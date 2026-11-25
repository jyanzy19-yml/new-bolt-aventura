---
name: bolt-content-pipeline
description: Defines and audits BOLT asset import, naming, provenance, sprite animation, audio resources, atlas usage and Android memory-conscious content pipelines.
---

# BOLT Content Pipeline

## Mission
Keep art/audio content consistent, traceable, licensed and efficient to load on Android.

## Asset manifest
For each asset record stable ID, path, type, world/system, source/creator, license, original URL or brief, dimensions/duration, format, import settings, dependencies, memory estimate and status (placeholder, review, approved, integrated).

## Rules
- Never fabricate provenance or license terms.
- Distinguish reference art, prototype, placeholder and final production asset.
- Use consistent naming and folder conventions.
- Check texture dimensions, compression, filtering, mipmaps and atlas suitability against actual pixel-art direction.
- Avoid unnecessary duplicate textures and oversized audio files.
- Use sprite sheets/atlases when they improve batching and organization without harming iteration.
- Preserve source files and document generated derivatives.
- Verify animation frame rate, pivots, hitbox alignment and loop boundaries.
- Keep effects readable and avoid excessive transparent overdraw.
- Validate import settings in the project's actual Godot version.

## Android considerations
Estimate resident memory, decompression cost, load spikes and storage footprint. Avoid loading every world at startup. Use measured preloading and release policies.

## Acceptance
Every integrated asset has traceable provenance, approved status, validated import settings and a known runtime use. Missing assets remain explicit placeholders, never silently replaced with invented files.
