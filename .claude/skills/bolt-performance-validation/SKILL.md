---
name: bolt-performance-validation
description: Establishes repeatable performance baselines and verifies CPU, GPU, frame-time, memory, loading and thermal changes for BOLT on low-to-mid Android hardware.
---

# BOLT Performance Validation

## Mission
Make performance decisions from reproducible evidence rather than intuition.

## Target context
Android app; reference devices around 4 GB RAM and Helio G99-class or weaker. 60 FPS is a preferred target only where sustained by the device. The corresponding frame budget is about 16.67 ms.

## Workflow
1. Detect Godot version, renderer, build type, resolution, frame cap and VSync configuration.
2. Choose a reproducible scene and input sequence.
3. Record device model, SoC/GPU, RAM, Android version and thermal conditions.
4. Measure warm-up and sustained run; distinguish first-use shader/resource stutter from steady-state performance.
5. Capture average, p95, p99 and worst frame time; CPU/GPU breakdown when available.
6. Record memory at start, end and peak; look for monotonic growth across repeated loops.
7. Change one dominant factor at a time where possible.
8. Repeat identical measurements and compare.
9. Document regressions and revert unsupported optimizations.

## Priority order
Correctness and input responsiveness first; then frame-time bottlenecks, memory pressure, loading spikes, overdraw/rendering cost, physics/AI update cost and allocation churn.

## Reporting
Use docs/qa/performance-capture-template.md. Never infer GPU bottlenecks from CPU FPS alone. Never claim sustained 60 FPS from a short test or desktop editor result.

## Acceptance
A performance claim includes baseline, changed build, same reproduction sequence, device conditions and before/after measurements. If measurement is unavailable, label the work as an unverified hypothesis.
