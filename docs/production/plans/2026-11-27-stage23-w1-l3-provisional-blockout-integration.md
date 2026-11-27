# Etapa 23 — integração do blockout provisório Cybercore W1-L3

**Data:** 27/11/2026  
**Branch:** `integration/campaign-w1-l3-provisional-blockout-2026-11-27`  
**Origem:** consolidação da PR #84  
**Estado de conteúdo:** BLOCKOUT PROVISÓRIO / PROPOSTA DE PRODUÇÃO

## 1. Objetivo

Adicionar a terceira fase provisória do mundo Cybercore e conectar o fluxo de campanha W1-L2 → W1-L3, preservando o blueprint de 42 fases e sem declarar W1-L3 como conteúdo final ou canon narrativo.

## 2. Composição de blockout

- Piso inicial para entrada e observação.
- Elevador industrial vertical lento.
- Piso intermediário para combate/reposicionamento.
- Plataforma superior estática de leitura espacial.
- Plataforma móvel horizontal de transferência.
- Piso final com recuperação, checkpoint e objetivo.
- Dois encontros com o inimigo-base provisório.
- KillZone e saída de conclusão.

As dimensões, coordenadas, durações e distâncias estão documentadas em `docs/game-design/W1-L3-setor-de-montagem.md` e são parâmetros de blockout sujeitos a playtest, não balanceamento final.

## 3. Integração de campanha

- W1-L2 conclui via `CampaignProgress.mark_level_completed("W1-L2", "W1-L3")`.
- O HUD de W1-L2 oferece `PRÓXIMA FASE` apontando para a PackedScene W1-L3.
- O menu resolve W1-L3 por ID estável e permite retomada.
- W1-L3 registra a entrada com `CampaignProgress.begin_level("W1-L3")`.
- Checkpoint usa ID persistente `cybercore_w1_l3_checkpoint`.
- A conclusão de W1-L3 não aponta para W1-L4, que permanece não implementada.

## 4. Testes

Novo teste `tests/unit/test_w1_l3_blockout.gd` cobre:
1. composição da cena, pisos, plataformas, inimigos, checkpoint e objetivo;
2. parâmetros de movimento das duas plataformas;
3. limites de patrulha dentro dos pisos;
4. contato físico, persistência e restauração do checkpoint após reentrada;
5. conclusão de W1-L2, atualização do destino W1-L3 e resolução pelo menu;
6. conclusão física de W1-L3, registro único da fase concluída e ausência de destino W1-L4 não implementado.

O teste existente `test_w1_l2_progression.gd` foi atualizado para exigir o próximo destino W1-L3, preservando os cenários de checkpoint/falha de save já integrados.

## 5. Preservação e limites

- W1-L3 permanece BLOCKOUT PROVISÓRIO, derivado da proposta W1-L3 do blueprint.
- Nenhum novo detalhe narrativo é canonizado.
- Nenhuma arte final, spritesheet, animação, VFX, áudio ou asset final é criado.
- Não altera schema de save, IDs anteriores, Dash, InputMap, física do Player ou tuning já estabelecido.
- Não anuncia W1-L4 nem inventa fluxo de campanha além do conteúdo implementado.
- Usa sistemas já existentes: Player, HUD, inimigo-base, MovingPlatform, checkpoint, KillZone e objetivo.

## 6. Critérios de aceite

- Godot 4.7.2: importação, parsing e suíte headless passam.
- Documentation Validation: SUCCESS.
- Android Debug Export: SUCCESS, assinatura v2/v3 e artifact rastreável.
- W1-L2 conclui e aponta para W1-L3; menu retoma W1-L3.
- Checkpoint W1-L3 persiste e restaura após reentrada.
- Nenhum teste afirma que W1-L3 é fase final ou que W1-L4 existe.

## 7. Limitações

Headless/CI não substitui playtest humano/Android físico. Legibilidade touch, tempos de embarque, câmera, clipping, FPS, memória e sensação das plataformas móveis continuam pendentes. Etapa 23 permanece EM ANDAMENTO.
