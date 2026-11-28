import {
  assertAssetLoadApproved,
  validateAssetEntry,
  validateAssetManifest,
} from './asset-manifest.js';

function createAbortError() {
  const error = new Error('Carregamento de assets cancelado.');
  error.name = 'AbortError';
  return error;
}

function validateSignal(signal) {
  if (
    signal !== undefined &&
    signal !== null &&
    (typeof signal.aborted !== 'boolean' ||
      typeof signal.addEventListener !== 'function')
  ) {
    throw new TypeError('signal deve implementar a interface AbortSignal.');
  }
}

export class AssetLoadAggregateError extends Error {
  constructor(failures, report) {
    super(`Falha ao carregar ${failures.length} asset(s) obrigatório(s).`);
    this.name = 'AssetLoadAggregateError';
    this.failures = failures;
    this.report = report;
  }
}

/**
 * Bounded asynchronous asset loader with explicit provenance/state policy.
 * Browser-specific decoders are injected as loaders; no fake progress or
 * artificial delay is introduced by this coordinator.
 */
export class AssetLoader {
  #loaders;
  #releasers;
  #maxConcurrency;
  #allowPlaceholders;
  #cache = new Map();

  constructor({
    loaders,
    releasers = {},
    maxConcurrency = 4,
    allowPlaceholders = false,
  }) {
    if (!loaders || typeof loaders !== 'object') {
      throw new TypeError('loaders deve ser um mapa de funções por tipo.');
    }
    if (!Number.isInteger(maxConcurrency) || maxConcurrency < 1) {
      throw new RangeError('maxConcurrency deve ser um inteiro positivo.');
    }
    if (typeof allowPlaceholders !== 'boolean') {
      throw new TypeError('allowPlaceholders deve ser booleano.');
    }

    for (const [type, loader] of Object.entries(loaders)) {
      if (typeof loader !== 'function') {
        throw new TypeError(`Loader de ${type} deve ser uma função.`);
      }
    }
    for (const [type, releaser] of Object.entries(releasers)) {
      if (typeof releaser !== 'function') {
        throw new TypeError(`Releaser de ${type} deve ser uma função.`);
      }
    }

    this.#loaders = { ...loaders };
    this.#releasers = { ...releasers };
    this.#maxConcurrency = maxConcurrency;
    this.#allowPlaceholders = allowPlaceholders;
  }

  get loadedCount() {
    return this.#cache.size;
  }

  has(id) {
    return this.#cache.has(id);
  }

  get(id) {
    return this.#cache.get(id)?.value ?? null;
  }

  async loadManifest(manifest, { signal, onProgress } = {}) {
    validateSignal(signal);
    if (onProgress !== undefined && typeof onProgress !== 'function') {
      throw new TypeError('onProgress deve ser uma função.');
    }
    if (signal?.aborted) throw createAbortError();

    const assets = validateAssetManifest(manifest);
    const entries = assets.filter((asset) => asset.loadPolicy === 'preload');
    for (const entry of entries) {
      assertAssetLoadApproved(entry, {
        allowPlaceholders: this.#allowPlaceholders,
      });
    }

    const report = await this.#loadEntries(entries, { signal, onProgress });
    const requiredFailures = report.failures.filter((failure) => failure.required);
    if (signal?.aborted) {
      this.#rollbackNewEntries(report.newlyLoadedIds);
      throw createAbortError();
    }
    if (requiredFailures.length > 0) {
      this.#rollbackNewEntries(report.newlyLoadedIds);
      throw new AssetLoadAggregateError(requiredFailures, {
        ...report,
        newlyLoadedIds: undefined,
      });
    }

    return {
      loaded: report.loaded,
      failures: report.failures,
      total: report.total,
      completed: report.completed,
      ratio: report.ratio,
    };
  }

  async loadOne(entry, { signal } = {}) {
    validateSignal(signal);
    if (signal?.aborted) throw createAbortError();
    validateAssetEntry(entry);
    if (entry.loadPolicy === 'stream') {
      throw new Error(`Asset ${entry.id} usa streaming, ainda não suportado pelo loader.`);
    }
    assertAssetLoadApproved(entry, {
      allowPlaceholders: this.#allowPlaceholders,
    });

    const result = await this.#loadEntry(entry, signal);
    if (signal?.aborted) {
      if (!result.cached) this.#releaseValue(entry, result.value);
      throw createAbortError();
    }
    return result.value;
  }

  unload(id) {
    const cached = this.#cache.get(id);
    if (!cached) return false;
    this.#cache.delete(id);
    this.#releaseValue(cached.entry, cached.value);
    return true;
  }

  clear() {
    const ids = [...this.#cache.keys()];
    for (const id of ids) this.unload(id);
    return ids.length;
  }

  async #loadEntries(entries, { signal, onProgress }) {
    const report = {
      loaded: [],
      failures: [],
      newlyLoadedIds: [],
      total: entries.length,
      completed: 0,
      ratio: entries.length === 0 ? null : 0,
      callbackError: null,
    };

    let cursor = 0;
    const worker = async () => {
      while (cursor < entries.length) {
        if (signal?.aborted) return;
        const entry = entries[cursor];
        cursor += 1;

        let status = 'loaded';
        try {
          const result = await this.#loadEntry(entry, signal);
          report.loaded.push(entry.id);
          if (!result.cached) report.newlyLoadedIds.push(entry.id);
          if (result.cached) status = 'cached';
        } catch (error) {
          status = 'failed';
          report.failures.push({
            id: entry.id,
            required: entry.required,
            error,
          });
        }

        report.completed += 1;
        report.ratio = report.total === 0
          ? null
          : report.completed / report.total;
        try {
          onProgress?.({
            total: report.total,
            completed: report.completed,
            failed: report.failures.length,
            ratio: report.ratio,
            assetId: entry.id,
            status,
          });
        } catch (error) {
          report.callbackError ??= error;
        }
      }
    };

    const workerCount = Math.min(this.#maxConcurrency, entries.length);
    await Promise.all(Array.from({ length: workerCount }, () => worker()));

    if (report.callbackError) {
      this.#rollbackNewEntries(report.newlyLoadedIds);
      throw report.callbackError;
    }

    return report;
  }

  async #loadEntry(entry, signal) {
    const cached = this.#cache.get(entry.id);
    if (cached) {
      if (cached.url !== entry.url || cached.type !== entry.type) {
        throw new Error(
          `Asset ${entry.id} já está carregado com outra identidade; descarregue antes de substituir.`,
        );
      }
      return { value: cached.value, cached: true };
    }

    const loader = this.#loaders[entry.type];
    if (!loader) {
      throw new Error(`Nenhum loader registrado para o tipo ${entry.type}.`);
    }

    const value = await loader(entry, { signal });
    if (signal?.aborted) {
      this.#releaseValue(entry, value);
      throw createAbortError();
    }

    this.#cache.set(entry.id, {
      entry,
      url: entry.url,
      type: entry.type,
      value,
    });

    return { value, cached: false };
  }

  #rollbackNewEntries(ids) {
    for (const id of ids) this.unload(id);
  }

  #releaseValue(entry, value) {
    const releaser = this.#releasers[entry.type];
    if (releaser) {
      releaser(value, entry);
    } else if (typeof value?.close === 'function') {
      value.close();
    }
  }
}
