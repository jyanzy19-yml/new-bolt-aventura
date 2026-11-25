# BOLT · AVENTURA — Documentação de produção

Este índice organiza a documentação de design, narrativa, tecnologia, produção e qualidade. Os documentos distinguem decisões confirmadas, requisitos, propostas e informações ainda pendentes.

## Diretiva Mestra
A especificação principal de produto e execução está dividida em partes para consulta e manutenção:
- [Índice da Diretiva Mestra](master-directive/README.md)
- [00 — Mandato, autonomia e identidade](master-directive/00-mandato-identidade.md)
- [01 — Campanha e sete universos](master-directive/01-campanha-e-universos.md)
- [02 — Antagonista e inimigos](master-directive/02-antagonista-e-inimigos.md)
- [03 — Bolt, movimentação e combate](master-directive/03-bolt-movimentacao-combate.md)
- [04 — Fluxo, menus e cinemáticas](master-directive/04-fluxo-menus-e-cinematicas.md)
- [05 — HUD, controles e configurações](master-directive/05-hud-controles-configuracoes.md)
- [06 — Progressão e salvamento](master-directive/06-progressao-e-salvamento.md)
- [07 — Arquitetura e assets](master-directive/07-arquitetura-e-assets.md)
- [08 — Android e performance](master-directive/08-android-performance.md)
- [09 — GitHub, CI e QA](master-directive/09-github-ci-e-qa.md)
- [10 — Documentação e skills](master-directive/10-documentacao-e-skills.md)
- [11 — Etapas e conclusão](master-directive/11-etapas-e-conclusao.md)

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
- **Confirmado:** declarado explicitamente no contexto aprovado.
- **Requisito:** critério que o produto deve cumprir.
- **Proposta:** solução recomendada, ainda sujeita a aprovação.
- **A definir:** informação ausente; não inventar.
- **Validado:** comprovado por inspeção ou teste identificável.

## Automação e colaboração
- Validador local: `scripts/validate_project_docs.py`.
- CI: `.github/workflows/docs-validation.yml`.
- Modelos de issue e pull request: `.github/ISSUE_TEMPLATE/` e `.github/PULL_REQUEST_TEMPLATE.md`.

Atualize este índice quando documentos forem adicionados ou movidos. Use links relativos e confira se todos resolvem.

## Referências complementares
- [Relatório de validação estrutural](production/validation-report.md)
- [Checklist de build Android](technical/04-android-build-checklist.md)
- [Status da etapa](production/stage-status.md)
- [Checklist de release Android](production/android-release-checklist.md)
- [Template de captura de performance](qa/performance-capture-template.md)
