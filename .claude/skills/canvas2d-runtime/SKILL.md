---
name: canvas2d-runtime
description: "Implement and validate the Canvas 2D renderer, camera, frame loop, sizing, visibility and runtime lifecycle."
---

# Skill: Canvas 2D Runtime

## Activation
Use for rendering, camera, canvas sizing, frame loop, performance, resize, visibility and lifecycle.

## Runtime contract
- Separate simulation state from rendering. Rendering must not mutate authoritative gameplay state.
- Prefer a fixed simulation timestep with an accumulator; cap catch-up work to prevent a spiral of death.
- Use monotonic timestamps, clamp pathological deltas and define pause/resume semantics.
- Interpolate presentation only where it does not alter collision/gameplay truth.
- Keep world units independent of CSS pixels and backing-store pixels.
- Handle devicePixelRatio deliberately; bound it by measured memory and GPU budgets.
- Recompute viewport/camera transforms on resize, orientation and display-mode changes.
- Define layer ordering, camera bounds, culling and coordinate conversion explicitly.

## Performance discipline
Avoid per-frame object/array creation, repeated style changes, redundant path construction, oversized offscreen surfaces, expensive filters and unnecessary full-canvas clears where profiling supports alternatives. Pool only when measurement proves benefit and lifecycle is safe. Release references and offscreen buffers on world disposal.

## Lifecycle
Handle visibilitychange, pagehide/pageshow, focus loss, orientation changes and Android WebView resume. Never let elapsed background time produce giant physics steps or unintended movement.

## Instrumentation and QA
Measure update/render/frame time, p50/p95/p99, dropped frames, draw calls, visible entity count, backing-store dimensions and estimated canvas memory. Test multiple aspect ratios, DPR levels, resize, long sessions, background/resume and large scenes.
