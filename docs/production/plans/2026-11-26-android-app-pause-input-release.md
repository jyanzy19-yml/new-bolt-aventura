# Correção — liberação de input na suspensão Android

**Data:** 2026-11-26  
**Branch:** `fix/android-app-pause-input-release-2026-11-26`  
**Base:** `54fd48e5f49fba877740265aafa0d8f649c2b1e9`

## Diagnóstico

`ActionBuffer` já limpa edges em `NOTIFICATION_APPLICATION_PAUSED`, mas `SceneFlow` e `TouchControls` tratavam somente perda de foco. Se o Android suspender o app sem o caminho de perda de foco esperado, ações lógicas e associações de ponteiros podem permanecer em estado ativo.

## Mudança proposta

- `SceneFlow`: chamar `Actions.release_all_game_actions()` também em `NOTIFICATION_APPLICATION_PAUSED`.
- `TouchControls`: chamar `release_all()` na mesma notificação, limpando mapa de ponteiros, holders e feedback visual.
- Preservar os caminhos existentes de `NOTIFICATION_APPLICATION_FOCUS_OUT` e `NOTIFICATION_WM_WINDOW_FOCUS_OUT`.
- Não alterar Input Map, Dash, janelas do ActionBuffer, física, game feel ou layout.

## Regressões

- Simular suspensão com JUMP lógico pressionado e confirmar que SceneFlow libera a ação.
- Simular suspensão com dedo segurando JUMP e confirmar liberação da ação, limpeza dos mapas de ponteiro/holders e reset visual.
- Manter a cobertura existente de ActionBuffer para suspensão do aplicativo.

## Limitações

Os testes headless verificam o tratamento da notificação, não a entrega real da notificação por Android OEM nem o comportamento de retomada em aparelho físico. A validação Android física permanece necessária.
