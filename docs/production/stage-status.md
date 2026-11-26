# Estado de produção — BOLT · AVENTURA

**Atualização:** 2026-11-26  
**Branch de integração:** `main` (base verificada para handoff: `4ecaff1d67049155d95bcbb5fc9d1c98187d3767`)  
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
| Campanha | Não iniciada | Nenhuma das 42 fases está implementada |
| Combate/inimigos/chefes | Não iniciado | Nenhum sistema de combate ou inimigo integrado |
| Checkpoint/save | Não iniciado | Sem persistência de campanha |
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
| 2 | Claude Code | PENDING / aguardando início manual | Auditar HEAD/handoffs e continuar Gate 1 / vertical slice |
| 3 | ChatGPT | Aguardando | Definir após auditoria e aceite da Etapa 2 |

Um único escritor por vez. O usuário aciona manualmente o próximo agente.

## Pull requests

- [PR #2](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/2): MERGED — melhorias de qualidade e especialistas.
- [PR #3](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/3): MERGED — hardening da fundação e governança.
- [PR #1](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/1): permanece separada e divergente; não mesclar, fechar ou modificar automaticamente.

## Próximo gate executável

Claude Code assume a Etapa 2 após o usuário iniciar sua sessão. Ponto de partida: [HANDOFF_ETAPA_2_CLAUDE.md](handoffs/HANDOFF_ETAPA_2_CLAUDE.md). Deve auditar o HEAD e os handoffs, preservar correções integradas e selecionar a próxima unidade funcional mínima para avançar a vertical slice conforme as especificações aprovadas. Não tratar a sandbox como fase da campanha nem canonizar parâmetros provisórios. Exportação e Android físico permanecem gates de validação pendentes.

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
