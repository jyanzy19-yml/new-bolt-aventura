const CONTROL_GROUPS = Object.freeze([
  {
    id: 'movement',
    label: 'Movimento',
    controls: [
      { action: 'move-left', label: 'Mover para a esquerda', glyph: '◀' },
      { action: 'move-right', label: 'Mover para a direita', glyph: '▶' },
    ],
  },
  {
    id: 'actions',
    label: 'Ações',
    controls: [
      { action: 'jump', label: 'Pular', glyph: 'PULAR' },
      { action: 'dash', label: 'Dash', glyph: 'DASH' },
      { action: 'fire', label: 'Atirar', glyph: 'TIRO' },
    ],
  },
]);

/**
 * Creates accessible touch buttons bound to logical ActionBuffer actions.
 * The controls are intentionally independent of player/gameplay modules.
 */
export class TouchControls {
  #inputManager;
  #document;
  #root = null;
  #container = null;
  #disposers = [];
  #groups;

  constructor({
    inputManager,
    documentTarget = globalThis.document ?? null,
    enabledActions = null,
  }) {
    if (!inputManager || typeof inputManager.bindPointerAction !== 'function') {
      throw new TypeError('TouchControls exige um InputManager compatível.');
    }
    if (!documentTarget || typeof documentTarget.createElement !== 'function') {
      throw new TypeError('TouchControls exige um document com createElement().');
    }

    if (enabledActions !== null && (
      !Array.isArray(enabledActions) ||
      enabledActions.length === 0 ||
      enabledActions.some((action) => typeof action !== 'string')
    )) {
      throw new TypeError('enabledActions deve ser null ou um array não vazio de ações.');
    }

    const enabled = enabledActions === null ? null : new Set(enabledActions);
    const knownActions = new Set(
      CONTROL_GROUPS.flatMap((group) => group.controls.map((control) => control.action)),
    );
    if (enabled && [...enabled].some((action) => !knownActions.has(action))) {
      throw new RangeError('enabledActions contém uma ação touch desconhecida.');
    }

    this.#inputManager = inputManager;
    this.#document = documentTarget;
    this.#groups = CONTROL_GROUPS
      .map((group) => ({
        ...group,
        controls: enabled
          ? group.controls.filter((control) => enabled.has(control.action))
          : group.controls,
      }))
      .filter((group) => group.controls.length > 0);
  }

  get mounted() {
    return this.#root !== null;
  }

  get element() {
    return this.#root;
  }

  mount(container) {
    if (this.#root) return false;
    if (!container || typeof container.appendChild !== 'function') {
      throw new TypeError('container precisa implementar appendChild().');
    }

    const root = this.#document.createElement('div');
    root.className = 'touch-controls';
    root.setAttribute('role', 'group');
    root.setAttribute('aria-label', 'Controles de toque');

    try {
      for (const groupDefinition of this.#groups) {
        const group = this.#document.createElement('div');
        group.className = `touch-control-group touch-control-group--${groupDefinition.id}`;
        group.setAttribute('role', 'group');
        group.setAttribute('aria-label', groupDefinition.label);

        for (const control of groupDefinition.controls) {
          const button = this.#document.createElement('button');
          button.type = 'button';
          button.className = `touch-control touch-control--${control.action}`;
          button.textContent = control.glyph;
          button.setAttribute('aria-label', control.label);
          button.dataset.action = control.action;
          button.setAttribute('data-action', control.action);

          const dispose = this.#inputManager.bindPointerAction(
            button,
            control.action,
          );
          this.#disposers.push(dispose);
          group.appendChild(button);
        }

        root.appendChild(group);
      }

      container.appendChild(root);
      this.#container = container;
      this.#root = root;
      return true;
    } catch (error) {
      for (const dispose of this.#disposers.splice(0)) dispose();
      root.remove?.();
      throw error;
    }
  }

  dispose() {
    for (const dispose of this.#disposers.splice(0)) dispose();

    if (this.#root && this.#container?.removeChild) {
      this.#container.removeChild(this.#root);
    } else {
      this.#root?.remove?.();
    }

    this.#root = null;
    this.#container = null;
  }
}
