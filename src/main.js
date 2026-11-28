import './styles.css';
import { CanvasSurface } from './rendering/canvas-surface.js';

const root = document.querySelector('#app');

if (!root) {
  throw new Error('Elemento raiz #app não encontrado.');
}

root.innerHTML = `
  <main class="game-screen" aria-labelledby="game-title">
    <h1 id="game-title" class="visually-hidden">BOLT · AVENTURA</h1>
    <canvas
      id="game-canvas"
      class="game-canvas"
      width="800"
      height="450"
      aria-label="Área de apresentação do BOLT · AVENTURA"
    >
      Seu navegador não oferece suporte ao Canvas 2D.
    </canvas>
    <p class="game-status" role="status">
      Núcleo gráfico Canvas 2D inicializado · gameplay em desenvolvimento
    </p>
  </main>
`;

const canvas = root.querySelector('#game-canvas');
const surface = new CanvasSurface(canvas, {
  logicalWidth: 800,
  logicalHeight: 450,
  maxDpr: 1.5,
});

function renderFoundationScreen() {
  surface.clear('#080d18');

  const { context } = surface;
  context.fillStyle = '#132238';
  context.fillRect(24, 24, 752, 402);

  context.strokeStyle = 'rgba(120, 185, 255, 0.18)';
  context.lineWidth = 1;

  for (let x = 48; x < 800; x += 32) {
    context.beginPath();
    context.moveTo(x, 24);
    context.lineTo(x, 426);
    context.stroke();
  }

  for (let y = 40; y < 450; y += 32) {
    context.beginPath();
    context.moveTo(24, y);
    context.lineTo(776, y);
    context.stroke();
  }

  context.textAlign = 'center';
  context.textBaseline = 'middle';
  context.fillStyle = '#edf4ff';
  context.font = '700 36px system-ui, sans-serif';
  context.fillText('BOLT · AVENTURA', 400, 190);
  context.fillStyle = '#78b9ff';
  context.font = '600 16px system-ui, sans-serif';
  context.fillText('CANVAS 2D RENDERER ONLINE', 400, 232);
  context.fillStyle = '#9fb4ce';
  context.font = '14px system-ui, sans-serif';
  context.fillText('Foundation placeholder — gameplay not integrated', 400, 270);
}

function resizeCanvas() {
  const bounds = canvas.getBoundingClientRect();
  if (bounds.width <= 0 || bounds.height <= 0) return;

  surface.resize(bounds.width, bounds.height, window.devicePixelRatio || 1);
  renderFoundationScreen();
}

if (typeof ResizeObserver === 'function') {
  const resizeObserver = new ResizeObserver(resizeCanvas);
  resizeObserver.observe(canvas);
} else {
  window.addEventListener('resize', resizeCanvas, { passive: true });
}

resizeCanvas();
