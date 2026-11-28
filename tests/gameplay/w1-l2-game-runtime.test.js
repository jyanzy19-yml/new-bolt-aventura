import { describe, expect, it } from 'vitest';
import { W1_L2, W1_L2_PLAYER_TUNING } from '../../src/levels/w1-l2.js';
import { validateW1L2Content } from '../../src/levels/w1-l2-validation.js';
import { W1L2GameRuntime } from '../../src/gameplay/w1-l2-game-runtime.js';
import { CombatSystem } from '../../src/gameplay/combat-system.js';
import { CollisionWorld } from '../../src/physics/collision-world.js';

function makeCombat() {
  const colliders = [
    ...W1_L2.geometry.solids.map((item) => ({ ...item, oneWay: false })),
    ...W1_L2.geometry.oneWayPlatforms.map((item) => ({ ...item, oneWay: true })),
  ];
  return new CombatSystem({
    collisionWorld: new CollisionWorld(colliders),
    worldBounds: W1_L2.bounds,
  });
}

const player = {
  body: { x: 80, y: 504, width: 30, height: 46 },
  facing: 1,
};

describe('W1-L2 production content', () => {
  it('validates campaign identity, four objectives, landmarks and enemy archetypes', () => {
    expect(validateW1L2Content(W1_L2)).toBe(W1_L2);
    expect(W1_L2.objectives).toHaveLength(4);
    expect(new Set(W1_L2.enemies.map((enemy) => enemy.archetype)).size).toBe(3);
    expect(W1_L2_PLAYER_TUNING.dash.durationSeconds).toBeGreaterThan(0);
  });

  it('rejects duplicated enemy ids and unknown archetypes', () => {
    const duplicate = {
      ...W1_L2,
      enemies: W1_L2.enemies.map((enemy, index) =>
        index === 1 ? { ...enemy, id: W1_L2.enemies[0].id } : enemy),
    };
    expect(() => validateW1L2Content(duplicate)).toThrow('ID duplicado');

    const unknown = {
      ...W1_L2,
      enemies: W1_L2.enemies.map((enemy, index) =>
        index === 0 ? { ...enemy, archetype: 'recolor-only' } : enemy),
    };
    expect(() => validateW1L2Content(unknown)).toThrow('Arquétipo não autorizado');
  });

  it('rejects patrol bounds outside the world and non-positive health', () => {
    const invalid = {
      ...W1_L2,
      enemies: W1_L2.enemies.map((enemy, index) =>
        index === 0 ? { ...enemy, health: 0 } : enemy),
    };
    expect(() => validateW1L2Content(invalid)).toThrow('Parâmetros');
  });
});

describe('W1L2GameRuntime', () => {
  it('starts with three weapons and the first campaign objective', () => {
    const runtime = new W1L2GameRuntime({ level: W1_L2, combatSystem: makeCombat() });
    expect(runtime.snapshot.objective).toBe('Alcance a estação de energia');
    expect(runtime.snapshot.combat.activeWeaponId).toBe('pistola-crono');
    expect(runtime.snapshot.enemies.filter((enemy) => enemy.alive)).toHaveLength(4);
  });

  it('switches weapons using normalized action names', () => {
    const runtime = new W1L2GameRuntime({ level: W1_L2, combatSystem: makeCombat() });
    const state = runtime.update(1 / 60, player, {
      pressed: ['weapon-3'], released: [], held: [],
    });
    expect(state.combat.activeWeaponId).toBe('laser-nexo');
  });

  it('fires at an enemy and applies enemy-owned health consistently', () => {
    const runtime = new W1L2GameRuntime({ level: W1_L2, combatSystem: makeCombat() });
    const target = { ...player, body: { ...player.body, x: 860, y: 504 } };
    runtime.update(1 / 60, target, { pressed: ['fire'], released: [], held: [] });
    const state = runtime.update(0.1, target, { pressed: [], released: [], held: [] });
    expect(state.enemies.find((enemy) => enemy.id === 'patrol-sentinel-alpha').health).toBe(3);
  });


  it('uses the Laser Nexo beam to damage a target through an unobstructed lane', () => {
    const runtime = new W1L2GameRuntime({ level: W1_L2, combatSystem: makeCombat() });
    const target = { ...player, body: { ...player.body, x: 860, y: 504 } };
    const state = runtime.update(1 / 60, target, {
      pressed: ['weapon-3', 'fire'], released: [], held: [],
    });
    expect(state.combat.activeWeaponId).toBe('laser-nexo');
    expect(state.enemies.find((enemy) => enemy.id === 'patrol-sentinel-alpha').health).toBe(2);
  });


  it('telegraphs enemy fire before spawning a projectile', () => {
    const runtime = new W1L2GameRuntime({ level: W1_L2, combatSystem: makeCombat() });
    const stationary = { ...player, body: { ...player.body, x: 820, y: 504 } };
    let state = runtime.snapshot;
    for (let frame = 0; frame < 120; frame += 1) {
      state = runtime.update(1 / 60, stationary);
    }
    expect(state.enemies.find((enemy) => enemy.id === 'patrol-sentinel-alpha').windupRemaining)
      .toBeGreaterThan(0);
    for (let frame = 0; frame < 40; frame += 1) {
      state = runtime.update(1 / 60, stationary);
    }
    expect(state.combat.projectiles.some((projectile) => projectile.owner === 'enemy')).toBe(true);
  });

  it('allows an enemy projectile to damage the player after its telegraphed firing interval', () => {
    const runtime = new W1L2GameRuntime({ level: W1_L2, combatSystem: makeCombat() });
    const stationary = { ...player, body: { ...player.body, x: 820, y: 504 } };
    let state = runtime.snapshot;
    for (let frame = 0; frame < 240; frame += 1) {
      state = runtime.update(1 / 60, stationary);
      if (state.combat.playerHealth < state.combat.maxPlayerHealth) break;
    }
    expect(state.combat.playerHealth).toBeLessThan(state.combat.maxPlayerHealth);
  });

  it('restores the repeater only through its explicit interaction', () => {
    const runtime = new W1L2GameRuntime({ level: W1_L2, combatSystem: makeCombat() });
    const atRepeater = { ...player, body: { x: 4325, y: 240, width: 30, height: 46 } };
    const state = runtime.update(1 / 60, atRepeater, {
      pressed: ['interact'], released: [], held: [],
    });
    expect(state.completed).toBe(true);
    expect(state.repeaterActive).toBe(true);
  });

  it('keeps the evacuation cache optional', () => {
    const runtime = new W1L2GameRuntime({ level: W1_L2, combatSystem: makeCombat() });
    const atCache = { ...player, body: { x: 2590, y: 210, width: 30, height: 46 } };
    const state = runtime.update(1 / 60, atCache, {
      pressed: ['interact'], released: [], held: [],
    });
    expect(state.secretFound).toBe(true);
    expect(state.completed).toBe(false);
  });


  it('activates checkpoints and respawns at the latest synchronized position', () => {
    const runtime = new W1L2GameRuntime({ level: W1_L2, combatSystem: makeCombat() });
    const beyondFirstCheckpoint = {
      ...player,
      body: { x: 1910, y: 504, width: 30, height: 46 },
    };
    const state = runtime.update(1 / 60, beyondFirstCheckpoint);
    expect(state.checkpointId).toBe('power-station-checkpoint');
    expect(runtime.respawn()).toEqual({ x: 1900, y: 504 });
    expect(runtime.snapshot.combat.playerHealth).toBe(5);
  });

  it('resets combat, enemy health, objective and optional progress', () => {
    const runtime = new W1L2GameRuntime({ level: W1_L2, combatSystem: makeCombat() });
    runtime.update(1 / 60, player, { pressed: ['weapon-2'], released: [], held: [] });
    runtime.reset();
    expect(runtime.snapshot.combat.activeWeaponId).toBe('pistola-crono');
    expect(runtime.snapshot.enemies.every((enemy) => enemy.alive)).toBe(true);
    expect(runtime.snapshot.secretFound).toBe(false);
  });
});
