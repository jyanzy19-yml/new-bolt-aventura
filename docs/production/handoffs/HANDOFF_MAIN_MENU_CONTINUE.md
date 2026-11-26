# Handoff — Nova Jornada / Continuar

**Data:** 2026-11-26  
**Responsável:** ChatGPT (único escritor ativo)  
**Base:** `52f75f437c37cbc018ef8d4611f49fb462bae74c`  
**Branch:** `feat/main-menu-new-game-continue`

## Requisito

Implementar fluxo explícito de Nova Jornada e Continuar integrado ao SaveSystem/CampaignProgress, sem inventar W1-L2 e sem regredir gameplay existente.

## Achados da auditoria

- Menu anterior: apenas botão Play/Nova Jornada para abertura.
- Abertura encaminha ao tutorial; tutorial encaminha à W1-L1.
- SaveSystem JSON v1 e CampaignProgress schema v1 já existentes.
- W1-L1 gravava checkpoint/conclusão, mas não registrava entrada inicial na fase.
- Só W1-L1 é destino de campanha existente.

## Implementação nesta branch

- `CampaignProgress.start_new_campaign()`: redefine apenas campaign_progress, preservando outros domínios legíveis; não apaga envelope ilegível.
- `CampaignProgress.begin_level()`: registra fase atual; reentrada na mesma fase preserva checkpoint.
- Menu oferece Nova Jornada e Continuar; Continue é condicionado à existência de W1-L1 e vai diretamente para essa cena.
- Nova Jornada permanece habilitada diante de save ausente, incompatível ou ilegível; em caso de envelope ilegível, gameplay pode prosseguir sem persistência.
- W1-L1 registra entrada na fase antes de recuperar checkpoint.
- Testes ampliados para reset, preservação de configurações, entrada, retomada direta, ID sem cena e save corrompido.

## Arquivos alterados

- `scripts/campaign/campaign_progress.gd`
- `scripts/ui/main_menu.gd`
- `scenes/ui/main_menu.tscn`
- `scripts/campaign/cybercore_w1_l1.gd`
- `tests/unit/test_campaign_progress.gd`
- `tests/unit/test_campaign_entry.gd`
- Documentação de produção e ADR-0005.

## Validação e integração

- PR #31: MERGED por squash.
- Merge commit/main HEAD: `42b60c06615c1d1bd8059e315f34fcedcff04d81`.
- Godot CI pré-merge run `45862187355`: SUCCESS — Godot 4.7.2, 66 testes, 404 verificações, 0 falhas.
- Docs CI pré-merge run `45862187418`: SUCCESS.
- Godot CI pós-merge run `45862459941`: SUCCESS — Godot 4.7.2, 66 testes, 404 verificações, 0 falhas.
- Docs CI pós-merge run `45862459947`: SUCCESS.
- Execução Godot local: não disponível/não executada nesta sessão.
- Android, APK, emulador, encerramento forçado e aparelho físico: não executados.

## Achado preexistente fora do escopo

O log da suíte contém erro de `Area2D.monitoring` alterado sincronamente dentro de `body_entered`, em `BoltHealthPickup`. A mesma mensagem aparece no CI anterior à PR #31 (`45859653809`), portanto não foi introduzida por esta entrega. Corrigir em tarefa isolada usando mudança deferred e teste de regressão.

## Próxima ação

Continuar a próxima unidade de produção a partir do HEAD integrado. W1-L1 permanece blockout em andamento; não criar W1-L2 sem conteúdo e cena reais.
