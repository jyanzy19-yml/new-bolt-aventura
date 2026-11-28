import { validateLevelDefinition } from './level-definition.js';

const STABLE_ID = /^[a-z][a-z0-9]*(?:-[a-z0-9]+)*$/;

function assertId(value, name, ids) {
  if (typeof value !== 'string' || !STABLE_ID.test(value)) {
    throw new TypeError(name + ' deve ser um ID estável em kebab-case.');
  }
  if (ids.has(value)) throw new Error('ID duplicado no pacote W1-L1: ' + value);
  ids.add(value);
}

function assertText(value, name) {
  if (typeof value !== 'string' || value.trim() === '') {
    throw new TypeError(name + ' deve ser texto não vazio.');
  }
}

function assertRectInside(rect, bounds, name) {
  if (!rect || typeof rect !== 'object') throw new TypeError(name + ' deve ser um retângulo.');
  for (const key of ['x', 'y', 'width', 'height']) {
    if (!Number.isFinite(rect[key])) throw new TypeError(name + '.' + key + ' deve ser finito.');
  }
  if (
    rect.width <= 0 || rect.height <= 0 ||
    rect.x < bounds.x || rect.y < bounds.y ||
    rect.x + rect.width > bounds.x + bounds.width ||
    rect.y + rect.height > bounds.y + bounds.height
  ) {
    throw new RangeError(name + ' está fora dos limites da fase.');
  }
}

export function validateW1L1Content(level) {
  validateLevelDefinition(level);
  const ids = new Set();

  for (const collection of [
    level.geometry.solids,
    level.geometry.oneWayPlatforms,
    level.checkpoints,
    level.exits,
  ]) {
    for (const item of collection) assertId(item.id, 'content.id', ids);
  }

  if (!Array.isArray(level.sections) || level.sections.length !== 4) {
    throw new TypeError('W1-L1 deve declarar exatamente quatro segmentos.');
  }
  let expectedStart = level.bounds.x;
  for (const [index, section] of level.sections.entries()) {
    assertId(section.id, 'sections[' + index + '].id', ids);
    assertText(section.title, 'sections[' + index + '].title');
    if (
      !Number.isFinite(section.startX) ||
      !Number.isFinite(section.endX) ||
      section.startX !== expectedStart ||
      section.endX <= section.startX ||
      section.endX > level.bounds.x + level.bounds.width
    ) {
      throw new RangeError('Os segmentos da W1-L1 devem ser contíguos e cobrir o percurso em ordem.');
    }
    expectedStart = section.endX;
  }
  if (expectedStart !== level.bounds.x + level.bounds.width) {
    throw new RangeError('Os segmentos da W1-L1 devem cobrir toda a extensão da fase.');
  }

  if (!Array.isArray(level.objectives) || level.objectives.length < 2) {
    throw new TypeError('W1-L1 precisa de uma sequência de objetivos.');
  }
  let previousThreshold = level.bounds.x;
  for (const [index, objective] of level.objectives.entries()) {
    assertId(objective.id, 'objectives[' + index + '].id', ids);
    assertText(objective.label, 'objectives[' + index + '].label');
    if (
      !Number.isFinite(objective.thresholdX) ||
      objective.thresholdX <= previousThreshold ||
      objective.thresholdX > level.bounds.x + level.bounds.width
    ) {
      throw new RangeError('Os gatilhos dos objetivos devem ser crescentes e estar dentro da fase.');
    }
    previousThreshold = objective.thresholdX;
  }

  if (!Array.isArray(level.interactables) || level.interactables.length < 1) {
    throw new TypeError('W1-L1 precisa declarar seus elementos interativos.');
  }
  for (const [index, item] of level.interactables.entries()) {
    assertId(item.id, 'interactables[' + index + '].id', ids);
    if (!['secret', 'completion'].includes(item.kind)) {
      throw new RangeError('Tipo de interação W1-L1 desconhecido: ' + item.kind);
    }
    assertRectInside(item, level.bounds, 'interactable ' + item.id);
    assertText(item.prompt, 'interactable ' + item.id + '.prompt');
  }

  if (!Array.isArray(level.landmarks) || level.landmarks.length < 1) {
    throw new TypeError('W1-L1 precisa declarar landmarks visuais.');
  }
  for (const [index, landmark] of level.landmarks.entries()) {
    assertId(landmark.id, 'landmarks[' + index + '].id', ids);
    assertText(landmark.kind, 'landmark ' + landmark.id + '.kind');
    assertRectInside(landmark, level.bounds, 'landmark ' + landmark.id);
  }

  const enemy = level.enemy;
  if (!enemy || typeof enemy !== 'object') throw new TypeError('W1-L1 precisa declarar a unidade de manutenção.');
  assertId(enemy.id, 'enemy.id', ids);
  assertRectInside(enemy, level.bounds, 'enemy ' + enemy.id);
  if (
    !Number.isFinite(enemy.patrolMin) ||
    !Number.isFinite(enemy.patrolMax) ||
    !Number.isFinite(enemy.speed) ||
    enemy.speed <= 0 ||
    enemy.patrolMin < level.bounds.x ||
    enemy.patrolMax > level.bounds.x + level.bounds.width ||
    enemy.patrolMax <= enemy.patrolMin ||
    enemy.x < enemy.patrolMin ||
    enemy.x + enemy.width > enemy.patrolMax
  ) {
    throw new RangeError('A patrulha da unidade de manutenção possui limites inválidos.');
  }

  return level;
}
