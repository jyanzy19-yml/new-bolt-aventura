# Plano — sistema reutilizável de plataformas móveis

**Data:** 2026-11-26  
**Branch:** `feat/moving-platform-system`  
**Base:** main após PR #44, `88b753f3b28d6591642a044b76d2d1ec21ad0d73`

## Fundamentação

O documento de gameplay inclui plataformas móveis como elemento de navegação/desafio. O blueprint de campanha propõe sua introdução em uma fase posterior do Mundo 1, mas a fase exata e seus parâmetros ainda são provisórios. Não há componente reutilizável de plataforma móvel no repositório.

## Arquitetura

- `AnimatableBody2D` com `sync_to_physics = true`.
- Colisão no world layer 1 e shape retangular instanciada por plataforma.
- Movimento ping-pong entre posição inicial e `travel_offset`, com duração por trecho e pausa configurável em cada endpoint.
- Atualização exclusivamente em `_physics_process`, incluindo consumo do delta excedente para não acumular erro de tempo em frames longos.
- Desenho placeholder compatível com `PlatformBlock`; origem no canto superior esquerdo.
- Não adicionar manualmente velocidade extra ao BOLT: `CharacterBody2D` já recebe a velocidade da plataforma por meio do motor.

## Testes

1. Tipo de corpo, sincronização física, collision layer/mask e alinhamento shape/render.
2. Chegada aos endpoints, pausa e inversão.
3. Transporte real de BOLT sobre a plataforma.
4. Respeito à pausa da SceneTree.

## Critérios de aceite

- Godot Validation e Docs Validation passam.
- Movimento é determinístico e independente de render frame rate.
- O player é transportado sem duplicação de velocidade.
- A plataforma para durante pause e retoma após unpause.

## Limites

- Não integrar a plataforma em W1-L1/W1-L2 nesta unidade.
- Velocidade, percurso, dimensões e duração são defaults provisórios; exigem playtest/level design.
- Sem teste visual ou Android físico, não declarar o comportamento de colisão aprovado para distribuição.
