---
name: bolt-boss-encounters
description: Designs or audits fair, readable and narratively integrated boss encounters for BOLT's seven-world structure, including phases, telegraphs, arenas, fragment rewards and regression cases.
---

# BOLT Boss Encounter Design

## Mission
Make each world guardian a memorable culmination of the mechanics and narrative established in its world.

## Canon boundary
Each of the seven worlds has a boss guarding its fragment. Specific identities, motives, names and mechanics remain undefined until approved. New ideas must be labeled proposals.

## Encounter specification
For each boss document:
- approved ID/name and world;
- narrative role and fragment relationship;
- arena layout, boundaries and traversal rules;
- phase graph and transition conditions;
- each pattern's anticipation, active interval, recovery and counterplay;
- readable visual and audio telegraph;
- intended player response and available response window;
- interaction with already taught abilities;
- damage/state rules, if applicable;
- victory, defeat, retry and checkpoint behavior;
- entry/exit cutscenes and skippable behavior;
- performance limits and simultaneous effects;
- accessibility and touch readability.

## Fairness rules
- Never rely on unavoidable damage as the primary difficulty.
- Telegraphs must remain visible against the arena background.
- Avoid simultaneous effects that obscure the player or platform edges.
- Teach component mechanics before combining them.
- Avoid timing demands that become unreasonable under touch input or frame-time variance.
- Phase transitions must not create ambiguous or uninterruptible failure states.

## QA
Test every phase transition, defeat/retry, pause/resume, scene reload, checkpoint, fragment award, save/load, skip cutscene, off-screen boundaries and low-performance conditions.

## Acceptance
The encounter is beatable using skills taught before or during the encounter, its attacks communicate counterplay, and its reward updates progression exactly once.
