# DebugCanvasRenderer

**Status:** development-only diagnostic renderer. It is not final art and must not be represented as approved BOLT character or world presentation.

## Responsibility

- Draw static solid geometry, one-way platforms, checkpoints, exits and the player AABB.
- Consume logical world coordinates and a camera world offset.
- Use an existing CanvasSurface-compatible object for clearing and a Canvas 2D context.
- Restore context state even if a draw operation throws.
- Return primitive draw counts for diagnostics.

## Non-goals

No sprite atlas, animation, particles, lighting, parallax, audio, HUD, accessibility presentation or final art integration. Replace/extend this renderer only after the approved asset pipeline and visual direction are ready. Do not let diagnostic colors leak into the final art palette.
