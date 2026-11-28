# BOLT · AVENTURA — HTML5 Execution Tracker

**Baseline:** `main` at `9c32df4225b4e410340b2254a098167023593625`  
**Technology authority:** HTML5, CSS3, JavaScript ES Modules, Canvas 2D, Vite, Web Audio API and Pointer Events.  
**Product target:** Android landscape; Capacitor remains conditional on validation.  
**Status vocabulary:** PLANNED → IMPLEMENTED → TESTED → VERIFIED. These states are not interchangeable.

## GitHub execution stages

| Stage | GitHub issue | Primary responsibility | Scope | Status |
|---|---:|---|---|---|
| 01 — Runtime kernel | [#135](https://github.com/jyanzy19-yml/new-bolt-aventura/issues/135) | ChatGPT | Fixed-step clock/loop, bounded catch-up, deterministic tests | IN PROGRESS |
| 02 — Canvas renderer and viewport | [#136](https://github.com/jyanzy19-yml/new-bolt-aventura/issues/136) | ChatGPT | Canvas lifecycle, logical viewport, resize and DPR policy | PLANNED |
| 03 — Input and multitouch | [#137](https://github.com/jyanzy19-yml/new-bolt-aventura/issues/137) | ChatGPT | Keyboard, Pointer Events, action edges/buffer, cancellation | PLANNED |
| 04 — Player physics and Dash | [#138](https://github.com/jyanzy19-yml/new-bolt-aventura/issues/138) | ChatGPT | Movement, jump, collision, state machine and approved Dash | PLANNED |
| 05 — Level runtime and camera | [#139](https://github.com/jyanzy19-yml/new-bolt-aventura/issues/139) | ChatGPT | Validated level schema, world geometry and camera | PLANNED |
| 06 — Combat | [#140](https://github.com/jyanzy19-yml/new-bolt-aventura/issues/140) | ChatGPT | Weapons, projectiles, damage and combat lifecycle | PLANNED |
| 07 — Enemies and hazards | [#141](https://github.com/jyanzy19-yml/new-bolt-aventura/issues/141) | Claude Code (content), ChatGPT (runtime) | Enemy archetypes, encounter data, hazards and telegraphs | PLANNED |
| 08 — UI and game flow | [#142](https://github.com/jyanzy19-yml/new-bolt-aventura/issues/142) | ChatGPT | Menus, HUD, pause, settings and result flow | PLANNED |
| 09 — Assets, loading, audio and saves | [#143](https://github.com/jyanzy19-yml/new-bolt-aventura/issues/143) | ChatGPT | Asset manifest, real loading, Web Audio and versioned persistence | PLANNED |
| 10 — W1-L1 vertical slice and Android validation | [#144](https://github.com/jyanzy19-yml/new-bolt-aventura/issues/144) | ChatGPT + Claude Code | Integrate W1-L1 package and validate the complete playable loop | PLANNED |

## Execution rules

- One primary writer per task; reviewer does not edit the same paths concurrently.
- Every stage uses an isolated branch and a pull request. No direct implementation commits to `main`.
- Each issue must record baseline commit, allowed/forbidden paths, acceptance criteria, tests, evidence and next owner.
- Claude Code owns the W1-L1 content package under its own handoff; ChatGPT owns runtime contracts and integration.
- No Godot/GDScript implementation is active. Historical engine-specific documents are not implementation authority.
- Do not mark a stage TESTED until the named commands actually pass. Do not mark it VERIFIED without representative runtime/platform evidence.
- Preserve approved canon and Dash. Keep proposals separate from approved decisions.
- Never claim Android physical-device validation from browser tests or CI alone.

## Current implementation boundary

The repository contains a Vite shell and a small tested math utility. This is a technical foundation, not gameplay. The first implementation increment establishes a bounded fixed-step runtime loop before renderer, input and gameplay systems are layered on top.
