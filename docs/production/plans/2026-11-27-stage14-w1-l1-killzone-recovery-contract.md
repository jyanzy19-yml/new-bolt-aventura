# Etapa 14 — recuperação física da KillZone em W1-L1

**Data:** 27/11/2026  
**Etapa:** 14 — Interações, sobrevivência, checkpoints e recuperação  
**Branch:** `test/stage14-w1-l1-killzone-recovery-contract-2026-11-27`  
**Base:** `main` no início desta unidade  
**Tipo:** regressão automatizada de integração; sem alteração de runtime

## Motivação

A campanha W1-L1 possui checkpoint persistido e uma `KillZone` física conectada ao retorno do jogador. A cobertura já existente de queda/recuperação em W1-L2 (PR #79) e de estado transitório no respawn (PR #93) não comprova, por si só, que o arranjo concreto de W1-L1 mantém a posição de retorno persistida após contato real com sua área de queda.

Esta unidade verifica esse caminho no blockout atual sem promover a geometria provisória a conteúdo final.

## Escopo fechado

Arquivo novo: `tests/unit/test_stage14_w1_l1_killzone_recovery_contract.gd`.

Cenário:

1. Instanciar a cena real W1-L1 com armazenamento de teste isolado.
2. Ativar o checkpoint por contato físico real entre BOLT e a `Area2D`.
3. Verificar ID persistido e feedback `CHECKPOINT ATIVADO`.
4. Aplicar dano não letal e conduzir BOLT para a `KillZone` real.
5. Verificar exatamente um evento `respawned`, retorno à posição persistida, restauração de vida, manutenção do checkpoint e ausência de overlay terminal/pausa.
6. Avançar ticks adicionais para comprovar que a saída da área não causa respawn duplicado.

O teste não chama o handler privado `_on_kill_zone_body_entered`; a colisão deve ocorrer pelo pipeline físico de `Area2D.body_entered`.

## Preservação

- Somente teste e documentação; nenhum runtime, cena, shape, coordenada, tuning, física, Dash, InputMap, ActionBuffer, save schema, ID persistente, progressão, canon, arte ou asset é alterado.
- Complementa PR #79: aquela regressão cobre sandbox/W1-L2 e fallback local; esta cobre o arranjo de campanha W1-L1.
- Complementa PR #93: aquela cobre a recuperação dos recursos transitórios de movimento; esta verifica o acionamento físico e a posição de retorno da fase.
- O save usa caminho isolado e é removido no cleanup.
- W1-L1 continua blockout; não há aprovação de geometria ou balanceamento final.
- Não declara a Etapa 14 concluída.

## Critérios de aceite

- O runner `tests/test_runner.gd` descobre automaticamente o teste.
- Contato real da KillZone, não chamada direta do callback privado.
- Godot Validation, Documentation Validation e Android Debug Export passam no HEAD final.
- A PR permanece aberta para revisão; não integrar sem autorização explícita.
- Exportação Android em CI não equivale a instalação/playtest físico.

## Limitações

Headless não comprova justiça da queda, legibilidade visual da área de perigo, resposta de toque, frame pacing, FPS, memória ou estabilidade térmica Android. A geometria e coordenadas de W1-L1 permanecem blockout provisório.
