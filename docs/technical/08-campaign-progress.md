# CampaignProgress — contrato de domínio

## Responsabilidades

CampaignProgress é o dono do schema de progresso de campanha. SaveSystem continua sendo apenas o mecanismo de armazenamento JSON versionado. O serviço não mantém referências a Nodes/Resources e não controla o HUD.

## Schema atual

O payload raiz de SaveSystem contém a chave campaign_progress:

- campaign_id: main
- schema_version: 1, inteiro JSON exato; floats e strings não são convertidos para v1
- current_level_id: string; vazio no estado padrão de campanha nova e W1-L1/W1-L2 após entrada/progressão
- active_checkpoint_id: string estável ou vazia
- completed_level_ids: array de strings sem duplicatas

A estrutura base está em ADR-0004; a extensão W1-L1→W1-L2 está registrada em ADR-0006.

## Eventos persistidos

- BoltCheckpoint.activated em W1-L1 chama CampaignProgress.save_checkpoint("W1-L1", checkpoint_id).
- Ao reentrar em W1-L1, o ID salvo é comparado com o checkpoint existente; se corresponder, a ativação é restaurada e BOLT nasce no ponto de retorno, sem reemitir activated.
- O objetivo de W1-L1 chama CampaignProgress.mark_level_completed("W1-L1", "W1-L2"), registra a conclusão e define W1-L2 como destino salvo. A transição ocorre pela ação PRÓXIMA FASE, não automaticamente.
- W1-L2 chama begin_level("W1-L2"), possui checkpoint próprio e persiste sua ativação no mesmo domínio.
- O objetivo de W1-L2 chama mark_level_completed("W1-L2") sem próximo ID. current_level_id permanece W1-L2; W1-L3 não existe e não é inferida.
- O menu Continuar só habilita W1-L1 ou W1-L2 quando o ID está no mapa de cenas e a PackedScene existe.

## Falhas e validação

- Schema desconhecido, schema_version não inteiro, campanha divergente ou payload inválido falham de forma fechada; não converter strings/floats nem sobrescrever automaticamente estado incompatível.
- Falha de gravação gera warning e não impede o jogador de continuar.
- Testes headless usam caminho user:// isolado, não o slot de produção.
- A suíte valida round-trip e reentrada de cena; não valida encerramento forçado, filesystem OEM, permissões ou Android físico.