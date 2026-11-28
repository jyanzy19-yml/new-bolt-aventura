# Skill: Android Web Runtime Performance

## Activation
Use for profiling, memory, WebView behavior, frame pacing, thermal effects and optimization.

## Target profile
Reference low/mid Android devices around 4 GB RAM and Helio G99-class or weaker. 60 FPS is a target when sustainable, not a universal guarantee.

## Measure first
Record device model, Android version, WebView/browser version, screen resolution, DPR, refresh rate, thermal/battery state, build commit, scene, test duration and background conditions. Measure frame-time average and p50/p95/p99, long tasks, input latency, memory/heap where available, image/audio decode, GC pauses and dropped frames.

## Budget and optimization
- Bound canvas backing-store dimensions and DPR; pixel cost grows quadratically with DPR.
- Reduce overdraw, large transparent surfaces, expensive compositing and unbounded particles.
- Cull offscreen entities and avoid work for inactive systems.
- Avoid layout thrashing, repeated parsing, synchronous storage and asset decode in hot paths.
- Schedule noncritical work outside gameplay-critical frames.
- Load/decode resources before use and release world-scoped memory on transitions.
- Use object pooling only for measured allocation hotspots; prevent stale references.
- Avoid unnecessary DOM overlays above Canvas.
- Validate WebView separately from mobile browser.

## Acceptance
Compare before/after under identical repeatable conditions. Do not trade control responsiveness, physics, visual identity or content for benchmark gains without approval. Report residual risks and thermal behavior.
