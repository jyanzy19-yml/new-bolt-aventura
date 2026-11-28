# HTML5 execution stages — BOLT · AVENTURA

This execution plan operationalizes the clean-start mandate in `HTML5_REBUILD_PLAN.md`. The GitHub issue tracker is the task-level source for ownership, acceptance criteria and review.

1. **Runtime kernel:** fixed-step simulation loop, bounded catch-up, scheduler lifecycle and deterministic tests.
2. **Canvas renderer and viewport:** context lifecycle, logical coordinates, landscape layout, resize and DPR budget.
3. **Input and multitouch:** keyboard and Pointer Events, stable pointer ownership, action edges, short-press buffering and cancellation.
4. **Player physics and Dash:** movement, jump, collision resolution, movement states and approved Dash behavior.
5. **Level runtime and camera:** validated content schema, world geometry, camera bounds and scene lifecycle.
6. **Combat:** weapon contracts, projectiles, damage, cooldowns, hit feedback and terminal lifecycle.
7. **Enemies and hazards:** distinct archetypes, readable telegraphs, encounter data and counterplay.
8. **UI and game flow:** boot/menu, HUD, pause, settings, victory/defeat and navigation.
9. **Assets, loading, audio and persistence:** manifests, preload/decode, failure handling, Web Audio lifecycle, versioned saves and checkpoints.
10. **W1-L1 vertical slice and Android validation:** integrate the separately authored W1-L1 content package and complete the playable loop; validate browser, WebView and physical Android separately.

## Stage gates

- **G1 — Runtime foundation:** loop and timing contracts are unit-tested; clean lint/test/build.
- **G2 — Control foundation:** renderer/viewport and multitouch input work under resize, cancellation and frame stalls.
- **G3 — Playable mechanics:** BOLT movement, jump, collision and Dash are deterministic and test-covered.
- **G4 — Integrated gameplay:** phase, camera, combat, enemies and hazards support a complete encounter.
- **G5 — Product loop:** UI, loading, audio, save and checkpoints support a complete restartable phase.
- **G6 — Platform readiness:** WebView and Android packaging are tested to the evidence level actually available; physical-device validation remains a separate gate.

A passing web build is not a playable game. A passing browser test is not Android verification. A generated APK is not proof of installation, input latency, frame pacing, memory or thermal stability.
