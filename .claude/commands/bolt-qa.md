---
description: Build a focused QA and regression plan for the current BOLT change or build.
---

Create a test plan for the current BOLT task/build.

1. Read docs/qa/test-matrix.md, docs/production/definition-of-done.md and relevant system specifications.
2. Inspect changed files and identify affected behavior and regression surfaces.
3. Prioritize crashes, softlocks, progress loss, essential touch input, scene transitions and broken campaign progression.
4. Separate automated tests, editor checks, emulator checks and physical Android device tests.
5. For each case, define setup, steps, expected result, evidence and severity if it fails.
6. Include relevant interruption, pause/resume, save/load, multitouch and low-performance cases.
7. Report tests that cannot be run in the current environment.

Do not state that tests passed unless you executed them and observed the result. Do not modify code during a QA-only task.
