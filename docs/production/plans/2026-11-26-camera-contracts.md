# Plano — contratos verificáveis da câmera 2D por fase

**Data:** 2026-11-26  
**Branch:** `test/camera-contracts`  
**Base:** main após PR #43, `22923228d2a58c0ee6d75b581d5a16aa70e1a7ef`

## Diagnóstico

O player já usa `Camera2D` nativa com suavização de posição, drag margins e processamento no tick de física. W1-L1 e W1-L2 já definem limites de câmera distintos por fase, mas essa configuração estava inline em `_ready()` e não possuía regressões específicas.

## Alterações

- Extrair a aplicação dos limites para `configure_camera(camera)` em cada script de fase; `_ready()` continua chamando o mesmo setup.
- Tornar explícito `limit_smoothed = true`.
- Adicionar testes do rig do player: smoothing, speed, drag margins, limites suavizados e callback no tick de física.
- Adicionar testes dos limites exatos W1-L1 (0, -360, 2200, 260) e W1-L2 (0, -360, 1900, 260), sem adicionar cenas de campanha à árvore nem alterar progresso salvo.

## Critérios de aceite

1. Configuração existente da Camera2D preservada.
2. Limites de cada fase aplicados de modo reproduzível.
3. Godot e Docs CI passam.
4. Nenhuma mudança de movimento, viewport, zoom ou feel sem playtest.

## Limites

- Headless comprova propriedades configuradas, não enquadramento/renderização real.
- Jitter, black bars nas bordas, resposta em 30/60/120 FPS, safe area e legibilidade precisam de inspeção visual e aparelho Android.
- Não introduzir look-ahead, zoom dinâmico ou câmera hand-rolled sem requisito e playtest.
