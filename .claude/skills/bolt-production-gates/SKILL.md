---
name: bolt-production-gates
description: Plans BOLT work into approval gates, implementation slices, review criteria, traceability, regression and evidence-based completion reports.
---

# BOLT Production Gates

## Mission
Keep work incremental, reviewable and aligned with user-approved scope.

## Before work
Read CLAUDE.md, docs/README.md, current stage status, relevant bible, architecture docs and Definition of Done. Inspect repository state and identify the real project stage.

## Plan
Break work into small coherent slices. Each slice states objective, files, dependencies, risks, tests, acceptance criteria and approvals required. Separate implementation from optional enhancements.

## Approval boundaries
Seek explicit approval before changing canon, scope, engine/version, architecture direction, platform target, release/signing, repository visibility or destructive data. A user request to implement a defined feature authorizes that feature, not unrelated changes.

## Evidence
For each task report files changed, tests run, exact outcomes, tests not run, known risks and next gate. Do not label a stage complete when mandatory evidence is missing.

## Review gates
- design/specification reviewed;
- implementation inspected;
- automated checks run;
- manual/device tests distinguished;
- regression risks addressed;
- documentation and status updated.

## Acceptance
Work is traceable to a user request and criteria; no approval is inferred; claims match evidence.
