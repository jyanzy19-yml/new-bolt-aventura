export const ASSET_MANIFEST_SCHEMA_VERSION = 1;

export const ASSET_STATES = Object.freeze([
  'PLANNED',
  'SPECIFIED',
  'CONCEPT_CREATED',
  'AWAITING_USER_APPROVAL',
  'REVISION_REQUESTED',
  'APPROVED',
  'INTEGRATED',
  'VERIFIED',
  'REJECTED',
  'PLACEHOLDER',
]);

export const ASSET_LOAD_POLICIES = Object.freeze([
  'preload',
  'lazy',
  'stream',
]);

const ASSET_TYPES = new Set(['image', 'audio', 'font', 'data']);
const ASSET_ID_PATTERN = /^[a-z][a-z0-9]*(?:-[a-z0-9]+)*$/;
const LEVEL_ID_PATTERN = /^w[1-7]-l[1-6]$/;

function assertText(value, name) {
  if (typeof value !== 'string' || value.trim() === '') {
    throw new TypeError(`${name} deve ser uma string não vazia.`);
  }
}

function assertOptionalPositiveInteger(value, name) {
  if (value === undefined || value === null) return;
  if (!Number.isInteger(value) || value <= 0) {
    throw new RangeError(`${name} deve ser um inteiro positivo.`);
  }
}

export function validateAssetEntry(entry, index = 0) {
  const name = `assets[${index}]`;
  if (!entry || typeof entry !== 'object' || Array.isArray(entry)) {
    throw new TypeError(`${name} deve ser um objeto.`);
  }

  assertText(entry.id, `${name}.id`);
  if (!ASSET_ID_PATTERN.test(entry.id)) {
    throw new TypeError(`${name}.id deve usar kebab-case estável.`);
  }

  assertText(entry.url, `${name}.url`);
  if (
    /^(?:https?:|data:|blob:)/i.test(entry.url) ||
    entry.url.split(/[?#]/, 1)[0].split('/').includes('..')
  ) {
    throw new TypeError(`${name}.url deve ser um caminho local sem traversal.`);
  }

  if (!ASSET_TYPES.has(entry.type)) {
    throw new TypeError(`${name}.type não é suportado.`);
  }
  if (!ASSET_STATES.includes(entry.state)) {
    throw new TypeError(`${name}.state não é válido.`);
  }
  if (!ASSET_LOAD_POLICIES.includes(entry.loadPolicy)) {
    throw new TypeError(`${name}.loadPolicy não é válido.`);
  }

  assertText(entry.license, `${name}.license`);
  if (
    !entry.provenance ||
    typeof entry.provenance !== 'object' ||
    Array.isArray(entry.provenance)
  ) {
    throw new TypeError(`${name}.provenance é obrigatório.`);
  }
  assertText(entry.provenance.creator, `${name}.provenance.creator`);
  assertText(entry.provenance.source, `${name}.provenance.source`);

  if (typeof entry.required !== 'boolean') {
    throw new TypeError(`${name}.required deve ser booleano.`);
  }
  if (
    entry.sizeBytes !== undefined &&
    (!Number.isInteger(entry.sizeBytes) || entry.sizeBytes < 0)
  ) {
    throw new RangeError(`${name}.sizeBytes deve ser um inteiro não negativo.`);
  }

  assertOptionalPositiveInteger(entry.durationMs, `${name}.durationMs`);

  if (entry.dimensions !== undefined) {
    if (!entry.dimensions || typeof entry.dimensions !== 'object') {
      throw new TypeError(`${name}.dimensions deve ser um objeto.`);
    }
    assertOptionalPositiveInteger(entry.dimensions.width, `${name}.dimensions.width`);
    assertOptionalPositiveInteger(entry.dimensions.height, `${name}.dimensions.height`);
    if (!entry.dimensions.width || !entry.dimensions.height) {
      throw new TypeError(`${name}.dimensions exige width e height.`);
    }
  }

  if (entry.worldId !== undefined) assertText(entry.worldId, `${name}.worldId`);
  if (entry.phaseId !== undefined && !LEVEL_ID_PATTERN.test(entry.phaseId)) {
    throw new TypeError(`${name}.phaseId deve seguir w1-l1 até w7-l6.`);
  }
  if (entry.dependencies !== undefined) {
    if (!Array.isArray(entry.dependencies)) {
      throw new TypeError(`${name}.dependencies deve ser um array.`);
    }
    for (const dependency of entry.dependencies) {
      assertText(dependency, `${name}.dependencies[]`);
      if (!ASSET_ID_PATTERN.test(dependency)) {
        throw new TypeError(`${name}.dependencies contém ID inválido.`);
      }
    }
  }
  if (entry.fallback !== undefined && entry.fallback !== null) {
    assertText(entry.fallback, `${name}.fallback`);
    if (!ASSET_ID_PATTERN.test(entry.fallback)) {
      throw new TypeError(`${name}.fallback deve ser um ID estável.`);
    }
  }

  return entry;
}

export function validateAssetManifest(manifest) {
  if (!manifest || typeof manifest !== 'object' || Array.isArray(manifest)) {
    throw new TypeError('manifest deve ser um objeto.');
  }
  if (manifest.schemaVersion !== ASSET_MANIFEST_SCHEMA_VERSION) {
    throw new RangeError(
      `Versão de manifesto não suportada: ${manifest.schemaVersion}.`,
    );
  }
  if (!Array.isArray(manifest.assets)) {
    throw new TypeError('manifest.assets deve ser um array.');
  }

  const ids = new Set();
  for (const [index, entry] of manifest.assets.entries()) {
    validateAssetEntry(entry, index);
    if (ids.has(entry.id)) throw new Error(`Asset ID duplicado: ${entry.id}`);
    ids.add(entry.id);
  }

  const entriesById = new Map(manifest.assets.map((entry) => [entry.id, entry]));
  for (const entry of manifest.assets) {
    for (const dependency of entry.dependencies ?? []) {
      if (!ids.has(dependency)) {
        throw new Error(`Dependência ausente ${dependency} em ${entry.id}.`);
      }
      if (dependency === entry.id) {
        throw new Error(`Asset ${entry.id} não pode depender de si mesmo.`);
      }
    }
    if (entry.fallback && !ids.has(entry.fallback)) {
      throw new Error(`Fallback ausente ${entry.fallback} em ${entry.id}.`);
    }
  }

  const visiting = new Set();
  const visited = new Set();
  const visit = (id) => {
    if (visiting.has(id)) {
      throw new Error(`Dependência circular detectada em ${id}.`);
    }
    if (visited.has(id)) return;

    visiting.add(id);
    for (const dependency of entriesById.get(id).dependencies ?? []) {
      visit(dependency);
    }
    visiting.delete(id);
    visited.add(id);
  };

  for (const id of ids) visit(id);

  return manifest.assets;
}

export function assertAssetLoadApproved(entry, { allowPlaceholders = false } = {}) {
  if (
    entry.state === 'APPROVED' ||
    entry.state === 'INTEGRATED' ||
    entry.state === 'VERIFIED'
  ) {
    return true;
  }
  if (entry.state === 'PLACEHOLDER' && allowPlaceholders) return true;

  throw new Error(
    `Asset ${entry.id} não pode ser carregado no estado ${entry.state}.`,
  );
}
