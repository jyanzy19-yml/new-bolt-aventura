# Plano — validação estrita de versões do save

**Data:** 2026-11-26  
**Branch:** fix/strict-save-version-validation  
**Base:** main após PR #54.

## Achado

SaveSystem._decode_file converte format_version para int antes de comparar. CampaignProgress.load_state faz o mesmo com schema_version. Isso permite que valores JSON malformados como 1.5 ou "1" sejam convertidos para 1 e aceitos como schema v1, apesar de não serem inteiros exatos.

## Escopo

- Validar tipo e valor exatos de format_version e schema_version, aceitando TYPE_INT ou TYPE_FLOAT finito que seja exatamente igual ao inteiro esperado.
- Rejeitar float fracionário, string, boolean, null e versões desconhecidas; aceitar representação numérica integral 1.0 porque o parser JSON do Godot pode materializar números inteiros como float.
- Preservar payloads legítimos v1 gravados pelo próprio SaveSystem.
- Acrescentar regressões para envelope e progresso com versões de tipo incorreto.
- Não alterar schema, payload, checksum, migrações ou dados do usuário.

## Critérios de aceite

1. format_version aceita TYPE_INT igual a FORMAT_VERSION ou TYPE_FLOAT finito exatamente igual ao inteiro; não converte strings.
2. schema_version aceita TYPE_INT igual a PROGRESS_SCHEMA_VERSION ou TYPE_FLOAT finito exatamente igual ao inteiro; não converte strings.
3. Float 1.5 e string "1" são rejeitados sem truncamento/coerção.
4. Representação numérica integral 1.0 e dados v1 válidos continuam round-trip.
5. Godot CI, Docs CI e Android Debug Export passam.

## Limites

A correção protege parsing de dados malformados. Não é migração de save e não comprova persistência em aparelho Android físico.
