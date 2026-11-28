# Collaboration State — BOLT · AVENTURA

## Snapshot operacional — 2026-11-28

**Status:** fundação HTML5 e consolidação documental integradas; próxima tarefa de gameplay ainda não atribuída.  
**Main HEAD:** 9c32df4225b4e410340b2254a098167023593625.  
**Tecnologia:** clean-start HTML5, CSS3, JavaScript ES Modules, Canvas 2D e Vite; Web Audio API e Pointer Events. Capacitor permanece candidato.  
**Agentes:** ChatGPT e Claude Code autorizados; um escritor primário por tarefa.  
**Últimas integrações:** PR #120 (metadados), PR #121 (fundação HTML5 + limpeza Godot), PR #132 (lockfile + npm ci).  
**Limpeza:** 169 paths exclusivamente Godot removidos; inventário de 417 paths publicado em docs/production/REPOSITORY_CLEANUP_2026-11-28.md.  
**CI:** Documentation validation, Web CI (npm ci, lint, Vitest, build) e CodeQL passaram nos heads das PRs correspondentes.  
**Limites:** não há gameplay/vertical slice, Capacitor, APK HTML5 ou validação física Android comprovados.

## Próxima tarefa

Definir a primeira vertical slice HTML5 com primary writer, reviewer, baseline, branch, paths permitidos, contratos, critérios de aceite e testes. Não iniciar edição concorrente sem ownership explícito.

## Default responsibility map

| Area | Default lead | Notes |
|---|---|---|
| Cross-system architecture/integration | ChatGPT | Claude may implement scoped architecture tasks by assignment |
| Runtime, physics/input contracts | ChatGPT | Claude may implement isolated features with explicit contracts |
| Level/content production | Claude Code | ChatGPT may review or take an explicitly assigned task |
| Enemy/boss behavior | Claude Code | Requires gameplay acceptance tests |
| UI/content systems | Claude Code | Respect mobile UX and asset approval rules |
| Performance/Android integration/CI | ChatGPT | Claude may take bounded implementation tasks |
| QA/regression review | Either, assigned per task | Non-authoring agent reviews read-only |

This table is default routing, not an exclusive capability restriction.

## Binding coordination rules

- Exactly one primary writer per task; reviewer remains read-only until handoff.
- Prefer isolated branches: agent/claude/<task> or agent/chatgpt/<task>.
- Do not edit the same paths concurrently.
- No force-push, shared-history rewrite or self-merge.
- User chooses agent sequence and approves merges.
- Inspect current Git state and open PRs before assigning work.
- Update this file and CONTINUITY.md after substantial work.
- Asset approval remains independent: no final art asset is integrated before approval of that exact version.

## Handoff template

```text
TASK ID:
PRIMARY WRITER:
REVIEWER:
BASE COMMIT:
BRANCH:
OBJECTIVE:
IN SCOPE:
ALLOWED PATHS:
FORBIDDEN / RESERVED PATHS:
DEPENDENCIES:
ACCEPTANCE CRITERIA:
REQUIRED TESTS:
KNOWN RISKS:
DELIVERABLE / PR:
NEXT OWNER:
```

## Historical record

The sections below are retained as historical evidence from the former Godot/GDScript project. Their old assignments, HEAD hashes, 26/32-stage status, PR references and claims that Claude was inactive or ChatGPT was the sole writer are not current instructions. They must not be used as the current runtime baseline. The user's later decision to rebuild from zero in HTML5 and authorize both agents supersedes those historical operational states.
