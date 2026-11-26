# ADR-0006 — Progressão persistente W1-L1 → W1-L2

- **Status:** Aceita como contrato de implementação integrado
- **Data:** 2026-11-26
- **Escopo:** progressão e retomada das duas fases existentes de Cybercore
- **Implementação de referência:** PR #34, com regressões posteriores; verificar sempre o código da main
- **Não altera:** schema v1, canon narrativo, ordem dos sete mundos, quantidade de fases ou balanceamento

## Contexto

ADR-0004 definiu o schema mínimo de CampaignProgress quando apenas W1-L1 estava integrada. ADR-0005 definiu Nova Jornada/Continuar antes de W1-L2 existir. A PR #34 adicionou W1-L2 em blockout e estendeu o fluxo persistente, tornando algumas frases históricas desses ADRs obsoletas.

## Decisão de implementação

1. CampaignProgress continua como dono do domínio de campanha e SaveSystem como mecanismo de armazenamento.
2. O schema de progresso permanece versão 1: campaign_id, schema_version, current_level_id, active_checkpoint_id e completed_level_ids.
3. O estado padrão de campanha recém-criada tem current_level_id vazio; a entrada real em W1-L1 chama begin_level("W1-L1").
4. O objetivo de W1-L1 chama mark_level_completed("W1-L1", "W1-L2"). O ID W1-L2 torna-se o destino salvo, mas a transição depende da ação explícita PRÓXIMA FASE apresentada pelo HUD.
5. W1-L2 chama begin_level("W1-L2"), possui checkpoint próprio e persiste sua ativação usando o mesmo domínio.
6. A conclusão de W1-L2 chama mark_level_completed("W1-L2") sem next_level_id. O progresso permanece apontando para W1-L2, permitindo revisitar a última fase implementada; não existe destino W1-L3.
7. O menu Continuar aceita somente IDs presentes no mapa de cenas realmente suportadas e verifica a existência da PackedScene. Atualmente W1-L1 e W1-L2.
8. Reentrada na mesma fase preserva o checkpoint; entrar em outro ID limpa o checkpoint ativo anterior.
9. W1-L1/W1-L2 são blockouts. Este ADR descreve persistência e roteamento, não aprovação de level design final.
10. Não são persistidos inventário, moedas, habilidades, fragmentos ou estados completos de inimigos por este contrato.

## Consequências

- O schema v1 não precisa de migração para a extensão W1-L2 porque os campos existentes já suportam IDs de nível e checkpoint.
- IDs de fase/checkpoint continuam estáveis; renomeações futuras exigem migração.
- Continuar nunca deve inferir destinos futuros. W1-L3 só será elegível depois de cena, integração e teste reais.
- O encerramento forçado e o lifecycle Android continuam pendentes de teste físico; CI headless não comprova persistência em dispositivo.

## Evidências

- PR #34 integrou W1-L2, o campo energético e progressão W1-L1→W1-L2.
- PR #47 pós-merge: Godot 4.7.2, 88 testes/553 verificações/0 falhas; Docs e Android Debug Export SUCCESS.
- Fontes executáveis: scripts/campaign/campaign_progress.gd, scripts/campaign/cybercore_w1_l1.gd, scripts/campaign/cybercore_w1_l2.gd, scripts/ui/main_menu.gd.
- Testes: tests/unit/test_campaign_progress.gd, tests/unit/test_campaign_entry.gd, tests/unit/test_w1_l2_progression.gd.
