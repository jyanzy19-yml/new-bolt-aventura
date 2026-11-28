/**
 * Non-production W1-L1 geometry fixture for validating the HTML5 runtime.
 * This is not the approved final level package or final gameplay tuning.
 */
export const DEBUG_W1_L1 = Object.freeze({
  schemaVersion: 1,
  id: 'w1-l1',
  worldId: 'cybercore',
  title: 'Despertar entre Ruínas',
  bounds: { x: 0, y: 0, width: 2600, height: 450 },
  spawn: { x: 48, y: 354 },
  geometry: {
    solids: [
      { id: 'debug-floor', x: 0, y: 400, width: 2600, height: 50 },
      { id: 'debug-barrier', x: 920, y: 310, width: 36, height: 90 },
      { id: 'debug-shelter-wall', x: 1900, y: 330, width: 28, height: 70 },
    ],
    oneWayPlatforms: [
      { id: 'debug-platform-01', x: 230, y: 340, width: 130, height: 12 },
      { id: 'debug-platform-02', x: 470, y: 292, width: 130, height: 12 },
      { id: 'debug-platform-03', x: 690, y: 350, width: 150, height: 12 },
      { id: 'debug-platform-04', x: 1120, y: 320, width: 180, height: 12 },
      { id: 'debug-platform-05', x: 1510, y: 350, width: 160, height: 12 },
      { id: 'debug-platform-06', x: 2070, y: 300, width: 180, height: 12 },
    ],
  },
  checkpoints: [
    { id: 'debug-checkpoint-01', x: 1220, y: 400 },
    { id: 'debug-checkpoint-02', x: 2020, y: 400 },
  ],
  exits: [
    {
      id: 'debug-exit-w1-l2',
      x: 2520,
      y: 340,
      width: 40,
      height: 60,
      targetLevelId: 'w1-l2',
    },
  ],
  metadata: {
    contentStatus: 'DEBUG_PLACEHOLDER',
    productionApproved: false,
    note: 'Geometria temporária para validar runtime, colisões, câmera e controles.',
  },
});

export const DEBUG_PLAYER_TUNING = Object.freeze({
  maxRunSpeed: 220,
  groundAcceleration: 1400,
  groundDeceleration: 1600,
  airAcceleration: 800,
  airDeceleration: 600,
  gravity: 1400,
  maxFallSpeed: 900,
  jumpVelocity: 520,
  jumpCount: 2,
  jumpBufferSeconds: 0.12,
  coyoteTimeSeconds: 0.1,
  jumpHoldMaxSeconds: 0.18,
  jumpHoldGravityScale: 0.55,
  jumpCutMultiplier: 0.45,
  groundProbeDistance: 2,
  dash: {
    speed: 520,
    durationSeconds: 0.3,
    cooldownSeconds: 0.5,
    gravityScale: 0,
    allowGrounded: true,
    allowAirborne: true,
    cancelOnWall: true,
  },
});

export const DEBUG_KEYBOARD_BINDINGS = Object.freeze({
  'move-left': ['ArrowLeft', 'KeyA'],
  'move-right': ['ArrowRight', 'KeyD'],
  jump: ['Space', 'KeyW', 'KeyZ'],
  dash: ['ShiftLeft', 'ShiftRight'],
});
