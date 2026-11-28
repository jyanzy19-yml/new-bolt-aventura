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
    const descriptors = Object.getOwnPropertyDescriptors(value);
    const ownKeys = Reflect.ownKeys(value);
    if (ownKeys.some((key) => typeof key !== 'string')) {
      throw new TypeError(`${name} contém chave de símbolo.`);
    }
    const indices = ownKeys.filter((key) => key !== 'length');
    if (indices.length !== value.length) {
      throw new TypeError(`${name} contém índices ausentes ou propriedades extras.`);
    }
    for (let index = 0; index < value.length; index += 1) {
      const descriptor = descriptors[String(index)];
      if (!descriptor?.enumerable || !Object.hasOwn(descriptor, 'value')) {
        throw new TypeError(`${name}[${index}] não é um dado JSON serializável.`);
      }
    }
    clone = Array.from({ length: value.length }, (_, index) =>
      cloneJsonValue(descriptors[String(index)].value, `${name}[${index}]`, ancestors),
    );
  } else {
    const prototype = Object.getPrototypeOf(value);
    if (prototype !== Object.prototype && prototype !== null) {
      throw new TypeError(`${name} deve conter apenas objetos simples.`);
    }

    clone = Object.create(null);
    const ownKeys = Reflect.ownKeys(value);
    if (ownKeys.some((key) => typeof key !== 'string')) {
      throw new TypeError(`${name} contém chave de símbolo.`);
    }
    const descriptors = Object.getOwnPropertyDescriptors(value);

    for (const key of ownKeys) {
      const descriptor = descriptors[key];
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
