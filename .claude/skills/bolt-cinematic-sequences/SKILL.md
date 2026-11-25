---
name: bolt-cinematic-sequences
description: Plans and audits BOLT's in-engine cutscenes, dialogue beats, camera staging, skip/replay behavior, narrative flags and Android performance.
---

# BOLT Cinematic Sequences

## Mission
Make cutscenes emotionally effective, technically robust and integrated with playable progression.

## Before implementation
Read the narrative bible and approved scene outline. Treat unapproved plot, dialogue, character behavior and revelations as proposals. Confirm Godot version and existing dialogue/camera systems.

## Scene brief
Record sequence ID, narrative purpose, entry conditions, location, cast, character knowledge, beats, camera framing, animation requirements, dialogue line IDs, music/SFX, subtitles, duration target, exit state and flags changed.

## Runtime rules
- Prefer in-engine presentation when it preserves continuity and reduces asset duplication.
- Keep player/input state transitions explicit.
- Provide skip behavior where appropriate; skipping must apply the same required progression flags as watching.
- Prevent repeated triggers from awarding progression or rewards twice.
- Define replay behavior separately from first-play behavior.
- Restore camera, audio, HUD and input state on every exit path.
- Handle app interruption and scene reload safely.
- Avoid long unskippable sequences that block play without strong narrative justification.

## QA
First view, skip immediately, skip near end, replay, pause/resume, app interruption, save before/after, reload, repeated trigger, missing optional dialogue and audio disabled.

## Acceptance
The sequence advances narrative consistently whether watched or skipped, does not softlock, and does not leave camera/audio/input in a stale state.
