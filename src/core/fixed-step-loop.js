/**
 * Browser-independent fixed-step simulation loop.
 *
 * Simulation advances in constant time slices while rendering receives an
 * interpolation alpha. The scheduler is injectable so timing behavior can be
 * tested without a browser or a real display refresh cycle.
 */
export class FixedStepLoop {
  #update;
  #render;
  #requestFrame;
  #cancelFrame;
  #stepMs;
  #maxFrameDeltaMs;
  #maxStepsPerFrame;
  #running = false;
  #frameId = null;
  #lastTimestamp = null;
  #accumulator = 0;
  #onFrame;

  constructor({
    update,
    render,
    requestFrame = (callback) => globalThis.requestAnimationFrame(callback),
    cancelFrame = (frameId) => globalThis.cancelAnimationFrame(frameId),
    stepMs = 1000 / 60,
    maxFrameDeltaMs = 250,
    maxStepsPerFrame = 5,
  }) {
    if (typeof update !== 'function') {
      throw new TypeError('FixedStepLoop exige uma função update.');
    }
    if (typeof render !== 'function') {
      throw new TypeError('FixedStepLoop exige uma função render.');
    }
    if (typeof requestFrame !== 'function' || typeof cancelFrame !== 'function') {
      throw new TypeError('FixedStepLoop exige funções válidas de agendamento.');
    }
    if (!Number.isFinite(stepMs) || stepMs <= 0) {
      throw new RangeError('stepMs deve ser um número finito maior que zero.');
    }
    if (
      !Number.isFinite(maxFrameDeltaMs) ||
      maxFrameDeltaMs < stepMs
    ) {
      throw new RangeError('maxFrameDeltaMs deve ser finito e maior ou igual a stepMs.');
    }
    if (!Number.isInteger(maxStepsPerFrame) || maxStepsPerFrame < 1) {
      throw new RangeError('maxStepsPerFrame deve ser um inteiro positivo.');
    }

    this.#update = update;
    this.#render = render;
    this.#requestFrame = requestFrame;
    this.#cancelFrame = cancelFrame;
    this.#stepMs = stepMs;
    this.#maxFrameDeltaMs = maxFrameDeltaMs;
    this.#maxStepsPerFrame = maxStepsPerFrame;
    this.#onFrame = (timestampMs) => this.#handleFrame(timestampMs);
  }

  get running() {
    return this.#running;
  }

  start() {
    if (this.#running) return false;

    this.#running = true;
    this.#lastTimestamp = null;
    this.#accumulator = 0;

    try {
      this.#scheduleNextFrame();
    } catch (error) {
      this.#running = false;
      throw error;
    }

    return true;
  }

  stop() {
    if (!this.#running) return false;

    this.#running = false;

    if (this.#frameId !== null) {
      this.#cancelFrame(this.#frameId);
      this.#frameId = null;
    }

    this.#lastTimestamp = null;
    this.#accumulator = 0;
    return true;
  }

  #scheduleNextFrame() {
    if (this.#running) {
      this.#frameId = this.#requestFrame(this.#onFrame);
    }
  }

  #handleFrame(timestampMs) {
    this.#frameId = null;
    if (!this.#running) return;

    if (!Number.isFinite(timestampMs)) {
      this.stop();
      throw new TypeError('O timestamp do frame deve ser finito.');
    }

    if (this.#lastTimestamp === null) {
      this.#lastTimestamp = timestampMs;
      this.#render(0);
      this.#scheduleNextFrame();
      return;
    }

    const elapsedMs = Math.max(0, timestampMs - this.#lastTimestamp);
    this.#lastTimestamp = timestampMs;

    const acceptedDeltaMs = Math.min(elapsedMs, this.#maxFrameDeltaMs);
    this.#accumulator += acceptedDeltaMs;

    let steps = 0;
    try {
      while (
        this.#accumulator + Number.EPSILON >= this.#stepMs &&
        steps < this.#maxStepsPerFrame
      ) {
        this.#update(this.#stepMs / 1000);
        this.#accumulator = Math.max(0, this.#accumulator - this.#stepMs);
        steps += 1;

        if (!this.#running) return;
      }

      // Drop whole overdue steps instead of entering a spiral of death.
      if (this.#accumulator >= this.#stepMs) {
        this.#accumulator %= this.#stepMs;
      }

      this.#render(this.#accumulator / this.#stepMs);
    } catch (error) {
      this.stop();
      throw error;
    }

    this.#scheduleNextFrame();
  }
}
