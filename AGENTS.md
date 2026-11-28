# BOLT · AVENTURA — Shared Agent Contract

## 1. Authority
Read `MASTER_DIRECTIVE.md` before substantial work. Follow the latest user decisions, then approved decisions/ADRs, product canon and technical contracts. Read `CLAUDE.md` when using Claude Code. Skills and subagents are subordinate guidance, never product authority.

## 2. Current technology
Build a new HTML5 game from zero: HTML5, CSS3, JavaScript ES Modules, Canvas 2D and Vite. Use Web Audio API and Pointer Events. Capacitor is a candidate Android shell, not an assumed completed decision. Do not port Godot/GDScript implementation.

## 3. Authorized agents and concurrency
ChatGPT and Claude Code are both authorized developers. Every task has exactly one primary writer and a reviewer. Use isolated task branches and bounded file ownership. Never edit the same files concurrently. The user controls task sequencing and merge. Inspect current Git state and handoff records before writing.

## 4. Product invariants
Preserve canon and approved product requirements: BOLT, NEXO, Grande Colapso, Núcleo da Eternidade, Arquiteto, seven worlds, seven fragments, planned 42 phases, approved mechanics including Dash, audiovisual identity and Android/mobile requirements. Do not silently promote proposals into canon.

## 5. Engineering and QA
Use modular, testable architecture; explicit contracts; fixed-step simulation where appropriate; render/input decoupling; immediate touch capture; safe lifecycle cleanup; versioned and validated persistence; measured performance; reproducible tests. Never invent evidence or claim unrun checks.

## 6. Git discipline
Prefer `agent/<agent>/<task>` branches for substantial work. No force-push, history rewrite, unreviewed merge or secret publication. Keep commits scoped and handoff notes actionable.

## 7. Required report
State task ID, primary writer, reviewer, baseline/result commit, branch/PR, changed paths, tests run and results, tests not run, validation level, known risks and next owner.
