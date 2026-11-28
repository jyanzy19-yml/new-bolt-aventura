# Dependências e lockfile

O projeto deve manter dependências de desenvolvimento enxutas. Toda nova dependência exige justificativa funcional, revisão de licença, manutenção, superfície de ataque, tamanho e impacto no build.

## Estado inicial
O scaffold define dependências em `package.json`, mas o lockfile ainda precisa ser gerado por `npm install` em ambiente com registry disponível e commitado. Até que `package-lock.json` exista, a resolução de versões não está totalmente reproduzível.

## Procedimento
1. Executar `npm install` com Node/npm suportados.
2. Revisar `package-lock.json` gerado.
3. Executar lint, testes e build.
4. Commitar package.json e package-lock.json juntos.
5. Depois disso, alterar CI para `npm ci`.
6. Atualizar dependências via Dependabot e revisar changelog/advisories.

Não usar `npm audit fix --force` automaticamente. Mudanças maiores exigem revisão e testes.
