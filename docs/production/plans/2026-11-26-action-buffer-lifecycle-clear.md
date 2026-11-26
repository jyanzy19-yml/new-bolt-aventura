# Plano — limpeza do ActionBuffer no ciclo de vida Android

**Data:** 2026-11-26  
**Branch:** `fix/action-buffer-lifecycle-clear-v2`  
**Base:** main após PR #38, `d08a2b203e525ccc98a4a0e45d1532b41e674fc5`

## Diagnóstico

`TouchControls` e `SceneFlow` liberam as ações lógicas quando o app perde foco, e `BoltPlayer` limpa o buffer em pausa/retomada da SceneTree. Entretanto, `ActionBuffer` não limpava explicitamente os edges de pressionamento pendentes ao receber notificações de pausa/suspensão/perda de foco do sistema.

Como o buffer usa ticks de física, um edge válido antes da suspensão poderia permanecer pendente se a simulação fosse interrompida e voltar a ser consumido depois da retomada. O risco é um salto/dash/ataque inesperado ao retornar ao jogo.

## Alteração

- `ActionBuffer._notification()` chama `clear()` em `NOTIFICATION_APPLICATION_PAUSED`, `NOTIFICATION_APPLICATION_FOCUS_OUT`, `NOTIFICATION_WM_WINDOW_FOCUS_OUT` e `NOTIFICATION_PAUSED`.
- Não altera a janela de buffer, as ações rastreadas, a física, os valores de movimento ou o comportamento normal dos controles.
- Adiciona testes para garantir que um JUMP pendente seja descartado na perda de foco e um DASH pendente seja descartado na suspensão do aplicativo.

## Critérios de aceite

1. Os testes demonstram que o buffer contém o edge antes da notificação.
2. A notificação de perda de foco/suspensão limpa o edge.
3. Os testes existentes de toque curto, expiração, tempo de jogo e ataque continuam passando.
4. Godot CI e Docs CI passam.
5. A documentação mantém separado o teste sintético/headless do teste de interrupção em Android físico.

## Limitações

A regressão automatizada envia notificações diretamente ao Node; não reproduz suspensão real pelo Android. Teste de troca de app, bloqueio de tela, retomada, multitouch físico e latência continuam pendentes em dispositivo identificado.
