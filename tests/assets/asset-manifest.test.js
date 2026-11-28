import { describe, expect, it } from 'vitest';
import {
  assertAssetLoadApproved,
  ASSET_MANIFEST_SCHEMA_VERSION,
  validateAssetManifest,
} from '../../src/assets/asset-manifest.js';

function asset(overrides = {}) {
  return {
    id: 'bolt-idle',
    url: '/assets/bolt/idle.webp',
    type: 'image',
    state: 'APPROVED',
    loadPolicy: 'preload',
    required: true,
    license: 'Original project asset; user-approved version',
    provenance: {
      creator: 'OpenAI ImageGen',
      source: 'asset-brief/ART-BOLT-004/v1',
    },
    sizeBytes: 12000,
    dimensions: { width: 128, height: 128 },
    dependencies: [],
    ...overrides,
  };
}

function manifest(assets = [asset()], overrides = {}) {
  return {
    schemaVersion: ASSET_MANIFEST_SCHEMA_VERSION,
    assets,
    ...overrides,
  };
}

describe('validateAssetManifest', () => {
  it('accepts a versioned manifest with provenance and lifecycle metadata', () => {
    expect(validateAssetManifest(manifest())).toHaveLength(1);
  });

  it('rejects unsupported schema, duplicate IDs and invalid local paths', () => {
    expect(() => validateAssetManifest(manifest([], { schemaVersion: 2 })))
      .toThrow(RangeError);
    expect(() => validateAssetManifest(manifest([asset(), asset()])))
      .toThrow('Asset ID duplicado');
    expect(() => validateAssetManifest(manifest([
      asset({ url: '../private/asset.png' }),
    ]))).toThrow('caminho local');
    expect(() => validateAssetManifest(manifest([
      asset({ url: 'https://example.com/asset.png' }),
    ]))).toThrow('caminho local');
  });

  it('validates dependencies and fallback references', () => {
    expect(() => validateAssetManifest(manifest([
      asset({ dependencies: ['missing-asset'] }),
    ]))).toThrow('Dependência ausente');

    expect(() => validateAssetManifest(manifest([
      asset({ fallback: 'missing-asset' }),
    ]))).toThrow('Fallback ausente');
  });

  it('validates optional type-specific metadata and provenance', () => {
    expect(() => validateAssetManifest(manifest([
      asset({ dimensions: { width: 128 } }),
    ]))).toThrow('exige width e height');

    expect(() => validateAssetManifest(manifest([
      asset({ provenance: { creator: 'unknown', source: '' } }),
    ]))).toThrow('provenance.source');
  });

  it('rejects cyclic dependency graphs', () => {
    expect(() => validateAssetManifest(manifest([
      asset({ id: 'asset-a', dependencies: ['asset-b'] }),
      asset({ id: 'asset-b', url: '/assets/b.webp', dependencies: ['asset-a'] }),
    ]))).toThrow('circular');
  });

  it('allows placeholders only under explicit development policy', () => {
    const placeholder = asset({ state: 'PLACEHOLDER' });

    expect(() => assertAssetLoadApproved(placeholder)).toThrow('não pode ser carregado');
    expect(assertAssetLoadApproved(placeholder, { allowPlaceholders: true })).toBe(true);
    expect(() => assertAssetLoadApproved(asset({ state: 'AWAITING_USER_APPROVAL' })))
      .toThrow('não pode ser carregado');
  });
});
