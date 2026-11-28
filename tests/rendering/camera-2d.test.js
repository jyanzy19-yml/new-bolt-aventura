import { describe, expect, it } from 'vitest';
import { Camera2D } from '../../src/rendering/camera-2d.js';

function createCamera(options = {}) {
  return new Camera2D({
    viewportWidth: 800,
    viewportHeight: 450,
    worldBounds: { x: 0, y: 0, width: 2400, height: 900 },
    deadZone: { x: 300, y: 150, width: 200, height: 120 },
    ...options,
  });
}

describe('Camera2D', () => {
  it('initially centers the target and clamps to world bounds', () => {
    const camera = createCamera();
    const target = { x: 20, y: 20, width: 30, height: 40 };

    expect(camera.update(target, 1)).toEqual({ x: 0, y: 0 });
  });

  it('does not move while the target remains inside the dead zone', () => {
    const camera = createCamera();
    camera.reset({ x: 800, y: 300, width: 30, height: 40 });

    const result = camera.update(
      { x: 900, y: 320, width: 30, height: 40 },
      1,
    );

    expect(result).toEqual(camera.position);
    expect(result.x).toBe(415);
  });

  it('moves when the target exits the dead zone', () => {
    const camera = createCamera();
    camera.reset({ x: 800, y: 300, width: 30, height: 40 });

    const result = camera.update(
      { x: 1200, y: 320, width: 30, height: 40 },
      1,
    );

    expect(result.x).toBe(715);
  });

  it('applies exponential smoothing using simulation delta', () => {
    const camera = createCamera({ smoothing: 4 });
    camera.reset({ x: 800, y: 300, width: 30, height: 40 });

    const before = camera.position.x;
    const after = camera.update(
      { x: 1400, y: 320, width: 30, height: 40 },
      0.1,
    ).x;

    expect(after).toBeGreaterThan(before);
    expect(after).toBeLessThan(1030);
    expect(camera.update({ x: 1400, y: 320, width: 30, height: 40 }, 0).x).toBe(
      after,
    );
  });

  it('applies horizontal look-ahead in the direction of travel', () => {
    const camera = createCamera({ lookAheadX: 80 });
    camera.reset({ x: 800, y: 300, width: 30, height: 40 });

    const right = camera.update(
      { x: 1000, y: 320, width: 30, height: 40, vx: 100 },
      1,
    );
    expect(right.x).toBeGreaterThan(415);
  });

  it('centers worlds smaller than the viewport', () => {
    const camera = createCamera({
      worldBounds: { x: 0, y: 0, width: 400, height: 200 },
    });

    expect(camera.reset({ x: 100, y: 50, width: 30, height: 40 })).toEqual({
      x: -200,
      y: -125,
    });
  });

  it('rejects invalid viewport, dead zone, target and delta', () => {
    expect(
      () =>
        createCamera({
          viewportWidth: 0,
        }),
    ).toThrow(RangeError);
    expect(
      () =>
        createCamera({
          deadZone: { x: 700, y: 0, width: 200, height: 20 },
        }),
    ).toThrow(RangeError);

    const camera = createCamera();
    expect(() => camera.update({ x: 0, y: 0, width: 10, height: 10 }, -1)).toThrow(
      RangeError,
    );
  });
});
