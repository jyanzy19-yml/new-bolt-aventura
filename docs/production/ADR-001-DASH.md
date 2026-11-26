# ADR-001 — Manter a mecânica Dash

- **Estado:** ACEITA
- **Data:** 2026-11-26
- **Decisor:** usuário do projeto
- **Contexto:** a implementação atual do BOLT · AVENTURA contém Dash no Input Map, em `Actions.DASH`, no estado `DASHING`, nos controles touch e nos testes. A diretiva documental ainda não integrada da PR #1 exclui a mecânica, criando conflito de escopo.

## Decisão

**Dash deve permanecer no BOLT · AVENTURA.** O usuário confirmou explicitamente essa decisão em 2026-11-26.

## Consequências

- Preservar a implementação, integração com controles e testes existentes.
- A instrução contrária na diretiva não integrada da PR #1 não é autoridade para remover Dash.
- Esta decisão não aprova mudanças de física, duração, velocidade, cooldown, balanceamento, controles ou efeitos visuais. Cada alteração futura precisa de escopo explícito, justificativa e testes.
- Não foi realizada nenhuma alteração de gameplay nesta decisão; ela formaliza a mecânica já existente.

## Evidências e referências

- Código atual: Input Map, `Actions.DASH`, estado `DASHING`, controles touch e testes.
- Auditoria: [repository-polish-audit-2026-11-26.md](repository-polish-audit-2026-11-26.md), seção 8.7.
