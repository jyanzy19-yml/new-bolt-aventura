function assertPositiveFinite(value, name) {
  if (!Number.isFinite(value) || value <= 0) {
    throw new RangeError(`${name} deve ser finito e maior que zero.`);
  }
}

function assertUnitInterval(value, name) {
  if (!Number.isFinite(value) || value < 0 || value > 1) {
    throw new RangeError(`${name} deve estar entre zero e um.`);
  }
}

function copyPlayerSnapshot(snapshot, name) {
  if (!snapshot || typeof snapshot !== 'object' || !snapshot.body) {
    throw new TypeError(`${name} precisa ser um snapshot de jogador.`);
  }
  const { body, velocity } = snapshot;
  for (const key of ['x', 'y', 'width', 'height']) {
    if (!Number.isFinite(body[key])) {
      throw new TypeError(`${name}.body.${key} deve ser finito.`);
    }
  }
  if (!velocity || !Number.isFinite(velocity.x) || !Number.isFinite(velocity.y)) {
    throw new TypeError(`${name}.velocity deve conter componentes finitos.`);
  }

  return {
    ...snapshot,
    body: { ...body },
    velocity: { ...velocity },
  };
}

function copyCameraPosition(position, name) {
  if (!position || !Number.isFinite(position.x) || !Number.isFinite(position.y)) {
    throw new TypeError(`${name} precisa conter coordenadas finitas.`);
  }
  return { x: position.x, y: position.y };
}

function interpolate(previous, current, alpha) {
  return previous + (current - previous) * alpha;
}

/**
 * Composes normalized input, PlayerMotor, camera and renderer for one player
 * scene. FixedStepLoop can call update(dt) and render(alpha) directly.
 */
export class PlayerSceneRuntime {
  #inputManager;
  #playerMotor;
  #camera;
  #renderer;
  #level;
  #previousPlayer;
  #currentPlayer;
  #previousCamera;
  #currentCamera;

  constructor({ inputManager, playerMotor, camera, renderer, level }) {
    if (!inputManager || typeof inputManager.consume !== 'function') {
      throw new TypeError('inputManager precisa implementar consume().');
    }
    if (!playerMotor || typeof playerMotor.update !== 'function' ||
        !playerMotor.snapshot || typeof playerMotor.reset !== 'function') {
      throw new TypeError('playerMotor precisa implementar update(), reset() e snapshot.');
    }
    if (!camera || typeof camera.reset !== 'function' ||
        typeof camera.update !== 'function') {
      throw new TypeError('camera precisa implementar reset() e update().');
    }
    if (!renderer || typeof renderer.render !== 'function') {
      throw new TypeError('renderer precisa implementar render().');
    }
    if (!level || typeof level !== 'object' || !level.geometry) {
      throw new TypeError('level carregado com geometry é obrigatório.');
    }

    this.#inputManager = inputManager;
    this.#playerMotor = playerMotor;
    this.#camera = camera;
    this.#renderer = renderer;
    this.#level = level;

    this.#currentPlayer = copyPlayerSnapshot(
      playerMotor.snapshot,
      'playerMotor.snapshot',
    );
    this.#previousPlayer = copyPlayerSnapshot(
      this.#currentPlayer,
      'initial player snapshot',
    );
    this.#currentCamera = copyCameraPosition(
      camera.reset(this.#currentPlayer.body),
      'camera.reset()',
    );
    this.#previousCamera = { ...this.#currentCamera };
  }

  get playerSnapshot() {
    return copyPlayerSnapshot(this.#currentPlayer, 'playerSnapshot');
  }

  update(deltaSeconds) {
    assertPositiveFinite(deltaSeconds, 'deltaSeconds');

    this.#previousPlayer = copyPlayerSnapshot(
      this.#currentPlayer,
      'previous player snapshot',
    );
    this.#previousCamera = { ...this.#currentCamera };

    const inputFrame = this.#inputManager.consume();
    this.#currentPlayer = copyPlayerSnapshot(
      this.#playerMotor.update(deltaSeconds, inputFrame),
      'playerMotor.update()',
    );

    this.#currentCamera = copyCameraPosition(
      this.#camera.update(
        {
          ...this.#currentPlayer.body,
          vx: this.#currentPlayer.velocity.x,
        },
        deltaSeconds,
      ),
      'camera.update()',
    );

    return this.playerSnapshot;
  }

  render(alpha = 1) {
    assertUnitInterval(alpha, 'alpha');

    const player = {
      ...this.#currentPlayer,
      body: {
        ...this.#currentPlayer.body,
        x: interpolate(
          this.#previousPlayer.body.x,
          this.#currentPlayer.body.x,
          alpha,
        ),
        y: interpolate(
          this.#previousPlayer.body.y,
          this.#currentPlayer.body.y,
          alpha,
        ),
      },
    };
    const camera = {
      x: interpolate(this.#previousCamera.x, this.#currentCamera.x, alpha),
      y: interpolate(this.#previousCamera.y, this.#currentCamera.y, alpha),
    };

    return this.#renderer.render({
      level: this.#level,
      player,
      camera,
    });
  }

  reset(body, options = {}) {
    const resetSnapshot = copyPlayerSnapshot(
      this.#playerMotor.reset(body, options),
      'playerMotor.reset()',
    );
    const cameraPosition = copyCameraPosition(
      this.#camera.reset(resetSnapshot.body),
      'camera.reset()',
    );

    this.#currentPlayer = resetSnapshot;
    this.#previousPlayer = copyPlayerSnapshot(
      resetSnapshot,
      'reset player snapshot',
    );
    this.#currentCamera = cameraPosition;
    this.#previousCamera = { ...cameraPosition };

    return this.playerSnapshot;
  }
}
