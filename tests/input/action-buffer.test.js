import { describe, expect, it } from 'vitest';
import { ActionBuffer } from '../../src/input/action-buffer.js';

describe('ActionBuffer', () => {
  it('preserves a short press and release between simulation ticks', () => {
    const buffer = new ActionBuffer();

    buffer.press('jump', 'keyboard:Space');
    buffer.release('jump', 'keyboard:Space');

    expect(buffer.consume()).toEqual({
      pressed: ['jump'],
      released: ['jump'],
      held: [],
    });
  });

  it('keeps an action held until every source releases it', () => {
    const buffer = new ActionBuffer();

    buffer.press('jump', 'pointer:1');
    buffer.press('jump', 'keyboard:Space');
    buffer.release('jump', 'pointer:1');

    expect(buffer.isHeld('jump')).toBe(true);
    expect(buffer.consume()).toEqual({
      pressed: ['jump'],
      released: [],
      held: ['jump'],
    });

    buffer.release('jump', 'keyboard:Space');
    expect(buffer.consume()).toEqual({
      pressed: [],
      released: ['jump'],
      held: [],
    });
  });

  it('deduplicates repeated presses and unknown releases', () => {
    const buffer = new ActionBuffer();

    expect(buffer.press('dash', 'keyboard:Shift')).toBe(true);
    expect(buffer.press('dash', 'keyboard:Shift')).toBe(false);
    expect(buffer.release('dash', 'unknown')).toBe(false);
    expect(buffer.consume()).toEqual({
      pressed: ['dash'],
      released: [],
      held: ['dash'],
    });
  });

  it('clears all actions owned by a source', () => {
    const buffer = new ActionBuffer();

    buffer.press('jump', 'pointer:1');
    buffer.press('attack', 'pointer:1');
    expect(buffer.clearSource('pointer:1')).toBe(true);

    expect(buffer.consume()).toEqual({
      pressed: ['jump', 'attack'],
      released: ['jump', 'attack'],
      held: [],
    });
  });

  it('hard-resets held state and pending edges', () => {
    const buffer = new ActionBuffer();

    buffer.press('dash', 'keyboard:Shift');
    buffer.clearAll();

    expect(buffer.isHeld('dash')).toBe(false);
    expect(buffer.consume()).toEqual({
      pressed: [],
      released: [],
      held: [],
    });
  });

  it('rejects invalid action and source identifiers', () => {
    const buffer = new ActionBuffer();

    expect(() => buffer.press('', 'source')).toThrow(TypeError);
    expect(() => buffer.press('jump', '')).toThrow(TypeError);
    expect(() => buffer.release('jump', '')).toThrow(TypeError);
  });
});
