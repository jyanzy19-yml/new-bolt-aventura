import { describe, expect, it } from 'vitest';
import { validateLevelDefinition } from '../../src/levels/level-definition.js';
import { W1_L1 } from '../../src/levels/w1-l1.js';

describe('W1-L1 production content', () => {
  it('validates the production phase against the shared level schema', () => {
    expect(validateLevelDefinition(W1_L1)).toBe(W1_L1);
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

  it('marks vector art and tuning as provisional rather than final approved assets', () => {
    expect(W1_L1.metadata.productionApproved).toBe(false);
    expect(W1_L1.metadata.artStatus).toBe('ORIGINAL_VECTOR_PLACEHOLDER');
  });
});
