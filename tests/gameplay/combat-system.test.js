import { describe, expect, it } from 'vitest';
import {
  COMBAT_ACTIONS,
  CombatSystem,
  PROVISIONAL_WEAPONS,
} from '../../src/gameplay/combat-system.js';
import { CollisionWorld } from '../../src/physics/collision-world.js';

const bounds = { x: 0, y: 0, width: 500, height: 240 };
const player = {
  body: { x: 10, y: 10, width: 20, height: 24 },
  facing: 1,
};

function createCombat(options = {}) {
  return new CombatSystem({
    collisionWorld: new CollisionWorld(),
    worldBounds: bounds,
    ...options,
  });
}

describe('CombatSystem weapon state', () => {
  it('starts with the first weapon and cycles through the configured arsenal', () => {
    const combat = createCombat();

    expect(combat.snapshot.activeWeaponId).toBe('pistola-crono');
    expect(combat.selectWeapon(1)).toBe(true);
    expect(combat.snapshot.activeWeaponId).toBe('triplice-prisma');
    expect(combat.cycleWeapon().id).toBe('laser-nexo');
    expect(combat.cycleWeapon().id).toBe('pistola-crono');
    expect(combat.selectWeaponById('laser-nexo')).toBe(true);
    expect(combat.selectWeaponById('missing')).toBe(false);
  });

  it('does not expose the internal spread-angle array', () => {
    const combat = createCombat();
    const weapon = combat.activeWeapon;
    weapon.spreadAnglesDeg[0] = 90;

    expect(combat.activeWeapon.spreadAnglesDeg).toEqual([0]);
  });

  it('rejects duplicate weapon ids and malformed weapon tuning', () => {
    expect(() => createCombat({
      weapons: [PROVISIONAL_WEAPONS[0], { ...PROVISIONAL_WEAPONS[0] }],
    })).toThrow('Identificador de arma duplicado');

    expect(() => createCombat({
      weapons: [{ ...PROVISIONAL_WEAPONS[0], spreadAnglesDeg: [Number.NaN] }],
    })).toThrow(TypeError);

    expect(() => createCombat({
      weapons: [{ ...PROVISIONAL_WEAPONS[0], maxActive: 0 }],
    })).toThrow(RangeError);
  });

  it('rejects invalid world bounds and constructor limits', () => {
    expect(() => createCombat({ worldBounds: { ...bounds, width: 0 } }))
      .toThrow(RangeError);
    expect(() => createCombat({ maxPlayerProjectiles: 0 })).toThrow(RangeError);
    expect(() => createCombat({ collisionWorld: {} })).toThrow(TypeError);
  });
});

describe('CombatSystem projectile weapons', () => {
  it('spawns a player projectile with the configured weapon data', () => {
    const combat = createCombat();
    const result = combat.tryFirePlayer(player);

    expect(result).toMatchObject({ fired: true, weaponId: 'pistola-crono' });
    expect(combat.snapshot.projectiles).toHaveLength(1);
    expect(combat.snapshot.projectiles[0]).toMatchObject({
      owner: 'player',
      weaponId: 'pistola-crono',
      damage: 1,
    });
  });

  it('fires continuously while FIRE remains held, respecting cooldown', () => {
    const combat = createCombat();
    const held = { pressed: [COMBAT_ACTIONS.FIRE], held: [COMBAT_ACTIONS.FIRE] };

    const first = combat.update(0.016, player, [], held);
    expect(first.firedWeaponId).toBe('pistola-crono');

    const blocked = combat.update(0.1, player, [], {
      pressed: [],
      held: [COMBAT_ACTIONS.FIRE],
    });
    expect(blocked.firedWeaponId).toBeNull();

    const second = combat.update(0.14, player, [], {
      pressed: [],
      held: [COMBAT_ACTIONS.FIRE],
    });
    expect(second.firedWeaponId).toBe('pistola-crono');
  });

  it('respects both per-weapon and global player projectile caps', () => {
    const weapon = {
      ...PROVISIONAL_WEAPONS[0],
      maxActive: 2,
      spreadAnglesDeg: [0, 0],
      cooldownSeconds: 0.01,
    };
    const combat = createCombat({ weapons: [weapon], maxPlayerProjectiles: 2 });

    expect(combat.tryFirePlayer(player).fired).toBe(true);
    combat.update(0.25, player);
    expect(combat.tryFirePlayer(player).fired).toBe(false);
    expect(combat.snapshot.projectiles).toHaveLength(2);
  });

  it('sweeps projectile movement so fast shots cannot pass through an enemy', () => {
    const combat = createCombat();
    const enemy = { id: 'drone-1', x: 65, y: 12, width: 18, height: 20, alive: true };

    combat.tryFirePlayer(player);
    const result = combat.update(0.1, player, [enemy]);

    expect(result.enemyHits).toContainEqual({
      enemyId: 'drone-1',
      damage: 1,
      weaponId: 'pistola-crono',
    });
    expect(combat.snapshot.projectiles).toHaveLength(0);
  });

  it('stops player projectiles at solid cover before they reach an enemy', () => {
    const world = new CollisionWorld([
      { id: 'cover', x: 60, y: 0, width: 10, height: 100 },
    ]);
    const combat = createCombat({ collisionWorld: world });
    const enemy = { id: 'guard-1', x: 100, y: 12, width: 20, height: 20, alive: true };

    combat.tryFirePlayer(player);
    const result = combat.update(0.1, player, [enemy]);

    expect(result.enemyHits).toHaveLength(0);
    expect(combat.snapshot.projectiles).toHaveLength(0);
  });

  it('discards projectiles after lifetime or world-bound expiration', () => {
    const weapon = { ...PROVISIONAL_WEAPONS[0], lifetimeSeconds: 0.02 };
    const combat = createCombat({ weapons: [weapon] });

    combat.tryFirePlayer(player);
    combat.update(0.03, player);
    expect(combat.snapshot.projectiles).toHaveLength(0);
  });
});

describe('CombatSystem Laser Nexo', () => {
  it('damages enemies in the unobstructed beam path', () => {
    const combat = createCombat();
    combat.selectWeapon(2);
    const enemy = { id: 'drone-2', x: 80, y: 12, width: 20, height: 20, alive: true };

    const result = combat.tryFirePlayer(player, [enemy]);

    expect(result.fired).toBe(true);
    expect(result.beamHits).toEqual([{
      enemyId: 'drone-2',
      damage: 2,
      weaponId: 'laser-nexo',
    }]);
  });

  it('does not hit enemies behind solid cover', () => {
    const world = new CollisionWorld([
      { id: 'wall', x: 60, y: 0, width: 12, height: 100 },
    ]);
    const combat = createCombat({ collisionWorld: world });
    combat.selectWeapon(2);
    const enemy = { id: 'drone-behind-wall', x: 90, y: 12, width: 20, height: 20, alive: true };

    const result = combat.tryFirePlayer(player, [enemy]);

    expect(result.beamHits).toHaveLength(0);
    expect(combat.snapshot.beams[0].width).toBeLessThan(40);
  });

  it('produces a zero-length non-damaging beam when cover blocks the muzzle', () => {
    const world = new CollisionWorld([
      { id: 'muzzle-cover', x: 32, y: 0, width: 12, height: 100 },
    ]);
    const combat = createCombat({ collisionWorld: world });
    combat.selectWeapon(2);
    const enemy = { id: 'nearby', x: 40, y: 12, width: 20, height: 20, alive: true };

    const result = combat.tryFirePlayer(player, [enemy]);

    expect(result.beamHits).toHaveLength(0);
    expect(combat.snapshot.beams[0].width).toBe(0);
  });

  it('keeps a newly fired beam alive for its full configured duration', () => {
    const combat = createCombat();
    combat.selectWeapon(2);

    const result = combat.update(0.016, player, [], {
      pressed: [COMBAT_ACTIONS.FIRE],
      held: [],
    });

    expect(result.firedWeaponId).toBe('laser-nexo');
    expect(result.combat.beams).toHaveLength(1);
    expect(result.combat.beams[0].remainingSeconds).toBeCloseTo(0.14);
  });
});

describe('CombatSystem enemy projectiles and health', () => {
  it('validates enemy projectile parameters before inserting them', () => {
    const combat = createCombat();

    expect(() => combat.spawnEnemyProjectile({
      x: Number.NaN, y: 0, vx: 10, vy: 0,
    })).toThrow(TypeError);
    expect(() => combat.spawnEnemyProjectile({
      x: 0, y: 0, vx: 10, vy: 0, width: 0,
    })).toThrow(RangeError);
    expect(() => combat.spawnEnemyProjectile({
      x: 0, y: 0, vx: 10, vy: 0, damage: 0,
    })).toThrow(RangeError);
  });

  it('caps enemy projectiles and applies damage with invulnerability frames', () => {
    const combat = createCombat({ maxEnemyProjectiles: 1 });
    expect(combat.spawnEnemyProjectile({
      x: 0, y: 15, vx: 200, vy: 0, width: 6, height: 6,
    })).not.toBeNull();
    expect(combat.spawnEnemyProjectile({
      x: 0, y: 15, vx: 200, vy: 0,
    })).toBeNull();

    const hit = combat.update(0.1, player);
    expect(hit.playerHit).toBe(true);
    expect(hit.combat.playerHealth).toBe(4);

    combat.spawnEnemyProjectile({ x: 0, y: 15, vx: 200, vy: 0, width: 6, height: 6 });
    const protectedHit = combat.update(0.1, player);
    expect(protectedHit.playerHit).toBe(false);
    expect(protectedHit.combat.playerHealth).toBe(4);
  });

  it('supports damage, healing, defeat and respawn', () => {
    const combat = createCombat({ maxPlayerHealth: 3, invulnerabilityDuration: 0 });
    expect(combat.damagePlayer(2).health).toBe(1);
    expect(combat.healPlayer(1).health).toBe(2);
    expect(combat.damagePlayer(5)).toMatchObject({ applied: true, defeated: true, health: 0 });
    expect(combat.healPlayer(1).applied).toBe(false);
    expect(combat.respawnPlayer().playerHealth).toBe(3);
    expect(combat.snapshot.invulnerable).toBe(false);
  });

  it('clears transient combat entities on reset and respawn', () => {
    const combat = createCombat();
    combat.tryFirePlayer(player);
    combat.update(0.25, player);
    combat.selectWeapon(2);
    combat.tryFirePlayer(player);
    expect(combat.snapshot.projectiles.length).toBeGreaterThan(0);
    expect(combat.snapshot.beams.length).toBeGreaterThan(0);

    combat.reset();
    expect(combat.snapshot.projectiles).toHaveLength(0);
    expect(combat.snapshot.beams).toHaveLength(0);
    expect(combat.snapshot.activeWeaponIndex).toBe(0);
  });
});

describe('CombatSystem input and validation', () => {
  it('switches weapons from discrete action presses', () => {
    const combat = createCombat();
    const result = combat.update(0.016, player, [], {
      pressed: [COMBAT_ACTIONS.WEAPON_3],
      held: [],
      released: [],
    });

    expect(result.weaponSwitched).toBe(true);
    expect(result.combat.activeWeaponId).toBe('laser-nexo');
  });

  it('rejects malformed input, enemy, player and timestep data', () => {
    const combat = createCombat();

    expect(() => combat.update(0, player)).toThrow(RangeError);
    expect(() => combat.update(0.016, {})).toThrow(TypeError);
    expect(() => combat.update(0.016, player, [], { pressed: 'fire' })).toThrow(TypeError);
    expect(() => combat.update(0.016, player, [{ id: 'broken', x: 0, y: 0, width: 0, height: 10 }]))
      .toThrow(RangeError);
    expect(() => combat.damagePlayer(0)).toThrow(RangeError);
  });
});
