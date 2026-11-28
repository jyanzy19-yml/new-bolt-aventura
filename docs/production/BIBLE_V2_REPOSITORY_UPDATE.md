# Atualização documental — Bíblia Mestre HTML5 v2.0

**Data:** 2026-11-28  
**Escritor primário:** ChatGPT  
**Revisor:** pendente  
**Branch:** `agent/chatgpt/master-bible-html5-v2`  
**Base:** `main` no início da tarefa  
**Escopo:** sincronização documental da decisão HTML5 e centralização dos requisitos.

## Entregáveis

- Bíblia Mestre HTML5 v2.0 em `docs/game-design/BOLT_MASTER_BIBLE_HTML5_V2.md`.
- ADR-0006 de adoção documental.
- Atualização dos pontos de entrada para que agentes encontrem a Bíblia.
- Atualização do contexto HTML5 para referenciar a fonte consolidada.

## Limites explícitos

Esta entrega é uma atualização documental. Não altera runtime, gameplay, assets, fases, APK ou integração Android. Não declara a campanha concluída. As PRs de runtime/W1-L1 e combate existentes devem ser revisadas separadamente, respeitando seus escopos e evitando integração duplicada.

## Verificação exigida

- Confirmar links e paths.
- Revisar diff e consistência de stack.
- Executar validador documental e CI da PR.
- Registrar resultados reais; não presumir validação por ausência de erro na edição.

## Próxima tarefa sugerida

Após integração desta documentação, atribuir uma única tarefa de integração de gameplay com branch e paths delimitados, tomando como baseline a PR W1-L1 escolhida pelo Product Owner. Não mesclar simultaneamente branches agregadoras e componentes que contenham o mesmo runtime.
