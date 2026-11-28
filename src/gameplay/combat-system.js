import { aabbIntersects, validateAabb } from '../physics/aabb.js';

export const COMBAT_ACTIONS = Object.freeze({
  FIRE: 'fire',
  WEAPON_NEXT: 'weapon-next',
  WEAPON_1: 'weapon-1',
  WEAPON_2: 'weapon-2',
  WEAPON_3: 'weapon-3',
});

/**
 * Provisional W1-L2 blockout tuning. These values are implementation defaults,
 * not approved/canonized balance values. Production balance must be data-driven.
 */
export const PROVISIONAL_WEAPONS = Object.freeze([
  Object.freeze({
    id: 'pistola-crono',
    name: 'Pistola Crono',
    shortLabel: 'PISTOLA',
    kind: 'projectile',
    damage: 1,
    cooldownSeconds: 0.24,
    projectileSpeed: 520,
    projectileWidth: 14,
    projectileHeight: 6,
    lifetimeSeconds: 1.15,
    maxActive: 6,
    spreadAnglesDeg: Object.freeze([0]),
  }),
  Object.freeze({
    id: 'triplice-prisma',
    name: 'Tríplice Prisma',
    shortLabel: 'TRÍPLICE',
    kind: 'projectile',
    damage: 1,
    cooldownSeconds: 0.48,
    projectileSpeed: 440,
    projectileWidth: 11,
    projectileHeight: 7,
    lifetimeSeconds: 0.8,
    maxActive: 9,
    spreadAnglesDeg: Object.freeze([-12, 0, 12]),
  }),
  Object.freeze({
    id: 'laser-nexo',
    name: 'Laser Nexo',
    shortLabel: 'LASER',
    kind: 'beam',
    damage: 2,
    cooldownSeconds: 0.72,
    range: 340,
    beamHeight: 10,
    durationSeconds: 0.14,
    stepSize: 12,
  }),
]);

const EMPTY_INPUT_FRAME = Object.freeze({
  pressed: Object.freeze([]),
  released: Object.freeze([]),
  held: Object.freeze([]),
});
const MAX_PROJECTILE_SWEEP_STEPS = 1024;

function assertFinite(value, name) {
  if (!Number.isFinite(value)) {
    throw new TypeError(`${name} deve ser finito.`);
  }
}

function assertPositiveFinite(value, name) {
  assertFinite(value, name);
  if (value <= 0) throw new RangeError(`${name} deve ser maior que zero.`);
}

function assertNonNegativeFinite(value, name) {
  assertFinite(value, name);
  if (value < 0) throw new RangeError(`${name} não pode ser negativo.`);
}

function assertPositiveInteger(value, name) {
  if (!Number.isInteger(value) || value < 1) {
    throw new RangeError(`${name} deve ser um inteiro positivo.`);
  }
}

function validateWeapon(weapon, index) {
  const prefix = `weapons[${index}]`;
  if (!weapon || typeof weapon !== 'object' || Array.isArray(weapon)) {
    throw new TypeError(`${prefix} deve ser um objeto.`);
  }
  if (typeof weapon.id !== 'string' || weapon.id.trim() === '') {
    throw new TypeError(`${prefix}.id deve ser uma string não vazia.`);
  }
  if (typeof weapon.name !== 'string' || weapon.name.trim() === '') {
    throw new TypeError(`${prefix}.name deve ser uma string não vazia.`);
  }
  if (!['projectile', 'beam'].includes(weapon.kind)) {
    throw new RangeError(`Tipo de arma inválido em ${prefix}: ${weapon.kind}`);
  }

  assertPositiveFinite(weapon.damage, `${prefix}.damage`);
  assertPositiveFinite(weapon.cooldownSeconds, `${prefix}.cooldownSeconds`);

  if (weapon.kind === 'projectile') {
    assertPositiveFinite(weapon.projectileSpeed, `${prefix}.projectileSpeed`);
    assertPositiveFinite(weapon.projectileWidth, `${prefix}.projectileWidth`);
    assertPositiveFinite(weapon.projectileHeight, `${prefix}.projectileHeight`);
    assertPositiveFinite(weapon.lifetimeSeconds, `${prefix}.lifetimeSeconds`);
    assertPositiveInteger(weapon.maxActive, `${prefix}.maxActive`);
    if (!Array.isArray(weapon.spreadAnglesDeg) || weapon.spreadAnglesDeg.length === 0) {
      throw new TypeError(`${prefix}.spreadAnglesDeg deve ser um array não vazio.`);
    }
    for (const angle of weapon.spreadAnglesDeg) {
      assertFinite(angle, `${prefix}.spreadAnglesDeg[]`);
      if (angle < -180 || angle > 180) {
        throw new RangeError(`${prefix}.spreadAnglesDeg[] deve estar entre -180 e 180.`);
      }
    }
  } else {
    assertPositiveFinite(weapon.range, `${prefix}.range`);
    assertPositiveFinite(weapon.beamHeight, `${prefix}.beamHeight`);
    assertPositiveFinite(weapon.durationSeconds, `${prefix}.durationSeconds`);
    assertPositiveFinite(weapon.stepSize, `${prefix}.stepSize`);
  }
}

function cloneWeapon(weapon) {
  return {
    ...weapon,
    ...(weapon.spreadAnglesDeg
      ? { spreadAnglesDeg: [...weapon.spreadAnglesDeg] }
      : {}),
  };
}

function validateInputFrame(inputFrame) {
  if (!inputFrame || typeof inputFrame !== 'object') {
    throw new TypeError('inputFrame deve ser um objeto.');
  }
  for (const key of ['pressed', 'released', 'held']) {
    if (inputFrame[key] !== undefined && !Array.isArray(inputFrame[key])) {
      throw new TypeError(`inputFrame.${key} deve ser um array.`);
    }
  }
  return {
    pressed: inputFrame.pressed ?? [],
    released: inputFrame.released ?? [],
    held: inputFrame.held ?? [],
  };
}

function validateEnemyList(enemies) {
  if (!Array.isArray(enemies)) throw new TypeError('enemies deve ser um array.');
  for (const enemy of enemies) {
    if (!enemy || typeof enemy !== 'object') {
      throw new TypeError('Cada inimigo deve ser um objeto.');
    }
    if (enemy.alive === false) continue;
    if (enemy.id === undefined || enemy.id === null) {
      throw new TypeError('Cada inimigo ativo precisa de um id.');
    }
    validateAabb(enemy, `enemy ${enemy.id}`);
  }
}

function makeHit(enemyId, damage, weaponId) {
  return { enemyId, damage, weaponId };
}

/**
 * Domain-level combat simulation. It owns weapon state, projectiles, transient
 * beams and player health, but not enemy health, rendering, input devices,
 * animation, audio, persistence or scene orchestration.
 *
 * collisionWorld must implement overlapsSolid(AABB). Projectile movement uses
 * adaptive swept samples to avoid tunnelling at normal fixed-step game rates.
 */
export class CombatSystem {
  #collisionWorld;
  #worldBounds;
  #weapons;
  #weaponIndexById;
  #activeWeaponIndex = 0;
  #fireCooldown = 0;
  #projectiles = [];
  #beams = [];
  #nextEntityId = 1;
  #maxPlayerHealth;
  #playerHealth;
  #invulnerabilityDuration;
  #invulnerabilityRemaining = 0;
  #maxEnemyProjectiles;
  #maxPlayerProjectiles;

  constructor({
    collisionWorld,
    worldBounds,
    weapons = PROVISIONAL_WEAPONS,
    maxPlayerHealth = 5,
    invulnerabilityDuration = 0.9,
    maxEnemyProjectiles = 12,
    maxPlayerProjectiles = 24,
  }) {
    if (!collisionWorld || typeof collisionWorld.overlapsSolid !== 'function') {
      throw new TypeError('collisionWorld precisa implementar overlapsSolid().');
    }
    validateAabb(worldBounds, 'worldBounds');
    if (!Array.isArray(weapons) || weapons.length === 0) {
      throw new TypeError('weapons deve ser um array não vazio.');
    }
    assertPositiveInteger(maxPlayerHealth, 'maxPlayerHealth');
    assertNonNegativeFinite(invulnerabilityDuration, 'invulnerabilityDuration');
    assertPositiveInteger(maxEnemyProjectiles, 'maxEnemyProjectiles');
    assertPositiveInteger(maxPlayerProjectiles, 'maxPlayerProjectiles');

    const ids = new Set();
    weapons.forEach((weapon, index) => {
      validateWeapon(weapon, index);
      if (ids.has(weapon.id)) throw new Error(`Identificador de arma duplicado: ${weapon.id}`);
      ids.add(weapon.id);
    });

    this.#collisionWorld = collisionWorld;
    this.#worldBounds = { ...worldBounds };
    this.#weapons = weapons.map(cloneWeapon);
    this.#weaponIndexById = new Map(this.#weapons.map((weapon, index) => [weapon.id, index]));
    this.#maxPlayerHealth = maxPlayerHealth;
    this.#playerHealth = maxPlayerHealth;
    this.#invulnerabilityDuration = invulnerabilityDuration;
    this.#maxEnemyProjectiles = maxEnemyProjectiles;
    this.#maxPlayerProjectiles = maxPlayerProjectiles;
  }

  get activeWeapon() {
    return cloneWeapon(this.#weapons[this.#activeWeaponIndex]);
  }

  get activeWeaponIndex() {
    return this.#activeWeaponIndex;
  }

  get snapshot() {
    const active = this.#weapons[this.#activeWeaponIndex];
    return {
      activeWeaponIndex: this.#activeWeaponIndex,
      activeWeaponId: active.id,
      activeWeaponName: active.name,
      activeWeaponShortLabel: active.shortLabel ?? active.name,
      weaponCount: this.#weapons.length,
      fireCooldownRemaining: this.#fireCooldown,
      playerHealth: this.#playerHealth,
      maxPlayerHealth: this.#maxPlayerHealth,
      playerDefeated: this.#playerHealth === 0,
      invulnerable: this.#invulnerabilityRemaining > 0,
      invulnerabilityRemaining: this.#invulnerabilityRemaining,
      projectiles: this.#projectiles.map((item) => ({ ...item })),
      beams: this.#beams.map((beam) => ({ ...beam })),
    };
  }

  selectWeapon(index) {
    if (!Number.isInteger(index) || index < 0 || index >= this.#weapons.length) {
      throw new RangeError('Índice de arma fora do intervalo disponível.');
    }
    if (this.#activeWeaponIndex === index) return false;
    this.#activeWeaponIndex = index;
    return true;
  }

  selectWeaponById(id) {
    const index = this.#weaponIndexById.get(id);
    if (index === undefined) return false;
    this.selectWeapon(index);
    return true;
  }

  cycleWeapon() {
    this.#activeWeaponIndex = (this.#activeWeaponIndex + 1) % this.#weapons.length;
    return this.activeWeapon;
  }

  damagePlayer(amount = 1) {
    assertPositiveInteger(amount, 'amount de dano');
    if (this.#playerHealth === 0 || this.#invulnerabilityRemaining > 0) {
      return { applied: false, defeated: this.#playerHealth === 0, health: this.#playerHealth };
    }
    this.#playerHealth = Math.max(0, this.#playerHealth - amount);
    this.#invulnerabilityRemaining =
      this.#playerHealth > 0 ? this.#invulnerabilityDuration : 0;
    return { applied: true, defeated: this.#playerHealth === 0, health: this.#playerHealth };
  }

  healPlayer(amount = 1) {
    assertPositiveInteger(amount, 'amount de cura');
    if (this.#playerHealth === 0 || this.#playerHealth >= this.#maxPlayerHealth) {
      return { applied: false, health: this.#playerHealth };
    }
    this.#playerHealth = Math.min(this.#maxPlayerHealth, this.#playerHealth + amount);
    return { applied: true, health: this.#playerHealth };
  }

  respawnPlayer() {
    this.#playerHealth = this.#maxPlayerHealth;
    this.#invulnerabilityRemaining = this.#invulnerabilityDuration;
    this.#fireCooldown = 0;
    this.clearProjectiles();
    return this.snapshot;
  }

  clearProjectiles() {
    this.#projectiles.length = 0;
    this.#beams.length = 0;
  }

  reset() {
    this.#activeWeaponIndex = 0;
    this.#fireCooldown = 0;
    this.#playerHealth = this.#maxPlayerHealth;
    this.#invulnerabilityRemaining = 0;
    this.#nextEntityId = 1;
    this.clearProjectiles();
    return this.snapshot;
  }

  spawnEnemyProjectile({
    x,
    y,
    vx,
    vy,
    width = 10,
    height = 10,
    damage = 1,
    lifetimeSeconds = 2.4,
    sourceId = 'enemy',
  }) {
    assertFinite(x, 'enemyProjectile.x');
    assertFinite(y, 'enemyProjectile.y');
    assertFinite(vx, 'enemyProjectile.vx');
    assertFinite(vy, 'enemyProjectile.vy');
    assertPositiveFinite(width, 'enemyProjectile.width');
    assertPositiveFinite(height, 'enemyProjectile.height');
    assertPositiveInteger(damage, 'enemyProjectile.damage');
    assertPositiveFinite(lifetimeSeconds, 'enemyProjectile.lifetimeSeconds');
    if (typeof sourceId !== 'string' || sourceId.trim() === '') {
      throw new TypeError('enemyProjectile.sourceId deve ser uma string não vazia.');
    }

    const enemyCount = this.#projectiles.reduce(
      (total, item) => total + (item.owner === 'enemy' ? 1 : 0),
      0,
    );
    if (enemyCount >= this.#maxEnemyProjectiles) return null;

    const projectile = {
      id: `proj-${this.#nextEntityId++}`,
      owner: 'enemy',
      weaponId: 'enemy-bolt',
      sourceId,
      x,
      y,
      width,
      height,
      vx,
      vy,
      damage,
      remainingSeconds: lifetimeSeconds,
    };
    validateAabb(projectile, 'enemyProjectile');
    this.#projectiles.push(projectile);
    return { ...projectile };
  }

  tryFirePlayer(playerSnapshot, enemies = []) {
    if (!playerSnapshot?.body) throw new TypeError('playerSnapshot.body é obrigatório.');
    validateAabb(playerSnapshot.body, 'playerSnapshot.body');
    validateEnemyList(enemies);
    if (this.#playerHealth === 0 || this.#fireCooldown > 0) {
      return { fired: false, weaponId: this.#weapons[this.#activeWeaponIndex].id, beamHits: [] };
    }

    const weapon = this.#weapons[this.#activeWeaponIndex];
    const body = playerSnapshot.body;
    const facing = playerSnapshot.facing === -1 ? -1 : 1;
    const originX = facing > 0 ? body.x + body.width + 2 : body.x - 2;
    const originY = body.y + body.height * 0.42;

    if (weapon.kind === 'projectile') {
      const activeForWeapon = this.#projectiles.reduce(
        (total, item) =>
          total + (item.owner === 'player' && item.weaponId === weapon.id ? 1 : 0),
        0,
      );
      const count = weapon.spreadAnglesDeg.length;
      const totalPlayerProjectiles = this.#projectiles.reduce(
        (total, item) => total + (item.owner === 'player' ? 1 : 0),
        0,
      );
      if (
        activeForWeapon + count > weapon.maxActive ||
        totalPlayerProjectiles + count > this.#maxPlayerProjectiles
      ) {
        return { fired: false, weaponId: weapon.id, beamHits: [] };
      }

      for (const deg of weapon.spreadAnglesDeg) {
        const rad = (deg * Math.PI) / 180;
        const vx = Math.cos(rad) * weapon.projectileSpeed * facing;
        const vy = Math.sin(rad) * weapon.projectileSpeed;
        const spawnX = facing > 0 ? originX : originX - weapon.projectileWidth;
        const spawnY = originY - weapon.projectileHeight / 2;
        this.#projectiles.push({
          id: `proj-${this.#nextEntityId++}`,
          owner: 'player',
          weaponId: weapon.id,
          x: spawnX,
          y: spawnY,
          width: weapon.projectileWidth,
          height: weapon.projectileHeight,
          vx,
          vy,
          damage: weapon.damage,
          remainingSeconds: weapon.lifetimeSeconds,
        });
      }

      this.#fireCooldown = weapon.cooldownSeconds;
      return { fired: true, weaponId: weapon.id, beamHits: [] };
    }

    const beamY = originY - weapon.beamHeight / 2;
    let length = 0;
    for (let distance = 0; distance < weapon.range; ) {
      const segmentLength = Math.min(weapon.stepSize, weapon.range - distance);
      const probeX = facing > 0 ? originX + distance : originX - distance - segmentLength;
      const probe = {
        x: probeX,
        y: beamY,
        width: segmentLength,
        height: weapon.beamHeight,
      };
      if (!this.#isInsideBounds(probe) || this.#collisionWorld.overlapsSolid(probe)) break;
      length += segmentLength;
      distance += segmentLength;
    }

    const beamRect = {
      x: facing > 0 ? originX : originX - length,
      y: beamY,
      width: length,
      height: weapon.beamHeight,
    };
    const beamHits = [];
    if (length > 0) {
      for (const enemy of enemies) {
        if (enemy.alive === false) continue;
        if (aabbIntersects(beamRect, enemy)) {
          beamHits.push(makeHit(enemy.id, weapon.damage, weapon.id));
        }
      }
    }

    this.#beams.push({
      id: `beam-${this.#nextEntityId++}`,
      owner: 'player',
      weaponId: weapon.id,
      x: beamRect.x,
      y: beamRect.y,
      width: beamRect.width,
      height: beamRect.height,
      facing,
      remainingSeconds: weapon.durationSeconds,
      durationSeconds: weapon.durationSeconds,
    });
    this.#fireCooldown = weapon.cooldownSeconds;
    return { fired: true, weaponId: weapon.id, beamHits };
  }

  update(
    deltaSeconds,
    playerSnapshot,
    enemies = [],
    inputFrame = EMPTY_INPUT_FRAME,
  ) {
    assertPositiveFinite(deltaSeconds, 'deltaSeconds');
    if (!playerSnapshot?.body) throw new TypeError('playerSnapshot.body é obrigatório.');
    validateAabb(playerSnapshot.body, 'playerSnapshot.body');
    validateEnemyList(enemies);
    const input = validateInputFrame(inputFrame);

    this.#fireCooldown = Math.max(0, this.#fireCooldown - deltaSeconds);
    this.#invulnerabilityRemaining = Math.max(
      0,
      this.#invulnerabilityRemaining - deltaSeconds,
    );

    // Expire existing beams before processing input so a newly fired beam
    // retains its full configured duration during this simulation step.
    let beamWrite = 0;
    for (let i = 0; i < this.#beams.length; i += 1) {
      const beam = this.#beams[i];
      beam.remainingSeconds -= deltaSeconds;
      if (beam.remainingSeconds > 0) {
        this.#beams[beamWrite++] = beam;
      }
    }
    this.#beams.length = beamWrite;

    let weaponSwitched = false;
    if (input.pressed.includes(COMBAT_ACTIONS.WEAPON_1) && this.#weapons.length >= 1) {
      weaponSwitched = this.selectWeapon(0) || weaponSwitched;
    } else if (input.pressed.includes(COMBAT_ACTIONS.WEAPON_2) && this.#weapons.length >= 2) {
      weaponSwitched = this.selectWeapon(1) || weaponSwitched;
    } else if (input.pressed.includes(COMBAT_ACTIONS.WEAPON_3) && this.#weapons.length >= 3) {
      weaponSwitched = this.selectWeapon(2) || weaponSwitched;
    } else if (input.pressed.includes(COMBAT_ACTIONS.WEAPON_NEXT)) {
      this.cycleWeapon();
      weaponSwitched = true;
    }

    const enemyHits = [];
    let playerHit = false;
    let firedWeaponId = null;
    if (
      input.pressed.includes(COMBAT_ACTIONS.FIRE) ||
      input.held.includes(COMBAT_ACTIONS.FIRE)
    ) {
      const fireResult = this.tryFirePlayer(playerSnapshot, enemies);
      if (fireResult.fired) {
        firedWeaponId = fireResult.weaponId;
        enemyHits.push(...fireResult.beamHits);
      }
    }

    let projectileWrite = 0;
    for (let i = 0; i < this.#projectiles.length; i += 1) {
      const projectile = this.#projectiles[i];
      projectile.remainingSeconds -= deltaSeconds;
      if (projectile.remainingSeconds <= 0) continue;

      const movement = this.#sweepProjectile(projectile, deltaSeconds, enemies, playerSnapshot.body);
      if (!movement.alive) {
        if (movement.hit) {
          if (projectile.owner === 'player') enemyHits.push(movement.hit);
          else {
            const result = this.damagePlayer(projectile.damage);
            if (result.applied) playerHit = true;
          }
        }
        continue;
      }
      this.#projectiles[projectileWrite++] = projectile;
    }
    this.#projectiles.length = projectileWrite;

    return {
      weaponSwitched,
      firedWeaponId,
      enemyHits,
      playerHit,
      playerDefeated: this.#playerHealth === 0,
      combat: this.snapshot,
    };
  }

  #sweepProjectile(projectile, deltaSeconds, enemies, playerBody) {
    const startX = projectile.x;
    const startY = projectile.y;
    const deltaX = projectile.vx * deltaSeconds;
    const deltaY = projectile.vy * deltaSeconds;
    const maxDistance = Math.max(Math.abs(deltaX), Math.abs(deltaY));
    const maxStep = Math.max(1, Math.min(projectile.width, projectile.height) * 0.5);
    const steps = Math.max(1, Math.ceil(maxDistance / maxStep));

    // An abnormal delta/velocity must not create an unbounded loop on mobile.
    // Such a projectile is discarded; the fixed-step runtime should normally
    // keep this path far below the cap.
    if (steps > MAX_PROJECTILE_SWEEP_STEPS) {
      return { alive: false, hit: null };
    }

    for (let step = 1; step <= steps; step += 1) {
      const progress = step / steps;
      projectile.x = startX + deltaX * progress;
      projectile.y = startY + deltaY * progress;

      if (!this.#isInsideBounds(projectile) || this.#collisionWorld.overlapsSolid(projectile)) {
        return { alive: false, hit: null };
      }

      if (projectile.owner === 'player') {
        for (const enemy of enemies) {
          if (enemy.alive === false) continue;
          if (aabbIntersects(projectile, enemy)) {
            return {
              alive: false,
              hit: makeHit(enemy.id, projectile.damage, projectile.weaponId),
            };
          }
        }
      } else if (aabbIntersects(projectile, playerBody)) {
        return { alive: false, hit: true };
      }
    }

    return { alive: true, hit: null };
  }

  #isInsideBounds(rect) {
    return (
      rect.x >= this.#worldBounds.x &&
      rect.y >= this.#worldBounds.y &&
      rect.x + rect.width <= this.#worldBounds.x + this.#worldBounds.width &&
      rect.y + rect.height <= this.#worldBounds.y + this.#worldBounds.height
    );
  }
}
