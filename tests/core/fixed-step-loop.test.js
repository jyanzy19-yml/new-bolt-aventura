import { describe, expect, it, vi } from 'vitest';
import { FixedStepLoop } from '../../src/core/fixed-step-loop.js';

function createScheduler() {
  let nextId = 0;
  const callbacks = new Map();

  return {
    callbacks,
    requestFrame(callback) {
      const id = ++nextId;
      callbacks.set(id, callback);
      return id;
    },
    cancelFrame(id) {
      callbacks.delete(id);
    },
    fire(timestampMs) {
      const next = callbacks.entries().next().value;
      if (!next) throw new Error('Nenhum frame agendado.');
      const [id, callback] = next;
      callbacks.delete(id);
      callback(timestampMs);
    },
  };
}

function createLoop(options = {}) {
  const scheduler = createScheduler();
  const update = vi.fn();
  const render = vi.fn();

  const loop = new FixedStepLoop({
    update,
    render,
    requestFrame: scheduler.requestFrame,
    cancelFrame: scheduler.cancelFrame,
    ...options,
  });

  return { loop, scheduler, update, render };
}

describe('FixedStepLoop', () => {
  it('renders the first frame without advancing simulation', () => {
    const { loop, scheduler, update, render } = createLoop();

    expect(loop.start()).toBe(true);
    scheduler.fire(100);

    expect(update).not.toHaveBeenCalled();
    expect(render).toHaveBeenCalledTimes(1);
    expect(render).toHaveBeenCalledWith(0);
    expect(scheduler.callbacks.size).toBe(1);
  });

  it('advances simulation using a fixed delta', () => {
    const { loop, scheduler, update } = createLoop();

    loop.start();
    scheduler.fire(0);
    scheduler.fire(1000 / 60);

    expect(update).toHaveBeenCalledTimes(1);
    expect(update).toHaveBeenCalledWith((1000 / 60) / 1000);
  });

  it('passes fractional accumulator progress to rendering', () => {
    const { loop, scheduler, update, render } = createLoop();

    loop.start();
    scheduler.fire(0);
    scheduler.fire(1000 / 120);

    expect(update).not.toHaveBeenCalled();
    expect(render).toHaveBeenLastCalledWith(0.5);
  });

  it('caps catch-up work after a long frame hitch', () => {
    const { loop, scheduler, update } = createLoop({
      stepMs: 10,
      maxFrameDeltaMs: 100,
      maxStepsPerFrame: 3,
    });

    loop.start();
    scheduler.fire(0);
    scheduler.fire(1000);

    expect(update).toHaveBeenCalledTimes(3);
    expect(update).toHaveBeenCalledWith(0.01);
  });

  it('does not accumulate negative time when timestamps move backwards', () => {
    const { loop, scheduler, update } = createLoop({
      stepMs: 10,
      maxFrameDeltaMs: 100,
      maxStepsPerFrame: 5,
    });

    loop.start();
    scheduler.fire(100);
    scheduler.fire(90);
    expect(update).not.toHaveBeenCalled();

    scheduler.fire(100);
    expect(update).toHaveBeenCalledTimes(1);
  });

  it('makes start and stop idempotent and cancels the pending frame', () => {
    const { loop, scheduler } = createLoop();

    expect(loop.start()).toBe(true);
    expect(loop.start()).toBe(false);
    expect(scheduler.callbacks.size).toBe(1);

    expect(loop.stop()).toBe(true);
    expect(loop.stop()).toBe(false);
    expect(loop.running).toBe(false);
    expect(scheduler.callbacks.size).toBe(0);
  });

  it('stops and propagates update failures', () => {
    const scheduler = createScheduler();
    const failure = new Error('update failed');
    const loop = new FixedStepLoop({
      update: () => {
        throw failure;
      },
      render: vi.fn(),
      requestFrame: scheduler.requestFrame,
      cancelFrame: scheduler.cancelFrame,
      stepMs: 10,
    });

    loop.start();
    scheduler.fire(0);

    expect(() => scheduler.fire(10)).toThrow(failure);
    expect(loop.running).toBe(false);
    expect(scheduler.callbacks.size).toBe(0);
  });

  it('stops when the initial render callback fails', () => {
    const scheduler = createScheduler();
    const failure = new Error('render failed');
    const loop = new FixedStepLoop({
      update: vi.fn(),
      render: () => {
        throw failure;
      },
      requestFrame: scheduler.requestFrame,
      cancelFrame: scheduler.cancelFrame,
    });

    loop.start();
    expect(() => scheduler.fire(0)).toThrow(failure);
    expect(loop.running).toBe(false);
    expect(scheduler.callbacks.size).toBe(0);
  });

  it('stops when scheduling the next frame fails', () => {
    const scheduler = createScheduler();
    const failure = new Error('scheduler failed');
    let calls = 0;
    const loop = new FixedStepLoop({
      update: vi.fn(),
      render: vi.fn(),
      requestFrame: (callback) => {
        calls += 1;
        if (calls > 1) throw failure;
        return scheduler.requestFrame(callback);
      },
      cancelFrame: scheduler.cancelFrame,
      stepMs: 10,
    });

    loop.start();
    expect(() => scheduler.fire(0)).toThrow(failure);
    expect(loop.running).toBe(false);
    expect(scheduler.callbacks.size).toBe(0);
  });

  it('rejects invalid callbacks and timing configuration', () => {
    const scheduler = createScheduler();
    const valid = {
      update: vi.fn(),
      render: vi.fn(),
      requestFrame: scheduler.requestFrame,
      cancelFrame: scheduler.cancelFrame,
    };

    expect(() => new FixedStepLoop({ ...valid, update: null })).toThrow(TypeError);
    expect(() => new FixedStepLoop({ ...valid, render: null })).toThrow(TypeError);
    expect(() => new FixedStepLoop({ ...valid, stepMs: 0 })).toThrow(RangeError);
    expect(() =>
      new FixedStepLoop({ ...valid, stepMs: 20, maxFrameDeltaMs: 10 }),
    ).toThrow(RangeError);
    expect(() =>
      new FixedStepLoop({ ...valid, maxStepsPerFrame: 0 }),
    ).toThrow(RangeError);
  });
});
