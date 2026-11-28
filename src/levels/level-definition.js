import { CollisionWorld } from '../physics/collision-world.js';
import { validateAabb } from '../physics/aabb.js';

export const LEVEL_SCHEMA_VERSION = 1;

const LEVEL_ID_PATTERN = /^w[1-7]-l[1-6]$/;
const STABLE_ID_PATTERN = /^[a-z][a-z0-9]*(?:-[a-z0-9]+)*$/;

function assertRecord(value, name) {
  if (!value || typeof value !== 'object' || Array.isArray(value)) {
    throw new TypeError(`${name} deve ser um objeto.`);
  }
}

function assertText(value, name) {
  if (typeof value !== 'string' || value.trim() === '') {
    throw new TypeError(`${name} deve ser uma string não vazia.`);
  }
}

function assertStableId(value, name) {
  assertText(value, name);
  if (!STABLE_ID_PATTERN.test(value)) {
    throw new TypeError(`${name} deve usar um identificador estável em kebab-case.`);
  }
}

function assertPoint(point, name, bounds) {
  assertRecord(point, name);
  if (!Number.isFinite(point.x) || !Number.isFinite(point.y)) {
    throw new TypeError(`${name} precisa conter coordenadas finitas.`);
  }
  if (
    point.x < bounds.x ||
    point.x > bounds.x + bounds.width ||
    point.y < bounds.y ||
    point.y > bounds.y + bounds.height
  ) {
    throw new RangeError(`${name} está fora dos limites da fase.`);
  }
}

function assertInsideBounds(rect, name, bounds) {
  validateAabb(rect, name);
  if (
    rect.x < bounds.x ||
    rect.y < bounds.y ||
    rect.x + rect.width > bounds.x + bounds.width ||
    rect.y + rect.height > bounds.y + bounds.height
  ) {
    throw new RangeError(`${name} está fora dos limites da fase.`);
  }
}

/**
 * Validates the engine-neutral, versioned level data contract.
 * Unknown metadata is preserved; runtime-critical geometry and IDs are strict.
 */
export function validateLevelDefinition(level) {
  assertRecord(level, 'level');

  if (level.schemaVersion !== LEVEL_SCHEMA_VERSION) {
    throw new RangeError(
      `Versão de fase não suportada: ${level.schemaVersion}; esperado ${LEVEL_SCHEMA_VERSION}.`,
    );
  }
  if (typeof level.id !== 'string' || !LEVEL_ID_PATTERN.test(level.id)) {
    throw new TypeError('level.id deve seguir o padrão w1-l1 até w7-l6.');
  }
  assertStableId(level.worldId, 'level.worldId');
  assertText(level.title, 'level.title');

  assertRecord(level.bounds, 'level.bounds');
  validateAabb(level.bounds, 'level.bounds');
  assertPoint(level.spawn, 'level.spawn', level.bounds);

  assertRecord(level.geometry, 'level.geometry');
  if (
    !Array.isArray(level.geometry.solids) ||
    !Array.isArray(level.geometry.oneWayPlatforms)
  ) {
    throw new TypeError('geometry.solids e geometry.oneWayPlatforms devem ser arrays.');
  }
  if (!Array.isArray(level.checkpoints) || !Array.isArray(level.exits)) {
    throw new TypeError('checkpoints e exits devem ser arrays.');
  }

  const ids = new Set();
  const registerId = (id, name) => {
    assertStableId(id, name);
    if (ids.has(id)) throw new Error(`ID duplicado na fase: ${id}`);
    ids.add(id);
  };

  for (const [index, solid] of level.geometry.solids.entries()) {
    assertRecord(solid, `geometry.solids[${index}]`);
    registerId(solid.id, `geometry.solids[${index}].id`);
    assertInsideBounds(solid, `solid ${solid.id}`, level.bounds);
  }

  for (const [index, platform] of level.geometry.oneWayPlatforms.entries()) {
    assertRecord(platform, `geometry.oneWayPlatforms[${index}]`);
    registerId(platform.id, `geometry.oneWayPlatforms[${index}].id`);
    assertInsideBounds(platform, `oneWay platform ${platform.id}`, level.bounds);
  }

  for (const [index, checkpoint] of level.checkpoints.entries()) {
    assertRecord(checkpoint, `checkpoints[${index}]`);
    registerId(checkpoint.id, `checkpoints[${index}].id`);
    assertPoint(checkpoint, `checkpoint ${checkpoint.id}`, level.bounds);
  }

  for (const [index, exit] of level.exits.entries()) {
    assertRecord(exit, `exits[${index}]`);
    registerId(exit.id, `exits[${index}].id`);
    assertInsideBounds(exit, `exit ${exit.id}`, level.bounds);
    if (typeof exit.targetLevelId !== 'string' || !LEVEL_ID_PATTERN.test(exit.targetLevelId)) {
      throw new TypeError(`exit ${exit.id} precisa de targetLevelId válido.`);
    }
  }

  return level;
}

export function createCollisionWorldFromLevel(level) {
  validateLevelDefinition(level);

  const solids = level.geometry.solids.map((rect) => ({
    ...rect,
    oneWay: false,
  }));
  const oneWayPlatforms = level.geometry.oneWayPlatforms.map((rect) => ({
    ...rect,
    oneWay: true,
  }));

  return new CollisionWorld([...solids, ...oneWayPlatforms]);
}
