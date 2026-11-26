---
name: bolt-android-release-readiness
description: >
  Audits and prepares BOLT Android export, package metadata, permissions, signing workflow,
  artifact integrity and install validation. Use for APK/AAB builds, release candidates or
  Android deployment failures.
---

# BOLT Android Release Readiness

## Mission
Produce a traceable Android artifact without exposing credentials or overstating device validation.

## Required discovery
1. Read Android build specifications, release checklist, QA matrix, ADRs and current stage status.
2. Detect the exact Godot version, renderer, export preset, Android SDK/build-tools and export templates.
3. Inspect package identifier, version code/name, orientation, permissions, minimum/target SDK and architecture settings.
4. Confirm whether the requested artifact is a debug/test build or a release build.

## Workflow
1. Validate project import and headless tests before export.
2. Check that the export preset is intentional and contains no embedded secret or local absolute path.
3. Verify signing configuration without printing, reading into logs, committing or transmitting private keys/passwords.
4. Export to a clean, ignored output directory and record artifact name, size, SHA-256, commit and tool versions.
5. Inspect the package metadata and permissions; justify every permission.
6. Install and launch on an identified Android device when available. Record model, SoC, RAM, Android version, orientation and result.
7. Smoke-test cold start, menu, primary gameplay, touch/multitouch, pause/resume, app background/foreground and exit.
8. Separate export success, install success, launch success and gameplay/device validation; they are different claims.
9. Record blockers such as missing SDK, export templates, signing material or device access. Continue all independent checks.

## Security and integrity
- Never request or expose signing passwords, keystore contents, tokens or personal data.
- Never commit keystores, signing files, generated secrets or release credentials.
- Keep debug and release configurations distinct.
- Do not change package identity, signing identity, permissions or minimum Android version without an approved decision.
- Preserve artifact hashes and provenance for every candidate.

## Acceptance
A release report identifies commit, Godot/export versions, preset, artifact hash, package metadata, permissions, tests, install/device evidence and remaining risks. No APK or Android compatibility claim without the corresponding artifact/evidence.
