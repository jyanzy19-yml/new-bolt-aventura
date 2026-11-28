# BOLT · AVENTURA — Continuity Log

## Snapshot — 2026-11-28

- Stack soberana: HTML5, CSS3, JavaScript ES Modules, Canvas 2D, Vite, Web Audio API e Pointer Events. Capacitor segue candidato, não integração concluída.
- Produto criado do zero; não é port nem migração Godot.
- PR #120 integrada: metadados das Skills/catálogos corrigidos.
- PR #121 integrada: fundação HTML5/Vite reconciliada, 169 paths exclusivamente Godot removidos da árvore ativa e inventário completo registrado.
- PR #132 integrada: package-lock.json versionado; Web CI usa npm ci e cache npm.
- Inventário do baseline: 417 arquivos versionados classificados path a path; 169 removidos; histórico Git preservado. Árvore atual: 250 arquivos.
- Catálogo ativo: 43 Skills, 16 agentes read-only e 9 comandos.
- Validação da PR #121: Documentation validation SUCCESS, Web CI SUCCESS (lint, Vitest, build e artifact), CodeQL SUCCESS.
- Validação da PR #132: npm ci SUCCESS, lint SUCCESS, Vitest SUCCESS, build Vite SUCCESS e CodeQL SUCCESS.
- Canon, bíblias de design, narrativa e registros históricos foram preservados. Dossiê Godot está marcado como histórico/superado.
- scripts/validate_project_docs.py permanece como validador documental; testes JavaScript do scaffold permanecem.
- O scaffold é fundação de tooling/shell, não gameplay ou vertical slice. Nenhum APK Capacitor ou teste Android físico foi comprovado.

## Próximas ações verificáveis

1. Iniciar a arquitetura/runtime HTML5 além do shell inicial.
2. Implementar uma primeira vertical slice pequena, integrada e testável.
3. Criar testes de unidade, integração e browser para os contratos reais.
4. Validar Android WebView separadamente do browser desktop.
5. Só integrar Capacitor após a decisão técnica e critérios do runtime web.
