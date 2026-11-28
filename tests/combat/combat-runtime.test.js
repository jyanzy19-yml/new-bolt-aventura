import { describe, expect, it } from 'vitest';
import { CollisionWorld } from '../../src/physics/collision-world.js';
import { HealthComponent } from '../../src/combat/health-component.js';
import { CombatRuntime } from '../../src/combat/combat-runtime.js';

function makeWeapon(overrides = {}) {
  return {
    id: 'chrono-pistol',
    fireMode: 'automatic',
    cooldownSeconds: 0.1,
    muzzleOffsetX: 0,
    muzzleOffsetY: 0,
    projectile: {
      width: 4,
      height: 4,
      speed: 1000,
      damage: 2,
      lifetimeSeconds: 1,
    },
    ...overrides,
  };
}

function createRuntime({
  collisionWorld = new CollisionWorld(),
  maxActiveProjectiles = 8,
  weapons = [makeWeapon()],
} = {}) {
  return new CombatRuntime({
    weapons,
    initialWeaponId: weapons[0].id,
    maxActiveProjectiles,
    collisionWorld,
  });
}

function shooter() {
  return {
    body: { x: 0, y: 0, width: 10, height: 10 },
    ownerId: 'bolt',
    team: 'player',
    facing: 1,
  };
}

function inputFrame(held = []) {
  return { pressed: held, released: [], held };
}

function target(overrides = {}) {
  return {
    id: 'enemy',
    team: 'enemy',
    body: { x: 50, y: 0, width: 10, height: 10 },
    health: new HealthComponent({ maxHealth: 5 }),
    ...overrides,
  };
}

describe('CombatRuntime', () => {
  it('integrates weapon firing, projectile movement and damage in one fixed step', () => {
    const runtime = createRuntime();
    const enemy = target();

    const result = runtime.update(0.1, {
      inputFrame: inputFrame(['fire']),
      shooter: shooter(),
      targets: [enemy],
    });

    expect(result.weaponResult.fired).toBe(true);
    expect(result.projectileEvents).toEqual([
      {
        type: 'hit',
        projectileId: 'chrono-pistol-shot-1',
        targetId: 'enemy',
        appliedDamage: 2,
        remainingHealth: 3,
        targetDefeated: false,
      },
    ]);
    expect(enemy.health.currentHealth).toBe(3);
    expect(result.activeProjectileCount).toBe(0);
  });

  it('keeps projectiles active when no target is intersected', () => {
    const runtime = createRuntime();

    const result = runtime.update(0.1, {
      inputFrame: inputFrame(['fire']),
      shooter: shooter(),
      targets: [],
    });

    expect(result.projectileEvents).toEqual([]);
    expect(result.activeProjectileCount).toBe(1);
    expect(runtime.activeProjectiles[0].x).toBeGreaterThan(10);
  });

  it('resolves static-world impact and removes the projectile', () => {
    const runtime = createRuntime({
      collisionWorld: new CollisionWorld([
        { id: 'wall', x: 20, y: -10, width: 10, height: 40 },
      ]),
    });

    const result = runtime.update(0.1, {
      inputFrame: inputFrame(['fire']),
      shooter: shooter(),
    });

    expect(result.projectileEvents).toEqual([
      { type: 'world-impact', projectileId: 'chrono-pistol-shot-1' },
    ]);
    expect(result.activeProjectileCount).toBe(0);
  });

  it('respects projectile capacity and clears transient state', () => {
    const runtime = createRuntime({ maxActiveProjectiles: 1 });

    const first = runtime.update(0.01, {
      inputFrame: inputFrame(['fire']),
      shooter: shooter(),
    });
    expect(first.activeProjectileCount).toBe(1);

    runtime.selectWeapon('chrono-pistol');
    const second = runtime.update(0.2, {
      inputFrame: inputFrame(['fire']),
      shooter: shooter(),
    });
    expect(second.weaponResult.reason).toBe('capacity');
    expect(runtime.clearTransientProjectiles()).toBe(1);
    expect(runtime.clearTransientProjectiles()).toBe(0);
    expect(runtime.activeProjectileCount).toBe(0);
  });

  it('rejects invalid world, capacity, delta and target collection', () => {
    expect(() => createRuntime({ maxActiveProjectiles: 0 })).toThrow(RangeError);
    expect(() => new CombatRuntime({
      weapons: [makeWeapon()],
      initialWeaponId: 'chrono-pistol',
      maxActiveProjectiles: 4,
      collisionWorld: null,
    })).toThrow(TypeError);

    const runtime = createRuntime();
    expect(() => runtime.update(0, {
      inputFrame: inputFrame(),
      shooter: shooter(),
    })).toThrow(RangeError);
    expect(() => runtime.update(0.1, {
      inputFrame: inputFrame(),
      shooter: shooter(),
      targets: {},
    })).toThrow(TypeError);
  });
});
