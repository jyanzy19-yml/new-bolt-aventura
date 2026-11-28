import { describe, expect, it } from 'vitest';
import { W1L1GameRuntime } from '../../src/gameplay/w1-l1-game-runtime.js';
import { W1_L1 } from '../../src/levels/w1-l1.js';

const frame = (pressed = []) => ({ pressed, released: [], held: [] });
const playerAt = (x, y = 504) => ({ body: { x, y, width: 30, height: 46 } });

describe('W1L1GameRuntime', () => {
  it('advances the main objective sequence from spatial progress', () => {
    const runtime = new W1L1GameRuntime(W1_L1);
    expect(runtime.snapshot.objectiveIndex).toBe(0);
    runtime.update(1 / 60, playerAt(800));
    expect(runtime.snapshot.objectiveIndex).toBe(1);
    runtime.update(1 / 60, playerAt(1600));
    expect(runtime.snapshot.objectiveIndex).toBe(2);
    runtime.update(1 / 60, playerAt(2800));
    expect(runtime.snapshot.objectiveIndex).toBe(3);
  });

  it('allows the optional diagnostic secret without completing the phase', () => {
    const runtime = new W1L1GameRuntime(W1_L1);
    runtime.update(1 / 60, playerAt(2210, 230));
    expect(runtime.snapshot.interactPrompt).toContain('DIAGNÓSTICO');
    runtime.update(1 / 60, playerAt(2210, 230), frame(['interact']));
    expect(runtime.snapshot.secretFound).toBe(true);
    expect(runtime.snapshot.completed).toBe(false);
  });

  it('completes only when the first synchronization point is activated', () => {
    const runtime = new W1L1GameRuntime(W1_L1);
    runtime.update(1 / 60, playerAt(3230, 500));
    expect(runtime.snapshot.interactPrompt).toContain('SINCRONIZAÇÃO');
    runtime.update(1 / 60, playerAt(3230, 500), frame(['interact']));
    expect(runtime.snapshot.checkpointActive).toBe(true);
    expect(runtime.snapshot.completed).toBe(true);
  });

  it('resolves side contact with a non-damaging bump and keeps the player outside the unit', () => {
    const runtime = new W1L1GameRuntime(W1_L1);
    const result = runtime.update(1 / 60, playerAt(1810, 506));
    expect(result.enemyContact).toBe(true);
    expect(result.contactResolution).not.toBeNull();
    expect(result.contactResolution.x + 30).toBeLessThanOrEqual(result.enemy.x + 0.001);
  });

  it('keeps the maintenance unit inside its patrol bounds', () => {
    const runtime = new W1L1GameRuntime(W1_L1);
    for (let index = 0; index < 500; index += 1) {
      runtime.update(1 / 60, playerAt(100));
    }
    const enemy = runtime.snapshot.enemy;
    expect(enemy.x).toBeGreaterThanOrEqual(enemy.patrolMin);
    expect(enemy.x + enemy.width).toBeLessThanOrEqual(enemy.patrolMax);
  });
});
