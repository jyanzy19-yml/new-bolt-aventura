# Plano — validação estrita de versões do save

**Data:** 2026-11-26  
**Branch:** fix/strict-save-version-validation  
**Base:** main após PR #54.

## Achado

SaveSystem._decode_file converte format_version para int antes de comparar. CampaignProgress.load_state faz o mesmo com schema_version. Isso permite que valores JSON malformados como 1.5 ou "1" sejam convertidos para 1 e aceitos como schema v1, apesar de não serem inteiros exatos.

## Escopo

- Validar tipo e valor exatos de format_version e schema_version.
- Rejeitar float, string, boolean, null e versões desconhecidas com os erros existentes de versão incompatível.
- Preservar payloads legítimos v1 gravados pelo próprio SaveSystem.
- Acrescentar regressões para envelope e progresso com versões de tipo incorreto.
- Não alterar schema, payload, checksum, migrações ou dados do usuário.

## Critérios de aceite

1. format_version só aceita TYPE_INT com valor FORMAT_VERSION.
2. schema_version só aceita TYPE_INT com valor PROGRESS_SCHEMA_VERSION.
3. Float 1.5 e string "1" são rejeitados sem serem truncados/coagidos.
4. Dados v1 válidos continuam round-trip.
5. Godot CI, Docs CI e Android Debug Export passam.

## Limites

A correção protege parsing de dados malformados. Não é migração de save e não comprova persistência em aparelho Android físico.
