import { describe, expect, it } from 'vitest';
import { ProjectileSystem } from '../../src/combat/projectile-system.js';
import {
  WEAPON_ACTIONS,
  WeaponController,
} from '../../src/combat/weapon-controller.js';

const FIRE = WEAPON_ACTIONS.FIRE;

function weapon(overrides = {}) {
  return {
    id: 'chrono-pistol',
    fireMode: 'automatic',
    cooldownSeconds: 0.2,
    muzzleOffsetX: 12,
    muzzleOffsetY: 0,
    projectile: {
      width: 6,
      height: 4,
      speed: 100,
      damage: 1,
      lifetimeSeconds: 2,
    },
    ...overrides,
  };
}

function createController({
  weapons = [weapon()],
  maxProjectiles = 10,
  initialWeaponId = weapons[0].id,
} = {}) {
  return new WeaponController({
    projectileSystem: new ProjectileSystem({ maxActiveProjectiles: maxProjectiles }),
    weapons,
    initialWeaponId,
  });
}

function shooter(overrides = {}) {
  return {
    body: { x: 10, y: 20, width: 30, height: 40 },
    ownerId: 'bolt',
    team: 'player',
    facing: 1,
    ...overrides,
  };
}

function inputFrame({ pressed = [], held = [] } = {}) {
  return { pressed, held };
}

describe('WeaponController', () => {
  it('fires an automatic weapon while the fire action is held', () => {
    const controller = createController();

    const result = controller.update(0.016, {
      inputFrame: inputFrame({ held: [FIRE] }),
      shooter: shooter(),
    });

    expect(result).toMatchObject({
      fired: true,
      reason: 'fired',
      weaponId: 'chrono-pistol',
      projectileId: 'chrono-pistol-shot-1',
    });
    expect(result.direction).toEqual({ x: 1, y: 0 });
    expect(controller.cooldownRemaining).toBe(0.2);
  });

  it('enforces deterministic cooldown before the next automatic shot', () => {
    const controller = createController();
    const request = {
      inputFrame: inputFrame({ held: [FIRE] }),
      shooter: shooter(),
    };

    expect(controller.update(0.016, request).fired).toBe(true);
    expect(controller.update(0.1, request).reason).toBe('cooldown');
    expect(controller.update(0.1, request).fired).toBe(true);
  });

  it('requires a pressed edge for semi-automatic fire', () => {
    const controller = createController({
      weapons: [weapon({ id: 'precision-shot', fireMode: 'semi-automatic' })],
      initialWeaponId: 'precision-shot',
    });
    const request = {
      shooter: shooter(),
      inputFrame: inputFrame({ held: [FIRE] }),
    };

    expect(controller.update(0.016, request).reason).toBe('not-requested');
    expect(controller.update(0.016, {
      ...request,
      inputFrame: inputFrame({ pressed: [FIRE] }),
    }).fired).toBe(true);
  });

  it('normalizes aim and applies muzzle offsets in shooter-local facing space', () => {
    const controller = createController();
    const result = controller.update(0.016, {
      inputFrame: inputFrame({ held: [FIRE] }),
      shooter: shooter({ facing: -1 }),
      aim: { x: 3, y: 4 },
    });

    expect(result.direction).toEqual({ x: 0.6, y: 0.8 });
    expect(result.fired).toBe(true);
  });

  it('switches only to known weapons without resetting the active cooldown', () => {
    const controller = createController({
      weapons: [
        weapon(),
        weapon({
          id: 'triple-shot',
          fireMode: 'semi-automatic',
          cooldownSeconds: 0.4,
        }),
      ],
    });

    controller.update(0.016, {
      inputFrame: inputFrame({ held: [FIRE] }),
      shooter: shooter(),
    });

    expect(controller.selectWeapon('missing')).toBe(false);
    expect(controller.selectWeapon('triple-shot')).toBe(true);
    expect(controller.activeWeaponId).toBe('triple-shot');
    expect(controller.cooldownRemaining).toBe(0.2);
  });

  it('does not consume cooldown or sequence when projectile capacity is full', () => {
    const projectileSystem = new ProjectileSystem({ maxActiveProjectiles: 1 });
    projectileSystem.spawn({
      id: 'occupying-shot',
      ownerId: 'other',
      team: 'enemy',
      x: 0,
      y: 0,
      width: 4,
      height: 4,
      vx: 1,
      vy: 0,
      damage: 1,
      lifetimeSeconds: 2,
    });
    const controller = new WeaponController({
      projectileSystem,
      weapons: [weapon()],
      initialWeaponId: 'chrono-pistol',
    });

    const result = controller.update(0.016, {
      inputFrame: inputFrame({ held: [FIRE] }),
      shooter: shooter(),
    });

    expect(result.reason).toBe('capacity');
    expect(controller.cooldownRemaining).toBe(0);
  });

  it('rejects invalid catalog entries, aim and shooter data', () => {
    const invalid = weapon({ cooldownSeconds: -1 });
    expect(() => createController({ weapons: [invalid] })).toThrow(RangeError);

    const controller = createController();
    expect(() => controller.update(0.016, {
      inputFrame: inputFrame({ held: [FIRE] }),
      shooter: shooter(),
      aim: { x: 0, y: 0 },
    })).toThrow(RangeError);
    expect(() => controller.update(0.016, {
      inputFrame: inputFrame(),
      shooter: shooter({ facing: 0 }),
    })).toThrow(RangeError);
  });
});
