import { describe, expect, it, vi } from 'vitest';
import { W1L1CanvasRenderer } from '../../src/rendering/w1-l1-canvas-renderer.js';
import { W1_L1 } from '../../src/levels/w1-l1.js';

function createSurface() {
  const gradient = { addColorStop: vi.fn() };
  const context = {
    save: vi.fn(),
    restore: vi.fn(),
    translate: vi.fn(),
    fillRect: vi.fn(),
    strokeRect: vi.fn(),
    beginPath: vi.fn(),
    moveTo: vi.fn(),
    lineTo: vi.fn(),
    quadraticCurveTo: vi.fn(),
    closePath: vi.fn(),
    fill: vi.fn(),
    stroke: vi.fn(),
    arc: vi.fn(),
    fillText: vi.fn(),
    createLinearGradient: vi.fn(() => gradient),
    createRadialGradient: vi.fn(() => gradient),
    globalAlpha: 1,
    fillStyle: '',
    strokeStyle: '',
    lineWidth: 1,
    font: '',
    textAlign: 'left',
  };
  return { context, clear: vi.fn() };
}

const player = {
  body: { x: 72, y: 504, width: 30, height: 46 },
  facing: 1,
  state: 'grounded',
};

describe('W1L1CanvasRenderer', () => {
  it('draws the production blockout, landmarks, player and HUD', () => {
    const surface = createSurface();
    const renderer = new W1L1CanvasRenderer(surface);
    renderer.setState({
      objective: 'Saia da câmara de despertar',
      objectiveIndex: 0,
      objectiveCount: 4,
      enemy: { ...W1_L1.enemy, direction: 1 },
      enemyContact: false,
      interactPrompt: '',
      message: 'NEXO // SINAL FRAGMENTADO DETECTADO',
      time: 1,
      completed: false,
      secretFound: false,
      checkpointActive: false,
    });

    const result = renderer.render({
      level: W1_L1,
      player,
      camera: { x: 0, y: 275 },
    });

    expect(result).toEqual({
      levelId: 'w1-l1',
      player: 1,
      landmarks: W1_L1.landmarks.length,
      enemy: 1,
      objectiveIndex: 0,
      completed: false,
    });
    expect(surface.clear).toHaveBeenCalledWith('#07111e');
    expect(surface.context.fillRect).toHaveBeenCalled();
    expect(surface.context.fillText).toHaveBeenCalled();
  });

  it('renders the optional-secret and phase-completion feedback state', () => {
    const surface = createSurface();
    const renderer = new W1L1CanvasRenderer(surface);
    renderer.setState({
      objective: 'Fase concluída',
      objectiveIndex: 3,
      objectiveCount: 4,
      enemy: { ...W1_L1.enemy, direction: -1 },
      enemyContact: false,
      interactPrompt: '',
      message: 'NEXO // PONTO DE SINCRONIZAÇÃO ATIVADO.',
      time: 8,
      completed: true,
      secretFound: true,
      checkpointActive: true,
    });

    const result = renderer.render({
      level: W1_L1,
      player,
      camera: { x: 2800, y: 275 },
    });

    expect(result.completed).toBe(true);
    expect(surface.context.fillText).toHaveBeenCalledWith(
      'FASE CONCLUÍDA',
      400,
      220,
    );
  });
});
