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

## Evidência de CI — 2026-11-27

- Godot Validation run `45914923434`: **SUCCESS — Godot 4.7.2, 93 testes, 593 verificações, 0 falhas**. O novo teste `test_boot_reports_missing_required_action_without_starting_transition` passou com 8 verificações.
- Documentation Validation run `45914923475`: **SUCCESS**.
- Android Debug Export run `45914923447`: **SUCCESS**; suíte repetida com 93 testes/593 verificações/0 falhas.
- APK debug: 28.461.057 bytes; package ID provisório `com.example.boltaventura`; assinatura v2/v3 verificada; SHA-256 `de1cbc2370c958104cb51d9dee607a1d5fba4f9a51a8bb19e0cbc4207c51b231`.
- Artifact: `bolt-aventura-android-debug-f49cde66ddb82956f30fd6afcc09e00620145f7c` (artifact ID `15161951684`).
- Limites: CI headless e exportação comprovados; instalação/execução em aparelho Android e cold-start visual não executados.

## Revalidação no HEAD documental final — `2837be13`

Após registrar a primeira evidência, os três workflows foram executados novamente no HEAD final da PR:

- Godot Validation run `45915128321`: **SUCCESS — 93 testes, 593 verificações, 0 falhas**.
- Documentation Validation run `45915128398`: **SUCCESS**.
- Android Debug Export run `45915128330`: **SUCCESS — 93 testes, 593 verificações, 0 falhas**.
- APK debug: 28.461.057 bytes; package ID provisório `com.example.boltaventura`; assinatura v2/v3 verificada; SHA-256 `d382f51b3c433d84c3ad9052b7145596305e3cc9751e2a1c29edc304ce99b9e4`.
- Artifact: `bolt-aventura-android-debug-68a34763ce73ead7f7cd0d2bf540c40a7eff5c59` (artifact ID `15162021236`).
