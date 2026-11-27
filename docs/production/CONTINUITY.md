## Continuidade vigente — adoção do plano de 32 etapas (27/11/2026)

- Main HEAD: `d90ac2c78e96b32233f8d003ea6673a38079ecb3`; PR #72 e PR #73 integradas por squash.
- Docs Validation pós-merge PR #73: run `45986435957` SUCCESS.
- PR #73 formalizou o plano de 32 etapas, migração 26→32 e aprovação visual obrigatória antes de integração.
- Plano operacional primário: `docs/production/32-stage-production-plan.md`; matriz 26 etapas preservada como histórico/crosswalk.
- Etapas 01–04 permanecem concluídas no nível L2 documentado; antiga Etapa 05 migra para nova Etapa 29 e continua em andamento.
- Novas Etapas 05–09 são trabalho de direção de arte e produção visual; ChatGPT cria assets e apresenta cada entrega ao usuário. Nenhuma integração ocorre antes de aprovação explícita.
- ChatGPT conduz arquitetura, sistemas centrais, integração, performance Android, regressão, QA e criação de assets. Claude está autorizado nas cinco frentes registradas em `COLLABORATION_STATE.md`, com branch/PR isolada e sem integração de assets não aprovados.
- Gate 1 permanece em andamento; W1-L1/W1-L2 continuam blockouts; instalação e validação Android física permanecem pendentes.
- PR #72 adicionou regressão de overflow do PerformanceProbe; Godot Validation e Android Debug Export passaram no HEAD da PR. Não é evidência de profiling físico.
- Próxima execução: avançar a Etapa 29 com preparação de captura Android e iniciar planejamento técnico da nova Etapa 05 sem integrar arte não aprovada.

---

## Snapshot histórico de continuidade — 2026-11-27 (pré-adoção das 32 etapas)

- Main HEAD: `5e55fa1693d8ecf6d8a1d79bfffa1999824ad1ea`.
- PR #69 integrada: cancelamento lógico opt-in de SceneFlow, com drenagem da carga, sem cancelamento físico de I/O.
- PR #70 integrada: PerformanceProbe debug-only; CI PR: 107 testes/1.933 verificações/0 falhas; Docs e Android export SUCCESS.
- Pós-merge main: Godot 45969003590, Docs 45969003654 e Android Debug Export 45969003728 SUCCESS. APK 28.209.643 bytes, assinatura v2/v3 verificada, SHA-256 `4c2096d378a798f7df42735cf06a9dcb90330d8a6ae7a8ebf091ffd4a4ec74e9`, artifact ID 15183533835.
- Etapa 05 permanece ativa. A política de recursos está sendo formalizada em `technical/11-resource-lifecycle-policy.md`; nenhuma evidência atual justifica preload global ou purge forçado.
- Claude autorizado para fases, inimigos/chefes, interativos, UI/visual e sistemas independentes em branches isoladas. ChatGPT mantém arquitetura, infraestrutura, integração, profiling e QA. Evitar edição concorrente dos mesmos arquivos.
- Gate 1 e validação Android física continuam pendentes; APK exportado/headless não equivale a instalação, playtest ou profiling em aparelho.

---

## Snapshot histórico — 2026-11-27 (plano anterior de 26 etapas)

- **Repositório:** `jyanzy19-yml/new-bolt-aventura`.
- **Main HEAD:** `4544efc7082a17e7824ccf46c524db07486e3dc9`; PR #67 integrada por squash.
- **Hardening integrado:** PR #59 SaveSystem; PR #60 lifecycle/input Android; PR #63 Boot/cold-start; PR #65 validação de IDs duplicados; PR #66 integração real SceneFlow/LoadingOverlay; PR #67 validação de payload CampaignProgress vazio/parcial.
- **CI pós-merge main:** Docs 45920441923 SUCCESS; Godot 45920441898 SUCCESS; Android Export 45920441894 SUCCESS.
- **Evidência:** Godot 4.7.2 — 102 testes/1.891 verificações/0 falhas; 20/20 cold boots; mutation test do prewarm aprovado. APK debug 28.465.153 bytes, assinatura v2/v3 válida, package ID placeholder `com.example.boltaventura`, SHA-256 `cf6c96a48012a27d61db83354c777034ffe18c02fee8c2dd8c20e02acc1f0205`, artifact ID 15164521585.
- **Escritor ativo:** ChatGPT como único escritor; Claude permanece inativo para escrita concorrente.
- **Etapas:** 01–04 concluídas; Etapa 05 em desenvolvimento; Gate 0 estático concluído; Gate 1 em andamento. W1-L1/W1-L2 permanecem blockouts.
- **PRs abertas:** #57 (polimento visual, revisão independente); #58/#61/#62 (branches antigas/sobrepostas à PR #63; não mesclar automaticamente); #1 (PR documental antiga e divergente).
- **Dash:** decisão canônica aprovada e vigente; preservar conforme `docs/production/ADR-001-DASH.md`.
- **Limites:** APK debug exportado, mas não instalado em aparelho. Cold-start visual, touch físico, safe area/barras, lifecycle OEM, FPS, memória, temperatura e sessão prolongada permanecem pendentes.
- **Próximo passo:** iniciar Etapa 05 — revisar cancelamento de carregamento, política de preload, descarregamento seletivo e medições de tempo/memória/frame time; manter o scope de gameplay e canon inalterado.


- **Repositório:** `jyanzy19-yml/new-bolt-aventura`.
- **Main HEAD após PR #52:** `6f8e9b8fbaaab9c44247050e5f86e4442bd2622f`; PR #51/#52 integraram e revisaram o mapa arquitetural atual.
- **Última entrega de conteúdo de gameplay:** PR #34 — W1-L2 Rede Interrompida em blockout, campo energético e progressão W1-L1→W1-L2.
- **Última correção de gameplay:** PR #47 — estado inicial `initial_active=false` do `TimedEnergyGate`, merge `2636226c4027625649e66c51ff64d7e2e56168a6`.
- **Último componente de plataforma:** PR #46 — `OneWayPlatform`, merge `8ecfe0aa11eb911745bbe5e8e1b2211c03010702`; PR #45 adicionou `MovingPlatform`.
- **Última unidade documental:** PR #52 — acoplamento Player/Combat documentado e snapshots sincronizados; Docs CI pré/pós-merge SUCCESS. Etapas 01–03 concluídas.
- **Escritor ativo:** ChatGPT como único escritor, por decisão explícita do usuário; Claude permanece inativo para escrita concorrente.
- **Etapas operacionais:** Etapas 01–03 CONCLUÍDAS (auditoria, planejamento e baseline arquitetural); Etapa 04 EM DESENVOLVIMENTO (hardening dos sistemas centrais); etapas 05–26 conforme `stage-status.md`. Gate 0 estático concluído; Gate 1 continua em andamento.
- **CI pós-merge PR #46:** Godot `45888110305`, Docs `45888110285`, Android Export `45888110166`: SUCCESS; 87 testes/548 verificações/0 falhas.
- **CI pós-merge PR #47:** Godot `45894802128`, Docs `45894802067`, Android Export `45894802116`: SUCCESS; 88 testes/553 verificações/0 falhas. APK 28.461.057 bytes, SHA-256 `c3ca03958eecf120f1a9f5f1e4fae3851fb7560bca303c8eb5a930f987b58123`, assinatura v2/v3 válida; package ID continua placeholder `com.example.boltaventura`.
- **CI pós-merge PR #48:** Docs `45895074739` SUCCESS.
- **PR #1:** continua OPEN, antiga e divergente; não mesclar/rebasear automaticamente. Revisar o diff inteiro e reconciliar documentos raiz antes de qualquer decisão.
- **Dash:** decisão canônica aprovada e vigente; deve permanecer conforme `docs/production/ADR-001-DASH.md`.
- **Limites:** W1-L1/W1-L2 continuam blockouts. APK debug exportado, mas não instalado em aparelho. Toque físico, safe area, barras, lifecycle, profiling e performance Android permanecem pendentes.
- **Próximo passo:** auditar edge cases de Boot/SceneFlow/SaveSystem/CampaignProgress/LoadingOverlay na Etapa 04, corrigir defeitos confirmados e ampliar regressões sem alterar o schema/canon.

---

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


## Sessão ChatGPT — W1-L1 progress feedback — 2026-11-26

- Base main confirmada: `13105c5422b73e2c362bdf3d4ce9eea45c97fc99` (PR #23 integrada; Godot pós-merge #45851700830 e Docs #45851700746 SUCCESS).
- Branch de trabalho: `feat/w1-l1-progression-feedback`.
- Alterações: HUD com notificação transitória temporizada; integração de feedback para checkpoint e coletável de recuperação; teste W1-L1 atravessa os gatilhos físicos de checkpoint, queda/respawn, cura e objetivo.
- Revisão geométrica: nenhum ajuste de piso necessário; `PlatformBlock` usa origem superior esquerda e Goal já está sobre EndFloor. O teste verifica essa condição.
- Dash, ActionBuffer, controles touch, Pistola Crono, inimigo-base e parâmetros de combate não foram retunados.
- CI desta branch pendente; corrigir falhas até a causa-raiz. Não integrar sem Godot e Docs CI verdes.
- Não executado: playtest humano, export APK, instalação, emulador, dispositivo Android, FPS, memória ou latência física.
- Próxima ação: aguardar CI, revisar logs, corrigir falhas, abrir PR e integrar apenas após checks verdes; registrar merge SHA e CI pós-merge.

- Achado adicional: checkpoint original ficava próximo o suficiente do limite da área de contato do inimigo para permitir dano imediato no respawn. Reposicionado para x=980; teste de integração calcula e exige separação superior à soma dos semilarguras das formas de colisão. CI do SHA final pendente.


## Pós-merge PR #24 e continuação — 2026-11-26

- PR #24 integrada por squash em `532320ec9c5b3507d880717e4437603a984b7808`.
- Godot CI pré-merge `45854657846` SUCCESS: 53 testes, 296 verificações, 0 falhas; Docs CI `45854657850` SUCCESS. CI pós-merge main Godot `45854849226` e Docs `45854849212` SUCCESS.
- Próxima branch: `test/w1-l1-live-combat-encounter`, baseada na main pós-merge.
- Escopo: ampliar `test_campaign_entry.gd` para validar o disparo ATTACK através de InputEvent → ActionBuffer → BoltCombat → ChronoProjectile → CybercorePatrolEnemy real, sem retunar o combate.
- Não executado: playtest humano, APK, instalação, emulador, Android físico ou métricas de performance.


## Pós-merge PR #25 e próximo gate — 2026-11-26

- PR #25 integrada em `92b35d52723f5fa1b05a8e53921a2d8605c6f1cf`.
- Godot CI pré-merge `45855173247` SUCCESS: 53 testes, 298 verificações, 0 falhas. Docs CI `45855173229` SUCCESS.
- Entrega: integração verificada do disparo da Pistola Crono no inimigo real de W1-L1 via InputEvent → ActionBuffer → BoltCombat → ChronoProjectile → CybercorePatrolEnemy.
- Pós-merge main CI ainda precisa de verificação final: Godot `45855371627` / `45855463491`, Docs `45855371706` / `45855463599`.
- Próxima branch: `test/w1-l1-defeat-retry-flow`, com cobertura do overlay de derrota e do contrato do botão de reinício, sem alterar gameplay.
- Não executado: playtest humano, APK, instalação, emulador, Android físico, FPS, memória ou latência física.


## Pós-merge PR #26 — 2026-11-26

- PR #26 integrada por squash em `3428851c774f989d3522da1ed0430e9d39f7a680`.
- Godot CI pré-merge `45855625278` SUCCESS: Godot 4.7.2, 54 testes, 304 verificações, 0 falhas. Docs CI `45855625442` SUCCESS.
- CI pós-merge main: Godot `45855795164` SUCCESS (54 testes / 304 verificações / 0 falhas); Docs `45855795173` SUCCESS.
- W1-L1 agora tem cobertura de integração para a cadeia real de disparo no inimigo, checkpoint/queda/respawn, coletável/recuperação, saída, derrota e contrato de retry.
- Nenhum APK, instalação, emulador, Android físico, FPS, memória ou latência foi testado. W1-L1 permanece Em andamento; ainda falta conteúdo final, persistência de campanha e playtest/QA Android.


## Sessão ChatGPT — fundação SaveSystem — 2026-11-26

- Base main: `7af315f258a1360d84906ef72f98eae39611b623` (PR #27 integrada; rastreabilidade atualizada após PR #26).
- Branch: `feat/versioned-save-storage-foundation`.
- Implementação em andamento: autoload `SaveSystem`, armazenamento `user://bolt_save.json`, envelope JSON v1, checksum SHA-256, validação estrita de payload, temporário/backup e recuperação de backup.
- API é de baixo nível e não define o payload da campanha. Nenhum checkpoint ou progresso W1-L1 foi conectado; evitar alegar persistência de gameplay.
- Testes: round-trip, overwrite, delete, fallback de backup, formato futuro e rejeição de Node no payload. CI ainda pendente.
- Não executado: Android físico, exportação APK, instalação, emulador, interrupção forçada do processo, benchmark de I/O ou teste de armazenamento em OEM.
- Próxima ação: validar GDScript/import e suíte; corrigir causa-raiz; abrir PR; integrar apenas com Godot/Docs CI verdes; depois definir/integrar o primeiro payload de campanha por IDs estáveis.


## Sessão ChatGPT — CampaignProgress e checkpoint persistente W1-L1 — 2026-11-26

- Base main confirmada: `e09ee388aa511d78f2b36c4ee6be9617d0c27655` (PR #28 integrada; Godot pós-merge #45858347751 SUCCESS, 58 testes/335 verificações/0 falhas; Docs #45858347565 SUCCESS).
- Branch: `feat/w1-l1-persistent-checkpoint-progress`.
- Adiciona autoload `CampaignProgress` sobre `SaveSystem`, schema de domínio v1, IDs estáveis de campanha/nível/checkpoint, persistência de checkpoint e conclusão W1-L1.
- `BoltCheckpoint.restore_activation()` restaura apresentação/estado sem reemitir o evento; reentrada da W1-L1 posiciona BOLT no ponto salvo.
- O objetivo marca W1-L1 como concluída e limpa checkpoint ativo; não tenta carregar W1-L2, que não existe.
- ADR-0004 registra a decisão técnica. Testes isolam os arquivos user:// para não tocar no slot real.
- CI da branch ainda pendente. Não executado: APK, instalação, emulador, Android físico, encerramento forçado, filesystem OEM, FPS, memória ou latência.


## Pós-merge PR #29 — 2026-11-26

- PR #29 integrada em `44d9e0fcda68200579506b909c8920d4692cdc84`.
- Godot CI pré-merge `45859492456` SUCCESS: 62 testes, 369 verificações, 0 falhas; Docs CI `45859492355` SUCCESS.
- W1-L1 persiste o checkpoint quando ativado, restaura estado visual/respawn na reentrada e registra a conclusão da fase no schema CampaignProgress v1.
- CI pós-merge main Godot `45859653809` e Docs `45859653966` ainda aguardando confirmação final.
- Persistência ainda não validada em Android físico ou após encerramento forçado. Sandbox e demais fases não integradas.


## Sessão ChatGPT — fluxo Nova Jornada / Continuar — 2026-11-26

- **Base main confirmada:** `52f75f437c37cbc018ef8d4611f49fb462bae74c`.
- **Branch:** `feat/main-menu-new-game-continue`.
- **Escopo:** fluxo explícito de Nova Jornada e Continuar integrado ao `CampaignProgress`; o projeto continua em Godot 4.7.2 e Android empacotado em paisagem.
- **Auditoria:** o menu anterior só iniciava abertura/tutorial; W1-L1 só registrava progresso em checkpoint/conclusão, não na entrada inicial.
- **Decisão:** Nova Jornada reseta apenas `campaign_progress` e inicia abertura/tutorial; Continuar só aceita o ID W1-L1 quando a cena está presente e abre W1-L1 diretamente. Não criar destino W1-L2.
- **Persistência:** W1-L1 registra `current_level_id` na entrada. Reentrada na mesma fase não limpa checkpoint.
- **Falha de save:** ausência de save é estado limpo; schema de campanha incompatível pode ser substituído apenas pela ação explícita Nova Jornada; envelope ilegível não é apagado automaticamente e não impede iniciar a sessão, embora a persistência possa ficar indisponível.
- **Arquivos de implementação:** `scripts/campaign/campaign_progress.gd`, `scripts/ui/main_menu.gd`, `scenes/ui/main_menu.tscn`, `scripts/campaign/cybercore_w1_l1.gd`.
- **Testes adicionados:** `tests/unit/test_campaign_progress.gd` e `tests/unit/test_campaign_entry.gd`; aguardando CI Godot/Docs.
- **Validação local:** não executada; sem runtime Godot local disponível nesta sessão. Não alegar teste headless até o workflow concluir.
- **Não executado:** editor gráfico, exportação APK, instalação, emulador, Android físico, teste de encerramento forçado, FPS, memória e I/O.
- **PR #31:** integrada por squash em `42b60c06615c1d1bd8059e315f34fcedcff04d81`.
- **CI pré-merge:** Godot run `45862187355` SUCCESS — 66 testes/404 verificações/0 falhas; Docs run `45862187418` SUCCESS.
- **CI pós-merge main:** Godot run `45862459941` SUCCESS — 66 testes/404 verificações/0 falhas; Docs run `45862459947` SUCCESS.
- **Limites:** W1-L1 continua em andamento; sem encerramento forçado, editor gráfico, APK, emulador, Android físico ou benchmark.
- **Achado preexistente fora do escopo:** o coletável altera `Area2D.monitoring` sincronicamente durante `body_entered`, gerando erro no log. O mesmo erro consta no CI anterior `45859653809`; não foi introduzido pela PR #31. Registrar para correção isolada.
- **Próxima ação:** continuar a próxima unidade de produção a partir do HEAD integrado; preservar W1-L1 como blockout e não criar W1-L2 sem implementação real.


---

## Sessão ChatGPT — correção de feedback do checkpoint W1-L2 — 2026-11-26

- **Base:** `main`, referência confirmada `4226c5ebe397993e11aa9d23d24e240796e2f6b1`; PR #35 já integrada.
- **Branch ativa:** `fix/w1-l2-checkpoint-feedback`.
- **Achado:** `scripts/campaign/cybercore_w1_l2.gd::_on_checkpoint_activated` só apresentava `CHECKPOINT ATIVADO` no ramo de falha de `CampaignProgress.save_checkpoint`. O caminho de sucesso persistia o checkpoint sem feedback visual.
- **Alteração:** mover a notificação para fora da condição de erro; preservar `push_warning` quando o salvamento falhar.
- **Regressão:** `tests/unit/test_w1_l2_progression.gd` verifica que `ProgressNotification` fica visível e contém o texto esperado após ativação real do checkpoint.
- **Plano:** `docs/production/plans/2026-11-26-w1-l2-checkpoint-feedback.md`.
- **Commits da branch:** correção de gameplay `28d0bdc17f6424917160e4f2ef4ae1e8a100f67f`; regressão `a3b5e3acb611ced259984d643b9a1a244bd3a26c`; plano `17ffdaaa4fde495f1a17b58af744b44a1ade8225`.
- **Validação:** ainda não confirmada nesta branch. A API de status combinado consultada no HEAD de main não retornou checks; workflows associados a esse commit também não foram retornados por esse endpoint. Aguardar workflows da PR.
- **Não executado:** Godot local, editor gráfico, APK, emulador, Android físico, touch físico, safe area ou profiling.
- **Próximo passo:** revisar o conteúdo final da branch, abrir PR, aguardar Godot CI e Docs CI, corrigir qualquer falha e só integrar com checks verdes.


---

## Sessão ChatGPT — baseline de 26 etapas e regressão física do coletável — 2026-11-26

### Estado confirmado do repositório

- Repositório: `jyanzy19-yml/new-bolt-aventura`.
- `main` confirmada no merge commit da PR #36: `afea046b6a481d48299641c9d8e529f6288d5256`.
- PR #36 fechada e integrada por squash. Godot CI pré-merge e Docs CI pré-merge SUCCESS; CI pós-merge Godot run `45877649854` SUCCESS e Docs run `45877649923` SUCCESS.
- A única PR aberta identificada na consulta é a PR #1 documental, antiga e divergente; não integrar nem rebasear automaticamente.
- Projeto atual confirmado: Godot 4.7.2, GDScript, aplicativo Android empacotado em paisagem. W1-L1 e W1-L2 seguem blockouts; campanha completa não existe.
- A auditoria examinou árvore recursiva (383 entradas), documentos mestrais, ADRs, bíblias, especificações, estado de produção, testes, workflows e sistemas executáveis pertinentes. A Etapa 01 das 26 permanece **EM ANÁLISE** até a consolidação de todas as dependências e cobertura documental.

### Unidade em execução

- **Branch:** `test/health-pickup-physical-contact`.
- **Base:** `afea046b6a481d48299641c9d8e529f6288d5256`.
- **Commits:** teste físico `e139825a11e1f4bb77c194faf27109f7465cd1b9`; filtro CI para erro físico `7525a7db38d9771b1aad6ff8fec524aaa0689820`; plano `0a85dcc6d02968d8c0c021f01f5c05b46e9c6e92`.
- **Arquivos alterados:** `tests/unit/test_enemy_combat.gd`, `.github/workflows/godot-validation.yml`, `docs/production/plans/2026-11-26-health-pickup-physical-contact.md`, `docs/production/stage-status.md`, `docs/production/implementation-tracker.md`, `docs/production/CONTINUITY.md`.
- **Diagnóstico:** teste antigo chamava `_on_body_entered` diretamente; não comprovava `Area2D.body_entered` por contato real. O script de produção já usa `set_deferred("monitoring", false)`.
- **Implementação:** adicionado teste com player/coletável instanciados e sobrepostos; CI agora procura o erro Godot de mutação física bloqueada durante callbacks de entrada/saída e flush de queries.
- **Validação:** ainda não executada nesta branch; aguardar Godot CI e Docs CI. Nenhum Godot local, editor gráfico, APK, emulador ou Android físico foi executado.
- **Próximo passo:** revisar diff/compare, abrir PR, analisar os checks, corrigir falhas e integrar somente com CI verde.


---

## Sessão ChatGPT — pipeline de exportação Android debug — 2026-11-26

- **Base main:** `39b6db8298542c5057c06f509b20d250a888e289` (PR #37 integrada).
- **Branch:** `ci/android-debug-export`.
- **Objetivo:** criar exportação automatizada de APK debug usando o preset Android existente e versões pareadas do Godot/export templates.
- **Configuração:** JDK 17, Android SDK Platform 35 / Build Tools 35.0.1, NDK r28b, CMake 3.10.2.4988404, chave debug efêmera e variáveis oficiais de exportação Android.
- **Segurança:** nenhuma credencial de release, keystore persistente, package ID definitivo ou segredo foi criado. `com.example.boltaventura` continua placeholder.
- **Workflow:** `.github/workflows/android-debug-export.yml`; plano `docs/production/plans/2026-11-26-android-debug-export-pipeline.md`.
- **Validação:** aguardando execução do workflow na PR. Não há APK confirmado, hash de artefato, instalação, emulador ou teste em dispositivo físico nesta sessão.
- **Próximo passo:** abrir PR, revisar o workflow e corrigir qualquer falha real; após sucesso, confirmar artifact e metadados; atualizar continuidade e distinguir exportação de validação no dispositivo.


---

## Sessão ChatGPT — exportação Android integrada e correção de ActionBuffer — 2026-11-26

### PR #38 — pipeline Android debug integrada

- PR #38 foi reaberta após revisão da execução final e integrada por squash em `d08a2b203e525ccc98a4a0e45d1532b41e674fc5`.
- Godot Validation `45879045282`, Docs Validation `45879045081` e Android Debug Export `45879045098`: SUCCESS.
- Artefato: `bolt-aventura-android-debug-5be706c042fceaa66dadf2509ffafd0833ad3617` (28.194.385 bytes).
- Godot 4.7.2; assinatura APK v2/v3 válida; package ID `com.example.boltaventura` provisório; SHA-256 `acbacb86afeb767e293ba357d6749db4bdde55c2d78c05f90779dafc5f438fab`.
- Exportação em CI comprovada; instalação, cold start, touch, safe area, lifecycle e performance física não executados.

### Unidade atual — ActionBuffer lifecycle

- Branch: `fix/action-buffer-lifecycle-clear-v2`, base `d08a2b203e525ccc98a4a0e45d1532b41e674fc5`.
- Arquivos de gameplay/teste: `scripts/input/action_buffer.gd`, `tests/unit/test_action_buffer.gd`.
- Mudança: limpar edges pendentes em `NOTIFICATION_APPLICATION_PAUSED`, `NOTIFICATION_APPLICATION_FOCUS_OUT`, `NOTIFICATION_WM_WINDOW_FOCUS_OUT` e `NOTIFICATION_PAUSED`.
- Regressões: pending JUMP descartado na perda de foco; pending DASH descartado na suspensão do app.
- Plano: `docs/production/plans/2026-11-26-action-buffer-lifecycle-clear.md`.
- **Estado:** implementação escrita; CI ainda não confirmado. Sem validação Android física.
- **Próximo passo:** abrir PR, aguardar Godot/Docs CI, revisar logs e corrigir falhas antes de integrar. Depois seguir para instalação e testes de ciclo de vida em aparelho.


---

## Sessão ChatGPT — PR #39 integrada e reconciliação documental — 2026-11-26

- Main HEAD: `50c9bfdd997edf0cb5cb7cfb22d246bd4d0beca2`.
- PR #39 integrada por squash; Godot Validation `45881320136` SUCCESS — 72 testes/451 verificações/0 falhas; Docs Validation `45881320133` SUCCESS; Android Debug Export `45881252046` SUCCESS.
- PR #39 corrige edges pendentes do `ActionBuffer` em notificações de pausa/suspensão/perda de foco; não altera física ou tuning.
- Artifact de export: `bolt-aventura-android-debug-7415dfb988faf2dd63f9ff289106e7f7205dcdd1`, 28.194.534 bytes; package ID provisório `com.example.boltaventura`; SHA-256 `db03a42b909781a1f5e7c94d025615e1aa5f397c8ebd306ba30cddf84eca14b0`.
- **CI pós-merge main:** Godot `45881703643`, Docs `45881703650`, Android export `45881703604`: SUCCESS; 72 testes/451 verificações/0 falhas. Artifact main `bolt-aventura-android-debug-50c9bfdd997edf0cb5cb7cfb22d246bd4d0beca2`, APK 28.447.553 bytes, SHA-256 `edb88f43f407241e5716d6b7d327272c22e40f1025a00637d7393573e320c6d7`.
- Instalação e validação física Android continuam pendentes.
- Branch atual: `docs/reconcile-canonical-decisions-2026-11-26`.
- Auditoria documental encontrou conflito resolvido no canon mas não nos documentos: MASTER_DIRECTIVE e diretiva integral ainda classificavam Dash como pendente, apesar do ADR-001; AGENTS/CLAUDE ainda descreviam alternância obrigatória apesar da decisão de ChatGPT como único escritor.
- Esta unidade atualiza apenas documentação e governança; não altera gameplay.


---

## Sessão ChatGPT — overlay persistente de carregamento — 2026-11-26

- **Main base:** `85412c3bdd5c6eefd27f25bf2a56af4b38fcdfed` (PR #40 integrada).
- **Branch:** `feat/scene-loading-overlay`.
- **Achado:** `SceneFlow` já carregava cenas em thread, mas não havia overlay persistente conectado aos sinais de transição; Boot só tinha um rótulo local.
- **Implementação:** autoload `LoadingOverlay` com cena `scenes/ui/loading_overlay.tscn`; progresso percentual somente quando o ResourceLoader fornece valor real; overlay ocultado em sucesso/falha; input bloqueado durante a transição.
- **Resiliência:** `SceneFlow` agora processa durante pausa da árvore.
- **Testes:** autoload, estado inicial, progresso real, sucesso/falha e processamento durante pausa.
- **Plano:** `docs/production/plans/2026-11-26-scene-loading-overlay.md`.
- **Limites:** sem espera artificial mínima, sem cancelamento explícito ou preload avançado; CI ainda pendente nesta branch; validação visual/Android físico não executada.


---

## Sessão ChatGPT — bloqueio integral de input em transições — 2026-11-26

- Main base: `66b3c0e060762ebe1f3c4b6af84c84a79f0cd781` (PR #41 integrada).
- PR #41 pós-merge: Godot `45883137849` SUCCESS (75 testes/470 verificações/0 falhas), Docs `45883137856` SUCCESS, Android export `45883137961` SUCCESS.
- Artefato main PR #41: `bolt-aventura-android-debug-66b3c0e060762ebe1f3c4b6af84c84a79f0cd781`, APK 28.456.143 bytes, SHA-256 `5c630ba464bdd34617aface29e86da721eb1b9578f5f82d717b15b619941f213`.
- Achado pós-merge: overlay capturava GUI/touch, mas não bloqueava por si só ações de teclado.
- Branch `fix/scene-flow-input-lock`: pausa SceneTree, mantém SceneFlow/LoadingOverlay processando, oculta controles touch, ignora pausa no HUD durante transição, retoma após sucesso e restaura estado de pausa em falha.
- Plano: `docs/production/plans/2026-11-26-scene-flow-input-lock.md`.
- **Estado:** implementação escrita; aguardando Godot/Docs CI. Sem teste físico Android.


---

## Sessão ChatGPT — regressão de restauração após falha de transição — 2026-11-26

- Main base: `68b677aa7860894928a690861ef63b300f8175fb` (PR #42 integrada).
- PR #42: Godot `45883759266` SUCCESS — 77 testes/479 verificações/0 falhas; Docs `45883759252` SUCCESS; Android Debug Export `45883759260` SUCCESS.
- APK da PR #42: artifact `bolt-aventura-android-debug-b5f277107f2c590ef5401cd24c0d15e7f0a6468b`, SHA-256 `976b83d44abb50a7c545e8943b3f5b89ebfbb98ef364eb3a3da9224f0fb79f2c`.
- Achado: a restauração do pause state em sucesso estava coberta; o ramo de falha ainda não tinha teste direto.
- Branch `test/scene-flow-failure-pause-restoration`: regressões para origem pausada e despausada.
- **Estado:** teste escrito; aguardando CI.


---

## Sessão ChatGPT — contratos da câmera 2D — 2026-11-26

- Main base: `22923228d2a58c0ee6d75b581d5a16aa70e1a7ef` (PR #43 integrada).
- PR #43: Godot `45884348999` SUCCESS — 78 testes/484 verificações/0 falhas; Docs `45884348954` SUCCESS; Android Export `45884348969` SUCCESS.
- PR #43 artifact: `bolt-aventura-android-debug-b6bf765bccdb80c2de0512655208060ab2fc1480`, APK 28.456.143 bytes, SHA-256 `3dc8eba90dc3f914b1db725f50fbdc38bee9a16dee2c38d95b05f476a41cb212`.
- PR #43 pós-merge main: Godot `45884671403`, Docs `45884671584`, Android export `45884671259` SUCCESS; artifact main `bolt-aventura-android-debug-22923228d2a58c0ee6d75b581d5a16aa70e1a7ef`, APK 28.456.143 bytes, SHA-256 `3fc5ea209e88a69b3b33a7de9360dbc42d38dae9a2734eb38e103ab7f2478661`.
- Achado: Camera2D já usa rig nativo com smoothing/drag e limites W1-L1/W1-L2; faltavam testes dedicados.
- Branch `test/camera-contracts`: extrai `configure_camera()` nos scripts de fase e testa smoothing, margins, callback físico e limites por fase.
- Plano: `docs/production/plans/2026-11-26-camera-contracts.md`.
- **Estado:** aguardando CI; inspeção visual e Android físico pendentes.


---

## Sessão ChatGPT — plataforma móvel reutilizável — 2026-11-26

- Main base: `88b753f3b28d6591642a044b76d2d1ec21ad0d73` (PR #44 integrada).
- PR #44: Godot `45885327218` SUCCESS — 81 testes/508 verificações/0 falhas; Docs `45885327202` SUCCESS; Android export `45885327266` SUCCESS.
- Pós-merge main: Godot `45885612259`, Docs `45885612332`, Android export `45885612341` SUCCESS; artifact main `bolt-aventura-android-debug-88b753f3b28d6591642a044b76d2d1ec21ad0d73`, SHA-256 `de37ec1b4330f1845eb434f079be92a3c83d661cbfc1aecfd431a9fe75a3fe2d`.
- Etapa 09: camera rig e limites W1-L1/W1-L2 possuem regressões headless; inspeção visual continua pendente.
- Próxima unidade: `feat/moving-platform-system`, implementação de `AnimatableBody2D` ping-pong para suporte a plataformas móveis. Sem integração em fase nesta unidade.


---

## Sessão ChatGPT — plataforma móvel integrada e plataforma unidirecional — 2026-11-26

- Main HEAD: `b24c8624a8ed64816d0131070f440a47f525ba47` (PR #45 integrada).
- PR #45 pré-merge e pós-merge: Godot 4.7.2 — 85 testes/533 verificações/0 falhas; Docs SUCCESS; Android debug export SUCCESS.
- APK main: artifact `bolt-aventura-android-debug-b24c8624a8ed64816d0131070f440a47f525ba47`, 28.460.646 bytes, package ID provisório `com.example.boltaventura`, SHA-256 `3b3be5c8df067c000216bbc3e5ad39b357f0ea70ad3d3a5bc12625724873ffd1`.
- MovingPlatform está integrado como componente reutilizável, sem uso em fase da campanha.
- Nova unidade `feat/one-way-platform`: implementar plataforma que permite passagem de baixo para cima e colisão ao aterrissar por cima, conforme Godot 4.7.


## Sessão ChatGPT — plataforma unidirecional — 2026-11-26

- Main base: `b24c8624a8ed64816d0131070f440a47f525ba47` (PR #45 integrada).
- Unidade atual: `feat/one-way-platform`.
- `OneWayPlatform` estende `PlatformBlock`; direção de bloqueio `Vector2.DOWN` permite atravessar por baixo e aterrissar por cima.
- Testes adicionados para configuração da shape, passagem ascendente e aterrissagem descendente.
- Plano: `docs/production/plans/2026-11-26-one-way-platform.md`.
- **Estado:** aguardando CI. Não integrada em fase.
\n\n## Sessão ChatGPT — integração da PR #46 — 2026-11-26\n\n- PR #46 `feat: add reusable one-way platform` integrada por squash; merge `8ecfe0aa11eb911745bbe5e8e1b2211c03010702`.\n- Implementação: `scripts/world/one_way_platform.gd`, `scenes/world/one_way_platform.tscn`; teste `tests/unit/test_one_way_platform.gd`; contrato atualizado em `docs/technical/05-system-contracts.md`.\n- Godot CI pré-merge `45887805114`: SUCCESS — 87 testes/548 verificações/0 falhas. Docs CI `45887805097`: SUCCESS. Android Debug Export `45887805269`: SUCCESS; artifact e hash registrados em `stage-status.md`.\n- Não houve integração em fase; margin 2 px e dimensões são provisórias. Sem playtest visual ou Android físico. Pós-merge CI da main não confirmado no momento do registro.\n

---

## Sessão ChatGPT — recuperação de temporário e proteção de versão futura do SaveSystem — 2026-11-26

- Main confirmada no início: `54fd48e5f49fba877740265aafa0d8f649c2b1e9`.
- Branch: `fix/save-system-temp-recovery-2026-11-26`.
- Arquivos funcionais alterados: `scripts/core/save_system.gd`, `scripts/campaign/campaign_progress.gd`, `tests/unit/test_save_system.gd` e `tests/unit/test_campaign_progress.gd`.
- `load_payload()` tenta recuperar `.tmp` completo, com checksum/payload válidos, quando o principal está ausente ou inválido; promove o temporário ao principal. A precedência permanece principal válido → `.tmp` válido → backup válido.
- Um envelope de versão não suportada em qualquer slot (principal, temporário ou backup) bloqueia a seleção de uma cópia para evitar downgrade silencioso. `save_payload()` verifica os três slots e bloqueia escrita/rotação quando qualquer um contém versão não suportada, preservando os bytes existentes.
- `has_save()` reconhece `.tmp` pendente. Schema v1, API pública e domínio CampaignProgress não foram alterados.
- `CampaignProgress` reconhece `recovered_temp`/`recovered_temp_unpromoted:*` como recuperação do armazenamento, preservando validação independente do schema de campanha.
- Testes adicionados para recuperação do temporário mais novo que backup, preservação de temporário em nova gravação, precedência/fallback, proteção dos três slots futuros e continuidade de checkpoint da campanha.
- **Estado no checkpoint:** PR #59 aberta; diff revisado. Godot Validation `45913709017` SUCCESS — 95 testes/652 verificações/0 falhas; Documentation Validation `45913709173` SUCCESS; Android Debug Export `45913709027` SUCCESS. APK 28.465.153 bytes, package ID provisório `com.example.boltaventura`, assinatura v2/v3 válida, SHA-256 `2f9ae799db84dbcf648566c8953c5fede9bcb91800417edb9586005092ad358f`; artifact `bolt-aventura-android-debug-90ef12231618606280134d7f29d2761d74ca8306`. PR não integrada. Próximo passo: manter a unidade revisável e continuar auditoria estática de Boot/SceneFlow/LoadingOverlay como parte da Etapa 04; não mesclar automaticamente.
- Limites: nenhum teste local Godot, encerramento forçado real, Android físico, APK desta branch, profiling ou acesso ao save real do usuário foi realizado.


## Sessão ChatGPT — Etapa 12: contrato de estados do BOLT — 2026-11-27

- PR #91 aberta: `test/stage12-player-state-transition-contract-2026-11-27`.
- Teste em `tests/unit/test_player_movement.gd` observa o sinal `BoltPlayer.state_changed` e exige `RISING → FALLING → GROUNDED` sem duplicações.
- CI no head `0019ac9b0ac1bf813c4bcc874d9017fa69bf0295`: Godot `46027916866`, Docs `46027916827` e Android Debug Export `46027916828` concluídos SUCCESS.
- Nenhum runtime, cena, tuning, física, InputMap, Dash, arte ou save foi alterado. A exportação debug não foi instalada em aparelho.
- PR #91 não integrada; Etapa 12 continua EM ANDAMENTO. Próxima unidade independente: contratos de configuração espacial/câmera da Etapa 13, sem sobrepor a PR #91.


## Sessão ChatGPT — consolidação de contratos da Etapa 14 — 2026-11-27

- Base `main`: `79023eabb6b31bccc456d3a2d005731733e8444e`.
- Criada branch `integration/stage14-respawn-checkpoint-defeat-contracts-2026-11-27` para reunir as regressões anteriormente divididas nas PRs #93–#96, reduzindo divergência documental e repetição do mesmo ajuste no workflow Android.
- Quatro contratos: recuperação de estados transitórios após respawn (4 cenários); integração da derrota ao feedback terminal W1-L1; recuperação física pela KillZone com checkpoint persistido; fallback local quando o schema de campanha não pode ser gravado.
- A reentrada normal com checkpoint persistido já tinha cobertura em `test_campaign_entry.gd`; preservada sem duplicação.
- Inclui quatro planos de unidade e uma única remoção da instalação redundante de `cmdline-tools;latest` no workflow Android.
- Somente testes, planos, continuidade/tracker/status e workflow. Nenhum runtime, cena, física, input, Dash, save schema, IDs, progressão, canon, arte ou asset alterado.
- CI combinado concluído com SUCCESS nos três workflows. A Etapa 14 permanece em andamento até validação física Android e demais critérios do plano.
- CI no HEAD `4408e5efe07f6feb600591d72a66b033af571b1d`: Godot Validation `46046013186`, Documentation Validation `46046013068` e Android Debug Export `46046013082` — **todos SUCCESS**.
- Godot 4.7.2: **115 testes / 2.015 verificações / 0 falhas**; 20/20 cold boots e mutation check do prewarm aprovados.
- Android Debug Export repetiu a suíte: **115 testes / 2.015 verificações / 0 falhas**. APK **28.469.428 bytes**, package ID placeholder `com.example.boltaventura`, SHA-256 `747083ed3f5b1e108c00a0f671abcba8244dbe2821b28eafa99f064ef7e96b35`; assinatura v2/v3 verificada.
- Artifact ID `15222041977`; ZIP SHA-256 `ab31c810e7327478cdedc1bf3ad1d3fc7d318a160f67c7db0bb8682e81e632e9`; [artefato Android Debug](https://github.com/jyanzy19-yml/new-bolt-aventura/actions/runs/46046013082/artifacts/15222041977).
- Evidência L2/CI somente: APK não foi instalado nem executado em Android físico; touch, safe areas/barras, FPS, frame pacing, memória, temperatura e lifecycle OEM continuam sem validação.
