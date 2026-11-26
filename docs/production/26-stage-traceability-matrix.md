# Matriz de rastreabilidade — plano operacional em 26 etapas

**Data:** 2026-11-26  
**Base funcional:** PR #47 integrada em `2636226c4027625649e66c51ff64d7e2e56168a6`.  
**Branch documental:** `docs/26-stage-traceability-matrix`.  
**Escopo:** decompor o mandato de produção em 26 unidades rastreáveis sem substituir a MASTER_DIRECTIVE, as bíblias, as especificações técnicas, os ADRs ou o roadmap.

## 1. Regra de autoridade

Esta matriz organiza o trabalho; não cria canon nem aprova propostas. Aplicar a hierarquia de `MASTER_DIRECTIVE.md`:

1. Instrução explícita mais recente do usuário.
2. Decisões aprovadas em `docs/decisions/`.
3. Canon confirmado nas bíblias de design.
4. Requisitos e especificações técnicas.
5. Diretiva mestra, roadmap e esta matriz.
6. Propostas de agentes, exemplos e parâmetros provisórios.

Cada linha distingue:
- **Implementado:** existe no repositório executável.
- **Validado:** existe evidência reproduzível (CI, teste, build ou aparelho identificado).
- **Pendente:** requisito ainda não implementado ou evidência ainda não obtida.
- **Provisório:** valor, arte ou comportamento de trabalho que não pode ser promovido a canon sem aprovação.

A existência de um documento, script ou cena não basta para declarar a etapa concluída. O status operacional deve ser sincronizado com `docs/production/stage-status.md` e `implementation-tracker.md`.

## 2. Matriz principal

| # | Etapa | Fontes de requisito / autoridade | Sistemas, cenas e arquivos rastreados | Evidência / testes existentes | Critério de aceite da etapa |
|---:|---|---|---|---|---|
| 01 | Auditoria integral do repositório | `MASTER_DIRECTIVE.md`; `docs/README.md`; `roadmap.md`; ADRs; estado Git | Árvore Git; `project.godot`; `export_presets.cfg`; 30 scripts runtime; 19 cenas; recurso de tuning; workflows | Inventário de 288 arquivos; revisão estática; PR #47: 88 testes/553 verificações, scripts compilados e cenas instanciadas | **CONCLUÍDA — auditoria estática.** Registrar riscos e limites sem alegar teste físico |
| 02 | Requisitos e planejamento | `MASTER_DIRECTIVE.md`; `00-game-overview.md`; bíblias `01–07`; `EXPANDED-42-LEVEL-CAMPAIGN-BLUEPRINT.md`; `EXPANDED-GAMEPLAY-SYSTEMS.md`; `roadmap.md` | Esta matriz; `stage-status.md`; `implementation-tracker.md`; 42 IDs de fase; backlog de requisitos e decisões | Documentos canônicos existentes; matriz criada nesta entrega; rastreabilidade por consolidar e lacunas de canon a classificar | Todo requisito relevante tem fonte, classificação (canon/requisito/proposta/a definir), etapa, sistema-alvo, teste e critério de aceite; conflitos registrados, nunca resolvidos por suposição |
| 03 | Arquitetura e organização | `technical/00-architecture-principles.md`; `technical/05-system-contracts.md`; ADR-0002 | `project.godot`; autoloads; `scripts/`; `scenes/`; `resources/`; organização de domínios | 4.7.2 fixado; projeto e cenas existentes; testes de configuração e carregamento | Ownership, dependências, sinais, ciclo de vida, limites entre domínios e convenções documentados; nenhuma duplicação de sistemas; referências e dependências validadas |
| 04 | Infraestrutura e sistemas centrais | `technical/05-system-contracts.md`; `technical/06-godot-project-foundation.md`; ADR-0004/0005 | `scripts/core/boot.gd`; `scene_flow.gd`; `save_system.gd`; `campaign_progress.gd`; autoloads | `test_scene_flow.gd`; `test_save_system.gd`; `test_campaign_progress.gd`; `test_project_config.gd` | Boot previsível; transições exclusivas e recuperáveis; save versionado e íntegro; progressão de domínio sem referências a Nodes; falhas não destroem dados |
| 05 | Recursos e carregamento | `technical/03-loading-and-assets.md`; `technical/01-android-performance.md`; `quality-control-protocol.md` | `SceneFlow`; `LoadingOverlay`; carregamento threaded; importação e preload de recursos | `test_loading_overlay.gd`; `test_scene_flow.gd`; Android export CI | Loading representa progresso real; sem percentuais inventados; bloqueia input; falhas restauram estado; cancelamento/interrupções e picos de memória testados antes de aprovação |
| 06 | Personagem principal | `game-design/03-character-bible.md`; `game-design/04-gameplay-systems.md`; ADRs aplicáveis | `scenes/player/bolt.tscn`; `scripts/player/bolt_player.gd`; `bolt_tuning.gd`; `BoltHealth`; visual, animações e estados | `test_player_movement.gd`; `test_combat_core.gd`; testes de derrota/respawn | Identidade, estados, capacidades, dano, derrota e recuperação aderem ao canon; tuning final aprovado e medido; apresentação final substitui placeholders |
| 07 | Física e movimentação | `game-design/04-gameplay-systems.md`; `technical/02-touch-and-display.md`; ADR-001-DASH | `BoltPlayer`; `BoltTuning`; `ActionBuffer`; `PlatformBlock`; colisões | `test_player_movement.gd`; `test_action_buffer.gd`; `test_moving_platform.gd`; `test_one_way_platform.gd` | Corrida, salto, variável, duplo, coyote, buffer e Dash mantêm regras explícitas; regressões de borda; sensação validada em touch físico; nenhuma mudança de física sem medição e aprovação |
| 08 | Animações e feedback | `game-design/03-character-bible.md`; `game-design/07-art-audio-direction.md`; `game-design/06-ui-ux.md` | Estados de BOLT, visual do player/inimigo, HUD, notificações, hit flash, efeitos e animação | Feedback de vida, dash, checkpoint e hit flash existem; pipeline de animação final e QA visual pendentes | Estados visuais correspondem ao estado de gameplay; transições legíveis; sem feedback contraditório; animações não bloqueiam input nem introduzem custo excessivo |
| 09 | Câmera e sistemas espaciais | `technical/05-system-contracts.md`; `game-design/05-level-design-standard.md` | Camera2D em `bolt.tscn`; `configure_camera()` de W1-L1/W1-L2; limites e composição | `test_camera_contract.gd`; limites por fase validados headless | Câmera não mostra fora do mundo, não corta eventos importantes e mantém leitura em proporções Android; smoothing/drag e transições testados visualmente |
| 10 | Interações e sobrevivência | `game-design/04-gameplay-systems.md`; `technical/05-system-contracts.md`; `technical/08-campaign-progress.md` | Vida/dano, invulnerabilidade, checkpoint, kill zone, coletável, campo energético, retry e respawn | `test_checkpoints.gd`; `test_enemy_combat.gd`; `test_campaign_entry.gd`; `test_w1_l2_progression.gd` | Interações têm estados e contratos claros; contato físico real; sem dano duplicado ou softlock; checkpoint/respawn/save persistem corretamente |
| 11 | Arquitetura de combate | `game-design/04-gameplay-systems.md`; `game-design/03-character-bible.md`; `technical/05-system-contracts.md` | `BoltHealth`; `BoltCombat`; `ChronoProjectile`; alvos e componentes de dano | `test_combat_core.gd`; `test_enemy_combat.gd`; teste de encontro W1-L1 | Pipeline ataque → projétil → colisão → dano → feedback → derrota modular; filtros de alvo; lifecycle e cooldown previsíveis |
| 12 | Armas e arsenal | `game-design/04-gameplay-systems.md`; bíblias de personagem e gameplay; decisões aprovadas | Pistola Crono atual; futuras armas, slots, seleção, munição/cooldown e UI de arsenal | Pistola Crono funcional em protótipo; outras armas e seleção não implementadas | Cada arma tem identidade, papel, regras, telegraph/feedback, tuning e controles touch; balanceamento aprovado; nenhuma arma inventada como canon |
| 13 | Arquitetura de inimigos | `game-design/03-character-bible.md`; `game-design/02-world-bible.md`; `game-design/04-gameplay-systems.md` | `CybercorePatrolEnemy`; componentes de vida/dano; cenas e recursos por arquétipo | `test_enemy_combat.gd`; `test_campaign_entry.gd` | Contrato reutilizável para percepção, estados, dano, contato, derrota, drops e telegraphs; arquétipos distintos por função, não recoloração |
| 14 | Inteligência artificial | `game-design/04-gameplay-systems.md`; bíblias dos mundos/personagens | Inimigo de patrulha provisório; futura percepção, navegação, combate, busca e recuperação | Patrulha horizontal simples; cobertura automatizada limitada | Estados de IA determinísticos e testáveis; limites de arena; telegraphs justos; comportamento não causa softlock nem carga desnecessária |
| 15 | Chefes e confrontos | `game-design/02-world-bible.md`; `game-design/03-character-bible.md`; `game-design/05-level-design-standard.md` | Arenas, chefes dos sete mundos, fases de combate, fragmentos e recompensas | Nenhum chefe/arena executável identificado | Cada chefe tem identidade canônica, padrões, fases, telegraphs, contra-jogo, checkpoint, vitória/derrota, recompensa e QA de justiça/acessibilidade |
| 16 | Arquitetura de mundos e fases | `game-design/02-world-bible.md`; `EXPANDED-42-LEVEL-CAMPAIGN-BLUEPRINT.md`; `05-level-design-standard.md` | IDs W#-L#; dados de campanha; roteamento; seleção/continuação; dependências e recursos por fase | W1-L1/W1-L2; `CampaignProgress`; testes de campanha e progressão | Matriz das 42 fases rastreada; dependências e transições explícitas; fase não implementada nunca aparece como destino válido |
| 17 | Construção dos mundos | `game-design/02-world-bible.md`; `07-art-audio-direction.md`; asset pipeline | Cybercore W1 em blockout; mundos W2–W7, tilesets, fundos, hazards, NPCs e temas | W1 parcial; mundos 2–7 sem ambientes executáveis | Cada mundo possui fantasia, linguagem visual/sonora, mecânica, NPCs, inimigos, obstáculos, chefe e fragmento conforme canon; performance medida |
| 18 | Construção das fases | `game-design/05-level-design-standard.md`; blueprint de 42 fases; bíblias de mundo | W1-L1 e W1-L2; futuros níveis e cenas de campanha | `test_campaign_entry.gd`; `test_w1_l2_progression.gd`; blockouts atuais | Cada fase cumpre ficha de level design, ritmo ensinar/praticar/combinar/dominar, rota principal, checkpoints, segredos, dificuldade e critérios de conclusão |
| 19 | Obstáculos e exploração | `game-design/04-gameplay-systems.md`; `05-level-design-standard.md`; blueprint dos mundos | `PlatformBlock`; `MovingPlatform`; `OneWayPlatform`; `TimedEnergyGate`; checkpoints; pickups | `test_moving_platform.gd`; `test_one_way_platform.gd`; `test_w1_l2_progression.gd`; PR #47 corrige estado inicial do gate | Cada obstáculo tem contrato físico e visual, parâmetros validados, teste de contato real e integração somente na fase cujo design o exigir |
| 20 | Narrativa e progressão | `game-design/01-narrative-bible.md`; `02-world-bible.md`; `03-character-bible.md`; ADR-0004/0005 | Abertura, tutorial, flags, NPCs, diálogos, fragmentos, CampaignProgress e transições | `opening_cinematic.gd`; `tutorial.gd`; progressão W1-L1→W1-L2 parcial; testes de campanha | Arco completo coerente; flags estáveis; cenas puláveis sem perda de compreensão; fragmentos e consequências conforme canon; save/load e migrações |
| 21 | Interface e UX | `game-design/06-ui-ux.md`; `technical/02-touch-and-display.md`; ADR-0003 | Boot, menu, HUD, pausa, resultados, loading, touch, safe area e configurações | `test_touch_controls.gd`; `test_loading_overlay.gd`; `test_safe_area.gd`; `test_project_config.gd` | Fluxos completos e acessíveis; hierarquia consistente; input não fica preso; barras/recortes e áreas seguras validados em aparelho |
| 22 | Arte e efeitos visuais | `game-design/07-art-audio-direction.md`; `production/ASSET_PIPELINE.md` | Sprite/rig de BOLT; inimigos; tilesets; UI; VFX; icon; import presets | Placeholders geométricos e icon placeholder; assets finais não integrados | Identidade visual aprovada; fontes e licenças registradas; atlas/import settings e budgets; legibilidade e desempenho Android aprovados |
| 23 | Áudio e apresentação | `game-design/07-art-audio-direction.md`; `game-design/06-ui-ux.md` | Música por mundo/fase; SFX; buses; mix; opções; lifecycle áudio | Nenhuma implementação de áudio de gameplay identificada | Música/SFX originais ou licenciados; buses, volume/mute, ducking, foco e retomada; mix testado em alto-falante/fone |
| 24 | Android e touchscreen | ADR-0001/0003; `technical/01-android-performance.md`; `02-touch-and-display.md`; `04-android-build-checklist.md`; `qa/ANDROID_DEVICE_TEST_TEMPLATE.md` | Preset Android; arm64; immersive mode; safe area; multitouch; APK; assinatura e pacote | Android Debug Export CI; APK debug assinado e verificado; testes touch sintéticos | Instalação/cold start/upgrade/lifecycle/touch/safe area/barras testados em dispositivos identificados; package ID definitivo aprovado; release signing segura |
| 25 | Otimização e garantia de qualidade | `technical/01-android-performance.md`; `qa/test-matrix.md`; templates de performance/bug; Definition of Done | Runner headless; CI Godot/Docs/Android; profiler; budgets CPU/GPU/RAM; crash/perf capture | 88 testes/553 verificações na PR #47; export debug; nenhum profiling físico | Testes de regressão, sessões longas, p95/p99 frame time, memória e temperatura em hardware de referência; zero blocker/critical aberto |
| 26 | Polimento e consolidação final | `production/definition-of-done.md`; `android-release-checklist.md`; `qa/test-matrix.md`; MASTER_DIRECTIVE | Campanha integrada, arte/áudio, menus, saves, release candidate, changelog e proveniência | Não iniciada; produto ainda em blockout/protótipo | 42 fases e sete mundos concluídos conforme escopo aprovado; narrativa fechada; QA completo; release candidate assinável e reproduzível; riscos e evidências anexados |

## 3. Dependências e ordem de execução

A numeração operacional organiza o trabalho, mas não obriga serialização absoluta. Sistemas independentes podem avançar em paralelo desde que não violem ownership, contratos ou gates.

- Etapas 01–03 estabelecem inventário, rastreabilidade e arquitetura.
- Etapas 04–05 fornecem infraestrutura e carregamento para os demais domínios.
- Etapas 06–14 constroem player, física, interação, combate e inimigos; mudanças em movimento/combate exigem regressão e tuning aprovado.
- Etapas 15–20 dependem de canon, arquitetura de campanha e contratos centrais; conteúdo não pode ser produzido em escala com lacunas narrativas ou de level design escondidas.
- Etapas 21–24 atravessam o produto e devem ser validadas continuamente, não apenas no final.
- Etapas 25–26 consolidam evidência e release, mas profiling e QA devem começar assim que houver build executável.

## 4. Gates de qualidade transversais

| Gate | Bloqueia avanço quando | Evidência mínima |
|---|---|---|
| Canon/design | Nome, lore, mecânica, fase, personagem ou balanceamento não definido e a escolha altera a experiência | Decisão aprovada ou proposta isolada explicitamente marcada |
| Arquitetura | Ownership/sinal/estado persistente não tem contrato ou cria dependência circular | Contrato técnico e teste de integração |
| Gameplay | Alteração quebra input, colisão, física, progresso ou fluxo | Regressão headless + playtest humano quando afeta sensação |
| Android | Export, orientação, barras, safe area ou lifecycle não reproduzível | APK identificado + matriz por aparelho; não extrapolar para aparelhos não testados |
| Performance | Meta de frame time/memória não foi medida no cenário representativo | Captura com aparelho/build/cena/duração e percentis |
| Release | Package ID, assinatura, proveniência, save migration ou blocker/critical pendente | Checklist Android e Definition of Done aprovados |

## 5. Regras para manter a matriz atualizada

1. Toda PR informa quais etapas e IDs de sistema afeta.
2. Ao concluir uma unidade, registrar branch, commit, arquivos, testes, resultados, artefatos e limitações.
3. Atualizar `stage-status.md` e `implementation-tracker.md` após merge; não marcar etapa concluída por uma PR isolada quando os critérios da etapa forem maiores.
4. Testes headless não comprovam toque físico, renderização, FPS, memória ou ergonomia.
5. APK exportado não equivale a APK instalado/testado.
6. Parâmetros provisórios continuam provisórios até aprovação e medição.
7. Não abrir novas linhas de trabalho concorrentes: um único escritor ativo, branch por unidade e integração controlada.

## 6. Estado desta matriz

- **Etapa 01:** concluída como auditoria estática; relatório em `repository-audit-2026-11-26.md`.
- **Etapa 02:** em andamento; esta matriz consolida fontes, sistemas, evidências e critérios. Próximo trabalho: revisar cada requisito de design e identificar conflitos/lacunas de canon ou valores a definir.
- **Etapas 03–26:** status conforme `stage-status.md`; linhas não significam que o conteúdo final já existe.
- **Limites conhecidos:** package ID `com.example.boltaventura` é placeholder; instalação Android, toque físico, barras/safe area, profiling e sessão prolongada não foram executados.
