import { describe, expect, it } from 'vitest';
import { CollisionWorld } from '../../src/physics/collision-world.js';

const body = { x: 10, y: 10, width: 10, height: 10 };

describe('CollisionWorld', () => {
  it('resolves downward floor crossings without tunneling', () => {
    const world = new CollisionWorld([
      { id: 'floor', x: 0, y: 100, width: 200, height: 20 },
    ]);

    expect(world.move({ ...body, y: 0 }, 0, 500)).toEqual({
      x: 10,
      y: 90,
      collidedX: false,
      collidedY: true,
      grounded: true,
      hitCeiling: false,
    });
  });

  it('resolves upward ceiling and horizontal wall crossings', () => {
    const world = new CollisionWorld([
      { id: 'ceiling', x: 0, y: 0, width: 200, height: 10 },
      { id: 'wall', x: 80, y: 0, width: 10, height: 200 },
    ]);

    expect(world.move({ ...body, y: 20 }, 0, -50)).toMatchObject({
      y: 10,
      collidedY: true,
      grounded: false,
      hitCeiling: true,
    });
    expect(world.move({ ...body, x: 0 }, 100, 0)).toMatchObject({
      x: 70,
      collidedX: true,
    });
  });

  it('resolves against the nearest of multiple colliders', () => {
    const world = new CollisionWorld([
      { id: 'far-wall', x: 80, y: 0, width: 10, height: 100 },
      { id: 'near-wall', x: 50, y: 0, width: 10, height: 100 },
    ]);

    expect(world.move(body, 100, 0)).toMatchObject({
      x: 40,
      collidedX: true,
    });
  });

  it('supports one-way platforms only on downward crossing', () => {
    const world = new CollisionWorld([
      { id: 'one-way', x: 0, y: 50, width: 100, height: 8, oneWay: true },
    ]);

    expect(world.move({ ...body, y: 0 }, 0, 100)).toMatchObject({
      y: 40,
      grounded: true,
      collidedY: true,
    });
    expect(world.move({ ...body, y: 60 }, 0, -30)).toMatchObject({
      y: 30,
      collidedY: false,
    });
    expect(world.move({ ...body, y: 0 }, 0, 100, { dropThrough: true })).toMatchObject({
      y: 100,
      grounded: false,
      collidedY: false,
    });
  });

  it('probes ground without changing the caller body', () => {
    const world = new CollisionWorld([
      { id: 'floor', x: 0, y: 20, width: 100, height: 10 },
    ]);
    const standingBody = { x: 10, y: 10, width: 10, height: 10 };

    expect(world.probeGround(standingBody, 2)).toBe(true);
    expect(standingBody).toEqual({ x: 10, y: 10, width: 10, height: 10 });
  });

  it('adds and removes stable collider ids', () => {
    const world = new CollisionWorld();
    world.addCollider({ id: 'platform', x: 0, y: 20, width: 100, height: 10 });

    expect(world.colliders).toHaveLength(1);
    expect(world.removeCollider('platform')).toBe(true);
    expect(world.removeCollider('platform')).toBe(false);
    expect(world.colliders).toHaveLength(0);
  });

  it('rejects invalid colliders, bodies and movement values', () => {
    expect(
      () => new CollisionWorld([{ id: 'bad', x: 0, y: 0, width: 0, height: 10 }]),
    ).toThrow(RangeError);
    expect(
      () => new CollisionWorld([{ id: 'a', x: 0, y: 0, width: 10, height: 10 }, { id: 'a', x: 0, y: 0, width: 10, height: 10 }]),
    ).toThrow('Collider duplicado');
    const world = new CollisionWorld();
    expect(() => world.move(body, Number.NaN, 0)).toThrow(TypeError);
    expect(() => world.probeGround(body, 0)).toThrow(RangeError);
  });
});
