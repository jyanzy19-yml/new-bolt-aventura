---
name: persistence-save-integrity
description: "Design robust save schemas, checkpoint persistence and migration recovery."
---

# Skill: Persistence, Checkpoints and Save Integrity

Separate transient runtime state, checkpoint state and campaign-persistent state. Use stable IDs for worlds, phases, fragments, unlocks, inventory and flags. Define a versioned schema and migration policy before expanding the format.

Validate loaded data; handle missing, malformed, stale and future-version payloads. Use safe writes where supported, preserve last-known-good recovery and never overwrite valid data with partial data. Treat storage as untrusted and reject impossible IDs/values.

Specify what death, checkpoint reload, phase restart, app termination and new game reset. Keep narrative flags, fragment collection, phase completion and unlocks consistent; prevent duplicate rewards and progression skips.

Test first launch, save/load, interrupted write, corrupt payload, schema migration, unknown IDs, repeated reward claims, checkpoint reload, cold start, app update and storage unavailable. Physical-device claims require device evidence.
