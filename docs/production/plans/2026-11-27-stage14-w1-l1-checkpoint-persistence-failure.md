# Etapa 14 — fallback local de checkpoint quando a persistência falha

**Data:** 27/11/2026  
**Branch:** `test/stage14-w1-l1-checkpoint-save-failure-2026-11-27`  
**Base:** `main` — `79023eabb6b31bccc456d3a2d005731733e8444e`  
**Escopo:** regressão automatizada de integração; sem alteração de runtime.

## 1. Lacuna identificada

A cobertura existente verifica ativação física, persistência e restauração do checkpoint W1-L1 em reentrada, além do caminho de KillZone com persistência bem-sucedida. Ainda faltava provar o comportamento quando `CampaignProgress` rejeita o domínio salvo por incompatibilidade de schema.

O controlador de W1-L1 atualiza `_respawn_position` antes de solicitar a gravação. Esse fallback transitório deve continuar útil durante a sessão, sem sobrescrever um domínio de campanha que o runtime não compreende.

## 2. Objetivo

Provar que, quando o save de campanha está em schema futuro/incompatível:

1. a fase não normaliza nem sobrescreve o domínio desconhecido;
2. o contato físico real ativa o checkpoint para a sessão atual;
3. o HUD informa a ativação sem fingir que a gravação foi concluída;
4. a KillZone continua usando a posição local de respawn;
5. BOLT recupera a vida e retorna ao checkpoint local sem overlay terminal ou pausa indevida.

## 3. Implementação

Novo teste: `tests/unit/test_stage14_w1_l1_checkpoint_persistence_failure_contract.gd`.

- Usa a cena real `cybercore_w1_l1.tscn`.
- Semeia um payload físico válido contendo `campaign_progress.schema_version = 999`.
- Não chama handlers privados; ativa checkpoint e KillZone por sobreposição física real.
- Verifica o erro `unsupported_progress_schema`, a preservação do payload incompatível e o fallback transitório.
- Não altera scripts de runtime, cenas, colisões, física, Dash, InputMap, schema v1, IDs persistentes, progressão, canon, arte ou assets.

## 4. Critérios de aceite

- A suíte Godot 4.7.2 passa sem falhas.
- A validação documental passa.
- A exportação Android Debug passa.
- O teste comprova que a falha de persistência não apaga dados incompatíveis e não impede recuperação local durante a sessão.

## 5. Limitações

A regressão headless comprova o contrato lógico/físico simulado no runner, não a instalação ou execução em Android físico. Não mede latência touch, FPS, memória, frame pacing, temperatura ou comportamento OEM. W1-L1 continua blockout provisório e a Etapa 14 permanece em andamento.
