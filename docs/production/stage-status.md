# Estado de produção — BOLT · AVENTURA

**Atualização:** 2026-11-26  
**Última entrega de conteúdo de gameplay:** PR #34 — W1-L2 Rede Interrompida em blockout, campo energético cíclico e progressão persistente.  
**Última regressão de gameplay integrada:** PR #37 — contato físico do coletável, merge `39b6db8298542c5057c06f509b20d250a888e289`.  
**Última entrega de infraestrutura integrada:** PR #38 — pipeline Android debug, merge `d08a2b203e525ccc98a4a0e45d1532b41e674fc5`.  
**Branch de trabalho:** `fix/action-buffer-lifecycle-clear-v2` — regressão de limpeza do ActionBuffer no ciclo de vida, aguardando CI.  
**Responsável atual:** ChatGPT, único escritor ativo conforme decisão vigente do usuário.  
**Estado do Gate 1:** EM ANDAMENTO — W1-L1/W1-L2 seguem blockouts; APK debug foi exportado em CI, mas instalação e validação Android física continuam pendentes.  
**CI pré-merge PR #34:** Godot run `45872508689` SUCCESS — Godot 4.7.2, 69 testes, 439 verificações, 0 falhas; Docs run `45872508675` SUCCESS.  
**CI pós-merge PR #34:** Godot run `45872656738` SUCCESS — 69 testes, 439 verificações, 0 falhas; Docs run `45872656798` SUCCESS. **PR #35:** Godot CI pré/pós-merge SUCCESS — 69 testes, 439 verificações, 0 falhas (`45873118202`, `45873234656`). Docs CI da sincronização anterior `45872828901` SUCCESS.  
**Responsável atual:** ChatGPT, como único escritor ativo conforme a diretriz vigente do usuário.  
**Estado do Gate 1:** EM ANDAMENTO — W1-L1 e W1-L2 permanecem blockouts; nenhuma validação Android física foi executada.

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
- [PR #39](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/39): OPEN — limpeza do ActionBuffer em interrupções do ciclo de vida Android; aguardando CI.
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

**Base:** `main` após PR #36, commit `afea046b6a481d48299641c9d8e529f6288d5256`.  
**Unidade em execução:** `test/health-pickup-physical-contact` — regressão de contato físico do coletável de vida.  
**CI pós-merge PR #36:** Godot Validation run `45877649854` SUCCESS; Docs Validation run `45877649923` SUCCESS. A suíte headless passou; contagem de testes não foi inferida dos metadados do job.

### Estado das 26 etapas

| Etapa | Área | Estado | Evidência / lacuna principal |
|---:|---|---|---|
| 01 | Auditoria integral do repositório | EM ANÁLISE | Inventário recursivo, fontes mestras, ADRs, estado Git/PRs e sistemas centrais inspecionados; auditoria integral de todos os recursos/cenas ainda em consolidação |
| 02 | Requisitos e planejamento | EM ANÁLISE | Master Directive, bíblias, especificações e roadmap existem; matriz de rastreabilidade específica das 26 etapas ainda precisa ser consolidada |
| 03 | Arquitetura e organização | EM DESENVOLVIMENTO | Godot 4.7.2, cenas, scripts, autoloads e contratos existentes; arquitetura global ainda parcial |
| 04 | Infraestrutura e sistemas centrais | EM DESENVOLVIMENTO | Boot, SceneFlow, SaveSystem e CampaignProgress implementados parcialmente |
| 05 | Recursos e carregamento | EM DESENVOLVIMENTO | SceneFlow threaded e transições; gestão abrangente de preload/memória e assets pendente |
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
| 19 | Obstáculos e exploração | EM DESENVOLVIMENTO | Plataformas, checkpoint, coletável e campo energético; segredos/rotas opcionais ainda ausentes |
| 20 | Narrativa e progressão | EM DESENVOLVIMENTO | Premissa/canon, abertura, tutorial e progressão W1-L1→W1-L2 parciais; campanha narrativa incompleta |
| 21 | Interface e UX | EM DESENVOLVIMENTO | Menu, HUD, pausa e controles touch parciais; configurações e validação visual/Android pendentes |
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
