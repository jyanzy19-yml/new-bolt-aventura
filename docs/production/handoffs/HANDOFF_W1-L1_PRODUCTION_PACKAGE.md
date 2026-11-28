# Handoff — W1-L1 Production Package (BOLT-001)

- **Task:** BOLT-001 (pacote de conteúdo/level design). **Escritor:** Claude Code. **Revisor sugerido:** ChatGPT, somente leitura.
- **Base:** `origin/main` @ `27c3407`. **Branch:** `agent/claude/w1-l1-production-package`.
- **Escopo permitido (usado):** `content/levels/**`, `scripts/levels/**`, `tests/content/**`, `docs/game-design/W1-L1-*`, `docs/game-design/figures/**`, `docs/assets/W1-L1-*`, `docs/qa/W1-L1-*`, `docs/production/W1-L1-*`, `docs/production/handoffs/HANDOFF_W1-L1_*`, anexos curtos em `ASSET_REQUEST_QUEUE.md` e `implementation-tracker.md`.
- **Não tocado:** `src/**`, `package.json`, pipeline, `CONTINUITY.md`, `COLLABORATION_STATE.md`, `docs/README.md` (donos: PRs #133/#134/#162/#165).

## Leia primeiro
[`W1-L1-PENDING-AND-DEPENDENCIES.md`](../W1-L1-PENDING-AND-DEPENDENCIES.md), seção 0: conflito com a PR #162.

## Trecho de continuidade a aplicar depois que #133 for integrada
> **W1-L1 production package (BOLT-001, Claude Code)** — dados em `content/levels/w1-l1.*`, docs em `docs/game-design/W1-L1-*`. Estado: SPECIFIED_NOT_INTEGRATED, não aprovado. Validado: contrato v1 (script, PR #161) e pernas por bot; Vitest/CI/dispositivo não executados. Pendente: conflito com #162, D-01..D-15, schema v2 de conteúdo. Próximo dono: usuário decide a direção (seção 0 do registro de pendências).

## Como verificar
`node scripts/levels/validate-level-package.js` · testes em `tests/content/` · sondas em `scripts/levels/runtime-probes/` (exigem #149–#161).
