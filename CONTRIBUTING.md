# Contribuindo com BOLT · AVENTURA

## Antes de começar
Leia `MASTER_DIRECTIVE.md`, `AGENTS.md`, `docs/PROJECT_CONTEXT_HTML5.md` e a skill específica. Confira a branch atual, PRs abertas e `docs/production/COLLABORATION_STATE.md`.

## Fluxo de trabalho
1. Obtenha uma tarefa aprovada com ID, escritor, revisor, escopo e critérios de aceite.
2. Crie branch isolada: `agent/claude/<task>`, `agent/chatgpt/<task>`, `feat/<task>` ou `fix/<task>`.
3. Não altere paths pertencentes a outra tarefa ativa.
4. Faça commits pequenos, coesos e descritivos.
5. Abra PR para `main`; não faça force-push nem reescreva histórico.
6. Responda aos findings e registre handoff.

## Qualidade local
```bash
npm install
npm run lint
npm test
npm run build
```

## Regras do produto
- A implementação é HTML5 clean-start, não Godot.
- Não altere canon, personagens, mecânicas aprovadas ou escopo de campanha sem aprovação.
- Dash, touch/multitouch, confiabilidade de save/loading e requisitos Android são invariantes.
- Não adicione dependências sem justificar necessidade, licença, manutenção e custo.
- Não inclua credenciais, keystores, tokens, arquivos pessoais ou dados sensíveis.
- Não declare desempenho, instalação Android ou validação física sem evidência.

## Pull requests
Use o template do repositório. Informe testes realmente executados e os que não foram executados. CI verde não substitui playtest.
