import { describe, expect, it, vi } from 'vitest';
import { FixedStepLoop } from '../../src/core/fixed-step-loop.js';
import { PlayerMotor } from '../../src/gameplay/player-motor.js';
import { PlayerSceneRuntime } from '../../src/gameplay/player-scene-runtime.js';
import { createLevelCollisionWorld } from '../../src/levels/level-collision-adapter.js';
import { LevelRuntime } from '../../src/levels/level-runtime.js';
import { Camera2D } from '../../src/rendering/camera-2d.js';
import { DebugCanvasRenderer } from '../../src/rendering/debug-canvas-renderer.js';
import {
  DEBUG_PLAYER_TUNING,
  DEBUG_W1_L1,
} from '../../src/levels/fixtures/w1-l1-debug.js';

function createCanvasSurface() {
  const context = {
    fillRect: vi.fn(),
    strokeRect: vi.fn(),
    save: vi.fn(),
    restore: vi.fn(),
    translate: vi.fn(),
    fillStyle: '',
    strokeStyle: '',
  };
  return {
    context,
    clear: vi.fn(),
  };
}

describe('W1-L1 debug playable slice composition', () => {
  it('loads the debug phase, builds collision, moves, jumps, dashes and renders', () => {
    const levelRuntime = new LevelRuntime();
    const level = levelRuntime.load(DEBUG_W1_L1);
    const collisionWorld = createLevelCollisionWorld(level);
    const playerMotor = new PlayerMotor({
      body: {
        x: level.spawn.x,
        y: level.spawn.y,
        width: 30,
        height: 46,
      },
      collisionWorld,
      config: DEBUG_PLAYER_TUNING,
    });

    const frames = [
      { pressed: [], released: [], held: [] },
      { pressed: ['jump'], released: [], held: ['jump'] },
      { pressed: ['dash'], released: [], held: [] },
    ];
    const inputManager = {
      consume: vi.fn(() => frames.shift() ?? {
        pressed: [],
        released: [],
        held: [],
      }),
    };
    const camera = new Camera2D({
      viewportWidth: 800,
      viewportHeight: 450,
      worldBounds: level.bounds,
      deadZone: { x: 300, y: 150, width: 200, height: 120 },
      lookAheadX: 48,
      smoothing: 8,
    });
    const surface = createCanvasSurface();
    const renderer = new DebugCanvasRenderer(surface);
    const scene = new PlayerSceneRuntime({
      inputManager,
      playerMotor,
      camera,
      renderer,
      level,
    });

    const grounded = scene.update(1 / 60);
    expect(grounded.state).toBe('grounded');

    const jumping = scene.update(1 / 60);
    expect(jumping.velocity.y).toBeLessThan(0);
    expect(jumping.state).toBe('airborne');

    const dashing = scene.update(1 / 60);
    expect(dashing.state).toBe('dashing');

    const drawReport = scene.render(0.5);
    expect(drawReport).toEqual({
      solids: 3,
      oneWayPlatforms: 6,
      checkpoints: 2,
      exits: 1,
      player: 1,
    });
    expect(surface.clear).toHaveBeenCalled();
    expect(surface.context.fillRect).toHaveBeenCalled();
    expect(inputManager.consume).toHaveBeenCalledTimes(3);
  });

  it('runs the composed scene through the fixed-step scheduler contract', () => {
    const levelRuntime = new LevelRuntime();
    const level = levelRuntime.load(DEBUG_W1_L1);
    const playerMotor = new PlayerMotor({
      body: { x: level.spawn.x, y: level.spawn.y, width: 30, height: 46 },
      collisionWorld: createLevelCollisionWorld(level),
      config: DEBUG_PLAYER_TUNING,
    });
    const inputManager = {
      consume: vi.fn(() => ({ pressed: [], released: [], held: [] })),
    };
    const camera = new Camera2D({
      viewportWidth: 800,
      viewportHeight: 450,
      worldBounds: level.bounds,
      deadZone: { x: 300, y: 150, width: 200, height: 120 },
    });
    const renderer = new DebugCanvasRenderer(createCanvasSurface());
    const scene = new PlayerSceneRuntime({
      inputManager,
      playerMotor,
      camera,
      renderer,
      level,
    });

    let scheduledFrame;
    const loop = new FixedStepLoop({
      update: (deltaSeconds) => scene.update(deltaSeconds),
      render: (alpha) => scene.render(alpha),
      requestFrame: (callback) => {
        scheduledFrame = callback;
        return 1;
      },
      cancelFrame: vi.fn(),
      stepMs: 1000 / 60,
      maxFrameDeltaMs: 250,
      maxStepsPerFrame: 5,
    });

    expect(loop.start()).toBe(true);
    scheduledFrame(0);
    scheduledFrame(1000 / 60);

    expect(inputManager.consume).toHaveBeenCalledTimes(1);
    expect(loop.running).toBe(true);
    expect(loop.stop()).toBe(true);
  });

  it('keeps the W1-L1 fixture explicitly marked as non-production', () => {
    expect(DEBUG_W1_L1.id).toBe('w1-l1');
    expect(DEBUG_W1_L1.metadata.contentStatus).toBe('DEBUG_PLACEHOLDER');
    expect(DEBUG_W1_L1.metadata.productionApproved).toBe(false);
  });
});
