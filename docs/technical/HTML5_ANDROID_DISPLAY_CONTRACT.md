# HTML5 Android display and immersive-mode contract

**Authority:** approved product policy in ADR-0003; implementation mapping in ADR-0005.  
**Stack:** HTML5/CSS3/ES Modules/Vite hosted in Android WebView; Capacitor is a candidate and is not yet integrated.

## 1. Product invariants

- Official orientation is landscape.
- Android status and navigation bars are hidden by immersive policy throughout the game, not only in an optional fullscreen mode.
- The game's fullscreen option remains OFF. Do not add a toggle or activate it automatically.
- OS gestures, accessibility and security surfaces may reveal system bars temporarily. Do not promise absolute suppression.
- Gameplay, physics, camera and input semantics must not change when immersive presentation is entered or restored.

## 2. Responsibility split

| Layer | Responsibility |
|---|---|
| Android host / future Capacitor bridge | Landscape activity configuration; immersive system-bar visibility; transient-by-swipe policy; re-apply after resume |
| HTML document | `viewport-fit=cover`; viewport metadata |
| CSS | Safe-area-aware layout using `env(safe-area-inset-*)`; responsive logical viewport; controls outside gesture insets |
| Input lifecycle | Clear held actions and pointer ownership on pause, blur, visibility loss and scene transition |
| QA | Verify bars, cutouts, gestures, focus and controls on physical Android devices |

## 3. Safe-area policy

- Treat system insets as dynamic values; do not hardcode one device's status/navigation bar dimensions.
- Background and non-interactive world art may extend to the display edges.
- Jump, Dash, fire, pause and other essential controls must remain within safe interactive regions and outside system gesture edges.
- Recalculate layout after viewport/inset changes without mutating logical world dimensions or physics.
- Preserve 16:9 logical gameplay viewport and letterbox/extend presentation rather than stretching the world.

## 4. Lifecycle

On pause, blur or visibility loss:
1. Stop or suspend the simulation loop.
2. Clear ActionBuffer sources and pending edges.
3. Release pointer captures and reset touch-control visual state.
4. Persist only at approved discrete save points; never serialize each frame.

On resume:
1. Re-evaluate viewport and safe-area dimensions.
2. Re-apply native immersive presentation where platform policy permits.
3. Re-enable input only after the game scene is ready.
4. Require fresh pointer/key events; never restore previously held actions.

## 5. Validation matrix

- Android versions supported by the eventual release target.
- Gesture navigation and three-button navigation.
- Cutout/notch and camera-hole displays.
- Common and elongated landscape aspect ratios.
- App launch, resume, notification interruption, app switch, screen lock/unlock and return.
- Touch controls near but not inside system gesture regions.
- Browser and WebView behavior are separate test environments.

## 6. Evidence gate

Do not mark VERIFIED until:
- Native host configuration is present in the repository.
- Immersive behavior is observed on physical Android devices.
- Temporary OS bar reveal and subsequent restoration are verified.
- Safe-area controls remain reachable.
- Pause/resume does not leave input stuck or trigger phantom actions.

A Vite build or desktop browser screenshot cannot satisfy this gate.
