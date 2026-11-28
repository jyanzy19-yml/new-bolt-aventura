# Inventário e limpeza do repositório — 2026-11-28

## Escopo e método

Baseline: `7fb5be25a3f7601d9a3f3ffe27006b524f1aa9d3`. A árvore Git recursiva contém 417 arquivos versionados. Stack soberana: HTML5/CSS3, JavaScript ES Modules, Canvas 2D e Vite; a reconstrução não é migração Godot. O histórico Git não foi reescrito.

Classificações: KEEP (manter), ADAPT (alinhar), ARCHIVE (preservar como histórico), REMOVE (retirar da árvore ativa), REVIEW (ambiguidade pendente). Cada path do baseline aparece uma vez nas tabelas abaixo.

## Resultado

| Classe | Quantidade |
|---|---:|
| KEEP | 151 |
| ADAPT | 53 |
| ARCHIVE | 44 |
| REMOVE | 169 |
| REVIEW | 0 |
| **Total** | **417** |

## Regra de remoção

Foram retirados apenas projeto/configuração/export Godot, cenas `.tscn`, recursos `.tres`, scripts GDScript e UIDs, testes GDScript, workflows de validação/export Godot, skills específicas Godot e o revisor específico da engine. O validador documental Python foi mantido; o teste JavaScript do scaffold e o ícone SVG genérico foram mantidos. Os arquivos removidos continuam recuperáveis nos commits anteriores; não houve force-push nem reescrita do histórico.

## KEEP — 151 paths

| Path | Classe | Justificativa / destino |
|---|---|---|
| `.claude/agents/README.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/agents/android-performance-engineer.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/agents/android-release-auditor.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/agents/architecture-reviewer.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/agents/art-audio-director.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/agents/game-architect.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/agents/gameplay-engineer.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/agents/gameplay-reviewer.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/agents/level-designer.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/agents/mobile-performance-reviewer.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/agents/narrative-continuity-reviewer.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/agents/narrative-designer.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/agents/persistence-integrity-auditor.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/agents/qa-engineer.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/agents/qa-reviewer.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/agents/ui-ux-designer.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/commands/README.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/commands/bolt-android-review.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/commands/bolt-audit.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/commands/bolt-continue.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/commands/bolt-handoff.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/commands/bolt-plan.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/commands/bolt-qa.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/commands/bolt-release-check.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/commands/bolt-review.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/android-capacitor-packaging/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/android-web-performance/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/asset-provenance-qa/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/assets-loading-audio/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/audio-design/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/audio-design/references/adaptive-music.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/bolt-android-release-readiness/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/bolt-android-touch/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/bolt-boss-encounters/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/bolt-cinematic-sequences/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/bolt-content-pipeline/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/bolt-mobile-ui/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/bolt-performance-validation/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/bolt-production-gates/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/bolt-regression-engineering/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/bolt-save-integrity/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/bolt-world-continuity/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/browser-webview-compatibility/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/camera-systems/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/camera-systems/references/follow-and-framing.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/canvas-rendering-performance/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/canvas2d-runtime/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/collaborative-development/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/create-game-assets/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/create-game-assets/assets/art-direction-brief.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/create-game-assets/assets/asset-manifest.json` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/create-game-assets/references/art-direction.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/create-game-assets/references/provenance.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/create-game-assets/references/raster-pipeline.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/create-game-assets/references/three-d-pipeline.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/create-game-assets/scripts/asset_report.py` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/create-game-assets/scripts/build_preview_sheet.py` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/create-game-assets/scripts/requirements.txt` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/deterministic-gameplay-testing/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/dialogue-systems/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/dialogue-systems/references/ink-and-yarn.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/dialogue-systems/references/runner.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/enemy-boss-design/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/game-ai/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/game-ai/references/fsm-perception-steering.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/game-ai/references/pathfinding.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/game-feel/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/game-feel/references/feedback-recipes.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/game-ui-ux/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/game-ui-ux/references/layout-and-flow.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/gameplay-physics-loop/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/html5-game-architecture/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/input-systems/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/input-systems/references/buffering-and-accessibility.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/level-design-content/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/level-design/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/level-design/references/pacing-and-flow.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/mobile-input-ux/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/performance-optimization/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/performance-optimization/references/profiling-and-budgets.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/persistence-save-integrity/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/physics-tuning/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/physics-tuning/references/timestep-and-ccd.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/platformer/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/platformer/references/feel-tuning.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/router/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/router/references/custom-engines.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/router/references/engine-detection.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/router/references/routing-table.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/save-systems/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/save-systems/references/versioning-and-migration.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/ui-ux-accessibility/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/web-game-qa/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.claude/skills/web-tooling-ci/SKILL.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.editorconfig` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.github/ISSUE_TEMPLATE/bug_report.yml` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.github/ISSUE_TEMPLATE/config.yml` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.github/ISSUE_TEMPLATE/feature_request.yml` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.github/ISSUE_TEMPLATE/work-item.yml` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.github/PULL_REQUEST_TEMPLATE.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.github/dependabot.yml` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.github/pull_request_template.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.github/workflows/ci.yml` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.github/workflows/codeql.yml` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.github/workflows/docs-validation.yml` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.nvmrc` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `.prettierrc.json` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `AGENTS.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `CLAUDE.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `CONTRIBUTING.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `MASTER_DIRECTIVE.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `SECURITY.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `THIRD_PARTY_NOTICES/awesome-gamedev-agent-skills/LICENSE` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `THIRD_PARTY_NOTICES/awesome-gamedev-agent-skills/NOTICE` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/PROJECT_CONTEXT_HTML5.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/architecture/HTML5_RUNTIME_CONTRACTS.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/assets/ASSET_PIPELINE.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/game-design/00-game-overview.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/game-design/01-narrative-bible.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/game-design/02-world-bible.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/game-design/03-character-bible.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/game-design/04-gameplay-systems.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/game-design/05-level-design-standard.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/game-design/06-ui-ux.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/game-design/07-art-audio-direction.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/game-design/EXPANDED-42-LEVEL-CAMPAIGN-BLUEPRINT.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/game-design/EXPANDED-GAMEPLAY-SYSTEMS.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/game-design/EXPANDED-NARRATIVE-DOSSIER.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/game-design/W1-L3-fabrica-de-ecos.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/game-design/W1-L4-laboratorio-de-memorias.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/performance/ANDROID_PERFORMANCE_PROFILE.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/prompts/master-game-design-and-gameplay-prompt.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/qa/ANDROID_DEVICE_TEST_TEMPLATE.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/qa/HTML5_TEST_STRATEGY.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/qa/bug-report-template.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/qa/performance-capture-template.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/qa/test-matrix.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/release/ANDROID_RELEASE_CHECKLIST.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/templates/README.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/templates/decision-record.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `docs/templates/implementation-plan.md` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `eslint.config.js` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `icon.svg` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `index.html` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `package.json` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `scripts/validate_project_docs.py` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `src/core/math.js` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `src/main.js` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `src/styles.css` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `tests/core/math.test.js` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |
| `vite.config.js` | KEEP | Conteúdo ativo, canon, tooling web, documentação ou referência engine-neutral. |

## ADAPT — 53 paths

| Path | Classe | Justificativa / destino |
|---|---|---|
| `.claude/skills/README.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `.gitignore` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `README.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/README.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/decisions/ADR-0001-HTML5-CLEAN-START.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/decisions/ADR-0001-android-target.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/decisions/ADR-0003-android-system-bars.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/decisions/ADR-0004-campaign-progress-schema.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/decisions/ADR-0005-main-menu-campaign-entry.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/decisions/ADR-0006-campaign-progress-w1-l2.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/decisions/ADR-TEMPLATE.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/decisions/README.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/26-stage-traceability-matrix.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/26_STAGE_WORKFLOW.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/32-stage-production-plan.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/ADR-001-DASH.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/AGENT_ACCESS_SETUP.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/AGENT_TASK_TEMPLATE.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/ASSET_PIPELINE.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/ASSET_REQUEST_QUEUE.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/CI_AND_VALIDATION_PIPELINE.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/COLLABORATION_STATE.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/COLLABORATIVE_DEVELOPMENT_PROTOCOL.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/CONTINUITY.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/DEFINITION_OF_DONE.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/ETAPA_0_CLAUDE_CHECKLIST.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/GITHUB_ACTIONS_SETUP.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/HANDOFF_TEMPLATE.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/HTML5_REBUILD_PLAN.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/LEVEL_SPEC_TEMPLATE.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/LOCKFILE_AND_DEPENDENCIES.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/PREPRODUCTION_AUDIT.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/REPOSITORY_GOVERNANCE.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/android-release-checklist.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/change-management.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/definition-of-done.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/from-zero-implementation-directive.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/quality-control-protocol.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/repository-polish-audit-2026-11-26.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/requirements-gap-register.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/production/roadmap.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/skills-catalog.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/technical/00-architecture-principles.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/technical/01-android-performance.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/technical/02-touch-and-display.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/technical/03-loading-and-assets.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/technical/04-android-build-checklist.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/technical/05-system-contracts.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/technical/07-save-system.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/technical/08-campaign-progress.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/technical/09-current-architecture-map.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/technical/10-performance-instrumentation.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |
| `docs/technical/11-resource-lifecycle-policy.md` | ADAPT | Documento de processo/contrato a alinhar com HTML5; mantido ou atualizado sem descarte de conteúdo. |

## ARCHIVE — 44 paths

| Path | Classe | Justificativa / destino |
|---|---|---|
| `BOLT_MASTER_CONTEXT.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/decisions/ADR-0002-godot-direction.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/handoffs/HANDOFF_ENEMY_COMBAT.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/handoffs/HANDOFF_ETAPA_0.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/handoffs/HANDOFF_ETAPA_1.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/handoffs/HANDOFF_ETAPA_2_CLAUDE.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/handoffs/HANDOFF_HEALTH_PICKUP_FEEDBACK.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/handoffs/HANDOFF_MAIN_MENU_CONTINUE.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/implementation-tracker.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-26-action-buffer-lifecycle-clear.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-26-android-app-pause-input-release.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-26-android-debug-export-pipeline.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-26-camera-contracts.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-26-canonical-decisions-and-writer-authority.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-26-health-pickup-physical-contact.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-26-main-menu-new-game-continue.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-26-moving-platform-system.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-26-one-way-platform.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-26-save-system-test-isolation.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-26-scene-flow-input-lock.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-26-scene-loading-overlay.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-26-strict-save-version-validation.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-26-timed-energy-gate-initial-state.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-26-w1-l2-checkpoint-feedback.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-26-w1-l2-energy-network-progression.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-27-campaign-selection-end-to-end.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-27-campaign-world-phase-selection.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-27-stage13-one-way-platform-physics-integration.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-27-stage14-health-checkpoint-respawn-integration.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-27-stage14-player-defeat-feedback-contract.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-27-stage14-respawn-movement-state-contract.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-27-stage14-w1-l1-checkpoint-persistence-failure.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-27-stage14-w1-l1-killzone-recovery-contract.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-27-stage15-enemy-projectile-lifecycle-integration.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-27-stage15-enemy-terminal-lifecycle-regression.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-27-stage23-w1-l3-provisional-blockout-integration.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-27-stage29-transition-telemetry.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-27-w1-l3-canonical-atlas-correction.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/plans/2026-11-27-w1-l4-memory-lab-blockout.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/repository-audit-2026-11-26.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/stage-0-hardening-audit.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/stage-status.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/production/validation-report.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |
| `docs/technical/06-godot-project-foundation.md` | ARCHIVE | Registro da fase Godot preservado para rastreabilidade; não é instrução operacional atual. |

## REMOVE — 169 paths

| Path | Classe | Justificativa / destino |
|---|---|---|
| `.claude/agents/godot-integration-reviewer.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/bolt-godot-debugging/SKILL.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-2d-movement/SKILL.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-2d-movement/assets/test_character_controller.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-2d-movement/references/controller-recipes.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-animation/SKILL.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-animation/assets/test_animation_states.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-animation/references/animation-tree-and-tween.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-audio/SKILL.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-audio/assets/check_audio_buses.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-audio/references/buses-and-effects.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-export/SKILL.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-export/references/presets-and-cli.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-gdscript-headless-testing/SKILL.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-gdscript/SKILL.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-gdscript/assets/check_scripts_compile.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-gdscript/references/annotations-and-typing.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-nodes-scenes/SKILL.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-nodes-scenes/references/tree-and-instancing.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-physics/SKILL.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-physics/references/bodies-and-queries.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-project-structure/SKILL.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-resources/SKILL.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-resources/references/resource-patterns.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-signals-groups/SKILL.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-signals-groups/references/signal-patterns.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-tilemap/SKILL.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-tilemap/references/tileset-and-terrains.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-ui-control/SKILL.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.claude/skills/godot-ui-control/references/layout-and-theming.md` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.github/workflows/android-debug-export.yml` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.github/workflows/godot-validation.yml` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `.godot-version` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `export_presets.cfg` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `icon.svg.import` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `project.godot` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `resources/player/bolt_tuning_provisional.tres` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/boot/boot.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/campaign/cybercore_w1_l1.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/campaign/cybercore_w1_l2.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/campaign/cybercore_w1_l3.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/campaign/cybercore_w1_l4.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/campaign/opening_cinematic.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/combat/bolt_health_pickup.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/combat/chrono_projectile.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/combat/training_target.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/enemies/cybercore_patrol_enemy.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/levels/checkpoint.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/levels/industrial_press.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/levels/narrative_beat_trigger.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/levels/sandbox/movement_sandbox.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/levels/timed_energy_gate.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/player/bolt.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/tutorial/tutorial.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/ui/hud.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/ui/loading_overlay.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/ui/main_menu.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/ui/phase_selection.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/ui/world_selection.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/world/alternating_platform.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/world/conveyor_belt.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/world/moving_platform.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/world/one_way_platform.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scenes/world/platform_block.tscn` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/campaign/campaign_catalog.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/campaign/campaign_progress.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/campaign/cybercore_w1_l1.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/campaign/cybercore_w1_l2.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/campaign/cybercore_w1_l3.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/campaign/cybercore_w1_l4.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/campaign/opening_cinematic.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/combat/bolt_combat.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/combat/bolt_health.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/combat/bolt_health_pickup.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/combat/chrono_projectile.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/combat/training_target.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/core/boot.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/core/boot.gd.uid` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/core/performance_probe.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/core/save_system.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/core/scene_flow.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/core/scene_flow.gd.uid` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/enemies/cybercore_patrol_enemy.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/input/action_buffer.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/input/action_buffer.gd.uid` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/input/actions.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/input/actions.gd.uid` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/input/touch_button.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/input/touch_button.gd.uid` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/input/touch_controls.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/input/touch_controls.gd.uid` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/levels/bolt_checkpoint.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/levels/industrial_press.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/levels/movement_sandbox.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/levels/movement_sandbox.gd.uid` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/levels/narrative_beat_trigger.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/levels/timed_energy_gate.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/player/bolt_player.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/player/bolt_player.gd.uid` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/player/bolt_tuning.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/player/bolt_tuning.gd.uid` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/tutorial/tutorial.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/ui/campaign_selection_entry.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/ui/hud.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/ui/hud.gd.uid` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/ui/loading_overlay.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/ui/main_menu.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/ui/main_menu.gd.uid` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/ui/phase_selection.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/ui/safe_area_margin.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/ui/safe_area_margin.gd.uid` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/ui/world_selection.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/world/alternating_platform.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/world/conveyor_belt.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/world/moving_platform.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/world/one_way_platform.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/world/platform_block.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `scripts/world/platform_block.gd.uid` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/bolt_test.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/bolt_test.gd.uid` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/capture_campaign_selection.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/test_runner.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/test_runner.gd.uid` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_action_buffer.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_action_buffer.gd.uid` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_boot.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_camera_contract.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_campaign_catalog.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_campaign_entry.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_campaign_progress.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_campaign_selection_flow.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_checkpoints.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_chrono_projectile.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_combat_core.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_enemy_combat.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_enemy_lifecycle.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_health_component_contract.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_health_pickup_lifecycle.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_input_contract.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_input_contract.gd.uid` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_loading_overlay.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_moving_platform.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_one_way_platform.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_performance_probe.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_player_movement.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_player_movement.gd.uid` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_player_respawn_movement_contract.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_project_config.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_project_config.gd.uid` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_safe_area.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_safe_area.gd.uid` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_sandbox_playthrough.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_sandbox_playthrough.gd.uid` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_save_system.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_scene_flow.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_scene_flow.gd.uid` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_scenes_and_scripts.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_scenes_and_scripts.gd.uid` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_stage14_player_defeat_feedback_contract.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_stage14_w1_l1_checkpoint_persistence_failure_contract.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_stage14_w1_l1_killzone_recovery_contract.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_threaded_scene_loading.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_touch_controls.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_touch_controls.gd.uid` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_w1_l2_progression.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_w1_l3_blockout.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_w1_l3_factory_mechanics.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_w1_l4_memory_lab.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |
| `tests/unit/test_z_runner_isolation.gd` | REMOVE | Artefato exclusivo Godot/GDScript retirado da árvore ativa; recuperável no histórico Git. |

## REVIEW — 0 paths

| Path | Classe | Justificativa / destino |
|---|---|---|
| — | REVIEW | Nenhum path nesta classe. |

## Limites

O inventário comprova a classificação do baseline. A remoção efetiva, integridade do diff e qualidade do novo scaffold dependem da validação da branch e dos workflows. A fundação HTML5 é apenas scaffold; não comprova gameplay, vertical slice, APK Capacitor ou validação Android física.
