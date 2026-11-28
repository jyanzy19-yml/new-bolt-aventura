import { describe, expect, it, vi } from 'vitest';
import { CollisionWorld } from '../../src/physics/collision-world.js';
import { PlayerMotor } from '../../src/gameplay/player-motor.js';
import { PlayerSceneRuntime } from '../../src/gameplay/player-scene-runtime.js';

function createMotor() {
  return new PlayerMotor({
    body: { x: 0, y: 90, width: 10, height: 10 },
    collisionWorld: new CollisionWorld([
      { id: 'floor', x: -100, y: 100, width: 1000, height: 20 },
    ]),
    config: {
      maxRunSpeed: 100,
      groundAcceleration: 1000,
      groundDeceleration: 1000,
      airAcceleration: 500,
      airDeceleration: 500,
      gravity: 100,
      maxFallSpeed: 300,
      jumpVelocity: 200,
      jumpCount: 2,
      jumpBufferSeconds: 0.1,
      coyoteTimeSeconds: 0.1,
      jumpHoldMaxSeconds: 0.1,
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
    },
  });
}

function createHarness() {
  const inputManager = {
    consume: vi.fn()
      .mockReturnValueOnce({ pressed: [], released: [], held: ['move-right'] })
      .mockReturnValue({ pressed: [], released: [], held: [] }),
  };
  const camera = {
    position: { x: 0, y: 0 },
    reset: vi.fn((body) => {
      camera.position = { x: body.x - 10, y: body.y - 10 };
      return { ...camera.position };
    }),
    update: vi.fn((target) => {
      camera.position = { x: target.x - 10, y: target.y - 10 };
      return { ...camera.position };
    }),
  };
  const renderer = { render: vi.fn(() => 'frame-rendered') };
  const level = {
    geometry: { solids: [], oneWayPlatforms: [] },
    checkpoints: [],
    exits: [],
  };
  const playerMotor = createMotor();
  const runtime = new PlayerSceneRuntime({
    inputManager,
    playerMotor,
    camera,
    renderer,
    level,
  });

  return { runtime, inputManager, camera, renderer, level, playerMotor };
}

describe('PlayerSceneRuntime', () => {
  it('composes input, player movement and camera in each fixed update', () => {
    const { runtime, inputManager, camera } = createHarness();

    const snapshot = runtime.update(0.1);

    expect(inputManager.consume).toHaveBeenCalledTimes(1);
    expect(snapshot.body.x).toBe(10);
    expect(snapshot.velocity.x).toBe(100);
    expect(camera.update).toHaveBeenCalledWith(
      { x: 10, y: 90, width: 10, height: 10, vx: 100 },
      0.1,
    );
  });

  it('interpolates player and camera only during render', () => {
    const { runtime, renderer, playerMotor } = createHarness();

    runtime.update(0.1);
    const beforeRender = runtime.playerSnapshot;
    const result = runtime.render(0.5);

    expect(result).toBe('frame-rendered');
    expect(renderer.render).toHaveBeenCalledWith(expect.objectContaining({
      player: expect.objectContaining({
        body: expect.objectContaining({ x: 5, y: 90 }),
      }),
      camera: { x: -5, y: 80 },
    }));
    expect(runtime.playerSnapshot).toEqual(beforeRender);
    expect(playerMotor.snapshot.body.x).toBe(10);
  });

  it('renders initial state and supports alpha boundaries', () => {
    const { runtime, renderer } = createHarness();

    runtime.render(0);
    expect(renderer.render.mock.lastCall[0].player.body.x).toBe(0);
    runtime.render(1);
    expect(renderer.render.mock.lastCall[0].player.body.x).toBe(0);
  });

  it('resets player and camera without interpolating across respawn', () => {
    const { runtime, renderer } = createHarness();

    runtime.update(0.1);
    runtime.reset({ x: 300, y: 200, width: 10, height: 10 }, { facing: -1 });
    runtime.render(0);

    expect(runtime.playerSnapshot.body).toEqual({
      x: 300,
      y: 200,
      width: 10,
      height: 10,
    });
    expect(renderer.render.mock.lastCall[0].player.body.x).toBe(300);
    expect(renderer.render.mock.lastCall[0].camera).toEqual({ x: 290, y: 190 });
  });

  it('rejects invalid delta, interpolation alpha and dependencies', () => {
    const { runtime } = createHarness();

    expect(() => runtime.update(0)).toThrow(RangeError);
    expect(() => runtime.render(1.1)).toThrow(RangeError);
    expect(() => new PlayerSceneRuntime({})).toThrow(TypeError);
  });
});
