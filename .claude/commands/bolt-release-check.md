---
description: Evaluate BOLT release readiness against the Android release checklist and evidence-based quality gates.
---

Perform a release-readiness audit; do not publish or sign a release.

1. Read MASTER_DIRECTIVE.md, docs/production/definition-of-done.md, docs/production/quality-control-protocol.md, docs/production/android-release-checklist.md, docs/qa/test-matrix.md and docs/production/implementation-tracker.md.
2. Inspect the exact commit, project.godot, Godot version, export presets, assets, permissions, package/application ID and build artifacts.
3. Verify campaign completeness against all 42 tracker entries and all global systems. Do not infer completion from documentation or file presence alone.
4. Review blocker/critical bugs, save migration/recovery, touch/multitouch, interruptions, safe areas, system bars, performance captures and long-session evidence.
5. Separate missing evidence from failed tests and from features not implemented.
6. Produce PASS / FAIL / BLOCKED for each release gate with exact evidence and unresolved risks.
7. Do not access signing secrets, create/publish releases, upload artifacts or change repository settings.

A release candidate is not a final release. Never claim Android compatibility, sustained 60 FPS or successful installation without device-specific evidence.
