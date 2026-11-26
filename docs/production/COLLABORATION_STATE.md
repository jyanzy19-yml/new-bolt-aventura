# Estado canônico da colaboração — Claude Code ↔ ChatGPT

**Fonte única para o próximo turno.** Antes de editar, confirme este arquivo contra o HEAD, os commits e as PRs reais do GitHub.

## Estado vigente — 2026-11-26

- **Etapa 0 — Claude Code: ACCEPTED.** Fundação Godot e protótipo técnico provisório aceitos após auditoria da Etapa 1. A exceção de escopo está registrada no handoff; não canoniza valores de gameplay.
- **Etapa 1 — ChatGPT: HANDOFF_READY.** Correção de reatribuição de ponteiro, teste de regressão e CI headless entregues. Handoff: [HANDOFF_ETAPA_1.md](handoffs/HANDOFF_ETAPA_1.md).
- **PR #2 — melhorias de qualidade: MERGED.** Merge commit: `6f8bae62018fc2c7efce8fa454c16681599dcbe6`. Adiciona três skills, três agentes read-only, validações documentais e melhorias de CI.
- **Etapa atual a executar: 2 — Claude Code.** O usuário aciona manualmente o Claude. Até ele confirmar início e commit-base, o estado é aguardando; não presumir sessão ativa.
- **Branch oficial:** `main`. Um único escritor ativo. O responsável pela etapa usa branch/PR quando possível; a entrega só passa ao próximo após integração e handoff.
- **Projeto:** Godot 4.7.2, GDScript, Android em paisagem. O projeto executável existe.
- **Validação máxima comprovada:** L2 (importação e testes Godot headless no GitHub Actions). Não há comprovação de exportação APK, instalação, teste visual, toque físico, safe area real ou performance Android.
- **PR #1:** permanece separada; não mesclar nem fechar automaticamente.

## Estado por etapa

| Etapa | Responsável | Estado | Evidência/entrega | Próximo responsável |
|---|---|---|---|---|
| 0 | Claude Code | ACCEPTED | Handoff Etapa 0; commits `7057532`, `c32a99d`, `ab72c58`. Escopo extra aceito como protótipo provisório. | ChatGPT |
| 1 | ChatGPT | HANDOFF_READY | Handoff Etapa 1; correção de input + regressão + CI, entrega `f3ab682`. | Claude Code |
| 2 | Claude Code | Aguardando | Auditar HEAD e Etapa 1; continuar Gate 1/vertical slice. | ChatGPT |
| 3 | ChatGPT | Aguardando | Atribuição futura; definir após aceite da Etapa 2. | Claude Code |

## Protocolo de início de turno

1. Confirmar que a etapa corresponde ao agente que vai escrever.
2. Registrar branch, HEAD/commit-base, alterações locais e PRs.
3. Ler `MASTER_DIRECTIVE.md`, `CLAUDE.md`, `AGENTS.md`, este arquivo, roadmap, tracker, stage status, continuidade, handoff anterior, ADRs e skills necessárias.
4. Comparar código e cenas reais com o handoff; não confiar apenas em resumos.
5. Separar bugs confirmados, hipóteses e riscos que dependem de Android físico.
6. Corrigir defeitos confirmados relevantes antes de ampliar o escopo; não reescrever sistemas funcionais por preferência.
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
4. Nunca force push, sobrescreva commits posteriores ou integre a PR #1 sem revisão independente.
5. Não declarar escrita, teste ou merge sem confirmação do GitHub/runner.
6. O usuário aciona manualmente o próximo agente; não existe transferência automática entre sessões.
7. Agentes consultivos são read-only e não substituem o responsável pela etapa.

## Fontes obrigatórias

- [Protocolo colaborativo](COLLABORATIVE_DEVELOPMENT_PROTOCOL.md)
- [Configuração de acesso](AGENT_ACCESS_SETUP.md)
- [Checklist Etapa 0](ETAPA_0_CLAUDE_CHECKLIST.md)
- [Handoff Etapa 0](handoffs/HANDOFF_ETAPA_0.md)
- [Handoff Etapa 1](handoffs/HANDOFF_ETAPA_1.md)
- [Roadmap](roadmap.md)
- [Estado de produção](stage-status.md)
- [Rastreador](implementation-tracker.md)
- [Continuidade](CONTINUITY.md)

## Histórico resumido

- **Etapa 0:** Claude criou a fundação e antecipou movimento, touch, HUD e sandbox a pedido do usuário. O próximo agente aceitou essa ampliação como provisória.
- **Etapa 1:** ChatGPT corrigiu a reatribuição de ponteiro, adicionou regressão e fez o CI executar a suíte.
- **PR #2:** melhorias de skills, agentes, validação documental e CI integradas em 2026-11-26.
- **Etapa 2:** próximo turno de implementação de Claude Code; auditar o estado atual antes de editar.
