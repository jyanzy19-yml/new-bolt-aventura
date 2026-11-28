# BOLT · AVENTURA — Continuity Log

## Current snapshot — 2026-11-28 (HTML5 runtime execution)

- **Main HEAD:** `27c34070a9ee1746076a1ca034833a577858b306`; its tree SHA is identical to the original baseline commit `9c32df4225b4e410340b2254a098167023593625`. A documentation file was accidentally added directly to main and immediately deleted; there is no remaining tree diff from the original baseline. All subsequent changes remain PR-only.
- **Technology authority:** HTML5, CSS3, JavaScript ES Modules, Canvas 2D, Vite, Web Audio API and Pointer Events; the game is created from zero, not migrated from Godot. Capacitor remains conditional on validation.
- **Open PRs:** #145–#160 are open and unmerged. User retains merge authority. Main has not been changed by this development pass.
- **Subsystem work on isolated branches:** fixed-step runtime; CanvasSurface/viewport; keyboard and multitouch ActionBuffer/InputManager; accessible TouchControls; static AABB CollisionWorld; configurable PlayerMotor with jump buffer, coyote time, variable jump and Dash; debug Canvas renderer; PlayerSceneRuntime composition; versioned level schema; Camera2D; immutable transactional LevelRuntime; static level geometry adapter; HealthComponent; bounded ProjectileSystem; data-driven WeaponController; integrated CombatRuntime.
- **Configured CI:** PRs #145–#159 have passing configured checks, including CodeQL for #159. PR #160 Web CI passed; documentation and CodeQL checks are in progress. Earlier test failures in PR #151 and #154 were traced to incorrect test expectations (not runtime regressions), corrected, and the newer runs passed.
- **W1-L1 content authority:** World 1 is Cybercore; W1-L1 title “Despertar entre Ruínas”. The campaign blueprint describes the sequence chamber → collapsed corridor → open courtyard → maintenance shelter, teaching movement, acceleration, jump, variable jump, double jump and interaction in safe spaces. Treat this as production proposal until the dedicated content package is reviewed; no final W1-L1 level file has been integrated.
- **Canon invariants:** preserve BOLT, NEXO, Grande Colapso, Núcleo da Eternidade, Arquiteto, seven worlds, seven fragments, planned 42 phases and approved Dash. Dash remains configurable; no numeric balance from test fixtures is canon.
- **Current active branches:** `agent/chatgpt/stage-01-runtime-kernel`, `agent/chatgpt/stage-02-canvas-viewport`, `agent/chatgpt/stage-03-input-multitouch`, `agent/chatgpt/stage-03-touch-controls`, `agent/chatgpt/stage-04-collision-kernel`, `agent/chatgpt/stage-04-player-motor`, `agent/chatgpt/stage-04-debug-renderer`, `agent/chatgpt/stage-04-player-scene-runtime`, `agent/chatgpt/stage-05-level-camera`, `agent/chatgpt/stage-05-level-runtime`, `agent/chatgpt/stage-05-level-collision-adapter`, `agent/chatgpt/stage-06-combat-core`, `agent/chatgpt/stage-06-weapon-controller`, `agent/chatgpt/stage-06-combat-runtime`, `agent/chatgpt/stage-09-android-display-contract`, `agent/chatgpt/stage-09-asset-loader`.
- **Not yet demonstrated:** playable W1-L1, final weapon catalogue, final art/audio integration, APK/Capacitor package, browser gameplay session, Android WebView, touch on physical device, safe-area/status/navigation bar behavior, stable FPS, memory/thermal profile or physical Android validation.
- **Next work:** finish PR #160 documentation/CodeQL; integrate FixedStepLoop, CanvasSurface, InputManager/TouchControls, PlayerMotor, Camera2D, LevelRuntime, CollisionWorld adapter and DebugCanvasRenderer into a single browser-level playable loop; then implement browser asset decoders/loading UI and validate Android packaging/device behavior.


## Earlier snapshot — 2026-11-28 (pre-runtime implementation)


- Stack soberana: HTML5, CSS3, JavaScript ES Modules, Canvas 2D, Vite, Web Audio API e Pointer Events.
- Produto criado do zero; não é port nem migração Godot.
- PR #120 integrada à main: metadados das Skills/catálogos corrigidos; documentação validada com sucesso.
- PR #117 (fundação Vite/ES Modules) foi marcada ready, mas precisa de reconciliação com a main após a integração da PR #120.
- Branch ativa de consolidação/limpeza: `chore/html5-runtime-cleanup`.
- Inventário recursivo do baseline: 417 arquivos versionados; 169 paths classificados como remoção por serem artefatos exclusivos da antiga implementação Godot. O histórico Git permanece preservado.
- Canon, bíblias de design, conteúdo narrativo, planos e handoffs históricos foram mantidos.
- `scripts/validate_project_docs.py` permanece porque valida documentação; testes JavaScript do scaffold permanecem. Testes GDScript foram removidos da árvore ativa.
- Nenhum gameplay HTML5, vertical slice, APK Capacitor ou teste em Android físico é declarado concluído.

## Próximas ações verificáveis

1. Concluir PR de consolidação e limpeza após CI integral.
2. Gerar e commitar `package-lock.json` em ambiente com acesso ao registry; migrar CI para `npm ci`.
3. Executar lint, Vitest, build Vite, validador documental e CodeQL no commit integrado.
4. Implementar a primeira vertical slice com contratos e testes.
5. Validar browser, Android WebView e dispositivo físico separadamente.
