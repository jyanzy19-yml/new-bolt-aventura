import { validateAabb } from '../physics/aabb.js';

export const PLAYER_ACTIONS = Object.freeze({
  MOVE_LEFT: 'move-left',
  MOVE_RIGHT: 'move-right',
  JUMP: 'jump',
  DASH: 'dash',
});

function assertFinite(value, name) {
  if (!Number.isFinite(value)) {
    throw new TypeError(`${name} deve ser finito.`);
  }
}

function assertPositive(value, name) {
  assertFinite(value, name);
  if (value <= 0) throw new RangeError(`${name} deve ser maior que zero.`);
}

function assertNonNegative(value, name) {
  assertFinite(value, name);
  if (value < 0) throw new RangeError(`${name} não pode ser negativo.`);
}

function assertUnitInterval(value, name) {
  assertFinite(value, name);
  if (value < 0 || value > 1) {
    throw new RangeError(`${name} deve estar entre zero e um.`);
  }
}

function validateConfig(config) {
  if (!config || typeof config !== 'object') {
    throw new TypeError('config deve ser um objeto.');
  }

  assertPositive(config.maxRunSpeed, 'maxRunSpeed');
  assertPositive(config.groundAcceleration, 'groundAcceleration');
  assertPositive(config.groundDeceleration, 'groundDeceleration');
  assertPositive(config.airAcceleration, 'airAcceleration');
  assertPositive(config.airDeceleration, 'airDeceleration');
  assertPositive(config.gravity, 'gravity');
  assertPositive(config.maxFallSpeed, 'maxFallSpeed');
  assertPositive(config.jumpVelocity, 'jumpVelocity');
  assertPositive(config.groundProbeDistance, 'groundProbeDistance');
  assertNonNegative(config.jumpBufferSeconds, 'jumpBufferSeconds');
  assertNonNegative(config.coyoteTimeSeconds, 'coyoteTimeSeconds');
  assertNonNegative(config.jumpHoldMaxSeconds, 'jumpHoldMaxSeconds');
  assertUnitInterval(config.jumpHoldGravityScale, 'jumpHoldGravityScale');
  assertUnitInterval(config.jumpCutMultiplier, 'jumpCutMultiplier');

  if (!Number.isInteger(config.jumpCount) || config.jumpCount < 1) {
    throw new RangeError('jumpCount deve ser um inteiro positivo.');
  }
  if (!config.dash || typeof config.dash !== 'object') {
    throw new TypeError('config.dash é obrigatório.');
  }

  assertPositive(config.dash.speed, 'dash.speed');
  assertPositive(config.dash.durationSeconds, 'dash.durationSeconds');
  assertNonNegative(config.dash.cooldownSeconds, 'dash.cooldownSeconds');
  assertNonNegative(config.dash.gravityScale, 'dash.gravityScale');

  for (const key of ['allowGrounded', 'allowAirborne', 'cancelOnWall']) {
    if (typeof config.dash[key] !== 'boolean') {
      throw new TypeError(`dash.${key} deve ser booleano.`);
    }
  }
  if (!config.dash.allowGrounded && !config.dash.allowAirborne) {
    throw new RangeError('Dash precisa ser permitido no chão, no ar ou em ambos.');
  }
}

function readInputFrame(inputFrame) {
  if (!inputFrame || typeof inputFrame !== 'object') {
    throw new TypeError('inputFrame deve ser um objeto.');
  }

  for (const key of ['pressed', 'released', 'held']) {
    if (!Array.isArray(inputFrame[key])) {
      throw new TypeError(`inputFrame.${key} deve ser um array.`);
    }
  }

  return {
    pressed: new Set(inputFrame.pressed),
    released: new Set(inputFrame.released),
    held: new Set(inputFrame.held),
  };
}

function approach(current, target, amount) {
  if (current < target) return Math.min(current + amount, target);
  if (current > target) return Math.max(current - amount, target);
  return target;
}

/**
 * Deterministic player movement model. All tuning is injected by the caller;
 * this class deliberately contains no unapproved production balance values.
 *
 * The motor consumes ActionBuffer frames and a static CollisionWorld. It does
 * not own rendering, animation, camera, audio, save data or DOM event handlers.
 */
export class PlayerMotor {
  #body;
  #velocityX = 0;
  #velocityY = 0;
  #facing = 1;
  #grounded = false;
  #jumpsRemaining;
  #jumpBufferRemaining = 0;
  #coyoteRemaining = 0;
  #jumpHoldRemaining = 0;
  #dashRemaining = 0;
  #dashCooldownRemaining = 0;
  #collisionWorld;
  #config;

  constructor({ body, collisionWorld, config }) {
    validateAabb(body, 'player body');
    if (!collisionWorld || typeof collisionWorld.move !== 'function' ||
        typeof collisionWorld.probeGround !== 'function') {
      throw new TypeError('collisionWorld precisa implementar move() e probeGround().');
    }
    validateConfig(config);

    this.#body = { x: body.x, y: body.y, width: body.width, height: body.height };
    this.#collisionWorld = collisionWorld;
    this.#config = {
      ...config,
      dash: { ...config.dash },
    };
    this.#jumpsRemaining = config.jumpCount;
  }

  get snapshot() {
    return {
      body: { ...this.#body },
      velocity: { x: this.#velocityX, y: this.#velocityY },
      facing: this.#facing,
      grounded: this.#grounded,
      state: this.#dashRemaining > 0
        ? 'dashing'
        : this.#grounded
          ? 'grounded'
          : 'airborne',
      jumpsRemaining: this.#jumpsRemaining,
      jumpBufferRemaining: this.#jumpBufferRemaining,
      coyoteRemaining: this.#coyoteRemaining,
      dashRemaining: this.#dashRemaining,
      dashCooldownRemaining: this.#dashCooldownRemaining,
    };
  }

  reset(body, { facing = 1 } = {}) {
    validateAabb(body, 'player body');
    if (facing !== -1 && facing !== 1) {
      throw new RangeError('facing deve ser -1 ou 1.');
    }

    this.#body = { x: body.x, y: body.y, width: body.width, height: body.height };
    this.#velocityX = 0;
    this.#velocityY = 0;
    this.#facing = facing;
    this.#grounded = false;
    this.#jumpsRemaining = this.#config.jumpCount;
    this.#jumpBufferRemaining = 0;
    this.#coyoteRemaining = 0;
    this.#jumpHoldRemaining = 0;
    this.#dashRemaining = 0;
    this.#dashCooldownRemaining = 0;
    return this.snapshot;
  }

  update(deltaSeconds, inputFrame) {
    assertPositive(deltaSeconds, 'deltaSeconds');
    const input = readInputFrame(inputFrame);
    const config = this.#config;
    const dashConfig = config.dash;

    const horizontalAxis =
      Number(input.held.has(PLAYER_ACTIONS.MOVE_RIGHT)) -
      Number(input.held.has(PLAYER_ACTIONS.MOVE_LEFT));

    if (horizontalAxis !== 0) this.#facing = Math.sign(horizontalAxis);

    const groundedAtStart = this.#collisionWorld.probeGround(
      this.#body,
      config.groundProbeDistance,
    );

    if (groundedAtStart) {
      this.#grounded = true;
      this.#jumpsRemaining = config.jumpCount;
      this.#coyoteRemaining = config.coyoteTimeSeconds;
    } else {
      this.#grounded = false;
      this.#coyoteRemaining = Math.max(0, this.#coyoteRemaining - deltaSeconds);
      if (this.#coyoteRemaining === 0 && this.#jumpsRemaining === config.jumpCount) {
        this.#jumpsRemaining = Math.max(0, config.jumpCount - 1);
      }
    }

    if (input.pressed.has(PLAYER_ACTIONS.JUMP)) {
      this.#jumpBufferRemaining = config.jumpBufferSeconds;
    } else {
      this.#jumpBufferRemaining = Math.max(
        0,
        this.#jumpBufferRemaining - deltaSeconds,
      );
    }

    this.#dashCooldownRemaining = Math.max(
      0,
      this.#dashCooldownRemaining - deltaSeconds,
    );

    let startedDash = false;
    if (
      input.pressed.has(PLAYER_ACTIONS.DASH) &&
      this.#dashRemaining === 0 &&
      this.#dashCooldownRemaining === 0 &&
      ((groundedAtStart && dashConfig.allowGrounded) ||
        (!groundedAtStart && dashConfig.allowAirborne))
    ) {
      this.#dashRemaining = dashConfig.durationSeconds;
      this.#dashCooldownRemaining = dashConfig.cooldownSeconds;
      this.#velocityX = this.#facing * dashConfig.speed;
      this.#velocityY = 0;
      this.#jumpHoldRemaining = 0;
      startedDash = true;
    }

    if (
      !startedDash &&
      this.#dashRemaining === 0 &&
      this.#jumpBufferRemaining > 0 &&
      (this.#jumpsRemaining > 0 || this.#coyoteRemaining > 0)
    ) {
      this.#velocityY = -config.jumpVelocity;
      this.#jumpsRemaining = Math.max(0, this.#jumpsRemaining - 1);
      this.#jumpBufferRemaining = 0;
      this.#coyoteRemaining = 0;
      this.#jumpHoldRemaining = config.jumpHoldMaxSeconds;
      this.#grounded = false;
    }

    if (
      input.released.has(PLAYER_ACTIONS.JUMP) &&
      this.#velocityY < 0 &&
      this.#jumpHoldRemaining > 0
    ) {
      this.#velocityY *= config.jumpCutMultiplier;
      this.#jumpHoldRemaining = 0;
    }

    const isDashingThisStep = this.#dashRemaining > 0;
    if (isDashingThisStep) {
      this.#velocityX = this.#facing * dashConfig.speed;
      this.#velocityY += config.gravity * dashConfig.gravityScale * deltaSeconds;
    } else {
      const acceleration = this.#grounded
        ? config.groundAcceleration
        : config.airAcceleration;
      const deceleration = this.#grounded
        ? config.groundDeceleration
        : config.airDeceleration;
      const targetVelocity = horizontalAxis * config.maxRunSpeed;

      this.#velocityX = horizontalAxis === 0
        ? approach(this.#velocityX, 0, deceleration * deltaSeconds)
        : approach(this.#velocityX, targetVelocity, acceleration * deltaSeconds);

      const holdingJump =
        input.held.has(PLAYER_ACTIONS.JUMP) &&
        this.#velocityY < 0 &&
        this.#jumpHoldRemaining > 0;
      const gravityScale = holdingJump ? config.jumpHoldGravityScale : 1;
      this.#velocityY = Math.min(
        config.maxFallSpeed,
        this.#velocityY + config.gravity * gravityScale * deltaSeconds,
      );
      if (holdingJump) {
        this.#jumpHoldRemaining = Math.max(
          0,
          this.#jumpHoldRemaining - deltaSeconds,
        );
      }
    }

    const movement = this.#collisionWorld.move(
      this.#body,
      this.#velocityX * deltaSeconds,
      this.#velocityY * deltaSeconds,
    );

    this.#body.x = movement.x;
    this.#body.y = movement.y;

    if (movement.collidedX) {
      this.#velocityX = 0;
      if (isDashingThisStep && dashConfig.cancelOnWall) {
        this.#dashRemaining = 0;
      }
    }
    if (movement.collidedY) this.#velocityY = 0;

    this.#grounded =
      movement.grounded ||
      (this.#velocityY >= 0 &&
        this.#collisionWorld.probeGround(this.#body, config.groundProbeDistance));

    if (this.#grounded) {
      this.#velocityY = 0;
      this.#jumpsRemaining = config.jumpCount;
      this.#coyoteRemaining = config.coyoteTimeSeconds;
    }

    if (isDashingThisStep && this.#dashRemaining > 0) {
      this.#dashRemaining = Math.max(0, this.#dashRemaining - deltaSeconds);
      if (this.#dashRemaining === 0) {
        this.#velocityX = Math.sign(this.#velocityX) *
          Math.min(Math.abs(this.#velocityX), config.maxRunSpeed);
      }
    }

    return this.snapshot;
  }
}
