# Skill: HTML5 Game Architecture

## Activation
Use for system design, project bootstrap, module boundaries, dependency changes, Vite/tooling, lifecycle and cross-system integration.

## Authority
Read `MASTER_DIRECTIVE.md`, `AGENTS.md`, the active task handoff and relevant ADRs. The game is a clean-start HTML5 implementation, not a Godot port.

## Target architecture
Use HTML5/CSS3, JavaScript ES Modules, Canvas 2D and Vite. Keep platform APIs behind narrow adapters. Candidate domains include:
- app/bootstrap and lifecycle;
- core clock, eventing, configuration and diagnostics;
- runtime/game loop and scene/state orchestration;
- gameplay domain, entities, combat, physics and collision;
- input abstraction and touch controls;
- rendering, camera, layers and effects;
- level/world data and content registries;
- UI/HUD/dialogue;
- audio and asset pipeline;
- persistence/checkpoints/progression;
- platform/Android integration;
- tests, scripts and build tooling.

## Rules
1. Define ownership and public contracts before splitting modules.
2. Keep dependency direction acyclic; domain logic must not depend on DOM or Canvas.
3. Prefer composition and data-driven definitions over inheritance webs.
4. Avoid both monoliths and micro-module fragmentation.
5. Give every long-lived subsystem explicit init/start/pause/resume/dispose semantics.
6. Avoid ambient mutable globals; inject dependencies at composition roots.
7. Keep runtime content IDs stable and data schema versioned.
8. Pin dependencies, justify each runtime dependency and check license/security posture.
9. Keep browser-specific behavior behind adapters when it improves testability.
10. Record material architectural decisions as ADRs with alternatives and consequences.

## Deliverables
Provide module map, dependency graph, contracts, migration/rollout sequence if relevant, test plan, risks and exact changed paths. Do not create architecture-only scaffolding without an executable consumer or test.
