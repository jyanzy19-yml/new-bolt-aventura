import { describe, expect, it } from 'vitest';
import { computeViewport, mapClientPointToLogical } from '../../src/rendering/viewport.js';

describe('computeViewport', () => {
  it('fits a landscape logical viewport without stretching', () => {
    const viewport = computeViewport({
      cssWidth: 1000,
      cssHeight: 600,
      logicalWidth: 800,
      logicalHeight: 450,
    });

    expect(viewport.scale).toBe(1.25);
    expect(viewport.contentWidth).toBe(1000);
    expect(viewport.contentHeight).toBe(562.5);
    expect(viewport.offsetX).toBe(0);
    expect(viewport.offsetY).toBe(18.75);
  });

  it('centers the logical viewport in a portrait container', () => {
    const viewport = computeViewport({
      cssWidth: 400,
      cssHeight: 800,
      logicalWidth: 800,
      logicalHeight: 450,
    });

    expect(viewport.scale).toBe(0.5);
    expect(viewport.contentWidth).toBe(400);
    expect(viewport.contentHeight).toBe(225);
    expect(viewport.offsetY).toBe(287.5);
  });

  it('caps device pixel ratio before allocating the backing store', () => {
    const viewport = computeViewport({
      cssWidth: 800,
      cssHeight: 450,
      logicalWidth: 800,
      logicalHeight: 450,
      devicePixelRatio: 3,
      maxDpr: 1.5,
    });

    expect(viewport.effectiveDpr).toBe(1.5);
    expect(viewport.backingWidth).toBe(1200);
    expect(viewport.backingHeight).toBe(675);
  });

  it('rejects zero, negative and non-finite dimensions', () => {
    expect(() =>
      computeViewport({
        cssWidth: 0,
        cssHeight: 450,
        logicalWidth: 800,
        logicalHeight: 450,
      }),
    ).toThrow(RangeError);
    expect(() =>
      computeViewport({
        cssWidth: 800,
        cssHeight: 450,
        logicalWidth: -1,
        logicalHeight: 450,
      }),
    ).toThrow(RangeError);
    expect(() =>
      computeViewport({
        cssWidth: 800,
        cssHeight: 450,
        logicalWidth: 800,
        logicalHeight: 450,
        devicePixelRatio: Number.NaN,
      }),
    ).toThrow(RangeError);
  });
});

describe('mapClientPointToLogical', () => {
  const viewport = computeViewport({
    cssWidth: 1000,
    cssHeight: 600,
    logicalWidth: 800,
    logicalHeight: 450,
  });

  it('maps client coordinates into logical game coordinates', () => {
    const point = mapClientPointToLogical(510, 318.75, { left: 10, top: 20 }, viewport);

    expect(point).toEqual({ x: 400, y: 240, inside: true });
  });

  it('marks letterbox bars as outside the logical viewport', () => {
    const point = mapClientPointToLogical(510, 25, { left: 10, top: 20 }, viewport);

    expect(point.inside).toBe(false);
  });

  it('rejects invalid pointer and rectangle values', () => {
    expect(() =>
      mapClientPointToLogical(Number.NaN, 10, { left: 0, top: 0 }, viewport),
    ).toThrow(TypeError);
    expect(() => mapClientPointToLogical(10, 10, {}, viewport)).toThrow(TypeError);
  });
});
