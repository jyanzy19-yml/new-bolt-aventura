# BOLT · AVENTURA — Documentação de produção

Este índice organiza a documentação de design, narrativa, tecnologia, produção e qualidade. O repositório também contém o projeto Godot 4.7.2 executável em estágio de fundação/protótipo (`project.godot`, `scenes/`, `scripts/`, `resources/` e `tests/`). Continue a base existente; os documentos distinguem decisões confirmadas, requisitos, propostas e pendências.

## Ponto de entrada obrigatório

- [Plano Mestre de Produção — 32 etapas](production/32-stage-production-plan.md) — plano operacional aprovado, critérios de aceite, migração rastreável da matriz histórica e pipeline de aprovação visual.

- [Diretiva de implementação integral e continuidade](production/from-zero-implementation-directive.md) — mandato completo de produção aplicado à base Godot existente; não recriar o projeto.
- [MASTER_DIRECTIVE.md](../MASTER_DIRECTIVE.md) — diretriz central para criação, produção, implementação e validação. Leia primeiro.
- [Master Game Design & Gameplay Prompt](prompts/master-game-design-and-gameplay-prompt.md) — diretiva detalhada de design e gameplay; deve ser lida em conjunto com as bíblias e decisões.
- [CLAUDE.md](../CLAUDE.md) — regras permanentes de trabalho do Claude Code.
- [AGENTS.md](../AGENTS.md) — regras para agentes de implementação e revisão.

## Mapa das oito áreas mestras

| Área | Documento-fonte |
|---|---|
| Diretriz central | [MASTER_DIRECTIVE.md](../MASTER_DIRECTIVE.md) |
| Game Bible | [Bíblia narrativa](game-design/01-narrative-bible.md), [personagens](game-design/03-character-bible.md) |
| Worlds & Level Design | [Bíblia dos mundos](game-design/02-world-bible.md), [padrão de fases](game-design/05-level-design-standard.md) |
| Gameplay Specification | [Sistemas de gameplay](game-design/04-gameplay-systems.md) |
| UI/UX Specification | [UI/UX e acessibilidade](game-design/06-ui-ux.md) |
| Technical Specification | Documentos em [technical](technical/) |
| Production Roadmap | [Roadmap](production/roadmap.md), [status da etapa](production/stage-status.md), [gestão de mudanças](production/change-management.md) |
| QA & Acceptance | [Matriz de QA](qa/test-matrix.md), [Definition of Done](production/definition-of-done.md) |

## Design

1. [Visão geral e pilares](game-design/00-game-overview.md)
2. [Bíblia narrativa](game-design/01-narrative-bible.md)
3. [Bíblia dos sete mundos](game-design/02-world-bible.md)
4. [Personagens, inimigos e chefes](game-design/03-character-bible.md)
5. [Padrão de level design](game-design/05-level-design-standard.md)
6. [Sistemas de gameplay](game-design/04-gameplay-systems.md)
7. [UI/UX e acessibilidade](game-design/06-ui-ux.md)
8. [Direção de arte e áudio](game-design/07-art-audio-direction.md)
9. [W1-L3 — Fábrica de Ecos (blockout provisório)](game-design/W1-L3-fabrica-de-ecos.md)

## Skills e agentes

- [Catálogo de skills](skills-catalog.md) — conjunto selecionado, regras de carregamento e proveniência.
- **39 skills Claude Code:** `.claude/skills/`; carregar apenas as necessárias. Inclui diagnóstico Godot, engenharia de regressão e prontidão de release Android.
- **11 agentes consultivos read-only:** `.claude/agents/`; incluem revisão de integração Godot, release Android e integridade de persistência.

## Engenharia

- [ADR-0005 — fluxo Nova Jornada/Continuar](decisions/ADR-0005-main-menu-campaign-entry.md)
- [Plano — fluxo Nova Jornada/Continuar](production/plans/2026-11-26-main-menu-new-game-continue.md)
- [Handoff — fluxo Nova Jornada/Continuar](production/handoffs/HANDOFF_MAIN_MENU_CONTINUE.md)

- [Princípios de arquitetura Godot](technical/00-architecture-principles.md)
- [Especificação Android e desempenho](technical/01-android-performance.md)
- [Instrumentação de performance em builds debug](technical/10-performance-instrumentation.md)
- [Política de ciclo de vida de recursos](technical/11-resource-lifecycle-policy.md)
- [Input touch, tela e áreas seguras](technical/02-touch-and-display.md)
- [Carregamento e recursos](technical/03-loading-and-assets.md)
- [Checklist de build Android](technical/04-android-build-checklist.md)
- [Contratos entre sistemas](technical/05-system-contracts.md)
- [Fundação do projeto Godot — estado real](technical/06-godot-project-foundation.md)
- [Pipeline de CI e validação](production/CI_AND_VALIDATION_PIPELINE.md)
- [Pipeline de assets e aprovação visual](production/ASSET_PIPELINE.md)
- [Fila rastreável de assets](production/ASSET_REQUEST_QUEUE.md)

## Produção e qualidade

- [Roadmap e gates](production/roadmap.md)
- [Protocolo de qualidade](production/quality-control-protocol.md)
- [Checklist de execução e aceite da Etapa 0](production/ETAPA_0_CLAUDE_CHECKLIST.md)
- [Revisão de fundação da Etapa 0 — hardening](production/stage-0-hardening-audit.md)
- [Auditoria de pré-produção](production/PREPRODUCTION_AUDIT.md)
- [Protocolo histórico/condicional de colaboração Claude Code ↔ ChatGPT](production/COLLABORATIVE_DEVELOPMENT_PROTOCOL.md) — só aplicar quando o usuário reativar explicitamente a alternância; o escritor vigente consta em `COLLABORATION_STATE.md` (atualmente ChatGPT).
- [Estado canônico da colaboração](production/COLLABORATION_STATE.md) — etapa atual, responsável, commit-base e próximo turno.
- [Configuração de acesso dos agentes](production/AGENT_ACCESS_SETUP.md) — diferença entre contexto de leitura e acesso real de escrita/commit.
- [Template obrigatório de handoff](production/HANDOFF_TEMPLATE.md) — transferência verificável entre os agentes.
- [Handoff da Etapa 0](production/handoffs/HANDOFF_ETAPA_0.md) — entrega da fundação Godot (Claude Code → ChatGPT).
- [Continuidade entre sessões](production/CONTINUITY.md)
- [Rastreador de implementação — 24 sistemas e 42 fases](production/implementation-tracker.md)
- [Gestão de mudanças](production/change-management.md)
- [Definition of Done](production/definition-of-done.md)
- [Matriz de QA](qa/test-matrix.md)
- [Template de sessão Android](qa/ANDROID_DEVICE_TEST_TEMPLATE.md)
- [Modelo de bug report](qa/bug-report-template.md)
- [Captura de performance](qa/performance-capture-template.md)
- [Relatório de validação do ecossistema](production/validation-report.md)
- [Estado da etapa](production/stage-status.md)
- [Registro de decisões](decisions/README.md)
- [Modelos de trabalho](templates/README.md)

## Status de informação

- **Confirmado:** declarado explicitamente pelo usuário ou registrado em decisão aprovada.
- **Requisito:** critério obrigatório ainda sujeito a verificação de implementação.
- **Proposta:** solução sugerida, ainda não aprovada.
- **A definir:** informação ausente; não inventar.
- **Implementado:** presente no projeto executável e inspecionado.
- **Validado:** comprovado por teste identificável.

## Automação e colaboração

- Validador local: scripts/validate_project_docs.py.
- CI documental: .github/workflows/docs-validation.yml.
- Modelos de issue e pull request: .github/ISSUE_TEMPLATE/ e .github/PULL_REQUEST_TEMPLATE.md.
- Comandos Claude Code: /bolt-audit, /bolt-plan, /bolt-qa, /bolt-android-review, /bolt-continue e /bolt-release-check.
- O usuário inicia manualmente o agente indicado no estado canônico; não há transferência automática de sessão.

Atualize este índice quando documentos forem adicionados ou movidos. Use links relativos e confira se todos resolvem.

## Referências complementares

- [Relatório de validação estrutural](production/validation-report.md)
- [Auditoria de integridade do repositório — 2026-11-26](production/repository-audit-2026-11-26.md)
- [Plano Mestre de Produção — 32 etapas](production/32-stage-production-plan.md) — fonte operacional vigente.
- [Matriz histórica das 26 etapas](production/26-stage-traceability-matrix.md) — preservada para rastreabilidade legada e crosswalk 26→32.
- [Registro de lacunas e decisões — Etapa 02](production/requirements-gap-register.md) — requisitos ainda a definir, prioridades, dependências e decisões já fechadas.
- [Mapa da arquitetura atual](technical/09-current-architecture-map.md) — autoloads, fluxo de boot, ownership de estado, contratos e lacunas arquiteturais.
- [Checklist de release Android](production/android-release-checklist.md)
