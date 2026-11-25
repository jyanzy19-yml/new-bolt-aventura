---
name: bolt-save-integrity
description: Designs and audits BOLT save data, checkpoint consistency, fragment progression, migration, recovery and Android interruption safety.
---

# BOLT Save Integrity

## Mission
Protect player progress across crashes, app interruption, updates and repeated actions.

## Data classification
Separate transient runtime state from persistent progress. Define one source of truth for settings, world unlocks, fragments, checkpoints, secrets, dialogue flags and campaign completion.

## Design rules
- Use stable IDs, not scene-tree paths or display names, as persistent identifiers.
- Version the save schema and define migration behavior.
- Validate loaded data and provide safe recovery for malformed or partial saves.
- Avoid writing every frame; define meaningful save boundaries.
- Make critical progression updates atomic where possible.
- Prevent duplicate rewards when events replay.
- Define checkpoint restore semantics for player, enemies, doors, pickups and boss state.
- Never store credentials or signing secrets in save data or repository files.
- Avoid destructive migration; preserve backup/recovery path where feasible.

## Test matrix
Fresh save; repeated save; app interruption during save; corrupted/truncated file; missing fields; unknown version; migration; checkpoint respawn; boss defeat; fragment acquisition; scene transition; duplicate trigger; storage unavailable.

## Acceptance
A valid save resumes consistently, malformed data does not crash the game, migrations are explicit, and critical progression cannot be duplicated or silently lost.
