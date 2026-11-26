# ADR-0004 — Modelo mínimo de progresso persistente da campanha

- **Status:** Aprovada sob delegação técnica explícita do usuário em 2026-11-26.
- **Data:** 2026-11-26
- **Escopo:** dados de progresso e checkpoint da campanha Godot.
- **Não altera:** canon narrativo, quantidade de mundos/fases, balanceamento, economia ou regras de gameplay além da persistência descrita.

## Contexto

O repositório já possui um armazenamento genérico versionado (SaveSystem), mas checkpoints e conclusão de fase ainda eram apenas estado da sessão. A W1-L1 já possui IDs estáveis para a fase e seu checkpoint. A integração precisa de um contrato de domínio sem persistir referências a Nodes ou caminhos frágeis.

## Decisão

1. CampaignProgress será a camada de domínio sobre SaveSystem; armazenamento físico e regras de campanha permanecem separados.
2. O payload fica no campo campaign_progress do Dictionary raiz para preservar dados de outros domínios.
3. Identidade da campanha: main; versão do schema de progresso: 1.
4. Campos mínimos: campaign_id (string estável), schema_version, current_level_id, active_checkpoint_id (string ou vazio) e completed_level_ids (lista sem duplicatas).
5. A ativação física de checkpoint persiste nível + checkpoint. Ao reentrar na fase, o ponto é restaurado sem reemitir o evento de ativação.
6. A conclusão da fase adiciona o ID à lista e limpa o checkpoint ativo. Não inicia a fase seguinte automaticamente enquanto W1-L2 não existir.
7. Derrota/retry reabre a W1-L1 e usa o último checkpoint persistido, se válido.
8. Falha de save não bloqueia gameplay; é registrada com warning. A fase não deve fingir que o save foi confirmado.
9. Mudanças incompatíveis exigem incremento de schema_version e migração explícita testada.

## Consequências

- Checkpoint e conclusão sobrevivem ao encerramento/reabertura do app quando o sistema de arquivos do dispositivo preserva o arquivo.
- IDs de nível/checkpoint tornam-se contrato persistente; renomeações exigem migração.
- Inventário, fragmentos, opções, moedas e outros domínios não são definidos por este ADR.
- A integração atual cobre somente W1-L1; não prova comportamento Android físico, restauração após encerramento forçado ou migrações futuras.

## Emenda de escopo — PR #34 / ADR-0006

A decisão original foi escrita quando apenas W1-L1 existia. A extensão para W1-L2 foi integrada pela PR #34 e está formalizada em [ADR-0006](ADR-0006-campaign-progress-w1-l2.md). O schema v1 permanece inalterado; W1-L1 conclui com next_level_id W1-L2, W1-L2 tem checkpoint próprio e sua conclusão mantém W1-L2 como destino atual até existir uma próxima fase real. As frases históricas deste ADR que dizem que W1-L2 não existe ou que a integração cobre somente W1-L1 descrevem o estado original, não o estado atual.
