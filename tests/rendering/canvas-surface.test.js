import { describe, expect, it, vi } from 'vitest';
import { CanvasSurface } from '../../src/rendering/canvas-surface.js';

function createCanvas() {
  const context = {
    fillRect: vi.fn(),
    restore: vi.fn(),
    save: vi.fn(),
    setTransform: vi.fn(),
    fillStyle: '',
  };
  const canvas = {
    width: 0,
    height: 0,
    getContext: vi.fn(() => context),
    getBoundingClientRect: () => ({
      left: 10,
      top: 20,
      width: 800,
      height: 450,
    }),
  };

  return { canvas, context };
}

describe('CanvasSurface', () => {
  it('creates a 2D context and allocates a DPR-capped backing store', () => {
    const { canvas, context } = createCanvas();
    const surface = new CanvasSurface(canvas, {
      logicalWidth: 800,
      logicalHeight: 450,
      maxDpr: 1.5,
    });

    const viewport = surface.resize(800, 450, 3);

    expect(canvas.getContext).toHaveBeenCalledWith('2d');
    expect(canvas.width).toBe(1200);
    expect(canvas.height).toBe(675);
    expect(context.setTransform).toHaveBeenCalledWith(1.5, 0, 0, 1.5, 0, 0);
    expect(viewport.effectiveDpr).toBe(1.5);
  });

  it('clears the full backing store without losing the logical transform', () => {
    const { canvas, context } = createCanvas();
    const surface = new CanvasSurface(canvas);
    surface.resize(800, 450, 1);

    surface.clear('#123456');

    expect(context.save).toHaveBeenCalledTimes(1);
    expect(context.setTransform).toHaveBeenLastCalledWith(1, 0, 0, 1, 0, 0);
    expect(context.fillRect).toHaveBeenCalledWith(0, 0, 800, 450);
    expect(context.restore).toHaveBeenCalledTimes(1);
  });

  it('maps pointer coordinates using the current canvas bounds', () => {
    const { canvas } = createCanvas();
    const surface = new CanvasSurface(canvas);
    surface.resize(800, 450, 1);

    expect(surface.mapClientPoint(410, 245)).toEqual({
      x: 400,
      y: 225,
      inside: true,
    });
  });

  it('requires a valid canvas and a successful 2D context', () => {
    expect(() => new CanvasSurface(null)).toThrow(TypeError);
    expect(() => new CanvasSurface({ getContext: () => null })).toThrow(
      'Não foi possível obter o contexto Canvas 2D.',
    );
  });

  it('requires resize before clear or pointer mapping', () => {
    const { canvas } = createCanvas();
    const surface = new CanvasSurface(canvas);

    expect(() => surface.clear()).toThrow('precisa ser redimensionado');
    expect(() => surface.mapClientPoint(10, 20)).toThrow(
      'precisa ser redimensionado',
    );
  });
});
