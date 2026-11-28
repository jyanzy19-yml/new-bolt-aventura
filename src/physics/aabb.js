function assertFinite(value, name) {
  if (!Number.isFinite(value)) {
    throw new TypeError(`${name} deve ser finito.`);
  }
}

export function validateAabb(rect, name = 'AABB') {
  if (!rect || typeof rect !== 'object') {
    throw new TypeError(`${name} deve ser um objeto.`);
  }

  for (const key of ['x', 'y', 'width', 'height']) {
    assertFinite(rect[key], `${name}.${key}`);
  }

  if (rect.width <= 0 || rect.height <= 0) {
    throw new RangeError(`${name} precisa ter largura e altura positivas.`);
  }

  return rect;
}

export function aabbIntersects(first, second) {
  validateAabb(first, 'first');
  validateAabb(second, 'second');

  return (
    first.x < second.x + second.width &&
    first.x + first.width > second.x &&
    first.y < second.y + second.height &&
    first.y + first.height > second.y
  );
}
