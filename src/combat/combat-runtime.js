import { ProjectileSystem } from './projectile-system.js';
import { WeaponController } from './weapon-controller.js';

export class CombatRuntime {
  #projectiles;
  #weapons;
  #collisionWorld;

  constructor({
    weapons,
    initialWeaponId,
    maxActiveProjectiles,
    collisionWorld,
  }) {
    if (!Number.isInteger(maxActiveProjectiles) || maxActiveProjectiles < 1) {
      throw new RangeError('maxActiveProjectiles deve ser um inteiro positivo.');
    }
    if (!collisionWorld || typeof collisionWorld.move !== 'function') {
      throw new TypeError('collisionWorld precisa implementar move().');
    }

    this.#projectiles = new ProjectileSystem({ maxActiveProjectiles });
    this.#weapons = new WeaponController({
      projectileSystem: this.#projectiles,
      weapons,
      initialWeaponId,
    });
    this.#collisionWorld = collisionWorld;
  }

  get activeWeaponId() {
    return this.#weapons.activeWeaponId;
  }

  get activeProjectileCount() {
    return this.#projectiles.activeCount;
  }

  get activeProjectiles() {
    return this.#projectiles.activeProjectiles;
  }

  selectWeapon(weaponId) {
    return this.#weapons.selectWeapon(weaponId);
  }

  /**
   * Advances firing and all transient projectiles in one fixed simulation step.
   * Weapon creation occurs before projectile movement, so a new shot advances
   * consistently within the same step in which its trigger is accepted.
   */
  update(deltaSeconds, { inputFrame, shooter, aim = null, targets = [] }) {
    if (!Number.isFinite(deltaSeconds) || deltaSeconds <= 0) {
      throw new RangeError('deltaSeconds deve ser finito e maior que zero.');
    }
    if (!Array.isArray(targets)) {
      throw new TypeError('targets deve ser um array.');
    }

    const weaponResult = this.#weapons.update(deltaSeconds, {
      inputFrame,
      shooter,
      aim,
    });
    const projectileEvents = this.#projectiles.update(deltaSeconds, {
      collisionWorld: this.#collisionWorld,
      targets,
    });

    return {
      weaponResult,
      projectileEvents,
      activeProjectileCount: this.#projectiles.activeCount,
    };
  }

  clearTransientProjectiles() {
    return this.#projectiles.clear();
  }
}
