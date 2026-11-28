---
name: enemy-boss-design
description: "Design distinct enemy archetypes, boss encounters and readable combat AI."
---

# Skill: Enemy AI and Boss Encounter Design

Define each enemy by gameplay role, silhouette, movement, perception, attack, telegraph, recovery, vulnerability/counterplay, damage model, defeat behavior and audiovisual feedback. Color or health changes alone do not create a distinct archetype.

Use explicit finite-state machines or behavior structures with bounded transitions. Separate perception, decision, movement, attack execution and presentation. Avoid hidden coupling to player internals. Inject clocks/randomness for deterministic tests where practical.

Boss specifications must include arena, entry/exit, phase transitions, attack patterns, telegraph duration, safe zones, recovery windows, escalation, vulnerability, checkpoint/retry and victory progression. Difficulty comes from readable pattern mastery, not unavoidable damage or unclear hitboxes.

Keep telegraphs legible on phone screens. Bound projectiles, particles and per-frame searches. Test every state transition, interruption, pause/resume, player death, reset, simultaneous damage and softlock recovery. Read approved canon and gameplay skills before implementation.
