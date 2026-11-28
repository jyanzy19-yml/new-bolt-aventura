# Protocolo de desenvolvimento colaborativo — ChatGPT + Claude Code

**Projeto:** BOLT · AVENTURA  
**Tecnologia vigente:** HTML5, CSS3, JavaScript ES Modules, Canvas 2D e Vite. Web Audio API e Pointer Events dão suporte ao runtime. Capacitor é candidato para empacotamento Android, sujeito a validação.  
**Autoridade:** MASTER_DIRECTIVE.md, decisões aprovadas e instruções mais recentes do usuário.

## 1. Estado vigente

ChatGPT e Claude Code estão autorizados a desenvolver o jogo. Ambos podem implementar código, testes, documentação, tooling e conteúdo dentro de tarefas atribuídas. Isso substitui os snapshots históricos que descreviam ChatGPT como único escritor ou Claude como inativo.

O trabalho é **coordenado e não concorrente sobre os mesmos arquivos**. Não há transferência automática de sessão entre agentes; o usuário escolhe qual agente assume a próxima tarefa e controla o merge.

## 2. Regra de ownership

Cada tarefa substancial deve declarar:
- um único escritor primário;
- um revisor não autor da mudança;
- task ID e commit-base;
- branch e PR (quando aplicável);
- objetivo e escopo;
- paths permitidos e reservados;
- dependências/contratos afetados;
- critérios de aceite e testes;
- riscos e próximo responsável.

O revisor não edita os mesmos arquivos enquanto a tarefa estiver em andamento. Se os dois agentes precisarem do mesmo path, o trabalho é sequencial: primeiro escritor conclui e commita; o segundo atualiza sua base e então atua.

## 3. Branches e integração

Preferir:
- `agent/claude/<task-id>-<slug>`
- `agent/chatgpt/<task-id>-<slug>`

Mudanças substanciais devem usar PR. Não fazer force-push, reescrever histórico compartilhado, mesclar a própria PR ou editar diretamente a main em tarefas amplas. O usuário aprova a integração. Se o ambiente não permitir branch/PR, registrar a limitação e manter as mudanças mínimas, reversíveis e verificadas.

## 4. Roteamento padrão de trabalho

| Domínio | Responsável padrão | Revisão |
|---|---|---|
| Arquitetura transversal e integração | ChatGPT | Claude ou agente read-only |
| Runtime, física, input e performance | ChatGPT | Claude ou agente read-only |
| Fases, mundos e conteúdo de campanha | Claude Code | ChatGPT |
| Inimigos, chefes e encontros | Claude Code | ChatGPT |
| UI e sistemas independentes | Claude Code | ChatGPT |
| Android shell, CI e release gates | ChatGPT | Claude ou agente read-only |
| QA/regressão | Agente explicitamente designado | O não autor revisa |

O roteamento é padrão, não uma restrição de capacidade. O usuário pode atribuir qualquer domínio a qualquer agente.

## 5. Handoff obrigatório

Use o template em `COLLABORATION_STATE.md`. O handoff deve registrar commit real, paths, testes e resultados. Não afirmar que o agente seguinte recebeu/aceitou o trabalho sem confirmação.

## 6. Revisão e resolução de conflitos

O revisor verifica correção, regressões, arquitetura, gameplay, performance, mobile UX, segurança, testes e documentação conforme o escopo. Findings devem ter severidade, path/linha, impacto e correção sugerida.

Conflito de canon, escopo ou arquitetura não deve ser resolvido por preferência do agente. Preservar evidências e solicitar decisão do usuário quando material.

## 7. Limites e segurança

- Não compartilhar tokens, credenciais, signing keys ou keystores.
- Não executar release/publicação sem autorização explícita.
- Assets finais seguem aprovação da versão exata pelo usuário.
- Skills e subagentes são auxiliares; não substituem diretiva, testes ou aprovação.
- Diferenciar PLANNED, IMPLEMENTED, TESTED e VERIFIED.
- O estado GitHub é a memória compartilhada; conversas antigas são apenas contexto histórico.
