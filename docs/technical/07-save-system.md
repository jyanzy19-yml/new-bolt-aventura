# SaveSystem — armazenamento persistente versionado

## Escopo desta entrega

`SaveSystem` é uma camada de armazenamento local de baixo nível. Ela não define o modelo de campanha, IDs de progressão, política de autosave ou quando um checkpoint deve ser persistido. O domínio CampaignProgress já prepara e consome o payload de campanha; outros domínios (inventário, fragmentos, opções e economia) ainda não estão integrados.

## Contrato

- Autoload: `SaveSystem`.
- API: `save_payload(Dictionary) -> bool`, `load_payload() -> Dictionary`, `has_save() -> bool`, `delete_save() -> bool`.
- Arquivo principal: `user://bolt_save.json`.
- Envelope: `format_version`, `payload_json` (string JSON canônico), `checksum`.
- Versão atual do envelope: 1; format_version deve ser número finito exatamente integral (TYPE_INT ou TYPE_FLOAT com valor inteiro); strings não são convertidas.
- Checksum SHA-256 sobre a representação JSON do payload.
- Tipos permitidos: null, bool, int, float finito, String, Array e Dictionary com chaves String. Nodes, Resources, referências de runtime e tipos não JSON são rejeitados. O parser JSON do Godot materializa números como valores numéricos (frequentemente float); o consumidor de domínio deve converter contadores/índices para int conforme seu schema.
- Ausência de arquivo retorna Dictionary vazio sem erro.
- Versão desconhecida, format_version fracionário/textual, JSON inválido, payload inválido ou checksum divergente falham de forma fechada e deixam a causa em `last_error`.
- Escrita: arquivo temporário, preservação do anterior como backup, promoção do novo arquivo e restauração do backup se a promoção falhar. Antes de qualquer rotação/limpeza, a escrita inspeciona principal, temporário e backup; se algum envelope declarar versão não suportada, a operação falha sem modificar esses arquivos.
- Leitura prioriza principal válido; se o principal estiver ausente/inválido, tenta um temporário completo e o promove ao principal (`last_error = "recovered_temp"`), depois tenta o backup (`last_error = "recovered_backup"`). Um envelope de qualquer slot (principal, temporário ou backup) com versão não suportada bloqueia a seleção de uma cópia, evitando downgrade silencioso.
- A API é síncrona e deve ser chamada apenas em marcos discretos (checkpoint, conclusão ou opções), nunca no caminho por frame.

## Propriedade e integração

O sistema recebe um Dictionary já preparado pelo produtor de estado. Não mantém referências a Nodes nem conhece player, HUD, fase ou inventário. CampaignProgress define os campos/IDs estáveis e integra checkpoints e progressão em W1-L1/W1-L2 (ADR-0004 e ADR-0006). Ele trata `recovered_backup`, `recovered_temp` e `recovered_temp_unpromoted:*` como estados de recuperação do armazenamento, sem confundi-los com erro de schema/domínio. SaveSystem permanece agnóstico aos campos da campanha.

## Limites conhecidos

- Não há migração de versões anteriores: a versão 1 é a primeira versão de envelope; mudanças futuras exigem migração explícita e testes.
- Arquivos `.tmp` inválidos podem ser descartados durante uma gravação nova; envelopes de versão não suportada em qualquer slot são preservados e bloqueiam gravações. A recuperação automática de `.tmp` cobre apenas envelopes completos, com checksum e payload válidos.
- A camada está conectada ao domínio CampaignProgress em W1-L1 e W1-L2 (ADR-0004/0006). Sandbox e as outras 40 fases planejadas ainda não estão integradas; não declarar persistência global da campanha concluída.
- CI headless valida o contrato de arquivo em ambiente de teste; não substitui teste de interrupção do processo, permissões, armazenamento e comportamento em Android físico.
- O teste usa um caminho isolado `user://bolt_save_test.json`; não toca no slot de produção.
