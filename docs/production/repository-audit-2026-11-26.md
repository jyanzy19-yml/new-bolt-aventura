# Auditoria de integridade do repositório — 2026-11-26

**Escopo:** revisão estática da estrutura, governança, skills/agentes, scripts centrais, testes e workflows da branch main.
**Branch das melhorias:** chore/bolt-quality-tooling-expansion.
**Limite:** esta auditoria não substitui execução local do Godot, teste no editor, exportação ou validação em Android físico.

## Resumo executivo

O repositório já contém uma fundação Godot 4.7.2, cenas iniciais, sistemas parciais e uma suíte headless. Ele ainda não contém a campanha, combate, inimigos, chefes, persistência de campanha ou um APK validado. A Etapa 1 foi registrada como entregue; a próxima etapa de implementação continua atribuída ao Claude Code.

A revisão não confirmou um bug de gameplay S0–S2 apenas por leitura estática. Foram identificadas fragilidades reais no processo de CI e na clareza dos registros de continuidade, além de riscos técnicos que exigem reprodução ou dispositivo físico.

## Achados confirmados e ações nesta branch

| ID | Severidade | Evidência | Ação |
|---|---|---|---|
| AUD-001 | S3 | godot-validation.yml era acionado em todo push/PR, inclusive alterações exclusivamente documentais, apesar de baixar e executar o engine. | Adicionados filtros de caminhos para arquivos do projeto Godot, testes, assets e workflow. Docs-only continua coberto pelo Docs CI. |
| AUD-002 | S2 de processo | O workflow confiava no exit code do runner. O runner conta falhas de teste, mas erros de script emitidos por callbacks/fluxos fora do retorno do teste poderiam aparecer no log sem necessariamente refletir no contador. | O workflow captura stdout/stderr e falha se detectar SCRIPT ERROR ou Parse Error, além de respeitar o exit code. |
| AUD-003 | S3 | O validador documental verificava metadados obrigatórios e nome de skill igual ao diretório, mas não detectava nomes duplicados nem impedia que agentes consultivos deixassem de ser read-only. | Adicionada verificação de unicidade de nomes e allowlist de ferramentas Read, Grep, Glob para agentes. |
| AUD-004 | S3 | COLLABORATION_STATE.md e CONTINUITY.md mantinham snapshots antigos que diziam que o projeto Godot não existia, embora seções posteriores registrassem a Etapa 1 entregue e project.godot presente. | Inserido snapshot vigente no início dos arquivos e identificado explicitamente o conteúdo anterior como histórico. |
| AUD-005 | S4 | README e catálogo contabilizavam 36 skills e 8 agentes; a expansão não poderia ser compreendida sem atualizar os índices. | Atualizados README, catálogo, índice de documentação e orientação dos agentes. |

## Riscos técnicos que permanecem abertos

### RISK-001 — Coordenadas de toque e transformações de viewport

TouchButton.contains_point() compara InputEventScreenTouch.position com Control.get_global_rect(). O comentário assume coordenadas de viewport. Isso pode estar correto na cena atual, mas precisa ser verificado com a hierarquia real de CanvasLayer, stretch, escala e proporções de tela. Não foi confirmado defeito.

**Teste necessário:** tocar nos limites de cada botão em diferentes resoluções/aspect ratios; repetir com stretch e overlays; comparar a posição do evento com o retângulo global do controle.

### RISK-002 — Conversão de safe area no Android

SafeAreaMargin.compute_insets() converte pixels físicos por escala de janela/viewport e assume janela ocupando a tela inteira. A hipótese pode falhar em multi-window, letterboxing, offsets de janela, rotação ou diferenças de API Android.

**Teste necessário:** aparelho físico, paisagem, recortes, navegação por gestos/botões e diferentes proporções; registrar valores de screen, safe rect, window e viewport.

### RISK-003 — Input acumulado global

SceneFlow._ready() desativa Input.use_accumulated_input globalmente para reduzir latência de eventos sintéticos. É uma decisão intencional, mas afeta o processamento global de input e não tem medição em aparelho.

**Teste necessário:** comparar latência de toque e custo de processamento em cena com multitouch/arrasto intenso, no mesmo dispositivo e build.

### RISK-004 — Carregamento threaded e interrupções

SceneFlow trata estados de carregamento não concluídos como falha e impede transições concorrentes. Ainda é necessário testar falha de recurso, app suspenso durante o carregamento, troca de cena repetida e retomada, verificando que input e overlay não ficam presos.

**Teste necessário:** testes de integração com recursos ausentes/inválidos, transição repetida, foco perdido e retorno ao app.

### RISK-005 — Validação real de controles e performance

Os testes headless comprovam lógica automatizada, não ergonomia, latência touch, barras do sistema, rendering, FPS ou consumo térmico.

**Teste necessário:** exportar APK de debug, instalar em aparelho identificado e executar a matriz Android. Não declarar 60 FPS sustentados sem captura prolongada.

## Expansão de skills e agentes

### Skills novas
- bolt-godot-debugging: diagnóstico de runtime, lifecycle, sinais, recursos e profiler.
- bolt-regression-engineering: desenho de regressões, runner confiável e prevenção de CI falso-verde.
- bolt-android-release-readiness: export, pacote, permissões, assinatura segura e proveniência do artefato.

### Agentes novos — todos read-only
- godot-integration-reviewer: contratos, ownership, sinais e ciclo de vida entre sistemas.
- android-release-auditor: configuração de export, pacote, permissões e evidências de release.
- persistence-integrity-auditor: save, checkpoints, migração e recuperação.

O router foi atualizado para encaminhar essas tarefas sem carregar todas as skills em cada solicitação.

## Validação desta entrega

- Alterações feitas em branch isolada; main não foi modificada.
- Não foi possível executar o Godot localmente neste ambiente.
- A validação automatizada desta branch deve ser confirmada pelo GitHub Actions após a abertura da PR.
- Nenhuma validação de editor gráfico, emulador, APK, aparelho físico, touch, safe area ou performance foi executada nesta auditoria.

## Próximas ações recomendadas

1. Aguardar Docs CI e Godot CI aplicáveis à PR.
2. Corrigir eventuais falhas de validação antes de integrar.
3. Durante a Etapa 2, usar bolt-godot-debugging e bolt-regression-engineering apenas nas áreas tocadas pelo Claude.
4. Executar RISK-001 a RISK-005 com cenas e aparelho reais antes de declarar a vertical slice Android validada.
5. Manter a PR #1 separada; esta branch não altera nem tenta resolver a divergência histórica dela.


## Addendum — snapshot atualizado após PR #46 — 2026-11-26

**Base de código:** `main` em `8ecfe0aa11eb911745bbe5e8e1b2211c03010702` (merge PR #46).  
**Último HEAD documental observado antes deste adendo:** `603a13a993e8bdf207bfd12b5789edb74a474ffe` (reconciliação do tracker SYS-026).  
**Método:** árvore Git recursiva via GitHub API, inspeção estática focalizada de scripts/cenas/testes e leitura das fontes mestras/ADRs. Nenhuma execução Godot local ou Android físico.

### Inventário atual da árvore Git

| Tipo | Quantidade |
|---|---:|
| Arquivos versionados | 288 |
| GDScript (.gd) | 56 |
| Cenas Godot (.tscn) | 19 |
| Recursos .tres | 1 |
| Testes unitários `tests/unit/test_*.gd` | 20 |
| Skills Claude | 39 |
| Agentes consultivos | 11 |

Essas contagens descrevem a árvore versionada na branch principal no momento da consulta; não são contagens de recursos importados/runtime.

### Estado Git e colaboração

- A branch principal contém as integrações até PR #46.
- A única PR aberta retornada pela busca é a PR #1 (`docs/master-directive-bolt`). Sua descrição afirma que o repositório seria apenas documental e exclui Dash; ambas as afirmações estão obsoletas em relação ao estado atual. Não mesclar sem rebase, revisão integral do diff e reconciliação dos documentos raiz.
- Há diversas branches históricas e divergentes. Não tratá-las como trabalho ativo nem mesclar automaticamente.
- O fluxo vigente mantém ChatGPT como escritor ativo único, conforme decisão do usuário registrada nos documentos de colaboração.

### Sistemas e arquivos inspecionados nesta sessão

- `project.godot`, `export_presets.cfg`, `scripts/core/scene_flow.gd`, `scripts/core/save_system.gd`, `scripts/campaign/campaign_progress.gd`.
- `scripts/player/bolt_player.gd`, `scripts/input/action_buffer.gd`, `scripts/input/touch_controls.gd`, `scripts/input/touch_button.gd`.
- `scripts/ui/hud.gd`, `scripts/ui/safe_area_margin.gd`, `scenes/ui/hud.tscn`.
- `scripts/world/platform_block.gd`, `scripts/world/moving_platform.gd`, `scripts/world/one_way_platform.gd`.
- `scripts/campaign/cybercore_w1_l1.gd`, testes de movimento, multitouch e plataforma unidirecional; documentos técnicos de touch/display, matriz QA, roadmap e diretriz mestre.

### Achados confirmados / estado de produção

1. **Package ID ainda é placeholder:** `com.example.boltaventura` em `export_presets.cfg`. Não substituir por domínio inventado; a identidade Android definitiva precisa de decisão do proprietário antes de release.
2. **Validação física Android não existe ainda:** APK debug exportado e assinatura v2/v3 verificada em CI não comprovam instalação, cold start, barras do sistema, safe area, toque, suspensão/retomada, FPS ou memória em aparelho.
3. **Safe area é risco conhecido, não bug reproduzido:** conversão de coordenadas precisa ser confrontada com valores reais de screen/safe rect/window/viewport em Android, especialmente telas com recorte, navegação por gestos e multi-window.
4. **Input acumulado global é decisão técnica sem benchmark físico:** `SceneFlow` desativa `Input.use_accumulated_input`; medir latência e custo sob multitouch/arrasto antes de declarar benefício.
5. **Touch é validado sinteticamente:** testes cobrem multitouch, reatribuição de pointer ID, cancelamento, pausa e transição; não medem digitalizador, latência ou ergonomia.
6. **Loading/SceneFlow:** threaded loading, overlay, pausa e input lock estão presentes; falha real de carregamento, suspensão durante transição e stress de memória precisam de testes de integração.
7. **Gameplay segue blockout/provisório:** `BoltPlayer` usa `BoltTuning` provisório; W1-L1/W1-L2 ainda são blockouts; placeholders de arte persistem.
8. **SYS-026 atualizado:** OneWayPlatform foi integrada na PR #46. Evidência disponível: Godot CI pré-merge 87 testes/548 verificações/0 falhas, Docs SUCCESS e Android Debug Export SUCCESS. A consulta de workflow runs do merge commit retornou zero execuções; não declarar pós-merge CI.
9. **SYS-025:** MovingPlatform permanece componente reutilizável integrado, com transporte de BOLT coberto por CI pós-merge PR #45; não foi inserido em fase.

### Fechamento da Etapa 01 — auditoria estática

A inspeção manual foi concluída para as 19 cenas Godot, os 30 scripts de runtime, o único recurso `.tres`, o ícone placeholder, `project.godot`, `export_presets.cfg`, as fontes mestras, ADRs, workflows e estado Git/PRs. A CI da PR #47 compilou os scripts e carregou/instanciou as cenas; a suíte passou com 88 testes/553 verificações/0 falhas. **Etapa 01: CONCLUÍDA — auditoria estática.**

Limites físicos Android permanecem no Gate 1/5: instalação, cold start, toque real, barras/safe area, interrupções, FPS e memória. Esses limites não invalidam a auditoria estática e não foram apresentados como testes executados.

### Achado adicional AUD-006 — estado inicial do campo energético

- **Severidade:** S2 funcional, isolado em configuração não padrão.
- **Causa:** `_active` começava em `false`; `_set_active(false)` retornava antes de aplicar `monitoring=false` e cor inativa quando `initial_active=false`.
- **Correção:** PR #47 adicionou estado explícito de inicialização, preservando o update deferred de `monitoring`.
- **Regressão:** teste de contato físico confirma `initial_active=false`, estado visual inativo, `monitoring=false` e ausência de dano durante a janela inicial.
- **Validação pré-merge:** Godot `45894563021` SUCCESS — 88 testes/553 verificações/0 falhas; Docs `45894562989` SUCCESS; Android Debug Export `45894563000` SUCCESS. APK 28.461.057 bytes, SHA-256 `4f5ab64b2c51aaa2c69656854d10e056b4a4881b2f00b1bfb56279bbe5bf0884`, assinatura v2/v3 válida. Merge `2636226c4027625649e66c51ff64d7e2e56168a6`. CI pós-merge main: Godot `45894802128` SUCCESS (88 testes/553 verificações/0 falhas), Docs `45894802067` SUCCESS e Android Export `45894802116` SUCCESS; APK 28.461.057 bytes, SHA-256 `c3ca03958eecf120f1a9f5f1e4fae3851fb7560bca303c8eb5a930f987b58123`, assinatura v2/v3 válida.

### Próxima etapa

Consolidar a matriz de rastreabilidade das 26 etapas (requisito → fonte canônica → sistema/arquivo → teste → critério de aceite) e reconciliar a Etapa 02. A auditoria estática já foi encerrada; não repetir inventário nem recriar o projeto.
\n\n### Correção de evidência de pós-merge\n\nA primeira consulta por workflow runs usou um wrapper que retorna somente execuções associadas ao evento `pull_request`, por isso não listou os workflows `push` disparados após merge. Consulta direta da lista de runs da branch `main` confirmou pós-merge CI para PR #46 (Godot `45888110305`, Docs `45888110285`, Android `45888110166`) e PR #47 (Godot `45894802128`, Docs `45894802067`, Android `45894802116`), todos SUCCESS. O registro foi corrigido para não declarar ausência de CI quando havia runs de push.\n