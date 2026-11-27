# Etapa 13 — regressão física da plataforma unidirecional

**Data:** 27/11/2026  
**Branch:** `test/stage13-one-way-platform-physics-integration-2026-11-27`  
**Base:** `main` após integrações Stage 14/15  
**Tipo:** ampliação de testes headless; sem alteração de runtime ou tuning de produção.

## 1. Objetivo

Fortalecer o contrato geométrico e físico da plataforma unidirecional usada nas fases 2D, substituindo um cenário isolado de movimento por uma sequência de gameplay completa e observável.

## 2. Cobertura

1. Verifica geometria retangular, dimensões, posição da shape, direção de bloqueio e margem unidirecional configurada.
2. Instancia piso sólido inferior, plataforma unidirecional e BOLT real.
3. Entrega o comando de pulo pelo InputMap/ActionBuffer do projeto.
4. Verifica que BOLT atravessa a plataforma durante a subida e aterrissa na face superior após o arco de salto.

## 3. Preservação

- Altera somente `tests/unit/test_one_way_platform.gd`.
- Não altera runtime, Player, física, tuning, Dash, InputMap, cenas de produção, arte ou assets.
- Não substitui validação visual ou playtest Android; o teste comprova o contrato de simulação física no runner headless.

## 4. Critérios de aceite

- Godot Validation: todos os testes passam.
- Documentation Validation: SUCCESS.
- Android Debug Export: SUCCESS, com assinatura v2/v3 e artifact rastreável.
- Sequência de gameplay completa comprova passagem ascendente e aterrissagem superior.

## 5. Limitações

Não comprova leitura visual, câmera, clipping, resposta touch, FPS ou estabilidade em Android físico. Etapa 13 permanece EM ANDAMENTO.
