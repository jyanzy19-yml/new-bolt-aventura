# Revisão de fundação — Etapa 0 — 2026-11-26

## Escopo

Revisão estática da fundação Godot criada na Etapa 0, com foco em integridade do runner, ciclo de vida Android, clareza dos handoffs e coerência do estado colaborativo. Não é uma validação de gameplay em dispositivo físico.

Branch de trabalho: `chore/bolt-stage-0-hardening`, baseada no merge da PR #2 (`6f8bae6`).

## Achados e correções

| ID | Severidade | Achado | Correção nesta branch |
|---|---|---|---|
| ST0-01 | S2 de QA | `BoltTest.list_files()` retorna lista vazia se o diretório de testes não puder ser aberto. O runner não verificava se algum teste/check foi executado; uma suíte vazia poderia terminar com exit code 0. | `tests/test_runner.gd` agora falha quando descobre zero testes ou executa zero verificações. |
| ST0-02 | S3 / risco de lifecycle | `SafeAreaMargin` recalculava insets somente em `Window.size_changed`. Após suspensão/retomada ou mudança de orientação/recorte sem mudança detectável no tamanho lógico, margens poderiam ficar desatualizadas. | Recalcula também em `Viewport.size_changed`, `NOTIFICATION_APPLICATION_RESUMED` e notificações de foco. Recalcular é idempotente. |
| ST0-03 | S3 documental | Comentário de `SceneFlow` atribuía uma estimativa de latência de 16 ms a uma medição headless, o que poderia ser interpretado como medição de input real. | Comentário agora distingue propagação de evento sintético de latência/custo real, que continuam sem medição Android. |
| ST0-04 | S3 documental | O handoff da Etapa 0 deixava como pendente a aceitação da ampliação de escopo, embora o handoff da Etapa 1 já registrasse que ela foi aceita. | Handoff e checklist agora registram a exceção específica como ACCEPTED e mantêm tuning/sandbox como provisórios. |
| ST0-05 | S2 de governança | `COLLABORATION_STATE.md` continha snapshots antigos com estados incompatíveis (projeto ausente/Etapa 0 PENDING) abaixo do estado vigente, permitindo que agentes retomassem pelo trecho errado. | Documento reestruturado: estado atual no topo, matriz única de etapas, protocolo de início e histórico resumido. |

## Revisão estática dos sistemas da fundação

Inspecionados: `project.godot`, `SceneFlow`, `TouchControls`, `TouchButton`, `ActionBuffer`, `BoltPlayer`, `BoltTuning`, `SafeAreaMargin`, boot, menu, HUD, sandbox, export preset, runner e testes de touch/safe area/action buffer/scene flow.

- Não foi confirmado bug de gameplay S0–S2 apenas pela leitura estática desta rodada.
- A orientação `window/handheld/orientation=4` corresponde a Sensor Landscape no enum Godot; está coerente com a decisão de produto. A viewport 960×540 e GL Compatibility permanecem escolhas técnicas provisórias.
- O preset Android mantém `com.example.boltaventura` como package ID placeholder; isso deve ser definido antes de distribuição, não inventado nesta revisão.
- A sandbox é somente ambiente de teste de movimento; não conta como uma das 42 fases.
- O defeito S3 de reatribuição de ponteiro identificado na Etapa 1 permanece corrigido e coberto por regressão.

## Riscos ainda não resolvidos

1. **Coordenadas touch:** a correspondência entre posição de eventos e retângulos dos controles precisa de validação em aparelho, incluindo stretch, proporções e CanvasLayer.
2. **Safe area real:** a nova atualização em retomada reduz risco de insets obsoletos, mas não prova conversão correta em todas as janelas, fabricantes, recortes e modos imersivos.
3. **Input acumulado:** `Input.use_accumulated_input = false` permanece decisão sem medição real de latência/custo em Android.
4. **Feel do movimento:** nenhum teste humano documentado confirmou aceleração, altura de salto, dash, coyote ou buffer.
5. **Exportação:** package ID é placeholder e não há APK exportado/instalado nesta revisão.
6. **Performance:** não há frame-time, p95/p99, memória ou sessão térmica medidos em aparelho.

## Evidências e limites

- A suíte anteriormente passou no Godot CI #36: 42 testes, 171 verificações, 0 falhas, em Godot 4.7.2 headless. Isso é evidência anterior às mudanças desta branch.
- A validação desta branch deve ser confirmada pelo GitHub Actions após abrir a PR.
- Godot local/editor, exportação APK, emulador, Android físico, touch real, barras, renderização e performance: **NÃO EXECUTADOS** nesta revisão.

## Decisão de continuidade

A Etapa 0 permanece **ACCEPTED**; esta é uma hardening pass complementar, não uma reabertura da etapa nem uma mudança de canon. Após os checks passarem e a PR ser integrada, Claude Code pode assumir a Etapa 2, auditar o HEAD e continuar o Gate 1.
