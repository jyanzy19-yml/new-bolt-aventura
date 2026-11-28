# content/levels

Dados de fase consumíveis pelo runtime HTML5. Cada fase tem dois arquivos:

| Arquivo | Conteúdo | Contrato |
|---|---|---|
| `<id>.level.json` | Geometria, spawn, checkpoints, saída (px, viewport 800×450) | Schema v1 (`docs/technical/HTML5_LEVEL_RUNTIME_CONTRACT.md`, PR #149). Passa em `validateLevelDefinition`. |
| `<id>.content.json` | Seções, rota, encontros, eventos, objetivos, diálogos, assets, metas de QA | **Proposta `0.1.0-proposal`**. O schema v1 não admite inimigos, eventos nem assets; exige extensão versionada. Nada aqui é lido pelo runtime hoje. |

## Estado atual
- `w1-l1`: `SPECIFIED_NOT_INTEGRATED`, `productionApproved: false` (task BOLT-001).
- O envelope de movimento no `content.json` foi MEDIDO com o tuning de debug (PR #161, não aprovado). Se o tuning mudar, reexecute as sondas e o validador.

## Verificação
```
node scripts/levels/validate-level-package.js          # validador estático do pacote (roda na main)
node scripts/levels/render-level-svg.js content/levels/w1-l1.level.json content/levels/w1-l1.content.json docs/game-design/figures/W1-L1-layout.svg
```
O validador estático NÃO prova jogabilidade. Sondas contra o runtime real: `scripts/levels/runtime-probes/` (dependem das PRs #149–#161).
