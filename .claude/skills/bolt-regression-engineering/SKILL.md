---
name: bolt-regression-engineering
description: >
  Designs deterministic regression tests for the BOLT HTML5 runtime, Canvas simulation,
  input edges, lifecycle, persistence and CI failure behavior.
---

# BOLT Regression Engineering

## Mission
Make regressions observable, reproducible and merge-blocking when they affect required behavior.

## Workflow
1. Read the quality-control protocol, HTML5 test strategy, Definition of Done and relevant runtime contract.
2. Identify externally observable behavior and the smallest deterministic regression scenario.
3. Prefer unit tests for pure JavaScript logic; use integration/browser tests for DOM, Canvas, input, lifecycle, audio and persistence contracts.
4. Inject clocks and randomness where needed. Avoid hidden global state and arbitrary sleeps.
5. Test boundary conditions: zero/large delta, first/last tick, expiry boundary, duplicate calls, invalid resource, cancellation and repeated execution.
6. For input, cover press/release edges, rapid taps, simultaneous actions, pointer reuse, pointercancel, focus loss, pause and scene changes.
7. For persistence, cover missing, malformed, old-version, partially written and migrated data without using real user data.
8. Ensure each test fails through the runner's exit code; never rely on log text alone.
9. Verify the harness itself with a disposable failing test, confirm CI fails, then revert the mutation before delivery.
10. Capture stdout/stderr and distinguish unit/integration/browser checks from physical-device QA.

## Test quality rules
- One behavior per test where practical; stable names and useful failure messages.
- Avoid arbitrary sleeps. Await explicit events or bounded conditions.
- Clean up listeners, timers, DOM nodes, storage fixtures and temporary resources.
- Avoid order-dependent shared state and test pollution.
- Do not mock the exact implementation detail being tested.
- Keep tests fast; reserve WebView, thermal and device scenarios for their correct validation layer.

## Acceptance
A change includes a regression test that fails for the original defect where practical, the relevant suite passes, and CI reports a non-zero exit on failure. Report tests not run and the highest validation level actually reached.
