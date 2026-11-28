# HTML5 Clean-Start Execution Plan

## Mandate
Create BOLT · AVENTURA from zero as an HTML5 game. This is not a Godot migration. Preserve approved canon, product requirements, mechanics and mobile experience while replacing engine-specific implementation guidance with browser/web-runtime architecture.

## Phase A — Repository inventory and governance
1. Obtain a complete recursive Git tree for the current integration branch.
2. Classify every path: KEEP (canon/prompt), ADAPT (engine-neutral design), REWRITE (technical docs/workflows), REMOVE (Godot-only implementation), or REVIEW (unclear ownership/value).
3. Identify all existing skills, agents, commands, workflows, docs, assets, code, tests and generated files.
4. Preserve Git history; do not bulk-delete based on filename assumptions.
5. Reconcile root instructions and agent collaboration state.

**Gate A:** no destructive cleanup until the full tree is available and reviewed.

## Phase B — Product and technical specification
1. Reconcile narrative/gameplay/world/UI bibles with the master directive.
2. Define HTML5 runtime contracts and module ownership.
3. Define viewport, landscape, safe-area and system-bar behavior with the Android packaging candidate.
4. Define fixed-step simulation, render loop, input event buffering and multitouch contracts.
5. Define asset manifest, loading, audio, save schema and campaign progression.
6. Define QA matrix and performance budgets for target Android hardware.

**Gate B:** no large-scale implementation while material contracts remain unresolved.

## Phase C — Web project bootstrap
Create a reproducible Vite project with HTML/CSS/ES Modules, lint/test/build scripts and lockfile. Establish the minimal boot path, error reporting, lifecycle and test harness. Avoid scaffolding without executable consumers.

**Gate C:** clean install, tests and production web build pass from a clean checkout.

## Phase D — Vertical slice
Implement a complete minimal player experience: boot/menu → input → movement/jump/Dash → collision/platforms → camera/render → enemy/combat → checkpoint/save → loading/transition → result/resume. Use placeholder assets only where the asset approval pipeline permits.

**Gate D:** reproducible browser tests and documented manual playtest; no critical control, softlock or save defects.

## Phase E — Content production
Scale reusable systems into seven distinct worlds and 42 planned phases. Produce enemy archetypes, bosses, NPCs, secrets, narrative events, audio and visual content with stable IDs and traceability. Blockouts remain blockouts until art, balance and QA gates pass.

**Gate E:** phase-by-phase acceptance evidence and campaign progression integrity.

## Phase F — Android packaging and hardening
Validate WebView compatibility; adopt Capacitor only if it satisfies packaging/lifecycle/system-bar requirements. Test landscape, safe areas, status/navigation bars, multitouch, background/foreground, audio, offline assets, memory, thermal behavior and long sessions on physical devices.

**Gate F:** distinguish web build, debug APK/AAB generation, install verification and release readiness. Never claim device validation without evidence.

## Current state
Governance and agent instructions have been updated. The complete repository tree has not yet been inventoried. The HTML5 runtime bootstrap and game implementation are not asserted as complete by this document.
