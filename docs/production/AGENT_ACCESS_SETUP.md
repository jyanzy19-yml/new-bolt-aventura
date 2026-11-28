# Configuração de acesso dos agentes — BOLT · AVENTURA

## Objetivo
Permitir que ChatGPT e Claude Code trabalhem sobre o mesmo repositório GitHub, sem pressupor conexão direta entre sessões.

**Repositório oficial:** `jyanzy19-yml/new-bolt-aventura`  
**Branch de integração:** `main`  
**Tecnologia:** HTML5, CSS3, JavaScript ES Modules, Canvas 2D, Vite.

## Estado conhecido
- A conexão GitHub desta sessão ChatGPT confirmou acesso de leitura/escrita ao repositório.
- O acesso do Claude deve ser autenticado e verificado no ambiente Claude Code do usuário; não pode ser inferido pela conexão do ChatGPT.
- Ambos os agentes estão autorizados pelo usuário a desenvolver, conforme `COLLABORATION_STATE.md`.
- Não existe transferência automática de contexto ou sessão. O GitHub, commits, branches, PRs e handoffs são a fonte compartilhada.
- A existência de instruções no repositório não garante que Claude esteja conectado ou consiga fazer push.

## Configuração recomendada para Claude Code
1. Abrir/clonear `jyanzy19-yml/new-bolt-aventura` em um ambiente autenticado.
2. Confirmar repositório, branch e HEAD contra o GitHub.
3. Ler `MASTER_DIRECTIVE.md`, `AGENTS.md`, `CLAUDE.md`, o router de skills e `docs/production/COLLABORATION_STATE.md`.
4. Confirmar tarefa atribuída, escritor primário, revisor, base commit, branch e paths permitidos.
5. Criar branch própria `agent/claude/<task-id>-<slug>`; não trabalhar diretamente em `main` para mudanças substanciais.
6. Executar checks definidos na tarefa, commitar e abrir PR quando disponível.
7. Deixar handoff com commit, paths, testes, resultados e riscos. Não presumir que ChatGPT recebeu a transferência.

## Configuração recomendada para ChatGPT
1. Confirmar acesso ao repositório e branch atual.
2. Ler a mesma diretiva e o estado colaborativo.
3. Trabalhar em branch `agent/chatgpt/<task-id>-<slug>` para tarefas substanciais quando as ferramentas disponíveis permitirem.
4. Revisar PR/diff do Claude sem editar simultaneamente os mesmos paths.
5. Atualizar handoff e aguardar decisão do usuário para merge/continuidade.

## Segurança e governança
- Nunca incluir token, senha, chave de assinatura ou keystore em arquivos, prompts ou commits.
- Não criar automação de publicação ou release sem autorização.
- Não force-push nem reescrever histórico compartilhado.
- O usuário controla a ordem de execução e a integração.
- A proteção de branch e checks obrigatórios devem ser configurados pelo proprietário no GitHub; a documentação não prova que estejam ativos.

## Tecnologia
Este é um jogo novo em HTML5, não uma migração Godot. Godot/GDScript são referências históricas e não devem orientar implementação.
