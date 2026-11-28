#!/usr/bin/env node
/**
 * Static validator for a level package (geometry + content layer).
 *
 * It checks data integrity and design budgets WITHOUT running the game:
 *  - a mirror of the schema-v1 geometry rules (docs/technical/HTML5_LEVEL_RUNTIME_CONTRACT.md);
 *  - cross-references between geometry, route, events, objectives, dialogue and assets;
 *  - per-leg traversal budgets computed from a MEASURED movement envelope;
 *  - teaching order, checkpoints, encounter and softlock rules.
 *
 * It is NOT a replacement for the runtime validator (validateLevelDefinition) and it does not prove
 * the level is playable on a device. Measured envelope values are temporary debug tuning.
 *
 * Usage: node scripts/levels/validate-level-package.js [level.json content.json]
 */
import { readFileSync } from 'node:fs';
import { fileURLToPath, pathToFileURL } from 'node:url';

const STABLE_ID = /^[a-z][a-z0-9]*(?:-[a-z0-9]+)*$/;
const LEVEL_ID = /^w[1-7]-l[1-6]$/;
// Mirrors ASSET_STATES in the asset manifest contract (PR #160); only pre-approval states are allowed here.
const PRE_APPROVAL_STATES = new Set(['PLANNED', 'SPECIFIED']);
const ASSET_TYPES = new Set(['image', 'audio', 'font', 'data']);
const VIA = new Set(['start', 'walk', 'jump', 'doubleJump', 'jumpDash', 'drop']);

const right = (r) => r.x + r.width;
const bottom = (r) => r.y + r.height;
const overlapsArea = (a, b) => a.x < right(b) && right(a) > b.x && a.y < bottom(b) && bottom(a) > b.y;
const rectOf = (r) => ({ x: r.x, y: r.y, width: r.width, height: r.height });
const sectionOfX = (sections, x) => sections.find((s) => x >= s.x0 && x < s.x1);

/** Horizontal gap between two surfaces (0 when their x-ranges overlap or touch). */
export function horizontalGap(from, to) {
  if (to.x >= right(from)) return to.x - right(from);
  if (right(to) <= from.x) return from.x - right(to);
  return 0;
}

/** Ratio of a jump leg against the measured envelope; >1 means "not doable with that ability". */
export function legRatio(envelope, from, to, ability) {
  const rise = from.y - to.y; // positive when the landing is higher
  const gap = horizontalGap(from, to);
  const height = ability === 'doubleJump' ? envelope.doubleJumpHeight : envelope.jumpHeight;
  const flatReach =
    ability === 'doubleJump'
      ? envelope.doubleJumpReach
      : ability === 'jumpDash'
        ? envelope.jumpDashReach
        : envelope.runJumpReach;
  const reach = flatReach * (1 - envelope.reachRiseDerating * (Math.max(0, rise) / height));
  const heightRatio = Math.max(0, rise) / height;
  return { rise, gap, ratio: Math.max(gap / reach, heightRatio), gapRatio: gap / reach, heightRatio };
}

class Report {
  constructor() {
    this.errors = [];
    this.warnings = [];
  }
  error(code, message, ref) {
    this.errors.push({ code, message, ref });
  }
  warn(code, message, ref) {
    this.warnings.push({ code, message, ref });
  }
}

function checkContractMirror(level, report) {
  const e = (m, ref) => report.error('CONTRACT', m, ref);
  if (level.schemaVersion !== 1) e('schemaVersion deve ser 1.');
  if (!LEVEL_ID.test(level.id ?? '')) e('id da fase fora do padrão w1-l1..w7-l6.', level.id);
  if (!STABLE_ID.test(level.worldId ?? '')) e('worldId deve ser kebab-case.', level.worldId);
  if (typeof level.title !== 'string' || level.title.trim() === '') e('title vazio.');
  const b = level.bounds;
  if (!b || !(b.width > 0) || !(b.height > 0)) return e('bounds inválido.');
  const inside = (r) => r.x >= b.x && r.y >= b.y && right(r) <= right(b) && bottom(r) <= bottom(b);
  const ids = new Map();
  const reg = (id, kind) => {
    if (!STABLE_ID.test(id ?? '')) e(`ID inválido (${kind}).`, id);
    else if (ids.has(id)) e(`ID duplicado: ${id}.`, id);
    ids.set(id, kind);
  };
  for (const [kind, list] of [
    ['solid', level.geometry?.solids ?? []],
    ['one-way', level.geometry?.oneWayPlatforms ?? []],
    ['exit', level.exits ?? []],
  ]) {
    for (const r of list) {
      reg(r.id, kind);
      const fin = ['x', 'y', 'width', 'height'].every((k) => Number.isFinite(r[k]));
      if (!fin || r.width <= 0 || r.height <= 0) e(`Retângulo inválido (${kind}).`, r.id);
      else if (!inside(r)) e(`Fora dos limites (${kind}).`, r.id);
    }
  }
  for (const c of level.checkpoints ?? []) {
    reg(c.id, 'checkpoint');
    if (c.x < b.x || c.x > right(b) || c.y < b.y || c.y > bottom(b)) e('Checkpoint fora dos limites.', c.id);
  }
  for (const x of level.exits ?? []) if (!LEVEL_ID.test(x.targetLevelId ?? '')) e('targetLevelId inválido.', x.id);
  const s = level.spawn;
  if (!s || s.x < b.x || s.x > right(b) || s.y < b.y || s.y > bottom(b)) e('spawn fora dos limites.');
  return ids;
}

function checkGeometry(level, content, report) {
  const env = content.designEnvelope;
  const body = { w: env.player.width, h: env.player.height };
  const solids = level.geometry.solids;
  const oneWay = level.geometry.oneWayPlatforms;
  for (let i = 0; i < solids.length; i++) {
    for (let j = i + 1; j < solids.length; j++) {
      if (overlapsArea(solids[i], solids[j])) report.error('GEO_OVERLAP', 'Sólidos sobrepostos.', `${solids[i].id}/${solids[j].id}`);
    }
    for (const o of oneWay) {
      if (overlapsArea(solids[i], o)) report.error('GEO_OVERLAP', 'Plataforma unidirecional sobre sólido.', `${solids[i].id}/${o.id}`);
    }
  }
  for (let i = 0; i < oneWay.length; i++) {
    for (let j = i + 1; j < oneWay.length; j++) {
      if (overlapsArea(oneWay[i], oneWay[j])) report.error('GEO_OVERLAP', 'Unidirecionais sobrepostas.', `${oneWay[i].id}/${oneWay[j].id}`);
    }
  }
  const surfaces = [...solids, ...oneWay];
  const standsOn = (x, y) => surfaces.find((s) => x > s.x && x < right(s) && s.y === y);
  const bodyBlocked = (cx, feetY) => {
    const r = { x: cx - body.w / 2, y: feetY - body.h, width: body.w, height: body.h };
    return surfaces.find((s) => overlapsArea(r, s));
  };
  const s = level.spawn;
  if (!standsOn(s.x + body.w / 2, s.y + body.h)) report.error('GEO_SPAWN', 'Spawn não está apoiado em uma superfície.');
  if (bodyBlocked(s.x + body.w / 2, s.y + body.h)) report.error('GEO_SPAWN', 'Corpo do spawn colide com geometria.');
  for (const c of level.checkpoints) {
    if (!standsOn(c.x, c.y)) report.error('GEO_CHECKPOINT', 'Checkpoint não está sobre o topo de uma superfície.', c.id);
    if (bodyBlocked(c.x, c.y)) report.error('GEO_CHECKPOINT', 'Corpo no checkpoint colide com geometria.', c.id);
    const surf = standsOn(c.x, c.y);
    const margin = content.qa.limits.minCheckpointFloorMargin;
    if (surf && (c.x - surf.x < margin || right(surf) - c.x < margin)) {
      report.error('GEO_CHECKPOINT_MARGIN', `Checkpoint a menos de ${margin}px da borda da superfície.`, c.id);
    }
  }
  for (const x of level.exits) {
    const hasFloor = surfaces.some((f) => f.y === bottom(x) && x.x >= f.x && right(x) <= right(f));
    if (!hasFloor) report.error('GEO_EXIT', 'Saída flutuando: sem piso sob a zona.', x.id);
  }
  // sections tile the level and own every surface
  const secs = content.sections;
  if (secs[0].x0 !== level.bounds.x || secs.at(-1).x1 !== right(level.bounds)) report.error('SECTION', 'Seções não cobrem os limites.');
  for (let i = 1; i < secs.length; i++) if (secs[i].x0 !== secs[i - 1].x1) report.error('SECTION', 'Seções não contíguas.', secs[i].id);
  for (const sf of surfaces) if (!sectionOfX(secs, sf.x)) report.error('SECTION', 'Superfície fora de qualquer seção.', sf.id);
  return surfaces;
}

/**
 * Over-approximate reachability between surfaces using the best ability (double jump).
 * Used only to decide which surfaces a player could stand on (fall checks, route coverage);
 * it ignores walls and ceilings on purpose, so it can only over-report reachable surfaces.
 */
export function reachableSurfaces(level, content, surfaces) {
  const env = content.designEnvelope;
  const byId = new Map(surfaces.map((s) => [s.id, s]));
  const start = surfaces.find((s) => level.spawn.x + env.player.width / 2 > s.x && level.spawn.x + env.player.width / 2 < right(s) && s.y === level.spawn.y + env.player.height);
  const seen = new Set();
  if (!start) return { start: null, seen, byId };
  const queue = [start];
  seen.add(start.id);
  const canGo = (a, b) => {
    const gap = horizontalGap(a, b);
    const rise = a.y - b.y;
    if (rise > env.doubleJumpHeight) return false;
    if (rise >= 0) return legRatio(env, a, b, 'doubleJump').ratio <= 1;
    // lower target: generous reach, gaining range with the drop (over-approximation)
    const fall = -rise;
    return gap <= env.doubleJumpReach + 0.5 * env.runSpeed * Math.sqrt((2 * fall) / 1400);
  };
  while (queue.length) {
    const a = queue.shift();
    for (const b of surfaces) {
      if (!seen.has(b.id) && canGo(a, b)) {
        seen.add(b.id);
        queue.push(b);
      }
    }
  }
  return { start, seen, byId };
}

/**
 * Falls from reachable surface edges inside the level bounds.
 *  - no surface or killzone below            -> error (bottomless);
 *  - lands deeper than the visible area below -> error when a killzone is within +-300 px of the landing,
 *    or when a non-dormant enemy is; a dormant enemy with a telegraph is reported as a warning because
 *    the unit gives a >= 1.0 s warning before acting (documented design risk, not a blind lethal drop).
 */
function checkFalls(level, content, surfaces, reach, report) {
  const env = content.designEnvelope;
  const b = level.bounds;
  const killzones = content.hazards.filter((h) => h.kind === 'killzone');
  const informational = [];
  for (const s of surfaces) {
    if (!reach.seen.has(s.id)) continue;
    for (const edgeX of [s.x - 1, right(s) + 1]) {
      if (edgeX < b.x || edgeX > right(b)) continue; // level boundary: handled by bounds, not a fall
      const blockedBeside = surfaces.some((o) => o !== s && edgeX > o.x && edgeX < right(o) && s.y - 8 > o.y && s.y - 8 < bottom(o));
      if (blockedBeside) continue; // wall directly beside the edge
      const below = surfaces.filter((o) => o !== s && edgeX > o.x && edgeX < right(o) && o.y >= s.y - 0.5);
      const killer = killzones.find((h) => edgeX > h.rect.x && edgeX < right(h.rect) && h.rect.y >= s.y - 0.5);
      const landing = Math.min(...below.map((o) => o.y), killer ? killer.rect.y : Infinity);
      if (!Number.isFinite(landing)) {
        report.error('FALL_BOTTOMLESS', 'Borda alcançável sem superfície abaixo.', s.id);
        continue;
      }
      const depth = landing - s.y;
      if (depth <= env.visibleBelow) continue;
      const nearKill = killzones.filter((h) => right(h.rect) >= edgeX - 300 && h.rect.x <= edgeX + 300);
      const nearEnemy = content.enemies.filter((en) => en.patrol.maxX + en.size.width / 2 >= edgeX - 300 && en.patrol.minX - en.size.width / 2 <= edgeX + 300);
      const hard = nearKill.map((h) => h.id).concat(nearEnemy.filter((en) => !(en.initialState === 'dormant' && en.wake.rebootTelegraphSeconds >= 1)).map((en) => en.id));
      if (hard.length) report.error('FALL_BLIND_DAMAGE', `Queda de ${depth}px aterrissa perto de fonte de dano (${hard}).`, s.id);
      else if (nearEnemy.length) report.warn('FALL_NEAR_DORMANT_ENEMY', `Queda de ${depth}px (> ${env.visibleBelow}px visíveis) aterrissa perto de inimigo dormente (${nearEnemy.map((e) => e.id)}).`, s.id);
      else informational.push({ surface: s.id, edgeX, depth });
    }
  }
  return informational;
}

function checkRoute(level, content, surfaces, report) {
  const env = content.designEnvelope;
  const byId = new Map(surfaces.map((s) => [s.id, s]));
  const secs = content.sections;
  const main = content.route.main;
  const sectionStats = new Map(secs.map((s) => [s.id, { maxRatio: 0, legs: 0 }]));
  const legInfo = [];

  const checkLeg = (prev, node, optional) => {
    const to = byId.get(node.solid);
    const from = byId.get(prev.solid);
    if (!VIA.has(node.via)) return report.error('ROUTE_VIA', `via desconhecido: ${node.via}.`, node.id);
    if (!from || !to) return report.error('ROUTE_REF', 'Nó referencia superfície inexistente.', node.id);
    if (node.via === 'start') return undefined;
    const sec = sectionOfX(secs, to.x);
    const limit = optional ? (sec.maxRatioOptional ?? sec.maxRatio) : sec.maxRatio;
    const info = { id: node.id, via: node.via, from: from.id, to: to.id, section: sec.id, optional };
    if (node.via === 'walk') {
      const touching = from === to || (horizontalGap(from, to) === 0 && from.y === to.y);
      if (!touching) report.error('ROUTE_WALK', 'Perna "walk" exige superfícies contíguas e niveladas.', node.id);
    } else if (node.via === 'drop') {
      const depth = to.y - from.y;
      const gap = horizontalGap(from, to);
      if (depth <= 0) report.error('ROUTE_DROP', 'Perna "drop" deve descer.', node.id);
      if (depth > env.visibleBelow) report.error('ROUTE_DROP_VISIBILITY', `Queda de ${depth}px excede a área visível abaixo (${env.visibleBelow}px).`, node.id);
      const walkOffReach = 0.8 * env.runSpeed * Math.sqrt((2 * Math.max(depth, 1)) / 1400);
      if (gap > walkOffReach) report.error('ROUTE_DROP_REACH', `Intervalo de ${gap}px excede o alcance de queda (${Math.round(walkOffReach)}px).`, node.id);
      Object.assign(info, { depth, gap });
    } else {
      const ability = node.via;
      const r = legRatio(env, from, to, ability);
      Object.assign(info, r);
      if (r.rise > 0 && r.rise > (ability === 'doubleJump' ? env.doubleJumpHeight : env.jumpHeight) - 8) {
        report.error('ROUTE_LEG_HEIGHT', 'Desnível próximo demais da altura máxima.', node.id);
      }
      if (r.ratio > limit) report.error('ROUTE_LEG_RATIO', `Razão ${r.ratio.toFixed(2)} acima do limite ${limit} da seção ${sec.id}.`, node.id);
      if (to.width < sec.minLandingWidth) report.error('ROUTE_LANDING_WIDTH', `Aterrissagem de ${to.width}px < ${sec.minLandingWidth}px.`, node.id);
      if (r.gap + 40 > env.visibleAhead) report.error('ROUTE_BLIND_LANDING', 'Aterrissagem não visível a partir da decolagem.', node.id);
      if (ability === 'doubleJump' || ability === 'jumpDash') {
        const single = legRatio(env, from, to, 'jump').ratio;
        info.singleRatio = single;
        if (single <= 1) report.error('ROUTE_NOT_REQUIRED', `Perna marcada como ${ability}, mas pulo simples basta (razão ${single.toFixed(2)}).`, node.id);
      }
      if (node.alsoVia) {
        const alt = legRatio(env, from, to, node.alsoVia).ratio;
        if (alt > limit) report.error('ROUTE_ALT_RATIO', `Alternativa ${node.alsoVia} com razão ${alt.toFixed(2)} > ${limit}.`, node.id);
      }
      // ceilings over the leg must clear the apex of the arc (conservative lint, not a proof)
      const apexHeadTop = from.y - (ability === 'doubleJump' ? env.doubleJumpHeight : env.jumpHeight) - env.player.height;
      const right_ = to.x + to.width / 2 >= from.x + from.width / 2;
      const takeoff = right_ ? Math.min(right(from), to.x) : Math.max(from.x, right(to));
      const span0 = right_ ? takeoff - 96 : to.x + to.width - 64;
      const span1 = right_ ? to.x + 64 : takeoff + 96;
      for (const c of level.geometry.solids) {
        const clear = bottom(c) <= Math.min(from.y, to.y) - env.player.height;
        if (clear && c.x < span1 && right(c) > span0 && bottom(c) > apexHeadTop) {
          report.error('ROUTE_HEADROOM', `Teto (base ${bottom(c)}) abaixo do ápice da cabeça (${Math.round(apexHeadTop)}).`, `${node.id}/${c.id}`);
        }
      }
      if (!optional) {
        const st = sectionStats.get(sec.id);
        st.maxRatio = Math.max(st.maxRatio, r.ratio);
        st.legs += 1;
      }
    }
    legInfo.push(info);
    return undefined;
  };

  let prev = null;
  for (const node of main) {
    if (prev) checkLeg(prev, node, false);
    prev = node;
  }
  for (const r of content.route.optional) {
    const start = { solid: r.from };
    let p = start;
    for (const node of r.nodes) {
      checkLeg(p, node, true);
      p = node;
    }
  }
  if (main[0]?.via !== 'start') report.error('ROUTE_START', 'Primeiro nó da rota principal deve ser "start".');
  const forbidden = main.filter((n) => n.via === 'jumpDash' || n.alsoVia === 'jumpDash' || n.dash || n.shoot);
  if (forbidden.length) report.error('ROUTE_MAIN_ABILITY', 'Rota principal exige Dash/tiro (deve ser opcional).', forbidden.map((n) => n.id).join(','));

  // difficulty curve over the main route
  const m = (i) => sectionStats.get(secs[i].id).maxRatio;
  if (m(0) !== 0) report.error('CURVE', 'Seção 1 não pode exigir saltos.');
  if (!(m(2) > m(1))) report.error('CURVE', 'Seção 3 (combinação) deve superar a seção 2 em dificuldade.');
  if (!(m(4) >= m(3))) report.error('CURVE', 'Seção 5 (domínio) deve igualar ou superar a seção 4.');
  if (!(m(4) >= m(1))) report.error('CURVE', 'Seção 5 (domínio) deve igualar ou superar a seção 2.');
  if (!(m(5) <= secs[5].maxRatio)) report.error('CURVE', 'Encerramento acima do limite.');
  for (const [sid, st] of sectionStats) if (st.maxRatio > 0.8) report.error('CURVE', `Razão ${st.maxRatio.toFixed(2)} > 0,80 na rota principal.`, sid);
  return { legInfo, sectionStats: [...sectionStats.entries()].map(([id, v]) => ({ id, ...v })) };
}

function checkTeaching(content, surfaces, report) {
  const env = content.designEnvelope;
  const main = content.route.main;
  const surf = new Map();
  const triggers = content.triggers;
  const hintBefore = (hint, x) => triggers.some((t) => t.kind === 'hint' && t.hint === hint && t.rect.x + t.rect.width <= x);
  for (const s of surfaces) surf.set(s.id, s);
  const firstJump = main.find((n) => n.via === 'jump');
  const firstDouble = main.find((n) => n.via === 'doubleJump');
  if (firstJump) {
    const idx = main.indexOf(firstJump);
    const from = surf.get(main[idx - 1].solid);
    const to = surf.get(firstJump.solid);
    if (from.y - to.y > env.tapJumpHeight - 4) report.error('TEACH_FIRST_JUMP', 'Primeiro salto deve caber em um toque curto.', firstJump.id);
    if (!hintBefore('jump-tap', to.x)) report.error('TEACH_HINT', 'Falta dica "jump-tap" antes do primeiro salto.', firstJump.id);
  }
  for (const [i, n] of main.entries()) {
    if (n.via !== 'jump' || i === 0) continue;
    const rise = surf.get(main[i - 1].solid).y - surf.get(n.solid).y;
    if (rise > env.tapJumpHeight && !hintBefore('jump-hold', surf.get(n.solid).x)) {
      report.error('TEACH_HINT', 'Obstáculo exige salto sustentado sem dica "jump-hold" prévia.', n.id);
    }
  }
  if (firstDouble && !hintBefore('double-jump', surf.get(firstDouble.solid).x)) {
    report.error('TEACH_HINT', 'Falta dica "double-jump" antes do primeiro uso obrigatório.', firstDouble.id);
  }
  for (const t of triggers.filter((x) => x.kind === 'hint' && x.requiresAbility)) {
    if (!content.abilities[t.requiresAbility]) report.error('TEACH_ABILITY', 'Dica referencia habilidade desconhecida.', t.id);
  }
}

function checkEncounterAndCheckpoints(level, content, surfaces, report) {
  const lim = content.qa.limits;
  const env = content.designEnvelope;
  const byId = new Map(surfaces.map((s) => [s.id, s]));
  const cps = level.checkpoints;
  for (const en of content.enemies) {
    const sf = byId.get(en.solid);
    if (!sf) return report.error('ENEMY_REF', 'Inimigo sobre superfície inexistente.', en.id);
    const x0 = en.patrol.minX - en.size.width / 2;
    const x1 = en.patrol.maxX + en.size.width / 2;
    if (x0 < sf.x + 48 || x1 > right(sf) - 48) report.error('ENEMY_PATROL', 'Patrulha precisa de ao menos 48px de margem na plataforma.', en.id);
    const box = { x: x0, y: sf.y - en.size.height, width: x1 - x0, height: en.size.height };
    for (const s of surfaces) if (s.id !== sf.id && overlapsArea(box, s)) report.error('ENEMY_COLLISION', 'Faixa de patrulha intersecta geometria.', `${en.id}/${s.id}`);
    if (!en.optional) report.error('ENEMY_OPTIONAL', 'O primeiro encontro deve ser opcional.', en.id);
    if (en.wake.rebootTelegraphSeconds < 1) report.error('ENEMY_TELEGRAPH', 'Telegraph de reinício < 1,0 s.', en.id);
    if (en.patrol.speed > 0.35 * env.runSpeed) report.error('ENEMY_SPEED', 'Patrulha rápida demais para o primeiro encontro.', en.id);
    if (en.contactDamage.invulnerabilitySeconds < 0.8) report.error('ENEMY_IFRAMES', 'Invulnerabilidade pós-dano < 0,8 s.', en.id);
    if (en.glitch.durationSeconds < 1) report.error('ENEMY_WINDOW', 'Janela de núcleo exposto < 1,0 s.', en.id);
    if (en.size.height + 32 > 0.9 * env.jumpHeight) report.error('ENEMY_JUMPABLE', 'Inimigo alto demais para ser saltado com folga.', en.id);
    const bypass = content.route.optional.some((r) => r.from === en.solid);
    if (!bypass) report.error('ENEMY_BYPASS', 'Sem rota alternativa que evite o encontro.', en.id);
    const before = cps.filter((c) => c.x < x0);
    if (!before.length) report.error('CP_BEFORE_ENEMY', 'Sem checkpoint antes do inimigo.', en.id);
    else if (x0 - Math.max(...before.map((c) => c.x)) > lim.maxCheckpointDistanceBeforeEnemy) report.error('CP_BEFORE_ENEMY', 'Checkpoint longe demais do inimigo.', en.id);
    for (const c of cps) {
      const d = Math.max(x0 - c.x, c.x - x1, 0);
      if (d < lim.minCheckpointDistanceFromDamageSource) report.error('CP_NEAR_DAMAGE', `Checkpoint a ${d}px da patrulha.`, `${c.id}/${en.id}`);
    }
  }
  for (const h of content.hazards.filter((x) => x.kind === 'killzone')) {
    for (const s of surfaces) if (overlapsArea(h.rect, s)) report.error('HAZ_OVERLAP', 'Zona letal sobreposta à geometria.', `${h.id}/${s.id}`);
    const before = cps.filter((c) => c.x < h.rect.x);
    if (!before.length || h.rect.x - Math.max(...before.map((c) => c.x)) > lim.maxCheckpointDistanceBeforeKillzone) {
      report.error('CP_BEFORE_KILLZONE', 'Checkpoint ausente ou longe da zona letal.', h.id);
    }
    if (!cps.some((c) => c.id === h.respawnCheckpoint)) report.error('HAZ_RESPAWN', 'respawnCheckpoint inexistente.', h.id);
    for (const c of cps) {
      const d = Math.max(h.rect.x - c.x, c.x - right(h.rect), 0);
      if (d < 96) report.error('CP_NEAR_DAMAGE', 'Checkpoint dentro/colado à zona letal.', `${c.id}/${h.id}`);
    }
  }
  for (const h of content.hazards.filter((x) => x.kind === 'recovery-pit')) {
    const bed = byId.get(h.bed);
    if (!bed) report.error('HAZ_PIT', 'Leito da vala inexistente.', h.id);
    else {
      if (bed.y !== bottom(h.rect)) report.error('HAZ_PIT', 'Leito não coincide com a base da vala.', h.id);
      const depth = h.rect.height;
      const sec = sectionOfX(content.sections, h.rect.x);
      if (depth / env.jumpHeight > sec.maxRatio) report.error('HAZ_PIT_DEPTH', 'Vala funda demais para recuperação.', h.id);
    }
  }
  return undefined;
}

function checkEventsAndRefs(level, content, report) {
  const events = new Map(content.events.map((e) => [e.id, e]));
  const objectives = new Map(content.objectives.map((o) => [o.id, o]));
  const dialogue = new Map(content.dialogue.map((d) => [d.id, d]));
  const assets = new Map(content.assets.map((a) => [a.id, a]));
  const gates = new Map(content.gates.map((g) => [g.id, g]));
  const cps = new Set(level.checkpoints.map((c) => c.id));
  const dupes = (list, kind) => {
    const seen = new Set();
    for (const x of list) {
      if (!STABLE_ID.test(x.id)) report.error('ID', `ID inválido (${kind}).`, x.id);
      if (seen.has(x.id)) report.error('ID', `ID duplicado (${kind}).`, x.id);
      seen.add(x.id);
    }
  };
  for (const [kind, list] of [
    ['event', content.events], ['objective', content.objectives], ['dialogue', content.dialogue], ['asset', content.assets],
    ['gate', content.gates], ['interactable', content.interactables], ['hazard', content.hazards], ['enemy', content.enemies],
    ['pickup', content.pickups], ['prop', content.props], ['trigger', content.triggers],
  ]) dupes(list, kind);

  const usedAssets = new Set();
  const useAsset = (ref, owner) => {
    if (ref === null || ref === undefined) return;
    usedAssets.add(ref);
    if (!assets.has(ref)) report.error('ASSET_REF', `assetRef inexistente: ${ref}.`, owner);
  };
  for (const list of [content.gates, content.interactables, content.hazards, content.enemies, content.pickups, content.props]) {
    for (const x of list) useAsset(x.assetRef, x.id);
  }
  const emitted = new Set();
  const flagsUsed = new Set();
  for (const ev of content.events) {
    for (const fx of ev.effects ?? []) {
      if (fx.op === 'dialogue') {
        if (!dialogue.has(fx.id)) report.error('EVENT_REF', `diálogo inexistente: ${fx.id}.`, ev.id);
        else if (dialogue.get(fx.id).event !== ev.id) report.error('DIALOGUE_LINK', 'Diálogo aponta para outro evento.', `${ev.id}/${fx.id}`);
      }
      if (fx.op === 'setObjective' && !objectives.has(fx.id)) report.error('EVENT_REF', `objetivo inexistente: ${fx.id}.`, ev.id);
      if (fx.op === 'completeOptional' && !objectives.has(fx.id)) report.error('EVENT_REF', `objetivo inexistente: ${fx.id}.`, ev.id);
      if (fx.op === 'openGate' && !gates.has(fx.id)) report.error('EVENT_REF', `portão inexistente: ${fx.id}.`, ev.id);
      if (fx.op === 'saveCheckpoint' && !cps.has(fx.id)) report.error('EVENT_REF', `checkpoint inexistente: ${fx.id}.`, ev.id);
      if (fx.op === 'emit') {
        emitted.add(fx.id);
        if (!events.has(fx.id)) report.error('EVENT_REF', `evento emitido inexistente: ${fx.id}.`, ev.id);
      }
      if (fx.op === 'setFlag') flagsUsed.add(fx.flag);
      if (fx.cue) {
        useAsset(fx.cue, ev.id);
        if (assets.has(fx.cue) && assets.get(fx.cue).type !== 'audio') report.error('ASSET_TYPE', 'cue deve apontar para áudio.', ev.id);
      }
    }
    if (ev.after && !events.has(ev.after)) report.error('EVENT_REF', `after inexistente: ${ev.after}.`, ev.id);
  }
  // acyclic emit/after graph
  const edges = new Map(content.events.map((e) => [e.id, [...(e.effects ?? []).filter((f) => f.op === 'emit').map((f) => f.id)]]));
  const visiting = new Set();
  const done = new Set();
  const dfs = (id) => {
    if (done.has(id)) return;
    if (visiting.has(id)) return report.error('EVENT_CYCLE', 'Ciclo de eventos.', id);
    visiting.add(id);
    for (const n of edges.get(id) ?? []) dfs(n);
    visiting.delete(id);
    done.add(id);
    return undefined;
  };
  for (const id of events.keys()) dfs(id);

  const sources = new Set([
    ...content.interactables.map((i) => i.event),
    ...content.triggers.filter((t) => t.kind === 'event').map((t) => t.event),
    ...content.enemies.flatMap((e) => [e.defeatEvent, e.wakeEvent]),
    ...level.checkpoints.map((c) => `evt-${c.id.replace(/^cp-(\d+)-.*/, 'cp-$1')}-activated`),
    ...emitted,
    'evt-level-enter',
    'evt-control-granted',
  ]);
  for (const ev of content.events) if (!sources.has(ev.id)) report.error('EVENT_ORPHAN', 'Evento sem origem (gatilho, interação, inimigo ou emissão).', ev.id);
  for (const o of content.objectives) {
    if (!events.has(o.completedBy)) report.error('OBJ_REF', 'Objetivo completa por evento inexistente.', o.id);
    if (o.requiresAbility && !content.abilities[o.requiresAbility]) report.error('OBJ_ABILITY', 'Habilidade desconhecida.', o.id);
  }
  for (const g of content.gates) {
    const opener = events.get(g.openWhen);
    if (!opener) report.error('GATE_REF', 'Evento de abertura inexistente.', g.id);
    else if (!(opener.effects ?? []).some((f) => f.op === 'openGate' && f.id === g.id)) report.error('GATE_OPEN', 'Evento de abertura não executa openGate.', g.id);
  }
  for (const i of content.interactables) {
    if (!events.has(i.event)) report.error('IX_REF', 'Evento da interação inexistente.', i.id);
    if (content.gates.some((g) => g.openWhen === i.event) && !i.failsafe) report.error('IX_FAILSAFE', 'Interação que abre portão precisa de failsafe.', i.id);
  }
  const comp = content.completion;
  if (!events.has(comp.event)) report.error('COMPLETION', 'Evento de conclusão inexistente.');
  for (const r of comp.requires) if (!events.has(r)) report.error('COMPLETION', `Requisito inexistente: ${r}.`);
  if (!LEVEL_ID.test(comp.next)) report.error('COMPLETION', 'Próxima fase inválida.');
  if (!level.exits.some((x) => x.targetLevelId === comp.next)) report.error('COMPLETION', 'Nenhuma saída leva à próxima fase.');
  const persistent = new Set(content.persistence.persistentFlags);
  for (const f of flagsUsed) if (!persistent.has(f)) report.error('FLAG', `Flag não declarada na persistência: ${f}.`);
  for (const f of persistent) if (!flagsUsed.has(f)) report.error('FLAG', `Flag declarada mas nunca definida: ${f}.`);
  for (const a of content.assets) {
    if (!STABLE_ID.test(a.id)) report.error('ASSET', 'ID de asset inválido.', a.id);
    if (!ASSET_TYPES.has(a.type)) report.error('ASSET', `Tipo de asset inválido: ${a.type}.`, a.id);
    if (!PRE_APPROVAL_STATES.has(a.state) || a.approval !== 'NONE') report.error('ASSET_STATE', 'Asset não pode constar como existente/aprovado neste pacote.', a.id);
    const usedBy = Array.isArray(a.usedBy) ? a.usedBy : [];
    const secIds = new Set(content.sections.map((x) => x.id));
    const ENV_GROUPS = new Set(['solids', 'one-way', 'level']);
    const ENTITY_GROUPS = new Set(['events', 'props', 'interactables', 'gates', 'hazards', 'checkpoints', 'pickups', 'enemies']);
    for (const u of usedBy) if (!ENV_GROUPS.has(u) && !ENTITY_GROUPS.has(u) && !secIds.has(u)) report.error('ASSET_USEDBY', `usedBy desconhecido: ${u}.`, a.id);
    const envUse = usedBy.some((u) => ENV_GROUPS.has(u) || secIds.has(u));
    if (!usedAssets.has(a.id) && !envUse) report.warn('ASSET_UNUSED', 'Asset especificado e não referenciado por entidade/evento.', a.id);
  }
  for (const g of content.gates) if (!g.rect) report.error('GATE', 'Portão sem retângulo.', g.id);
  const respawn = content.respawnPolicy;
  if (!respawn || respawn.onDefeatOrKillzone !== 'last-activated-checkpoint') report.error('RESPAWN', 'Política de respawn ausente ou inesperada.');
}

function checkRouteCoverage(level, content, surfaces, report) {
  const byId = new Map(surfaces.map((s) => [s.id, s]));
  const main = content.route.main;
  const spans = [];
  for (let i = 1; i < main.length; i++) spans.push({ a: main[i - 1], b: main[i] });
  const covers = (rect) =>
    spans.some(({ a, b }) => {
      const lo = Math.min(a.x, b.x);
      const hi = Math.max(a.x, b.x);
      if (!(rect.x < hi && right(rect) > lo)) return false;
      return [a, b].some((n) => {
        const top = byId.get(n.solid).y;
        return rect.y <= top && bottom(rect) >= top - 1;
      });
    });
  const events = new Map(content.events.map((e) => [e.id, e]));
  const sourceRect = (evId) => {
    const ix = content.interactables.find((i) => i.event === evId);
    if (ix) return ix.zone;
    const tr = content.triggers.find((t) => t.event === evId);
    return tr?.rect ?? null;
  };
  const emittedBy = (evId) => content.events.find((e) => (e.effects ?? []).some((f) => f.op === 'emit' && f.id === evId));
  const rootRect = (evId, seen = new Set()) => {
    const r = sourceRect(evId);
    if (r) return r;
    const parent = emittedBy(evId);
    if (!parent || seen.has(parent.id)) return null;
    seen.add(parent.id);
    return rootRect(parent.id, seen);
  };
  for (const o of content.objectives.filter((x) => x.type === 'primary')) {
    const r = rootRect(o.completedBy);
    if (!r) report.error('COVERAGE', 'Objetivo principal sem origem espacial.', o.id);
    else if (!covers(r)) report.error('COVERAGE', 'Rota principal não passa pela origem do objetivo principal.', o.id);
  }
  for (const req of content.completion.requires) {
    const r = rootRect(req);
    if (!r || !covers(r)) report.error('COVERAGE', 'Requisito de conclusão fora da rota principal.', req);
  }
  const exit = level.exits[0];
  if (!covers(rectOf(exit))) report.error('COVERAGE', 'A rota principal não alcança a saída.', exit.id);
  // gates must be opened before the route passes them
  const order = new Map(main.map((n, i) => [n.id, i]));
  for (const g of content.gates) {
    const passIdx = main.findIndex((n) => n.passesGate === g.id);
    if (passIdx < 0) {
      report.error('GATE_ROUTE', 'Nenhum nó da rota principal atravessa o portão.', g.id);
      continue;
    }
    const viaEvent = content.interactables.find((i) => i.event === g.openWhen) ?? null;
    const interactNode = main.find((n) => n.interact && viaEvent && n.interact === viaEvent.id);
    if (!viaEvent || !interactNode) report.error('GATE_ORDER', 'Nenhuma interação da rota principal abre o portão.', g.id);
    else if (order.get(interactNode.id) > passIdx) report.error('GATE_ORDER', 'A rota atravessa o portão antes de abri-lo.', g.id);
  }
  // route nodes reference real checkpoints/interactables/pickups
  const cps = new Set(level.checkpoints.map((c) => c.id));
  const ixs = new Set(content.interactables.map((i) => i.id));
  const pks = new Set(content.pickups.map((p) => p.id));
  for (const n of [...main, ...content.route.optional.flatMap((r) => r.nodes)]) {
    if (n.checkpoint && !cps.has(n.checkpoint)) report.error('ROUTE_REF', 'Checkpoint inexistente.', n.id);
    if (n.interact && !ixs.has(n.interact)) report.error('ROUTE_REF', 'Interação inexistente.', n.id);
    if (n.pickup && !pks.has(n.pickup)) report.error('ROUTE_REF', 'Pickup inexistente.', n.id);
  }
  const mainCps = new Set(main.map((n) => n.checkpoint).filter(Boolean));
  for (const id of cps) if (!mainCps.has(id)) report.error('ROUTE_CHECKPOINT', 'Checkpoint fora da rota principal.', id);
  for (const p of content.pickups) {
    const s = byId.get(p.solid);
    if (!s || p.x <= s.x || p.x >= right(s) || p.y !== s.y) report.error('PICKUP', 'Pickup fora do topo da superfície declarada.', p.id);
  }
}

function checkCounts(level, content, report) {
  const exp = content.qa.expected;
  const actual = {
    sections: content.sections.length,
    checkpoints: level.checkpoints.length,
    killzones: content.hazards.filter((h) => h.kind === 'killzone').length,
    recoveryPits: content.hazards.filter((h) => h.kind === 'recovery-pit').length,
    enemies: content.enemies.length,
    interactables: content.interactables.length,
    pickups: content.pickups.length,
    gates: content.gates.length,
    optionalRoutes: content.route.optional.length,
    primaryObjectives: content.objectives.filter((o) => o.type === 'primary').length,
    optionalObjectives: content.objectives.filter((o) => o.type === 'optional').length,
  };
  for (const [k, v] of Object.entries(exp)) if (actual[k] !== v) report.error('COUNT', `${k}: esperado ${v}, encontrado ${actual[k]}.`);
  return actual;
}

/** Validate a level package. Returns { errors, warnings, stats }; never throws on content problems. */
export function validateLevelPackage(level, content) {
  const report = new Report();
  checkContractMirror(level, report);
  if (report.errors.length) return { errors: report.errors, warnings: report.warnings, stats: null };
  const surfaces = checkGeometry(level, content, report);
  const reach = reachableSurfaces(level, content, surfaces);
  const informationalFalls = checkFalls(level, content, surfaces, reach, report);
  const route = checkRoute(level, content, surfaces, report);
  checkTeaching(content, surfaces, report);
  checkEncounterAndCheckpoints(level, content, surfaces, report);
  checkEventsAndRefs(level, content, report);
  checkRouteCoverage(level, content, surfaces, report);
  const counts = checkCounts(level, content, report);
  return {
    errors: report.errors,
    warnings: report.warnings,
    stats: { counts, route, informationalFalls },
  };
}

export function loadPackage(levelPath, contentPath) {
  return {
    level: JSON.parse(readFileSync(levelPath, 'utf8')),
    content: JSON.parse(readFileSync(contentPath, 'utf8')),
  };
}

function main(argv) {
  const root = new URL('../../', import.meta.url);
  const levelPath = argv[0] ?? fileURLToPath(new URL('content/levels/w1-l1.level.json', root));
  const contentPath = argv[1] ?? fileURLToPath(new URL('content/levels/w1-l1.content.json', root));
  const { level, content } = loadPackage(levelPath, contentPath);
  const { errors, warnings, stats } = validateLevelPackage(level, content);
  const out = (s) => process.stdout.write(`${s}\n`);
  out(`Pacote ${level.id} — ${errors.length} erro(s), ${warnings.length} aviso(s)`);
  for (const e of errors) out(`  ERRO  [${e.code}] ${e.message}${e.ref ? ` (${e.ref})` : ''}`);
  for (const w of warnings) out(`  AVISO [${w.code}] ${w.message}${w.ref ? ` (${w.ref})` : ''}`);
  if (stats) {
    out(`  contagens: ${JSON.stringify(stats.counts)}`);
    for (const s of stats.route.sectionStats) out(`  ${s.id}: ${s.legs} pernas, razão máx ${s.maxRatio.toFixed(2)}`);
    out(`  quedas informativas (> área visível abaixo, sem fonte de dano próxima): ${stats.informationalFalls.length}`);
  }
  process.exitCode = errors.length ? 1 : 0;
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) main(process.argv.slice(2));
