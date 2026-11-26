# Checklist de execução e aceite — Etapa 0 (Claude Code)

**Projeto:** BOLT · AVENTURA  
**Responsável:** Claude Code  
**Branch de integração:** `main`  
**Próximo responsável:** ChatGPT — Etapa 1  
**Estado inicial:** PENDING  
**Escopo:** fundação executável Godot; não é a vertical slice nem a implementação da campanha.

> **Retrospectiva (2026-11-26):** Etapa 0 ACCEPTED pelo responsável da Etapa 1. A execução também incluiu protótipo provisório de movimento, touch, HUD e sandbox a pedido explícito do usuário. Essa exceção específica está registrada em [HANDOFF_ETAPA_0.md](handoffs/HANDOFF_ETAPA_0.md); não altera o escopo padrão deste checklist para futuras etapas e não canoniza tuning ou a sandbox como fase.

Este checklist complementa `COLLABORATION_STATE.md`, `COLLABORATIVE_DEVELOPMENT_PROTOCOL.md`, `from-zero-implementation-directive.md` e `roadmap.md`. Em caso de conflito, prevalecem as fontes de autoridade descritas em `MASTER_DIRECTIVE.md` e as ADRs aprovadas.

## 1. Antes de editar

- [ ] Confirmar repositório `jyanzy19-yml/new-bolt-aventura`, branch e HEAD atual.
- [ ] Confirmar que não existe outro escritor ativo e registrar o commit-base.
- [ ] Verificar diff, arquivos novos, commits recentes, PRs e estado real da árvore.
- [ ] Ler `MASTER_DIRECTIVE.md`, `CLAUDE.md`, `AGENTS.md`, `docs/README.md`.
- [ ] Ler a diretiva from-zero, `COLLABORATION_STATE.md`, protocolo colaborativo, este checklist, roadmap, stage-status, tracker, continuidade e Definition of Done.
- [ ] Ler ADRs e especificações técnicas relevantes: arquitetura, Android/performance, touch/display, loading/assets e contratos.
- [ ] Carregar o router e apenas as skills realmente necessárias; para estrutura, ler `godot-project-structure`.
- [ ] Identificar contradições ou decisões materiais não cobertas; não canonizar propostas.

## 2. Descoberta técnica

- [ ] Verificar se `project.godot` passou a existir desde a última auditoria. Se existir, inspecionar; nunca recriar por cima.
- [ ] Confirmar a versão estável Godot 4.x disponível e compatível com o projeto.
- [ ] Registrar versão exata em `.godot-version` somente depois de confirmar a versão realmente utilizada.
- [ ] Registrar renderer escolhido, justificativa e limitações conhecidas para Android de baixo/médio desempenho.
- [ ] Identificar disponibilidade de export templates, Android SDK/JDK e limites do ambiente.
- [ ] Não inventar versão, renderer, configuração ou resultado de teste.

## 3. Fundação mínima a implementar

- [ ] Criar `project.godot` válido e importável.
- [ ] Criar estrutura mínima de pastas orientada a responsabilidades, sem abstrações ou diretórios vazios em excesso.
- [ ] Configurar orientação paisagem e viewport/stretch de forma consistente com a especificação.
- [ ] Preparar configuração Android inicial sem incluir credenciais, chaves de assinatura ou secrets.
- [ ] Aplicar a decisão ADR-0003: política imersiva das barras durante a experiência; opção/configuração Tela cheia permanece desligada. Registrar limitações que dependam de validação em dispositivo.
- [ ] Definir Input Map inicial para as ações lógicas essenciais, documentando nomes e convenções; não implementar ainda um sistema de input completo.
- [ ] Criar uma cena inicial funcional e defini-la como entrada do projeto.
- [ ] Garantir que o projeto abra sem erros conhecidos na versão fixada.
- [ ] Criar apenas recursos temporários estritamente necessários e identificá-los como placeholders.

## 4. Validação obrigatória e limites

- [ ] Executar importação/parse headless com a versão fixada, quando disponível.
- [ ] Executar o projeto no editor/desktop se o ambiente permitir e registrar o que foi observado.
- [ ] Revisar logs, referências, caminhos de recursos e configurações.
- [ ] Registrar comandos exatos, ambiente, commit e resultados.
- [ ] Se exportação Android for possível, registrar separadamente; não é condição para alegar teste físico.
- [ ] Se algo não puder ser executado, registrar como NÃO EXECUTADO/BLOQUEADO, com motivo.
- [ ] Não declarar APK exportado, instalado ou validado sem evidência específica.
- [ ] Não alegar teste de toque, barras, FPS ou memória sem aparelho Android identificado.

## 5. Fora do escopo da Etapa 0

- [ ] Não implementar campanha, fases, chefes, inimigos ou sistemas completos de gameplay.
- [ ] Não criar 42 cenas vazias para aparentar progresso.
- [ ] Não produzir assets finais ou importar recursos de licença desconhecida.
- [ ] Não antecipar a vertical slice completa do Gate 1, salvo requisito mínimo para provar que a cena inicial abre.
- [ ] Não escolher detalhes criativos pendentes como canon.
- [ ] Não alterar engine, plataforma, orientação, controles aprovados ou ADRs.
- [ ] Não mesclar nem fechar PR #1 automaticamente.
- [ ] Não criar automações Claude, secrets, GitHub Apps ou permissões adicionais.

## 6. Atualização de estado e handoff

- [ ] Atualizar SYS-001 a SYS-003 somente de acordo com evidências; não marcar sistemas de gameplay como implementados.
- [ ] Atualizar `stage-status.md`, `CONTINUITY.md` e `COLLABORATION_STATE.md`.
- [ ] Preencher integralmente `HANDOFF_TEMPLATE.md`.
- [ ] Revisar o diff completo e conferir que não houve alterações fora do escopo.
- [ ] Entregar commit completo, branch/PR e commit-base.
- [ ] Informar arquivos criados/alterados, testes executados, testes não executados, limitações, bugs e riscos.
- [ ] Declarar próximo passo: ChatGPT inspeciona o commit e o handoff, aceita/corrige a Etapa 0 e então implementa a Etapa 1.

## 7. Critérios de aceite da Etapa 0

A Etapa 0 só pode ser entregue como HANDOFF_READY quando:

1. O projeto Godot real existe e tem versão exata fixada.
2. A cena inicial abre no projeto e a configuração básica está coerente com Android/paisagem e ADRs.
3. A estrutura mínima e o Input Map inicial estão documentados e não introduzem dependências desnecessárias.
4. As verificações disponíveis foram executadas e os limites foram declarados com honestidade.
5. O tracker, a continuidade, o estado colaborativo e o handoff apontam para o mesmo commit.
6. O commit está acessível na branch compartilhada e o próximo agente consegue continuar sem depender da conversa anterior.

**HANDOFF_READY não significa que a vertical slice, o gameplay, o APK ou a campanha estejam prontos.** O próximo agente deve inspecionar o estado real antes de aceitar e iniciar a Etapa 1.
