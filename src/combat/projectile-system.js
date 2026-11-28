import { aabbIntersects, validateAabb } from '../physics/aabb.js';

function assertText(value, name) {
  if (typeof value !== 'string' || value.trim() === '') {
    throw new TypeError(`${name} deve ser uma string não vazia.`);
  }
}

function assertPositiveFinite(value, name) {
  if (!Number.isFinite(value) || value <= 0) {
    throw new RangeError(`${name} deve ser finito e maior que zero.`);
  }
}

function axisTimes(movingStart, movingSize, targetStart, targetSize, delta) {
  if (delta > 0) {
    return [
      (targetStart - (movingStart + movingSize)) / delta,
      (targetStart + targetSize - movingStart) / delta,
    ];
  }
  if (delta < 0) {
    return [
      (targetStart + targetSize - movingStart) / delta,
      (targetStart - (movingStart + movingSize)) / delta,
    ];
  }

  if (
    movingStart < targetStart + targetSize &&
    movingStart + movingSize > targetStart
  ) {
    return [-Infinity, Infinity];
  }
  return [Infinity, -Infinity];
}

function sweptAabbTime(moving, deltaX, deltaY, target) {
  if (aabbIntersects(moving, target)) return 0;

  const [xEntry, xExit] = axisTimes(
    moving.x,
    moving.width,
    target.x,
    target.width,
    deltaX,
  );
  const [yEntry, yExit] = axisTimes(
    moving.y,
    moving.height,
    target.y,
    target.height,
    deltaY,
  );

  const entryTime = Math.max(xEntry, yEntry);
  const exitTime = Math.min(xExit, yExit);

  if (entryTime > exitTime || exitTime < 0 || entryTime > 1) return null;
  return Math.max(0, entryTime);
}

/**
 * Owns transient projectile instances and resolves their lifetime, static-world
 * impact and swept AABB hits against opposing damageable targets.
 */
export class ProjectileSystem {
  #projectiles = new Map();
  #maxActiveProjectiles;

  constructor({ maxActiveProjectiles }) {
    if (!Number.isInteger(maxActiveProjectiles) || maxActiveProjectiles < 1) {
      throw new RangeError('maxActiveProjectiles deve ser um inteiro positivo.');
    }
    this.#maxActiveProjectiles = maxActiveProjectiles;
  }

  get activeCount() {
    return this.#projectiles.size;
  }

  get activeProjectiles() {
    return [...this.#projectiles.values()].map((projectile) => ({ ...projectile }));
  }

  spawn({
    id,
    ownerId,
    team,
    x,
    y,
    width,
    height,
    vx,
    vy,
    damage,
    lifetimeSeconds,
  }) {
    assertText(id, 'id');
    assertText(ownerId, 'ownerId');
    assertText(team, 'team');
    validateAabb({ x, y, width, height }, 'projectile');
    if (!Number.isFinite(vx) || !Number.isFinite(vy)) {
      throw new TypeError('A velocidade do projétil deve ser finita.');
    }
    assertPositiveFinite(damage, 'damage');
    assertPositiveFinite(lifetimeSeconds, 'lifetimeSeconds');

    if (this.#projectiles.has(id)) {
      throw new Error(`Projétil duplicado: ${id}`);
    }
    if (this.#projectiles.size >= this.#maxActiveProjectiles) return false;

    this.#projectiles.set(id, {
      id,
      ownerId,
      team,
      x,
      y,
      width,
      height,
      vx,
      vy,
      damage,
      remainingSeconds: lifetimeSeconds,
    });

    return true;
  }

  update(deltaSeconds, { collisionWorld, targets = [] }) {
    if (!Number.isFinite(deltaSeconds) || deltaSeconds <= 0) {
      throw new RangeError('deltaSeconds deve ser finito e maior que zero.');
    }
    if (!collisionWorld || typeof collisionWorld.move !== 'function') {
      throw new TypeError('collisionWorld precisa implementar move().');
    }
    if (!Array.isArray(targets)) {
      throw new TypeError('targets deve ser um array.');
    }

    const events = [];

    for (const projectile of this.#projectiles.values()) {
      projectile.remainingSeconds -= deltaSeconds;

      if (projectile.remainingSeconds <= 0) {
        this.#projectiles.delete(projectile.id);
        events.push({ type: 'expired', projectileId: projectile.id });
        continue;
      }

      const deltaX = projectile.vx * deltaSeconds;
      const deltaY = projectile.vy * deltaSeconds;
      const movement = collisionWorld.move(projectile, deltaX, deltaY);
      const actualDeltaX = movement.x - projectile.x;
      const actualDeltaY = movement.y - projectile.y;

      let firstHit = null;

      for (const target of targets) {
        if (
          !target ||
          target.id === projectile.ownerId ||
          target.team === projectile.team ||
          !target.health ||
          typeof target.health.applyDamage !== 'function' ||
          target.health.defeated
        ) {
          continue;
        }

        validateAabb(target.body, `target ${target.id}`);
        const hitTime = sweptAabbTime(
          projectile,
          actualDeltaX,
          actualDeltaY,
          target.body,
        );

        if (hitTime !== null && (!firstHit || hitTime < firstHit.hitTime)) {
          firstHit = { target, hitTime };
        }
      }

      if (firstHit) {
        const damage = firstHit.target.health.applyDamage(projectile.damage);
        this.#projectiles.delete(projectile.id);
        events.push({
          type: 'hit',
          projectileId: projectile.id,
          targetId: firstHit.target.id,
          appliedDamage: damage.applied,
          remainingHealth: damage.currentHealth,
          targetDefeated: damage.defeated,
        });
        continue;
      }

      if (movement.collidedX || movement.collidedY) {
        this.#projectiles.delete(projectile.id);
        events.push({ type: 'world-impact', projectileId: projectile.id });
        continue;
      }

      projectile.x = movement.x;
      projectile.y = movement.y;
    }

    return events;
  }

  clear() {
    const removed = this.#projectiles.size;
    this.#projectiles.clear();
    return removed;
  }
}
