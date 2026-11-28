---
name: deterministic-gameplay-testing
description: "Build deterministic gameplay tests and reliable regression coverage."
---

# Skill: Deterministic Gameplay and Regression Testing

Design gameplay systems so time, randomness, input and persistence can be controlled in tests. Prefer injected clock/random sources and explicit action queues over hidden global state.

Test boundary conditions: zero/large delta, frame drops, multiple events between frames, press+release before update, pointercancel, simultaneous actions, pause/resume, death/reset and repeated scene transitions.

For physics, test tunneling, corners, floor/wall transitions, one-way platforms, moving platforms, collision order and recovery from invalid state. For Dash, preserve approved semantics and assert activation, duration, interruption, collision response, cooldown and input responsiveness.

Every fixed bug receives a regression test that fails before the fix where practical. Avoid arbitrary sleeps and flaky wall-clock assertions. Record seed, input trace, runtime version and expected state. Unit tests do not replace human playtesting.
