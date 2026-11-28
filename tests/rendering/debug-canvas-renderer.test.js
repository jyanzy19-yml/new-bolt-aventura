import { describe, expect, it, vi } from 'vitest';
import { DebugCanvasRenderer } from '../../src/rendering/debug-canvas-renderer.js';

function createSurface() {
  const context = {
    fillRect: vi.fn(),
    strokeRect: vi.fn(),
    save: vi.fn(),
    restore: vi.fn(),
    translate: vi.fn(),
    fillStyle: '',
    strokeStyle: '',
  };
  const surface = {
    clear: vi.fn(),
    context,
  };

  return { surface, context };
}

function createFrame(overrides = {}) {
  return {
    level: {
      geometry: {
        solids: [{ id: 'floor', x: 0, y: 400, width: 800, height: 50 }],
        oneWayPlatforms: [
          { id: 'upper', x: 200, y: 300, width: 100, height: 10 },
        ],
      },
      checkpoints: [{ id: 'cp-1', x: 400, y: 380 }],
      exits: [{ id: 'exit', x: 760, y: 340, width: 24, height: 60 }],
    },
    player: {
      body: { x: 48, y: 354, width: 30, height: 46 },
      facing: 1,
      state: 'grounded',
    },
    camera: { x: 0, y: 0 },
    ...overrides,
  };
}

describe('DebugCanvasRenderer', () => {
  it('draws level geometry, checkpoints, exits and the player in logical world space', () => {
    const { surface, context } = createSurface();
    const renderer = new DebugCanvasRenderer(surface);

    const result = renderer.render(createFrame());

    expect(surface.clear).toHaveBeenCalledWith('#080d18');
    expect(context.save).toHaveBeenCalledTimes(1);
    expect(context.translate).toHaveBeenCalledWith(0, 0);
    expect(context.fillRect).toHaveBeenCalledTimes(5);
    expect(context.strokeRect).toHaveBeenCalledTimes(2);
    expect(context.restore).toHaveBeenCalledTimes(1);
    expect(result).toEqual({
      solids: 1,
      oneWayPlatforms: 1,
      checkpoints: 1,
      exits: 1,
      player: 1,
    });
  });

  it('applies camera translation and custom clear color', () => {
    const { surface, context } = createSurface();
    const renderer = new DebugCanvasRenderer(surface);

    renderer.render(createFrame({
      camera: { x: 120, y: 40 },
      clearColor: '#101820',
    }));

    expect(surface.clear).toHaveBeenCalledWith('#101820');
    expect(context.translate).toHaveBeenCalledWith(-120, -40);
  });

  it('marks Dash state with the diagnostic dash color', () => {
    const { surface, context } = createSurface();
    const renderer = new DebugCanvasRenderer(surface);

    renderer.render(createFrame({
      player: {
        body: { x: 48, y: 354, width: 30, height: 46 },
        facing: -1,
        state: 'dashing',
      },
    }));

    expect(context.fillStyle).toBe('#58c7ff');
    expect(context.fillRect).toHaveBeenLastCalledWith(49, 365.5, 4, 4);
  });

  it('restores the context when drawing throws', () => {
    const { surface, context } = createSurface();
    context.fillRect.mockImplementationOnce(() => {
      throw new Error('render failure');
    });
    const renderer = new DebugCanvasRenderer(surface);

    expect(() => renderer.render(createFrame())).toThrow('render failure');
    expect(context.restore).toHaveBeenCalledTimes(1);
  });

  it('rejects invalid render input and incompatible surfaces', () => {
    expect(() => new DebugCanvasRenderer(null)).toThrow(TypeError);

    const { surface } = createSurface();
    const renderer = new DebugCanvasRenderer(surface);

    expect(() => renderer.render(createFrame({ camera: { x: Number.NaN, y: 0 } })))
      .toThrow(TypeError);
    expect(() => renderer.render(createFrame({
      player: {
        body: { x: 0, y: 0, width: 0, height: 10 },
        facing: 1,
        state: 'grounded',
      },
    }))).toThrow(RangeError);
  });
});
