/**
 * W1-L1 production gameplay data.
 * Geometry and narrative cues follow the approved campaign blueprint.
 * Vector presentation and numeric movement tuning remain provisional.
 */
export const W1_L1 = Object.freeze({
  schemaVersion: 1,
  id: 'w1-l1',
  worldId: 'cybercore',
  title: 'Despertar entre Ruínas',
  bounds: { x: 0, y: 0, width: 3600, height: 700 },
  spawn: { x: 72, y: 504 },
  geometry: {
    solids: [
      { id: 'cybercore-floor', x: 0, y: 550, width: 3600, height: 150 },
      { id: 'awakening-pillar', x: 260, y: 420, width: 34, height: 130 },
      { id: 'collapsed-beam', x: 930, y: 478, width: 118, height: 72 },
      { id: 'corridor-rubble', x: 1260, y: 512, width: 120, height: 38 },
      { id: 'courtyard-arch', x: 1570, y: 420, width: 54, height: 130 },
      { id: 'shelter-sidewall', x: 2790, y: 402, width: 28, height: 148 },
    ],
    oneWayPlatforms: [
      { id: 'awakening-platform-a', x: 390, y: 482, width: 150, height: 14 },
      { id: 'awakening-platform-b', x: 625, y: 432, width: 146, height: 14 },
      { id: 'corridor-platform-a', x: 1080, y: 454, width: 170, height: 14 },
      { id: 'courtyard-platform-a', x: 1740, y: 468, width: 164, height: 14 },
      { id: 'courtyard-platform-b', x: 1940, y: 380, width: 150, height: 14 },
      { id: 'courtyard-platform-c', x: 2150, y: 292, width: 154, height: 14 },
      { id: 'courtyard-platform-d', x: 2370, y: 382, width: 164, height: 14 },
      { id: 'courtyard-platform-e', x: 2550, y: 466, width: 154, height: 14 },
      { id: 'shelter-platform-a', x: 2960, y: 478, width: 176, height: 14 },
    ],
  },
  checkpoints: [
    { id: 'first-sync-checkpoint', x: 3260, y: 550 },
  ],
  exits: [
    {
      id: 'cybercore-w1-l1-exit',
      x: 3420,
      y: 438,
      width: 82,
      height: 112,
      targetLevelId: 'w1-l2',
    },
  ],
  interactables: [
    {
      id: 'diagnostic-compartment',
      kind: 'secret',
      x: 2200,
      y: 222,
      width: 68,
      height: 70,
      prompt: 'E / INTERAGIR — COMPARTIMENTO DE DIAGNÓSTICO',
    },
    {
      id: 'first-synchronization-point',
      kind: 'completion',
      x: 3220,
      y: 444,
      width: 84,
      height: 106,
      prompt: 'E / INTERAGIR — ATIVAR SINCRONIZAÇÃO',
    },
  ],
  enemy: {
    id: 'faulty-maintenance-unit',
    x: 1810,
    y: 506,
    width: 42,
    height: 44,
    patrolMin: 1680,
    patrolMax: 1915,
    speed: 42,
  },
  landmarks: [
    { id: 'awakening-pod', kind: 'pod', x: 104, y: 426, width: 112, height: 124 },
    { id: 'broken-signal-mast', kind: 'mast', x: 1160, y: 354, width: 46, height: 196 },
    { id: 'courtyard-ruin', kind: 'arch', x: 1510, y: 364, width: 176, height: 186 },
    { id: 'diagnostic-terminal', kind: 'terminal', x: 2200, y: 222, width: 68, height: 70 },
    { id: 'maintenance-shelter', kind: 'shelter', x: 2825, y: 404, width: 260, height: 146 },
    { id: 'sync-beacon', kind: 'beacon', x: 3220, y: 444, width: 84, height: 106 },
  ],
  sections: [
    { id: 'awakening-chamber', startX: 0, endX: 720, title: 'Câmara de despertar' },
    { id: 'collapsed-corridor', startX: 720, endX: 1500, title: 'Corredor desmoronado' },
    { id: 'open-courtyard', startX: 1500, endX: 2700, title: 'Pátio aberto' },
    { id: 'maintenance-shelter', startX: 2700, endX: 3600, title: 'Abrigo de manutenção' },
  ],
  objectives: [
    { id: 'leave-awakening-chamber', label: 'Saia da câmara de despertar', thresholdX: 720 },
    { id: 'cross-collapsed-corridor', label: 'Atravesse o corredor desmoronado', thresholdX: 1500 },
    { id: 'reach-maintenance-shelter', label: 'Alcance o abrigo de manutenção', thresholdX: 2700 },
    { id: 'activate-first-sync', label: 'Ative o primeiro ponto de sincronização', thresholdX: 3220 },
  ],
  metadata: {
    contentStatus: 'PLAYABLE_BLOCKOUT',
    productionApproved: false,
    artStatus: 'ORIGINAL_VECTOR_PLACEHOLDER',
    audioStatus: 'PENDING',
    narrativeStatus: 'CANON_BEATS_WITH_PROVISIONAL_UI_COPY',
    source: 'docs/game-design/EXPANDED-42-LEVEL-CAMPAIGN-BLUEPRINT.md',
    notes: [
      'Percurso e beats seguem o blueprint: câmara, corredor, pátio e abrigo.',
      'A unidade de manutenção é um encontro opcional de leitura e evasão; combate letal não é introduzido nesta fase.',
      'O compartimento de diagnóstico é opcional e não bloqueia a conclusão.',
      'A ativação da sincronização encerra W1-L1; W1-L2 ainda depende de implementação.',
      'A arte vetorial e as falas de interface são provisórias, não assets finais aprovados.',
    ],
  },
});

export const W1_L1_PLAYER_TUNING = Object.freeze({
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

export const W1_L1_KEYBOARD_BINDINGS = Object.freeze({
  'move-left': ['ArrowLeft', 'KeyA'],
  'move-right': ['ArrowRight', 'KeyD'],
  jump: ['Space', 'KeyW', 'KeyZ'],
  dash: ['ShiftLeft', 'ShiftRight', 'KeyC'],
  interact: ['KeyE', 'Enter'],
  pause: ['KeyP', 'Escape'],
});
