/** Clamp a finite numeric value to an inclusive range. */
export function clamp(value, min, max) {
  if (![value, min, max].every(Number.isFinite)) {
    throw new TypeError('clamp espera somente valores numéricos finitos.');
  }

  if (min > max) {
    throw new RangeError('O limite mínimo não pode superar o máximo.');
  }

  return Math.min(max, Math.max(min, value));
}
