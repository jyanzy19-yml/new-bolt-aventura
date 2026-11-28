# Skill: Collaborative Development — ChatGPT + Claude Code

## Purpose
Coordinate two authorized coding agents without overlapping edits, losing decisions or treating chat history as shared state.

## Before work
1. Read the master directive and shared agent contract.
2. Inspect branch, HEAD, status, recent commits, open PRs and collaboration state.
3. Confirm primary writer, reviewer, task ID, base commit, branch and allowed/forbidden paths.
4. Identify dependencies and any active ownership conflict.

## Execution
- One primary writer per task; reviewer is read-only until handoff is complete.
- Prefer `agent/claude/<task>` and `agent/chatgpt/<task>` branches.
- Split tasks by bounded files and subsystem contracts, not vague job titles.
- If the same file is needed by both agents, serialize the work and refresh from the latest commit.
- Do not force-push, rewrite history, self-merge or bypass review.
- Keep commits cohesive and task-scoped.
- A reviewer reports findings with severity, file/line, impact and remediation.
- The user decides sequencing and merge.

## Handoff
Record task ID, writer, reviewer, base/result commit, branch/PR, objective, exact paths, acceptance criteria, tests, validation level, risks and next owner. Update collaboration state and continuity after substantial work.

## Conflict handling
Stop on overlapping ownership, uncommitted changes, canon conflicts, architecture conflicts or incompatible assumptions. Do not resolve material product decisions silently. Preserve evidence and request user direction.

## Completion
A task is complete only when implementation, relevant tests, diff review, documentation/tracker updates and a usable handoff are done. Clearly mark anything not tested or not device-verified.
