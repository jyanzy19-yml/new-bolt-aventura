# Collaboration State — BOLT · AVENTURA

**Status:** ACTIVE — ChatGPT e Claude Code são agentes de desenvolvimento autorizados.  
**Tecnologia:** HTML5 clean-start, CSS3, JavaScript ES Modules, Canvas 2D e Vite.  
**Integração:** controlada pelo usuário.

## Tarefa ativa
- **ID:** REPO-FOUNDATION-001
- **Objetivo:** adicionar fundação de tooling, CI, segurança, templates GitHub e documentação de produção HTML5.
- **Escritor primário:** ChatGPT.
- **Revisor:** Claude Code (revisão posterior, sem edição concorrente).
- **Branch:** `chore/github-production-foundation-v2`
- **Base:** `0b6b2cea994f24638f48ac190d37edd8e58f8f2c`
- **Paths:** `package.json`, `index.html`, `src/`, `tests/`, `.github/`, `docs/architecture/`, `docs/qa/`, `docs/performance/`, `docs/assets/`, `docs/production/`, `docs/decisions/`, raiz de governança.
- **Critérios:** CI web; lint/test/build; templates; Dependabot; CodeQL; documentação; sem alegações de runtime Android.
- **Validação:** pendente de execução do GitHub Actions após PR.
- **Riscos:** lockfile ainda precisa ser gerado e commitado; scaffold não é gameplay; Capacitor não está integrado.

## Responsabilidade padrão
| Área | Lead padrão | Observação |
|---|---|---|
| Arquitetura transversal e integração | ChatGPT | Claude pode implementar tarefas isoladas |
| Runtime, física e contratos de input | ChatGPT | revisão por agente não autor |
| Fases, mundos e conteúdo | Claude Code | ChatGPT pode revisar |
| Inimigos e chefes | Claude Code | exige testes de comportamento |
| UI e sistemas independentes | Claude Code | respeitar UX mobile |
| Performance Android, CI e release gates | ChatGPT | Claude pode assumir tarefas delimitadas |
| QA/regressão | atribuído por tarefa | revisor não autor |

## Regras obrigatórias
- Uma tarefa, um escritor primário.
- Branch isolada por agente/tarefa; não editar paths simultaneamente.
- Revisores permanecem read-only durante a implementação.
- Sem force-push, reescrita de histórico ou auto-merge.
- O usuário escolhe sequência e aprova integração.
- Atualizar este arquivo e `CONTINUITY.md` após trabalho substancial.
- Assets finais só entram após aprovação explícita da versão exata.

## Handoff
```text
TASK ID:
PRIMARY WRITER:
REVIEWER:
BASE COMMIT:
BRANCH:
OBJECTIVE:
IN SCOPE:
ALLOWED PATHS:
FORBIDDEN PATHS:
DEPENDENCIES:
ACCEPTANCE CRITERIA:
REQUIRED TESTS:
KNOWN RISKS:
DELIVERABLE / PR:
NEXT OWNER:
```
