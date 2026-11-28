---
name: browser-webview-compatibility
description: "Validate browser APIs and Android WebView compatibility."
---

# Skill: Browser and Android WebView Compatibility

Read the master directive and runtime contracts first. Treat browser support as a tested compatibility matrix, not an assumption based on desktop Chrome.

Define the minimum Android System WebView/Chromium version only after dependency/API analysis. Test feature detection and graceful fallbacks for Pointer Events, Canvas 2D, ResizeObserver, visibility/lifecycle, Web Audio, storage and fullscreen/display APIs. Avoid UA sniffing unless a documented platform defect requires it.

Validate viewport-fit, safe-area insets, landscape policy, CSS viewport units, cutouts, navigation/status bars and keyboard/system overlays in the actual Android shell. Browser fullscreen and native immersive mode are not equivalent.

Record device, Android version, WebView version, resolution, DPR, shell version, build commit and reproduction steps. Test background/foreground, low memory, interrupted audio, pointercancel, resize and process recreation. Never mark Android VERIFIED from desktop browser tests.
