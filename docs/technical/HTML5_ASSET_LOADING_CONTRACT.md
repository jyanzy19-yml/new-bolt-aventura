# HTML5 AssetManifest and AssetLoader contract

**Authority:** `docs/production/ASSET_PIPELINE.md` and `docs/assets/ASSET_PIPELINE.md`.  
**Status:** generic data/loading infrastructure; no game assets are created or approved by this implementation.

## Manifest

Schema version 1 records stable ID, local URL, type, lifecycle state, load policy, required/optional status, license, provenance, optional size/dimensions/duration, world/phase consumer, dependencies and fallback. IDs are unique and references must resolve. URLs must be local paths without traversal or remote schemes.

Lifecycle states follow the project asset pipeline. Only APPROVED, INTEGRATED and VERIFIED assets may load by default. PLACEHOLDER is allowed only when the loader is explicitly constructed with `allowPlaceholders: true`. PLANNED, SPECIFIED, CONCEPT_CREATED, AWAITING_USER_APPROVAL, REVISION_REQUESTED and REJECTED are never loaded.

## Loader

- Browser-specific decoders are injected by asset type (image/audio/font/data).
- Preload policy loads only entries marked `preload`; lazy and stream entries remain untouched.
- Concurrency is bounded.
- Progress events reflect actual completion/failure only; no synthetic delay or fabricated percentage is used.
- Optional failures are returned in the report. Required failures raise `AssetLoadAggregateError` and newly loaded values from that batch are released.
- AbortSignal is forwarded to loaders and checked between tasks.
- Cache is keyed by stable ID and type/URL identity; `unload` and `clear` invoke configured releasers or `close()` when available.
- The coordinator does not implement fetch/decode adapters, image atlases, AudioContext lifecycle, streaming decode, dependency scheduling, retry UI or loading overlays.

## Asset approval boundary

The loader enforces the status field, but the manifest author remains responsible for recording accurate provenance and approval evidence. A placeholder must be visibly identified and must not silently become final art. No asset in this PR is an actual BOLT asset.

## Validation

Unit tests cover schema/provenance, approval gating, preload/lazy policy, concurrency, progress, cache reuse, release, optional/required failures and pre-aborted cancellation. Browser decoder behavior, memory measurements and Android physical-device loading remain separate verification gates.
