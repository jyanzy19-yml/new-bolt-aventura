---
name: asset-provenance-qa
description: "Validate asset provenance, licensing, approvals and manifest integrity."
---

# Skill: Asset Provenance and Integration QA

Every asset must have stable ID, source/creator, license/permission, dimensions or duration, file format, intended use, approval status and fallback. Treat external assets as untrusted and never assume a web image is licensed for redistribution.

Track states separately: REQUESTED, PROPOSED, APPROVED, INTEGRATED, VERIFIED and REJECTED. Approval applies only to the exact delivered version; edits after approval require renewed approval.

Check naming, duplicate IDs, missing references, path case-sensitivity, texture dimensions, alpha, color profile, audio sample rate, loop points, decode cost and memory footprint. Validate all manifest references before build.

Do not replace approved art, alter character silhouettes or reinterpret canon without user approval. Placeholders must be visibly labeled and excluded from final-content claims.
