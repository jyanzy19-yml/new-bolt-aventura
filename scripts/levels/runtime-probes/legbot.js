/* eslint-disable no-console -- sonda de linha de comando; a saída é o resultado. */
import { readFileSync } from 'node:fs';
import { createLevelCollisionWorld } from '../../../src/levels/level-collision-adapter.js';
import { PlayerMotor } from '../../../src/gameplay/player-motor.js';
import { DEBUG_PLAYER_TUNING as BASE } from '../../../src/levels/fixtures/w1-l1-debug.js';

const level = JSON.parse(readFileSync(new URL('../../../content/levels/w1-l1.level.json', import.meta.url), 'utf8'));
const content = JSON.parse(readFileSync(new URL('../../../content/levels/w1-l1.content.json', import.meta.url), 'utf8'));
const world = createLevelCollisionWorld(level);
const surf = new Map([...level.geometry.solids, ...level.geometry.oneWayPlatforms].map((s) => [s.id, s]));
const DT = 1 / 60, BW = 30, BH = 46, R = 'move-right', J = 'jump', D = 'dash';

const tuned = (k) => ({ ...BASE, maxRunSpeed: BASE.maxRunSpeed * k, jumpVelocity: BASE.jumpVelocity * k, dash: { ...BASE.dash, speed: BASE.dash.speed * k } });

function onTarget(snap, to) {
  const b = snap.body;
  return snap.grounded && Math.abs(b.y + BH - to.y) < 0.6 && b.x + BW > to.x && b.x < to.x + to.width;
}

// plan = {startX, takeoffRight, hold1, dbl: {k2, hold2}|null, dash: kd|null, noJump: bool}
function attempt(from, to, plan, cfg) {
  const m = new PlayerMotor({ body: { x: plan.startX, y: from.y - BH, width: BW, height: BH }, collisionWorld: world, config: cfg });
  const step = (o = {}) => m.update(DT, { pressed: [], released: [], held: [], ...o });
  for (let i = 0; i < 4; i++) step();
  let s = m.snapshot, f = 0, jumped = -1, holdLeft = 0, secondAt = -1, hold2Left = 0, dashed = false;
  for (f = 0; f < 420; f++) {
    const held = [R]; const pressed = [], released = [];
    if (!plan.noJump) {
      if (jumped < 0 && s.body.x + BW >= plan.takeoffRight && s.grounded) { pressed.push(J); jumped = f; holdLeft = plan.hold1; }
      if (jumped >= 0 && f > jumped) {
        if (holdLeft > 0) { held.push(J); holdLeft--; if (holdLeft === 0) released.push(J); }
      } else if (jumped === f) held.push(J);
      if (plan.dbl && jumped >= 0 && secondAt < 0 && f - jumped >= plan.dbl.k2 && !s.grounded) { pressed.push(J); secondAt = f; hold2Left = plan.dbl.hold2; }
      if (secondAt >= 0 && f > secondAt) { if (hold2Left > 0) { held.push(J); hold2Left--; if (hold2Left === 0) released.push(J); } } else if (secondAt === f) held.push(J);
    }
    if (plan.dash != null && jumped >= 0 && !dashed && f - jumped >= plan.dash) { pressed.push(D); dashed = true; }
    s = step({ held, pressed, released });
    if (f > 3 && onTarget(s, to)) { for (let k = 0; k < 3; k++) s = step({ held: [] }); if (onTarget(s, to)) return true; }
    if (s.body.y > level.bounds.height) return false;
  }
  return false;
}

function legPlans(from, to, via) {
  const plans = [];
  const edge = (to.x >= from.x + from.width) ? from.x + from.width : to.x;
  const lo = (to.x >= from.x + from.width) ? edge - 160 : edge - 200, hi = edge + 24;
  const runUps = [0, 128, 400];
  for (let tx = lo; tx <= hi; tx += 16) for (const ru of runUps) {
    const startX = Math.max(from.x + 2, tx - BW - ru);
    if (startX + BW > from.x + from.width) continue;
    if (via === 'drop') { plans.push({ startX, takeoffRight: 1e9, noJump: true, hold1: 0 }); continue; }
    const holds = via === 'jump' ? [1, 4, 8, 12, 16, 24, 40] : [24];
    for (const h1 of holds) {
      if (via === 'jump') plans.push({ startX, takeoffRight: tx, hold1: h1 });
      else if (via === 'doubleJump') for (let k2 = 8; k2 <= 40; k2 += 4) for (const h2 of [8, 16, 24, 40]) plans.push({ startX, takeoffRight: tx, hold1: h1, dbl: { k2, hold2: h2 } });
      else if (via === 'jumpDash') for (let kd = 6; kd <= 40; kd += 4) plans.push({ startX, takeoffRight: tx, hold1: h1, dash: kd });
    }
  }
  return plans;
}

function runLeg(fromId, toId, via, k) {
  const from = surf.get(fromId), to = surf.get(toId); const cfg = tuned(k);
  const plans = legPlans(from, to, via); let ok = 0;
  for (const p of plans) if (attempt(from, to, p, cfg)) ok++;
  return { ok, total: plans.length };
}
// "single jump must not suffice" control: same search but with a SINGLE jump only
function runSingle(fromId, toId, k) { return runLeg(fromId, toId, 'jump', k); }

const legs = [];
const pushLegs = (nodes, startPrev) => { let prev = startPrev; for (const n of nodes) { if (prev && n.via !== 'start' && n.via !== 'walk') legs.push({ from: prev.solid, to: n.solid, via: n.via, alsoVia: n.alsoVia, id: n.id }); prev = n; } };
pushLegs(content.route.main, null);
for (const r of content.route.optional) pushLegs(r.nodes, { solid: r.from });

// recovery pits: climbing out must always be possible (rise 48 px over the pit edge)
for (const [f, t, id] of [['s2-pit1-bed','s2-floor-b','pit1-exit'],['s2-pit2-bed','s2-floor-c','pit2-exit'],['s4-trench-1-bed','s4-courtyard-1','trench1-exit'],['s4-trench-2-bed','s4-courtyard-2','trench2-exit']])
  legs.push({ from: f, to: t, via: 'jump', id });
const scales = [1.0, 0.9, 1.1];
let bad = 0;
console.log('leg'.padEnd(18), 'from→to'.padEnd(40), 'via'.padEnd(11), scales.map((k) => `x${k}`.padEnd(14)).join(''), 'single-jump@1.0/1.1');
for (const L of legs) {
  const cols = []; let okAll = true;
  for (const k of scales.slice(0, 2)) { const r = runLeg(L.from, L.to, L.via, k); cols.push(`${r.ok}/${r.total}`.padEnd(14)); if (r.ok === 0) okAll = false; }
  const r11 = runLeg(L.from, L.to, L.via, 1.1); cols.push(`${r11.ok}/${r11.total}`.padEnd(14));
  let single = '-';
  if (L.via === 'doubleJump' || L.via === 'jumpDash') {
    const s10 = runSingle(L.from, L.to, 1.0), s11 = runSingle(L.from, L.to, 1.1);
    single = `${s10.ok}/${s10.total}  ${s11.ok}/${s11.total}`;
    if (s10.ok > 0) okAll = false; // a leg marked as needing double jump/dash must not be doable with a single jump
  }
  let alt = '';
  if (L.alsoVia) { const a = runLeg(L.from, L.to, L.alsoVia, 1.0); alt = `  alt ${L.alsoVia}: ${a.ok}/${a.total}`; if (a.ok === 0) okAll = false; }
  if (!okAll) bad++;
  console.log(L.id.padEnd(18), `${L.from}→${L.to}`.padEnd(40), L.via.padEnd(11), cols.join(''), single + alt, okAll ? '' : '  <<< PROBLEM');
}
console.log(bad === 0 ? '\nALL LEGS FEASIBLE at 100% and 90% tuning; double-jump legs not doable with a single jump.' : `\n${bad} leg(s) with problems`);
process.exitCode = bad === 0 ? 0 : 1;
