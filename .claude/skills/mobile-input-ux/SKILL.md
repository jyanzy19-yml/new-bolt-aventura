# Skill: Mobile Input and UX

## Activation
Use for touch controls, multitouch, on-screen HUD, display modes, safe areas, orientation and mobile interaction.

## Input invariants
- Use Pointer Events and track each active pointer by pointerId.
- Separate logical actions (jump, Dash, attack, aim, pause) from physical touch controls.
- Capture pointer ownership and handle pointerup, pointercancel and lostpointercapture.
- Clear held/edge states on pause, scene change, blur, visibility loss, pagehide and app suspension.
- Input sampling must not wait for the next render frame; preserve edge events across simulation ticks.
- Support simultaneous combinations explicitly (e.g. move + jump + Dash/attack where design permits).
- Never let one pointer release cancel another pointer's active action.
- Prevent browser gestures only on the intended game surface; do not globally disable expected system navigation.
- Avoid duplicate touch and synthesized mouse activation.

## Display and ergonomics
Use responsive layout and safe-area insets where relevant. Define landscape behavior, viewport scaling, touch target dimensions, spacing, visual pressed/disabled states, contrast and HUD occlusion. Treat normal and fullscreen/display-mode presentation consistently. Status/navigation bar behavior must be tested in the actual Android shell; do not assume CSS alone can control system bars.

## QA matrix
Test rapid taps, held buttons, pointer cancellation, two-to-four simultaneous pointers, orientation changes, resize, browser chrome changes, low FPS, app background/foreground, incoming interruptions and physical devices. Jump and Dash responsiveness during frame drops are release-critical.
