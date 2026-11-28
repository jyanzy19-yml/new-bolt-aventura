import { describe, expect, it } from 'vitest';
import { clamp } from '../../src/core/math.js';

describe('clamp', () => {
  it('mantém valores dentro do intervalo', () => {
    expect(clamp(5, 0, 10)).toBe(5);
  });
  it('limita valores abaixo e acima do intervalo', () => {
    expect(clamp(-2, 0, 10)).toBe(0);
    expect(clamp(12, 0, 10)).toBe(10);
  });
  it('aceita limites iguais', () => {
    expect(clamp(8, 4, 4)).toBe(4);
  });
  it('rejeita limites invertidos', () => {
    expect(() => clamp(2, 5, 1)).toThrow(RangeError);
  });
  it('rejeita valores não finitos', () => {
    expect(() => clamp(Number.NaN, 0, 1)).toThrow(TypeError);
  });
});
