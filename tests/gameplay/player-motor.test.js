import { describe, expect, it } from 'vitest';
import { CollisionWorld } from '../../src/physics/collision-world.js';
import { PLAYER_ACTIONS, PlayerMotor } from '../../src/gameplay/player-motor.js';

const { MOVE_LEFT, MOVE_RIGHT, JUMP, DASH } = PLAYER_ACTIONS;

function makeConfig(overrides = {}) {
  return {
    maxRunSpeed: 100,
    groundAcceleration: 1000,
    groundDeceleration: 1000,
    airAcceleration: 500,
    airDeceleration: 500,
    gravity: 100,
    maxFallSpeed: 300,
    jumpVelocity: 200,
    jumpCount: 2,
    jumpBufferSeconds: 0.12,
    coyoteTimeSeconds: 0.1,
    jumpHoldMaxSeconds: 0.2,
    jumpHoldGravityScale: 0.5,
    jumpCutMultiplier: 0.5,
    groundProbeDistance: 1,
    dash: {
      speed: 300,
      durationSeconds: 0.1,
      cooldownSeconds: 0.2,
      gravityScale: 0,
      allowGrounded: true,
      allowAirborne: true,
      cancelOnWall: true,
    },
    ...overrides,
  };
}

function frame({ pressed = [], released = [], held = [] } = {}) {
  return { pressed, released, held };
}

function createMotor({
  body = { x: 0, y: 90, width: 10, height: 10 },
  colliders = [{ id: 'floor', x: -100, y: 100, width: 1000, height: 20 }],
  config = makeConfig(),
} = {}) {
  return new PlayerMotor({
    body,
    collisionWorld: new CollisionWorld(colliders),
    config,
  });
}

describe('PlayerMotor horizontal movement', () => {
  it('accelerates on ground, caps speed and decelerates without input', () => {
    const motor = createMotor();

    let state = motor.update(0.1, frame({ held: [MOVE_RIGHT] }));
    expect(state.velocity.x).toBe(100);
    expect(state.body.x).toBe(10);
    state = motor.update(0.1, frame());
    expect(state.velocity.x).toBe(0);
  });

  it('uses a distinct air acceleration profile', () => {
    const motor = createMotor({ body: { x: 0, y: 0, width: 10, height: 10 } });

    const state = motor.update(0.1, frame({ held: [MOVE_RIGHT] }));
    expect(state.velocity.x).toBe(50);
  });

  it('updates facing from the most recent horizontal direction', () => {
    const motor = createMotor();

    expect(motor.update(0.01, frame({ held: [MOVE_LEFT] })).facing).toBe(-1);
    expect(motor.update(0.01, frame({ held: [MOVE_RIGHT] })).facing).toBe(1);
  });
});

describe('PlayerMotor jumping', () => {
  it('jumps from ground and lands with a reset jump budget', () => {
    const motor = createMotor();

    const airborne = motor.update(0.016, frame({
      pressed: [JUMP],
      held: [JUMP],
    }));
    expect(airborne.velocity.y).toBeLessThan(0);
    expect(airborne.state).toBe('airborne');
    expect(airborne.jumpsRemaining).toBe(1);

    let landed;
    for (let index = 0; index < 300; index += 1) {
      landed = motor.update(0.016, frame());
      if (landed.grounded) break;
    }
    expect(landed.grounded).toBe(true);
    expect(landed.jumpsRemaining).toBe(2);
  });

  it('supports the configured second jump while airborne', () => {
    const motor = createMotor();

    motor.update(0.016, frame({ pressed: [JUMP], held: [JUMP] }));
    const secondJump = motor.update(0.016, frame({ pressed: [JUMP], held: [JUMP] }));

    expect(secondJump.velocity.y).toBeLessThan(0);
    expect(secondJump.jumpsRemaining).toBe(0);
  });

  it('cuts upward velocity when jump is released', () => {
    const motor = createMotor();

    motor.update(0.016, frame({ pressed: [JUMP], held: [JUMP] }));
    const released = motor.update(0.016, frame({ released: [JUMP] }));

    expect(Math.abs(released.velocity.y)).toBeLessThan(100);
  });

  it('buffers a jump shortly before landing', () => {
    const motor = createMotor({
      body: { x: 0, y: 9, width: 10, height: 10 },
      colliders: [{ id: 'floor', x: -100, y: 20, width: 1000, height: 20 }],
      config: makeConfig({
        gravity: 100,
        jumpVelocity: 200,
        jumpBufferSeconds: 0.2,
      }),
    });

    motor.update(0.15, frame({ pressed: [JUMP] }));
    const state = motor.update(0.016, frame());

    expect(state.velocity.y).toBeLessThan(0);
    expect(state.jumpsRemaining).toBe(1);
  });

  it('allows a coyote-time jump after leaving a ledge', () => {
    const motor = createMotor({
      body: { x: -4, y: 90, width: 10, height: 10 },
      colliders: [{ id: 'ledge', x: -100, y: 100, width: 100, height: 20 }],
    });

    motor.update(0.1, frame({ held: [MOVE_RIGHT] }));
    const state = motor.update(0.02, frame({ pressed: [JUMP] }));

    expect(state.velocity.y).toBeLessThan(0);
    expect(state.jumpsRemaining).toBe(1);
  });

  it('does not allow a ground jump after coyote time expires', () => {
    const motor = createMotor({
      body: { x: -4, y: 90, width: 10, height: 10 },
      colliders: [{ id: 'ledge', x: -100, y: 100, width: 100, height: 20 }],
      config: makeConfig({ jumpCount: 1, coyoteTimeSeconds: 0.02 }),
    });

    motor.update(0.05, frame({ held: [MOVE_RIGHT] }));
    const state = motor.update(0.05, frame({ pressed: [JUMP] }));

    expect(state.velocity.y).toBeGreaterThanOrEqual(0);
    expect(state.jumpsRemaining).toBe(0);
  });
});

describe('PlayerMotor Dash', () => {
  it('starts a horizontal Dash using the facing direction when no direction is held', () => {
    const motor = createMotor();

    const state = motor.update(0.05, frame({ pressed: [DASH] }));

    expect(state.state).toBe('dashing');
    expect(state.body.x).toBe(15);
    expect(state.velocity.x).toBe(300);
  });

  it('uses held horizontal direction to set Dash facing', () => {
    const motor = createMotor();

    const state = motor.update(0.05, frame({
      pressed: [DASH],
      held: [MOVE_LEFT],
    }));

    expect(state.facing).toBe(-1);
    expect(state.body.x).toBe(-15);
  });

  it('enforces Dash ground/air eligibility and cooldown', () => {
    const groundedOnly = createMotor({
      body: { x: 0, y: 0, width: 10, height: 10 },
      config: makeConfig({
        dash: {
          speed: 300,
          durationSeconds: 0.1,
          cooldownSeconds: 0.2,
          gravityScale: 0,
          allowGrounded: true,
          allowAirborne: false,
          cancelOnWall: true,
        },
      }),
    });

    expect(groundedOnly.update(0.016, frame({ pressed: [DASH] })).state)
      .toBe('airborne');

    const motor = createMotor();
    motor.update(0.05, frame({ pressed: [DASH] }));
    const cooldownState = motor.update(0.05, frame({ pressed: [DASH] }));
    expect(cooldownState.state).not.toBe('dashing');
  });

  it('cancels Dash on a blocking wall when configured', () => {
    const motor = createMotor({
      colliders: [
        { id: 'floor', x: -100, y: 100, width: 1000, height: 20 },
        { id: 'wall', x: 20, y: 0, width: 10, height: 100 },
      ],
    });

    const state = motor.update(0.1, frame({ pressed: [DASH] }));

    expect(state.body.x).toBe(10);
    expect(state.velocity.x).toBe(0);
    expect(state.state).toBe('grounded');
  });

  it('resets movement and timers without changing configuration', () => {
    const motor = createMotor();
    motor.update(0.05, frame({ pressed: [DASH] }));

    const state = motor.reset(
      { x: 50, y: 90, width: 10, height: 10 },
      { facing: -1 },
    );

    expect(state.body).toEqual({ x: 50, y: 90, width: 10, height: 10 });
    expect(state.velocity).toEqual({ x: 0, y: 0 });
    expect(state.facing).toBe(-1);
    expect(state.dashCooldownRemaining).toBe(0);
  });
});

describe('PlayerMotor validation', () => {
  it('rejects invalid timestep, body and tuning', () => {
    const motor = createMotor();

    expect(() => motor.update(0, frame())).toThrow(RangeError);
    expect(() => createMotor({ body: { x: 0, y: 0, width: 0, height: 10 } }))
      .toThrow(RangeError);
    expect(() => createMotor({ config: makeConfig({ maxRunSpeed: 0 }) }))
      .toThrow(RangeError);
    expect(() => createMotor({
      config: makeConfig({
        dash: {
          speed: 300,
          durationSeconds: 0.1,
          cooldownSeconds: 0,
          gravityScale: 0,
          allowGrounded: false,
          allowAirborne: false,
          cancelOnWall: true,
        },
      }),
    })).toThrow(RangeError);
  });
});
