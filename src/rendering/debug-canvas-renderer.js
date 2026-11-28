import { validateAabb } from '../physics/aabb.js';

const COLORS = Object.freeze({
  solid: '#29445f',
  solidOutline: '#6c91b5',
  oneWay: '#55a7ff',
  checkpoint: '#f5d66b',
  exit: '#70e0b4',
  player: '#e9f2ff',
  playerOutline: '#58c7ff',
  dash: '#f4bd54',
});

function assertPoint(point, name) {
  if (
    !point ||
    typeof point !== 'object' ||
    !Number.isFinite(point.x) ||
    !Number.isFinite(point.y)
  ) {
    throw new TypeError(`${name} precisa conter coordenadas finitas.`);
  }
}

function validateRenderInput({ level, player, camera }) {
  if (!level || typeof level !== 'object' || !level.geometry) {
    throw new TypeError('level.geometry é obrigatório.');
  }
  if (
    !Array.isArray(level.geometry.solids) ||
    !Array.isArray(level.geometry.oneWayPlatforms)
  ) {
    throw new TypeError('A geometria precisa conter solids e oneWayPlatforms.');
  }
  if (!Array.isArray(level.checkpoints ?? []) || !Array.isArray(level.exits ?? [])) {
    throw new TypeError('checkpoints e exits devem ser arrays.');
  }
  if (!player || typeof player !== 'object') {
    throw new TypeError('player é obrigatório.');
  }
  validateAabb(player.body, 'player.body');
  if (player.facing !== -1 && player.facing !== 1) {
    throw new RangeError('player.facing deve ser -1 ou 1.');
  }
  assertPoint(camera, 'camera');

  for (const [index, solid] of level.geometry.solids.entries()) {
    validateAabb(solid, `solid[${index}]`);
  }
  for (const [index, platform] of level.geometry.oneWayPlatforms.entries()) {
    validateAabb(platform, `oneWayPlatform[${index}]`);
  }
  for (const [index, checkpoint] of (level.checkpoints ?? []).entries()) {
    assertPoint(checkpoint, `checkpoint[${index}]`);
  }
  for (const [index, exit] of (level.exits ?? []).entries()) {
    validateAabb(exit, `exit[${index}]`);
  }
}

/**
 * Development-only geometric renderer. It intentionally draws primitive
 * diagnostics rather than final approved character/world art.
 */
export class DebugCanvasRenderer {
  #surface;
  #context;

  constructor(surface) {
    if (
      !surface ||
      typeof surface.clear !== 'function' ||
      !surface.context ||
      typeof surface.context.save !== 'function' ||
      typeof surface.context.restore !== 'function' ||
      typeof surface.context.translate !== 'function' ||
      typeof surface.context.fillRect !== 'function' ||
      typeof surface.context.strokeRect !== 'function'
    ) {
      throw new TypeError('DebugCanvasRenderer exige uma CanvasSurface compatível.');
    }

    this.#surface = surface;
    this.#context = surface.context;
  }

  render({
    level,
    player,
    camera = { x: 0, y: 0 },
    clearColor = '#080d18',
  }) {
    validateRenderInput({ level, player, camera });
    if (typeof clearColor !== 'string' || clearColor.trim() === '') {
      throw new TypeError('clearColor deve ser uma string não vazia.');
    }

    this.#surface.clear(clearColor);
    const context = this.#context;

    context.save();
    try {
      context.translate(camera.x === 0 ? 0 : -camera.x, camera.y === 0 ? 0 : -camera.y);

      for (const solid of level.geometry.solids) {
        context.fillStyle = COLORS.solid;
        context.strokeStyle = COLORS.solidOutline;
        context.fillRect(solid.x, solid.y, solid.width, solid.height);
        context.strokeRect(solid.x, solid.y, solid.width, solid.height);
      }

      for (const platform of level.geometry.oneWayPlatforms) {
        context.fillStyle = COLORS.oneWay;
        context.fillRect(platform.x, platform.y, platform.width, platform.height);
      }

      for (const checkpoint of level.checkpoints ?? []) {
        context.fillStyle = COLORS.checkpoint;
        context.fillRect(checkpoint.x - 4, checkpoint.y - 20, 8, 20);
      }

      for (const exit of level.exits ?? []) {
        context.fillStyle = COLORS.exit;
        context.strokeStyle = COLORS.exit;
        context.fillRect(exit.x, exit.y, exit.width, exit.height);
        context.strokeRect(exit.x, exit.y, exit.width, exit.height);
      }

      const body = player.body;
      context.fillStyle = player.state === 'dashing' ? COLORS.dash : COLORS.player;
      context.strokeStyle = COLORS.playerOutline;
      context.fillRect(body.x, body.y, body.width, body.height);
      context.strokeRect(body.x, body.y, body.width, body.height);

      const markerX = player.facing > 0
        ? body.x + body.width - 5
        : body.x + 1;
      context.fillStyle = COLORS.playerOutline;
      context.fillRect(markerX, body.y + body.height * 0.25, 4, 4);
    } finally {
      context.restore();
    }

    return {
      solids: level.geometry.solids.length,
      oneWayPlatforms: level.geometry.oneWayPlatforms.length,
      checkpoints: (level.checkpoints ?? []).length,
      exits: (level.exits ?? []).length,
      player: 1,
    };
  }
}
