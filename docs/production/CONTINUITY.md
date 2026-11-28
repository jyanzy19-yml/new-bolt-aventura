# BOLT · AVENTURA — Continuity Log

## Current snapshot — 2026-11-28 (HTML5 runtime execution)

- **Main HEAD:** `9c32df4225b4e410340b2254a098167023593625`; main remains the clean HTML5/Vite foundation and does not yet contain the open runtime/gameplay PRs.
- **Technology authority:** HTML5, CSS3, JavaScript ES Modules, Canvas 2D, Vite, Web Audio API and Pointer Events; game created from zero, not a Godot migration. Capacitor remains a candidate pending validation.
- **Open implementation PRs:** #145 runtime kernel, #146 Canvas viewport, #147 input/multitouch, #148 collision kernel, #149 level schema/camera, #150 combat core, #151 PlayerMotor/Dash, #152 transactional LevelRuntime. All are open and unmerged; the user controls integration.
- **Passing validation:** PRs #145–#149 and #152 have their configured CI checks passing; PR #150 Web CI passed. PR #151 had one failed test assertion on an earlier commit; the expected jump-charge count was corrected and a new Web CI run is pending.
- **Current code boundary:** fixed-step loop, Canvas viewport, logical input buffering, static AABB collision, configurable PlayerMotor/Dash, versioned level schema, 2D camera, immutable level lifecycle and bounded health/projectile primitives exist on isolated branches. They are not yet integrated into main or a playable scene.
- **Content authority:** Cybercore is World 1; W1-L1 is “Despertar entre Ruínas”. The blueprint describes the sequence chamber → collapsed corridor → open courtyard → maintenance shelter, with movement, acceleration, jump, variable jump, double jump and interaction taught in safe spaces. This blueprint is production proposal, not final built level content.
- **Canon invariant:** preserve BOLT, NEXO, Grande Colapso, Núcleo da Eternidade, Arquiteto, seven worlds, seven fragments, planned 42 phases and approved Dash. Dash tuning/policy remains configurable and must not be presented as approved numeric balance.
- **Current branches:** `agent/chatgpt/stage-01-runtime-kernel`, `stage-02-canvas-viewport`, `stage-03-input-multitouch`, `stage-04-collision-kernel`, `stage-04-player-motor`, `stage-05-level-camera`, `stage-05-level-runtime`, `stage-06-combat-core`.
- **No unsupported claims:** no playable W1-L1, final weapon catalogue, final art/audio integration, APK/Capacitor package, WebView test or physical Android validation is declared complete.
- **Next work:** finish PlayerMotor CI; complete the level geometry → CollisionWorld adapter; connect fixed-step runtime, InputManager, PlayerMotor, Camera2D and Canvas renderer; then build a first playable W1-L1 slice from the approved phase package.

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
