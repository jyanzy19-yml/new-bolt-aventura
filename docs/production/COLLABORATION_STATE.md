# Estado canônico da colaboração — Claude Code ↔ ChatGPT

**Fonte única para descobrir quem trabalha agora, qual etapa está ativa e quem recebe a próxima entrega.**
Este arquivo controla a alternância; não substitui código, commits, tracker ou evidências de QA.

## Estado vigente — fonte prioritária (2026-11-26)

- **Etapa 0 — Claude Code:** ACCEPTED.
- **Etapa 1 — ChatGPT:** HANDOFF_READY, entregue e validada até L2 no commit `624edce` (Godot/headless + Docs CI). O handoff completo está em `docs/production/handoffs/HANDOFF_ETAPA_1.md`.
- **Próximo turno:** Etapa 2 — Claude Code. Nenhum escritor deve editar `main` em paralelo; o usuário aciona Claude manualmente.
- **Projeto executável:** existe `project.godot`; versão fixada em `.godot-version` = 4.7.2. Há cenas, scripts e testes de gameplay em andamento.
- **Limite de validação:** sem exportação APK, instalação, toque físico, validação visual ou medição de performance Android comprovados nesta etapa.
- **PR #1:** continua separada e divergente; não integrar automaticamente.

As seções de snapshots anteriores abaixo são histórico. Quando houver divergência, este bloco vigente e os arquivos atuais `stage-status.md`, `CONTINUITY.md`, tracker e commits mais recentes prevalecem. Antes de editar, reconfirmar o HEAD e o estado real do GitHub.

## Snapshot histórico de auditoria antes dos controles colaborativos

- **Repositório:** jyanzy19-yml/new-bolt-aventura (privado).
- **Branch de integração:** main.
- **Commit-base inspecionado antes deste registro:** b9b84660b251313ff3cec014aced9292777e4550.
- **Árvore nesse commit:** 225 entradas; 36 skills, 8 agentes, 6 comandos e 38 arquivos Markdown em docs/. Este é o snapshot anterior à criação dos três documentos de coordenação abaixo; não é um substituto da leitura do HEAD atual.
- **Automação existente:** um workflow de validação documental.
- **Última execução observada:** GitHub Actions run 45692594026, SUCCESS, no commit-base acima. Valida metadados Claude e links Markdown; não executa Godot nem valida gameplay/Android.
- **Projeto executável:** não foi encontrado project.godot, cenas .tscn ou scripts .gd de gameplay BOLT. Os scripts GDScript existentes são exemplos/testes internos de skills.
- **PR aberto observado:** #1 (docs/master-directive-bolt), divergente de main (17 commits à frente e 68 atrás no momento da comparação). Contém arquivos de diretiva dividida que não estão na árvore main; não mesclar nem fechar automaticamente. Revisar o conteúdo e decidir separadamente.

## Atribuição do próximo turno

Antes de iniciar, o agente deve atualizar este snapshot com o HEAD atual. Os commits de governança criados depois do snapshot acima são documentação; não alteram a constatação de que o projeto Godot ainda não foi criado.

- **Estado:** HANDOFF_READY — Etapa 1 (ChatGPT) entregue em `main`; implementação principal no commit `f3ab6829228c077b1a3c14eb65385a8a99c34608`. Handoff: [handoffs/HANDOFF_ETAPA_1.md](handoffs/HANDOFF_ETAPA_1.md). Etapa 0 aceita após inspeção.
- **Escritor ativo:** nenhum; a Etapa 1 foi encerrada e o usuário acionará Claude Code manualmente.
- **Próxima etapa:** 2.
- **Responsável:** Claude Code.
- **Entrega esperada:** auditar a Etapa 1 e continuar o Gate 1/vertical slice conforme roadmap, sem presumir que APK ou validação Android já existem.
- **Próximo responsável após handoff:** Claude Code, Etapa 2.

### Escopo inicial da Etapa 0 — Claude Code

1. Reconfirmar main, HEAD, PRs, alterações e estrutura real antes de editar.
2. Ler as diretrizes obrigatórias, este estado, o protocolo colaborativo, roadmap, decisões/ADRs, tracker, continuidade e skills realmente relevantes.
3. Confirmar e registrar a versão exata do Godot 4.x, renderer e limitações do ambiente; não inventar versão nem resultado de teste.
4. Criar o projeto Godot real, incluindo project.godot, estrutura mínima sustentável, configuração Android/paisagem e input map inicial, respeitando decisões aprovadas.
5. Criar uma cena inicial funcional e a infraestrutura mínima para abrir/importar/executar o projeto.
6. Executar verificações disponíveis (estático e Godot/headless quando possível), registrar comandos e resultados e separar o que não foi testado.
7. Atualizar SYS-001 a SYS-003 somente conforme evidência; atualizar status, continuidade e este arquivo.
8. Entregar commit identificável e handoff completo usando HANDOFF_TEMPLATE.md.

**Não ampliar a Etapa 0 para criar sistemas inteiros ou conteúdo de campanha sem necessidade.** A divisão de trabalho subsequente segue o roadmap e as dependências; a Etapa 1 será definida por ChatGPT após inspecionar e aceitar a entrega real da Etapa 0.

## Máquina de estados

Use somente estes estados:

- PENDING: atribuído, ainda não iniciado.
- IN_PROGRESS: responsável atual confirmou início e commit-base.
- HANDOFF_READY: implementação commitada, testes e pacote de transferência registrados.
- ACCEPTED: próximo responsável inspecionou a entrega, tratou achados bloqueadores e aceitou a base.
- BLOCKED: existe bloqueio real; registrar responsável, evidência e trabalho independente permitido.

Não avançar o número da etapa apenas porque uma sessão terminou. O próximo responsável só assume depois de inspecionar o commit e o handoff. Defeitos não bloqueadores podem permanecer no backlog com risco e prioridade explícitos.

## Regras de sincronização

1. main é a branch de integração e a fonte oficial do estado compartilhado.
2. Um único escritor por vez. O responsável atual informa o commit-base antes de editar.
3. Se o agente trabalhar em branch de tarefa, a entrega só passa ao próximo agente depois que o commit integrado estiver em main; registrar branch, PR e merge commit.
4. Nunca sobrescrever commits posteriores, fazer force push ou editar com base em um snapshot desatualizado.
5. ChatGPT só declara alteração no GitHub quando a gravação e a leitura de confirmação forem bem-sucedidas.
6. Claude só declara entrega compartilhada quando os commits estiverem acessíveis no repositório comum.
7. O usuário aciona manualmente o próximo agente. **Não existe transferência automática de sessão entre Claude e ChatGPT neste protocolo.**
8. Se o acesso de um agente for apenas leitura, ele deve declarar a limitação e entregar patch/diff; não pode declarar a etapa entregue como integrada.

## Histórico de turnos

| Etapa | Responsável | Estado | Commit de entrega | Próxima ação |
|---|---|---|---|---|
| 0 | Claude Code | ACCEPTED | `7057532` + `c32a99d` + `ab72c58` | Base inspecionada e aceita; valores de gameplay permanecem provisórios |
| 1 | ChatGPT | HANDOFF_READY | `4700d39` + `317f4ef` + `f3ab682` | Handoff registrado; aguarda Claude Code Etapa 2 |
| 2 | Claude Code | Aguardando | — | Auditar Etapa 1 e continuar Gate 1 |
| 3 | ChatGPT | Aguardando | — | Auditar Etapa 2 e continuar |

Atualize esta tabela a cada handoff aceito. Não preencher commits hipotéticos.

## Fontes obrigatórias

- COLLABORATIVE_DEVELOPMENT_PROTOCOL.md — regras completas da alternância.
- AGENT_ACCESS_SETUP.md — como dar ao Claude acesso real de leitura/escrita.
- HANDOFF_TEMPLATE.md — formato obrigatório da transferência.
- ETAPA_0_CLAUDE_CHECKLIST.md — checklist específico de execução e aceite da Etapa 0.
- from-zero-implementation-directive.md e roadmap.md — escopo de produto e gates.
- stage-status.md, implementation-tracker.md e CONTINUITY.md — estado de produção e evidências.


## Auditoria atual — 2026-11-25

- HEAD main: d8d1a5b8801f0096ba372bf686c459fdba385931.
- Árvore: 228 entradas; 129 Markdown totais; 41 Markdown em docs/.
- Catálogo: 36 skills, 8 agentes, 6 comandos.
- Projeto: project.godot ausente; 0 cenas .tscn; 4 scripts .gd de exemplos/testes de skills; nenhum gameplay BOLT.
- Assets de jogo: nenhuma imagem, áudio ou fonte identificados.
- CI: run documental #90 SUCCESS no HEAD acima; não executa Godot/Android.
- PR #1: aberta e divergente; 17 commits exclusivos da PR e 88 exclusivos de main; não mergeável no momento da consulta. Não integrar automaticamente.
- Workflow Godot condicional adicionado nesta atualização; NOT APPLICABLE até existir projeto e versão fixada.
- Branch protection não foi alterada nesta rodada.

Este snapshot substitui os números anteriores para decisões atuais; registros antigos permanecem como histórico.

## Atribuição permanece inalterada

- Estado PENDING; escritor ativo nenhum.
- Etapa atual: 0 — Claude Code.
- Entrega: fundação Godot executável e handoff completo.
- Próximo agente após aceite: ChatGPT — Etapa 1.

As melhorias de infraestrutura não iniciam nem substituem a Etapa 0 e não autorizam dois escritores simultâneos.


## Snapshot após instalação dos controles de CI e QA — 2026-11-25

- HEAD main de referência: 75e5021b95c013c70b4b19d7fbb8a84290280647.
- Árvore: 232 entradas; 132 Markdown totais; 44 Markdown em docs/.
- 36 skills, 8 agentes, 6 comandos e 2 workflows.
- project.godot ausente; 0 cenas .tscn; 4 scripts .gd de exemplos/testes das skills; nenhum asset final de jogo identificado.
- Run documental #94: SUCCESS.
- Run Godot #4: SUCCESS com NOT APPLICABLE; nenhum teste de engine foi realizado.
- Etapa 0 Claude Code continua PENDING; nenhum escritor ativo.
- Novos controles: CI condicional Godot, pipeline de CI, pipeline de assets, template de teste Android e links nos índices.

Este snapshot substitui os inventários anteriores para retomadas futuras. Não altera a atribuição nem inicia a Etapa 0.


## Snapshot de pré-produção — base auditada em 2026-11-25

- Commit-base da auditoria: `bc5799c651ccd5ffbcdfadf36f669435df63501b`.
- Inventário nessa base: 232 entradas; 132 Markdown totais; 44 Markdown em docs/; 36 skills; 8 agentes; 6 comandos; 2 workflows.
- `project.godot` ausente; 0 cenas `.tscn`; 4 scripts `.gd` de exemplos/testes das skills; nenhum asset final de jogo identificado.
- Run documental #96: SUCCESS.
- Run Godot #6: workflow SUCCESS com `NOT APPLICABLE`; o log confirma que `project.godot` estava ausente e nenhum teste de engine foi executado.
- PR #1: 17 commits exclusivos da PR e 94 exclusivos de main; divergente. Não integrar automaticamente.
- O checklist obrigatório da Etapa 0 está em [ETAPA_0_CLAUDE_CHECKLIST.md](ETAPA_0_CLAUDE_CHECKLIST.md); a auditoria está em [PREPRODUCTION_AUDIT.md](PREPRODUCTION_AUDIT.md).

Os commits seguintes desta auditoria alteram apenas documentação e QA. Antes de iniciar a Etapa 0, Claude deve consultar o HEAD real novamente. A atribuição permanece PENDING — Claude Code Etapa 0; nenhum escritor ativo; ChatGPT Etapa 1 após handoff aceito.


## Estado autoritativo — Etapa 1 encerrada (2026-11-26)

- HEAD consultado antes do início: `ab72c584522db49ad7b31c80717fd2d6ab7ab73e`; não havia commits posteriores ao handoff de Claude.
- Etapa 0: **ACCEPTED**. O escopo antecipado de movimento, touch, HUD e sandbox foi aceito como implementação provisória solicitada pelo usuário; a sandbox não é fase da campanha. Não houve canonização dos valores de `BoltTuning`, layout touch ou interpretação de “All Jump”.
- Etapa 1: **HANDOFF_READY**. Corrigida a reatribuição do mesmo índice de ponteiro em `TouchControls`; teste de regressão adicionado; workflow Godot agora executa a suíte headless após import.
- Godot CI Run #36: SUCCESS no commit `624edce`; import + runner headless exit 0. Docs CI Run #124: SUCCESS no mesmo commit. Validação L2; sem teste de editor, Android, APK, toque físico, FPS ou memória.
- Achado S3 corrigido: reatribuição inesperada de índice podia deixar ação anterior presa. Nenhum S0–S2 confirmado na revisão estática dos sistemas da Etapa 0.
- PR #1 permanece aberta/divergente e intocada.
- Próximo escritor: Claude Code, Etapa 2, após acionamento manual do usuário.
