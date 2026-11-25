---
description: Resume BOLT production from verified repository state and the continuity handoff.
---

Resume the BOLT · AVENTURA implementation without relying on previous chat memory.

1. Read MASTER_DIRECTIVE.md, CLAUDE.md, AGENTS.md, docs/production/CONTINUITY.md, docs/production/stage-status.md, docs/production/implementation-tracker.md and docs/production/quality-control-protocol.md.
2. Inspect the current branch, HEAD commit, working tree, recent commits and actual project files. The repository state overrides stale handoff notes.
3. Check whether project.godot, scenes, GDScript, assets, tests and Android export configuration exist. Never assume they exist.
4. Identify the current gate and the next exact unfinished task from evidence, not from a guessed percentage.
5. Load the router and only the relevant specialist skills/agents.
6. Continue the highest-priority safe task already authorized. Do not repeat completed work or stop at another planning report.
7. Run relevant checks, record failures and update the implementation tracker, stage status and CONTINUITY.md.
8. Commit coherent changes when appropriate and leave a precise next action.

Never claim tests, builds, APK installation, physical-device validation or performance results unless actually performed. Ask only for material decisions outside approved scope, user-only credentials/signing, destructive-risk actions or genuine blockers. Continue independent work while blocked.
