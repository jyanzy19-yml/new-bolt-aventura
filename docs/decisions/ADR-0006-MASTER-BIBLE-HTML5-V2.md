# ADR-0006 — Adoção da Bíblia Mestre HTML5 v2.0

- **Status:** ACCEPTED — consolidação documental da decisão tecnológica já aprovada
- **Data:** 2026-11-28
- **Responsável:** Product Owner / equipe de engenharia
- **Escopo:** autoridade documental, canon, requisitos e orientação de produção

## Contexto

A reconstrução do BOLT · AVENTURA foi aprovada como jogo HTML5 desenvolvido do zero, sem engine de jogos. A stack vigente é HTML5, CSS3, JavaScript ES Modules, Canvas 2D e Vite, com Web Audio API e Pointer Events. Capacitor permanece candidato para empacotamento Android após validação.

O repositório contém documentos históricos da fase Godot e documentos HTML5 derivados do contexto anterior. Para reduzir divergências, foi consolidada uma Bíblia Mestre HTML5 v2.0.

## Decisão

1. Adotar `docs/game-design/BOLT_MASTER_BIBLE_HTML5_V2.md` como referência consolidada de produto e engenharia.
2. Manter `MASTER_DIRECTIVE.md` como diretiva operacional e hierarquia de autoridade.
3. Manter ADRs especializados como autoridade para decisões técnicas específicas.
4. Tratar Godot/GDScript como histórico, sem instrução ativa de implementação.
5. Preservar o canon, os sete mundos, sete fragmentos, 42 fases planejadas e mecânicas aprovadas, incluindo Dash.
6. Não inferir que a atualização documental significa que todos os sistemas, fases, assets ou builds já existem.
7. Atualizar os documentos de continuidade quando a PR for integrada, registrando o commit real e os testes realmente executados.

## Consequências

- Agentes devem ler esta Bíblia antes de alterar sistemas ou conteúdo relevante.
- A stack HTML5 é obrigatória; não utilizar engine de jogos.
- Conteúdo planejado permanece distinto de conteúdo implementado/testado/verificado.
- Mudanças futuras de canon ou escopo exigem decisão explícita do Product Owner.
- Esta ADR não autoriza merge automático nem substitui validação de código.

## Validação

A revisão desta ADR é documental. Não declara testes de gameplay, browser, WebView, APK ou Android físico.
