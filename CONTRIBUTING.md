# Contribuindo com BOLT · AVENTURA

Leia `MASTER_DIRECTIVE.md`, `AGENTS.md`, `docs/PROJECT_CONTEXT_HTML5.md` e a skill específica antes de trabalhar. Confira branch, PRs e `docs/production/COLLABORATION_STATE.md`.

## Fluxo
1. Obtenha tarefa aprovada com ID, escritor, revisor, escopo e critérios.
2. Use branch isolada: `agent/claude/<task>`, `agent/chatgpt/<task>`, `feat/<task>` ou `fix/<task>`.
3. Não altere paths de outra tarefa ativa.
4. Faça commits pequenos e coesos.
5. Abra PR para `main`; não force push nem reescreva histórico.
6. Registre testes, riscos e handoff.

## Qualidade
```bash
npm install
npm run lint
npm test
npm run build
```

## Regras
- Implementação HTML5 clean-start, não Godot.
- Não altere canon ou mecânicas aprovadas sem aprovação.
- Dash, touch/multitouch, save/loading e requisitos Android são invariantes.
- Justifique dependências e revise licença/manutenção.
- Não inclua tokens, keystores, dados pessoais ou saves reais.
- Não declare performance ou validação física sem evidência.
- CI verde não substitui playtest.
