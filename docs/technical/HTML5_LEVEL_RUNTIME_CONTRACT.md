# HTML5 level runtime contract — schema v1

**Status:** implementation contract for the clean-start HTML5 runtime.  
**Scope:** level identity, world bounds, spawn, static geometry, checkpoints, exits and camera-follow parameters.  
**Not included:** enemy/encounter definitions, narrative event graphs, asset manifests, audio cues or final W1-L1 content.

## 1. Coordinate system

- World coordinates use CSS-independent logical game units.
- Origin and axis orientation: top-left origin; X increases right; Y increases down.
- Rectangles use `x`, `y`, `width`, `height`; width and height must be positive.
- AABB edge contact is not an overlap.
- Runtime geometry must fit inside the declared level bounds.

## 2. Level definition

A level object must declare:

| Field | Contract |
|---|---|
| `schemaVersion` | Integer supported by runtime; currently `1` |
| `id` | Campaign ID matching `w1-l1` through `w7-l6` |
| `worldId` | Stable kebab-case world identifier |
| `title` | Non-empty display title |
| `bounds` | Positive AABB describing the playable world extent |
| `spawn` | Finite point contained by bounds |
| `geometry.solids` | Array of static solid AABBs with unique stable IDs |
| `geometry.oneWayPlatforms` | Array of static one-way AABBs with unique stable IDs |
| `checkpoints` | Array of stable IDs and finite points within bounds |
| `exits` | Array of stable IDs, trigger AABBs and valid target level IDs |

IDs must be unique across geometry, checkpoints and exits within one level. Unknown top-level metadata is preserved by validation; runtime-critical fields remain strict.

## 3. Collision semantics

- Solid AABBs block horizontal and vertical movement.
- One-way platforms block only downward crossings of their upper face.
- One-way platforms do not block horizontal movement or upward movement.
- `dropThrough` bypasses one-way platforms for the current movement operation.
- The first collision kernel is static and axis-separated. Slopes, moving platforms and dynamic-vs-dynamic collision require separate contracts and tests.
- `createCollisionWorldFromLevel` accepts only a validated definition.

## 4. Camera contract

`Camera2D` receives explicit viewport dimensions, world bounds and dead-zone rectangle. Optional horizontal look-ahead and exponential smoothing are configurable. The camera:

1. Centers the target on initialization/reset.
2. Remains stationary while the target stays inside the dead zone.
3. Moves only when the target exits the dead zone.
4. Applies optional look-ahead according to horizontal velocity sign.
5. Clamps to world bounds; if the world is smaller than the viewport, centers the world.

The runtime does not define final dead-zone, look-ahead or smoothing values here. Those values require representative playtesting and must not be treated as approved design tuning.

## 5. Validation and failure policy

Invalid schema versions, malformed IDs, duplicate IDs, non-finite coordinates, non-positive rectangles, out-of-bounds geometry/spawns/exits and unsupported target level IDs are rejected before the level is made available to gameplay. Do not silently repair malformed content.

## 6. Future extensions

Add entities, encounter data, triggers, collectibles, narrative events, asset/audio references and checkpoint persistence only with explicit schema versioning, migration policy, stable IDs and corresponding validation tests. Do not overload the level definition with runtime object instances or save-state data.
