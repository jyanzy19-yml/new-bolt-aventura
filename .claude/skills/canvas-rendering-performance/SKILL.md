---
name: canvas-rendering-performance
description: "Optimize Canvas rendering cost, backing-store memory and frame-time stability."
---

# Skill: Canvas Rendering and Frame-Time Engineering

Keep rendering deterministic with respect to supplied simulation state. The renderer must not own gameplay state or advance physics.

Profile before changing draw architecture. Record frame-time distributions, scene complexity, DPR, backing-store dimensions and target device. Bound backing-store memory; account for width × height × bytes-per-pixel and avoid blindly matching high devicePixelRatio on low-memory phones.

Use stable draw ordering, culling, batching where beneficial, sprite atlases when justified and cached static layers only with explicit invalidation. Avoid per-frame object creation, repeated text measurement, layout reads, unnecessary save/restore, expensive filters and canvas resizing.

Define resize behavior, camera transform, world/screen coordinate conversion and interpolation contracts. Verify pixel alignment and touch/gameplay hitboxes independently of visual scaling. Benchmark changes against identical scenes and reject visual/physics regressions.
