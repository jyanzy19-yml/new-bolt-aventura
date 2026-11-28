import './styles.css';

import { FixedStepLoop } from './core/fixed-step-loop.js';
import { InputManager } from './input/input-manager.js';
import { TouchControls } from './input/touch-controls.js';
import { PlayerMotor } from './gameplay/player-motor.js';
import { PlayerSceneRuntime } from './gameplay/player-scene-runtime.js';
import { LevelRuntime } from './levels/level-runtime.js';
import { createLevelCollisionWorld } from './levels/level-collision-adapter.js';
import {
  DEBUG_KEYBOARD_BINDINGS,
  DEBUG_PLAYER_TUNING,
  DEBUG_W1_L1,
} from './levels/fixtures/w1-l1-debug.js';
import { Camera2D } from './rendering/camera-2d.js';
import { CanvasSurface } from './rendering/canvas-surface.js';
import { DebugCanvasRenderer } from './rendering/debug-canvas-renderer.js';

const LOGICAL_WIDTH = 800;
const LOGICAL_HEIGHT = 450;
const root = document.querySelector('#app');

if (!root) {
  throw new Error('Elemento raiz #app não encontrado.');
}

function createElement(tag, className, text) {
  const element = document.createElement(tag);
  if (className) element.className = className;
  if (text !== undefined) element.textContent = text;
  return element;
}

function bootDebugSlice() {
  const screen = createElement('main', 'game-screen');
  const canvas = createElement('canvas', 'game-canvas');
  canvas.width = LOGICAL_WIDTH;
  canvas.height = LOGICAL_HEIGHT;
  canvas.setAttribute('role', 'img');
  canvas.setAttribute(
    'aria-label',
    'Protótipo de depuração de BOLT AVENTURA, fase W1-L1',
  );

  const orientationHint = createElement(
    'p',
    'orientation-hint',
    'Gire o dispositivo para jogar na horizontal.',
  );
  const status = createElement(
    'p',
    'game-status',
    'PROTÓTIPO DEBUG · W1-L1 · A/D ou setas · Espaço pula · Shift usa Dash',
  );

  screen.appendChild(canvas);
  root.replaceChildren(screen);

  const surface = new CanvasSurface(canvas, {
    logicalWidth: LOGICAL_WIDTH,
    logicalHeight: LOGICAL_HEIGHT,
    maxDpr: 1.5,
  });

  const resizeSurface = () => {
    const rect = canvas.getBoundingClientRect();
    if (rect.width <= 0 || rect.height <= 0) return;
    surface.resize(rect.width, rect.height, window.devicePixelRatio || 1);
  };

  const resizeObserver = typeof ResizeObserver === 'function'
    ? new ResizeObserver(resizeSurface)
    : null;
  resizeObserver?.observe(canvas);
  window.addEventListener('resize', resizeSurface);

  const inputManager = new InputManager({
    keyboardBindings: DEBUG_KEYBOARD_BINDINGS,
  });
  const touchControls = new TouchControls({
    inputManager,
    enabledActions: ['move-left', 'move-right', 'jump', 'dash'],
  });
  touchControls.mount(screen);
  screen.appendChild(orientationHint);
  screen.appendChild(status);

  const levelRuntime = new LevelRuntime();
  const level = levelRuntime.load(DEBUG_W1_L1);
  const collisionWorld = createLevelCollisionWorld(level);
  const playerMotor = new PlayerMotor({
    body: {
      x: level.spawn.x,
      y: level.spawn.y,
      width: 30,
      height: 46,
    },
    collisionWorld,
    config: DEBUG_PLAYER_TUNING,
  });
  const camera = new Camera2D({
    viewportWidth: LOGICAL_WIDTH,
    viewportHeight: LOGICAL_HEIGHT,
    worldBounds: level.bounds,
    deadZone: { x: 300, y: 150, width: 200, height: 120 },
    lookAheadX: 48,
    smoothing: 8,
  });
  const renderer = new DebugCanvasRenderer(surface);
  const sceneRuntime = new PlayerSceneRuntime({
    inputManager,
    playerMotor,
    camera,
    renderer,
    level,
  });
  const loop = new FixedStepLoop({
    update: (deltaSeconds) => sceneRuntime.update(deltaSeconds),
    render: (alpha) => sceneRuntime.render(alpha),
    stepMs: 1000 / 60,
    maxFrameDeltaMs: 250,
    maxStepsPerFrame: 5,
  });

  let disposed = false;
  const onVisibilityChange = () => {
    if (document.hidden) {
      loop.stop();
      inputManager.setEnabled(false);
      return;
    }
    inputManager.setEnabled(true);
    loop.start();
  };
  const onBlur = () => {
    loop.stop();
    inputManager.setEnabled(false);
  };
  const onFocus = () => {
    if (document.hidden || disposed) return;
    inputManager.setEnabled(true);
    loop.start();
  };
  const dispose = () => {
    if (disposed) return;
    disposed = true;
    loop.stop();
    resizeObserver?.disconnect();
    window.removeEventListener('resize', resizeSurface);
    window.removeEventListener('blur', onBlur);
    window.removeEventListener('focus', onFocus);
    document.removeEventListener('visibilitychange', onVisibilityChange);
    touchControls.dispose();
    inputManager.dispose();
    levelRuntime.unload();
  };

  document.addEventListener('visibilitychange', onVisibilityChange);
  window.addEventListener('blur', onBlur);
  window.addEventListener('focus', onFocus);
  window.addEventListener('pagehide', dispose, { once: true });

  resizeSurface();
  loop.start();

  return dispose;
}

try {
  bootDebugSlice();
} catch (error) {
  root.replaceChildren(
    createElement(
      'p',
      'boot-error',
      'Não foi possível iniciar o protótipo de depuração. Consulte o console.',
    ),
  );
  throw error;
}
