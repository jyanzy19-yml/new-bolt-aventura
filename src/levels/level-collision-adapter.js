import { CollisionWorld } from '../physics/collision-world.js';

function assertLevelGeometry(level) {
  if (!level || typeof level !== 'object' || Array.isArray(level)) {
    throw new TypeError('level deve ser um objeto.');
  }
  if (!level.geometry || typeof level.geometry !== 'object') {
    throw new TypeError('level.geometry é obrigatório.');
  }
  if (
    !Array.isArray(level.geometry.solids) ||
    !Array.isArray(level.geometry.oneWayPlatforms)
  ) {
    throw new TypeError('A geometria deve declarar solids e oneWayPlatforms como arrays.');
  }
}

/**
 * Adapts validated declarative level geometry into the static physics kernel.
 *
 * Call validateLevelDefinition() and load the data through LevelRuntime before
 * invoking this adapter. Runtime entities and dynamic colliders are not created
 * here; only static solids and one-way platforms are translated.
 */
export function createLevelCollisionWorld(level) {
  assertLevelGeometry(level);

  const solids = level.geometry.solids.map((collider) => ({
    ...collider,
    oneWay: false,
  }));
  const oneWayPlatforms = level.geometry.oneWayPlatforms.map((collider) => ({
    ...collider,
    oneWay: true,
  }));

  return new CollisionWorld([...solids, ...oneWayPlatforms]);
}
