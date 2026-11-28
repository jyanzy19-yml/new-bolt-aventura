import { validateAabb } from '../physics/aabb.js';

export const WEAPON_ACTIONS = Object.freeze({
  FIRE: 'fire',
});

const WEAPON_ID_PATTERN = /^[a-z][a-z0-9]*(?:-[a-z0-9]+)*$/;

function assertText(value, name) {
  if (typeof value !== 'string' || value.trim() === '') {
    throw new TypeError(`${name} deve ser uma string não vazia.`);
  }
}

function assertFinite(value, name) {
  if (!Number.isFinite(value)) {
    throw new TypeError(`${name} deve ser finito.`);
  }
}

function assertPositive(value, name) {
  assertFinite(value, name);
  if (value <= 0) throw new RangeError(`${name} deve ser maior que zero.`);
}

function validateWeapon(weapon) {
  if (!weapon || typeof weapon !== 'object') {
    throw new TypeError('Cada weapon deve ser um objeto.');
  }
  assertText(weapon.id, 'weapon.id');
  if (!WEAPON_ID_PATTERN.test(weapon.id)) {
    throw new TypeError('weapon.id deve usar kebab-case estável.');
  }
  if (!['automatic', 'semi-automatic'].includes(weapon.fireMode)) {
    throw new TypeError('fireMode deve ser automatic ou semi-automatic.');
  }
  assertFinite(weapon.cooldownSeconds, 'cooldownSeconds');
  if (weapon.cooldownSeconds < 0) {
    throw new RangeError('cooldownSeconds não pode ser negativo.');
  }
  assertFinite(weapon.muzzleOffsetX, 'muzzleOffsetX');
  assertFinite(weapon.muzzleOffsetY, 'muzzleOffsetY');

  if (!weapon.projectile || typeof weapon.projectile !== 'object') {
    throw new TypeError('weapon.projectile é obrigatório.');
  }
  for (const key of ['width', 'height', 'speed', 'damage', 'lifetimeSeconds']) {
    assertPositive(weapon.projectile[key], `projectile.${key}`);
  }
}

function readInput(inputFrame) {
  if (!inputFrame || !Array.isArray(inputFrame.pressed) || !Array.isArray(inputFrame.held)) {
    throw new TypeError('inputFrame precisa conter arrays pressed e held.');
  }
  return {
    pressed: new Set(inputFrame.pressed),
    held: new Set(inputFrame.held),
  };
}

function resolveDirection(aim, facing) {
  if (aim === null || aim === undefined) return { x: facing, y: 0 };
  if (!aim || typeof aim !== 'object') {
    throw new TypeError('aim deve ser um vetor ou null.');
  }
  assertFinite(aim.x, 'aim.x');
  assertFinite(aim.y, 'aim.y');

  const magnitude = Math.hypot(aim.x, aim.y);
  if (magnitude <= Number.EPSILON) {
    throw new RangeError('aim não pode ser um vetor nulo.');
  }

  return {
    x: aim.x / magnitude,
    y: aim.y / magnitude,
  };
}

/**
 * Data-driven weapon firing. Weapon balance and catalogue are injected; this
 * controller owns only selection, trigger semantics, cooldown and projectile
 * creation. It does not decide which weapons are canon.
 */
export class WeaponController {
  #projectileSystem;
  #weapons = new Map();
  #activeWeaponId;
  #cooldownRemaining = 0;
  #shotSequence = 0;

  constructor({ projectileSystem, weapons, initialWeaponId }) {
    if (!projectileSystem || typeof projectileSystem.spawn !== 'function') {
      throw new TypeError('projectileSystem precisa implementar spawn().');
    }
    if (!Array.isArray(weapons) || weapons.length === 0) {
      throw new TypeError('weapons deve ser um array não vazio.');
    }

    for (const weapon of weapons) {
      validateWeapon(weapon);
      if (this.#weapons.has(weapon.id)) {
        throw new Error(`Arma duplicada: ${weapon.id}`);
      }
      this.#weapons.set(weapon.id, Object.freeze({
        ...weapon,
        projectile: Object.freeze({ ...weapon.projectile }),
      }));
    }

    if (!this.#weapons.has(initialWeaponId)) {
      throw new RangeError('initialWeaponId não existe no catálogo.');
    }

    this.#projectileSystem = projectileSystem;
    this.#activeWeaponId = initialWeaponId;
  }

  get activeWeaponId() {
    return this.#activeWeaponId;
  }

  get cooldownRemaining() {
    return this.#cooldownRemaining;
  }

  selectWeapon(weaponId) {
    if (!this.#weapons.has(weaponId)) return false;
    this.#activeWeaponId = weaponId;
    return true;
  }

  update(deltaSeconds, { inputFrame, shooter, aim = null }) {
    assertPositive(deltaSeconds, 'deltaSeconds');
    const input = readInput(inputFrame);
    if (!shooter || typeof shooter !== 'object') {
      throw new TypeError('shooter é obrigatório.');
    }
    validateAabb(shooter.body, 'shooter.body');
    assertText(shooter.ownerId, 'shooter.ownerId');
    assertText(shooter.team, 'shooter.team');
    if (shooter.facing !== -1 && shooter.facing !== 1) {
      throw new RangeError('shooter.facing deve ser -1 ou 1.');
    }

    this.#cooldownRemaining = Math.max(
      0,
      this.#cooldownRemaining - deltaSeconds,
    );

    const weapon = this.#weapons.get(this.#activeWeaponId);
    const triggerRequested = weapon.fireMode === 'automatic'
      ? input.held.has(WEAPON_ACTIONS.FIRE)
      : input.pressed.has(WEAPON_ACTIONS.FIRE);

    if (!triggerRequested) {
      return { fired: false, reason: 'not-requested', weaponId: weapon.id };
    }
    if (this.#cooldownRemaining > 0) {
      return { fired: false, reason: 'cooldown', weaponId: weapon.id };
    }

    const direction = resolveDirection(aim, shooter.facing);
    const projectile = weapon.projectile;
    const muzzleX =
      shooter.body.x +
      shooter.body.width / 2 +
      weapon.muzzleOffsetX * shooter.facing;
    const muzzleY =
      shooter.body.y +
      shooter.body.height / 2 +
      weapon.muzzleOffsetY;
    const projectileId = `${weapon.id}-shot-${this.#shotSequence + 1}`;

    const spawned = this.#projectileSystem.spawn({
      id: projectileId,
      ownerId: shooter.ownerId,
      team: shooter.team,
      x: muzzleX - projectile.width / 2,
      y: muzzleY - projectile.height / 2,
      width: projectile.width,
      height: projectile.height,
      vx: direction.x * projectile.speed,
      vy: direction.y * projectile.speed,
      damage: projectile.damage,
      lifetimeSeconds: projectile.lifetimeSeconds,
    });

    if (!spawned) {
      return { fired: false, reason: 'capacity', weaponId: weapon.id };
    }

    this.#shotSequence += 1;
    this.#cooldownRemaining = weapon.cooldownSeconds;

    return {
      fired: true,
      reason: 'fired',
      weaponId: weapon.id,
      projectileId,
      direction,
      cooldownRemaining: this.#cooldownRemaining,
    };
  }
}
