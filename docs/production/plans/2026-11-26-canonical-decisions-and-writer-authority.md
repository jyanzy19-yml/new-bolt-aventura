# Plano — reconciliação de decisões canônicas e autoridade operacional

**Data:** 2026-11-26  
**Branch:** `docs/reconcile-canonical-decisions-2026-11-26`  
**Base:** main após PR #39, `50c9bfdd997edf0cb5cb7cfb22d246bd4d0beca2`

## Achados da auditoria documental

1. `docs/production/ADR-001-DASH.md` registra decisão explícita do usuário: Dash deve permanecer no jogo.
2. `MASTER_DIRECTIVE.md` ainda dizia que o conflito de escopo sobre Dash não estava resolvido.
3. `docs/production/from-zero-implementation-directive.md` ainda classificava o escopo do Dash como pendente de reconciliação.
4. `AGENTS.md` e `CLAUDE.md` ainda descreviam alternância obrigatória Claude ↔ ChatGPT, enquanto `COLLABORATION_STATE.md` registra a decisão posterior do usuário de manter ChatGPT como único escritor ativo.
5. `docs/README.md` e o protocolo colaborativo ainda apresentavam a alternância como fluxo atual, sem destacar que ela só pode ser reativada por decisão explícita do usuário.
6. O cabeçalho de `stage-status.md` continha snapshots duplicados e uma frase antiga que negava a exportação APK já comprovada pela PR #38.

## Alterações

- Alinhar MASTER_DIRECTIVE e diretiva integral ao ADR-001: Dash é aprovado e deve ser preservado.
- Manter o protocolo Claude ↔ ChatGPT como referência histórica/condicional, sem alternância automática.
- Definir `COLLABORATION_STATE.md` como fonte operacional do escritor atual; no estado vigente, ChatGPT é o único escritor ativo.
- Atualizar AGENTS, CLAUDE, índice e protocolo para impedir que instruções antigas sobrescrevam a decisão atual.
- Reconciliar o cabeçalho do stage status e atualizar continuidade/tracker/CI com PR #39 e o APK exportado nessa PR.

## Limites

- Somente documentação e governança; nenhuma alteração de gameplay, Dash, controles, física, save, narrativa ou arquitetura.
- Não fechar, rebasear ou integrar PR #1 automaticamente.
- Não alterar o plano operacional de 26 etapas nem substituir o prompt mestre.

## Critérios de aceite

1. Todas as referências atuais confirmam que Dash permanece e apontam para ADR-001.
2. A alternância de agentes é explicitamente condicional à reativação pelo usuário.
3. O escritor atual é determinado por `COLLABORATION_STATE.md`.
4. Stage status, tracker e continuidade apontam para a main e evidências atuais.
5. Docs Validation passa.
