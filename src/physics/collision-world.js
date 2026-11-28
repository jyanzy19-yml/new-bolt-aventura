import { aabbIntersects, validateAabb } from './aabb.js';

const EPSILON = 1e-9;

function overlapsHorizontally(firstX, firstWidth, second) {
  return (
    firstX < second.x + second.width &&
    firstX + firstWidth > second.x
  );
}

function overlapsVertically(firstY, firstHeight, second) {
  return (
    firstY < second.y + second.height &&
    firstY + firstHeight > second.y
  );
}

/**
 * Deterministic axis-separated AABB collision world for static platforms.
 *
 * Colliders are immutable rectangles. One-way platforms only block downward
 * crossings; dropThrough bypasses those platforms for the current movement.
 * Slopes, moving bodies and dynamic-vs-dynamic collision are intentionally
 * outside this first collision contract.
 */
export class CollisionWorld {
  #colliders = new Map();

  constructor(colliders = []) {
    if (!Array.isArray(colliders)) {
      throw new TypeError('colliders deve ser um array.');
    }
    for (const collider of colliders) this.addCollider(collider);
  }

  get colliders() {
    return [...this.#colliders.values()].map((collider) => ({ ...collider }));
  }

  addCollider({ id, x, y, width, height, oneWay = false }) {
    if (typeof id !== 'string' || id.trim() === '') {
      throw new TypeError('Collider precisa de um id não vazio.');
    }
    if (this.#colliders.has(id)) {
      throw new Error(`Collider duplicado: ${id}`);
    }
    if (typeof oneWay !== 'boolean') {
      throw new TypeError('oneWay deve ser booleano.');
    }

    const collider = { id, x, y, width, height, oneWay };
    validateAabb(collider, `collider ${id}`);
    this.#colliders.set(id, Object.freeze(collider));
    return id;
  }

  removeCollider(id) {
    return this.#colliders.delete(id);
  }

  overlapsSolid(body) {
    validateAabb(body, 'body');
    for (const collider of this.#colliders.values()) {
      if (collider.oneWay) continue;
      if (aabbIntersects(body, collider)) return true;
    }
    return false;
  }

  move(body, deltaX, deltaY, { dropThrough = false } = {}) {
    validateAabb(body, 'body');
    if (!Number.isFinite(deltaX) || !Number.isFinite(deltaY)) {
      throw new TypeError('O deslocamento precisa ser finito.');
    }
    if (typeof dropThrough !== 'boolean') {
      throw new TypeError('dropThrough deve ser booleano.');
    }

    let x = body.x;
    let y = body.y;
    let collidedX = false;
    let collidedY = false;

    if (deltaX !== 0) {
      let targetX = x + deltaX;

      for (const collider of this.#colliders.values()) {
        if (collider.oneWay) continue;
        if (!overlapsVertically(y, body.height, collider)) continue;

        if (
          deltaX > 0 &&
          x + body.width <= collider.x + EPSILON &&
          targetX + body.width > collider.x + EPSILON
        ) {
          targetX = Math.min(targetX, collider.x - body.width);
          collidedX = true;
        } else if (
          deltaX < 0 &&
          x >= collider.x + collider.width - EPSILON &&
          targetX < collider.x + collider.width - EPSILON
        ) {
          targetX = Math.max(targetX, collider.x + collider.width);
          collidedX = true;
        }
      }

      x = targetX;
    }

    if (deltaY !== 0) {
      let targetY = y + deltaY;

      for (const collider of this.#colliders.values()) {
        if (collider.oneWay && (dropThrough || deltaY < 0)) continue;
        if (!overlapsHorizontally(x, body.width, collider)) continue;

        if (
          deltaY > 0 &&
          y + body.height <= collider.y + EPSILON &&
          targetY + body.height > collider.y + EPSILON
        ) {
          targetY = Math.min(targetY, collider.y - body.height);
          collidedY = true;
        } else if (
          !collider.oneWay &&
          deltaY < 0 &&
          y >= collider.y + collider.height - EPSILON &&
          targetY < collider.y + collider.height - EPSILON
        ) {
          targetY = Math.max(targetY, collider.y + collider.height);
          collidedY = true;
        }
      }

      y = targetY;
    }

    return {
      x,
      y,
      collidedX,
      collidedY,
      grounded: deltaY > 0 && collidedY,
      hitCeiling: deltaY < 0 && collidedY,
    };
  }

  probeGround(body, distance = 1) {
    if (!Number.isFinite(distance) || distance <= 0) {
      throw new RangeError('distance deve ser finito e maior que zero.');
    }

    return this.move(body, 0, distance).grounded;
  }
}
