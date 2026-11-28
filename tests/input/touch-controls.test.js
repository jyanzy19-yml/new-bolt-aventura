import { describe, expect, it, vi } from 'vitest';
import { InputManager } from '../../src/input/input-manager.js';
import { TouchControls } from '../../src/input/touch-controls.js';

function createElement(tagName) {
  const listeners = new Map();
  return {
    tagName,
    children: [],
    attributes: {},
    dataset: {},
    className: '',
    textContent: '',
    type: '',
    appendChild(child) {
      this.children.push(child);
      child.parent = this;
      return child;
    },
    removeChild(child) {
      this.children = this.children.filter((entry) => entry !== child);
      child.parent = null;
    },
    remove() {
      this.parent?.removeChild(this);
    },
    setAttribute(name, value) {
      this.attributes[name] = value;
    },
    addEventListener(type, listener) {
      const handlers = listeners.get(type) ?? [];
      handlers.push(listener);
      listeners.set(type, handlers);
    },
    removeEventListener(type, listener) {
      listeners.set(
        type,
        (listeners.get(type) ?? []).filter((handler) => handler !== listener),
      );
    },
    dispatch(type, event) {
      for (const listener of listeners.get(type) ?? []) listener(event);
    },
    setPointerCapture: vi.fn(),
  };
}

function createHarness() {
  const documentTarget = {
    createElement: vi.fn((tagName) => createElement(tagName)),
  };
  const inputManager = {
    bindPointerAction: vi.fn((element, action) => vi.fn(() => {
      element.disposedAction = action;
    })),
  };
  const container = createElement('main');
  const controls = new TouchControls({ inputManager, documentTarget });

  return { controls, container, documentTarget, inputManager };
}

describe('TouchControls', () => {
  it('mounts accessible logical controls for movement, jump, Dash, fire and interaction', () => {
    const { controls, container, inputManager } = createHarness();

    expect(controls.mount(container)).toBe(true);
    expect(controls.mounted).toBe(true);
    expect(container.children).toHaveLength(1);

    const root = controls.element;
    expect(root.attributes['aria-label']).toBe('Controles de toque');
    expect(root.children).toHaveLength(2);

    const buttons = root.children.flatMap((group) => group.children);
    expect(buttons.map((button) => button.dataset.action)).toEqual([
      'move-left',
      'move-right',
      'jump',
      'dash',
      'fire',
      'weapon-next',
      'interact',
    ]);
    expect(buttons.every((button) => button.type === 'button')).toBe(true);
    expect(buttons.every((button) => button.attributes['aria-label'])).toBe(true);
    expect(inputManager.bindPointerAction).toHaveBeenCalledTimes(7);
  });

  it('is idempotent when mounted twice', () => {
    const { controls, container, inputManager } = createHarness();

    expect(controls.mount(container)).toBe(true);
    expect(controls.mount(container)).toBe(false);
    expect(container.children).toHaveLength(1);
    expect(inputManager.bindPointerAction).toHaveBeenCalledTimes(7);
  });

  it('disposes all pointer bindings and removes the control root', () => {
    const { controls, container, inputManager } = createHarness();

    controls.mount(container);
    const disposers = inputManager.bindPointerAction.mock.results
      .map((result) => result.value);

    controls.dispose();

    expect(disposers.every((dispose) => dispose.mock.calls.length === 1)).toBe(true);
    expect(container.children).toHaveLength(0);
    expect(controls.mounted).toBe(false);
    expect(controls.dispose()).toBeUndefined();
  });

  it('rolls back bindings if a later pointer binding fails', () => {
    const { controls, container, inputManager } = createHarness();
    inputManager.bindPointerAction
      .mockImplementationOnce(() => vi.fn())
      .mockImplementationOnce(() => vi.fn())
      .mockImplementationOnce(() => {
        throw new Error('binding failed');
      });

    expect(() => controls.mount(container)).toThrow('binding failed');
    expect(container.children).toHaveLength(0);
    expect(controls.mounted).toBe(false);
  });

  it('preserves simultaneous jump and Dash pointers through the real InputManager', () => {
    const documentTarget = {
      createElement: vi.fn((tagName) => createElement(tagName)),
    };
    const container = createElement('main');
    const inputManager = new InputManager({
      keyboardTarget: null,
      lifecycleTarget: null,
      documentTarget: null,
    });
    const controls = new TouchControls({ inputManager, documentTarget });

    controls.mount(container);
    const buttons = controls.element.children.flatMap((group) => group.children);
    const jump = buttons.find((button) => button.dataset.action === 'jump');
    const dash = buttons.find((button) => button.dataset.action === 'dash');

    jump.dispatch('pointerdown', { pointerId: 11, preventDefault: vi.fn() });
    dash.dispatch('pointerdown', { pointerId: 12, preventDefault: vi.fn() });

    expect(inputManager.consume()).toEqual({
      pressed: ['jump', 'dash'],
      released: [],
      held: ['jump', 'dash'],
    });

    jump.dispatch('pointerup', { pointerId: 11 });
    expect(inputManager.consume()).toEqual({
      pressed: [],
      released: ['jump'],
      held: ['dash'],
    });

    dash.dispatch('pointercancel', { pointerId: 12 });
    expect(inputManager.consume()).toEqual({
      pressed: [],
      released: ['dash'],
      held: [],
    });

    controls.dispose();
    inputManager.dispose();
  });

  it('supports a scene-specific touch action subset without showing unused actions', () => {
    const documentTarget = {
      createElement: vi.fn((tagName) => createElement(tagName)),
    };
    const inputManager = { bindPointerAction: vi.fn(() => vi.fn()) };
    const container = createElement('main');
    const controls = new TouchControls({
      inputManager,
      documentTarget,
      enabledActions: ['move-left', 'move-right', 'jump', 'dash', 'interact'],
    });

    controls.mount(container);
    const actions = controls.element.children
      .flatMap((group) => group.children)
      .map((button) => button.dataset.action);

    expect(actions).toEqual(['move-left', 'move-right', 'jump', 'dash', 'interact']);
    expect(actions).not.toContain('fire');
    controls.dispose();
  });

  it('rejects incompatible input manager, document and container', () => {
    expect(() => new TouchControls({ inputManager: {} })).toThrow(TypeError);

    const inputManager = { bindPointerAction: vi.fn() };
    expect(() => new TouchControls({
      inputManager,
      documentTarget: {},
    })).toThrow(TypeError);

    const controls = new TouchControls({
      inputManager,
      documentTarget: { createElement },
    });
    expect(() => controls.mount(null)).toThrow(TypeError);
  });
});
