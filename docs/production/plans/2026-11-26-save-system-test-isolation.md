# Plano — isolamento dos fixtures do SaveSystem no runner

**Data:** 2026-11-26  
**Branch:** test/isolate-save-system-fixtures  
**Base:** main após PR #52; baseline Godot 4.7.2.

## Achado

tests/unit/test_save_system.gd configura SaveSystem.storage_path_override para user://bolt_save_test.json em cada teste, mas não restaura o override após concluir. O runner executa todos os testes na mesma SceneTree e o autoload SaveSystem é compartilhado. Portanto, testes posteriores podem herdar o caminho temporário, dependendo da ordem de descoberta.

## Escopo

- Adicionar teardown explícito aos testes de SaveSystem para remover apenas o slot temporário e restaurar storage_path_override vazio.
- Adicionar fallback de isolamento no test_runner.gd após cada método test_*; só apagar o arquivo quando storage_path_override não estiver vazio, nunca tocar no save real.
- Preservar o comportamento do jogo e os caminhos de produção.
- Não resetar estado global de forma ampla nem esconder falhas de teardown.

## Critérios de aceite

1. Cada teste de SaveSystem termina com override vazio e fixture removido.
2. O runner recupera o override caso um teste falhe antes do teardown.
3. O fallback nunca chama delete_save quando override está vazio.
4. A suíte headless completa passa sem regressões.
5. Docs CI passa; nenhum APK ou gameplay muda.

## Limites

A mudança corrige isolamento do harness de teste. Não representa bug de persistência em execução normal e não comprova lifecycle Android físico.
