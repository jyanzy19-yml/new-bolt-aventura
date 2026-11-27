# Plano — regressão de inicialização fail-closed do Boot

**Data:** 2026-11-27  
**Branch:** `test/boot-input-map-fail-closed-2026-11-27`  
**Base:** `54fd48e5f49fba877740265aafa0d8f649c2b1e9`

## Escopo

Cobrir o contrato já implementado em `scripts/core/boot.gd`: o jogo não deve iniciar a transição para o menu quando faltar uma ação obrigatória no Input Map. O Boot deve expor uma mensagem de configuração, em vez de prosseguir silenciosamente.

## Alteração

- Adiciona `tests/unit/test_boot.gd`.
- Remove temporariamente a ação Jump do InputMap durante um teste isolado.
- Instancia a cena real `scenes/boot/boot.tscn` na SceneTree.
- Verifica a mensagem de erro e confirma que SceneFlow não inicia transição.
- Restaura a ação original e seus eventos ao final do teste.
- Não altera o comportamento de runtime, Input Map, Dash, controles ou física.

## Critérios de aceite

1. A cena Boot carrega e instancia.
2. Com uma ação obrigatória ausente, Boot mostra o estado de configuração incompleta.
3. Nenhuma transição para o menu é iniciada nessa condição.
4. A fixture restaura o InputMap original.
5. Godot Validation e Documentation Validation passam.

## Auditoria relacionada

Na revisão estática de 2026-11-27, Boot, SceneFlow e LoadingOverlay não apresentaram defeito de execução confirmado no código inspecionado. Esta unidade fecha uma lacuna específica de regressão de cold-start; não substitui teste de inicialização em aparelho Android.

## Limitações

Headless valida o contrato programático e a cena carregável. Não comprova cold-start visual, desempenho, entrega de notificações Android, legibilidade em diferentes telas ou comportamento OEM.
