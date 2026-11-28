# Governança do repositório

## Branches
- `main`: integração aprovada.
- `agent/claude/*`: tarefas escritas por Claude Code.
- `agent/chatgpt/*`: tarefas escritas por ChatGPT.
- `feat/*`, `fix/*`, `chore/*`: tarefas técnicas convencionadas.
- Não force-push nem reescreva histórico compartilhado.

## Commits
Formato recomendado: `type(scope): summary`.
Tipos: feat, fix, refactor, test, docs, chore, perf, build, ci, security.
Um commit deve representar uma unidade lógica. Evitar misturar gameplay, arte, infraestrutura e documentação sem necessidade.

## Pull requests
- Usar template.
- Um escritor primário.
- Revisor não autor.
- Critérios de aceite verificáveis.
- Testes e evidências reais.
- Sem auto-merge por padrão.
- O usuário controla integração final.

## Issues
Usar formulário adequado: bug, melhoria ou tarefa. Aplicar labels por domínio e prioridade. Issues devem ter reprodução ou critérios objetivos, não apenas "melhorar tudo".

## Segurança
Não commitar tokens, keystores, dados pessoais ou saves reais. Workflows usam permissões mínimas. Não disponibilizar secrets para código não confiável de PRs.

## Histórico Godot
O histórico Git é preservado. A limpeza da árvore ativa deve ocorrer somente após inventário completo e revisão dos paths. O fato de um arquivo estar no histórico não significa que ele pertence à nova stack.
