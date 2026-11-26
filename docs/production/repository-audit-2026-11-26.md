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
