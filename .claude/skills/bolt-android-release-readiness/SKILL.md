---
name: bolt-android-release-readiness
description: >
  Audits and prepares the BOLT HTML5 Android packaging path, Capacitor configuration,
  package metadata, permissions, signing safety, artifact integrity and device validation.
---

# BOLT Android Release Readiness

## Mission
Produce a traceable Android artifact without exposing credentials or overstating device validation.

## Required discovery
1. Read the HTML5 runtime contracts, Android release checklist, QA matrix, ADRs and current production status.
2. Confirm that the web runtime builds and passes its browser-level checks before evaluating a native shell.
3. Detect whether Capacitor is actually integrated; do not assume its presence or invent native configuration.
4. Inspect package identifier, versioning, orientation, permissions, minimum/target SDK and architecture settings only when the native project exists.
5. Confirm whether the requested artifact is a debug/test build or a release build.

## Workflow
1. Validate clean dependency installation, lint, tests and production web build.
2. Check that native packaging uses the exact intended web build output.
3. Verify signing configuration without printing, reading into logs, committing or transmitting private keys/passwords.
4. Export to a clean, ignored output directory and record artifact name, size, SHA-256, commit and tool versions.
5. Inspect package metadata and permissions; justify every permission.
6. Install and launch on an identified Android device when available. Record model, SoC, RAM, Android version, WebView version and result.
7. Smoke-test cold start, menu, gameplay, touch/multitouch, pause/resume, background/foreground and exit.
8. Separate web build success, native package success, install success, launch success and physical-device validation.
9. Record blockers such as missing SDK, native shell, signing material or device access. Continue all independent checks.

## Security and integrity
- Never request or expose signing passwords, keystore contents, tokens or personal data.
- Never commit keystores, signing files, generated secrets or release credentials.
- Keep debug and release configurations distinct.
- Do not change package identity, signing identity, permissions or minimum Android version without an approved decision.
- Preserve artifact hashes and provenance for every candidate.

## Acceptance
A release report identifies commit, web/native tool versions, packaging configuration, artifact hash, package metadata, permissions, tests, install/device evidence and remaining risks. No APK or Android compatibility claim without the corresponding artifact/evidence.
