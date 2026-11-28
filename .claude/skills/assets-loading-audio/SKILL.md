---
name: assets-loading-audio
description: "Design and validate asset manifests, loading, decoding, caching, transitions and Web Audio lifecycle."
---

# Skill: Asset Pipeline, Loading and Web Audio

## Activation
Use for art/audio manifests, resource loading, decoding, caching, transitions, music and SFX.

## Asset governance
Maintain stable asset IDs and a manifest with path, type, dimensions/duration, format, source/license/attribution, intended worlds, preload policy and estimated decoded memory. Validate missing paths, duplicate IDs, unsupported formats and orphaned references. Never silently replace approved art/audio.

## Loading
- Split critical boot assets from world-scoped and optional assets.
- Fetch/decode/prewarm resources before gameplay when needed.
- Report real progress from completed work; never add artificial delay to a loading screen.
- Handle failure, retry, cancellation and fallback states.
- Prevent gameplay input until required assets and systems are ready.
- Release references and decoded resources safely when leaving a world.
- Test cold start, warm start, slow storage, missing/corrupt assets and repeated transitions.

## Audio
Unlock/resume AudioContext from a valid user gesture. Define master/music/SFX buses, voice limits, priorities, concurrency, spatial/pan policy and cleanup. Suspend/resume correctly across pause/background. Avoid creating unbounded nodes or buffers. Respect mute and volume settings.

## Deliverables
Update manifest, loading contract, memory estimates, license records and tests. Distinguish placeholder from final approved assets.
