# Plano de implementação — W1-L2 Rede Interrompida e progressão da campanha

**Data:** 2026-11-26  
**Base:** `main` após PR #33, `09afde26cc2bdb1126202dbfd413fa317f2a3e9d`  
**Branch:** `feat/w1-l2-energy-network-progression`  
**Gate:** Gate 1 — vertical slice / campanha inicial  
**Responsável:** ChatGPT

## Objetivo

Transformar W1-L2, já especificada no blueprint de campanha, em um segundo blockout jogável e conectar a conclusão da W1-L1 ao próximo destino de campanha. A fase introduz um campo energético cíclico que alterna entre ativo e inativo, ensinando observação do ciclo e travessia em janela segura.

## Fontes e limites

- `docs/game-design/EXPANDED-42-LEVEL-CAMPAIGN-BLUEPRINT.md`, ficha W1-L2 — Rede Interrompida.
- `docs/game-design/EXPANDED-GAMEPLAY-SYSTEMS.md`, contratos de saúde, checkpoint, HUD e progressão.
- `docs/production/quality-control-protocol.md`.
- O blueprint permanece proposta de produção; esta implementação é blockout reversível, não arte final nem canon narrativo adicional.
- Dash permanece preservado; nenhum parâmetro de movimento ou arma foi alterado.
- W1-L2 não é apresentada como fase final ou validada por playtest humano.

## Escopo da unidade

1. `TimedEnergyGate`: campo `Area2D` com temporizador one-shot, duração ativa/inativa configurável, feedback visual e dano de contato apenas no período ativo.
2. Cena `timed_energy_gate.tscn` para reutilização.
3. Blockout `cybercore_w1_l2.tscn` com percurso horizontal, plataformas de serviço, campo energético, checkpoint persistente e objetivo de saída.
4. Script de fase com registro de entrada, restauração de checkpoint, respawn, feedback do ciclo e conclusão.
5. `CampaignProgress.mark_level_completed` aceita um próximo ID opcional e atualiza o destino de retomada sem alterar o schema do save.
6. W1-L1 registra W1-L2 como próximo destino e o HUD oferece a ação PRÓXIMA FASE.
7. Menu Continuar resolve destinos apenas para cenas implementadas (W1-L1 e W1-L2); IDs sem cena continuam indisponíveis.
8. Testes para avanço do ponteiro de retomada, cena W1-L2, ciclo/dano do campo e fluxo de conclusão; PR #35 reforça o contato com a `Area2D` usando eventos físicos reais.

## Fora de escopo

- Construir W1-L3 ou fases adicionais.
- Definir arte, áudio, narrativa detalhada ou nomes definitivos de inimigos.
- Adicionar chefes, novos arquétipos ou armas.
- Retunar física, Dash ou Pistola Crono.
- Declarar W1-L2 concluída como conteúdo final.
- Declarar exportação APK, teste Android físico ou desempenho.

## Critérios de aceite

- A conclusão da W1-L1 persiste W1-L1 como concluída e W1-L2 como destino de retomada.
- O botão PRÓXIMA FASE carrega W1-L2 pelo SceneFlow.
- Menu Continuar habilita apenas destinos com cena existente.
- W1-L2 registra sua entrada e restaura seu checkpoint próprio.
- O campo alterna estado ativo/inativo; contato causa dano somente quando ativo.
- Concluir W1-L2 persiste a conclusão e não aponta para uma fase inexistente.
- Godot CI e Docs CI passam; limitações de validação Android são explicitadas.

## Validação

**CI pré-merge PR #34:** Godot 4.7.2 SUCCESS — 69 testes, 439 verificações, 0 falhas (run `45872508689`); Docs SUCCESS (run `45872508675`).  
**CI pós-merge PR #34:** Godot SUCCESS — 69 testes, 439 verificações, 0 falhas (run `45872656738`); Docs SUCCESS (run `45872656798`). Docs CI da sincronização documental seguinte também SUCCESS (run `45872828901`).
**PR #35:** integrada por squash; o teste de contato físico real passou no Godot CI pré/pós-merge (`45873118202`, `45873234656`), mantendo 69 testes/439 verificações/0 falhas.  
**Nível máximo comprovado:** L2 — Godot/headless via GitHub Actions.  
**Não executado:** Godot local/editor gráfico, APK, emulador, Android físico, touch físico, safe area e performance.

## Resultado

**Resultado:** implementado e integrado pela PR #34, squash merge `c10ca6944bf0047abe694b7c429270a256cfff96`. Godot CI pré/pós-merge e Docs CI passaram; PR #35 adicionou a regressão física real e também foi integrada. W1-L2 permanece blockout/protótipo e requer playtest humano e validação Android antes de ser considerado conteúdo aprovado.
