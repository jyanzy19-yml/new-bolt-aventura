# Etapa 14 — integração de saúde, checkpoints e recuperação do combate

**Data:** 27/11/2026  
**Branch:** `integration/stage14-health-checkpoint-respawn-2026-11-27`  
**Base:** `main` após a integração da PR #97  
**Tipo:** integração de runtime restrita e regressões automatizadas; sem tuning ou mudança de conteúdo.

## 1. Objetivo

Consolidar contratos complementares da Etapa 14 que permaneceram em PRs separadas: reinicialização do cooldown de combate após respawn, restauração idempotente de checkpoints, continuidade do checkpoint W1-L2 em reentrada e fallback local sob falha de armazenamento, eventos de saúde e coleta única de pickups.

## 2. Lacunas e cenários cobertos

1. **Combate após respawn:** BOLT dispara, é derrotado durante cooldown, respawna e consegue atacar imediatamente; toque curto de ataque pendente da vida anterior é descartado.
2. **Checkpoint idempotente:** `restore_activation()` atualiza estado/indicador sem emitir `activated`, inclusive em chamadas repetidas.
3. **W1-L2 reentrada:** ID persistido, destruição e reinstanciação da fase, indicador restaurado e BOLT retorna à posição salva.
4. **W1-L2 falha de save:** com envelope JSON corrompido, checkpoint ativa localmente e a KillZone retorna BOLT ao ponto de sessão, mantendo o erro diagnosticável.
5. **BoltHealth:** entradas inválidas são rejeitadas; dano válido emite uma atualização por mutação; esgotamento emite uma vez por ciclo; `restore_full()` inicia novo ciclo.
6. **Health pickup:** callback duplicado na janela anterior ao flush de `queue_free()` não cura nem emite `collected` novamente.

A reentrada W1-L1 e o fallback de schema futuro já estão cobertos pelos contratos integrados na PR #97; esta unidade acrescenta W1-L2 e os contratos de componente/combate.

## 3. Implementação

- `BoltCombat.reset_for_respawn()` zera somente o cooldown transitório e reabilita o subsistema.
- `BoltPlayer.respawn()` usa esse contrato explícito em vez de apenas habilitar o componente.
- Testes atualizados em `test_enemy_combat.gd`, `test_checkpoints.gd` e `test_w1_l2_progression.gd`.
- Novos testes `test_health_component_contract.gd` e `test_health_pickup_lifecycle.gd`.

## 4. Preservação

- Não altera valores de cooldown, dano, velocidade, cura, vida máxima, física, Dash, InputMap, ActionBuffer, schema de save, IDs persistentes, progressão, canon, geometria, arte ou assets.
- Não converte falhas de armazenamento em sucesso persistente; o fallback permanece restrito à sessão.
- Nenhuma nova regra de balanceamento é introduzida.

## 5. Critérios de aceite

- Godot 4.7.2 Validation: todos os testes passam, sem falhas.
- Documentation Validation: SUCCESS.
- Android Debug Export: SUCCESS, com APK assinado e artefato rastreável.
- A suíte combinada preserva os contratos integrados anteriormente na PR #97.

## 6. Limitações

Headless/CI não comprova execução em Android físico, latência de toque, safe areas/barras, FPS, frame pacing, memória, temperatura ou lifecycle OEM. Etapa 14 permanece EM ANDAMENTO até os critérios restantes e QA físico serem satisfeitos.
