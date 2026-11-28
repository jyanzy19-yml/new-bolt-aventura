---
name: web-tooling-ci
description: "Maintain web tooling, CI, dependency hygiene and release gates."
---

# Skill: Web Tooling, CI and Repository Hygiene

Pin Node/package manager expectations and dependencies; commit the lockfile. Keep scripts deterministic and document environment variables without secrets. Validate clean install, tests and production build in CI.

Pipeline layers: formatting/lint/static checks where configured, unit/integration/browser tests, asset-manifest validation, production build and packaging checks. Cache safely; attach logs/artifacts with commit identity.

Review dependency provenance, license, maintenance and security. Minimize dependencies and permissions. Never commit tokens, signing keys or private keystores. Keep generated build output/caches/temp files out of version control unless intentional.

Do not delete legacy paths until the complete Git tree is inventoried and cleanup scope confirmed. Distinguish passing CI, web build, generated APK/AAB, installed app and physical-device verification.
