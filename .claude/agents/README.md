---
name: agent-catalog
description: Catalog of read-only specialist review agents for BOLT AVENTURA.
tools: Read, Grep, Glob
---

# BOLT · AVENTURA — Agent Catalog

These are focused **read-only review agents**. They inspect assigned diffs and report findings; they do not implement fixes or override user decisions.

| Agent | Review focus |
|---|---|
| `architecture-reviewer` | Module boundaries, dependency direction, lifecycle and maintainability |
| `gameplay-reviewer` | Physics, movement, combat, Dash and state transitions |
| `mobile-performance-reviewer` | Android WebView, memory, frame pacing, input and lifecycle |
| `qa-reviewer` | Acceptance criteria, regression coverage and evidence quality |
| `narrative-continuity-reviewer` | Canon, character/world continuity and campaign sequence |

The primary writer remains ChatGPT or Claude Code as assigned in `docs/production/COLLABORATION_STATE.md`. Reviewers must not edit overlapping paths during active implementation.
