# BOLT Skill Router — HTML5 + Multi-Agent Production

## Authority and collaboration
Read `MASTER_DIRECTIVE.md` and `AGENTS.md` first. Claude Code must also read `CLAUDE.md`. Inspect task ownership and current Git state before editing. ChatGPT and Claude are authorized writers; one primary writer per task, isolated branch, no simultaneous same-file edits, review before merge.

## Route by task
- Architecture, module boundaries, dependency direction, Vite and tooling: `html5-game-architecture`.
- Canvas renderer, camera, DPR, frame loop, visibility and lifecycle: `canvas2d-runtime`.
- Movement, collision, combat, Dash, simulation and state machines: `gameplay-physics-loop`.
- Touch, multitouch, pointer lifecycle, safe areas and responsive UX: `mobile-input-ux`.
- Profiling, memory, WebView and thermal constraints: `android-web-performance`.
- Asset manifests, decoding, loading, Web Audio and transitions: `assets-loading-audio`.
- Unit/integration/browser regression and evidence: `web-game-qa`.
- APK/AAB, native shell and Capacitor: `android-capacitor-packaging`.
- Task ownership, branch isolation, review and handoff: `collaborative-development`.
- World, phase, encounter and progression content: `level-design-content`.
- Enemy archetypes, boss state machines and combat readability: `enemy-boss-design`.
- Save schema, checkpoint, migration and recovery: `persistence-save-integrity`.
- UI systems, accessibility, touch ergonomics and safe-area behavior: `ui-ux-accessibility`.
- CI, repository hygiene, dependency and release gates: `web-tooling-ci`.

Load only skills required by the task. Never load every skill by default.

## Legacy handling
Godot/GDScript skills, scripts, workflows and technical docs are not implementation guidance for the new HTML5 game. Preserve useful product/canon information only when it does not conflict with the latest HTML5 clean-start decision. Do not delete legacy paths until the complete Git tree has been inventoried and the user-approved cleanup scope is clear.

## Evidence
Distinguish PLANNED, IMPLEMENTED, TESTED and VERIFIED. Record exact commands, environment, commit, outputs and limitations. Skills and agent files do not replace execution or user approval.
