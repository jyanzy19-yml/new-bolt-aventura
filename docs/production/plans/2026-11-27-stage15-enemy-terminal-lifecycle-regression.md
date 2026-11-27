# Etapa 15 — regressão do ciclo de vida terminal do inimigo Cybercore

**Data:** 27/11/2026  
**Branch:** `test/stage15-enemy-terminal-lifecycle-2026-11-27`  
**Base:** `main`  
**Tipo:** ampliação isolada de testes headless; sem alteração de runtime, tuning ou conteúdo.

## 1. Objetivo

Formalizar uma regressão para o limite entre a derrota lógica do inimigo e sua remoção física diferida pela SceneTree. O contrato existente usa `_active` como autoridade de lifecycle; `queue_free()` não remove o nó imediatamente.

## 2. Cenários cobertos

1. Dano inválido não altera vida nem emite `hit_received`.
2. Dano letal aceito esgota a vida, emite `hit_received` uma vez e inicia a transição terminal.
3. O sinal `defeated` é emitido exatamente uma vez.
4. Uma chamada tardia de dano, durante a janela anterior ao flush de `queue_free()`, não reabre o lifecycle nem duplica sinais.
5. Um callback tardio de contato após a derrota não causa dano em BOLT.
6. O teste usa as cenas reais `BoltPlayer` e `CybercorePatrolEnemy`, sem substituir seus contratos por mocks.

## 3. Implementação

- Acrescenta `test_enemy_terminal_lifecycle_is_idempotent_and_ignores_late_contact()` em `tests/unit/test_enemy_combat.gd`.
- Não altera `CybercorePatrolEnemy`, `BoltHealth`, Player, cenas, colisões, tuning ou InputMap.
- Não cria hierarquia genérica de inimigos nem abstração sem segundo consumidor.

## 4. Critérios de aceite

- Godot 4.7.2 Validation: suíte completa sem falhas.
- Documentation Validation: SUCCESS.
- Android Debug Export: SUCCESS.
- O teste deve demonstrar a idempotência do estado terminal e a rejeição de callbacks atrasados.

## 5. Limitações

A regressão headless comprova o contrato de lifecycle no runner automatizado. Não comprova leitura visual, balanceamento, IA avançada, telegraphs, percepção, navegação por plataformas ou comportamento em Android físico. A Etapa 15 permanece EM ANDAMENTO.
