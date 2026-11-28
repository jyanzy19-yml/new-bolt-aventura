# Skill: HTML5 Game QA and Regression

## Activation
Use for test strategy, regression, release gates, bug triage and evidence.

## Test layers
- Pure unit tests: physics helpers, state transitions, parsers, save validation and deterministic rules.
- Integration tests: subsystem contracts, scene transitions, combat, checkpoints and progression.
- Browser tests: boot, UI, canvas sizing, input, lifecycle, audio and loading.
- Build checks: lint/type/static checks where configured, production build and asset validation.
- Manual device QA: touch, multitouch, safe areas, WebView, lifecycle, thermal/performance and visual inspection.

## Critical coverage
Test fixed-step behavior, pause/resume, collision edge cases, jump buffering, Dash, pointer cancellation, simultaneous controls, low-FPS input, asset failure, loading interruption, audio unlock, save corruption/migration, checkpoint recovery, campaign flags, softlocks and repeated world transitions.

## Evidence levels
- PLANNED: requirement or test case exists.
- IMPLEMENTED: code exists and is inspected.
- TESTED: named automated/manual checks ran and passed.
- VERIFIED: representative runtime evidence exists for the target environment/device.
Never promote one level to another without evidence.

## Reporting
Record commit, environment, exact commands, pass/fail/skip, logs/artifacts, device/runtime conditions, known limitations and severity. Add regression coverage for confirmed defects. Automated success is not physical-device verification.
