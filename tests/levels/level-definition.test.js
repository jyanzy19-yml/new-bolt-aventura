import { describe, expect, it } from 'vitest';
import {
  LEVEL_SCHEMA_VERSION,
  validateLevelDefinition,
} from '../../src/levels/level-definition.js';

function makeLevel() {
  return {
    schemaVersion: LEVEL_SCHEMA_VERSION,
    id: 'w1-l1',
    worldId: 'cybercore',
    title: 'Despertar entre Ruínas',
    bounds: { x: 0, y: 0, width: 800, height: 450 },
    spawn: { x: 48, y: 360 },
    geometry: {
      solids: [{ id: 'starting-floor', x: 0, y: 400, width: 800, height: 50 }],
      oneWayPlatforms: [
        { id: 'upper-platform', x: 180, y: 300, width: 120, height: 12 },
      ],
    },
    checkpoints: [{ id: 'checkpoint-01', x: 400, y: 360 }],
    exits: [
      {
        id: 'level-exit',
        x: 760,
        y: 340,
        width: 24,
        height: 60,
        targetLevelId: 'w1-l2',
      },
    ],
  };
}

describe('validateLevelDefinition', () => {
  it('accepts a complete engine-neutral level definition', () => {
    const level = makeLevel();
    expect(validateLevelDefinition(level)).toBe(level);
  });

  it('rejects unsupported schema versions and invalid phase ids', () => {
    const wrongVersion = makeLevel();
    wrongVersion.schemaVersion = 2;
    expect(() => validateLevelDefinition(wrongVersion)).toThrow(RangeError);

    const wrongId = makeLevel();
    wrongId.id = 'cybercore-intro';
    expect(() => validateLevelDefinition(wrongId)).toThrow(TypeError);
  });

  it('rejects duplicate stable ids across level elements', () => {
    const level = makeLevel();
    level.checkpoints.push({ id: 'starting-floor', x: 20, y: 20 });

    expect(() => validateLevelDefinition(level)).toThrow('ID duplicado');
  });

  it('rejects spawn, geometry and exits outside level bounds', () => {
    const badSpawn = makeLevel();
    badSpawn.spawn.x = 900;
    expect(() => validateLevelDefinition(badSpawn)).toThrow('spawn está fora');

    const badGeometry = makeLevel();
    badGeometry.geometry.solids[0].width = 900;
    expect(() => validateLevelDefinition(badGeometry)).toThrow('fora dos limites');

    const badExit = makeLevel();
    badExit.exits[0].targetLevelId = 'not-a-level';
    expect(() => validateLevelDefinition(badExit)).toThrow('targetLevelId válido');
  });

  it('requires explicit geometry, checkpoints and exits arrays', () => {
    const level = makeLevel();
    delete level.checkpoints;
    expect(() => validateLevelDefinition(level)).toThrow(TypeError);
  });
});

