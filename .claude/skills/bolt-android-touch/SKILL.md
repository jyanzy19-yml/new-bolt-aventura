---
name: bolt-android-touch
description: Designs, implements or audits Android-first touch input for BOLT, including multitouch, action buffering, jump/dash reliability, lifecycle interruptions, safe areas and system UI. Use for mobile controls or Android input bugs.
---

# BOLT Android Touch Systems

## Mission
Protect the responsiveness and reliability of essential player actions on packaged Android devices.

## Mandatory discovery
1. Inspect the actual Godot project and detect its exact version.
2. Read input actions, player controller, touch UI scenes, pause flow and Android display settings.
3. Reproduce the issue and record device/build/frame conditions where available.
4. Read docs/technical/02-touch-and-display.md and docs/game-design/04-gameplay-systems.md.

## Design requirements
- Separate logical actions from touch-widget presentation.
- Support simultaneous touch points; never assume one finger at a time.
- Track pointer identity so one finger releasing does not cancel another finger's action.
- Handle press, release, drag-out, focus loss, pause, scene change and app resume.
- Evaluate input buffering for essential actions so brief frame stalls do not silently discard a valid press.
- Define precedence for simultaneous actions and avoid stuck input states.
- Keep UI hit targets reachable and visually legible on the approved orientation/aspect ratios.
- Keep essential controls outside unsafe cutout/system-gesture regions.
- Distinguish a visual button state from the gameplay action state.

## Required test cases
Movement + jump; movement + dash; jump + dash; three-finger combination if layout supports it; rapid tap; held press; finger leaves button; finger releases out of order; pause while held; scene transition while held; app background/foreground; temporary frame-time spike.

## Acceptance
No essential action remains stuck, disappears due to another finger release, or becomes unusable during normal multitouch. Do not claim real-device validation without device evidence.

## Boundaries
Do not invent touch latency numbers or promise universal Android system-bar behavior. Treat OS/version/device differences as test variables.
