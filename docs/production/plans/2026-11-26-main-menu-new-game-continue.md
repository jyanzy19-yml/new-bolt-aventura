# Plano de implementação — Nova Jornada e Continuar

**Data:** 2026-11-26  
**Base:** `main` em `52f75f437c37cbc018ef8d4611f49fb462bae74c`  
**Branch:** `feat/main-menu-new-game-continue`

## Objetivo e resultado observável

O menu deve permitir iniciar uma campanha nova ou retomar o progresso salvo. A retomada deve abrir uma fase realmente existente e evitar repetir abertura/tutorial quando o progresso já chegou à campanha.

## Escopo incluído

- Inspecionar menu, abertura, tutorial, SceneFlow, SaveSystem, CampaignProgress e testes existentes.
- Adicionar reset explícito do domínio de campanha preservando outros domínios legíveis.
- Registrar a entrada em W1-L1 e preservar checkpoint na reentrada da mesma fase.
- Adicionar botão Continuar condicionado a ID conhecido e cena existente.
- Tratar ausência, schema incompatível e envelope ilegível sem bloquear Nova Jornada.
- Adicionar regressões automatizadas e atualizar ADR, tracker, status e continuidade.

## Fora de escopo

- Criar W1-L2 ou qualquer fase não existente.
- Alterar gameplay, Dash, controles, combate, movimentação, HUD de combate ou parâmetros provisórios.
- Criar novo slot de save, serviço de persistência ou alterar versões dos schemas.
- Validar APK, Android físico, desempenho ou encerramento forçado sem ambiente de execução.

## Documentos e skills consultados

- `.claude/skills/router/SKILL.md`
- `.claude/skills/save-systems/SKILL.md`
- `.claude/skills/bolt-save-integrity/SKILL.md`
- `docs/README.md`
- `docs/production/quality-control-protocol.md`
- `docs/qa/test-matrix.md`
- `docs/templates/implementation-plan.md`
- `docs/templates/decision-record.md`
- `docs/decisions/ADR-0004-campaign-progress-schema.md` (contrato de schema já existente)

## Estado atual e dependências

- `SaveSystem` usa envelope JSON v1, checksum e backup.
- `CampaignProgress` usa schema de domínio v1, persiste checkpoint/conclusão W1-L1.
- Menu só tinha Nova Jornada; abertura → tutorial → W1-L1.
- W1-L1 não registrava a entrada antes do primeiro checkpoint.
- Apenas W1-L1 existe como destino de campanha implementado.

## Arquivos previstos

- `scripts/campaign/campaign_progress.gd`
- `scripts/ui/main_menu.gd`
- `scenes/ui/main_menu.tscn`
- `scripts/campaign/cybercore_w1_l1.gd`
- `tests/unit/test_campaign_progress.gd`
- `tests/unit/test_campaign_entry.gd`
- Documentação: ADR-0005, tracker, stage-status, CONTINUITY e índice.

## Plano por etapas

1. Estender CampaignProgress com reset de campanha e registro idempotente de entrada na fase.
2. Integrar menu Nova Jornada/Continuar, validar destino real e manter Nova Jornada disponível em falhas de save.
3. Registrar a entrada em W1-L1 sem apagar checkpoint ativo na reentrada.
4. Testar reset, preservação de domínios, checkpoint, ausência/corrupção/incompatibilidade e retomada direta.
5. Atualizar documentação, revisar diff, abrir PR, aguardar Godot/Docs CI, corrigir falhas e integrar somente após aprovação.

## Riscos e mitigação

- **ID de fase sem cena:** Continuar só aceita W1-L1 e verifica ResourceLoader.
- **Checkpoint apagado na reentrada:** begin_level é idempotente para a mesma fase; teste específico.
- **Save ilegível:** não apagar arquivo automaticamente; permitir iniciar a sessão sem persistência.
- **Dados de outros domínios:** reset modifica apenas campaign_progress quando payload pode ser lido.
- **Mudança de schema:** nenhuma nesta etapa.

## Estratégia de teste

- Automatizado: testes de CampaignProgress e menu/entrada W1-L1 no runner headless via CI.
- Manual: inspeção do diff e dos contratos de sinais/transição.
- Android real: não executado nesta etapa.
- Performance: não aplicável ao escopo; não reivindicar métricas.

## Critérios de aceite

- Nova Jornada limpa apenas progresso da campanha e entra pela abertura/tutorial.
- Continuar só habilita para W1-L1 existente e abre a cena diretamente.
- A entrada em W1-L1 fica persistida desde o spawn.
- Reentrada na mesma fase preserva checkpoint.
- Save ausente/corrompido/incompatível não bloqueia Nova Jornada.
- Testes e workflows Godot/Docs aprovados; documentação atualizada.
