# Estado canônico da colaboração — Claude Code ↔ ChatGPT

**Fonte única para o próximo turno.** Antes de editar, confirme este arquivo contra o HEAD, commits, branches e PRs reais do GitHub.

## Estado vigente — 2026-11-26

**HEAD da main confirmado:** `f5fbff8de138bfec395f45a7fef1ad57c45aa37c` (merge da PR #5).

- **Etapa 0 — Claude Code: ACCEPTED.** Fundação Godot 4.7.2 e protótipo técnico provisório aceitos após auditoria. Hardening complementar integrado pela PR #3.
- **Etapa 1 — ChatGPT: HANDOFF_READY.** Correção de reatribuição de ponteiro em `TouchControls`, regressão e execução da suíte no CI. Handoff: [HANDOFF_ETAPA_1.md](handoffs/HANDOFF_ETAPA_1.md).
- **PR #2 — qualidade e especialistas: MERGED.** Merge `6f8bae62018fc2c7efce8fa454c16681599dcbe6`; adiciona skills, agentes consultivos e validações.
- **PR #3 — hardening da Etapa 0: MERGED.** Merge `4ecaff1d67049155d95bcbb5fc9d1c98187d3767`; runner não aceita suíte vazia, Safe Area responde ao ciclo de vida e registros de aceite/continuidade foram corrigidos. Auditoria: [stage-0-hardening-audit.md](stage-0-hardening-audit.md).
- **PR #4 — handoff e sincronização documental: MERGED.** Merge `9d5381047817ac9fc949583f6645d24eadd88e8c`; registra a transferência para Claude Etapa 2.
- **PR #5 — auditoria e polimento do repositório: MERGED.** Merge `f5fbff8de138bfec395f45a7fef1ad57c45aa37c`; Docs CI #140 SUCCESS. Relatório: [repository-polish-audit-2026-11-26.md](repository-polish-audit-2026-11-26.md).
- **Próximo turno: Etapa 2 — Claude Code.** Aguardando o usuário iniciar Claude manualmente. Este handoff é o ponto de partida: [HANDOFF_ETAPA_2_CLAUDE.md](handoffs/HANDOFF_ETAPA_2_CLAUDE.md).
- **Branch oficial:** `main`. Um único escritor ativo. Implementações substanciais em branch/PR; só passar o turno após integração e handoff.
- **Projeto:** Godot 4.7.2, GDScript, Android em paisagem.
- **Validação máxima comprovada:** L2 (importação/testes headless via GitHub Actions). Não há comprovação de exportação APK, instalação, teste visual, toque físico, safe area real ou performance Android.
- **PR #1:** permanece separada; não mesclar nem fechar automaticamente.

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
