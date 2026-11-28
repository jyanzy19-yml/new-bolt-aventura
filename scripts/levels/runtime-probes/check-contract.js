/* eslint-disable no-console -- sonda de linha de comando; a saída é o resultado. */
import { readFileSync } from 'node:fs';
import { validateLevelDefinition } from '../../../src/levels/level-definition.js';
import { LevelRuntime } from '../../../src/levels/level-runtime.js';
import { createLevelCollisionWorld } from '../../../src/levels/level-collision-adapter.js';

const level = JSON.parse(readFileSync(new URL('../../../content/levels/w1-l1.level.json', import.meta.url), 'utf8'));
validateLevelDefinition(level);
console.log('validateLevelDefinition: OK  (id=%s, solids=%d, oneWay=%d, checkpoints=%d, exits=%d)',
  level.id, level.geometry.solids.length, level.geometry.oneWayPlatforms.length, level.checkpoints.length, level.exits.length);
const loaded = new LevelRuntime().load(level);
console.log('LevelRuntime.load: OK (immutable snapshot, id=%s)', loaded.id);
const world = createLevelCollisionWorld(loaded);
console.log('CollisionWorld colliders:', world.colliders.length);

// the debug fixture must also still pass, as a control
const { DEBUG_W1_L1 } = await import('../../../src/levels/fixtures/w1-l1-debug.js');
validateLevelDefinition(DEBUG_W1_L1); console.log('control (debug fixture): OK');

// negative control: the contract must reject a dotted/uppercase id like my first draft used
try { validateLevelDefinition({ ...level, geometry: { ...level.geometry, solids: [{ id: 'W1-L1.solid.x', x: 0, y: 0, width: 1, height: 1 }] } }); console.log('NEGATIVE CONTROL FAILED'); }
catch (e) { console.log('negative control ok ->', e.message); }
