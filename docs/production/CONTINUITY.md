# BOLT · AVENTURA — Continuity Log

## Atualização de fundação GitHub/HTML5
- Base: `0b6b2cea994f24638f48ac190d37edd8e58f8f2c`.
- Branch de trabalho: `chore/github-production-foundation-v2`.
- Tarefa: REPO-FOUNDATION-001.
- Escopo: bootstrap Vite, ESLint, Vitest, CI web, CodeQL, Dependabot, issue/PR templates, segurança, contribuição e documentação de arquitetura/QA/performance/assets/release.
- A implementação inicial de `src/main.js` é somente um shell de inicialização visual; não contém gameplay.
- CI e testes ainda precisam ser executados pelo GitHub Actions após a abertura da PR.
- `package-lock.json` ainda não existe; gerar com npm em ambiente com registry e então mudar CI para `npm ci`.
- Android/Capacitor não foi integrado nem validado.
- Limpeza dos arquivos históricos Godot não foi executada; aguarda inventário completo da árvore.

## Próximas ações
1. Abrir PR e aguardar CI.
2. Gerar e commitar package-lock.
3. Fazer revisão independente pelo Claude Code.
4. Inventariar árvore completa e classificar KEEP/ADAPT/ARCHIVE/REMOVE.
5. Definir próximo task ID para contratos de runtime e vertical slice.
