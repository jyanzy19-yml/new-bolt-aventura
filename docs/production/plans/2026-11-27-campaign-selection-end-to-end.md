# Regressão ponta a ponta — seleção de campanha

**Data:** 27/11/2026  
**Branch:** `test/campaign-selection-end-to-end-main-2026-11-27`  
**Base:** `44bed68d5612209e6c3124f0ab50539f8c84841c`  
**Estado:** EM VALIDAÇÃO — teste automatizado; não é validação física Android.

## Objetivo

Verificar o fluxo jogável de entrada na campanha:
`Menu principal → Seleção de mundos → Seleção de fases → W1-L1`.

## Cobertura

- Usa botões reais e sinais `pressed`, sem mock de navegação.
- Usa o autoload `SceneFlow` e aguarda o carregamento threaded.
- Confirma as cenas de destino efetivamente instaladas na SceneTree.
- Confirma Cybercore disponível em campanha nova.
- Confirma W1-L1 disponível e W1-L2 bloqueada antes da conclusão de W1-L1.
- Confirma entrada efetiva em W1-L1 e persistência de `current_level_id` em save isolado.
- Limpa cena, pausa, metadados e arquivo temporário.

## Preservação

Nenhum runtime de produção, física, tuning, Dash, InputMap, schema de save, IDs persistentes, arte, áudio ou canon narrativo é alterado. Escopo exclusivamente de regressão de integração da UI.

## Aceite

1. Godot 4.7.2 importa o projeto e compila o teste.
2. Suíte headless conclui sem falhas.
3. Documentation Validation passa.
4. Android Debug Export passa e publica APK verificável.
5. Nenhum save, pausa, cena ou metadado residual contamina testes seguintes.

## Limitações

Headless valida encadeamento de cenas e sinais; não comprova legibilidade visual, gestos reais, safe areas, latência touch, frame pacing ou execução física Android.
