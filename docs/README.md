# BOLT · AVENTURA — Documentação de produção

Este índice organiza a documentação de design, narrativa, tecnologia, produção e qualidade. Os documentos distinguem decisões confirmadas, requisitos, propostas e informações ainda pendentes.

## Ponto de entrada obrigatório
- [MASTER_DIRECTIVE.md](../MASTER_DIRECTIVE.md) — diretriz central para criação, produção, implementação e validação. Leia primeiro.
- [Master Game Design & Gameplay Prompt](prompts/master-game-design-and-gameplay-prompt.md) — diretiva detalhada de design e gameplay; deve ser lida em conjunto com as bíblias e decisões.
- [CLAUDE.md](../CLAUDE.md) — regras permanentes de trabalho do Claude Code.

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
5. [Sistemas de gameplay](game-design/04-gameplay-systems.md)
6. [Padrão de level design](game-design/05-level-design-standard.md)
7. [UI/UX e acessibilidade](game-design/06-ui-ux.md)
8. [Direção de arte e áudio](game-design/07-art-audio-direction.md)

## Engenharia
- [Princípios de arquitetura Godot](technical/00-architecture-principles.md)
- [Especificação Android e desempenho](technical/01-android-performance.md)
- [Input touch, tela e áreas seguras](technical/02-touch-and-display.md)
- [Carregamento e recursos](technical/03-loading-and-assets.md)
- [Checklist de build Android](technical/04-android-build-checklist.md)
- [Contratos entre sistemas](technical/05-system-contracts.md)

## Produção e qualidade
- [Roadmap e gates](production/roadmap.md)
- [Gestão de mudanças](production/change-management.md)
- [Definition of Done](production/definition-of-done.md)
- [Matriz de QA](qa/test-matrix.md)
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
- Validador local: `scripts/validate_project_docs.py`.
- CI: `.github/workflows/docs-validation.yml`.
- Modelos de issue e pull request: `.github/ISSUE_TEMPLATE/` e `.github/PULL_REQUEST_TEMPLATE.md`.

Atualize este índice quando documentos forem adicionados ou movidos. Use links relativos e confira se todos resolvem.

## Referências complementares
- [Relatório de validação estrutural](production/validation-report.md)
- [Checklist de release Android](production/android-release-checklist.md)
