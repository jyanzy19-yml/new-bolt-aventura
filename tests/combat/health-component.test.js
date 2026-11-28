import { describe, expect, it } from 'vitest';
import { HealthComponent } from '../../src/combat/health-component.js';

describe('HealthComponent', () => {
  it('applies bounded damage and reports defeat', () => {
    const health = new HealthComponent({ maxHealth: 10 });

    expect(health.applyDamage(4)).toEqual({
      applied: 4,
      currentHealth: 6,
      defeated: false,
    });
    expect(health.applyDamage(20)).toEqual({
      applied: 6,
      currentHealth: 0,
      defeated: true,
    });
    expect(health.defeated).toBe(true);
  });

  it('heals without exceeding maximum health', () => {
    const health = new HealthComponent({ maxHealth: 10, currentHealth: 7 });

    expect(health.heal(8)).toEqual({
      healed: 3,
      currentHealth: 10,
      defeated: false,
    });
  });

  it('does not revive a defeated target through healing', () => {
    const health = new HealthComponent({ maxHealth: 3, currentHealth: 0 });

    expect(health.heal(2)).toEqual({
      healed: 0,
      currentHealth: 0,
      defeated: true,
    });
  });

  it('supports explicit reset and rejects invalid amounts', () => {
    const health = new HealthComponent({ maxHealth: 5, currentHealth: 2 });

    expect(health.reset()).toBe(5);
    expect(() => health.applyDamage(0)).toThrow(RangeError);
    expect(() => health.heal(Number.NaN)).toThrow(RangeError);
    expect(() => health.reset(6)).toThrow(RangeError);
  });
});
