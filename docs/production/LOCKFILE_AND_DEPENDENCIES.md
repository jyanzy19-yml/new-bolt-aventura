# Dependências e lockfile

O projeto mantém dependências de desenvolvimento enxutas. Toda dependência exige justificativa funcional, revisão de licença, manutenção, superfície de ataque, tamanho e impacto no build.

## Estado atual — concluído em 2026-11-28

- `package.json` declara as dependências diretas.
- `package-lock.json` está versionado (lockfileVersion 3).
- O lockfile foi gerado no GitHub Actions com Node 22/npm 10 a partir das faixas declaradas, sem atualização forçada.
- O Web CI usa `npm ci --no-audit --no-fund` e cache npm baseado em `package-lock.json`.
- PR #132 integrada à main; npm ci, lint, Vitest e build Vite passaram no head validado. CodeQL também passou.

## Procedimento para mudanças futuras

1. Alterar `package.json` apenas quando houver justificativa.
2. Atualizar `package-lock.json` com a versão de npm compatível.
3. Revisar o diff de resolução, integridade, licenças e advisories.
4. Executar `npm ci` em checkout limpo.
5. Executar lint, testes e build de produção.
6. Integrar somente após CI e revisão.

Não usar `npm audit fix --force` automaticamente. Mudanças maiores exigem revisão e testes.
