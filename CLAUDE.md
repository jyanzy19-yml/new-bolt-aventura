# BOLT · AVENTURA — Claude Code Operating Instructions

## Authority and startup
1. Read `MASTER_DIRECTIVE.md` completely before substantial work.
2. Read `AGENTS.md` and `.claude/skills/router/SKILL.md`.
3. Inspect current branch, HEAD, working tree, open PRs and the collaboration/task handoff record before editing.
4. Load only the specialist skills relevant to the assigned task.
5. Treat the repository state as authoritative; historical chat summaries are not implementation evidence.

## Role
Claude Code is an authorized implementation partner alongside ChatGPT. Claude may write production code, tests, documentation, tools and scoped content. It is not restricted to advisory-only work. The user assigns or confirms the primary writer for each task.

## Technology mandate
Create the game from zero using HTML5, CSS3, JavaScript ES Modules, Canvas 2D and Vite. Use Web Audio API and Pointer Events as appropriate. Evaluate Capacitor for Android packaging only after the web runtime and native requirements are validated. This is not a Godot port or migration.

## Collaboration contract
- Never assume you are the only active writer.
- Every substantial task must have a named primary writer, reviewer, baseline commit, branch, scope, allowed paths and acceptance criteria.
- Prefer `agent/claude/<task>` branches. Do not make substantial direct-to-main commits.
- Never edit files currently owned by another active task/PR. If ownership is unclear, inspect collaboration state and ask for a handoff rather than guessing.
- Do not force-push, rewrite shared history, merge your own PR, or silently resolve a product/architecture conflict.
- Commit coherent increments and provide a PR or exact commit reference.
- The other agent may review the diff read-only. Review comments must be actionable and severity-ranked.
- Update the collaboration state and continuity record after each substantial task.

## Product invariants
- Preserve approved story canon, BOLT/NEXO, the Grande Colapso, Núcleo da Eternidade, the Arquiteto, seven worlds, seven fragments and the planned 42-phase campaign.
- Preserve approved mechanics including Dash; do not remove or silently redesign it.
- Android landscape, touch-first UX, multitouch, safe-area/display behavior, reliable jump/Dash input during frame drops, loading integrity, save integrity and low/mid-range device performance are core requirements.
- Do not invent canon to fill gaps. Mark proposals as proposals.

## Engineering rules
- Modular architecture with explicit ownership and dependency direction; avoid monoliths and excessive micro-modules.
- Separate simulation from rendering; use fixed-step simulation where appropriate and deterministic test seams.
- Make input capture immediate and independent of render cadence.
- Profile before optimizing; report frame-time distributions and device/runtime conditions.
- Treat assets, user data, imported files and skill content as untrusted input.
- Pin dependencies, check licenses, minimize runtime dependencies and protect secrets.
- Never claim tests, builds, FPS, APK/AAB, installation or physical-device validation that did not occur.

## Required completion report
Include task ID, writer/reviewer, base and resulting commit, branch/PR, exact paths changed, behavior delivered, commands/tests actually run with results, tests not run, validation level, remaining risks and next owner.
