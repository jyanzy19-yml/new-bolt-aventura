# Skill: Enemy AI and Boss Encounter Design

## Activation
Use for enemy archetypes, behavior trees/state machines, combat roles, boss patterns, telegraphs and encounter balancing.

## Design contract
Each enemy archetype needs a distinct gameplay role, silhouette/readability, locomotion, detection/engagement range, attack rules, telegraph, recovery window, vulnerability/counterplay, damage model, defeat behavior and audio/visual feedback. A color or health-value change alone is not a distinct archetype.

## AI architecture
Use explicit finite-state machines or behavior structures with bounded transitions. Separate perception, decision, movement, attack execution and presentation. Avoid hidden coupling to player internals. Make AI deterministic in tests through injected clocks/randomness where practical.

## Bosses
Specify arena geometry, entry/exit conditions, phase transitions, attack patterns, telegraph duration, safe zones, recovery windows, escalation, vulnerability rules, checkpoint/retry behavior and victory progression. Difficulty must come from readable pattern mastery, not unavoidable damage or unclear hitboxes.

## Mobile and performance
Ensure telegraphs remain visible on phone screens. Avoid excessive simultaneous projectiles, particles and expensive per-frame searches. Cap active agents and use spatial queries/culling where justified by profiling.

## Validation
Test each state transition, interruption, pause/resume, player death, boss reset, edge-of-arena cases, simultaneous damage, phase transition and softlock recovery. Record tuning changes and rationale.
