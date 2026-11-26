# ADR-0005 — Fluxo de Nova Jornada e Continuar

- **Status:** Aprovada
- **Data:** 2026-11-26
- **Responsável pela proposta:** ChatGPT — implementação autorizada pelo usuário
- **Escopo:** arquitetura / dados / fluxo de campanha

## Contexto

O menu anterior oferecia apenas Nova Jornada e sempre encaminhava o jogador à abertura e ao tutorial. O domínio `CampaignProgress` persistia checkpoint/conclusão da W1-L1, mas não registrava a entrada inicial na fase. Assim, não havia retomada explícita e um jogador sem checkpoint não possuía um destino de continuação.

## Opções consideradas

1. Duplicar o estado de save no menu — rejeitada por criar uma segunda fonte de verdade.
2. Adicionar um novo serviço de save/gerenciador de slots — rejeitada por duplicar `SaveSystem` e `CampaignProgress`.
3. Estender `CampaignProgress` e usar o `SaveSystem` existente — escolhida; mantém os limites de domínio e armazenamento atuais.

## Decisão

- O menu apresenta **Nova Jornada** e **Continuar**.
- Nova Jornada chama `CampaignProgress.start_new_campaign()`, redefine somente o campo `campaign_progress` e preserva os demais domínios do payload quando o envelope pode ser lido. Em seguida, segue para abertura e tutorial.
- Continuar só é habilitado quando o save contém `current_level_id = "W1-L1"` e a cena `cybercore_w1_l1.tscn` existe. O destino é diretamente W1-L1, sem repetir abertura/tutorial.
- A entrada em W1-L1 registra `current_level_id`. Entrar novamente na mesma fase não apaga o checkpoint ativo. Mudar para outro ID limpa o checkpoint ativo anterior.
- W1-L2 não é criada nem presumida. IDs sem cena correspondente não habilitam Continuar.
- Se o envelope estiver ilegível ou incompatível, Continuar permanece indisponível, mas Nova Jornada continua habilitada. Um envelope ilegível não é apagado automaticamente; a sessão pode prosseguir sem persistência até que o armazenamento seja recuperável.
- Um schema de domínio incompatível, mas dentro de um envelope válido, pode ser substituído por Nova Jornada explícita, preservando os demais campos do payload.
- Não há mudança no schema v1 de `CampaignProgress` nem no formato v1 de `SaveSystem`.

## Consequências

- Uma única fonte de verdade para o progresso continua sendo `CampaignProgress`.
- O jogador pode retomar W1-L1 mesmo antes de ativar o primeiro checkpoint; nesse caso, começa no spawn inicial da fase.
- Após a conclusão de W1-L1, Continuar reabre a fase existente desde o início, pois não há próxima fase implementada.
- A retomada de fases futuras exige cena e integração reais; nenhum destino futuro é inferido.
- A corrupção de armazenamento não impede iniciar gameplay, mas pode impedir salvar progresso. A falha é reportada por warning e estado do menu.
- Permanecem pendentes testes de encerramento forçado, editor/emulador, APK e Android físico.

## Evidências e aprovação

- Requisito do usuário: implementar Novo Jogo e Continuar integrado ao SaveSystem/CampaignProgress.
- Implementação nesta etapa: branch `feat/main-menu-new-game-continue`.
- Testes automatizados adicionados em `tests/unit/test_campaign_progress.gd` e `tests/unit/test_campaign_entry.gd`.
- A aprovação da validação técnica depende dos workflows Godot e Docs concluírem com sucesso.
