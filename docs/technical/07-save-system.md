# SaveSystem — armazenamento persistente versionado

## Escopo desta entrega

`SaveSystem` é uma camada de armazenamento local de baixo nível. Ela não define o modelo de campanha, IDs de progressão, política de autosave ou quando um checkpoint deve ser persistido. Esses dados pertencem aos sistemas de domínio que ainda serão integrados.

## Contrato

- Autoload: `SaveSystem`.
- API: `save_payload(Dictionary) -> bool`, `load_payload() -> Dictionary`, `has_save() -> bool`, `delete_save() -> bool`.
- Arquivo principal: `user://bolt_save.json`.
- Envelope: `format_version`, `payload`, `checksum`.
- Versão atual do envelope: 1.
- Checksum SHA-256 sobre a representação JSON do payload.
- Tipos permitidos: null, bool, int, float finito, String, Array e Dictionary com chaves String. Nodes, Resources, referências de runtime e tipos não JSON são rejeitados.
- Ausência de arquivo retorna Dictionary vazio sem erro.
- Versão desconhecida, JSON inválido, payload inválido ou checksum divergente falham de forma fechada e deixam a causa em `last_error`.
- Escrita: arquivo temporário, preservação do anterior como backup, promoção do novo arquivo e restauração do backup se a promoção falhar.
- Leitura tenta o backup quando o arquivo principal está ausente ou inválido. Recuperação é sinalizada por `last_error = "recovered_backup"`.
- A API é síncrona e deve ser chamada apenas em marcos discretos (checkpoint, conclusão ou opções), nunca no caminho por frame.

## Propriedade e integração

O sistema recebe um Dictionary já preparado pelo produtor de estado. Não mantém referências a Nodes nem conhece player, HUD, fase ou inventário. O modelo de campanha deve definir seus campos e IDs estáveis antes de conectar checkpoints e progressão a este serviço.

## Limites conhecidos

- Não há migração de versões anteriores: a versão 1 é a primeira versão de envelope; mudanças futuras exigem migração explícita e testes.
- A camada ainda não está conectada ao checkpoint ou ao fluxo de conclusão de W1-L1. Portanto, não declarar persistência de campanha implementada.
- CI headless valida o contrato de arquivo em ambiente de teste; não substitui teste de interrupção do processo, permissões, armazenamento e comportamento em Android físico.
- O teste usa um caminho isolado `user://bolt_save_test.json`; não toca no slot de produção.
