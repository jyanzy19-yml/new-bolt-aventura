# Snapshot operacional vigente — adoção do plano de 32 etapas (27/11/2026)

**Main HEAD no início desta consolidação:** `79023eabb6b31bccc456d3a2d005731733e8444e`. Contratos de recuperação da Etapa 14 reunidos na branch de integração; CI combinado pendente.  
**PR #73:** formalizou o plano de 32 etapas e o pipeline de aprovação visual; merge commit `d90ac2c78e96b32233f8d003ea6673a38079ecb3`.
**Plano primário:** [32-stage-production-plan.md](32-stage-production-plan.md). A matriz de 26 etapas permanece como histórico/crosswalk, não como plano operacional primário.  
**Etapas novas 01–04:** concluídas no nível automatizado/documental L2 descrito nas evidências históricas; isso não aprova Gate 1 nem QA Android físico.  
**Nova Etapa 29:** EM ANDAMENTO — recebe o trabalho da antiga Etapa 05 sobre recursos, carregamento, ciclo de vida e instrumentação. PR #69, #70, #71 e #72 integradas; medições físicas ainda pendentes.  
**Novas Etapas 05–09:** NÃO INICIADAS — direção de arte, guia técnico e produção visual ainda precisam ser executados. A criação visual deverá ser apresentada ao usuário e aprovada antes de integração.  
**Gate 1:** EM ANDAMENTO. W1-L1 e W1-L2 permanecem blockouts. Instalação, touch, safe areas, barras, FPS, memória, temperatura e lifecycle ainda carecem de validação Android física.  
**PR #72:** integrada por squash antes deste plano; teste determinístico de overflow do buffer de 600 amostras. Godot Validation `45969491642` e Android Debug Export `45969491660` SUCCESS no HEAD da PR. Isso não é profiling físico.

## Estado inicial das 32 etapas

| Etapa | Estado no checkpoint de adoção | Fundamentação |
|---:|---|---|
| 01 | VALIDADA (L2 documental/estático) | Auditoria histórica preservada; não equivale a QA físico |
| 02 | VALIDADA (L2 documental) | Requisitos, GAPs e conflitos documentais rastreados |
| 03 | VALIDADA (L2 documental) | Baseline arquitetural e contratos mapeados |
| 04 | VALIDADA (L2) | Boot, SceneFlow, SaveSystem, CampaignProgress e LoadingOverlay endurecidos |
| 05 | NÃO INICIADA | Nova etapa de direção de arte global |
| 06 | NÃO INICIADA | Guia técnico de assets a formalizar |
| 07 | NÃO INICIADA | Concept final de BOLT depende de produção e aprovação |
| 08 | NÃO INICIADA | Spritesheets finais dependem da Etapa 07 |
| 09 | NÃO INICIADA | Kit visual inicial de UI/HUD depende de aprovação |
| 10 | EM ANDAMENTO | BoltPlayer e componentes existem; personagem final ainda não consolidado |
| 11 | EM ANDAMENTO | Movimento, Dash e touch possuem base/testes; feel e Android físico pendentes |
| 12 | EM ANDAMENTO | Estados/feedback parciais; animações finais dependem de assets aprovados |
| 13 | EM ANDAMENTO | Camera2D e componentes espaciais existem; validação visual/device incompleta |
| 14 | EM ANDAMENTO | Vida, checkpoints, pickups e progressão parciais |
| 15 | EM ANDAMENTO | Componentes de inimigo-base existem; arquitetura completa não fechada |
| 16 | NÃO INICIADA | Produção visual de inimigos aguarda direção e aprovação |
| 17 | EM ANDAMENTO | Patrulha simples provisória; IA/arquetipagem incompletas |
| 18 | NÃO INICIADA | Dossiers/concepts dos sete chefes pendentes |
| 19 | NÃO INICIADA | Arenas e confrontos finais não identificados |
| 20 | EM ANDAMENTO | Blueprint de 42 fases existe; rastreabilidade/integração completa pendente |
| 21 | NÃO INICIADA | Concepts visuais dos sete mundos pendentes |
| 22 | NÃO INICIADA | Tilesets e kits finais não identificados; blockouts não contam como arte final |
| 23 | EM ANDAMENTO | W1-L1/W1-L2 em blockout; demais fases não construídas |
| 24 | EM ANDAMENTO | Componentes reutilizáveis existem; integração e exploração da campanha parciais |
| 25 | EM ANDAMENTO | Abertura/tutorial e progressão inicial existem; arco completo pendente |
| 26 | EM ANDAMENTO | Menu/HUD/Loading existem em estágio parcial; UX completa pendente |
| 27 | NÃO INICIADA | Áudio final de campanha não identificado |
| 28 | EM ANDAMENTO | Export Android CI existe; instalação, safe areas, barras e lifecycle físico pendentes |
| 29 | EM ANDAMENTO | Antiga Etapa 05 migrada; instrumentação/política documental integradas, baseline físico pendente |
| 30 | EM ANDAMENTO | CI/regressões existentes; QA integral 42 fases e validação física pendentes |
| 31 | NÃO INICIADA | Polimento final depende de conteúdo e arte aprovados |
| 32 | NÃO INICIADA | Release Candidate e auditoria final não iniciados |

Os estados são um snapshot inicial, não percentuais. Atualizar somente com evidências novas. A correspondência histórica 26→32 está documentada no plano mestre.

---

## Snapshot histórico — 2026-11-27 (pré-adoção das 32 etapas; pós-PR #70)

**Main HEAD:** `5e55fa1693d8ecf6d8a1d79bfffa1999824ad1ea`. PR #69 e PR #70 integradas por squash.
**Etapas:** 01–04 concluídas; Etapa 05 em desenvolvimento. Gate 1 permanece em andamento; W1-L1/W1-L2 seguem blockouts e QA Android físico permanece pendente.
**PR #69 — SceneFlow soft cancellation:** integrada em `a68d8c5e9b5575ae936d85d087e4d2d241e2c65d`. Cancelamento lógico opt-in; drena o carregamento threaded, não instala a cena de destino, restaura pause state e encerra o overlay. Não cancela I/O físico nem prova unload.
**PR #70 — PerformanceProbe:** integrada em `5e55fa1693d8ecf6d8a1d79bfffa1999824ad1ea`. Autoload debug-only; janela de 600 amostras, média/p95/p99/máximo de frame time, monitores de memória/objetos/nós/draw calls/process time; snapshot calculado sob demanda.
**CI PR #70:** Godot 45968533614 SUCCESS — 107 testes/1.933 verificações/0 falhas; Documentation 45968533594 SUCCESS; Android Debug Export 45968533542 SUCCESS. **CI pós-merge main:** Godot 45969003590 SUCCESS; Documentation 45969003654 SUCCESS; Android Debug Export 45969003728 SUCCESS. APK 28.209.643 bytes, assinatura v2/v3 verificada; SHA-256 do APK `4c2096d378a798f7df42735cf06a9dcb90330d8a6ae7a8ebf091ffd4a4ec74e9`; artifact ID 15183533835; digest SHA-256 do ZIP do artifact `b1f91a344044b62fae9d54e7a3e58c447701cb4fa924e0dabe6567c2a5cd9752`.
**Inventário de recursos:** baseline contém 20 arquivos de cena/recurso em `scenes/` e `resources/`, todos pequenos arquivos de texto Godot; não foram encontrados diretórios `assets/` ou `audio/` nem catálogo de texturas/áudio importados. W1-L1/W1-L2 permanecem blockouts com geometria/cores/controles provisórios.
**Política proposta nesta branch:** não introduzir preload global nem gerenciador genérico; manter SceneFlow threaded por cena, prewarm pontual do script MainMenu no Boot e liberação natural por referências/ownership. Não implementar purge/unload forçado sem evidência e ownership definido. Ver `technical/11-resource-lifecycle-policy.md`.
**Responsabilidade:** ChatGPT conduz arquitetura, sistemas centrais, integração, desempenho e qualidade. Claude está autorizado a desenvolver as cinco frentes de conteúdo em branch isolada/PR própria; não realizar escrita concorrente nos mesmos arquivos. Nenhuma entrega de conteúdo nova de Claude é presumida neste snapshot.
**Limites:** CI headless e APK exportado não comprovam FPS, RSS, GPU, latência touch, safe area, lifecycle OEM, temperatura ou estabilidade em aparelho. Nenhuma captura física foi realizada nesta unidade.

---

# Estado de produção — BOLT · AVENTURA

## Snapshot histórico — 2026-11-27 (plano anterior de 26 etapas)

**Main HEAD:** `4544efc7082a17e7824ccf46c524db07486e3dc9` — PRs #65, #66 e #67 integradas; PRs #59, #60 e #63 também permanecem na linha principal.
**Etapas:** 01–04 concluídas; Etapa 05 em desenvolvimento; etapas 06–26 conforme a matriz.
**Gate 0:** auditoria e alinhamento estáticos concluídos. **Gate 1:** em andamento; W1-L1 e W1-L2 continuam blockouts e a validação Android física permanece pendente.
**Responsável:** ChatGPT, único escritor ativo. Claude permanece inativo para escrita concorrente.
**Última entrega de gameplay:** PR #34 — W1-L2 Rede Interrompida em blockout, com campo energético cíclico e progressão W1-L1→W1-L2.
**Hardening integrado:** PR #59 (recuperação de save temporário/backup e proteção de formato futuro); PR #60 (liberação de input/touch na suspensão Android); PR #63 (Boot/cold-start, prewarm e transições threaded); PR #65 (IDs de fases concluídas duplicados rejeitados); PR #66 (integração real SceneFlow→LoadingOverlay); PR #67 (domínio CampaignProgress vazio/parcial rejeitado).
**PRs abertas e não integradas:** #57 (polimento visual Cybercore, revisão independente); #58, #61 e #62 (branches antigas/sobrepostas à PR #63; não integrar automaticamente); #1 (PR documental antiga e divergente; revisão independente antes de qualquer ação).
**Validação consolidada:** Godot 4.7.2 — 102 testes, 1.891 verificações, zero falhas; 20/20 cold boots headless; mutation test do prewarm aprovado. PRs #65–#67 e CI pós-merge main aprovados.
**CI pós-merge main:** Documentation Validation 45920441923 SUCCESS; Godot Validation 45920441898 SUCCESS; Android Debug Export 45920441894 SUCCESS.
**APK main:** 28.465.153 bytes; assinatura v2/v3 verificada; package ID provisório `com.example.boltaventura`; SHA-256 `cf6c96a48012a27d61db83354c777034ffe18c02fee8c2dd8c20e02acc1f0205`; artifact [bolt-aventura-android-debug-4544efc7082a17e7824ccf46c524db07486e3dc9](https://github.com/jyanzy19-yml/new-bolt-aventura/actions/runs/45920441894/artifacts/15164521585).
**Etapa 04:** CONCLUÍDA no nível L2 — contratos de Boot, SceneFlow, SaveSystem, CampaignProgress e integração do LoadingOverlay endurecidos e aprovados em CI. Isso não equivale a validação Android física.
**Próxima unidade:** Etapa 05 — auditoria de recursos/carregamento: cancelamento explícito, política de preload, descarregamento seletivo e medições de tempo/memória/frame time. Não alterar gameplay, schema v1, IDs persistentes, Dash, física ou canon sem escopo aprovado.
**Limites Android:** APK exportado em CI não significa instalado. Cold-start visual, touch físico/multitouch, safe areas, barras do sistema, lifecycle OEM, FPS, memória, temperatura e sessão prolongada ainda não foram medidos em aparelho.


**Atualização:** 2026-11-26  
**Main HEAD confirmado nesta unidade:** `54fd48e5f49fba877740265aafa0d8f649c2b1e9` (PRs #57/#58 permanecem abertas e não integradas).  
**Matriz operacional:** `docs/production/26-stage-traceability-matrix.md`, integrada pela PR #48. Registro de lacunas GAP-001…GAP-022 em elaboração na branch `docs/requirements-gap-register`; Etapa 02 continua em revisão requisito-a-requisito.  
**Última entrega de conteúdo de gameplay:** PR #34 — W1-L2 Rede Interrompida em blockout, campo energético cíclico e progressão persistente.  
**Última regressão de gameplay integrada:** PR #39 — limpeza do ActionBuffer no ciclo de vida Android, merge `50c9bfdd997edf0cb5cb7cfb22d246bd4d0beca2`.  
**Última entrega de infraestrutura integrada:** PR #38 — pipeline Android debug, merge `d08a2b203e525ccc98a4a0e45d1532b41e674fc5`.  
**Último componente de plataforma integrado:** PR #46 — `OneWayPlatform`, merge `8ecfe0aa11eb911745bbe5e8e1b2211c03010702`.  
**Última correção de gameplay integrada:** PR #47 — estado inicial do `TimedEnergyGate`, merge `2636226c4027625649e66c51ff64d7e2e56168a6`.  
**Branch de trabalho:** `main`; PR #47 integrada. Próxima branch deve ser criada somente para a unidade aprovada seguinte.  
**Responsável atual:** ChatGPT, único escritor ativo conforme decisão vigente do usuário.  
**Estado do Gate 1:** EM ANDAMENTO — W1-L1/W1-L2 seguem blockouts; APK debug exportado em CI, instalação e validação Android física pendentes.

**CI da PR #39:** Godot Validation `45881320136` SUCCESS — Godot 4.7.2, 72 testes, 451 verificações, 0 falhas; Docs Validation `45881320133` SUCCESS; Android Debug Export `45881252046` SUCCESS.  
**Artifact PR #39:** `bolt-aventura-android-debug-7415dfb988faf2dd63f9ff289106e7f7205dcdd1`, 28.194.534 bytes; package ID provisório `com.example.boltaventura`; assinatura v2/v3 verificada; SHA-256 `db03a42b909781a1f5e7c94d025615e1aa5f397c8ebd306ba30cddf84eca14b0`.
**PR #40:** reconciliação de Dash e autoridade do escritor integrada em `85412c3bdd5c6eefd27f25bf2a56af4b38fcdfed`; Docs CI PR `45882294553` e pós-merge main `45882348474`: SUCCESS.
**PR #43 CI:** Godot `45884348999` SUCCESS (78 testes/484 verificações/0 falhas), Docs `45884348954` SUCCESS, Android Export `45884348969` SUCCESS; artifact `bolt-aventura-android-debug-b6bf765bccdb80c2de0512655208060ab2fc1480`, SHA-256 `3dc8eba90dc3f914b1db725f50fbdc38bee9a16dee2c38d95b05f476a41cb212`.
**PR #43 pós-merge main:** Godot `45884671403`, Docs `45884671584`, Android Export `45884671259`: SUCCESS; artifact `bolt-aventura-android-debug-22923228d2a58c0ee6d75b581d5a16aa70e1a7ef`, APK 28.456.143 bytes, SHA-256 `3fc5ea209e88a69b3b33a7de9360dbc42d38dae9a2734eb38e103ab7f2478661`.
**PR #44 pós-merge main:** Godot `45885612259`, Docs `45885612332`, Android Export `45885612341`: SUCCESS; 81 testes/508 verificações/0 falhas; artifact `bolt-aventura-android-debug-88b753f3b28d6591642a044b76d2d1ec21ad0d73`, APK 28.456.143 bytes, SHA-256 `de37ec1b4330f1845eb434f079be92a3c83d661cbfc1aecfd431a9fe75a3fe2d`.
**PR #45 pós-merge main:** Godot `45886997248`, Docs `45886997138`, Android Export `45886997220`: SUCCESS; 85 testes/533 verificações/0 falhas; artifact `bolt-aventura-android-debug-b24c8624a8ed64816d0131070f440a47f525ba47`, APK 28.460.646 bytes, SHA-256 `3b3be5c8df067c000216bbc3e5ad39b357f0ea70ad3d3a5bc12625724873ffd1`.  
**PR #46 pré-merge:** Godot Validation `45887805114` SUCCESS — 87 testes/548 verificações/0 falhas; Docs Validation `45887805097` SUCCESS; Android Debug Export `45887805269` SUCCESS. Artifact `bolt-aventura-android-debug-f20ba8c94a4e1c205edba95fc12c3b3a2beac1cd`, 28.461.057 bytes; package ID provisório `com.example.boltaventura`; assinatura v2/v3 válida; SHA-256 `8211b6c46b17861f9859c62beed1f524a35f9d571838171034cb59cb8f02eb58`. **Pós-merge:** consulta de workflow runs para `8ecfe0aa11eb911745bbe5e8e1b2211c03010702` retornou zero execuções; portanto não há evidência de CI pós-merge neste momento.
**CI pós-merge main:** Godot `45881703643`, Docs `45881703650` e Android Export `45881703604`: SUCCESS. A execução da main repetiu 72 testes/451 verificações/0 falhas e gerou artifact `bolt-aventura-android-debug-50c9bfdd997edf0cb5cb7cfb22d246bd4d0beca2`; SHA-256 do APK `edb88f43f407241e5716d6b7d327272c22e40f1025a00637d7393573e320c6d7`.

## Estado executável observado

| Área | Estado | Evidência e limite |
|---|---|---|
| Projeto Godot | Implementado | `project.godot`, Godot 4.7.2 fixado em `.godot-version` |
| Android/paisagem | Configurado | Preset Android, orientação sensor landscape e política imersiva ADR-0003; APK debug exportado e assinatura verificada em CI; instalação física pendente |
| Inicialização/menu | Implementado parcialmente | Boot e menu com Nova Jornada/Continuar; retomada mapeia W1-L1 e W1-L2 quando a cena existe. CI pré e pós-merge da PR #34 passou; validação visual/Android pendente |
| SceneFlow/loading | Implementado parcialmente | Carregamento threaded, bloqueio de transições concorrentes e sinais; headless |
| Player/movimento | Implementado parcialmente | Corrida, salto variável, pulo duplo provisório, coyote, buffer e dash; parâmetros provisórios |
| Touch/multitouch | Implementado parcialmente | Controles por ponteiro, liberação de ações e regressão de reatribuição de índice; eventos sintéticos |
| Safe Area | Implementado parcialmente | Recalcula em resize/viewport e eventos de retomada/foco; comportamento real ainda não validado em Android |
| HUD | Implementado parcialmente | HUD de sandbox, pausa e resultado; layout provisório |
| Sandbox | Implementado | Cenário de desenvolvimento; **não é fase da campanha** |
| Campanha | Em andamento | Abertura/tutorial; W1-L1 em blockout com combate, checkpoint e persistência; W1-L2 em blockout com campo energético cíclico, checkpoint e objetivo. Conteúdo/arte/áudio finais e playtest humano pendentes |
| Combate/inimigos/chefes | Em andamento | Pistola Crono, inimigo-base de patrulha provisório, vida/dano, invulnerabilidade, feedback visual de impacto e coletável de cura. Sem chefes, IA avançada ou arsenal completo |
| Checkpoint/save | Em andamento | `SaveSystem` v1 + `CampaignProgress` v1; checkpoint persistente em W1-L1 e W1-L2; conclusão de W1-L1 avança o destino salvo para W1-L2. Persistência após encerramento e em Android físico ainda não testada |
| Assets finais/áudio | Não identificados como integrados | Placeholders de apresentação permanecem |

## Validação observada

- **Godot CI Run #45:** [SUCCESS](https://github.com/jyanzy19-yml/new-bolt-aventura/actions/runs/45808858828), commit da PR #3 `373d5170362ded16d7054aeacf3daeb6b649d751`. O job Godot e as etapas de importação condicional/análise de scripts concluíram com sucesso.
- **Docs CI Run #133:** [SUCCESS](https://github.com/jyanzy19-yml/new-bolt-aventura/actions/runs/45808858862), commit da PR #3.
- **Suíte anterior:** Godot CI #36 passou com 42 testes, 171 verificações e 0 falhas; essa evidência é anterior ao hardening PR #3 e não deve ser atribuída à Run #45 sem log que confirme execução do runner.
- Validação máxima comprovada: **G3 — exportação APK debug via GitHub Actions**, além de Godot/headless (L2).
- Godot local/editor gráfico/emulador: **NÃO EXECUTADO** nesta rodada.
- Exportação APK: **EXECUTADA** no run `45879045098`, assinatura v2/v3 verificada, artifact e SHA-256 registrados.
- Instalação Android, cold start, toque físico, barras/safe area em aparelho, FPS e memória: **NÃO EXECUTADOS**.

## Etapas e colaboração

| Etapa | Responsável | Estado | Entrega |
|---|---|---|---|
| 0 | Claude Code | ACCEPTED | Fundação + protótipo provisório; hardening complementar PR #3 integrado |
| 1 | ChatGPT | HANDOFF_READY | Correção de reatribuição de ponteiro, regressão e CI executando suíte |
| 2 | ChatGPT | IN_PROGRESS | PR #34 integrada (`c10ca69`); W1-L1→W1-L2, retomada e blockout W1-L2. Godot CI pré/pós-merge: 69 testes/439 verificações/0 falhas; Docs CI SUCCESS |
| 3 | ChatGPT | Aguardando | Próxima unidade após validação da Etapa 2 |

Um único escritor por vez. Por decisão do usuário, ChatGPT conduz sozinho as próximas etapas; Claude permanece inativo no fluxo de escrita.

## Pull requests

- [PR #35](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/35): MERGED — substitui chamada direta do handler por teste real de contato físico da `Area2D`; Godot CI pré/pós-merge: 69 testes/439 verificações/0 falhas.
- [PR #36](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/36): MERGED — feedback de ativação do checkpoint W1-L2; CI pré/pós-merge SUCCESS.
- [PR #37](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/37): MERGED — regressão física isolada do coletável e filtro de erro de física no CI.
- [PR #38](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/38): MERGED — pipeline Android debug; Godot, Docs e export SUCCESS, artifact publicado.
- [PR #39](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/39): MERGED — limpeza do ActionBuffer em notificações de pausa/suspensão/perda de foco; Godot 72 testes/451 verificações/0 falhas, Docs e export Android SUCCESS.
- [PR #40](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/40): MERGED — reconcilia decisão canônica de Dash e autoridade atual do escritor; Docs CI SUCCESS.
- [PR #41](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/41): MERGED — overlay persistente de carregamento; Godot 75 testes/470 verificações/0 falhas, Docs e Android export SUCCESS.
- [PR #42](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/42): MERGED — pausa da SceneTree e bloqueio integral de input durante loading; Godot 77 testes/479 verificações/0 falhas, Docs e Android export SUCCESS.
- [PR #43](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/43): MERGED — teste de restauração do pause state após falha; Godot 78 testes/484 verificações/0 falhas, Docs e export Android SUCCESS.
- [PR #44](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/44): MERGED — contratos de câmera e limites por fase; Godot 81 testes/508 verificações/0 falhas, Docs e Android export SUCCESS.
- [PR #45](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/45): MERGED — MovingPlatform reutilizável (AnimatableBody2D); Godot 85 testes/533 verificações/0 falhas, Docs e Android export SUCCESS.\n- [PR #46](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/46): MERGED — OneWayPlatform com colisão unidirecional nativa; pré-merge Godot 87 testes/548 verificações/0 falhas, Docs e Android export SUCCESS; sem integração em fase.\n- [PR #47](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/47): MERGED — corrige `initial_active=false` no TimedEnergyGate e adiciona regressão física; Godot pré/pós-merge 88 testes/553 verificações/0 falhas, Docs e Android export SUCCESS.\n- [PR #48](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/48): MERGED — matriz de rastreabilidade das 26 etapas; Docs CI pré-merge `45895024931` e pós-merge `45895074739` SUCCESS; alteração documental.\n- [PR #49](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/49): MERGED — reconcilia snapshots de continuidade/colaboração, tracker, prioridade da diretriz mestra e referências canônicas; Docs CI pré-merge `45895420328` e pós-merge `45895460895` SUCCESS.\n- [PR #50](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/50): MERGED — GAP-001…GAP-022, owners, dependências, P0 acceptance, ADR-0006 e reconciliação técnica; Docs CI `45896247264` SUCCESS no HEAD final da PR.\n- **Revisão documental adicional em main:** commit `13dc16625019f9f5c1351daee6ec63406eed4b59`, Docs CI `45896357977` SUCCESS; classificação explícita dos 22 GAPs.\n- [PR #51](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/51): MERGED — encerra Etapa 02 e adiciona mapa da arquitetura atual; Docs CI pré-merge `45896594068` e pós-merge `45896636445` SUCCESS.\n- [PR #52](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/52): MERGED — registra acoplamento Player/Combat e sincroniza status; Docs CI pré-merge `45896823250` e pós-merge `45896905043` SUCCESS.
- [PR #34](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/34): MERGED — W1-L2 Rede Interrompida, campo energético cíclico e progressão W1-L1→W1-L2; Godot CI pré-merge 69 testes/439 verificações/0 falhas; Docs CI SUCCESS.
- [PR #33](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/33): MERGED — expansão da diretriz de produção e correção do coletável de vida.

- [PR #4](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/4): MERGED — handoff Etapa 2 e sincronização documental.
- [PR #5](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/5): MERGED — auditoria integral e polimento da continuidade (Docs CI #140 SUCCESS).
- [PR #7](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/7): MERGED — reconciliação dos documentos raiz com o projeto Godot existente, continuidade e handoff (merge `b8def7a`; Docs CI #144/#145 SUCCESS).

- [PR #2](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/2): MERGED — melhorias de qualidade e especialistas.
- [PR #3](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/3): MERGED — hardening da fundação e governança.
- [PR #11](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/11): MERGED — auditoria documental, ADR-001-DASH e sincronização do handoff (squash `6f97ffc`; Docs CI #160 SUCCESS no HEAD da PR).
- [PR #1](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/1): permanece separada e divergente; não mesclar, fechar ou modificar automaticamente.

## Auditoria de polimento e reconciliação documental

- Auditoria abrangente anterior: [repository-polish-audit-2026-11-26.md](repository-polish-audit-2026-11-26.md), integrada pela PR #5.
- Revisão atual confirmou PR #1 OPEN, `mergeable_state=dirty`, 17 commits exclusivos; a comparação de 2026-11-26 após PR #9 indicava 138 commits de atraso. Consultar o compare atual antes de rebasear.; 17 arquivos modificados, todos documentais. Não contém gameplay. Não mesclar automaticamente.
- Documentos raiz foram identificados como obsoletos quanto à existência do projeto Godot. Esta rodada atualiza o mandato para continuar a base existente, sem recriá-la.
- Dash: decisão do usuário em 2026-11-26 resolvida e registrada em `ADR-001-DASH.md`; deve permanecer. Preservar implementação e testes; mudanças de tuning/controles exigem escopo próprio.
- GitHub confirmou `protected=false` para `main`. A integração não tem operação administrativa para ativar proteção/ruleset; o proprietário precisa configurar manualmente. Verificar também os filtros por caminhos antes de exigir checks específicos.

## Próximo gate executável

ChatGPT conduz a Etapa 2 por decisão explícita do usuário. A unidade de checkpoint/respawn local da sandbox foi integrada pela PR #13 (`09317a2c1b7c1113e7ff2f142a82b495998f7578`). A próxima unidade será selecionada a partir dos sistemas centrais ainda ausentes, sem tratar a sandbox como fase da campanha. Não tratar a sandbox como fase da campanha nem canonizar parâmetros provisórios. Exportação e Android físico permanecem gates de validação pendentes.

## Referências

- [Roadmap](roadmap.md)
- [Rastreador de implementação](implementation-tracker.md)
- [Estado da colaboração](COLLABORATION_STATE.md)
- [Continuidade](CONTINUITY.md)
- [Handoff Etapa 0](handoffs/HANDOFF_ETAPA_0.md)
- [Handoff Etapa 1](handoffs/HANDOFF_ETAPA_1.md)
- [Handoff Etapa 2 — Claude](handoffs/HANDOFF_ETAPA_2_CLAUDE.md)
- [Auditoria de hardening da Etapa 0](stage-0-hardening-audit.md)
- [Protocolo de qualidade](quality-control-protocol.md)


## Auditoria corretiva — snapshot após PR #10 (2026-11-26)

- HEAD confirmado: `1e5294cf112c014c21e43c51b4c8e797beceb9b6`.
- PR #1 permanece OPEN e não mergeável; compare atual: 17 commits exclusivos e 139 commits atrás. Os 17 arquivos continuam exclusivamente documentais.
- PRs #2–#10 estão integradas. A PR #10 é o último merge observado.
- Godot 4.7.2, GDScript, Android empacotado em paisagem; projeto real com cenas, scripts, recursos e testes.
- Nenhum defeito S0–S2 de gameplay foi confirmado pela inspeção estática focalizada nesta rodada. Isso não substitui execução Godot local nem teste físico.
- Dash deve permanecer por decisão explícita do usuário; ver `ADR-001-DASH.md`. A exclusão documental na PR #1 não integrada está superada.
- A validação CI deste novo snapshot deve ser registrada pela execução da PR desta auditoria; o status consultado para o HEAD atual não retornou checks.


## Decisão canônica sobre Dash — 2026-11-26

- **Decisão:** Dash deve permanecer no BOLT · AVENTURA, conforme confirmação explícita do usuário.
- **Fonte canônica:** [ADR-001-DASH.md](ADR-001-DASH.md). A exclusão na diretiva ainda não integrada da PR #1 está superada e não autoriza remover a mecânica.
- Preservar código, Input Map, controles touch e testes existentes. Alterações de física, cooldown, velocidade, duração, controles ou balanceamento exigem tarefa própria.
- Esta atualização é documental; não altera gameplay.

## Estado desta auditoria — PR #11 integrada

- PR #11 foi integrada por squash em `6f97ffc97219bb541e9f36a1c140331c2c621403`.
- Docs CI run #160 (ID `45825228812`) SUCCESS no HEAD `7412e49b27bf135fcaa566bcfce458d19de39cec`; job `Validate project documentation` e todas as etapas concluídos.
- A sincronização pós-merge está sendo registrada nesta PR documental separada. Godot CI não foi acionado por não haver alterações de gameplay. APK, emulador e Android físico continuam não executados.


## Execução solo — atualização de 2026-11-26

- O usuário definiu ChatGPT como único desenvolvedor ativo; Claude Code fica fora do fluxo de escrita até nova decisão.
- Etapa 2 em andamento na branch `feat/checkpoint-respawn-system`, baseada em `8c502efaee16a47a31303c77d0efbbd4c847a5e8`.
- Primeira unidade: checkpoint reutilizável e respawn local na sandbox. Não representa checkpoint de campanha nem persistência entre sessões.
- Godot CI #47 (run `45841375185`) passou no HEAD `4f89fa73f16cc28ed6e400fbcb26d81046d4864e`: importação Godot 4.7.2 e suíte headless com 43 testes, 179 verificações, 0 falhas. Docs CI #164 (`45841375193`) também passou. APK e Android físico continuam não executados. Nenhuma exportação APK ou validação em Android físico foi realizada.


## Pós-merge PR #13 — 2026-11-26

- PR #13 integrada por squash em `09317a2c1b7c1113e7ff2f142a82b495998f7578`.
- Godot CI #50 (`45841890027`) SUCCESS no merge: Godot 4.7.2, importação headless e suíte com 43 testes / 179 verificações / 0 falhas.
- Docs CI #167 (`45841889890`) SUCCESS no merge.
- Nenhuma exportação APK, instalação, emulador ou validação em Android físico foi realizada.


## Próxima entrega — entrada da campanha

- Menu principal → storyboard de abertura → tutorial jogável com robô mensageiro → blockout W1-L1 Cybercore.
- W1-L1 é blockout de gameplay em desenvolvimento, não fase concluída. Inimigos, combate, narrativa ambiental, assets finais, áudio, save/load e QA continuam pendentes.
- PR #15 integrada em `783c1d2587ebea39d645a641417e663e561ea710`; Godot CI #56 e Docs CI #175 SUCCESS. CI pós-merge #57/#176 em execução.


## Próxima unidade — combate básico

- Branch `feat/chrono-pistol-combat-core`, baseada no HEAD atual da main.
- Pistola Crono é a primeira arma conectada ao input lógico e ao botão touch TIRO. Valores permanecem provisórios.
- Alvo de treinamento estático valida vida/dano e o tutorial; não deve ser contabilizado como inimigo/arquétipo da campanha.
- Tríplice Prisma, Laser Nexo, seleção de armas, IA inimiga, dano ao jogador e validação física Android continuam pendentes.


## Pós-merge PR #17 — combate básico

- PR #17 integrada por squash em `33fe452d0a6aad2fc87ea19da789dfde9999c93a`.
- Godot CI #61 (`45846655204`) SUCCESS: Godot 4.7.2, 47 testes, 231 verificações, 0 falhas.
- Docs CI #182 (`45846655293`) SUCCESS.
- O primeiro loop de ataque está disponível no tutorial; o alvo é estático e exclusivo de treino, não um inimigo de campanha.
- Valores da Pistola Crono são provisórios. Tríplice Prisma, Laser Nexo, seleção de armas, IA inimiga, dano ao jogador e chefes permanecem pendentes.
- APK, emulador e Android físico ainda não testados.


## Atualização de gameplay — PR #19 (2026-11-26)

- Branch `feat/cybercore-enemy-player-damage`, baseada no HEAD integrado `e588c2f6a45cda0ec71b14dad815f2359569e3bf`.
- Entrega em revisão: inimigo-base provisório de patrulha em Cybercore W1-L1; vida/dano/knockback/invulnerabilidade para BOLT; restauração de vida no respawn; HUD de vida; tela de derrota.
- Testes adicionados em `tests/unit/test_enemy_combat.gd` para dano, invulnerabilidade, respawn, patrulha, contato e derrota por Pistola Crono.
- O inimigo não é um arquétipo canônico. Todos os parâmetros são provisórios; arte geométrica é placeholder.
- Preservados Dash, buffer de ações, controles touch e Pistola Crono.
- CI Godot PR #19: run `45848699004` estava em execução na última consulta. Nenhuma alegação de sucesso até o resultado final.
- APK/exportação, emulador, dispositivo Android, FPS e memória: NÃO EXECUTADOS.
- Handoff detalhado: [HANDOFF_ENEMY_COMBAT.md](handoffs/HANDOFF_ENEMY_COMBAT.md).


## Pós-merge PR #19 — 2026-11-26

- PR #19 integrada por squash em `96bf49a659fecc3ca280ceb140613add808dcdda`.
- Godot Validation da PR #19: run `45848858668` SUCCESS em Godot 4.7.2; import/parse headless aprovado; suíte com **50 testes, 252 verificações, 0 falhas**.
- Docs Validation da PR #19: run `45848858475` SUCCESS.
- CI pós-merge main: Godot run `45849033538` e Docs run `45849033502` estavam em execução no momento da atualização; verificar resultados finais antes de declarar main validada.
- Conteúdo: inimigo-base de patrulha provisório em W1-L1, dano/knockback/invulnerabilidade para BOLT, restauração de vida no respawn, HUD de vida e tela de derrota.
- Dash, ActionBuffer, controles touch e Pistola Crono preservados. Inimigo e parâmetros continuam protótipos, não canon.
- Handoff: [HANDOFF_ENEMY_COMBAT.md](handoffs/HANDOFF_ENEMY_COMBAT.md).
- APK/exportação, instalação, emulador, aparelho Android, FPS e memória: NÃO EXECUTADOS.


## Pós-merge PR #21 — recuperação e feedback de combate (2026-11-26)

- PR #21 integrada por squash em `b2e66d9638d367cce29b266d75f230cb16ed1763`.
- Godot Validation PR #21: run `45849915250` SUCCESS, Godot 4.7.2, import/parse headless aprovado, **53 testes, 276 verificações, 0 falhas**.
- Entrega: `BoltHealth.restore(amount)` com limite de vida máxima; `BoltPlayer.heal(amount)`; coletável `BoltHealthPickup` que só é consumido quando a cura funciona; flash de impacto temporário no inimigo; coletável posicionado no blockout W1-L1.
- Primeiro CI da PR #21 falhou por referência visual não marcada como única e regressões de contato; correção aplicada e segunda execução passou. Não ocultar o primeiro resultado: a revisão foi corrigida antes do merge.
- O coletável e seus parâmetros são protótipos, não sistema final de inventário/recompensas. Feedback usa placeholder geométrico.
- Dash, ActionBuffer, controles touch, Pistola Crono, invulnerabilidade e fluxo de derrota preservados.
- APK/exportação, instalação, emulador, aparelho Android, FPS e memória: NÃO EXECUTADOS.
- Handoff: [HANDOFF_HEALTH_PICKUP_FEEDBACK.md](handoffs/HANDOFF_HEALTH_PICKUP_FEEDBACK.md).


## W1-L1 — correção de layout e integração (PR em revisão)

- Inimigo-base reposicionado integralmente sobre o piso intermediário; patrulha reduzida para permanecer dentro da plataforma.
- Área de conclusão reposicionada para sobrepor a faixa ocupada pelo jogador quando está sobre o piso final.
- Teste de integração ampliado para conferir layout, ativação do checkpoint, dano e retorno após queda.
- A primeira execução Godot CI (`45851338093`) falhou por uma asserção de teste que exigia posição X estática apesar do movimento de patrulha no primeiro tick; a asserção foi corrigida para verificar a faixa válida da patrulha. Aguardar nova execução.
- Esta alteração corrige o blockout; não representa playtest humano, balanceamento final nem validação Android.


## Incremento W1-L1 — feedback de progressão e validação dos gatilhos

- Base confirmada: main `13105c5422b73e2c362bdf3d4ce9eea45c97fc99`; PR #23 pós-merge Godot run `45851700830` SUCCESS e Docs run `45851700746` SUCCESS.
- HUD recebe notificação temporizada para eventos de progressão, sem polling por frame: ativação do checkpoint e recuperação de vida.
- W1-L1 conecta o sinal real do coletável ao HUD; a saída continua usando o resultado de trecho existente.
- Teste de integração foi ampliado para entrar fisicamente nas áreas de checkpoint, queda, coletável e objetivo, em vez de invocar diretamente os handlers de respawn.
- Geometria mantida após confirmar que `PlatformBlock` usa origem no canto superior esquerdo e que a saída já está dentro do piso final. Nenhuma alteração geométrica especulativa.
- Branch: `feat/w1-l1-progression-feedback`. Validação CI desta branch pendente.
- Limites: protótipo visual e valores continuam provisórios; sem playtest humano, APK, instalação, emulador, aparelho Android ou métricas de performance.

- Segurança de respawn: checkpoint reposicionado em x=980 para manter folga além do alcance horizontal máximo do inimigo; teste calcula a distância mínima com base nas formas de colisão reais. CI do SHA final ainda pendente.


## Pós-merge PR #24 — W1-L1 progress feedback — 2026-11-26

- PR #24 integrada por squash em `532320ec9c5b3507d880717e4437603a984b7808`.
- Godot CI pré-merge no HEAD final da PR: run `45854657846` SUCCESS — Godot 4.7.2, import/parse headless aprovado, **53 testes, 296 verificações, 0 falhas**.
- Docs CI pré-merge: run `45854657850` SUCCESS. Pós-merge main: Godot run `45854849226` SUCCESS; Docs run `45854849212` SUCCESS.
- HUD agora comunica ativação do checkpoint e recuperação com notificação temporizada. Testes atravessam checkpoint, queda/respawn, coletável e objetivo por áreas físicas reais.
- Checkpoint em x=980; teste calcula folga em relação ao limite da patrulha e às dimensões das formas de colisão do player/inimigo.
- W1-L1 permanece **Em andamento**. Próximo incremento: comprovar no teste de integração que o input ATTACK e a Pistola Crono atingem o inimigo real instanciado na fase.
- Sem playtest humano, export APK, instalação, emulador, aparelho Android ou medições de performance.


## Pós-merge PR #25 — combate real de W1-L1 — 2026-11-26

- PR #25 integrada por squash em `92b35d52723f5fa1b05a8e53921a2d8605c6f1cf`.
- Godot CI pré-merge run `45855173247` SUCCESS — Godot 4.7.2, **53 testes, 298 verificações, 0 falhas**; Docs CI `45855173229` SUCCESS.
- Teste de integração agora percorre ATTACK → ActionBuffer → BoltCombat → ChronoProjectile → CybercorePatrolEnemy e verifica `hit_received`/redução da vida do inimigo real da fase.
- CI pós-merge main: Godot run `45855371627` / `45855463491` e Docs run `45855371706` / `45855463599`; consultar os resultados finais antes de declarar a main pós-merge validada.
- Próximo incremento: cobrir derrota e ligação do botão de reinício da W1-L1; branch `test/w1-l1-defeat-retry-flow`.
- W1-L1 continua **Em andamento**; sem playtest humano, APK, instalação, emulador, aparelho Android ou medições de performance.


## Pós-merge PR #26 — derrota e retry W1-L1 — 2026-11-26

- PR #26 integrada por squash em `3428851c774f989d3522da1ed0430e9d39f7a680`.
- Godot CI pré-merge run `45855625278` SUCCESS — Godot 4.7.2, import/parse headless aprovado, **54 testes, 304 verificações, 0 falhas**.
- Docs CI pré-merge run `45855625442` SUCCESS.
- CI pós-merge main: Godot run `45855795164` SUCCESS — 54 testes, 304 verificações, 0 falhas; Docs run `45855795173` SUCCESS.
- Teste novo aplica dano letal em BOLT na W1-L1 e verifica overlay/título de derrota, conexão do botão `JOGAR DE NOVO` e destino de retry para a própria W1-L1.
- Nenhuma regra de vida, checkpoint, respawn, dano, invulnerabilidade ou SceneFlow foi alterada.
- W1-L1 permanece **Em andamento**: blockout/arte e áudio finais, save/load de campanha, playtest humano e QA Android ainda não concluídos.


## SYS-015 — fundação de armazenamento versionado (branch `feat/versioned-save-storage-foundation`)

- Novo autoload `SaveSystem` com API `save_payload`, `load_payload`, `has_save` e `delete_save`.
- Envelope JSON versão 1, checksum SHA-256, validação de tipos serializáveis, arquivo temporário, backup e recuperação quando o arquivo principal está ausente/inválido.
- Dados de domínio continuam pertencendo aos produtores; nenhum estado de checkpoint/campanha foi conectado ainda. `SYS-014` e W1-L1 permanecem Em andamento.
- Testes headless cobrem round-trip, sobrescrita, delete, recuperação do backup, versão futura incompatível e rejeição de referências a Nodes. CI desta branch pendente.
- Sem teste de interrupção real, Android físico, APK, emulador, desempenho ou armazenamento OEM.


## Integração CampaignProgress — W1-L1 (branch `feat/w1-l1-persistent-checkpoint-progress`)

- Define schema de domínio `campaign_progress` v1 sob o payload genérico de SaveSystem, preservando campos de outros domínios.
- IDs técnicos: campanha `main`, nível `W1-L1`, checkpoint `cybercore_w1_l1_checkpoint`.
- Ativação do checkpoint grava current_level_id + active_checkpoint_id; reentrada restaura o indicador e ponto de respawn sem reemitir o sinal.
- Objetivo marca W1-L1 em completed_level_ids e limpa o checkpoint ativo; não transiciona para W1-L2 inexistente.
- ADR-0004 registra a decisão técnica. Testes cobrem schema, preservação de payload, reentrada de cena e conclusão. CI desta branch pendente.
- Limite: sem validação de encerramento forçado, APK, emulador, Android físico, filesystem OEM ou performance de I/O.


## Pós-merge PR #29 — persistência W1-L1 — 2026-11-26

- PR #29 integrada por squash em `44d9e0fcda68200579506b909c8920d4692cdc84`.
- Godot CI pré-merge `45859492456` SUCCESS — Godot 4.7.2, **62 testes, 369 verificações, 0 falhas**; Docs CI `45859492355` SUCCESS.
- `CampaignProgress` mantém schema v1 sob `campaign_progress`, preserva campos não relacionados do payload e usa IDs estáveis.
- W1-L1 grava checkpoint na ativação física, restaura o indicador e posição de BOLT na reentrada e marca conclusão ao alcançar a saída.
- CI pós-merge main: Godot run `45859653809` e Docs run `45859653966`; consultar os resultados finais antes de fechar o registro pós-merge.
- Limites: sandbox e outras fases não usam CampaignProgress; sem teste de encerramento forçado, Android físico, APK, emulador, filesystem OEM ou benchmark de I/O.


## Pós-merge PR #31 — Nova Jornada / Continuar — 2026-11-26

- **Main HEAD:** `42b60c06615c1d1bd8059e315f34fcedcff04d81`.
- **PR #31:** integrada por squash; menu oferece Nova Jornada e Continuar.
- **Comportamento:** Nova Jornada redefine apenas `campaign_progress` e segue abertura/tutorial; Continuar só aceita W1-L1 quando a cena existe e abre a fase diretamente.
- **Persistência:** W1-L1 registra `current_level_id` ao entrar; reentrada na mesma fase preserva checkpoint.
- **Falhas de save:** save ausente/incompatível/corrompido não bloqueia Nova Jornada; envelope ilegível não é apagado automaticamente e pode deixar a sessão sem persistência.
- **CI pré-merge:** Godot run `45862187355` SUCCESS — 66 testes, 404 verificações, 0 falhas; Docs run `45862187418` SUCCESS.
- **CI pós-merge:** Godot run `45862459941` SUCCESS — 66 testes, 404 verificações, 0 falhas; Docs run `45862459947` SUCCESS.
- **Limites:** W1-L2 não existe nem foi presumida; W1-L1 continua Em andamento. Sem editor gráfico, APK, emulador, Android físico, encerramento forçado ou benchmark.
- **Observação preexistente:** log do teste de coletável registra alteração síncrona de `Area2D.monitoring` durante `body_entered`; o mesmo erro aparece no CI anterior `45859653809`, portanto não foi introduzido pela PR #31. Correção fica como tarefa separada.


## Unidade corretiva em andamento — feedback de checkpoint W1-L2 (2026-11-26)

- **Branch:** `fix/w1-l2-checkpoint-feedback`, criada a partir de `main` após PR #35.
- **Diagnóstico confirmado:** W1-L2 só chamava `show_progress_notification("CHECKPOINT ATIVADO")` quando `CampaignProgress.save_checkpoint` falhava; no caminho normal de sucesso, o jogador não recebia feedback. W1-L1 já exibe a notificação após a ativação.
- **Correção aplicada na branch:** a notificação passa a ser exibida após a ativação, mantendo o warning exclusivo para falha de persistência.
- **Regressão adicionada:** `tests/unit/test_w1_l2_progression.gd` verifica visibilidade e texto do feedback.
- **Plano:** [w1-l2-checkpoint-feedback](plans/2026-11-26-w1-l2-checkpoint-feedback.md).
- **Estado:** implementação registrada; CI da nova branch/PR ainda não executada ou confirmada. Não integrar até Godot CI e Docs CI passarem.
- **Limites:** nenhuma validação local, APK, emulador, Android físico, toque físico ou profiling nesta unidade.


---

## Snapshot operacional — plano de execução em 26 etapas (2026-11-26)

**Base atualizada:** `main` após PR #46, commit `8ecfe0aa11eb911745bbe5e8e1b2211c03010702`; snapshot documental mais recente `b48553312b2295af618c6900ec8a26688743f095`.  
**Última unidade integrada:** PR #46 — OneWayPlatform.  
**CI pré-merge PR #46:** Godot Validation `45887805114` SUCCESS (87 testes/548 verificações/0 falhas), Docs Validation `45887805097` SUCCESS e Android Debug Export `45887805269` SUCCESS.  
**CI pós-merge PR #46:** Godot `45888110305`, Docs `45888110285` e Android Export `45888110166`: SUCCESS; Godot 87 testes/548 verificações/0 falhas; APK 28.461.057 bytes, SHA-256 `ea16a92eb28d206f00b7c06a795730a69cfb04c8b4c1cd8179275400713a1e97`, assinatura v2/v3 válida.  
**PR #47 pré-merge:** Godot `45894563021` SUCCESS — 88 testes/553 verificações/0 falhas; Docs `45894562989` SUCCESS; Android Debug Export `45894563000` SUCCESS. APK 28.461.057 bytes, SHA-256 `4f5ab64b2c51aaa2c69656854d10e056b4a4881b2f00b1bfb56279bbe5bf0884`, assinatura v2/v3 válida, artifact `bolt-aventura-android-debug-fc0497e94781dd4ec9357190dd43277c14e67c2b`. **CI pós-merge PR #47:** Godot `45894802128`, Docs `45894802067` e Android Export `45894802116`: SUCCESS; Godot 88 testes/553 verificações/0 falhas; APK 28.461.057 bytes, SHA-256 `c3ca03958eecf120f1a9f5f1e4fae3851fb7560bca303c8eb5a930f987b58123`, assinatura v2/v3 válida; artifact `bolt-aventura-android-debug-2636226c4027625649e66c51ff64d7e2e56168a6`.

### Estado das 26 etapas

| Etapa | Área | Estado | Evidência / lacuna principal |
|---:|---|---|---|
| 01 | Auditoria integral do repositório | CONCLUÍDA — estática | Inventário recursivo de 288 arquivos; revisão manual das 19 cenas, 30 scripts runtime, recurso BoltTuning, configuração Android, fontes mestras, ADRs, PRs e branches. CI compila scripts e instancia cenas; 88 testes/553 verificações passaram na PR #47. Limites físicos Android permanecem nos Gates 1/5, não bloqueiam o fechamento da auditoria estática |
| 02 | Requisitos e planejamento | CONCLUÍDA — rastreabilidade e planejamento | Matriz `26-stage-traceability-matrix.md` integrada pela PR #48; registro GAP-001…GAP-022 e conflitos DOC-001…DOC-011 integrado; revisão requisito-a-requisito, classificação, owners, dependências e critérios P0 concluídos |
| 03 | Arquitetura e organização | CONCLUÍDA — baseline estático | Quatro autoloads, fluxos de boot/menu/campanha, ownership, persistência, player/combat, HUD/touch e plataformas mapeados; nenhum ciclo de autoload/serviço identificado; acoplamento local BoltPlayer↔BoltCombat documentado como exceção consciente; sem migração estética |
| 04 | Infraestrutura e sistemas centrais | CONCLUÍDA — hardening automatizado L2 | Boot/cold-start e transições threaded (PR #63); recuperação de save e formatos futuros (PR #59); domínio CampaignProgress com duplicidades e campos ausentes/vazios rejeitados (PRs #65/#67); integração real SceneFlow→LoadingOverlay (PR #66). Godot 4.7.2: 102 testes/1.891 verificações/0 falhas; 20/20 cold boots e mutation test aprovados. Validação física permanece nos Gates 1/24/25 |
| 05 | Recursos e carregamento | EM DESENVOLVIMENTO | SceneFlow threaded e LoadingOverlay integrados; progresso real, input lock e ciclo de exibição/ocultação validados em teste headless real (PR #66); cancelamento explícito, política de preload, descarregamento seletivo e medição de memória/frame time pendentes |
| 06 | Personagem principal | EM DESENVOLVIMENTO | BoltPlayer e BoltTuning provisório; arte/animações finais e validação humana pendentes |
| 07 | Física e movimentação | EM DESENVOLVIMENTO | Corrida, salto, pulo duplo provisório, coyote, buffer, Dash e colisões; feel e Android físico não validados |
| 08 | Animações e feedback | EM DESENVOLVIMENTO | Feedback HUD e hit flash; pipeline de animação final ainda não implementado |
| 09 | Câmera e sistemas espaciais | EM DESENVOLVIMENTO | Camera2D e limites de blockout; revisão visual em proporções/dispositivos pendente |
| 10 | Interações e sobrevivência | EM DESENVOLVIMENTO | Vida, dano, invulnerabilidade, derrota, retry, checkpoints e cura parcial |
| 11 | Arquitetura de combate | EM DESENVOLVIMENTO | BoltHealth, BoltCombat, projéteis e alvo/inimigo provisórios |
| 12 | Armas e arsenal | EM DESENVOLVIMENTO | Pistola Crono conectada; demais armas, seleção e balanceamento pendentes |
| 13 | Arquitetura de inimigos | EM DESENVOLVIMENTO | Inimigo-base de patrulha Cybercore; arquétipos canônicos e variedade pendentes |
| 14 | Inteligência artificial | EM DESENVOLVIMENTO | Patrulha simples provisória; percepção e comportamentos avançados pendentes |
| 15 | Chefes e confrontos | NÃO INICIADA | Nenhum chefe/arena implementado |
| 16 | Arquitetura de mundos e fases | EM DESENVOLVIMENTO | Atlas de 42 fases e fluxo de campanha; gerenciamento global de conteúdo ainda parcial |
| 17 | Construção dos mundos | EM DESENVOLVIMENTO | Cybercore em blockout; mundos 2–7 sem ambientes executáveis |
| 18 | Construção das fases | EM DESENVOLVIMENTO | W1-L1 e W1-L2 em blockout; demais fases sem cenas |
| 19 | Obstáculos e exploração | EM DESENVOLVIMENTO | Checkpoint, coletável, campo energético, MovingPlatform e OneWayPlatform integrados como componentes; PR #47 corrige estado inicial inativo do campo energético; 88 testes/553 verificações passaram pré-merge; sem integração de plataformas móveis/unidirecionais em fase; segredos/rotas opcionais pendentes |
| 20 | Narrativa e progressão | EM DESENVOLVIMENTO | Premissa/canon, abertura, tutorial e progressão W1-L1→W1-L2 parciais; campanha narrativa incompleta |
| 21 | Interface e UX | EM DESENVOLVIMENTO | Menu, HUD, pausa, controles touch e overlay de carregamento básico; lock de input durante transição em validação; configurações, polimento visual e validação Android pendentes |
| 22 | Arte e efeitos visuais | EM DESENVOLVIMENTO | Placeholders geométricos e feedback básico; arte final e pipeline de assets pendentes |
| 23 | Áudio e apresentação | NÃO INICIADA | Música, SFX, buses e opções de áudio não integrados |
| 24 | Android e touchscreen | EM DESENVOLVIMENTO | Preset e pipeline Android debug integrados; APK exportado/assinado/verificado em CI; instalação, touch, safe area e lifecycle físico pendentes |
| 25 | Otimização e garantia de qualidade | EM DESENVOLVIMENTO | Godot headless, regressões e export Android automatizado; profiling CPU/GPU/memória, sessões longas e QA físico pendentes |
| 26 | Polimento e consolidação final | NÃO INICIADA | Produto ainda é protótipo técnico/blockout, sem campanha completa ou release candidate |

**Regra de interpretação:** nenhuma etapa foi marcada como CONCLUÍDA neste baseline. “EM DESENVOLVIMENTO” indica existência de implementação parcial, não aprovação final. O status deve ser atualizado somente com evidência do branch/commit atual.

### Pós-merge PR #36 — feedback de checkpoint W1-L2

- Merge commit: `afea046b6a481d48299641c9d8e529f6288d5256`.
- PR #36 integrada por squash após Godot e Docs CI pré-merge SUCCESS.
- CI pós-merge: Godot run `45877649854` SUCCESS; Docs run `45877649923` SUCCESS.
- A notificação de ativação do checkpoint agora aparece também no caminho de salvamento bem-sucedido; a regressão verifica visibilidade e texto.
- W1-L2 permanece blockout. Nenhum teste local, APK, emulador ou Android físico foi realizado.

### Unidade seguinte em andamento — contato físico do coletável

- Branch: `test/health-pickup-physical-contact`.
- Diagnóstico: teste anterior chamava `_on_body_entered` diretamente e não comprovava a detecção real de `Area2D.body_entered`.
- A implementação atual usa `set_deferred("monitoring", false)`; o objetivo desta unidade é proteger o caminho físico e detectar o erro de mutação de física bloqueada no log.
- Teste de sobreposição física e filtro CI direcionado estão na branch; CI da PR ainda pendente.
- Plano: [health-pickup-physical-contact](plans/2026-11-26-health-pickup-physical-contact.md).


### Pós-merge PR #37 — regressão isolada do coletável

- Merge commit: `39b6db8298542c5057c06f509b20d250a888e289`.
- Godot CI pré e pós-merge SUCCESS; Docs CI pré e pós-merge SUCCESS.
- Precisão de cobertura: `tests/unit/test_campaign_entry.gd` já exercitava o coletável por contato físico real no fluxo W1-L1. PR #37 acrescentou cobertura isolada em `test_enemy_combat.gd`, com verificação de cura, quantidade, emissão única e consumo; não foi a primeira cobertura física do coletável.
- O workflow Godot agora também procura o erro específico de mutação de estado físico bloqueada durante sinais/flush de queries.

### Próxima unidade — exportação Android debug

- Branch: `ci/android-debug-export`, baseada em `39b6db8298542c5057c06f509b20d250a888e289`.
- Preset existente preservado; package ID placeholder mantido.
- Pipeline usa Godot/editor templates pareados, JDK 17, Android SDK, chave debug efêmera, testes headless e verificação de assinatura/hash.
- **Estado:** implementação na branch; execução e artefato ainda pendentes.
- Plano: [android-debug-export-pipeline](plans/2026-11-26-android-debug-export-pipeline.md).


### Pós-merge PR #38 — exportação Android debug

- Merge commit: `d08a2b203e525ccc98a4a0e45d1532b41e674fc5`.
- Godot Validation `45879045282` SUCCESS; Docs Validation `45879045081` SUCCESS; Android Debug Export `45879045098` SUCCESS.
- Artefato publicado: `bolt-aventura-android-debug-5be706c042fceaa66dadf2509ffafd0833ad3617`, 28.194.385 bytes.
- Log confirma Godot 4.7.2, assinatura APK v2/v3 válida, package ID provisório `com.example.boltaventura`, SHA-256 `acbacb86afeb767e293ba357d6749db4bdde55c2d78c05f90779dafc5f438fab`.
- A execução de export ocorreu no commit da PR `500f29299a869913664c58331db11a45d4e4dbee`; o merge incorporou o workflow. Não houve instalação ou teste físico do APK.

### Unidade em validação — ActionBuffer e ciclo de vida Android

- Branch: `fix/action-buffer-lifecycle-clear-v2`, baseada no merge PR #38.
- Achado: edges de input pendentes não eram explicitamente limpos pelo próprio `ActionBuffer` em pausa/suspensão/perda de foco.
- Implementação: limpar buffer nas notificações de ciclo de vida; testes cobrem perda de foco e suspensão.
- Plano: [action-buffer-lifecycle-clear](plans/2026-11-26-action-buffer-lifecycle-clear.md).
- **Estado:** implementação escrita; aguardando Godot CI e Docs CI. Não validado em Android físico.


### Unidade em desenvolvimento — overlay persistente de carregamento

- Branch: `feat/scene-loading-overlay`, base main `85412c3bdd5c6eefd27f25bf2a56af4b38fcdfed`.
- Achado: `SceneFlow` já carrega cenas em thread e emite sinais, mas não havia overlay persistente ligado aos sinais.
- Implementação: novo autoload `LoadingOverlay`, cena `scenes/ui/loading_overlay.tscn`, progresso exibido somente quando `ResourceLoader` informa valor real; falha e sucesso ocultam a interface.
- `SceneFlow` passa a processar transições mesmo com a árvore pausada.
- Não há espera artificial mínima; cancelamento e preload avançado permanecem pendentes.
- Plano: [scene-loading-overlay](plans/2026-11-26-scene-loading-overlay.md).
- **Estado:** implementação escrita; aguardando Godot CI e Docs CI. Validação visual e Android físico pendentes.


### Pós-merge PR #41 — overlay de carregamento

- Merge commit: `66b3c0e060762ebe1f3c4b6af84c84a79f0cd781`.
- Godot CI `45883137849`: SUCCESS — 75 testes/470 verificações/0 falhas.
- Docs CI `45883137856`: SUCCESS.
- Android Debug Export `45883137961`: SUCCESS; artifact `bolt-aventura-android-debug-66b3c0e060762ebe1f3c4b6af84c84a79f0cd781`, APK 28.456.143 bytes, package ID placeholder, SHA-256 `5c630ba464bdd34617aface29e86da721eb1b9578f5f82d717b15b619941f213`.
- O overlay foi integrado; a revisão seguinte encontrou que GUI capture não bloqueava teclado. A branch `fix/scene-flow-input-lock` está fechando o bloqueio integral e a restauração em falha.


### Unidade atual — teste da restauração de pausa após falha

- Branch: `test/scene-flow-failure-pause-restoration`, base `68b677aa7860894928a690861ef63b300f8175fb`.
- Cobertura adicional para falha de transição iniciada a partir de estado pausado e despausado.
- **Estado:** implementação escrita; aguardando CI.


### Unidade atual — contratos da câmera 2D

- Branch: `test/camera-contracts`, base main `22923228d2a58c0ee6d75b581d5a16aa70e1a7ef`.
- Achado: a câmera já estava configurada com Camera2D nativa e limites por fase, mas a aplicação dos limites não tinha testes dedicados.
- Alteração: extração de `configure_camera()` nos scripts W1-L1/W1-L2; teste de smoothing/drag/callback físico e limites exatos de cada fase.
- Plano: [camera-contracts](plans/2026-11-26-camera-contracts.md).
- **Estado:** implementação escrita; aguardando CI. Não altera zoom, tuning ou física.


### Unidade atual — plataforma móvel reutilizável

- Branch: `feat/moving-platform-system`, base main `88b753f3b28d6591642a044b76d2d1ec21ad0d73`.
- Motivação: gameplay systems documenta plataformas móveis; o W1-L3 proposto no blueprint prevê esse obstáculo, mas a implementação ainda não existe.
- Diretriz: componente `AnimatableBody2D` sincronizado com física, movimento ping-pong determinístico e sem aplicar velocidade do player duas vezes.
- Estado: em desenvolvimento; não será inserido em fase até validar transporte/colisão em testes.


### Unidade atual — plataforma unidirecional

- Branch: `feat/one-way-platform`, base main `b24c8624a8ed64816d0131070f440a47f525ba47`.
- Motivação: o contrato de gameplay prevê plataformas unidirecionais; o sistema ainda não existia.
- Diretriz: StaticBody2D com CollisionShape2D.one_way_collision e direção local DOWN; permitir subir através da plataforma e aterrissar por cima.
- Estado: em desenvolvimento; não integrar em fase até validar testes de passagem e aterrissagem.


### Unidade atual — OneWayPlatform

- Branch `feat/one-way-platform`, base `b24c8624a8ed64816d0131070f440a47f525ba47`.
- `OneWayPlatform` estende `PlatformBlock`, usa `one_way_collision=true` e direção bloqueada `Vector2.DOWN`.
- Testes: propriedades da shape, aterrissagem por cima e passagem ascendente por baixo.
- Plano: [one-way-platform](plans/2026-11-26-one-way-platform.md).
- **Estado:** implementação escrita; aguardando CI.
\n\n## Sessão ChatGPT — OneWayPlatform integrada — 2026-11-26\n\n- PR #46 integrada por squash em `8ecfe0aa11eb911745bbe5e8e1b2211c03010702`.\n- `OneWayPlatform` estende `PlatformBlock`, usa `CollisionShape2D.one_way_collision=true` e direção `Vector2.DOWN`; margem default de 2 px permanece provisória.\n- Testes headless cobrem configuração da shape, passagem ascendente e aterrissagem descendente: Godot 4.7.2, 87 testes/548 verificações/0 falhas; Docs CI e Android Debug Export SUCCESS antes do merge.\n- APK pré-merge: 28.461.057 bytes, assinatura v2/v3 válida, package ID placeholder `com.example.boltaventura`, SHA-256 `8211b6c46b17861f9859c62beed1f524a35f9d571838171034cb59cb8f02eb58`.\n- Não integrada em W1-L1/W1-L2; nenhuma alteração no controller, física-base, Dash ou plataforma sólida.\n- CI pós-merge main, playtest visual, instalação e validação Android física ainda não confirmados.\n

## Atualização de continuidade — 2026-11-26 (ChatGPT)

- PR #46 está integrada em `main` (`8ecfe0aa11eb911745bbe5e8e1b2211c03010702`); a branch `feat/one-way-platform` não é mais branch de trabalho.
- Consulta ao endpoint de workflow runs do commit de merge retornou lista vazia. Não afirmar CI pós-merge; as evidências disponíveis são exclusivamente pré-merge (87 testes/548 verificações, Docs e Android Export SUCCESS).
- A revisão estática desta sessão cobriu `BoltPlayer`, `TouchControls`, `TouchButton`, `PlatformBlock`, `MovingPlatform`, `OneWayPlatform`, W1-L1 e testes de movimento/toque/plataforma. Isso não substitui execução local nem auditoria de todos os arquivos.
- Próximo passo obrigatório: concluir inventário/auditoria do repositório e reconciliar o tracker de 26 etapas com o roadmap canônico antes de iniciar uma nova feature de gameplay.


### Atualização do snapshot de 26 etapas — 2026-11-26 (após PR #46)

- A base anterior `afea046b6a481d48299641c9d8e529f6288d5256` estava obsoleta. A base de gameplay atual é `8ecfe0aa11eb911745bbe5e8e1b2211c03010702`; o HEAD documental após reconciliação é registrado no histórico Git.
- A PR #46 foi integrada por squash. `SYS-026`/Etapa 19 deixa de ser “aguardando CI” e passa a componente integrado, com evidência apenas pré-merge: Godot 87 testes/548 verificações/0 falhas, Docs SUCCESS e Android Debug Export SUCCESS. Não há execução pós-merge registrada.
- O inventário recursivo atual contém 288 arquivos: 56 `.gd`, 19 `.tscn`, 1 `.tres`, 20 testes unitários (`tests/unit/test_*.gd`), 39 skills e 11 agentes. Contagens são do tree Git da `main`, não de uma varredura de assets em runtime.
- Etapa 01 permanece EM ANÁLISE: nem todos os 56 scripts e 19 cenas foram inspecionados individualmente; não declarar auditoria integral concluída.
- Etapa 02 permanece EM ANÁLISE: falta matriz de rastreabilidade requisito → sistema → arquivo → teste → critério de aceite para as 26 etapas.
- `com.example.boltaventura` permanece package ID placeholder. APK de CI é artefato debug; instalação, cold start, barras/safe area, toque físico e performance em aparelho não foram executados.
\n\n### Fechamento da Etapa 01 — auditoria estática — 2026-11-26\n\n- Revisão manual concluída das 19 cenas Godot, 30 scripts de runtime, `bolt_tuning_provisional.tres`, `project.godot`, `export_presets.cfg`, ícone placeholder, documentação mestra, ADRs, workflows, PRs e branches.\n- Inventário: 288 arquivos versionados, 56 GDScript no total (runtime, testes e fixtures de skills), 19 cenas, 20 arquivos de testes unitários, 39 skills e 11 agentes.\n- Evidência automatizada adicional na PR #47: Godot 4.7.2, 88 testes/553 verificações/0 falhas; Docs SUCCESS; Android Debug Export SUCCESS; 53 scripts compilados e 39 verificações de carregamento/instanciação de cenas no runner.\n- Achado AUD-006: `TimedEnergyGate` ignorava `initial_active=false`; corrigido pela PR #47 com teste que verifica estado lógico, `monitoring`, visual e ausência de dano inicial.\n- Limites registrados: APK debug não foi instalado em aparelho; toque físico, safe area, barras, FPS, memória e lifecycle Android continuam pendentes nos Gates 1/5.\n- **Estado:** Etapa 01 concluída como auditoria estática do repositório; limitações de hardware e QA não são tratadas como defeitos confirmados nem como motivo para manter a auditoria aberta.\n\n\n### Pós-merge PR #48 — matriz das 26 etapas\n\n- Merge commit: `e2e4f68b5b21c584c33eba739845adc3c685965e`.\n- Docs CI pós-merge push `45895074739`: SUCCESS.\n- A matriz foi integrada e indexada em `docs/README.md`. Etapa 02 permanece em desenvolvimento até revisão requisito-a-requisito, classificação das lacunas de canon e registro de conflitos/decisões.\n\n\n### Etapa 02 — registro de lacunas\n\n- O registro `requirements-gap-register.md` foi criado na branch `docs/requirements-gap-register` com 22 lacunas priorizadas e 8 decisões já fechadas.\n- GAP-021 mantém como pendência de reconciliação os comandos históricos do protótipo HTML (Blast, Voar e seleção de armas 1–3); não reintroduzir nem descartar sem comparar fontes.\n- A Etapa 02 permanece EM DESENVOLVIMENTO até classificar e atribuir owners às lacunas materiais e reconciliar todos os requisitos P0 do Gate 1.\n\n\n### Encerramento da Etapa 02 e início da Etapa 03\n\n- Etapa 02 CONCLUÍDA: 22 lacunas classificadas; oito decisões fechadas; owners e dependências; critérios verificáveis para GAP-001…GAP-004; 11 conflitos documentais registrados e corrigidos/emendados.\n- Etapa 03 EM DESENVOLVIMENTO: mapa atual de arquitetura criado na branch `docs/current-architecture-map`; não foi proposta migração de pastas nem reescrita de sistemas.\n- Gate 0 (auditoria/alinhamento) estático concluído; Gate 1 (vertical slice Android) permanece em andamento e depende de validação física.\n\n\n### Etapa 03 — mapa arquitetural integrado\n\n- PR #51 integrou `technical/09-current-architecture-map.md`, com quatro autoloads, fluxo de boot, ownership de dados, player/combat, cenas de campanha, plataformas e lacunas.\n- O mapa identifica acoplamento de tipo entre BoltPlayer e BoltCombat; não foi feita refatoração sem necessidade comprovada.\n- Etapa 03 permanece EM DESENVOLVIMENTO até revisar o grafo completo de dependências, sinais, lifecycle e outros possíveis ciclos.\n\n\n### Encerramento da Etapa 03 e início da Etapa 04\n\n- Etapa 03 CONCLUÍDA como baseline arquitetural estático; autoloads e fluxos mapeados; exceção BoltPlayer↔BoltCombat documentada e não refatorada sem necessidade.\n- Etapa 04 EM DESENVOLVIMENTO: auditar Boot, SceneFlow, SaveSystem, CampaignProgress e LoadingOverlay, cobrindo erros, transições, save/backup, progressão, pause/lifecycle e falhas.\n

## Etapa 04 — hardening do SaveSystem (2026-11-26)

- Base: `main` HEAD `54fd48e5f49fba877740265aafa0d8f649c2b1e9`; branch `fix/save-system-temp-recovery-2026-11-26`.
- Achados confirmados na inspeção: `load_payload()` não tentava recuperar um `.tmp` completo após interrupção entre a rotação do principal e a promoção do temporário; `save_payload()` não protegia explicitamente envelopes de versão não suportada em principal, `.tmp` ou backup antes de limpar/rotacionar arquivos.
- Implementação na branch: recuperação/promover `.tmp` válido quando principal está ausente/inválido; precedência principal válido → temporário completo → backup válido; proteção contra fallback/downgrade quando qualquer slot (principal, temporário ou backup) declara versão não suportada; bloqueio de gravação se qualquer slot contém formato não suportado; `has_save()` reconhece temporário pendente. `CampaignProgress` aceita os novos estados de recuperação do armazenamento sem mascarar erros de schema/domínio.
- Testes adicionados: recuperação de `.tmp` mais recente que backup; preservação de temporário pendente ao iniciar nova gravação; precedência de principal íntegro; fallback de temporário inválido para backup; preservação byte a byte de principal/backup/temporário futuros; prevenção de downgrade e integração com `CampaignProgress`.
- Godot Validation run `45913709017`: SUCCESS — Godot 4.7.2, **95 testes / 652 verificações / 0 falhas**.
- Documentation Validation run `45913709173`: SUCCESS.
- Android Debug Export run `45913709027`: SUCCESS; APK 28.465.153 bytes, package ID provisório `com.example.boltaventura`, assinatura v2/v3 válida, SHA-256 `2f9ae799db84dbcf648566c8953c5fede9bcb91800417edb9586005092ad358f`; artifact [bolt-aventura-android-debug-90ef12231618606280134d7f29d2761d74ca8306](https://github.com/jyanzy19-yml/new-bolt-aventura/actions/runs/45913709027/artifacts/15161575932).
- **Estado:** implementação e regressões aprovadas em CI headless; exportação APK debug validada. PR #59 permanece aberta e não integrada.
- Limites: teste headless simula estados de arquivos, não queda real do processo, filesystem OEM ou armazenamento Android. APK não instalado/executado em aparelho; nenhum save real do usuário foi acessado.


## Etapa 12 — regressão do contrato de estado (2026-11-27)

- PR #91: teste de sequência `RISING → FALLING → GROUNDED` no sinal público `state_changed` do BOLT, com assert de ausência de emissões duplicadas.
- CI: Godot `46027916866` SUCCESS; Docs `46027916827` SUCCESS; Android Debug Export `46027916828` SUCCESS.
- O workflow Android comprova exportação debug automatizada, não instalação/execução física.
- Etapa 12 permanece EM ANDAMENTO: sincronização visual e critérios completos de animação ainda não foram validados.


## Etapa 14 — pacote integrado de contratos de respawn, checkpoint e derrota (27/11/2026)

- Branch de integração: `integration/stage14-respawn-checkpoint-defeat-contracts-2026-11-27`; reúne as unidades anteriormente propostas nas PRs #93, #94, #95 e #96, integradas por squash na PR #97 em `63bbc92d1223d922021f3f209f469d29b4899285`.
- `tests/unit/test_player_respawn_movement_contract.gd`: quatro regressões para interrupção/retomada de Dash terrestre e aéreo, orçamento de salto aéreo e descarte de edges antigos no `ActionBuffer`.
- `tests/unit/test_stage14_player_defeat_feedback_contract.gd`: integração de vida esgotada até o estado terminal da W1-L1, emissão única de `defeated`, HUD, controles touch, pausa e retry.
- `tests/unit/test_stage14_w1_l1_killzone_recovery_contract.gd`: ativação física, persistência e retorno à posição do checkpoint pela KillZone, com exatamente um respawn.
- `tests/unit/test_stage14_w1_l1_checkpoint_persistence_failure_contract.gd`: domínio de campanha incompatível (schema 999), preservação dos dados desconhecidos e fallback de checkpoint local durante a sessão.
- A cobertura de reentrada bem-sucedida já existente em `test_w1_l1_restores_persisted_checkpoint_on_scene_reentry` foi preservada; não duplicada.
- Quatro planos técnicos correspondentes em `docs/production/plans/2026-11-27-stage14-*.md`.
- Ajuste único em `.github/workflows/android-debug-export.yml`: remove instalação redundante de `cmdline-tools;latest`, já preparada pelo setup do SDK.
- Sem alteração de runtime, cenas, colisões, tuning, física, Dash, InputMap, ActionBuffer, schema v1, IDs persistentes, progressão, canon ou assets.
- **Estado:** PR #97 integrada por squash em `63bbc92d1223d922021f3f209f469d29b4899285`; quatro contratos e ajuste de workflow estão em `main`. Etapa 14 permanece EM ANDAMENTO; W1-L1 continua blockout provisório.
- CI no HEAD final pré-merge `781db1d9edff479b79163eab6746929d0c3c8bbc`: Godot Validation `46046351715`, Documentation Validation `46046351848` e Android Debug Export `46046351864` — **todos SUCCESS**.
- Godot 4.7.2: **115 testes / 2.015 verificações / 0 falhas**; 20/20 cold boots e mutation check do prewarm aprovados.
- Android Debug Export repetiu a suíte: **115 testes / 2.015 verificações / 0 falhas**. APK **28.469.428 bytes**, package ID placeholder `com.example.boltaventura`, SHA-256 `47141db58ac0e11247727e1c3c5822092afd3807d6b80d1e71e20b7a4de1ed98`; assinatura v2/v3 verificada.
- Artifact ID `15222507024`; ZIP SHA-256 `eff4379737417cbda1b9e73dfb26475dc09ab3a93f029bb1391ee1ffa0e8311f`; [artefato Android Debug](https://github.com/jyanzy19-yml/new-bolt-aventura/actions/runs/46046351864/artifacts/15222507024).
- Evidência L2/CI somente: APK não foi instalado nem executado em Android físico; touch, safe areas/barras, FPS, frame pacing, memória, temperatura e lifecycle OEM continuam sem validação.


## Etapa 14 — integração de saúde, checkpoints e recuperação do combate (27/11/2026)

- Branch: `integration/stage14-health-checkpoint-respawn-2026-11-27`; consolida o conteúdo das PRs #78, #79, #82 e #85, todas baseadas no mesmo commit ancestral `71463b5a1f27d7499943858ac86392a3933c58f2`.
- Runtime: `BoltCombat.reset_for_respawn()` limpa somente o cooldown transitório e `BoltPlayer.respawn()` passa a usar esse contrato explícito.
- Regressões: reset de cooldown/ataque pendente; restauração idempotente do checkpoint; reentrada e fallback local W1-L2; eventos de `BoltHealth`; callback duplicado do `BoltHealthPickup`.
- W1-L1 reentrada/fallback e derrota/KillZone continuam cobertos pela PR #97 já integrada; esta unidade complementa com W1-L2 e lifecycle de componentes.
- Plano: `docs/production/plans/2026-11-27-stage14-health-checkpoint-respawn-integration.md`.
- Nenhum valor de tuning, Dash, InputMap, schema de save, ID persistente, progressão, canon, geometria, arte ou asset é alterado.
- **Estado:** contratos e correção de respawn passaram em CI combinado; PR #99 pronta para integração. Etapa 14 permanece EM ANDAMENTO.
- CI no HEAD de implementação `12d741c3ce1a17d00f8227ecbe9dfefc3d417e29`: Godot Validation `46047470577`, Documentation Validation `46047470585` e Android Debug Export `46047470530` — **todos SUCCESS**.
- Godot 4.7.2: **122 testes / 2.074 verificações / 0 falhas**; 20/20 cold boots e mutation check do prewarm aprovados.
- Android Debug Export repetiu a suíte: **122 testes / 2.074 verificações / 0 falhas**. APK **28.469.428 bytes**, package ID placeholder `com.example.boltaventura`, SHA-256 `4ec82202e1286f6e9b1379a20d3fadc648cf0eec5fd56374617e909a247e5e77`; assinatura v2/v3 verificada.
- Artifact ID `15222278861`; ZIP SHA-256 `fbaaf44d95c55f9a7c6b6873fff5cb46a83b50b5f9a6cde32bcb9f1f72e8d31d`; [artefato Android Debug](https://github.com/jyanzy19-yml/new-bolt-aventura/actions/runs/46047470530/artifacts/15222278861).
- Evidência L2/CI somente; APK não foi instalado nem executado em Android físico. Touch, safe areas/barras, FPS, frame pacing, memória, temperatura e lifecycle OEM continuam pendentes.
