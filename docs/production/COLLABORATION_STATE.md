# Estado canônico da colaboração — Claude Code ↔ ChatGPT

**Fonte única para o próximo turno.** Antes de editar, confirme este arquivo contra o HEAD, commits, branches e PRs reais do GitHub.

## Estado vigente — revisão de 2026-11-26

**HEAD atual da main:** `7afb58b190047157f35c5a0e971d0acee87dd999` (snapshot final após PR #7; Docs CI #145 SUCCESS). A PR #7 foi integrada por squash em `b8def7a22feee9573c8e4c46c99ed89cb92967c`, partindo do HEAD `75159132a7dc2503df68d8ca1abe57fc7e88019c`.

- **Etapa 0 — Claude Code: ACCEPTED.** Fundação Godot 4.7.2 e protótipo técnico provisório aceitos; hardening integrado pela PR #3.
- **Etapa 1 — ChatGPT: HANDOFF_READY.** Correção de reatribuição de ponteiro em `TouchControls`, regressão e execução da suíte no CI; entrega original `f3ab682`.
- **PRs #2–#7: MERGED.** A PR #7 (`b8def7a`) corrigiu a documentação obsoleta sobre a existência do projeto e sincronizou o handoff; Docs CI #144/#145 SUCCESS. Nenhum código de gameplay foi alterado.
- **Próximo turno de gameplay: Etapa 2 — Claude Code**, após integração desta rodada de correções documentais/governança. O usuário inicia Claude manualmente; não iniciar trabalho concorrente.
- **Projeto executável:** Godot 4.7.2, GDScript, Android em paisagem. A base contém boot/menu, SceneFlow, player, touch/multitouch, HUD, sandbox e testes; não é a campanha completa.
- **Validação máxima comprovada:** L2 (Godot headless/CI). Não há comprovação de APK exportado/instalado, teste visual, touch físico, safe area real ou desempenho em Android.
- **PR #1:** continua OPEN e não mergeável (`mergeable_state=dirty`), com 17 commits exclusivos e 137 commits de atraso em relação à main atual (`7afb58b`). Modifica 17 arquivos: quatro documentos de raiz e a diretiva dividida em 12 partes/índice. Não contém implementação de gameplay. Não mesclar automaticamente.
- **Dash:** código, Input Map, controles e testes atuais incluem a mecânica; PR #1 a exclui. A decisão canônica permanece pendente. Preservar a implementação existente sem ampliar, remover ou retunar até decisão explícita.
- **Governança da main:** o endpoint de branches confirmou `protected=false` para `main`. A integração não disponibiliza operação administrativa para habilitar proteção/ruleset; o proprietário deve configurar as regras manualmente. Não presumir checks obrigatórios antes de resolver os filtros por caminhos dos workflows.
- **Escritor desta rodada:** ChatGPT, restrito a documentação, governança e auditoria. Nenhuma alteração de gameplay está autorizada nesta rodada. Claude deve aguardar a conclusão/integração e o handoff atualizado.

## Estado por etapa

| Etapa | Responsável | Estado | Evidência/entrega | Próximo responsável |
|---|---|---|---|---|
| 0 | Claude Code | ACCEPTED | Fundação e protótipo provisório; hardening PR #3 integrado | ChatGPT |
| 1 | ChatGPT | HANDOFF_READY | `f3ab682`: correção multitouch, regressão e CI | Claude Code |
| 2 | Claude Code | PENDING / aguardando início manual | Handoff Etapa 2; continuar Gate 1 / vertical slice | ChatGPT |
| 3 | ChatGPT | Aguardando | Definir após auditoria e aceite da Etapa 2 | Claude Code |

## Protocolo de início de turno

1. Confirmar agente, etapa, branch, HEAD, PRs e alterações locais.
2. Ler `MASTER_DIRECTIVE.md`, `CLAUDE.md`, `AGENTS.md`, este arquivo e o protocolo colaborativo.
3. Ler handoff da etapa anterior, roadmap, tracker, stage status, continuidade, Definition of Done, ADRs e especificações pertinentes.
4. Comparar código/cenas reais com o handoff; não confiar apenas em resumos.
5. Separar bugs confirmados, hipóteses e riscos que dependem de Android físico.
6. Corrigir defeitos confirmados relevantes antes de ampliar escopo; não reescrever sistemas funcionais por preferência.
7. Implementar a etapa atribuída, testar, revisar diff e registrar limitações.
8. Atualizar tracker, status, continuidade, histórico e handoff com commit real.
9. O próximo agente só assume após integração e aceite do handoff.

## Máquina de estados

- **PENDING:** atribuído, ainda não iniciado.
- **IN_PROGRESS:** responsável confirmou início e commit-base.
- **HANDOFF_READY:** implementação commitada, testes e transferência registrados.
- **ACCEPTED:** próximo responsável inspecionou a entrega e aceitou a base.
- **BLOCKED:** bloqueio real registrado com evidência, responsável e tarefas independentes permitidas.

Não avançar etapa só porque uma sessão terminou. Não marcar ACCEPTED por autodeclaração do implementador.

## Regras de sincronização

1. `main` é a fonte oficial compartilhada.
2. Um único escritor por vez; não trabalhar em paralelo em arquivos de gameplay.
3. Branch/PR é preferível para mudanças substanciais. Registrar branch, PR, checks e merge commit.
4. Nunca force push, sobrescreva commits posteriores ou integre PR #1 sem revisão independente.
5. Não declarar escrita, teste ou merge sem confirmação do GitHub/runner.
6. O usuário aciona manualmente o próximo agente; não existe transferência automática entre sessões.
7. Agentes consultivos são read-only e não substituem o responsável pela etapa.

## Fontes obrigatórias

- [Protocolo colaborativo](COLLABORATIVE_DEVELOPMENT_PROTOCOL.md)
- [Configuração de acesso](AGENT_ACCESS_SETUP.md)
- [Checklist Etapa 0](ETAPA_0_CLAUDE_CHECKLIST.md)
- [Handoff Etapa 0](handoffs/HANDOFF_ETAPA_0.md)
- [Handoff Etapa 1](handoffs/HANDOFF_ETAPA_1.md)
- [Handoff Etapa 2 — Claude](handoffs/HANDOFF_ETAPA_2_CLAUDE.md)
- [Roadmap](roadmap.md)
- [Estado de produção](stage-status.md)
- [Rastreador](implementation-tracker.md)
- [Continuidade](CONTINUITY.md)

## Histórico resumido

- **Etapa 0:** Claude criou a fundação e antecipou movimento, touch, HUD e sandbox a pedido do usuário. A Etapa 1 aceitou a ampliação como provisória.
- **Etapa 1:** ChatGPT corrigiu reatribuição de ponteiro, adicionou regressão e fez CI executar a suíte.
- **PR #2:** melhorias de skills, agentes, validação documental e CI integradas em 2026-11-26.
- **PR #3:** hardening da fundação e registros de governança integrados em 2026-11-26.
- **Etapa 2:** próximo turno de implementação de Claude Code; auditar HEAD e handoff antes de editar.
- **PR #4:** handoff da Etapa 2 integrado em 2026-11-26.
- **PR #5:** auditoria integral e sincronização de continuidade integradas em 2026-11-26.
