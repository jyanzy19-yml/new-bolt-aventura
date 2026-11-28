import { describe, expect, it } from 'vitest';
import { createLevelCollisionWorld } from '../../src/levels/level-collision-adapter.js';

function makeLevel() {
  return {
    id: 'w1-l1',
    geometry: {
      solids: [
        { id: 'floor', x: 0, y: 400, width: 800, height: 50 },
        { id: 'left-wall', x: 0, y: 0, width: 20, height: 400 },
      ],
      oneWayPlatforms: [
        { id: 'upper-platform', x: 180, y: 300, width: 120, height: 12 },
      ],
    },
  };
}

describe('createLevelCollisionWorld', () => {
  it('maps static solids and one-way platforms into the physics kernel', () => {
    const world = createLevelCollisionWorld(makeLevel());

    expect(world.colliders).toEqual([
      { id: 'floor', x: 0, y: 400, width: 800, height: 50, oneWay: false },
      { id: 'left-wall', x: 0, y: 0, width: 20, height: 400, oneWay: false },
      { id: 'upper-platform', x: 180, y: 300, width: 120, height: 12, oneWay: true },
    ]);
  });

  it('supports normal collision and one-way landing semantics', () => {
    const world = createLevelCollisionWorld(makeLevel());

    expect(
      world.move({ x: 190, y: 250, width: 10, height: 10 }, 0, 100).grounded,
    ).toBe(true);
    expect(
      world.move({ x: 190, y: 320, width: 10, height: 10 }, 0, -40).collidedY,
    ).toBe(false);
    expect(
      world.move({ x: 30, y: 350, width: 10, height: 10 }, -40, 0).collidedX,
    ).toBe(true);
  });

  it('rejects malformed geometry before creating a world', () => {
    expect(() => createLevelCollisionWorld(null)).toThrow(TypeError);
    expect(() => createLevelCollisionWorld({ geometry: {} })).toThrow(TypeError);
    expect(() => createLevelCollisionWorld({
      geometry: {
        solids: [{ id: 'bad', x: 0, y: 0, width: 0, height: 10 }],
        oneWayPlatforms: [],
      },
    })).toThrow(RangeError);
  });

  it('rejects duplicate IDs across solid and one-way geometry', () => {
    const level = makeLevel();
    level.geometry.oneWayPlatforms[0].id = 'floor';

    expect(() => createLevelCollisionWorld(level)).toThrow('Collider duplicado');
  });

  it('does not mutate source level geometry', () => {
    const level = makeLevel();
    const before = structuredClone(level);

    createLevelCollisionWorld(level);

    expect(level).toEqual(before);
  });
});
