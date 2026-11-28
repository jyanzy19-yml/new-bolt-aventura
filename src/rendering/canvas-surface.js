import { computeViewport, mapClientPointToLogical } from './viewport.js';

/**
 * Owns a Canvas 2D backing store while drawing in stable logical coordinates.
 * CSS is responsible for the element's layout size; resize() receives its
 * measured CSS dimensions and applies the bounded physical-pixel resolution.
 */
export class CanvasSurface {
  #canvas;
  #context;
  #logicalWidth;
  #logicalHeight;
  #maxDpr;
  #viewport = null;

  constructor(canvas, { logicalWidth = 800, logicalHeight = 450, maxDpr = 2 } = {}) {
    if (!canvas || typeof canvas.getContext !== 'function') {
      throw new TypeError('CanvasSurface exige um elemento Canvas válido.');
    }

    const context = canvas.getContext('2d');
    if (!context) {
      throw new Error('Não foi possível obter o contexto Canvas 2D.');
    }

    this.#canvas = canvas;
    this.#context = context;
    this.#logicalWidth = logicalWidth;
    this.#logicalHeight = logicalHeight;
    this.#maxDpr = maxDpr;

    // Validate dimensions and DPR policy at construction time.
    computeViewport({
      cssWidth: 1,
      cssHeight: 1,
      logicalWidth,
      logicalHeight,
      devicePixelRatio: 1,
      maxDpr,
    });
  }

  get canvas() {
    return this.#canvas;
  }

  get context() {
    return this.#context;
  }

  get viewport() {
    return this.#viewport;
  }

  resize(cssWidth, cssHeight, devicePixelRatio = 1) {
    const viewport = computeViewport({
      cssWidth,
      cssHeight,
      logicalWidth: this.#logicalWidth,
      logicalHeight: this.#logicalHeight,
      devicePixelRatio,
      maxDpr: this.#maxDpr,
    });

    this.#canvas.width = viewport.backingWidth;
    this.#canvas.height = viewport.backingHeight;

    const backingScaleX = this.#canvas.width / cssWidth;
    const backingScaleY = this.#canvas.height / cssHeight;
    const transformScaleX = viewport.scale * backingScaleX;
    const transformScaleY = viewport.scale * backingScaleY;

    this.#context.setTransform(
      transformScaleX,
      0,
      0,
      transformScaleY,
      viewport.offsetX * backingScaleX,
      viewport.offsetY * backingScaleY,
    );

    this.#viewport = viewport;
    return viewport;
  }

  clear(color = '#000000') {
    if (!this.#viewport) {
      throw new Error('CanvasSurface precisa ser redimensionado antes de limpar.');
    }

    this.#context.save();
    this.#context.setTransform(1, 0, 0, 1, 0, 0);
    this.#context.fillStyle = color;
    this.#context.fillRect(0, 0, this.#canvas.width, this.#canvas.height);
    this.#context.restore();
  }

  mapClientPoint(clientX, clientY) {
    if (!this.#viewport) {
      throw new Error('CanvasSurface precisa ser redimensionado antes de mapear input.');
    }

    return mapClientPointToLogical(
      clientX,
      clientY,
      this.#canvas.getBoundingClientRect(),
      this.#viewport,
    );
  }
}
