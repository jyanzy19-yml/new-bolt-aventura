import { CollisionWorld } from '../../../src/physics/collision-world.js';
import { PlayerMotor } from '../../../src/gameplay/player-motor.js';
import { DEBUG_PLAYER_TUNING as T } from '../../../src/levels/fixtures/w1-l1-debug.js';

const DT = 1 / 60, FLOOR_Y = 1000, R = 'move-right', J = 'jump', D = 'dash';
const world = () => new CollisionWorld([{ id: 'floor', x: -10000, y: FLOOR_Y, width: 40000, height: 200 }]);
const feetY = (s) => s.body.y + s.body.height;

class Run {
  constructor() { this.m = new PlayerMotor({ body: { x: 0, y: FLOOR_Y - 46, width: 30, height: 46 }, collisionWorld: world(), config: T }); this.trace = []; this.step({}, 5); this.trace = []; this.x0 = this.m.snapshot.body.x; }
  step(o = {}, n = 1) { for (let i = 0; i < n; i++) { const s = this.m.update(DT, { pressed: [], released: [], held: [], ...o }); this.trace.push(s); this.last = s; } return this; }
  untilApex() { let g = 0; while (this.last.velocity.y < 0 && g++ < 200) this.step({ held: this.hold ?? [] }); return this; }
  untilLand(o = {}) { let g = 0; while (!(this.last.grounded && this.trace.length > 3) && g++ < 400) this.step(o); return this; }
  peak() { return FLOOR_Y - Math.min(...this.trace.map(feetY)); }
  dx() { return this.last.body.x - this.x0; }
}
const fmt = (n) => n.toFixed(1);

// 1) tap
{ const r = new Run().step({ pressed: [J], held: [J] }).step({ released: [J] }).untilLand(); console.log('tap jump height px', fmt(r.peak())); }
// 2) full hold (hold through hold window, then release at apex)
{ const r = new Run().step({ pressed: [J], held: [J] }); r.hold = [J]; r.untilApex(); r.step({ released: [J] }).untilLand();
  console.log('full-hold jump height px', fmt(r.peak()), ' air time s', fmt(r.trace.length / 60)); }
// 3) double jump at first apex, both held
{ const r = new Run().step({ pressed: [J], held: [J] }); r.hold = [J]; r.untilApex(); const a1 = FLOOR_Y - feetY(r.last);
  r.step({ pressed: [J], held: [J] }); r.hold = [J]; r.untilApex(); r.step({ released: [J] }).untilLand();
  console.log('first apex px', fmt(a1), ' double-jump peak height px', fmt(r.peak())); }
// 3b) double jump with early tap on first (min height route to check double jump needed)
// 4) max-speed running jump, full hold, release at apex
{ const r = new Run().step({ held: [R] }, 90); r.x0 = r.last.body.x; r.step({ pressed: [J], held: [J, R] }); r.hold = [J, R]; r.untilApex(); r.step({ released: [J], held: [R] }).untilLand({ held: [R] });
  console.log('running v', fmt(r.trace[0].velocity.x), ' flat running-jump horizontal px', fmt(r.dx()), ' air frames', r.trace.length); }
// 5) standing-start jump while holding right
{ const r = new Run(); r.step({ pressed: [J], held: [J, R] }); r.hold = [J, R]; r.untilApex(); r.step({ released: [J], held: [R] }).untilLand({ held: [R] });
  console.log('standing-start jump horizontal px', fmt(r.dx())); }
// 6) grounded dash distance
{ const r = new Run().step({ held: [R] }, 2); r.x0 = r.last.body.x; r.step({ pressed: [D], held: [R] }).step({ held: [R] }, 18);
  console.log('grounded dash displacement px (dash window 0.3 s)', fmt(r.dx())); }
// 7) running jump + dash at apex
{ const r = new Run().step({ held: [R] }, 90); r.x0 = r.last.body.x; r.step({ pressed: [J], held: [J, R] }); r.hold = [J, R]; r.untilApex();
  r.step({ pressed: [D], held: [R] }).step({ held: [R] }, 18).untilLand({ held: [R] });
  console.log('running jump + dash at apex horizontal px', fmt(r.dx())); }
// 8) running double jump (2nd at first apex, hold both, release at 2nd apex)
{ const r = new Run().step({ held: [R] }, 90); r.x0 = r.last.body.x; r.step({ pressed: [J], held: [J, R] }); r.hold = [J, R]; r.untilApex();
  r.step({ pressed: [J], held: [J, R] }); r.hold = [J, R]; r.untilApex(); r.step({ released: [J], held: [R] }).untilLand({ held: [R] });
  console.log('running double-jump horizontal px', fmt(r.dx()), ' peak', fmt(r.peak())); }
// 9) running jump with an ONE-WAY landing 96 px higher: can single jump do it?  report single jump peak under hold w/ release at apex = (2)
