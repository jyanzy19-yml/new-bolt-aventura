import { describe, expect, it } from 'vitest';
import { aabbIntersects, validateAabb } from '../../src/physics/aabb.js';

describe('AABB primitives', () => {
  it('detects overlap but treats touching edges as non-intersecting', () => {
    const first = { x: 0, y: 0, width: 10, height: 10 };

    expect(
      aabbIntersects(first, { x: 9, y: 9, width: 10, height: 10 }),
    ).toBe(true);
    expect(
      aabbIntersects(first, { x: 10, y: 0, width: 10, height: 10 }),
    ).toBe(false);
  });

  it('rejects invalid rectangles', () => {
    expect(() =>
      validateAabb({ x: 0, y: 0, width: 0, height: 10 }),
    ).toThrow(RangeError);
    expect(() =>
      validateAabb({ x: 0, y: Number.NaN, width: 10, height: 10 }),
    ).toThrow(TypeError);
  });
});
