# HTML5 PlayerMotor contract

**Status:** runtime implementation contract; tuning is injected and remains provisional until playtested.  
**Dependencies:** fixed-step simulation frames, ActionBuffer input frames and static CollisionWorld.  
**Out of scope:** rendering, animation, camera, enemy collision, damage, wall movement, moving platforms, slopes, save state and final balance values.

## 1. Ownership and coordinate model

- PlayerMotor owns the player's world-space AABB, horizontal/vertical velocity, facing, grounded state and movement timers.
- Coordinates use the top-left origin with positive Y downward.
- The caller supplies a CollisionWorld and a complete tuning object.
- The motor does not read DOM events. It consumes the normalized `{ pressed, released, held }` frame emitted by InputManager/ActionBuffer.
- Simulation delta must come from the fixed-step runtime; render delta must never be passed directly.

## 2. Required tuning

All values are mandatory. No production values are embedded in the motor.

| Parameter | Meaning |
|---|---|
| `maxRunSpeed` | Maximum horizontal locomotion speed |
| `groundAcceleration`, `groundDeceleration` | Ground response |
| `airAcceleration`, `airDeceleration` | Air response |
| `gravity`, `maxFallSpeed` | Vertical motion |
| `jumpVelocity`, `jumpCount` | Jump impulse and total jumps per grounded cycle |
| `jumpBufferSeconds`, `coyoteTimeSeconds` | Input forgiveness windows |
| `jumpHoldMaxSeconds`, `jumpHoldGravityScale`, `jumpCutMultiplier` | Variable-height jump policy |
| `groundProbeDistance` | Ground contact tolerance |
| `dash.speed`, `durationSeconds`, `cooldownSeconds` | Dash envelope |
| `dash.gravityScale` | Gravity multiplier while dashing |
| `dash.allowGrounded`, `allowAirborne` | Explicit eligibility policy |
| `dash.cancelOnWall` | Explicit wall-cancellation policy |

The configuration object is a design-tuning boundary, not a statement that these values or policies have been approved. Do not ship arbitrary values as canon. Calibrate from the approved prototype/feel targets and representative playtests.

## 3. State and update order

Each fixed update:
1. Reads the current normalized input frame and facing direction.
2. Probes ground and updates jump/coyote allowances.
3. Updates jump buffer and Dash cooldown.
4. Starts eligible Dash or consumes a buffered jump.
5. Applies variable-jump policy and horizontal acceleration/deceleration.
6. Applies gravity (scaled during Dash).
7. Resolves movement against CollisionWorld.
8. Resolves ceiling/floor/wall contact, landing and jump-budget reset.
9. Advances Dash lifetime and returns an immutable-by-copy snapshot.

Dash is horizontal. Direction follows current horizontal input, otherwise the last facing direction. Wall cancellation, grounded/airborne eligibility and gravity scaling are explicit configuration. The motor does not add a Dash retune or assume a canonical cooldown.

## 4. Input action identifiers

- `move-left`
- `move-right`
- `jump`
- `dash`

The mobile UI must bind touch controls to these logical actions. Multiple simultaneous pointers remain owned by ActionBuffer source tokens.

## 5. Acceptance and known limitations

- Ground and air acceleration profiles are independently configurable.
- Jump buffer, coyote time, multiple jumps and variable jump height are configurable.
- Dash is retained and configurable without hard-coded balance.
- Collision is axis-separated against static AABBs and one-way platforms.
- Fixed-step determinism is validated by unit tests; browser/Android input latency is not claimed by unit tests.
- No slope handling, moving platforms, wall jump/slide, knockback, damage, animation sync or physical-device verification is included.
