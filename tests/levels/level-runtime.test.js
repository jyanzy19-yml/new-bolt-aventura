import { describe, expect, it } from 'vitest';
import { LEVEL_SCHEMA_VERSION } from '../../src/levels/level-definition.js';
import { LevelRuntime } from '../../src/levels/level-runtime.js';

function makeLevel(overrides = {}) {
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
    ...overrides,
  };
}

describe('LevelRuntime', () => {
  it('loads a validated definition and exposes its stable identity', () => {
    const runtime = new LevelRuntime();

    const loaded = runtime.load(makeLevel());

    expect(runtime.isLoaded).toBe(true);
    expect(runtime.activeLevelId).toBe('w1-l1');
    expect(loaded.id).toBe('w1-l1');
    expect(runtime.activeLevel).toBe(loaded);
  });

  it('copies and freezes nested content so caller mutation cannot alter runtime data', () => {
    const runtime = new LevelRuntime();
    const source = makeLevel();

    const loaded = runtime.load(source);
    source.geometry.solids[0].x = 500;
    source.title = 'mutated';

    expect(loaded.title).toBe('Despertar entre Ruínas');
    expect(loaded.geometry.solids[0].x).toBe(0);
    expect(Object.isFrozen(loaded)).toBe(true);
    expect(Object.isFrozen(loaded.geometry)).toBe(true);
    expect(Object.isFrozen(loaded.geometry.solids[0])).toBe(true);
  });

  it('does not replace the active level when validation fails', () => {
    const runtime = new LevelRuntime();
    runtime.load(makeLevel());

    const invalid = makeLevel({
      id: 'not-a-campaign-level',
    });

    expect(() => runtime.load(invalid)).toThrow(TypeError);
    expect(runtime.activeLevelId).toBe('w1-l1');
  });

  it('rejects non-JSON metadata and circular content transactionally', () => {
    const runtime = new LevelRuntime();
    runtime.load(makeLevel());

    const withFunction = makeLevel({ metadata: { callback: () => true } });
    expect(() => runtime.load(withFunction)).toThrow('JSON compatível');
    expect(runtime.activeLevelId).toBe('w1-l1');

    const circular = makeLevel();
    circular.metadata = {};
    circular.metadata.self = circular.metadata;
    expect(() => runtime.load(circular)).toThrow('referência circular');
    expect(runtime.activeLevelId).toBe('w1-l1');
  });

  it('rejects array accessors and symbol-keyed metadata', () => {
    const runtime = new LevelRuntime();
    runtime.load(makeLevel());

    const withArrayAccessor = makeLevel();
    Object.defineProperty(withArrayAccessor.geometry.solids, '0', {
      enumerable: true,
      configurable: true,
      get: () => ({ id: 'starting-floor', x: 0, y: 400, width: 800, height: 50 }),
    });
    expect(() => runtime.load(withArrayAccessor)).toThrow('serializável');

    const withSymbol = makeLevel({ metadata: {} });
    withSymbol.metadata[Symbol('hidden')] = 'not-json';
    expect(() => runtime.load(withSymbol)).toThrow('chave de símbolo');
    expect(runtime.activeLevelId).toBe('w1-l1');
  });

  it('unloads idempotently and clears the active reference', () => {
    const runtime = new LevelRuntime();
    runtime.load(makeLevel());

    expect(runtime.unload()).toBe(true);
    expect(runtime.unload()).toBe(false);
    expect(runtime.isLoaded).toBe(false);
    expect(runtime.activeLevel).toBe(null);
    expect(runtime.activeLevelId).toBe(null);
  });

  it('replaces an active level only after the next definition is ready', () => {
    const runtime = new LevelRuntime();
    runtime.load(makeLevel());

    const next = makeLevel({
      id: 'w1-l2',
      title: 'Ruas sem Sinal',
    });
    const loaded = runtime.load(next);

    expect(loaded.id).toBe('w1-l2');
    expect(runtime.activeLevelId).toBe('w1-l2');
  });
});
