# Plano — bloqueio integral de input durante transições

**Data:** 2026-11-26  
**Branch:** `fix/scene-flow-input-lock`  
**Base:** main após PR #41, `66b3c0e060762ebe1f3c4b6af84c84a79f0cd781`

## Diagnóstico

A PR #41 adicionou o overlay persistente e um `Control` full-screen que captura eventos GUI/touch. Isso não bloqueia, por si só, ações de teclado processadas por `InputMap`. Além disso, o HUD usa `PROCESS_MODE_ALWAYS`; por isso, o player pode estar pausado em uma futura alteração, mas o HUD/touch ainda pode processar entradas se não forem explicitamente ocultados/filtrados.

## Implementação

- `SceneFlow` captura o estado de pausa anterior, pausa a SceneTree assim que uma transição é aceita e restaura o estado anterior em falha.
- Ao concluir a troca de cena, a SceneTree é retomada para que a nova cena comece jogável.
- `Hud` libera ações e oculta `TouchControls` em `transition_started`; restaura controles se a transição falhar e a árvore não estiver pausada.
- `Hud._input()` ignora a ação de pausa enquanto `SceneFlow.is_transitioning()`.
- `Hud._exit_tree()` não desfaz a pausa enquanto `SceneFlow` ainda controla uma transição.
- Testes verificam pausa durante carregamento, retomada após sucesso e liberação/ocultação/restauração do touch em sinais de transição.

## Critérios de aceite

1. Ao aceitar uma transição, a SceneTree fica pausada.
2. `SceneFlow` continua processando em `PROCESS_MODE_ALWAYS` e conclui a troca.
3. Após `scene_changed`, a nova cena fica despausada.
4. HUD libera ações e oculta controles touch durante a transição.
5. Em falha, o estado de pausa anterior é restaurado e os controles retornam somente quando apropriado.
6. Godot e Docs CI passam.

## Limites

- Testes headless simulam sinais e fluxo de cena; não substituem teste de teclado/touch físico durante carregamento em Android.
- Não adiciona cancelamento do carregamento.
