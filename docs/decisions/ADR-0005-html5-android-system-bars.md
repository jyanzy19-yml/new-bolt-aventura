# ADR-0005 — Implementação HTML5 da política imersiva Android

- **Status:** Proposed implementation mapping; product policy inherited from approved ADR-0003
- **Date:** 2026-11-28
- **Scope:** HTML5/Vite application hosted in Android WebView/Capacitor
- **Does not supersede:** `ADR-0003-android-system-bars.md`

## Context

The approved product decision requires the Android status and navigation bars to remain hidden during the game experience, including when the game's fullscreen option is disabled. The HTML5 rebuild uses a browser/WebView surface; CSS alone cannot control Android system bars.

## Decision mapping

1. Preserve the approved immersive policy; do not introduce a user-facing fullscreen toggle.
2. Implement system-bar control at the native Android host layer when Capacitor is integrated, using the platform-compatible WindowInsets APIs (AndroidX WindowInsetsControllerCompat or the current platform equivalent).
3. Use transient-by-swipe behavior where supported so the OS can temporarily reveal system bars for user gestures, then restore immersive presentation.
4. Lock the Android activity to landscape through the native app configuration; CSS orientation hints are not authoritative.
5. Keep `viewport-fit=cover` and use safe-area insets for interactive controls. The background/world may extend behind system cutouts; essential controls must remain outside system gesture regions.
6. Re-assert immersive presentation after app resume/focus restoration, but never fight OS security or accessibility behavior.
7. Do not claim the bars are permanently hidden on every device. Android version, OEM policy, gestures, and security surfaces can temporarily reveal them.

## Consequences

- A native Capacitor integration is required for the approved policy; a standalone browser page cannot guarantee it.
- The web layer owns safe-area-aware layout and input cancellation on lifecycle changes.
- Native integration must be tested separately from browser rendering.
- Any product-level change to the OFF fullscreen option or immersive policy requires explicit approval and an ADR amendment.
