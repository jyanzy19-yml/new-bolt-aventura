import { readFileSync } from 'node:fs';
import { describe, expect, it } from 'vitest';
import { validateLevelPackage } from '../../scripts/levels/validate-level-package.js';

const read = (p) => JSON.parse(readFileSync(new URL(`../../content/levels/${p}`, import.meta.url), 'utf8'));
const load = () => ({ level: read('w1-l1.level.json'), content: read('w1-l1.content.json') });
const codes = (r) => r.errors.map((e) => e.code);

describe('pacote W1-L1 (BOLT-001)', () => {
  it('passa sem erros com os dados reais', () => {
    const { level, content } = load();
    const r = validateLevelPackage(level, content);
    expect(r.errors).toEqual([]);
  });

  it('mantém o aviso conhecido de queda perto da unidade dormente', () => {
    const { level, content } = load();
    const r = validateLevelPackage(level, content);
    expect(r.warnings.map((w) => w.code)).toEqual(['FALL_NEAR_DORMANT_ENEMY']);
  });

  it('não declara assets como existentes ou aprovados', () => {
    const { content } = load();
    for (const a of content.assets) {
      expect(['PLANNED', 'SPECIFIED']).toContain(a.state);
      expect(a.approval).toBe('NONE');
    }
  });

  it('é marcado como não integrado e não aprovado', () => {
    const { level } = load();
    expect(level.metadata.productionApproved).toBe(false);
    expect(level.metadata.contentStatus).toBe('SPECIFIED_NOT_INTEGRATED');
  });

  describe('mutações devem ser rejeitadas', () => {
    const mutate = (fn) => {
      const pkg = load();
      fn(pkg);
      return codes(validateLevelPackage(pkg.level, pkg.content));
    };

    it('ID duplicado', () => {
      expect(mutate(({ level }) => { level.geometry.solids[1].id = level.geometry.solids[0].id; })).toContain('CONTRACT');
    });
    it('ID fora de kebab-case', () => {
      expect(mutate(({ level }) => { level.geometry.solids[0].id = 'S1_Floor'; })).toContain('CONTRACT');
    });
    it('vão acima do alcance do salto', () => {
      const c = mutate(({ level }) => {
        const pad = level.geometry.oneWayPlatforms.find((p) => p.id === 's5-pad-2');
        pad.x += 160;
      });
      expect(c).toContain('ROUTE_LEG_RATIO');
    });
    it('rota principal exigindo Dash', () => {
      expect(mutate(({ content }) => { content.route.main[3].via = 'jumpDash'; })).toContain('ROUTE_MAIN_ABILITY');
    });
    it('portão sem failsafe na interação', () => {
      expect(mutate(({ content }) => { delete content.interactables[2].failsafe; })).toContain('IX_FAILSAFE');
    });
    it('checkpoint colado à patrulha do inimigo', () => {
      expect(mutate(({ level }) => { level.checkpoints[1].x = 4300; })).toEqual(expect.arrayContaining(['CP_NEAR_DAMAGE']));
    });
    it('telegraph do inimigo abaixo de 1,0 s', () => {
      expect(mutate(({ content }) => { content.enemies[0].wake.rebootTelegraphSeconds = 0.5; })).toContain('ENEMY_TELEGRAPH');
    });
    it('assetRef inexistente', () => {
      expect(mutate(({ content }) => { content.enemies[0].assetRef = 'nao-existe'; })).toContain('ASSET_REF');
    });
    it('asset marcado como aprovado', () => {
      expect(mutate(({ content }) => { content.assets[0].state = 'APPROVED'; content.assets[0].approval = 'FINAL'; })).toContain('ASSET_STATE');
    });
    it('evento órfão', () => {
      expect(mutate(({ content }) => { content.events.push({ id: 'evt-orfao', effects: [] }); })).toContain('EVENT_ORPHAN');
    });
    it('contagem divergente de qa.expected', () => {
      expect(mutate(({ content }) => { content.qa.expected.checkpoints = 9; })).toContain('COUNT');
    });
  });
});
