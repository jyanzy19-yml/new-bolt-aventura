import { describe, expect, it } from 'vitest';
import { CollisionWorld } from '../../src/physics/collision-world.js';
import { HealthComponent } from '../../src/combat/health-component.js';
import { ProjectileSystem } from '../../src/combat/projectile-system.js';

function createSystem(maxActiveProjectiles = 10) {
  return new ProjectileSystem({ maxActiveProjectiles });
}

function spawnDefaults(overrides = {}) {
  return {
    id: 'shot-01',
    ownerId: 'player',
    team: 'player',
    x: 0,
    y: 0,
    width: 4,
    height: 4,
    vx: 100,
    vy: 0,
    damage: 2,
    lifetimeSeconds: 2,
    ...overrides,
  };
}

function createTarget(overrides = {}) {
  return {
    id: 'enemy-01',
    team: 'enemy',
    body: { x: 50, y: 0, width: 10, height: 10 },
    health: new HealthComponent({ maxHealth: 5 }),
    ...overrides,
  };
}

describe('ProjectileSystem', () => {
  it('moves projectiles and expires them at their configured lifetime', () => {
    const system = createSystem();
    const world = new CollisionWorld();

    system.spawn(spawnDefaults({ vx: 10, lifetimeSeconds: 0.15 }));
    expect(system.update(0.1, { collisionWorld: world })).toEqual([]);
    expect(system.activeProjectiles[0].x).toBe(1);

    expect(system.update(0.1, { collisionWorld: world })).toEqual([
      { type: 'expired', projectileId: 'shot-01' },
    ]);
    expect(system.activeCount).toBe(0);
  });

  it('uses swept AABB to hit a target between simulation positions', () => {
    const system = createSystem();
    const world = new CollisionWorld();
    const target = createTarget();

    system.spawn(spawnDefaults({ vx: 1000 }));
    const events = system.update(0.1, {
      collisionWorld: world,
      targets: [target],
    });

    expect(events).toEqual([
      {
        type: 'hit',
        projectileId: 'shot-01',
        targetId: 'enemy-01',
        appliedDamage: 2,
        remainingHealth: 3,
        targetDefeated: false,
      },
    ]);
    expect(target.health.currentHealth).toBe(3);
    expect(system.activeCount).toBe(0);
  });

  it('ignores the owner and same-team targets', () => {
    const system = createSystem();
    const world = new CollisionWorld();
    const owner = createTarget({
      id: 'player',
      team: 'player',
      body: { x: 0, y: 0, width: 10, height: 10 },
    });
    const ally = createTarget({
      id: 'ally',
      team: 'player',
      body: { x: 40, y: 0, width: 10, height: 10 },
    });

    system.spawn(spawnDefaults({ vx: 100 }));
    expect(
      system.update(0.1, { collisionWorld: world, targets: [owner, ally] }),
    ).toEqual([]);
    expect(system.activeCount).toBe(1);
  });

  it('removes projectiles on static world impact', () => {
    const system = createSystem();
    const world = new CollisionWorld([
      { id: 'wall', x: 20, y: -10, width: 10, height: 40 },
    ]);

    system.spawn(spawnDefaults({ vx: 1000 }));
    expect(system.update(0.1, { collisionWorld: world })).toEqual([
      { type: 'world-impact', projectileId: 'shot-01' },
    ]);
    expect(system.activeCount).toBe(0);
  });

  it('enforces active projectile budget and unique ids', () => {
    const system = createSystem(1);

    expect(system.spawn(spawnDefaults())).toBe(true);
    expect(system.spawn(spawnDefaults({ id: 'shot-02' }))).toBe(false);
    expect(() => system.spawn(spawnDefaults())).toThrow('Projétil duplicado');
  });

  it('clears transient projectiles on scene transition', () => {
    const system = createSystem();
    system.spawn(spawnDefaults());
    expect(system.clear()).toBe(1);
    expect(system.activeCount).toBe(0);
  });

  it('rejects invalid projectile and update data', () => {
    const system = createSystem();
    const world = new CollisionWorld();

    expect(() => system.spawn(spawnDefaults({ damage: 0 }))).toThrow(RangeError);
    expect(() => system.spawn(spawnDefaults({ vx: Number.NaN }))).toThrow(TypeError);
    expect(() => system.update(0, { collisionWorld: world })).toThrow(RangeError);
  });
});
