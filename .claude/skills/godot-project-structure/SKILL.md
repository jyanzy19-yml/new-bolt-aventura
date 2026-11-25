---
name: godot-project-structure
description: >
  Plan, audit, and evolve the folder, scene, script, resource, and asset structure of a Godot 4
  project. Use when creating the initial project layout, deciding where files belong, splitting
  responsibilities, reviewing dependencies, or planning a safe reorganization. Do not use to
  perform a broad restructure without an explicit task and migration plan.
---

# Godot Project Structure — BOLT · AVENTURA

## Purpose

Keep the Godot project navigable, modular, and easy to validate without imposing unnecessary
abstractions. Organize around gameplay responsibilities and ownership, not arbitrary file counts.
The project is an Android 2D platform-adventure; do not introduce browser-specific architecture.

This skill is an original BOLT-oriented adaptation informed by the function-first organization
approach described by [grndctrl/godot-skills](https://github.com/grndctrl/godot-skills)
(`godot-project-organization`). It does not copy that repository's skill text or scripts.
Use Godot's official documentation and the actual BOLT architecture decisions as authority.

## Mandatory preflight

1. Inspect the repository and locate `project.godot`. If it does not exist, state that the
   runnable Godot project has not yet been created; do not pretend to audit a nonexistent tree.
2. Read the pinned Godot version from project metadata. Do not assume a minor release or use
   APIs newer than the project.
3. Read the approved architecture principles, system contracts, ADRs, and current production
   stage before proposing directories or moving files.
4. Inventory existing scenes, scripts, resources, autoloads, addons, assets, tests, and build
   tooling. Search references before moving or renaming any resource path.
5. Distinguish a proposed layout from a layout that actually exists.

## Structural principles

- **Group by responsibility and ownership.** A player entity, its scene, script, local data,
  and tightly coupled presentation assets should be discoverable together when that improves
  iteration. Shared systems belong in explicit shared locations.
- **Keep dependencies directional.** Low-level reusable utilities must not depend on high-level
  game screens or specific levels. UI may observe gameplay state through defined interfaces;
  gameplay rules must not reach into arbitrary UI node paths.
- **Separate reusable content from authored instances.** Reusable enemy/player/prop scenes and
  data resources should not be confused with the unique composition of a particular stage.
- **Avoid both extremes.** Do not create a monolithic script or a single catch-all folder; do not
  create a folder, manager, autoload, base class, or abstraction for every tiny concept.
- **Keep assets near their owner when they are exclusive.** Truly global fonts, shared UI
  elements, common audio buses, and cross-world resources may live in shared asset locations.
  Stage-specific tiles, backgrounds, music, and props should remain traceable to their world.
- **Keep third-party addons isolated.** Do not mix imported plugin code with original BOLT
  gameplay code. Record addon provenance and license before inclusion.
- **Use stable resource paths.** Before renaming or moving a scene, script, resource, or asset,
  search `preload()`, `load()`, exported resource properties, scene references, project
  settings, tests, and documentation for path dependencies.
- **Do not make folder layout a substitute for architecture.** A clean tree does not prove
  correct runtime ownership, decoupling, lifecycle, or performance.

## Suggested functional boundaries

These are candidate boundaries, not mandatory directories. Reconcile them with approved ADRs
and the first real project before creating folders.

| Domain | Owns | Must not own |
|---|---|---|
| Core / application flow | Boot, scene transitions, global lifecycle and service composition | Level-specific rules or screen presentation details |
| Player | Player scene, movement state, abilities, animation integration and player-local data | Global progression persistence or menu navigation |
| Enemies / bosses | Enemy scenes, behavior state, attacks, damage rules and encounter hooks | Direct references to arbitrary HUD nodes |
| World / stages | Stage composition, checkpoints, hazards, tile data and local progression triggers | Global save-file implementation |
| Gameplay systems | Combat rules, pickups, objectives, damage, progression contracts | Rendering-only effects and menu layout |
| UI | HUD, menus, pause, settings, inventory and accessibility presentation | Authoritative gameplay state |
| Data / resources | Typed configuration, balance data, definitions and versioned content | Hidden runtime side effects during resource loading |
| Audio / presentation | Audio routing, animation/VFX coordination, camera feedback | Authoritative game rules |
| Shared utilities | Small, genuinely reusable helpers with narrow dependencies | Game-specific logic disguised as generic helpers |
| Tests / tools | Automated checks, fixtures, diagnostics and editor tooling | Shipping runtime dependencies unless explicitly required |

## File placement decision procedure

For each new file, ask in order:

1. Is it third-party code? Keep it under the addon boundary and record its source/license.
2. Is it a project-wide service or application entry point? Place it with core/application ownership.
3. Is it part of one gameplay entity? Keep its scene, script, local data, and exclusive assets together.
4. Is it a unique authored stage or world composition? Keep it with that stage/world.
5. Is it a reusable gameplay rule? Place it under the owning gameplay system, not under a random entity.
6. Is it presentation-only? Keep it in the UI/audio/presentation domain.
7. Is it shared data? Use a Resource/data location with explicit ownership and schema.
8. Is it a test or editor helper? Keep it outside shipping runtime content.
9. If no category fits, first reconsider whether the file or abstraction is necessary. Add a new top-level domain only when it represents a stable responsibility.

## Safe reorganization workflow

A structural change is a migration, not a cosmetic cleanup.

1. Write a short before/after map and explain the responsibility boundary being improved.
2. List every affected path and known reference.
3. Define a small migration batch; avoid simultaneous gameplay redesign.
4. Move one coherent group at a time and update references atomically.
5. Run project import and script parse checks using the pinned Godot version.
6. Run the project and relevant scene/system tests; inspect logs for missing resources and script
   errors.
7. Verify scene instancing, autoload order, signals, resource UIDs/paths, exported properties,
   Android export configuration, and any CI path filters affected.
8. Compare behavior before and after. Revert or repair if behavior changes unintentionally.
9. Update architecture documentation and record an ADR when the change is consequential.

Never report a reorganization as validated based only on a directory listing or successful Git
commit.

## BOLT-specific constraints

- Android packaged application is the product target; desktop editor use is a development tool.
- Preserve landscape orientation, touch-first interaction, multitouch, safe-area/system-bar
  decisions, and the approved immersive-mode ADR.
- Keep the 42 planned phases and seven-world campaign data-driven where justified, but do not
  create 42 placeholder scene files merely to make the directory tree look complete.
- Do not create one global manager for every system. Define ownership and contracts before
  introducing autoloads.
- Keep loading/preloading decisions evidence-based; avoid loading every world or asset into
  memory at startup on low-memory Android devices.
- Respect the target of roughly 4 GB RAM / Helio G99-class or weaker hardware. Structure must
  support bounded resource lifetimes and unloading, not retain all stage resources globally.
- No `project.godot`, scene, script, or Android build may be claimed to exist until inspected.

## Completion report

Report the actual tree inspected, proposed or changed paths, dependency/reference checks, tests
executed, tests not executed, migration risks, and whether the work was planning-only or
implemented. State the exact Godot version used for validation, or say it is not yet known.
