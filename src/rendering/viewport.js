const DEFAULT_MAX_DPR = 2;

function assertPositiveFinite(value, name) {
  if (!Number.isFinite(value) || value <= 0) {
    throw new RangeError(`${name} deve ser um número finito maior que zero.`);
  }
}

/**
 * Calculates a centered, aspect-preserving logical viewport and backing store.
 * CSS dimensions are measured in CSS pixels; backing dimensions are physical
 * pixels and are capped by maxDpr to bound Canvas memory use.
 */
export function computeViewport({
  cssWidth,
  cssHeight,
  logicalWidth,
  logicalHeight,
  devicePixelRatio = 1,
  maxDpr = DEFAULT_MAX_DPR,
}) {
  assertPositiveFinite(cssWidth, 'cssWidth');
  assertPositiveFinite(cssHeight, 'cssHeight');
  assertPositiveFinite(logicalWidth, 'logicalWidth');
  assertPositiveFinite(logicalHeight, 'logicalHeight');
  assertPositiveFinite(devicePixelRatio, 'devicePixelRatio');
  assertPositiveFinite(maxDpr, 'maxDpr');

  const effectiveDpr = Math.min(devicePixelRatio, maxDpr);
  const scale = Math.min(cssWidth / logicalWidth, cssHeight / logicalHeight);
  const contentWidth = logicalWidth * scale;
  const contentHeight = logicalHeight * scale;

  return Object.freeze({
    cssWidth,
    cssHeight,
    logicalWidth,
    logicalHeight,
    effectiveDpr,
    backingWidth: Math.max(1, Math.round(cssWidth * effectiveDpr)),
    backingHeight: Math.max(1, Math.round(cssHeight * effectiveDpr)),
    scale,
    offsetX: (cssWidth - contentWidth) / 2,
    offsetY: (cssHeight - contentHeight) / 2,
    contentWidth,
    contentHeight,
  });
}

/**
 * Maps a browser client point into logical game coordinates.
 * The returned inside flag is false for points in letterbox/pillarbox bars.
 */
export function mapClientPointToLogical(clientX, clientY, rect, viewport) {
  if (!Number.isFinite(clientX) || !Number.isFinite(clientY)) {
    throw new TypeError('As coordenadas do ponteiro devem ser finitas.');
  }
  if (!rect || !Number.isFinite(rect.left) || !Number.isFinite(rect.top)) {
    throw new TypeError('rect precisa conter left e top finitos.');
  }
  if (!viewport || !Number.isFinite(viewport.scale) || viewport.scale <= 0) {
    throw new TypeError('viewport inválido.');
  }

  const localX = clientX - rect.left;
  const localY = clientY - rect.top;
  const x = (localX - viewport.offsetX) / viewport.scale;
  const y = (localY - viewport.offsetY) / viewport.scale;

  return {
    x,
    y,
    inside:
      localX >= viewport.offsetX &&
      localX <= viewport.offsetX + viewport.contentWidth &&
      localY >= viewport.offsetY &&
      localY <= viewport.offsetY + viewport.contentHeight,
  };
}
