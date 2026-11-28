function assertIdentifier(value, name) {
  if (typeof value !== 'string' || value.trim() === '') {
    throw new TypeError(`${name} deve ser uma string não vazia.`);
  }
}

/**
 * Collects input edges independently of render cadence.
 *
 * A source token owns an action while active. An action remains held until all
 * sources release it, which prevents one finger/key from releasing another
 * finger/key's still-active action.
 */
export class ActionBuffer {
  #sourcesByAction = new Map();
  #actionsBySource = new Map();
  #pressedEdges = new Set();
  #releasedEdges = new Set();

  press(action, source) {
    assertIdentifier(action, 'action');
    assertIdentifier(source, 'source');

    let sources = this.#sourcesByAction.get(action);
    if (!sources) {
      sources = new Set();
      this.#sourcesByAction.set(action, sources);
    }

    if (sources.has(source)) return false;

    if (sources.size === 0) {
      this.#pressedEdges.add(action);
    }

    sources.add(source);

    let actions = this.#actionsBySource.get(source);
    if (!actions) {
      actions = new Set();
      this.#actionsBySource.set(source, actions);
    }
    actions.add(action);

    return true;
  }

  release(action, source) {
    assertIdentifier(action, 'action');
    assertIdentifier(source, 'source');

    const sources = this.#sourcesByAction.get(action);
    if (!sources || !sources.delete(source)) return false;

    const actions = this.#actionsBySource.get(source);
    actions?.delete(action);
    if (actions?.size === 0) this.#actionsBySource.delete(source);

    if (sources.size === 0) {
      this.#sourcesByAction.delete(action);
      this.#releasedEdges.add(action);
    }

    return true;
  }

  clearSource(source) {
    assertIdentifier(source, 'source');
    const actions = this.#actionsBySource.get(source);
    if (!actions) return false;

    for (const action of [...actions]) {
      this.release(action, source);
    }
    return true;
  }

  clearAll() {
    this.#sourcesByAction.clear();
    this.#actionsBySource.clear();
    this.#pressedEdges.clear();
    this.#releasedEdges.clear();
  }

  isHeld(action) {
    assertIdentifier(action, 'action');
    return (this.#sourcesByAction.get(action)?.size ?? 0) > 0;
  }

  consume() {
    const frame = {
      pressed: [...this.#pressedEdges],
      released: [...this.#releasedEdges],
      held: [...this.#sourcesByAction]
        .filter(([, sources]) => sources.size > 0)
        .map(([action]) => action),
    };

    this.#pressedEdges.clear();
    this.#releasedEdges.clear();
    return frame;
  }
}
