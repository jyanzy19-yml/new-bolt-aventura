# Estado de produção — BOLT · AVENTURA

**Atualização:** 2026-11-26  
**Branch de integração:** `main` — HEAD `96bf49a659fecc3ca280ceb140613add808dcdda` (PR #19 integrada).  
**Última entrega integrada:** inimigo-base provisório de Cybercore, dano/vida do jogador, invulnerabilidade, respawn e HUD de vida (PR #19).  
**CI da PR #19:** Godot #45848858668 e Docs #45848858475 SUCCESS; 50 testes, 252 verificações, 0 falhas. CI pós-merge #45849033538/#45849033502 em execução no momento deste registro.  
**Responsável atual:** ChatGPT, por decisão explícita do usuário; Claude não está no fluxo ativo.  
**Estado do Gate 1:** EM ANDAMENTO — a base jogável e o input existem, mas a vertical slice Android ainda não está completa.

## Estado executável observado

| Área | Estado | Evidência e limite |
|---|---|---|
| Projeto Godot | Implementado | `project.godot`, Godot 4.7.2 fixado em `.godot-version` |
| Android/paisagem | Configurado | Preset Android, orientação sensor landscape e política imersiva ADR-0003; exportação não executada |
| Inicialização/menu | Implementado parcialmente | Boot e menu de identidade; menu não é fluxo de campanha completo |
| SceneFlow/loading | Implementado parcialmente | Carregamento threaded, bloqueio de transições concorrentes e sinais; headless |
| Player/movimento | Implementado parcialmente | Corrida, salto variável, pulo duplo provisório, coyote, buffer e dash; parâmetros provisórios |
| Touch/multitouch | Implementado parcialmente | Controles por ponteiro, liberação de ações e regressão de reatribuição de índice; eventos sintéticos |
| Safe Area | Implementado parcialmente | Recalcula em resize/viewport e eventos de retomada/foco; comportamento real ainda não validado em Android |
| HUD | Implementado parcialmente | HUD de sandbox, pausa e resultado; layout provisório |
| Sandbox | Implementado | Cenário de desenvolvimento; **não é fase da campanha** |
| Campanha | Em andamento | Sequência de abertura/tutorial jogável; W1-L1 Cybercore possui blockout inicial, ainda sem inimigos/combate e conteúdo final. Nenhuma fase validada |
| Combate/inimigos/chefes | Em andamento | Pistola Crono básica, componente de vida/dano e alvo estático de treinamento integrados ao tutorial. Ainda sem inimigos com IA, dano ao jogador, chefes ou arsenal completo |
| Checkpoint/save | Em andamento | PR #13 integrada: `BoltCheckpoint` com ativação única e respawn no último ponto ativo da sandbox. Estado em memória; SaveSystem/campanha ainda não implementados |
| Assets finais/áudio | Não identificados como integrados | Placeholders de apresentação permanecem |

## Validação observada

- **Godot CI Run #45:** [SUCCESS](https://github.com/jyanzy19-yml/new-bolt-aventura/actions/runs/45808858828), commit da PR #3 `373d5170362ded16d7054aeacf3daeb6b649d751`. O job Godot e as etapas de importação condicional/análise de scripts concluíram com sucesso.
- **Docs CI Run #133:** [SUCCESS](https://github.com/jyanzy19-yml/new-bolt-aventura/actions/runs/45808858862), commit da PR #3.
- **Suíte anterior:** Godot CI #36 passou com 42 testes, 171 verificações e 0 falhas; essa evidência é anterior ao hardening PR #3 e não deve ser atribuída à Run #45 sem log que confirme execução do runner.
- Validação máxima comprovada: **L2 — Godot/headless via GitHub Actions**.
- Godot local/editor gráfico/emulador: **NÃO EXECUTADO** nesta rodada.
- Exportação APK/instalação Android/toque físico/barras/FPS/memória: **NÃO EXECUTADO**.

## Etapas e colaboração

| Etapa | Responsável | Estado | Entrega |
|---|---|---|---|
| 0 | Claude Code | ACCEPTED | Fundação + protótipo provisório; hardening complementar PR #3 integrado |
| 1 | ChatGPT | HANDOFF_READY | Correção de reatribuição de ponteiro, regressão e CI executando suíte |
| 2 | ChatGPT | IN_PROGRESS | PR #13 integrada (`09317a2`); Godot CI #50 e Docs CI #167 SUCCESS; próxima unidade da vertical slice ainda em execução |
| 3 | ChatGPT | Aguardando | Próxima unidade após validação da Etapa 2 |

Um único escritor por vez. Por decisão do usuário, ChatGPT conduz sozinho as próximas etapas; Claude permanece inativo no fluxo de escrita.

## Pull requests

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
