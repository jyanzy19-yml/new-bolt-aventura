# Estado de produção — BOLT · AVENTURA

**Atualização:** 2026-11-26  
**Branch de integração:** `main`  
**Commit de implementação da Etapa 1:** `f3ab6829228c077b1a3c14eb65385a8a99c34608`  
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
| HUD | Implementado parcialmente | HUD de sandbox, pausa e resultado; layout provisório |
| Sandbox | Implementado | Cenário de desenvolvimento; **não é fase da campanha** |
| Campanha | Não iniciada | Nenhuma das 42 fases está implementada |
| Combate/inimigos/chefes | Não iniciado | Nenhum sistema de combate ou inimigo integrado |
| Checkpoint/save | Não iniciado | Sem persistência de campanha |
| Assets finais/áudio | Não identificados como integrados | Placeholders de apresentação permanecem |

## Validação observada

- **Godot CI Run #31:** [SUCCESS](https://github.com/jyanzy19-yml/new-bolt-aventura/actions/runs/45801225080), commit `f3ab682`. O workflow executou Godot 4.7.2 headless, importação do projeto e `tests/test_runner.gd`; exit code 0.
- A árvore de testes contém 42 métodos `test_*` em 9 arquivos. O sucesso do runner comprova que não houve falhas segundo seu critério de saída.
- **Docs CI Run #119:** [SUCCESS](https://github.com/jyanzy19-yml/new-bolt-aventura/actions/runs/45801225270), commit `f3ab682`.
- Validação máxima observada nesta etapa: **L2 — Godot/headless via GitHub Actions**.
- Godot local neste ambiente: **NÃO EXECUTADO**, binário não instalado.
- Editor gráfico/emulador: **NÃO EXECUTADO**.
- Exportação APK/instalação Android/toque físico/barras/FPS/memória: **NÃO EXECUTADO**.

## Etapas e colaboração

| Etapa | Responsável | Estado | Entrega |
|---|---|---|---|
| 0 | Claude Code | ACCEPTED | Fundação + base provisória de movimento/touch/HUD; handoff aceito após inspeção |
| 1 | ChatGPT | HANDOFF_READY | Correção de reatribuição de ponteiro, teste de regressão e CI passa a executar a suíte |
| 2 | Claude Code | Aguardando | Auditar Etapa 1 e continuar a implementação do Gate 1 conforme roadmap |

Um único escritor por vez. O usuário aciona manualmente o próximo agente.

## PR #1

A [PR #1](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/1) permanece aberta e divergente. Não foi mesclada, fechada ou modificada nesta etapa.

## Próximo gate executável

Claude Code deve auditar o HEAD e o handoff da Etapa 1, preservar a correção de input e avançar a vertical slice do Gate 1 conforme as especificações aprovadas. Não tratar a sandbox como fase da campanha nem canonizar parâmetros provisórios. Android físico e exportação permanecem gates de validação pendentes.

## Referências

- [Roadmap](roadmap.md)
- [Rastreador de implementação](implementation-tracker.md)
- [Estado da colaboração](COLLABORATION_STATE.md)
- [Handoff Etapa 0](handoffs/HANDOFF_ETAPA_0.md)
- [Handoff Etapa 1](handoffs/HANDOFF_ETAPA_1.md)
- [Protocolo de qualidade](quality-control-protocol.md)
