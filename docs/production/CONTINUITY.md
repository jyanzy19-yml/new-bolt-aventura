## Estado atual — PR #17 integrada — 2026-11-26

- **Main HEAD:** `33fe452d0a6aad2fc87ea19da789dfde9999c93a`.
- **PR #17:** integrada por squash; adiciona vida/dano reutilizável, Pistola Crono básica, projétil, alvo estático de treino, botão touch TIRO e lição de ataque no tutorial.
- **Validação da PR:** Godot CI #61 (`45846655204`) SUCCESS — Godot 4.7.2, 47 testes / 231 verificações / 0 falhas. Docs CI #182 (`45846655293`) SUCCESS.
- **Limites:** parâmetros da Pistola Crono são provisórios; alvo é apenas de treino, não inimigo da campanha. Outras armas, seleção, IA inimiga, dano ao jogador e chefes não implementados. APK e Android físico não testados.
- **Próximo foco:** inimigo-base com comportamento simples e contrato de dano, depois integração gradual ao blockout W1-L1; manter valores provisórios e testes headless.

---

## Estado atual — combate básico em desenvolvimento

- **Main base:** `2b81211e56677a7f4ee1da97e6d1c4d604e87d77` (PR #16 integrada).
- **Branch:** `feat/chrono-pistol-combat-core`.
- **Implementação:** componente de vida/dano reutilizável (`BoltHealth`), controlador da Pistola Crono (`BoltCombat`), projétil (`ChronoProjectile`) e alvo estático de treinamento (`BoltTrainingTarget`).
- **Input:** ATTACK agora é bufferizado; botão touch TIRO adicionado ao HUD.
- **Tutorial:** fluxo passa a mover → saltar → Dash → acertar alvo com TIRO → Cybercore.
- **Limites:** alvo é apenas treinamento, não inimigo de campanha. Valores de cadência, dano, velocidade e alcance são provisórios. Tríplice Prisma, Laser Nexo, seleção de armas, IA inimiga e dano ao jogador ainda não implementados.
- **Testes:** regressão de ActionBuffer ATTACK, componente de vida/projétil e fluxo real de disparo no tutorial; Godot CI #58 (`45846440754`) SUCCESS — Godot 4.7.2, 47 testes / 231 verificações / 0 falhas. Docs CI #179 (`45846440753`) SUCCESS.
- **Próxima ação:** revisar o diff final e integrar a PR #17 após confirmar os checks; depois avançar para o primeiro inimigo-base e completar a lição de ataque.

---

## Estado atual — PR #15 integrada — 2026-11-26

- **Main HEAD:** `783c1d2587ebea39d645a641417e663e561ea710`.
- **PR #15:** integrada por squash; adiciona storyboard funcional de abertura, tutorial guiado por robô mensageiro provisório e blockout jogável de W1-L1 Cybercore.
- **Validação da PR:** Godot CI #56 (`45844707053`) SUCCESS — Godot 4.7.2, 44 testes / 205 verificações / 0 falhas. Docs CI #175 (`45844707079`) SUCCESS.
- **CI pós-merge:** Godot #57 (`45844900388`) e Docs #176 (`45844900148`) em execução no momento deste registro.
- **Limites:** abertura não é cinemática final animada; robô mensageiro é placeholder; W1-L1 é blockout sem inimigos/combate, assets/áudio finais ou save/load. Nenhum APK, emulador ou Android físico testado.
- **Próximo foco:** continuar sistemas centrais da campanha, começando por combate/dano e um inimigo-base, sem multiplicar conteúdo antes de validar os contratos.

---

## Estado atual — entrada da campanha em desenvolvimento

- **Base main:** `d6301e887c6c3a54ab532fcc2f75cb983c3e9840`.
- **Branch:** `feat/campaign-opening-tutorial`.
- **Responsável:** ChatGPT como único desenvolvedor, por decisão explícita do usuário.
- **Fluxo:** menu principal → storyboard funcional de abertura → tutorial jogável guiado por robô mensageiro provisório → blockout de W1-L1 Cybercore.
- **Abertura:** quatro páginas baseadas no canon aprovado (Grande Colapso/Núcleo da Eternidade, despertar de BOLT em Cybercore, união com NEXO, sete fragmentos). Ainda não é cinemática final animada e não possui áudio final.
- **Tutorial:** introduz deslocamento, salto e Dash usando o player/HUD/touch existentes. Textos são instruções funcionais provisórias; não definem a personalidade ou história do mensageiro.
- **W1-L1:** blockout jogável com BOLT, HUD/touch, checkpoint local, respawn e objetivo de trecho. Ainda faltam inimigos, combate, assets finais, áudio, save/load e validação Android.
- **Teste:** `tests/unit/test_campaign_entry.gd`, verificando carregamento e contratos estruturais das três cenas. CI pendente.
- **Próxima ação:** revisar o diff final e integrar a PR #15 após confirmar os checks finais; depois selecionar a próxima unidade da campanha.

---

## Estado atual após PR #13 — 2026-11-26

- **Main HEAD:** `09317a2c1b7c1113e7ff2f142a82b495998f7578` (PR #13 integrada por squash).
- **Responsável:** ChatGPT como único desenvolvedor, por autorização explícita do usuário.
- **Entrega:** checkpoint reutilizável (`BoltCheckpoint`) e respawn local no último ponto ativado da sandbox; PR #13 integrada.
- **Testes:** Godot CI #50 (`45841890027`) SUCCESS — Godot 4.7.2, 43 testes / 179 verificações / 0 falhas. Docs CI #167 (`45841889890`) SUCCESS.
- **Limites:** checkpoint é apenas em memória na sandbox; SaveSystem e checkpoints de campanha ainda não implementados. APK, emulador, teste físico, safe area e desempenho Android não executados.
- **Próxima ação:** implementar a próxima unidade dos sistemas centrais da vertical slice, após reauditar o HEAD `09317a2`; preservar Dash, touch e política Android.

---

## Sessão de desenvolvimento solo — 2026-11-26 (branch em revisão)

- **Responsável:** ChatGPT, por autorização explícita do usuário para conduzir todas as etapas sem Claude.
- **Base:** `main` em `8c502efaee16a47a31303c77d0efbbd4c847a5e8`.
- **Branch:** `feat/checkpoint-respawn-system`.
- **Unidade implementada nesta branch:** `BoltCheckpoint` reutilizável com ativação única, sinal contendo ID/posição de respawn e integração com a sandbox para atualizar o ponto de retorno ao cair. A sandbox continua sendo ambiente de desenvolvimento, não uma fase da campanha.
- **Teste adicionado:** `tests/unit/test_checkpoints.gd::test_checkpoint_updates_respawn_target_once`; valida ativação única e uso do ponto ativado no respawn. Execução ainda pendente do Godot CI.
- **Limites:** checkpoint apenas em memória durante a sessão; nenhum SaveSystem, progresso de campanha, APK, emulador ou teste em Android físico foi implementado/executado nesta unidade.
- **Validação CI:** Godot CI #47 (`45841375185`) SUCCESS no HEAD `4f89fa73f16cc28ed6e400fbcb26d81046d4864e`; importação Godot 4.7.2 passou e a suíte executou 43 testes / 179 verificações / 0 falhas. Docs CI #164 (`45841375193`) SUCCESS.
- **Próxima ação:** concluir revisão da PR #13 e integrar somente após confirmar os checks e o diff.

---

## Snapshot confirmado após PR #10 — 2026-11-26

- **HEAD real da main:** `1e5294cf112c014c21e43c51b4c8e797beceb9b6` (commit `docs: finalize live-state continuity`; PR #10 integrada por squash).
- **PRs #2–#10:** integradas; PR #1 permanece aberta, sem rebase, fechamento ou merge.
- **PR #1 vs main:** 17 commits exclusivos, 139 commits atrás; comparação executada em 2026-11-26. Métrica volátil, não reutilizar sem novo compare.
- **Estado do projeto:** Godot 4.7.2/GDScript, cenas/scripts/testes reais, Android empacotado em paisagem; fundação técnica, não campanha completa.
- **Dash:** decisão canônica já aprovada pelo usuário: deve permanecer. Preservar Input Map, `BoltPlayer`, touch e testes; a exclusão na PR #1 está superada. Ver `ADR-001-DASH.md`.
- **Validação:** o status combinado consultado para este HEAD não retornou checks; a última execução documental confirmada permanece Docs CI run `45817363134` no commit anterior `caedfee2f790cc78222b281a5b602110d7229043`. Esta auditoria abrirá PR para nova execução documental. Godot CI mais recente com números detalhados continua sendo run `45809258952` no commit `4ecaff1d67049155d95bcbb5fc9d1c98187d3767` (42 testes, 171 verificações, 0 falhas).
- **Limites:** nenhuma exportação APK, instalação, emulador, editor gráfico, toque físico, safe area em aparelho ou medição de FPS/RAM/temperatura foi executada nesta auditoria.
- **Colaboração:** ChatGPT é o único escritor desta auditoria/branch. Claude Code não deve iniciar Etapa 2 até esta PR ser concluída e o handoff atualizado; depois disso, Claude é o próximo escritor.

# BOLT · AVENTURA — Registro de continuidade entre sessões

**Função:** handoff obrigatório para retomar trabalho após limite de contexto, troca de sessão ou interrupção.  
**Fonte de verdade do estado:** repositório e evidências; este arquivo é um índice de retomada, não substitui código, QA, ADRs ou tracker.

## Snapshot vigente — revisão de 2026-11-26

- **Última verificação completa da main:** HEAD `1e5294cf112c014c21e43c51b4c8e797beceb9b6` após PR #10. O HEAD muda a cada integração; confirmar novamente antes de iniciar.
- **PR #7 integrada:** merge `b8def7a22feee9573c8e4c46c99ed89cb92967c`; Docs CI #144 (PR) e #145 (push após merge) SUCCESS. A PR partiu do HEAD `75159132a7dc2503df68d8ca1abe57fc7e88019c`.
- O projeto Godot executável existe na raiz: Godot **4.7.2**, `project.godot`, cenas, scripts GDScript, recursos e testes. Continuar a base existente; não recriar o projeto.
- Etapa 0: **ACCEPTED**. Etapa 1: **HANDOFF_READY**. PRs #2–#10: **MERGED**.
- Próximo turno de gameplay: **Claude Code — Etapa 2**, somente depois da integração desta rodada e confirmação do HEAD atual pelo usuário/Claude.
- **PR #1:** OPEN e não mergeável; compare confirmado após PR #10: 17 commits exclusivos e 139 commits atrás (fotografia de 2026-11-26). A contagem muda com cada merge; consultar novamente antes de qualquer rebase. Contém apenas documentação; não contém implementação de gameplay. Preservada sem merge/fechamento.
- **Dash:** decisão canônica resolvida em 2026-11-26: deve permanecer. Preservar implementação, Input Map, touch e testes; a exclusão na PR #1 está superada. Não retunar sem escopo próprio.
- **Branch protection:** GitHub confirmou `protected=false` para `main`. A integração não oferece operação administrativa para ativar proteção/ruleset; o proprietário deve configurar manualmente. Como os workflows usam filtros por caminhos, não tornar checks condicionais obrigatórios sem um check agregador que sempre execute.
- **Validação máxima comprovada:** L2 (Godot headless/CI). Docs CI run #45817363134 SUCCESS no commit anterior `caedfee`; para o HEAD `1e5294c`, o status combinado consultado não retornou checks. Nova validação documental será disparada pela PR desta auditoria. Não há APK exportado/instalado, editor gráfico, emulador, toque físico, safe area em aparelho, FPS ou memória medidos.
- **Escopo concluído pelo ChatGPT nesta rodada:** reconciliação documental, revisão estática focalizada, análise da PR #1 e atualização do handoff. PR #7–#10 integradas sem alterações de gameplay. Claude Code é o próximo escritor da Etapa 2 após o usuário iniciar a sessão e confirmar o HEAD real.

O estado do repositório prevalece sobre handoffs antigos. Confirmar branch/HEAD/PRs antes de qualquer implementação.

## 1. Protocolo de retomada

Ao iniciar uma sessão:
1. Ler MASTER_DIRECTIVE.md, CLAUDE.md, AGENTS.md e este arquivo.
2. Ler stage-status.md, implementation-tracker.md, quality-control-protocol.md e os documentos da tarefa.
3. Inspecionar branch, HEAD, status do Git, diff e commits recentes; não presumir que o handoff ainda está atualizado.
4. Confirmar arquivos e estado real no repositório. O código prevalece sobre descrições antigas.
5. Reexecutar as verificações mínimas necessárias antes de continuar.
6. Continuar da próxima tarefa segura, sem repetir etapas já comprovadas.
7. Se houver divergência, atualizar este handoff com fatos atuais antes de implementar.

## 2. Baseline conhecido em 2026-11-25

- Repositório: jyanzy19-yml/new-bolt-aventura.
- Branch verificada: main.
- Escopo existente: ecossistema documental, skills, agentes, comandos, templates e automação.
- Árvore verificada nesta revisão: 217 entradas no Git tree.
- Skills Claude: 35; agentes consultivos: 8; comandos: 4 antes desta atualização.
- Workflow existente: validação documental via GitHub Actions.
- Não foi encontrado project.godot.
- Não foram encontradas cenas .tscn.
- Não foram encontrados scripts .gd de gameplay do jogo; os exemplos existentes pertencem às skills.
- Não foi verificado APK nem build Godot.
- Este baseline descreve a inspeção do repositório, não uma execução do Claude Code ou do Godot.

**Atenção:** atualizar todos os números e estados após nova inspeção. Não copiar esse baseline como se ainda fosse atual.

## 3. Estado da sessão atual

Preencher ao concluir cada sessão substancial:

- **Data/hora (UTC):** A preencher
- **Branch / commit inicial:** A preencher
- **Branch / commit final:** A preencher
- **Gate atual:** Fundação / vertical slice / sistemas / conteúdo / polimento / release
- **Objetivo trabalhado:** A preencher
- **Resultado:** A preencher
- **Arquivos alterados:** A preencher
- **Testes executados:** A preencher
- **Nível de validação (L0–L5):** A preencher
- **Falhas e bugs abertos:** A preencher
- **Bloqueios reais:** A preencher
- **Decisões/ADRs criadas ou alteradas:** A preencher

Não deixar campos como "feito" sem indicar arquivo, commit ou evidência.

## 4. Próxima tarefa executável

1. Ler COLLABORATION_STATE.md e confirmar agente, etapa e estado.
2. Reconfirmar HEAD, branch, PRs, diff e arquivos reais.
3. Se Etapa 0 estiver PENDING, Claude Code lê e executa `ETAPA_0_CLAUDE_CHECKLIST.md` e cria a fundação Godot definida no estado canônico, sem antecipar gameplay.
4. Detectar a versão estável Godot 4.x realmente instalada e registrar .godot-version somente após confirmar a versão usada.
5. Criar/validar project.godot, configuração Android/paisagem, input map e cena inicial funcional.
6. Executar import/parse headless quando possível; registrar o que não foi executado.
7. Atualizar tracker, stage status, continuidade, estado e handoff.
8. O próximo agente assume somente após inspecionar a entrega real e o commit integrado.

Se o projeto já existir, não recriar. Vertical slice e gameplay seguem roadmap e alternância; não devem ser antecipados por este registro.

## 5. Template de handoff por tarefa

TASK:
REQUIREMENT / SOURCE:
BRANCH + COMMIT:
FILES CHANGED:
IMPLEMENTED:
NOT IMPLEMENTED:
TESTS EXECUTED + RESULTS:
VALIDATION LEVEL (L0-L5):
KNOWN BUGS (ID / SEVERITY):
RISKS:
DECISIONS NEEDED:
NEXT EXACT ACTION:

## 6. Regras de integridade do handoff

- Registrar apenas fatos observados.
- Diferenciar proposta, implementação e validação.
- Não omitir testes falhos ou bloqueados.
- Não dizer que uma build foi instalada se apenas foi exportada.
- Não dizer que desempenho foi validado sem aparelho, duração e métricas.
- Não registrar segredos, tokens, senhas ou dados pessoais.
- Não criar um novo handoff paralelo; atualizar este arquivo.
- Manter o resumo curto o suficiente para retomada, apontando para relatórios detalhados quando necessário.

## 7. Critério de sessão encerrada corretamente

Uma sessão está pronta para handoff quando o trabalho está commitado ou suas alterações não commitadas estão explicitamente descritas, os testes estão registrados, os riscos estão identificados e a próxima ação pode ser executada sem depender da memória da conversa.


## 8. Snapshot mais recente após os controles adicionais

- Árvore Git verificada: 222 entradas.
- Skills: 35; agentes: 8; comandos: 6; documentos Markdown em docs/: 37.
- Rastreador: 24 IDs SYS e 42 IDs de fase W1-L1 a W7-L6; IDs únicos confirmados.
- Novos arquivos e links de navegação recuperados do GitHub.
- GitHub Actions run #51: SUCCESS para validação documental no commit b07fe549949def93fbca0b68a00a346a585ce1fc.
- Ainda sem project.godot, cenas .tscn ou scripts .gd de gameplay BOLT na árvore verificada.


## 9. Expansão da biblioteca de skills — 2026-11-25

- Adicionada `.claude/skills/godot-project-structure/SKILL.md`.
- Skill original orientada ao BOLT, inspirada na abordagem Function First apresentada por grndctrl/godot-skills; nenhum texto ou script externo foi copiado.
- O catálogo agora registra 36 skills: 26 da coleção comunitária Apache-2.0 já existente, 1 adaptação original de estrutura Godot e 9 skills originais BOLT.
- Router, CLAUDE.md, AGENTS.md, README.md e docs/README.md foram integrados ao novo fluxo.
- A skill exige inspeção do projeto real, leitura das ADRs e migração em lotes; não cria uma estrutura fictícia nem autoriza reorganização ampla automaticamente.
- A skill complementa a biblioteca existente; não foram importadas skills duplicadas de gameplay, QA ou profiling.
- Verificações Godot ainda não aplicáveis: a árvore continua sem projeto executável, salvo confirmação posterior em nova inspeção.


## 10. Snapshot verificado em 2026-11-25 — substitui os números anteriores

- Repositório: jyanzy19-yml/new-bolt-aventura.
- Branch de integração: main.
- Commit inspecionado antes da criação dos controles de colaboração: b9b84660b251313ff3cec014aced9292777e4550.
- Árvore recursiva: 225 entradas; 36 skills, 8 agentes, 6 comandos e 38 documentos Markdown em docs/.
- Workflow: um workflow de validação documental; run 45692594026 concluiu SUCCESS no commit b9b84660b251313ff3cec014aced9292777e4550.
- Não há project.godot, cenas .tscn ou scripts .gd de gameplay BOLT. Os scripts .gd encontrados pertencem a exemplos/testes das skills.
- Não foi executado Godot, não foi exportado APK e não houve teste em emulador ou aparelho nesta inspeção.
- PR #1 está aberto e divergente de main; não usar seu branch como base de implementação sem revisão.
- O estado de atribuição do próximo turno está em [COLLABORATION_STATE.md](COLLABORATION_STATE.md): Etapa 0 atribuída a Claude Code, PENDING; nenhum escritor ativo.
- A configuração de acesso e o template oficial estão em [AGENT_ACCESS_SETUP.md](AGENT_ACCESS_SETUP.md) e [HANDOFF_TEMPLATE.md](HANDOFF_TEMPLATE.md).

Este snapshot é uma inspeção de repositório e CI documental, não uma validação do jogo.


## 11. Snapshot após a criação dos controles de colaboração — 2026-11-25

- HEAD consultado antes desta atualização de snapshot: 5174de38ea500349704871b7fc9e625271d16b77.
- Árvore recursiva: 228 entradas; 36 skills, 8 agentes, 6 comandos e 41 arquivos Markdown em docs/.
- Existe um único workflow: validação documental.
- A validação foi disparada novamente após as mudanças de governança; consultar o GitHub Actions para o resultado final do commit mais recente. Execuções intermediárias já concluídas passaram, mas não declarar o último commit como aprovado até confirmar seu run.
- Os três documentos novos são COLLABORATION_STATE.md, AGENT_ACCESS_SETUP.md e HANDOFF_TEMPLATE.md.
- A integração foi adicionada a MASTER_DIRECTIVE.md, CLAUDE.md, AGENTS.md, README.md, docs/README.md e ao protocolo colaborativo.
- Não há project.godot, cenas .tscn ou scripts .gd de gameplay BOLT.
- Etapa 0 está atribuída a Claude Code e PENDING; nenhum escritor está ativo. O usuário deve iniciar Claude e confirmar que o ambiente dele tem escrita/commit no repositório.
- A PR #1 permanece aberta e divergente; não a usar como branch de trabalho sem revisar os 17 commits exclusivos e a divergência com main.

O HEAD deve sempre ser consultado novamente ao retomar; o hash acima é histórico do snapshot, não uma trava de versão.


## 12. Snapshot autoritativo mais recente — 2026-11-25

Substitui os inventários anteriores para retomadas atuais.

- HEAD main: d8d1a5b8801f0096ba372bf686c459fdba385931.
- Árvore: 228 entradas; 129 Markdown totais; 41 Markdown em docs/.
- 36 skills, 8 agentes, 6 comandos.
- 1 workflow documental no HEAD auditado; workflow Godot condicional adicionado nesta atualização.
- Sem project.godot, cenas .tscn, assets de jogo ou gameplay BOLT.
- Os 4 scripts .gd são exemplos/testes das skills.
- Run documental #90 SUCCESS; não valida engine, gameplay ou Android.
- PR #1 aberta e divergente (17 commits exclusivos da PR; 88 exclusivos de main); não mergeável no momento da consulta.
- Etapa 0 Claude Code PENDING; nenhum escritor ativo.
- Controles adicionados: pipeline CI, pipeline de assets e template de teste Android.

Limite de evidência: auditoria estrutural/documental. Não foi executado Godot, exportado APK, instalado build, usado emulador ou medido desempenho físico nesta sessão.


## 13. Snapshot após instalação dos controles de CI e QA — 2026-11-25

- HEAD main de referência: 75e5021b95c013c70b4b19d7fbb8a84290280647.
- Árvore: 232 entradas; 132 Markdown; 44 Markdown em docs/.
- 36 skills, 8 agentes, 6 comandos, 2 workflows.
- Sem project.godot, cenas .tscn, gameplay BOLT ou assets finais.
- Run documental #94 SUCCESS.
- Run Godot #4 SUCCESS com NOT APPLICABLE; não houve execução de engine.
- Etapa 0 Claude Code PENDING; nenhum escritor ativo.
- Ler COLLABORATION_STATE.md antes de escolher a próxima tarefa.
- Pipeline CI: CI_AND_VALIDATION_PIPELINE.md; assets: ASSET_PIPELINE.md; QA físico: ../qa/ANDROID_DEVICE_TEST_TEMPLATE.md.

Este snapshot substitui os inventários anteriores. A auditoria continua estrutural/documental, sem APK, emulador ou teste físico.


## 14. Snapshot de pré-produção — base auditada em 2026-11-25

- Commit-base auditado: `bc5799c651ccd5ffbcdfadf36f669435df63501b`.
- Inventário nessa base: 232 entradas; 132 Markdown totais; 44 Markdown em docs/; 36 skills; 8 agentes; 6 comandos; 2 workflows.
- Não existe `project.godot`, cena `.tscn` ou gameplay BOLT; os quatro `.gd` identificados pertencem a exemplos/testes de skills. Nenhum asset final de jogo foi identificado.
- CI documental Run #96: SUCCESS. CI Godot Run #6: SUCCESS com `NOT APPLICABLE`; o log confirma que não houve teste de engine porque `project.godot` estava ausente.
- PR #1 permanece aberta e divergente: 17 commits exclusivos da PR, 94 exclusivos de main. Não mesclar automaticamente.
- Etapa 0 continua PENDING para Claude Code; nenhum escritor ativo. O checklist e a auditoria estão em `ETAPA_0_CLAUDE_CHECKLIST.md` e `PREPRODUCTION_AUDIT.md`.
- As mudanças de pré-produção após o commit-base são documentais: corrigem coerência de ADR/orientação/narrativa, adicionam checklist e auditoria e reforçam QA Android. Não criam projeto Godot, gameplay ou assets.

Ao retomar, consultar o HEAD real; este snapshot descreve a base auditada e não substitui a inspeção atual do Git.


## 12. Sessão Etapa 0 — Claude Code — 2026-11-26 (estado mais recente)

- **Commit inicial:** `16d42de`. **Final:** `c32a99d` (`7057532` fundação + `c32a99d` gameplay-base/docs).
- **Gate:** Fundação (com base de movimento/touch/HUD/sandbox a pedido do usuário).
- **Resultado:** projeto Godot 4.7.2 executável; detalhes em [handoffs/HANDOFF_ETAPA_0.md](handoffs/HANDOFF_ETAPA_0.md).
- **Testes executados:** import sem erros; suíte headless 41 testes / 167 verificações / 0 falhas; 5 mutações detectadas; boot 20× sem erro; bot completa a sandbox.
- **Nível de validação:** L2 (headless). Nada em editor gráfico, aparelho, FPS, memória ou export.
- **Bugs abertos:** nenhum conhecido reproduzível; riscos em handoff (feel e toque real não avaliados).
- **Bloqueios:** export Android (sem SDK/templates); decisões do usuário (package ID, resolução, renderer, ABIs, "All Jump").
- **Próxima ação executável:** Etapa 1 (ChatGPT) — inspecionar HEAD, rodar `--import` e a suíte, auditar o conflito de escopo e escolher a próxima unidade do roadmap.


## 13. Sessão Etapa 1 — ChatGPT — 2026-11-26

- **Commit-base:** `ab72c584522db49ad7b31c80717fd2d6ab7ab73e` (HEAD de `main) confirmado antes de editar; nenhum commit posterior encontrado.
- **Commit de implementação:** `f3ab6829228c077b1a3c14eb65385a8a99c34608` (precedido por `4700d39` e `317f4ef`). Atualizações documentais de handoff/status foram gravadas depois; consultar o HEAD atual para o hash mais recente.
- **Gate/unidade:** Gate 1 em andamento; integridade de input multitouch e execução automática da suíte headless.
- **Revisão Etapa 0:** commits `7057532`, `c32a99d`, `ab72c58` e handoff inspecionados. Conflito de escopo aceito explicitamente: movimento/touch/HUD/sandbox ficam como base provisória solicitada; sandbox não é fase de campanha.
- **Achado:** S3 em `TouchControls._bind`: o mesmo índice de ponteiro podia ser reassociado sem liberar o botão anterior, deixando ação lógica presa. Corrigido com unbind defensivo; teste sintético de regressão adicionado.
- **CI:** Godot Run #36 SUCCESS (`624edce`): Godot 4.7.2 headless, import e `tests/test_runner.gd` exit 0. 42 métodos de teste identificados em 9 arquivos. Docs Run #124 SUCCESS. Nível L2.
- **Ambiente local:** Godot não instalado; execução local NÃO EXECUTADA. Editor gráfico, APK, Android físico, toque real, barras, FPS e memória NÃO EXECUTADOS.
- **Mutação:** não executada nesta sessão para a nova regressão; não declarar cobertura por mutação adicional.
- **Arquivos de implementação:** `scripts/input/touch_controls.gd`, `tests/unit/test_touch_controls.gd`, `.github/workflows/godot-validation.yml`.
- **Documentação:** tracker, stage-status, COLLABORATION_STATE, este arquivo e `handoffs/HANDOFF_ETAPA_1.md`.
- **Decisões/ADRs:** nenhuma alterada. Valores de movimento, layout touch e “All Jump” continuam provisórios.
- **Próxima ação:** Claude Code assume Etapa 2, revisa HEAD/handoff e continua Gate 1 conforme roadmap; não tratar a sandbox como fase final.



## 14. Handoff autoritativo para Etapa 2 — 2026-11-26

Esta seção substitui snapshots anteriores para a próxima retomada. O histórico anterior foi preservado como registro histórico.

- **Branch de integração:** `main`.
- **HEAD-base confirmado:** `4ecaff1d67049155d95bcbb5fc9d1c98187d3767` (merge da PR #3).
- **PR #2:** MERGED, commit `6f8bae62018fc2c7efce8fa454c16681599dcbe6`.
- **PR #3:** MERGED, commit `4ecaff1d67049155d95bcbb5fc9d1c98187d3767`.
- **Godot CI #45:** SUCCESS no commit da PR #3; importação condicional/análise de scripts concluídas.
- **Docs CI #133:** SUCCESS no commit da PR #3.
- **Etapa 0:** ACCEPTED. Hardening complementar adicionou falha do runner para suíte/checks vazios e recálculo de Safe Area no ciclo de vida; detalhes em `stage-0-hardening-audit.md`.
- **Etapa 1:** HANDOFF_READY. Correção multitouch, teste de regressão e CI executando a suíte; handoff em `handoffs/HANDOFF_ETAPA_1.md`.
- **Próximo responsável:** Claude Code — Etapa 2, aguardando o usuário iniciar manualmente. Handoff de entrada: `handoffs/HANDOFF_ETAPA_2_CLAUDE.md`.
- **Gate:** Gate 1 / vertical slice ainda EM ANDAMENTO. Próxima unidade deve ser escolhida após auditoria do HEAD e das especificações; não reiniciar nem duplicar sistemas já implementados.
- **Validação máxima:** L2. A suíte 42 testes/171 verificações/0 falhas pertence à execução anterior Godot CI #36; não atribuir esses números à Run #45 sem evidência específica.
- **Não executado:** APK/exportação, instalação, editor gráfico, emulador, Android físico, toque real, safe area em aparelho, FPS e memória.
- **PR #1:** permanece aberta/separada; não mesclar automaticamente.
- **Protocolo:** um único escritor; Claude trabalha em branch/PR e ChatGPT só assume após revisar, integrar e aceitar o handoff. O usuário inicia cada sessão manualmente.

**Próxima ação exata:** Claude deve confirmar que está em `main` no HEAD indicado ou descendente, ler as diretivas e handoffs, auditar o projeto real e então implementar a próxima unidade funcional do Gate 1, com testes e atualização dos registros.

## 15. Auditoria de polimento — 2026-11-26

- Main auditada em `9d5381047817ac9fc949583f6645d24eadd88e8c`; inventário de 328 entradas, 39 skills, 11 agentes, 6 comandos, 9 arquivos de teste unitário e 30 arquivos Godot executáveis.
- Auditoria estática documentada em `repository-polish-audit-2026-11-26.md` na branch `chore/repository-polish-audit`.
- Achados prioritários: documentos raiz descrevem incorretamente a existência do projeto; PR #1 está aberta/não mergeável e precisa de rebase/reconciliação; conflito de escopo sobre Dash; main sem proteção de branch confirmada.
- Nenhum código de gameplay foi alterado nesta auditoria. Não foram executados Godot local, APK, emulador ou Android físico.
- Próxima ação de Claude: conferir a main atual, ler a auditoria, continuar o projeto existente sem recriá-lo e evitar alterações de Dash até reconciliação da fonte canônica.


## 16. Decisão canônica sobre Dash — 2026-11-26

- O usuário confirmou explicitamente: **Dash deve permanecer no BOLT · AVENTURA**. Esta decisão substitui todas as anotações anteriores deste arquivo que tratavam o escopo como pendente.
- Decisão formal registrada em [ADR-001-DASH.md](ADR-001-DASH.md). Esta decisão prevalece sobre a exclusão de Dash na diretiva ainda não integrada da PR #1.
- Preservar a implementação existente em Input Map, `BoltPlayer`, controles touch e testes. Não remover. Alterações de física, tuning, cooldown, controles ou balanceamento exigem tarefa própria.
- A formalização foi exclusivamente documental; nenhum código de gameplay foi alterado.
- Próximo passo: validar a atualização documental na PR #11 e, após integração/aceite, entregar a Etapa 2 a Claude com este ADR como fonte canônica.
