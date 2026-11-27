# Etapa 14 — contrato de recuperação do estado transitório de movimentação

**Data:** 27/11/2026  
**Etapa:** 14 — Interações, sobrevivência, checkpoints e recuperação  
**Branch:** `test/stage14-respawn-movement-state-contract-2026-11-27`  
**Base:** `79023eabb6b31bccc456d3a2d005731733e8444e`

## Objetivo

Adicionar regressões observáveis para garantir que o respawn encerre ações de movimentação pertencentes ao ciclo anterior de vida do personagem e restaure os recursos transitórios necessários a uma nova tentativa.

## Escopo fechado

Arquivo novo: `tests/unit/test_player_respawn_movement_contract.gd`.

Cenários:
1. Interromper um Dash terrestre em andamento, zerar deslocamento residual e permitir novo Dash imediatamente após o respawn.
2. Restaurar a disponibilidade de Dash aéreo quando o respawn posiciona BOLT no ar, sem depender de um pouso intermediário.
3. Restaurar o orçamento de salto aéreo após respawn em posição aérea.
4. Descartar toques curtos de salto e Dash ainda pendentes no ActionBuffer quando o respawn acontece, impedindo que comandos da vida anterior sejam executados na nova tentativa.

Os testes usam a cena real do jogador, o `ActionBuffer`, o `InputMap` e ticks reais de física do runner headless. Não alteram diretamente velocidades internas ou campos privados para simular os resultados.

## Preservação

- Somente teste automatizado e documentação desta unidade.
- Nenhuma alteração em runtime, tuning, física, Dash, InputMap, cenas de produção, save schema, IDs persistentes, progressão, canon ou assets.
- Não substitui as regressões de cooldown/ActionBuffer de combate da PR #78, nem os contratos de checkpoint da PR #79 ou de coleta da PR #85.
- Não declara a Etapa 14 concluída.

## Critérios de aceite

- Os quatro cenários são descobertos automaticamente por `tests/test_runner.gd`.
- Godot Validation e Documentation Validation passam no commit final.
- Android Debug Export passa, como verificação de compatibilidade de empacotamento; não equivale a instalação física.
- A PR permanece aberta para revisão e não é mesclada sem autorização explícita.

## Limitações

Evidência headless/CI (L2): não comprova sensação de controle, latência de touchscreen, renderização, estabilidade térmica, frame pacing ou execução em Android físico.
