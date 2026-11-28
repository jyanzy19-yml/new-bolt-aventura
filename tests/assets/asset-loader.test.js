import { describe, expect, it, vi } from 'vitest';
import {
  AssetLoadAggregateError,
  AssetLoader,
} from '../../src/assets/asset-loader.js';
import { ASSET_MANIFEST_SCHEMA_VERSION } from '../../src/assets/asset-manifest.js';

function asset(overrides = {}) {
  return {
    id: 'bolt-idle',
    url: '/assets/bolt/idle.webp',
    type: 'image',
    state: 'APPROVED',
    loadPolicy: 'preload',
    required: true,
    license: 'Original project asset; user-approved version',
    provenance: { creator: 'OpenAI ImageGen', source: 'brief/v1' },
    dependencies: [],
    ...overrides,
  };
}

function manifest(assets) {
  return { schemaVersion: ASSET_MANIFEST_SCHEMA_VERSION, assets };
}

function createLoader(options = {}) {
  const loadImage = vi.fn(async (entry) => ({ id: entry.id, url: entry.url }));
  const loadAudio = vi.fn(async (entry) => ({ id: entry.id, url: entry.url }));
  const releaseImage = vi.fn();
  return {
    loader: new AssetLoader({
      loaders: { image: loadImage, audio: loadAudio },
      releasers: { image: releaseImage },
      maxConcurrency: 2,
      ...options,
    }),
    loadImage,
    loadAudio,
    releaseImage,
  };
}

describe('AssetLoader', () => {
  it('loads preload entries only and reports measured progress', async () => {
    const { loader, loadImage, loadAudio } = createLoader();
    const progress = vi.fn();
    const result = await loader.loadManifest(manifest([
      asset(),
      asset({
        id: 'world-ambience',
        url: '/assets/audio/world.ogg',
        type: 'audio',
      }),
      asset({
        id: 'lazy-boss',
        url: '/assets/boss/boss.webp',
        loadPolicy: 'lazy',
      }),
    ]), { onProgress: progress });

    expect(loadImage).toHaveBeenCalledTimes(1);
    expect(loadAudio).toHaveBeenCalledTimes(1);
    expect(loader.has('lazy-boss')).toBe(false);
    expect(result.total).toBe(2);
    expect(result.completed).toBe(2);
    expect(result.ratio).toBe(1);
    expect(progress).toHaveBeenCalledTimes(2);
  });

  it('reuses cached assets without invoking the loader again', async () => {
    const { loader, loadImage } = createLoader();
    const first = await loader.loadOne(asset());
    const second = await loader.loadOne(asset());

    expect(first).toBe(second);
    expect(loadImage).toHaveBeenCalledTimes(1);
  });

  it('unloads and releases cached values exactly once', async () => {
    const { loader, releaseImage } = createLoader();
    await loader.loadOne(asset());

    expect(loader.unload('bolt-idle')).toBe(true);
    expect(loader.unload('bolt-idle')).toBe(false);
    expect(releaseImage).toHaveBeenCalledTimes(1);
    expect(loader.loadedCount).toBe(0);
  });

  it('clears every loaded asset', async () => {
    const { loader, releaseImage } = createLoader();
    await loader.loadManifest(manifest([
      asset(),
      asset({ id: 'bolt-run', url: '/assets/bolt/run.webp' }),
    ]));

    expect(loader.clear()).toBe(2);
    expect(loader.loadedCount).toBe(0);
    expect(releaseImage).toHaveBeenCalledTimes(2);
  });

  it('blocks unapproved assets and placeholders unless explicitly allowed', async () => {
    const { loader, loadImage } = createLoader();

    await expect(loader.loadManifest(manifest([
      asset({ state: 'AWAITING_USER_APPROVAL' }),
    ]))).rejects.toThrow('não pode ser carregado');
    await expect(loader.loadOne(asset({ state: 'PLACEHOLDER' })))
      .rejects.toThrow('não pode ser carregado');
    expect(loadImage).not.toHaveBeenCalled();

    const devLoader = createLoader({ allowPlaceholders: true }).loader;
    await expect(devLoader.loadOne(asset({ state: 'PLACEHOLDER' }))).resolves.toBeTruthy();
  });

  it('reports optional failures and rejects required failures transactionally', async () => {
    const failingLoader = vi.fn(async (entry) => {
      if (entry.id === 'broken-required' || entry.id === 'broken-optional') {
        throw new Error('decode failed');
      }
      return { id: entry.id };
    });
    const release = vi.fn();
    const { loader } = createLoader({
      loaders: { image: failingLoader },
      releasers: { image: release },
    });

    const optional = await loader.loadManifest(manifest([
      asset({ id: 'broken-optional', required: false }),
    ]));
    expect(optional.failures).toHaveLength(1);
    expect(optional.failures[0].required).toBe(false);

    await expect(loader.loadManifest(manifest([
      asset({ id: 'good-one' }),
      asset({ id: 'broken-required' }),
    ]))).rejects.toBeInstanceOf(AssetLoadAggregateError);
    expect(loader.has('good-one')).toBe(false);
    expect(release).toHaveBeenCalledTimes(1);
  });

  it('respects concurrency and aborts before starting when signal is already aborted', async () => {
    let active = 0;
    let maximum = 0;
    const controlledLoader = async (entry) => {
      active += 1;
      maximum = Math.max(maximum, active);
      await Promise.resolve();
      active -= 1;
      return { id: entry.id };
    };
    const { loader } = createLoader({
      loaders: { image: controlledLoader },
      maxConcurrency: 2,
    });

    await loader.loadManifest(manifest([
      asset({ id: 'asset-a' }),
      asset({ id: 'asset-b' }),
      asset({ id: 'asset-c' }),
      asset({ id: 'asset-d' }),
    ]));
    expect(maximum).toBeLessThanOrEqual(2);

    const controller = new AbortController();
    controller.abort();
    await expect(loader.loadManifest(manifest([asset()]), {
      signal: controller.signal,
    })).rejects.toMatchObject({ name: 'AbortError' });
  });

  it('requires an explicit unload before changing a cached asset identity', async () => {
    const { loader, loadImage } = createLoader();
    await loader.loadOne(asset());

    await expect(loader.loadOne(asset({
      url: '/assets/bolt/idle-v2.webp',
    }))).rejects.toThrow('outra identidade');

    expect(loader.has('bolt-idle')).toBe(true);
    expect(loadImage).toHaveBeenCalledTimes(1);
  });

  it('rejects unsupported streaming loads and rolls back on progress callback failure', async () => {
    const { loader, releaseImage } = createLoader();

    await expect(loader.loadOne(asset({ loadPolicy: 'stream' })))
      .rejects.toThrow('streaming');

    await expect(loader.loadManifest(manifest([asset()]), {
      onProgress: () => {
        throw new Error('progress consumer failed');
      },
    })).rejects.toThrow('progress consumer failed');

    expect(loader.has('bolt-idle')).toBe(false);
    expect(releaseImage).toHaveBeenCalledTimes(1);
  });

  it('returns an empty report without inventing progress for an empty preload set', async () => {
    const { loader } = createLoader();
    const result = await loader.loadManifest(manifest([
      asset({ loadPolicy: 'lazy' }),
    ]));

    expect(result).toEqual({
      loaded: [],
      failures: [],
      total: 0,
      completed: 0,
      ratio: null,
    });
  });
});
