function validateRect(rect, name) {
  if (!rect || typeof rect !== 'object') {
    throw new TypeError(`${name} deve ser um objeto.`);
  }
  for (const key of ['x', 'y', 'width', 'height']) {
    if (!Number.isFinite(rect[key])) {
      throw new TypeError(`${name}.${key} deve ser finito.`);
    }
  }
  if (rect.width <= 0 || rect.height <= 0) {
    throw new RangeError(`${name} precisa ter largura e altura positivas.`);
  }
}

function assertPositiveFinite(value, name) {
  if (!Number.isFinite(value) || value <= 0) {
    throw new RangeError(`${name} deve ser finito e maior que zero.`);
  }
}

function clampAxis(position, worldStart, worldSize, viewportSize) {
  const worldEnd = worldStart + worldSize;
  const maximum = worldEnd - viewportSize;

  if (maximum < worldStart) {
    return worldStart + (worldSize - viewportSize) / 2;
  }
  return Math.min(maximum, Math.max(worldStart, position));
}

/**
 * Camera follow model in world coordinates. It does not draw or mutate targets.
 * Dead-zone and smoothing are explicit configuration, not hidden game tuning.
 */
export class Camera2D {
  #viewportWidth;
  #viewportHeight;
  #worldBounds;
  #deadZone;
  #lookAheadX;
  #smoothing;
  #x = 0;
  #y = 0;
  #initialized = false;

  constructor({
    viewportWidth,
    viewportHeight,
    worldBounds,
    deadZone,
    lookAheadX = 0,
    smoothing = 0,
  }) {
    assertPositiveFinite(viewportWidth, 'viewportWidth');
    assertPositiveFinite(viewportHeight, 'viewportHeight');
    validateRect(worldBounds, 'worldBounds');
    validateRect(deadZone, 'deadZone');

    if (
      deadZone.x < 0 ||
      deadZone.y < 0 ||
      deadZone.x + deadZone.width > viewportWidth ||
      deadZone.y + deadZone.height > viewportHeight
    ) {
      throw new RangeError('deadZone precisa estar contida no viewport.');
    }
    if (!Number.isFinite(lookAheadX) || lookAheadX < 0) {
      throw new RangeError('lookAheadX deve ser finito e não negativo.');
    }
    if (!Number.isFinite(smoothing) || smoothing < 0) {
      throw new RangeError('smoothing deve ser finito e não negativo.');
    }

    this.#viewportWidth = viewportWidth;
    this.#viewportHeight = viewportHeight;
    this.#worldBounds = { ...worldBounds };
    this.#deadZone = { ...deadZone };
    this.#lookAheadX = lookAheadX;
    this.#smoothing = smoothing;
  }

  get position() {
    return { x: this.#x, y: this.#y };
  }

  reset(target) {
    validateRect(target, 'target');
    this.#x = target.x + target.width / 2 - this.#viewportWidth / 2;
    this.#y = target.y + target.height / 2 - this.#viewportHeight / 2;
    this.#clampToWorld();
    this.#initialized = true;
    return this.position;
  }

  update(target, deltaSeconds) {
    validateRect(target, 'target');
    if (!Number.isFinite(deltaSeconds) || deltaSeconds < 0) {
      throw new RangeError('deltaSeconds deve ser finito e não negativo.');
    }

    if (!this.#initialized) this.reset(target);

    const velocityX = Number.isFinite(target.vx) ? target.vx : 0;
    const lookAhead = Math.sign(velocityX) * this.#lookAheadX;
    const targetCenterX = target.x + target.width / 2 + lookAhead;
    const targetCenterY = target.y + target.height / 2;

    const desiredX = this.#followAxis(
      this.#x,
      targetCenterX,
      this.#deadZone.x,
      this.#deadZone.width,
    );
    const desiredY = this.#followAxis(
      this.#y,
      targetCenterY,
      this.#deadZone.y,
      this.#deadZone.height,
    );

    if (this.#smoothing === 0) {
      this.#x = desiredX;
      this.#y = desiredY;
    } else {
      const blend = 1 - Math.exp(-this.#smoothing * deltaSeconds);
      this.#x += (desiredX - this.#x) * blend;
      this.#y += (desiredY - this.#y) * blend;
    }

    this.#clampToWorld();
    return this.position;
  }

  #followAxis(cameraStart, targetCenter, deadStart, deadSize) {
    const deadEnd = cameraStart + deadStart + deadSize;

    if (targetCenter < cameraStart + deadStart) {
      return targetCenter - deadStart;
    }
    if (targetCenter > deadEnd) {
      return targetCenter - deadStart - deadSize;
    }
    return cameraStart;
  }

  #clampToWorld() {
    this.#x = clampAxis(
      this.#x,
      this.#worldBounds.x,
      this.#worldBounds.width,
      this.#viewportWidth,
    );
    this.#y = clampAxis(
      this.#y,
      this.#worldBounds.y,
      this.#worldBounds.height,
      this.#viewportHeight,
    );
  }
}
