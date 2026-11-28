import { describe, expect, it, vi } from 'vitest';
import { InputManager } from '../../src/input/input-manager.js';

function createEventTarget() {
  const listeners = new Map();

  return {
    addEventListener(type, listener) {
      const entries = listeners.get(type) ?? new Set();
      entries.add(listener);
      listeners.set(type, entries);
    },
    removeEventListener(type, listener) {
      listeners.get(type)?.delete(listener);
    },
    dispatch(type, event = {}) {
      for (const listener of listeners.get(type) ?? []) listener(event);
    },
    listenerCount(type) {
      return listeners.get(type)?.size ?? 0;
    },
  };
}

function createManager(options = {}) {
  const keyboardTarget = createEventTarget();
  const lifecycleTarget = createEventTarget();
  const documentTarget = createEventTarget();
  const manager = new InputManager({
    keyboardTarget,
    lifecycleTarget,
    documentTarget,
    keyboardBindings: { jump: ['Space', 'KeyW'], dash: ['ShiftLeft'] },
    ...options,
  });

  return { manager, keyboardTarget, lifecycleTarget, documentTarget };
}

describe('InputManager keyboard', () => {
  it('maps key edges and prevents browser defaults for bound keys', () => {
    const { manager, keyboardTarget } = createManager();
    const preventDefault = vi.fn();

    keyboardTarget.dispatch('keydown', { code: 'Space', preventDefault });
    keyboardTarget.dispatch('keydown', { code: 'Space', repeat: true, preventDefault });

    expect(preventDefault).toHaveBeenCalledTimes(2);
    expect(manager.consume()).toEqual({
      pressed: ['jump'],
      released: [],
      held: ['jump'],
    });

    keyboardTarget.dispatch('keyup', { code: 'Space' });
    expect(manager.consume()).toEqual({
      pressed: [],
      released: ['jump'],
      held: [],
    });
  });

  it('clears held and pending input on blur and hidden visibility', () => {
    const { manager, keyboardTarget, lifecycleTarget, documentTarget } =
      createManager();

    keyboardTarget.dispatch('keydown', { code: 'ShiftLeft' });
    lifecycleTarget.dispatch('blur');
    expect(manager.consume()).toEqual({
      pressed: [],
      released: [],
      held: [],
    });

    keyboardTarget.dispatch('keydown', { code: 'Space' });
    documentTarget.hidden = true;
    documentTarget.dispatch('visibilitychange');
    expect(manager.isHeld('jump')).toBe(false);
    expect(manager.consume()).toEqual({
      pressed: [],
      released: [],
      held: [],
    });
  });

  it('ignores input while disabled and releases state when disabling', () => {
    const { manager, keyboardTarget } = createManager();

    keyboardTarget.dispatch('keydown', { code: 'Space' });
    manager.setEnabled(false);
    keyboardTarget.dispatch('keydown', { code: 'ShiftLeft' });

    expect(manager.isHeld('jump')).toBe(false);
    expect(manager.isHeld('dash')).toBe(false);
    expect(manager.consume()).toEqual({
      pressed: [],
      released: [],
      held: [],
    });
  });

  it('removes keyboard and lifecycle listeners on dispose', () => {
    const { manager, keyboardTarget, lifecycleTarget, documentTarget } =
      createManager();

    manager.dispose();

    expect(keyboardTarget.listenerCount('keydown')).toBe(0);
    expect(keyboardTarget.listenerCount('keyup')).toBe(0);
    expect(lifecycleTarget.listenerCount('blur')).toBe(0);
    expect(documentTarget.listenerCount('visibilitychange')).toBe(0);
  });

  it('rejects invalid keyboard binding configuration', () => {
    expect(
      () =>
        new InputManager({
          keyboardTarget: null,
          lifecycleTarget: null,
          documentTarget: null,
          keyboardBindings: { jump: 'Space' },
        }),
    ).toThrow(TypeError);
  });
});

describe('InputManager pointer controls', () => {
  it('supports simultaneous pointers without prematurely releasing an action', () => {
    const { manager } = createManager();
    const button = createEventTarget();
    const setPointerCapture = vi.fn();
    button.setPointerCapture = setPointerCapture;
    manager.bindPointerAction(button, 'jump');

    const preventDefault = vi.fn();
    button.dispatch('pointerdown', { pointerId: 1, preventDefault });
    button.dispatch('pointerdown', { pointerId: 2, preventDefault });
    button.dispatch('pointerup', { pointerId: 1 });

    expect(setPointerCapture).toHaveBeenCalledTimes(2);
    expect(preventDefault).toHaveBeenCalledTimes(2);
    expect(manager.consume()).toEqual({
      pressed: ['jump'],
      released: [],
      held: ['jump'],
    });

    button.dispatch('pointercancel', { pointerId: 2 });
    expect(manager.consume()).toEqual({
      pressed: [],
      released: ['jump'],
      held: [],
    });
  });

  it('releases a pointer on lost capture and disposes the binding', () => {
    const { manager } = createManager();
    const button = createEventTarget();
    const dispose = manager.bindPointerAction(button, 'dash');

    button.dispatch('pointerdown', { pointerId: 7 });
    button.dispatch('lostpointercapture', { pointerId: 7 });
    expect(manager.consume()).toEqual({
      pressed: ['dash'],
      released: ['dash'],
      held: [],
    });

    button.dispatch('pointerdown', { pointerId: 8 });
    dispose();
    expect(manager.consume()).toEqual({
      pressed: ['dash'],
      released: ['dash'],
      held: [],
    });
    expect(button.listenerCount('pointerdown')).toBe(0);
  });

  it('clears pointer ownership on blur so a reused pointer ID is accepted', () => {
    const { manager, lifecycleTarget } = createManager();
    const button = createEventTarget();
    manager.bindPointerAction(button, 'jump');

    button.dispatch('pointerdown', { pointerId: 21 });
    lifecycleTarget.dispatch('blur');

    expect(manager.consume()).toEqual({
      pressed: [],
      released: [],
      held: [],
    });

    button.dispatch('pointerdown', { pointerId: 21 });
    expect(manager.consume()).toEqual({
      pressed: ['jump'],
      released: [],
      held: ['jump'],
    });

    manager.setEnabled(false);
    manager.setEnabled(true);
    button.dispatch('pointerdown', { pointerId: 21 });

    expect(manager.consume()).toEqual({
      pressed: ['jump'],
      released: [],
      held: ['jump'],
    });
  });

  it('does not capture pointer input while disabled', () => {
    const { manager } = createManager();
    const button = createEventTarget();
    const capture = vi.fn();
    button.setPointerCapture = capture;
    manager.bindPointerAction(button, 'jump');
    manager.setEnabled(false);

    button.dispatch('pointerdown', { pointerId: 1 });

    expect(capture).not.toHaveBeenCalled();
    expect(manager.consume()).toEqual({
      pressed: [],
      released: [],
      held: [],
    });
  });
});
