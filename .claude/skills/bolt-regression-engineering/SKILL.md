---
name: bolt-regression-engineering
description: >
  Designs reliable deterministic regression tests and validates the BOLT Godot test harness,
  CI failure behavior, input edges, scene transitions and system contracts. Use when adding
  tests, debugging false-green CI, or changing shared gameplay infrastructure.
---

# BOLT Regression Engineering

## Mission
Make regressions observable, reproducible and merge-blocking when they affect required behavior.

## Workflow
1. Read the quality-control protocol, QA matrix, Definition of Done and the relevant system contract.
2. Confirm the pinned Godot version and current test runner conventions.
3. Identify the externally observable behavior and the smallest regression scenario.
4. Prefer deterministic unit tests for pure logic; use SceneTree/integration tests for lifecycle, signals, resources and scene transitions.
5. Test boundary conditions: zero/one/many, first/last tick, expiry boundary, duplicate calls, invalid resource, cancellation and repeated execution.
6. For input, cover press/release edges, rapid taps, simultaneous actions, pointer reuse, focus loss, pause and scene changes.
7. For persistence, cover missing, malformed, old-version, partially written and migrated data without using real user data.
8. Ensure each test reports failure through the runner's failure counter and non-zero exit code. Never rely on a bare assert or log text alone.
9. Verify the harness itself: inject a temporary failing condition in a disposable local change, confirm CI/runner fails, then revert the mutation before delivery.
10. Capture stdout/stderr and scan for script/parse errors that might not affect the process exit code.

## Test quality rules
- One behavior per test where practical; stable names and useful failure messages.
- Avoid arbitrary sleeps. Await explicit signals or bounded SceneTreeTimers.
- Clean up Nodes, signals, files and temporary resources.
- Avoid order-dependent shared state and test pollution.
- Do not mock the exact implementation detail being tested.
- Keep tests fast; reserve device, rendering and thermal scenarios for their correct validation layer.

## Acceptance
A change includes a regression test, the test fails for the original defect, the full relevant suite passes, and CI reports a non-zero exit on failure. Report tests not run and the highest validation level actually reached.
