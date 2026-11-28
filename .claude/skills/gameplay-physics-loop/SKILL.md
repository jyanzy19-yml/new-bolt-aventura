# Skill: Gameplay Physics and Simulation

## Activation
Use for player movement, physics, collision, combat timing, Dash, enemy movement, simulation scheduling and gameplay state machines.

## Contracts
1. Define coordinate system, world units, timestep, gravity convention and collision layers.
2. Use fixed-step simulation independent of display refresh where appropriate.
3. Specify update ordering: input intent → state transitions → forces/velocity → collision resolution → gameplay events → presentation snapshots.
4. Separate input intent from physical control mapping and from simulation.
5. Use explicit state machines with documented entry/exit conditions.
6. Define collision semantics, one-way platforms, slopes, moving platforms, hazards and knockback.
7. Define jump buffering, coyote time, variable jump, air control and landing only according to approved gameplay design.
8. Preserve Dash as an approved mechanic. Specify activation, direction, duration, cooldown, interruption, invulnerability/interaction rules, cancellation and touch mapping.
9. Keep damage ownership singular; avoid duplicate hit application and re-entrant event chains.
10. Make deterministic seams for clocks and randomness in tests.

## Robustness
Handle pause, death, respawn, scene transition, focus loss and input cancellation without stale held actions. Avoid simulation depending on render cadence. Do not change tuning by intuition; compare measured movement traces and approved feel.

## Validation
Unit-test pure movement/state logic. Integration-test ground/air transitions, collisions, hazards, Dash, damage, checkpoints, enemy interaction and low-frame-rate behavior. Record exact parameters and regressions.
