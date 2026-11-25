---
description: Review BOLT Android readiness, touch controls, system bars, export configuration and performance evidence.
---

Perform an Android-focused review of BOLT.

1. Read CLAUDE.md and docs/technical/01-android-performance.md, 02-touch-and-display.md, 04-android-build-checklist.md and docs/production/android-release-checklist.md.
2. Inspect the real project. Identify Godot version, renderer, orientation, Android preset, SDK/JDK assumptions and input configuration only when evidenced by files.
3. Review touch/multitouch, jump/dash reliability, focus interruption, pause/resume, safe areas, display cutouts and system-bar behavior.
4. Review performance evidence: frame-time distribution, CPU/GPU, memory, loading and thermal session. Flag missing measurements.
5. Distinguish code/configuration inspection from emulator and physical-device validation.
6. Return a severity-ranked report and the next verification steps.

Do not change export/signing secrets, publish builds or claim compatibility/performance without device evidence. Keep the target as packaged Android, not browser.
