# CampaignProgress — contrato de domínio

## Responsabilidades

CampaignProgress é o dono do schema de progresso de campanha. SaveSystem continua sendo apenas o mecanismo de armazenamento JSON versionado. O serviço não mantém referências a Nodes/Resources e não controla o HUD.

## Schema atual

O payload raiz de SaveSystem contém a chave campaign_progress:

- campaign_id: main
- schema_version: 1
- current_level_id: string, atualmente W1-L1
- active_checkpoint_id: string estável ou vazia
- completed_level_ids: array de strings sem duplicatas

A estrutura e a política estão registradas em ADR-0004.

## Eventos persistidos

- BoltCheckpoint.activated na W1-L1 chama CampaignProgress.save_checkpoint("W1-L1", checkpoint_id).
- Ao reentrar em W1-L1, o ID salvo é comparado com o checkpoint existente. Se corresponder, o indicador é restaurado e BOLT nasce no ponto de retorno. A restauração não reemite activated.
- O objetivo chama CampaignProgress.mark_level_completed("W1-L1"), adiciona o ID uma única vez e limpa o checkpoint ativo.
- A conclusão não carrega W1-L2; essa fase ainda não existe.

## Falhas e validação

- Schema desconhecido, campanha divergente ou payload inválido falham de forma fechada; não sobrescrever automaticamente estado incompatível.
- Falha de gravação gera warning e não impede o jogador de continuar.
- Testes headless usam caminho user:// isolado, não o slot de produção.
- A suíte valida round-trip e reentrada de cena; não valida encerramento forçado, filesystem OEM, permissões ou Android físico.