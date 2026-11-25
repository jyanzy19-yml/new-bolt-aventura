---
name: bolt-mobile-ui
description: Designs and audits BOLT's Android game HUD, menus, touch layout, safe areas, system bars, readability and accessibility.
---

# BOLT Mobile UI/UX

## Mission
Deliver a coherent game interface optimized for touch and phone readability without sacrificing gameplay visibility.

## Workflow
Inspect the current scenes, approved art direction, orientation, resolution policy, safe-area handling and input map. Read docs/game-design/06-ui-ux.md and docs/technical/02-touch-and-display.md.

## Interface requirements
- Define navigation hierarchy and back/cancel behavior.
- Establish consistent spacing, typography, icon language and feedback states.
- Keep HUD focused on information needed now.
- Make touch targets comfortably reachable and avoid overlap with movement space.
- Provide pressed, disabled, focused and unavailable states.
- Preserve readability across supported aspect ratios and display cutouts.
- Separate decorative full-bleed backgrounds from interactive safe-area content.
- Consider captions, text scaling, contrast, volume controls and reduced motion.
- Maintain visual and behavioral consistency between normal gameplay, pause and immersive display modes.

## System UI
Do not promise that every Android version permits identical drawing under status/navigation bars. Verify actual window flags, safe areas and gesture regions on target devices. Essential buttons must not be placed in system-reserved regions.

## QA
Test all menus, focus order, back behavior, multitouch, landscape/portrait only as approved, narrow/wide ratios, cutouts, system bars, font scaling, localization expansion and app interruption.

## Acceptance
All essential actions are discoverable and reachable, text is readable, no key information is obscured, and system UI behavior matches the documented decision.
