# BOLT · AVENTURA — HTML5 Execution Tracker

**Baseline:** `main` at `27c34070a9ee1746076a1ca034833a577858b306` (tree restored to the original `9c32df4225b4e410340b2254a098167023593625` baseline)  
**Technology authority:** HTML5, CSS3, JavaScript ES Modules, Canvas 2D, Vite, Web Audio API and Pointer Events.  
**Product target:** Android landscape; Capacitor remains conditional on validation.  
**Status vocabulary:** PLANNED → IMPLEMENTED → TESTED → VERIFIED. These states are not interchangeable.

## GitHub execution stages

| Stage | GitHub issue | Primary responsibility | Scope | Status |
|---|---:|---|---|---|
| 01 — Runtime kernel | [#135](https://github.com/jyanzy19-yml/new-bolt-aventura/issues/135) | ChatGPT | Fixed-step clock/loop, bounded catch-up, deterministic tests | TESTED — [PR #145](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/145), lint/tests/build/docs pass; CodeQL running |
| 02 — Canvas renderer and viewport | [#136](https://github.com/jyanzy19-yml/new-bolt-aventura/issues/136) | ChatGPT | Canvas lifecycle, logical viewport, resize and DPR policy | TESTED — [PR #146](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/146), CI green; awaiting review/merge |
| 03 — Input and multitouch | [#137](https://github.com/jyanzy19-yml/new-bolt-aventura/issues/137) | ChatGPT | Keyboard, Pointer Events, action edges/buffer, cancellation and touch UI | TESTED — [PR #147](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/147) + accessible touch layer [PR #157](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/157), CI green; awaiting review/merge |
| 04 — Player physics and Dash | [#138](https://github.com/jyanzy19-yml/new-bolt-aventura/issues/138) | ChatGPT | Movement, jump, collision, state machine and approved Dash | TESTED — collision [PR #148](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/148), PlayerMotor/Dash [PR #151](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/151), debug renderer [PR #154](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/154), all CI green; scene composition [PR #158](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/158) Web CI pending |
| 05 — Level runtime and camera | [#139](https://github.com/jyanzy19-yml/new-bolt-aventura/issues/139) | ChatGPT | Validated level schema, world geometry, camera and lifecycle | TESTED — schema/camera [PR #149](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/149), immutable LevelRuntime [PR #152](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/152), geometry adapter [PR #153](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/153), all CI green; integration pending |
| 06 — Combat | [#140](https://github.com/jyanzy19-yml/new-bolt-aventura/issues/140) | ChatGPT | Weapons, projectiles, damage and combat lifecycle | TESTED — health/projectiles [PR #150](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/150), WeaponController [PR #155](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/155), CombatRuntime [PR #156](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/156), configured CI green; content catalogue/feedback pending |
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

The current `main` HEAD is `27c34070a9ee1746076a1ca034833a577858b306`; its tree SHA matches the original baseline `9c32df4225b4e410340b2254a098167023593625` after an unintended documentation add was immediately deleted. No implementation files remain changed on main. PRs #145–#159 are open and unmerged. Runtime, Canvas viewport, input, collision, PlayerMotor/Dash, touch controls, debug renderer, PlayerSceneRuntime, level schema/camera/lifecycle/geometry adapter and combat/weapon composition are implemented on isolated branches. Configured CI is green for PRs #145–#157; PR #158 documentation validation passed and Web CI is pending. No playable W1-L1, final weapon catalogue, APK/Capacitor package or physical-device validation is claimed.
