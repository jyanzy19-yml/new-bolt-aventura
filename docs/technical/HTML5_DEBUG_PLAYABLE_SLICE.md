# W1-L1 Debug Playable Slice — HTML5 integration

**Status:** integration prototype; not a production level and not final gameplay balance.  
**Entry point:** `src/main.js`.  
**Logical resolution:** 800 × 450 (16:9).  
**Rendering:** Canvas 2D with a diagnostic geometry renderer.

## Integrated systems

- FixedStepLoop: fixed 60 Hz simulation, bounded catch-up and render interpolation.
- CanvasSurface/Viewport: logical 800×450 drawing, aspect-preserving scaling and DPR cap.
- InputManager/ActionBuffer: keyboard and Pointer Events with independent pointer ownership.
- TouchControls: movement, jump and Dash buttons for coarse-pointer devices.
- LevelRuntime: validates and immutably loads the level fixture.
- LevelCollisionAdapter/CollisionWorld: static AABB solids and one-way platforms.
- PlayerMotor: horizontal acceleration, gravity, double jump, variable jump, jump buffer, coyote time and Dash.
- Camera2D: dead-zone follow, look-ahead and world-bound clamping.
- PlayerSceneRuntime: consumes input once per simulation tick, updates player/camera and interpolates render snapshots.
- DebugCanvasRenderer: draws solids, one-way platforms, checkpoints, exit and player body.

## Controls

| Input | Action |
|---|---|
| A / Left Arrow | Move left |
| D / Right Arrow | Move right |
| Space / W / Z | Jump |
| Left/Right Shift | Dash |
| Touch left/right | Move |
| Touch PULAR | Jump |
| Touch DASH | Dash |

Keyboard mappings and all movement tuning in this slice are temporary debug fixtures. Do not treat them as final control policy or balance.

## W1-L1 fixture

`src/levels/fixtures/w1-l1-debug.js` uses the canonical W1-L1 identifier/title for integration testing but marks the content `DEBUG_PLACEHOLDER` and `productionApproved: false`. Its geometry is a simple test course, not the approved phase package. It must be replaced by the reviewed W1-L1 content deliverable before production.

## Explicit exclusions

- No final character/world art, sprite animation, VFX or approved audio.
- No combat, weapon catalogue, enemies, hazards or boss.
- No pause/title/options/results flow or save persistence.
- No real asset loading overlay or asynchronous asset decoding.
- No native Capacitor host, immersive system-bar implementation or Android APK.
- No browser gameplay QA, WebView test, physical Android test, performance/thermal/memory measurement or FPS guarantee.

## Integration review policy

This branch consolidates source snapshots from the component PRs #145–#158 to validate their composition. Do not merge this aggregate PR together with all component PRs: choose one integration strategy. If the aggregate is merged, component PRs become superseded; if component PRs are merged individually, close this aggregate as superseded and rebase the next integration increment on the resulting main.
