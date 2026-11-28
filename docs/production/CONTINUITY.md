# BOLT · AVENTURA — Continuity Log

## Snapshot — 2026-11-28

- Stack soberana: HTML5, CSS3, JavaScript ES Modules, Canvas 2D, Vite, Web Audio API e Pointer Events.
- Produto criado do zero; não é port nem migração Godot.
- PR #120 integrada à main: metadados das Skills/catálogos corrigidos; documentação validada com sucesso.
- PR #117 (fundação Vite/ES Modules) foi marcada ready, mas precisa de reconciliação com a main após a integração da PR #120.
- Branch ativa de consolidação/limpeza: `chore/html5-runtime-cleanup`.
- Inventário recursivo do baseline: 417 arquivos versionados; 169 paths classificados como remoção por serem artefatos exclusivos da antiga implementação Godot. O histórico Git permanece preservado.
- Canon, bíblias de design, conteúdo narrativo, planos e handoffs históricos foram mantidos.
- `scripts/validate_project_docs.py` permanece porque valida documentação; testes JavaScript do scaffold permanecem. Testes GDScript foram removidos da árvore ativa.
- Nenhum gameplay HTML5, vertical slice, APK Capacitor ou teste em Android físico é declarado concluído.

## Próximas ações verificáveis

1. Concluir PR de consolidação e limpeza após CI integral.
2. Gerar e commitar `package-lock.json` em ambiente com acesso ao registry; migrar CI para `npm ci`.
3. Executar lint, Vitest, build Vite, validador documental e CodeQL no commit integrado.
4. Implementar a primeira vertical slice com contratos e testes.
5. Validar browser, Android WebView e dispositivo físico separadamente.
