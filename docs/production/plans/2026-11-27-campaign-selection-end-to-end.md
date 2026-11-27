# Regressão ponta a ponta — seleção de campanha

**Data:** 27/11/2026  
**Branch:** `test/campaign-selection-end-to-end-2026-11-27`  
**Base:** `7dcc5448c78383a6c6f40b155bd227160133657f`  
**Estado:** EM VALIDAÇÃO — teste automatizado; não é validação física Android.

## Objetivo

Verificar o fluxo jogável de entrada na campanha, não apenas a existência das telas:
`Menu principal → Seleção de mundos → Seleção de fases → W1-L1`.

## Cobertura adicionada

- Usa os botões reais das cenas e seus sinais `pressed`, sem mock de navegação.
- Usa o autoload `SceneFlow` e aguarda a conclusão do carregamento threaded real.
- Confirma as cenas de destino efetivamente instaladas na SceneTree.
- Confirma que Cybercore está disponível numa campanha nova.
- Confirma que W1-L1 está disponível e W1-L2 permanece bloqueada antes da conclusão da fase anterior.
- Confirma a entrada efetiva em W1-L1 e o registro de `current_level_id` no domínio de campanha.
- Isola o save em caminho temporário e limpa cena, pausa, metadados e arquivos ao final.

## Preservação

Nenhum runtime de produção, física, tuning, Dash, InputMap, schema de save, IDs persistentes, arte, áudio ou canon narrativo é alterado. O escopo é exclusivamente uma regressão de integração da UI de campanha já existente.

## Critérios de aceite

1. Godot 4.7.2 importa o projeto e compila o teste.
2. A suíte headless conclui sem falhas.
3. Documentation Validation passa.
4. Android Debug Export passa e publica APK verificável.
5. O teste não deixa save, pausa, cena ou metadados residuais para os testes seguintes.

## Limitações

A execução headless valida o encadeamento de cenas e sinais, mas não comprova legibilidade visual, gestos reais, safe areas, latência de toque, frame pacing ou execução em aparelho Android físico.
