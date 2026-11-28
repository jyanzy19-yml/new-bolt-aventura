# Governança do repositório

## Branches
- `main`: integração aprovada.
- `agent/claude/*`: tarefas escritas por Claude Code.
- `agent/chatgpt/*`: tarefas escritas por ChatGPT.
- `feat/*`, `fix/*`, `chore/*`: tarefas técnicas.
- Não force-push nem reescreva histórico compartilhado.

## Commits
Formato recomendado: `type(scope): summary`.
Tipos: feat, fix, refactor, test, docs, chore, perf, build, ci, security. Um commit deve representar uma unidade lógica.

## Pull requests
Usar template, escritor primário, revisor não autor, critérios verificáveis, testes e evidências reais. Sem auto-merge por padrão. O usuário controla a integração final.

## Issues
Usar formulário adequado: bug, melhoria ou tarefa. Aplicar labels por domínio/prioridade depois de configurar os labels no GitHub. Issues devem ter reprodução ou critérios objetivos.

## Segurança
Não commitar tokens, keystores, dados pessoais ou saves reais. Workflows usam permissões mínimas. Não disponibilizar secrets para código não confiável de PRs.

## Histórico Godot
O histórico Git é preservado. A limpeza da árvore ativa deve ocorrer somente após inventário completo e revisão dos paths. Arquivos no histórico não são automaticamente parte da nova stack.
