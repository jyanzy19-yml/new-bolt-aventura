# Level geometry → CollisionWorld adapter

**Status:** adapter contract for static level geometry.  
**Dependency:** `CollisionWorld` static AABB kernel.  
**Caller responsibility:** validate the complete definition with `validateLevelDefinition()` and load it through `LevelRuntime` before adapting.

## Mapping

- `geometry.solids[]` becomes static colliders with `oneWay: false`.
- `geometry.oneWayPlatforms[]` becomes static colliders with `oneWay: true`.
- Stable IDs are preserved.
- Duplicate IDs across both arrays are rejected by CollisionWorld.
- Invalid AABBs are rejected by CollisionWorld.
- The source level object is never mutated.

## Deliberate exclusions

This adapter does not create enemies, hazards, pickups, checkpoints, exits, moving platforms, slopes, triggers or dynamic bodies. It also does not validate the full level schema itself; that remains the responsibility of `validateLevelDefinition()`. This separation prevents the physics kernel from depending on content-schema modules.
