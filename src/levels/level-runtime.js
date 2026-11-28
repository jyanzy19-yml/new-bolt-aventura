import { validateLevelDefinition } from './level-definition.js';

function cloneJsonValue(value, name, ancestors = new WeakSet()) {
  if (
    value === null ||
    typeof value === 'string' ||
    typeof value === 'boolean'
  ) {
    return value;
  }

  if (typeof value === 'number') {
    if (!Number.isFinite(value)) {
      throw new TypeError(`${name} contém um número não finito.`);
    }
    return value;
  }

  if (typeof value !== 'object') {
    throw new TypeError(`${name} não é um valor JSON compatível.`);
  }

  if (ancestors.has(value)) {
    throw new TypeError(`${name} contém uma referência circular.`);
  }

  ancestors.add(value);

  let clone;
  if (Array.isArray(value)) {
    clone = value.map((item, index) =>
      cloneJsonValue(item, `${name}[${index}]`, ancestors),
    );
  } else {
    const prototype = Object.getPrototypeOf(value);
    if (prototype !== Object.prototype && prototype !== null) {
      throw new TypeError(`${name} deve conter apenas objetos simples.`);
    }

    clone = Object.create(null);
    const descriptors = Object.getOwnPropertyDescriptors(value);

    for (const [key, descriptor] of Object.entries(descriptors)) {
      if (!descriptor.enumerable || !Object.hasOwn(descriptor, 'value')) {
        throw new TypeError(`${name} contém propriedade não serializável: ${key}`);
      }
      Object.defineProperty(clone, key, {
        value: cloneJsonValue(descriptor.value, `${name}.${key}`, ancestors),
        enumerable: true,
        configurable: false,
        writable: false,
      });
    }
  }

  ancestors.delete(value);
  return Object.freeze(clone);
}

/**
 * Transactional in-memory level lifecycle.
 *
 * Validation and immutable cloning complete before replacing the active level.
 * This class does not fetch files, decode assets or instantiate gameplay actors.
 */
export class LevelRuntime {
  #activeLevel = null;

  get isLoaded() {
    return this.#activeLevel !== null;
  }

  get activeLevelId() {
    return this.#activeLevel?.id ?? null;
  }

  get activeLevel() {
    return this.#activeLevel;
  }

  load(definition) {
    validateLevelDefinition(definition);
    const candidate = cloneJsonValue(definition, 'level');

    // Commit only after the complete candidate has passed validation and cloning.
    this.#activeLevel = candidate;
    return this.#activeLevel;
  }

  unload() {
    if (!this.#activeLevel) return false;
    this.#activeLevel = null;
    return true;
  }
}
