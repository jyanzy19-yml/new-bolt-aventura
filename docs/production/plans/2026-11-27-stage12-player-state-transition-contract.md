# Etapa 12 — contrato de transições de estado do jogador

**Data:** 2026-11-27  
**Escopo:** regressão automatizada do contrato `BoltPlayer.state_changed`.  
**Classificação:** teste headless L2; não representa validação visual nem física Android.

## Objetivo

Verificar que a máquina de estados de movimento publica a sequência funcional esperada durante um salto completo, permitindo que consumidores orientados a estado (incluindo futura sincronização de animação) recebam transições ordenadas e sem notificações duplicadas.

## Cenário

1. Instanciar a cena real `res://scenes/player/bolt.tscn` sobre uma plataforma de teste e aguardar o assentamento.
2. Conectar-se ao sinal público `state_changed`.
3. Acionar salto por meio do InputMap e observar a transição `GROUNDED → RISING`.
4. Soltar o salto e acompanhar a subida até `FALLING`.
5. Aguardar contato com o piso e observar `GROUNDED`.
6. Comparar a sequência efetivamente emitida com `[RISING, FALLING, GROUNDED]`.

## Limites e preservação

- Altera somente cobertura automatizada; nenhum script de runtime, cena, tuning, InputMap, física, Dash, animação, save ou canon é modificado.
- O teste valida o contrato do sinal e a ordem dos estados; não prova que sprites/animações finais existem ou estão sincronizados.
- Não retuna física nem transforma valores provisórios de `BoltTuning` em decisões definitivas.
- A Etapa 12 permanece EM ANDAMENTO. A implementação e validação de animações depende dos assets aprovados e dos critérios integrais da etapa.
- Execução headless/CI é evidência L2; playtest visual e Android físico permanecem separados.

## Critério de aceite desta unidade

- O teste deve observar exatamente uma emissão para cada transição esperada.
- A sequência deve ser ordenada: RISING, FALLING, GROUNDED.
- A suíte Godot, validação documental e exportação Android Debug devem concluir sem falhas.
