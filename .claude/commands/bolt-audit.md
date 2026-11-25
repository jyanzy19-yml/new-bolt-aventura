---
description: Audit the current BOLT repository/project state and report verified facts, risks and next gate.
---

Perform a read-only audit of the current BOLT · AVENTURA repository.

1. Read CLAUDE.md, AGENTS.md, docs/README.md, docs/production/stage-status.md and docs/production/definition-of-done.md.
2. Inspect repository structure. Determine whether a Godot project exists; if so, identify project.godot, exact Godot version, renderer, Android export configuration and current implementation state.
3. Inspect relevant skills and specialist agents. Load only those required.
4. Verify referenced files and relative links relevant to the audit.
5. Separate verified facts, assumptions, missing information and proposals.
6. Report blockers, technical risks and the smallest sensible next step.

Do not modify files. Do not claim tests, builds, exports or Android device checks that were not actually run. Never infer game implementation from the presence of documentation or skills.
