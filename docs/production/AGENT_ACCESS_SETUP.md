# Configuração de acesso dos agentes — BOLT · AVENTURA

## Objetivo

Claude e ChatGPT precisam trabalhar sobre o mesmo repositório e o mesmo estado integrado. **Não existe conexão direta de sessão entre os dois modelos.** O GitHub é o meio compartilhado; o usuário continua acionando manualmente o agente da vez.

Repositório oficial: jyanzy19-yml/new-bolt-aventura (privado). Branch de integração: main.

## Estado do acesso verificado nesta revisão

- **ChatGPT:** a conexão GitHub disponível nesta sessão confirmou permissões de leitura, escrita e administração no repositório. Isso não garante que qualquer outra sessão/dispositivo mantenha as mesmas permissões.
- **Claude:** o acesso efetivo de leitura/escrita não pode ser inferido a partir da conexão do ChatGPT. O usuário precisa conectar/autenticar o Claude separadamente.
- **Automação:** não há workflow Claude configurado no repositório. A colaboração manual por commits não exige criar um agente automático nem adicionar secrets.
- **Proteção Git:** a branch main foi observada sem proteção de branch. A regra de escritor único está documentada, mas não é tecnicamente imposta pelo GitHub. A conexão disponível permite consultar regras, mas não oferece uma ação de escrita para configurar branch protection; essa configuração deve ser feita pelo proprietário nas configurações do repositório se desejar exigir PR e checks.

## Escolha o modo correto do Claude

### A. Claude Code com checkout Git — necessário para implementação com commit

1. Abra o repositório com Claude Code em um ambiente que tenha Git e autenticação GitHub autorizada pelo proprietário.
2. Confirme que o clone é jyanzy19-yml/new-bolt-aventura, que a branch de integração é main e que o HEAD corresponde ao commit mais recente do GitHub.
3. Confirme que Claude consegue ler os documentos e criar uma branch/commit conforme as permissões concedidas.
4. Antes de editar, Claude deve informar o commit-base e assumir a etapa registrada em COLLABORATION_STATE.md.
5. Ao terminar, os commits devem ficar disponíveis no repositório compartilhado. Se usar uma branch de tarefa/PR, integre-a a main antes de passar o turno ao ChatGPT.
6. Nunca deixe Claude e ChatGPT editarem ao mesmo tempo.

### B. Integração GitHub do Claude.ai — contexto de leitura

A integração GitHub do Claude.ai permite selecionar repositórios, branches, arquivos e pastas para fornecer contexto. A documentação oficial informa que a sincronização de projetos recupera nomes e conteúdos de arquivos de uma branch selecionada; não recupera histórico de commits, PRs ou outros metadados. Portanto, **não trate essa integração de contexto como prova de que Claude pode escrever, commitar ou enviar alterações**.

Se usar esse modo:
- selecione o repositório privado correto e a branch main;
- inclua as diretrizes, docs/production/, decisões, especificações e os arquivos do projeto Godot;
- sincronize novamente antes de cada turno;
- confirme separadamente se o ambiente oferece uma ação real de escrita/commit;
- se for somente leitura, use Claude Code com checkout Git para a etapa de implementação.

### C. Claude Code GitHub Action — automação opcional, não necessária agora

A ação oficial anthropics/claude-code-action pode executar Claude em eventos do GitHub. Ela exige instalação/configuração própria e autenticação Anthropic, por exemplo um secret de API ou Workload Identity Federation. Isso não está configurado neste repositório e não deve ser presumido.

Não habilitar automação, adicionar secrets ou ampliar permissões apenas para tornar possível o pingue-pongue manual. Se futuramente o usuário quiser automação, criar um plano separado com permissões mínimas, revisão de segurança, limites de execução e proteção contra loops de eventos.

## Fluxo operacional de cada troca

1. Consultar COLLABORATION_STATE.md e confirmar o responsável.
2. O responsável lê o commit-base atual, documentos obrigatórios e o projeto real.
3. Somente esse responsável edita.
4. O responsável valida, atualiza tracker/continuidade/estado e entrega o handoff preenchido.
5. O usuário aciona o próximo agente.
6. O próximo agente confirma que recebeu o commit integrado e repete a inspeção antes de escrever.

## Segurança e integridade

- Não colar tokens, senhas, chaves privadas ou dados de assinatura em chats, issues, arquivos ou commits.
- Não adicionar credenciais ao repositório. Usar os mecanismos oficiais de secrets somente se uma automação for aprovada e realmente necessária.
- Não conceder permissões administrativas quando leitura/escrita de conteúdo e PRs forem suficientes.
- Não instalar aplicações GitHub nem autorizar acesso em nome do usuário sem consentimento explícito.
- Não aceitar um resumo de chat como substituto do commit e do diff.
- Não afirmar que Claude tem acesso de escrita até que uma operação real e autorizada tenha sido confirmada.

## Referências oficiais

- [Integração GitHub no Claude](https://support.claude.com/en/articles/10167454-use-the-github-integration)
- [Configuração da Claude Code GitHub Action](https://github.com/anthropics/claude-code-action/blob/main/docs/setup.md)
- [Segurança da Claude Code GitHub Action](https://github.com/anthropics/claude-code-action/blob/main/docs/security.md)
