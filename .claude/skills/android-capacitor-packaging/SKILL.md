---
name: android-capacitor-packaging
description: "Evaluate and implement the Android packaging shell with Capacitor, APK/AAB configuration, lifecycle, system bars and device validation."
---

# Skill: Android Packaging with Capacitor

## Activation
Use only when evaluating or implementing the native Android shell, APK/AAB, plugins, system bars and lifecycle.

## Gate
First prove the HTML5 runtime builds and runs correctly in a supported browser. Treat Capacitor as the current packaging candidate, not a completed commitment; validate compatibility and native requirements before adopting it.

## Configuration
Pin Capacitor and plugin versions. Keep native plugins minimal. Define application ID, versioning, landscape orientation, splash/icon, local asset strategy, permissions, status/navigation bar policy, safe areas, keyboard behavior, back navigation, lifecycle and offline operation.

## Build and security
Make web build output deterministic and ensure native shell packages the exact intended artifact. Never commit signing keys, passwords, tokens or private keystores. Distinguish debug APK, signed release APK, AAB and store publication. Document reproducible setup without exposing secrets.

## Device validation
Test install/upgrade/uninstall, cold start, offline launch, background/foreground, interruptions, audio unlock, touch/multitouch, orientation, safe areas/system bars, memory, thermal behavior and long sessions on identified physical devices. Never claim a successful install or device test without evidence.
