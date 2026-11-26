# Plano — plataforma unidirecional

**Data:** 2026-11-26  
**Branch:** `feat/one-way-platform`  
**Base:** main após PR #45, `b24c8624a8ed64816d0131070f440a47f525ba47`

## Fundamentação

O sistema de gameplay documenta plataformas unidirecionais. A plataforma estática atual é sólida em todas as direções; ainda não existe um componente que permita atravessar a plataforma de baixo para cima e aterrissar sobre sua face superior.

## Arquitetura

- `OneWayPlatform` estende `PlatformBlock` para reutilizar tamanho, colisão, desenho e collision layer.
- Configura `CollisionShape2D.one_way_collision = true`.
- Configura `one_way_collision_direction = Vector2.DOWN`, isto é, a plataforma bloqueia movimento descendente e permite passagem ascendente.
- Mantém `one_way_collision_margin` configurável, default provisório de 2 px.
- Não altera o controller do BOLT nem adiciona verificações manuais de colisão.

## Testes

1. Verificar propriedades da CollisionShape2D.
2. Verificar aterrissagem do BOLT vindo de cima.
3. Verificar passagem do BOLT subindo por baixo.
4. Garantir que a passagem ascendente não seja confundida com aterrissagem.

## Critérios de aceite

- Godot e Docs CI passam.
- O motor confirma colisão somente no sentido descendente.
- Não há alteração na física base nem na plataforma sólida existente.

## Limites

- Não integrar em W1-L1/W1-L2 nesta unidade.
- Margin e dimensões são parâmetros provisórios.
- O teste headless não substitui playtest visual nem validação Android física.
