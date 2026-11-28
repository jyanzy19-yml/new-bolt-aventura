import { validateLevelDefinition } from './level-definition.js';

const ID = /^[a-z][a-z0-9]*(?:-[a-z0-9]+)*$/;
const ARCHETYPES = new Set(['patrol-sentinel', 'watch-drone', 'maintenance-unit']);

function addId(ids, value, name) {
  if (typeof value !== 'string' || !ID.test(value)) {
    throw new TypeError(name + ' deve usar ID kebab-case.');
  }
  if (ids.has(value)) throw new Error('ID duplicado em W1-L2: ' + value);
  ids.add(value);
}

function text(value, name) {
  if (typeof value !== 'string' || value.trim() === '') {
    throw new TypeError(name + ' deve ser texto não vazio.');
  }
}

function rect(value, bounds, name) {
  if (!value || typeof value !== 'object') throw new TypeError(name + ' deve ser retângulo.');
  for (const key of ['x', 'y', 'width', 'height']) {
    if (!Number.isFinite(value[key])) throw new TypeError(name + '.' + key + ' deve ser finito.');
  }
  if (value.width <= 0 || value.height <= 0 ||
      value.x < bounds.x || value.y < bounds.y ||
      value.x + value.width > bounds.x + bounds.width ||
      value.y + value.height > bounds.y + bounds.height) {
    throw new RangeError(name + ' está fora dos limites de W1-L2.');
  }
}

export function validateW1L2Content(level) {
  validateLevelDefinition(level);
  if (level.id !== 'w1-l2' || level.worldId !== 'cybercore') {
    throw new TypeError('Pacote inválido: esperado w1-l2 / cybercore.');
  }
  const ids = new Set();
  for (const collection of [
    level.geometry.solids, level.geometry.oneWayPlatforms,
    level.checkpoints, level.exits,
  ]) for (const item of collection) addId(ids, item.id, 'geometry.id');

  if (!Array.isArray(level.objectives) || level.objectives.length !== 4) {
    throw new TypeError('W1-L2 deve possuir quatro objetivos de progressão.');
  }
  let threshold = level.bounds.x;
  for (const [index, item] of level.objectives.entries()) {
    addId(ids, item.id, 'objectives[' + index + '].id');
    text(item.label, 'objectives[' + index + '].label');
    if (!Number.isFinite(item.thresholdX) || item.thresholdX <= threshold ||
        item.thresholdX > level.bounds.x + level.bounds.width) {
      throw new RangeError('Objetivos W1-L2 devem ter thresholds crescentes.');
    }
    threshold = item.thresholdX;
  }

  if (!Array.isArray(level.interactables) || level.interactables.length !== 2) {
    throw new TypeError('W1-L2 deve declarar cache opcional e repetidor.');
  }
  for (const [index, item] of level.interactables.entries()) {
    addId(ids, item.id, 'interactables[' + index + '].id');
    if (!['secret', 'objective'].includes(item.kind)) {
      throw new RangeError('Tipo de interactable desconhecido: ' + item.kind);
    }
    rect(item, level.bounds, 'interactables[' + index + ']');
    text(item.prompt, 'interactables[' + index + '].prompt');
  }

  if (!Array.isArray(level.enemies) || level.enemies.length < 3) {
    throw new TypeError('W1-L2 deve conter pelo menos três instâncias de inimigos.');
  }
  for (const [index, enemy] of level.enemies.entries()) {
    addId(ids, enemy.id, 'enemies[' + index + '].id');
    rect(enemy, level.bounds, 'enemies[' + index + ']');
    if (!ARCHETYPES.has(enemy.archetype)) {
      throw new RangeError('Arquétipo não autorizado em W1-L2: ' + enemy.archetype);
    }
    for (const key of ['patrolMin', 'patrolMax', 'speed', 'health', 'fireInterval', 'projectileSpeed']) {
      if (!Number.isFinite(enemy[key])) throw new TypeError('enemies[' + index + '].' + key + ' deve ser finito.');
    }
    if (enemy.patrolMin < level.bounds.x ||
        enemy.patrolMax > level.bounds.x + level.bounds.width ||
        enemy.patrolMax <= enemy.patrolMin ||
        enemy.x < enemy.patrolMin ||
        enemy.x + enemy.width > enemy.patrolMax ||
        enemy.speed < 0 || enemy.health <= 0 ||
        enemy.fireInterval < 0 || enemy.projectileSpeed < 0) {
      throw new RangeError('Parâmetros de patrulha/combate inválidos em ' + enemy.id + '.');
    }
  }

  if (!Array.isArray(level.landmarks) || level.landmarks.length < 4) {
    throw new TypeError('W1-L2 precisa declarar landmarks para orientar a exploração.');
  }
  for (const [index, item] of level.landmarks.entries()) {
    addId(ids, item.id, 'landmarks[' + index + '].id');
    rect(item, level.bounds, 'landmarks[' + index + ']');
    text(item.kind, 'landmarks[' + index + '].kind');
  }
  return level;
}
