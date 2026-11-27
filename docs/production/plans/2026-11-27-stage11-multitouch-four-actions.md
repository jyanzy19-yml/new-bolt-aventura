# Plano de implementação — regressão multitouch de quatro ações

**ID:** PLAN-STG11-TOUCH-004  
**Etapa:** 11 — Física, movimentação e controles touchscreen  
**Base:** `main` no início da unidade (checkpoint documental `d90ac2c78e96b32233f8d003ea6673a38079ecb3`)  
**Branch:** `test/stage11-touch-multiaction-buffer-2026-11-27`  
**Classificação:** teste automatizado de contrato; nenhuma alteração de runtime.

## Problema de cobertura

A suíte já verifica três ações simultâneas e o buffer de toques curtos isoladamente. Faltava uma regressão integrada que percorresse o caminho real:

`InputEventScreenTouch` → `TouchControls` → `InputEventAction` → `ActionBuffer`

A lacuna era especialmente relevante para a prioridade mobile: movimento, salto, Dash e ataque precisam coexistir sob multitouch, e os comandos discretos não podem desaparecer se o toque começar e terminar antes do próximo tick de física.

## Alteração

Adicionar um teste em `tests/unit/test_touch_controls.gd` que:
1. Instancia o HUD real e o `TouchControls` real.
2. Cria um `ActionBuffer` real com as ações rastreadas padrão.
3. Pressiona simultaneamente quatro ponteiros independentes: movimento, salto, Dash e ataque.
4. Verifica as quatro ações ativas ao mesmo tempo.
5. Libera os quatro ponteiros antes de ceder um tick de física.
6. Verifica que nenhuma ação mantida fica presa.
7. Verifica que jump, Dash e attack chegaram ao buffer e podem ser consumidos exatamente uma vez.

## Preservação

- Nenhum script de runtime, cena de produção, InputMap, física, Dash, janela do buffer, HUD ou save foi alterado.
- Nenhum valor de gameplay foi ajustado.
- O teste sintético/headless não prova latência do digitalizador, resposta física ou comportamento OEM Android.

## Critério de aceite

- O novo cenário deve ser descoberto automaticamente pelo `tests/test_runner.gd`.
- Godot Validation deve concluir com zero falhas.
- Android Debug Export deve passar se o workflow correspondente for acionado.
- Resultado deve ser descrito como evidência L2; validação física continua pendente.
