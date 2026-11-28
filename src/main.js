import './styles.css';

import { FixedStepLoop } from './core/fixed-step-loop.js';
import { InputManager } from './input/input-manager.js';
import { TouchControls } from './input/touch-controls.js';
import { PlayerMotor } from './gameplay/player-motor.js';
import { PlayerSceneRuntime } from './gameplay/player-scene-runtime.js';
import { W1L1GameRuntime } from './gameplay/w1-l1-game-runtime.js';
import { LevelRuntime } from './levels/level-runtime.js';
import { createLevelCollisionWorld } from './levels/level-collision-adapter.js';
import { W1_L1, W1_L1_KEYBOARD_BINDINGS, W1_L1_PLAYER_TUNING } from './levels/w1-l1.js';
import { Camera2D } from './rendering/camera-2d.js';
import { CanvasSurface } from './rendering/canvas-surface.js';
import { W1L1CanvasRenderer } from './rendering/w1-l1-canvas-renderer.js';

const LOGICAL_WIDTH = 800;
const LOGICAL_HEIGHT = 450;
const root = document.querySelector('#app');

if (!root) throw new Error('Elemento raiz #app não encontrado.');

function element(tag, className, text) {
  const node = document.createElement(tag);
  if (className) node.className = className;
  if (text !== undefined) node.textContent = text;
  return node;
}

function showStartScreen() {
  const screen = element('main', 'start-screen');
  const panel = element('section', 'start-panel');
  const eyebrow = element('p', 'start-eyebrow', 'UMA AVENTURA COMEÇA');
  const title = element('h1', 'start-title', 'BOLT · AVENTURA');
  const phase = element('h2', 'start-phase', 'DESPERTAR ENTRE RUÍNAS');
  const copy = element('p', 'start-copy', 'BOLT desperta em Cybercore sem memória. Um sinal fragmentado aponta o caminho para fora das ruínas.');
  const start = element('button', 'primary-button', 'INICIAR FASE');
  start.type = 'button';
  const controls = element('p', 'start-controls', 'TECLADO: A/D ou setas · Espaço: pular · Shift/C: Dash · E: interagir · P: pausar');
  panel.append(eyebrow, title, phase, copy, start, controls);
  screen.appendChild(panel);
  root.replaceChildren(screen);
  start.addEventListener('click', () => bootLevel());
}

function bootLevel() {
  const screen = element('main', 'game-screen');
  const topbar = element('header', 'game-topbar');
  const brand = element('span', 'game-brand', 'BOLT · AVENTURA');
  const phase = element('span', 'game-phase', 'W1-L1 / CYBERCORE');
  const pauseButton = element('button', 'pause-button', 'PAUSAR');
  pauseButton.type = 'button';
  topbar.append(brand, phase, pauseButton);

  const canvas = element('canvas', 'game-canvas');
  canvas.width = LOGICAL_WIDTH;
  canvas.height = LOGICAL_HEIGHT;
  canvas.setAttribute('role', 'img');
  canvas.setAttribute('aria-label', 'BOLT em Despertar entre Ruínas, primeira fase de Cybercore');

  const orientationHint = element('p', 'orientation-hint', 'Gire o dispositivo para jogar na horizontal.');
  const status = element('p', 'game-status', 'TOUCH: movimento · PULAR · DASH · AÇÃO   |   TECLADO: A/D · Espaço · Shift · E');
  const pauseOverlay = element('section', 'pause-overlay');
  const completionOverlay = element('section', 'completion-overlay');
  completionOverlay.hidden = true;
  const completionPanel = element('div', 'completion-panel');
  const completionTitle = element('h2', '', 'FASE CONCLUÍDA');
  const completionCopy = element('p', '', 'O primeiro ponto de sincronização foi ativado. W1-L2 ainda está em produção.');
  const restartButton = element('button', 'primary-button', 'REJOGAR W1-L1');
  restartButton.type = 'button';
  completionPanel.append(completionTitle, completionCopy, restartButton);
  completionOverlay.appendChild(completionPanel);
  pauseOverlay.hidden = true;
  const pausePanel = element('div', 'pause-panel');
  const pauseTitle = element('h2', '', 'JOGO PAUSADO');
  const resumeButton = element('button', 'primary-button', 'CONTINUAR');
  resumeButton.type = 'button';
  pausePanel.append(pauseTitle, resumeButton);
  pauseOverlay.appendChild(pausePanel);
  screen.append(topbar, canvas, orientationHint, status, pauseOverlay, completionOverlay);
  root.replaceChildren(screen);

  const surface = new CanvasSurface(canvas, {
    logicalWidth: LOGICAL_WIDTH,
    logicalHeight: LOGICAL_HEIGHT,
    maxDpr: 1.5,
  });
  const resizeSurface = () => {
    const rect = canvas.getBoundingClientRect();
    if (rect.width > 0 && rect.height > 0) {
      surface.resize(rect.width, rect.height, window.devicePixelRatio || 1);
    }
  };
  const resizeObserver = typeof ResizeObserver === 'function' ? new ResizeObserver(resizeSurface) : null;
  resizeObserver?.observe(canvas);
  window.addEventListener('resize', resizeSurface);

  const inputManager = new InputManager({ keyboardBindings: W1_L1_KEYBOARD_BINDINGS });
  const touchControls = new TouchControls({
    inputManager,
    enabledActions: ['move-left', 'move-right', 'jump', 'dash', 'interact'],
  });
  touchControls.mount(screen);

  const levelRuntime = new LevelRuntime();
  const level = levelRuntime.load(W1_L1);
  const collisionWorld = createLevelCollisionWorld(level);
  const playerMotor = new PlayerMotor({
    body: { x: level.spawn.x, y: level.spawn.y, width: 30, height: 46 },
    collisionWorld,
    config: W1_L1_PLAYER_TUNING,
  });
  const camera = new Camera2D({
    viewportWidth: LOGICAL_WIDTH,
    viewportHeight: LOGICAL_HEIGHT,
    worldBounds: level.bounds,
    deadZone: { x: 280, y: 145, width: 240, height: 150 },
    lookAheadX: 48,
    smoothing: 8,
  });
  const renderer = new W1L1CanvasRenderer(surface);
  const gameRuntime = new W1L1GameRuntime(level);
  let latestInputFrame = { pressed: [], released: [], held: [] };
  const inputAdapter = {
    consume() {
      latestInputFrame = inputManager.consume();
      return latestInputFrame;
    },
  };
  const sceneRuntime = new PlayerSceneRuntime({
    inputManager: inputAdapter,
    playerMotor,
    camera,
    renderer,
    level,
  });

  let loop = null;
  let paused = false;
  let disposed = false;

  const pauseGame = () => {
    if (paused || disposed || gameRuntime.snapshot.completed) return;
    paused = true;
    loop?.stop();
    inputManager.setEnabled(false);
    pauseOverlay.hidden = false;
    pauseButton.textContent = 'RETOMAR';
  };
  const resumeGame = () => {
    if (!paused || disposed) return;
    paused = false;
    pauseOverlay.hidden = true;
    pauseButton.textContent = 'PAUSAR';
    inputManager.setEnabled(true);
    loop?.start();
  };

  pauseButton.addEventListener('click', () => paused ? resumeGame() : pauseGame());
  resumeButton.addEventListener('click', resumeGame);
  restartButton.addEventListener('click', () => window.location.reload());

  loop = new FixedStepLoop({
    update: (deltaSeconds) => {
      sceneRuntime.update(deltaSeconds);
      const state = gameRuntime.update(deltaSeconds, sceneRuntime.playerSnapshot, latestInputFrame);
      if (state.contactResolution) {
        const currentBody = sceneRuntime.playerSnapshot.body;
        sceneRuntime.reset(
          { ...currentBody, x: state.contactResolution.x, y: state.contactResolution.y },
          { facing: state.contactResolution.facing },
        );
      }
      renderer.setState(state);
      if (latestInputFrame.pressed.includes('pause')) pauseGame();
    },
    render: (alpha) => {
      sceneRuntime.render(alpha);
      if (gameRuntime.snapshot.completed) {
        completionOverlay.hidden = false;
        pauseButton.hidden = true;
        inputManager.setEnabled(false);
        loop.stop();
      }
    },
    stepMs: 1000 / 60,
    maxFrameDeltaMs: 250,
    maxStepsPerFrame: 5,
  });

  const onVisibilityChange = () => {
    if (document.hidden) {
      if (!paused) pauseGame();
    }
  };
  const onBlur = () => {
    if (!paused) pauseGame();
  };
  const onFocus = () => {
    if (document.hidden || paused || disposed) return;
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

showStartScreen();
