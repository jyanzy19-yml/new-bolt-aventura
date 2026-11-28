import { describe, expect, it } from 'vitest';
import { validateLevelDefinition } from '../../src/levels/level-definition.js';
import { W1_L1 } from '../../src/levels/w1-l1.js';
import { validateW1L1Content } from '../../src/levels/w1-l1-validation.js';

describe('W1-L1 production content', () => {
  it('validates the production phase against the shared level schema', () => {
    expect(validateLevelDefinition(W1_L1)).toBe(W1_L1);
    expect(validateW1L1Content(W1_L1)).toBe(W1_L1);
  });

  it('preserves the approved four-part route and core tutorial beats', () => {
    expect(W1_L1.sections.map((section) => section.id)).toEqual([
      'awakening-chamber',
      'collapsed-corridor',
      'open-courtyard',
      'maintenance-shelter',
    ]);
    expect(W1_L1.id).toBe('w1-l1');
    expect(W1_L1.worldId).toBe('cybercore');
    expect(W1_L1.interactables.map((item) => item.kind)).toEqual(['secret', 'completion']);
  });

  it('keeps the optional diagnostic compartment separate from the completion gate', () => {
    const secret = W1_L1.interactables.find((item) => item.kind === 'secret');
    const completion = W1_L1.interactables.find((item) => item.kind === 'completion');
    expect(secret.id).not.toBe(completion.id);
    expect(secret.x).toBeLessThan(completion.x);
    expect(W1_L1.exits[0].targetLevelId).toBe('w1-l2');
  });

  it('rejects out-of-order objective thresholds', () => {
    const invalid = {
      ...W1_L1,
      objectives: [
        { ...W1_L1.objectives[0], thresholdX: 1500 },
        { ...W1_L1.objectives[1], thresholdX: 720 },
        ...W1_L1.objectives.slice(2),
      ],
    };
    expect(() => validateW1L1Content(invalid)).toThrow('gatilhos dos objetivos');
  });

  it('rejects a maintenance patrol that extends outside its declared lane', () => {
    const invalid = {
      ...W1_L1,
      enemy: { ...W1_L1.enemy, x: 1900, patrolMax: 1915 },
    };
    expect(() => validateW1L1Content(invalid)).toThrow('patrulha');
  });

  it('marks vector art and tuning as provisional rather than final approved assets', () => {
    expect(W1_L1.metadata.productionApproved).toBe(false);
    expect(W1_L1.metadata.artStatus).toBe('ORIGINAL_VECTOR_PLACEHOLDER');
  });
});
