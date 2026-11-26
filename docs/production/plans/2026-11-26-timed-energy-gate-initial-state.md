# Plano — correção do estado inicial do campo energético

**Data:** 2026-11-26  
**Branch:** `fix/timed-energy-gate-initial-state`  
**Base:** `main` após reconciliação documental de PR #46.

## Fundamentação

A inspeção estática identificou um defeito em `TimedEnergyGate._set_active()`: `_active` começa como `false`, e o método retorna imediatamente quando `initial_active=false`. Assim, o estado inicial inativo não é aplicado ao `Area2D`; a cena mantém `monitoring=true` e a apresentação visual ativa durante a primeira janela inativa.

## Escopo

- Corrigir somente a inicialização do estado ativo/inativo.
- Preservar a alternância temporal, durações, dano, sinais e comportamento padrão ativo.
- Não alterar geometria, dano, balanceamento, W1-L2 ou o controller do BOLT.

## Implementação proposta

- Distinguir “estado ainda não inicializado” de “estado atual já igual ao solicitado”.
- Permitir que a primeira chamada a `_set_active()` sempre aplique o estado visual e físico, mesmo quando `initial_active=false`.
- Manter a proteção contra alterações de `monitoring` durante flush de física usando `set_deferred`.

## Testes

1. Instanciar o campo com `initial_active=false` e confirmar `is_active()==false`.
2. Confirmar `monitoring==false` após a aplicação deferred.
3. Confirmar apresentação visual inativa.
4. Sobrepor BOLT ao campo durante a janela inicial inativa e confirmar que não há dano.
5. Manter a regressão existente que comprova o ciclo ativo → inativo → ativo e o dano apenas no estado ativo.

## Critérios de aceite

- Godot CI e Docs CI passam.
- Nenhuma mudança nos tempos ou valores de dano.
- O estado padrão `initial_active=true` permanece ativo.
- Sem alegação de validação Android física.

## Limites

- Esta unidade não altera o desenho/level design de W1-L2.
- Testes headless não substituem playtest no aparelho.
