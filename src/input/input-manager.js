import { ActionBuffer } from './action-buffer.js';

function buildKeyboardMap(bindings) {
  const keyToActions = new Map();

  for (const [action, codes] of Object.entries(bindings)) {
    if (!Array.isArray(codes)) {
      throw new TypeError(`As teclas de ${action} devem ser fornecidas em um array.`);
    }

    for (const code of codes) {
      if (typeof code !== 'string' || code.trim() === '') {
        throw new TypeError('Cada KeyboardEvent.code deve ser uma string não vazia.');
      }
      const actions = keyToActions.get(code) ?? [];
      actions.push(action);
      keyToActions.set(code, actions);
    }
  }

  return keyToActions;
}

/**
 * Bridges DOM keyboard/pointer events into an ActionBuffer.
 * Pointer controls are bound explicitly to UI elements; layout and hit regions
 * remain the responsibility of the UI layer.
 */
export class InputManager {
  #buffer;
  #keyToActions;
  #keyboardTarget;
  #lifecycleTarget;
  #documentTarget;
  #pointerDisposers = new Set();
  #pointerResetters = new Set();
  #enabled = true;
  #nextBindingId = 0;
  #onKeyDown;
  #onKeyUp;
  #onBlur;
  #onVisibilityChange;

  constructor({
    buffer = new ActionBuffer(),
    keyboardBindings = {},
    keyboardTarget = globalThis.window ?? null,
    lifecycleTarget = globalThis.window ?? null,
    documentTarget = globalThis.document ?? null,
  } = {}) {
    if (!buffer || typeof buffer.press !== 'function' || typeof buffer.release !== 'function') {
      throw new TypeError('InputManager exige um ActionBuffer compatível.');
    }

    this.#buffer = buffer;
    this.#keyToActions = buildKeyboardMap(keyboardBindings);
    this.#keyboardTarget = keyboardTarget;
    this.#lifecycleTarget = lifecycleTarget;
    this.#documentTarget = documentTarget;

    this.#onKeyDown = (event) => this.#handleKeyDown(event);
    this.#onKeyUp = (event) => this.#handleKeyUp(event);
    this.#onBlur = () => this.#clearAllSources();
    this.#onVisibilityChange = () => {
      if (this.#documentTarget?.hidden) this.#clearAllSources();
    };

    this.#keyboardTarget?.addEventListener('keydown', this.#onKeyDown);
    this.#keyboardTarget?.addEventListener('keyup', this.#onKeyUp);
    this.#lifecycleTarget?.addEventListener('blur', this.#onBlur);
    this.#documentTarget?.addEventListener(
      'visibilitychange',
      this.#onVisibilityChange,
    );
  }

  get enabled() {
    return this.#enabled;
  }

  setEnabled(enabled) {
    if (typeof enabled !== 'boolean') {
      throw new TypeError('enabled deve ser booleano.');
    }
    if (this.#enabled === enabled) return;
    this.#enabled = enabled;
    if (!enabled) this.#clearAllSources();
  }

  consume() {
    return this.#buffer.consume();
  }

  isHeld(action) {
    return this.#buffer.isHeld(action);
  }

  bindPointerAction(element, action) {
    if (!element || typeof element.addEventListener !== 'function') {
      throw new TypeError('O controle touch precisa aceitar eventos.');
    }
    if (typeof action !== 'string' || action.trim() === '') {
      throw new TypeError('action deve ser uma string não vazia.');
    }

    const bindingId = ++this.#nextBindingId;
    const activePointers = new Map();

    const onPointerDown = (event) => {
      if (!this.#enabled || activePointers.has(event.pointerId)) return;

      event.preventDefault?.();
      const source = `pointer:${bindingId}:${event.pointerId}`;
      activePointers.set(event.pointerId, source);
      this.#buffer.press(action, source);

      try {
        element.setPointerCapture?.(event.pointerId);
      } catch {
        // Pointer capture may fail after browser-level cancellation; the
        // explicit cancel/up handlers still release the action when delivered.
      }
    };

    const releasePointer = (event) => {
      const source = activePointers.get(event.pointerId);
      if (!source) return;

      activePointers.delete(event.pointerId);
      this.#buffer.release(action, source);
    };

    const releaseAllPointers = () => {
      for (const source of activePointers.values()) {
        this.#buffer.release(action, source);
      }
      activePointers.clear();
    };

    element.addEventListener('pointerdown', onPointerDown);
    element.addEventListener('pointerup', releasePointer);
    element.addEventListener('pointercancel', releasePointer);
    element.addEventListener('lostpointercapture', releasePointer);

    const dispose = () => {
      releaseAllPointers();
      element.removeEventListener('pointerdown', onPointerDown);
      element.removeEventListener('pointerup', releasePointer);
      element.removeEventListener('pointercancel', releasePointer);
      element.removeEventListener('lostpointercapture', releasePointer);
      this.#pointerDisposers.delete(dispose);
      this.#pointerResetters.delete(releaseAllPointers);
    };

    this.#pointerDisposers.add(dispose);
    this.#pointerResetters.add(releaseAllPointers);
    return dispose;
  }

  dispose() {
    this.#keyboardTarget?.removeEventListener('keydown', this.#onKeyDown);
    this.#keyboardTarget?.removeEventListener('keyup', this.#onKeyUp);
    this.#lifecycleTarget?.removeEventListener('blur', this.#onBlur);
    this.#documentTarget?.removeEventListener(
      'visibilitychange',
      this.#onVisibilityChange,
    );

    for (const disposePointerBinding of [...this.#pointerDisposers]) {
      disposePointerBinding();
    }

    this.#buffer.clearAll();
    this.#enabled = false;
  }

  #clearAllSources() {
    for (const releasePointers of [...this.#pointerResetters]) {
      releasePointers();
    }
    this.#buffer.clearAll();
  }

  #handleKeyDown(event) {
    if (!this.#enabled) return;

    const actions = this.#keyToActions.get(event.code);
    if (!actions) return;

    event.preventDefault?.();
    const source = `keyboard:${event.code}`;
    for (const action of actions) this.#buffer.press(action, source);
  }

  #handleKeyUp(event) {
    const actions = this.#keyToActions.get(event.code);
    if (!actions) return;

    const source = `keyboard:${event.code}`;
    for (const action of actions) this.#buffer.release(action, source);
  }
}
