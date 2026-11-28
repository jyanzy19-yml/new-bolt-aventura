# BOLT · AVENTURA — HTML5 Execution Tracker

**Baseline:** `main` at `9c32df4225b4e410340b2254a098167023593625`  
**Technology authority:** HTML5, CSS3, JavaScript ES Modules, Canvas 2D, Vite, Web Audio API and Pointer Events.  
**Product target:** Android landscape; Capacitor remains conditional on validation.  
**Status vocabulary:** PLANNED → IMPLEMENTED → TESTED → VERIFIED. These states are not interchangeable.

## GitHub execution stages

| Stage | GitHub issue | Primary responsibility | Scope | Status |
|---|---:|---|---|---|
| 01 — Runtime kernel | [#135](https://github.com/jyanzy19-yml/new-bolt-aventura/issues/135) | ChatGPT | Fixed-step clock/loop, bounded catch-up, deterministic tests | TESTED — [PR #145](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/145), lint/tests/build/docs pass; CodeQL running |
| 02 — Canvas renderer and viewport | [#136](https://github.com/jyanzy19-yml/new-bolt-aventura/issues/136) | ChatGPT | Canvas lifecycle, logical viewport, resize and DPR policy | TESTED — [PR #146](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/146), CI green; awaiting review/merge |
| 03 — Input and multitouch | [#137](https://github.com/jyanzy19-yml/new-bolt-aventura/issues/137) | ChatGPT | Keyboard, Pointer Events, action edges/buffer, cancellation | TESTED — [PR #147](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/147), CI green; awaiting review/merge |
| 04 — Player physics and Dash | [#138](https://github.com/jyanzy19-yml/new-bolt-aventura/issues/138) | ChatGPT | Movement, jump, collision, state machine and approved Dash | IN PROGRESS — collision kernel in [PR #148](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/148) CI green; configurable PlayerMotor/jump/Dash in [PR #151](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/151), latest test run pending after correction |
| 05 — Level runtime and camera | [#139](https://github.com/jyanzy19-yml/new-bolt-aventura/issues/139) | ChatGPT | Validated level schema, world geometry and camera | IN PROGRESS — schema/camera [PR #149](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/149) CI green; immutable transactional lifecycle [PR #152](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/152) CI green; collision adapter pending |
| 06 — Combat | [#140](https://github.com/jyanzy19-yml/new-bolt-aventura/issues/140) | ChatGPT | Weapons, projectiles, damage and combat lifecycle | IN PROGRESS — health/projectile core in [PR #150](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/150); Web CI pass, CodeQL pending |
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

The current `main` baseline still contains the Vite shell and math utility. PRs #145–#152 hold runtime, renderer, input, collision, PlayerMotor/Dash, level schema/camera/lifecycle and combat increments; all remain unmerged. PRs #145–#149 and #152 have passing configured checks; PR #150 Web CI passed. PR #151 had a test-expectation failure on an earlier commit; the assertion was corrected and the latest run is pending. No playable phase, final weapon catalog, Android package or physical-device validation is claimed.
