# Collaboration State — BOLT · AVENTURA

**Status:** ACTIVE — ChatGPT and Claude Code are both authorized development agents.  
**Authority:** latest user instruction and `MASTER_DIRECTIVE.md`.  
**Technology:** clean-start HTML5, CSS3, JavaScript ES Modules, Canvas 2D and Vite.  
**Integration owner:** user.

## Current active assignments — snapshot 2026-11-28

| Task | Primary writer | Reviewer | Branch | PR | Base | Status |
|---|---|---|---|---:|---|---|
| HTML5-01 Runtime kernel | ChatGPT | Claude Code | `agent/chatgpt/stage-01-runtime-kernel` | [#145](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/145) | `main` | CI, docs and CodeQL passed; open |
| HTML5-02 Canvas viewport | ChatGPT | Claude Code | `agent/chatgpt/stage-02-canvas-viewport` | [#146](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/146) | `main` | CI and CodeQL passed; open |
| HTML5-03 Input/multitouch | ChatGPT | Claude Code | `agent/chatgpt/stage-03-input-multitouch` | [#147](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/147) | `main` | CI and CodeQL passed; pointer ownership now clears on blur/disable; open |
| HTML5-03B TouchControls | ChatGPT | Claude Code | `agent/chatgpt/stage-03-touch-controls` | [#157](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/157) | `agent/chatgpt/stage-03-input-multitouch` | Web CI passed; open |
| HTML5-04 Collision kernel | ChatGPT | Claude Code | `agent/chatgpt/stage-04-collision-kernel` | [#148](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/148) | `main` | CI and CodeQL passed; open |
| HTML5-04B PlayerMotor/Dash | ChatGPT | Claude Code | `agent/chatgpt/stage-04-player-motor` | [#151](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/151) | `agent/chatgpt/stage-04-collision-kernel` | Web CI and docs passed; open |
| HTML5-04C Debug renderer | ChatGPT | Claude Code | `agent/chatgpt/stage-04-debug-renderer` | [#154](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/154) | `agent/chatgpt/stage-04-player-motor` | Web CI and docs passed; open |
| HTML5-04D Player scene composition | ChatGPT | Claude Code | `agent/chatgpt/stage-04-player-scene-runtime` | [#158](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/158) | `agent/chatgpt/stage-04-debug-renderer` | CI and docs passed; open |
| HTML5-05 Level schema/camera | ChatGPT | Claude Code | `agent/chatgpt/stage-05-level-camera` | [#149](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/149) | `main` | CI and docs passed; open |
| HTML5-05B LevelRuntime | ChatGPT | Claude Code | `agent/chatgpt/stage-05-level-runtime` | [#152](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/152) | `agent/chatgpt/stage-05-level-camera` | CI and docs passed; open |
| HTML5-05C Geometry adapter | ChatGPT | Claude Code | `agent/chatgpt/stage-05-level-collision-adapter` | [#153](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/153) | `agent/chatgpt/stage-04-collision-kernel` | CI and docs passed; open |
| HTML5-06 Combat core | ChatGPT | Claude Code | `agent/chatgpt/stage-06-combat-core` | [#150](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/150) | `agent/chatgpt/stage-04-collision-kernel` | Web CI passed; open |
| HTML5-06B WeaponController | ChatGPT | Claude Code | `agent/chatgpt/stage-06-weapon-controller` | [#155](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/155) | `agent/chatgpt/stage-06-combat-core` | CI and docs passed; open |
| HTML5-06C CombatRuntime | ChatGPT | Claude Code | `agent/chatgpt/stage-06-combat-runtime` | [#156](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/156) | `agent/chatgpt/stage-06-weapon-controller` | CI and docs passed; open |
| HTML5-09A Android display contract | ChatGPT | Claude Code | `agent/chatgpt/stage-09-android-display-contract` | [#159](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/159) | `main` | CI, docs and CodeQL passed; open |
| HTML5-09B AssetManifest/AssetLoader | ChatGPT | Claude Code | `agent/chatgpt/stage-09-asset-loader` | [#160](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/160) | `main` | CI, docs and CodeQL passed; open |
| HTML5-10A Debug playable slice | ChatGPT | Claude Code | `agent/chatgpt/stage-10-debug-playable-slice` | [#161](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/161) | `main` | Web CI/docs passed; CodeQL in progress; aggregate PR; open |

**Baseline:** `main` HEAD `27c34070a9ee1746076a1ca034833a577858b306`; tree SHA matches original baseline `9c32df4225b4e410340b2254a098167023593625`. All listed PRs are open and unmerged. No implementation branch has been merged automatically. A documentation file was inadvertently created on main by omitting the branch argument, then immediately deleted; the current tree is restored exactly to the original baseline. Continue PR-only changes.

### Active writer boundaries
- ChatGPT owns the runtime/physics/input/level integration work listed above.
- Claude Code is the designated read-only reviewer for these PRs; no Claude review result or implementation delivery is presumed.
- Each branch has isolated paths. A reviewer must not edit the same paths before the primary writer hands off.
- The user remains responsible for merge decisions.

### Next executable work
1. Complete the latest PlayerMotor Web CI run and fix any remaining regression.
2. Review the collision/PlayerMotor contract and integrate the level geometry adapter after both schema and collision dependencies are available.
3. Continue combat integration and create the first playable W1-L1 slice only from approved content.
4. Keep the HTML5 tracker and continuity log synchronized after every substantial delivery.

## Default responsibility map
| Area | Default lead | Notes |
|---|---|---|
| Cross-system architecture/integration | ChatGPT | Claude may implement scoped architecture tasks by assignment |
| Runtime, physics/input contracts | ChatGPT | Claude may implement isolated features with explicit contracts |
| Level/content production | Claude Code | ChatGPT may review or take an explicitly assigned task |
| Enemy/boss behavior | Claude Code | Requires gameplay acceptance tests |
| UI/content systems | Claude Code | Respect mobile UX and asset approval rules |
| Performance/Android integration/CI | ChatGPT | Claude may take bounded implementation tasks |
| QA/regression review | Either, assigned per task | Non-authoring agent reviews read-only |

This table is default routing, not an exclusive capability restriction.

## Binding coordination rules
- Exactly one primary writer per task; reviewer remains read-only until handoff.
- Prefer isolated branches: `agent/claude/<task>` or `agent/chatgpt/<task>`.
- Do not edit the same paths concurrently.
- No force-push, shared-history rewrite or self-merge.
- User chooses agent sequence and approves merges.
- Inspect current Git state and open PRs before assigning work.
- Update this file and `CONTINUITY.md` after substantial work.
- Asset approval remains independent: no final art asset is integrated before approval of that exact version.

## Handoff template
```text
TASK ID:
PRIMARY WRITER:
REVIEWER:
BASE COMMIT:
BRANCH:
OBJECTIVE:
IN SCOPE:
ALLOWED PATHS:
FORBIDDEN / RESERVED PATHS:
DEPENDENCIES:
ACCEPTANCE CRITERIA:
REQUIRED TESTS:
KNOWN RISKS:
DELIVERABLE / PR:
NEXT OWNER:
```

## Historical record
The sections below are retained as historical evidence from the former Godot/GDScript project. Their old assignments, HEAD hashes, 26/32-stage status, PR references and claims that Claude was inactive or ChatGPT was the sole writer are not current instructions. They must not be used as the current runtime baseline. The user's later decision to rebuild from zero in HTML5 and authorize both agents supersedes those historical operational states.

---

## Estado canônico de colaboração — plano de 32 etapas (27/11/2026)

**Main HEAD:** `d90ac2c78e96b32233f8d003ea6673a38079ecb3` (PR #72 e #73 integradas). Docs Validation pós-merge PR #73 `45986435957` SUCCESS.  
**Plano:** `docs/production/32-stage-production-plan.md`, formalizado pela PR #73.

### Responsabilidades autorizadas

**ChatGPT**
- Arquitetura, sistemas centrais, integração, desempenho Android, regressão e QA.
- Criação dos assets visuais do jogo.
- Apresentar cada asset ao usuário e aguardar aprovação explícita antes de integrar/substituir qualquer arte.

**Claude**
- Construção de fases.
- Inimigos e chefes.
- Elementos interativos.
- Interface e conteúdo visual.
- Sistemas independentes de gameplay.

A autorização de Claude não permite contornar o processo de aprovação visual do usuário. Claude pode preparar consumidores, cenas, layout e lógica; assets finais só entram depois de aprovação da versão exata.

### Coordenação obrigatória
- Uma branch/PR por unidade de trabalho; não editar simultaneamente os mesmos arquivos.
- Declarar escopo, arquivos, dependências e contratos afetados.
- CI e revisão de diff antes de merge; nenhum merge presumido.
- ChatGPT integra/revisa alterações que afetem contratos centrais.
- Nenhuma entrega de Claude é presumida sem commit/PR observável.
- O usuário mantém autoridade sobre canon, decisões materiais e aprovação de arte.

### Estado de produção
- Etapas 01–04 do novo plano: concluídas no nível L2 registrado.
- Nova Etapa 29: em andamento, recebe o trabalho de recursos/loading da antiga Etapa 05.
- Novas Etapas 05–09: não iniciadas; pipeline de arte exige aprovação antes da integração.
- Gate 1 em andamento; W1-L1/W1-L2 são blockouts; Android físico pendente.

---

## Snapshot histórico de colaboração — 2026-11-27 (pré-adoção das 32 etapas)

**Main HEAD:** `5e55fa1693d8ecf6d8a1d79bfffa1999824ad1ea`.
**ChatGPT:** responsável por arquitetura, sistemas centrais, integração entre subsistemas, desempenho Android, testes de regressão e gates de qualidade.
**Claude:** autorizado pelo usuário a implementar diretamente, em branches/PRs independentes:
1. Construção de fases;
2. Inimigos e chefes;
3. Elementos interativos;
4. Interface e conteúdo visual;
5. Sistemas independentes de gameplay.

**Coordenação:** não editar simultaneamente os mesmos arquivos. Cada agente deve declarar escopo, arquivos/contratos afetados e dependências antes da implementação; usar branch própria e PR; não fazer merge sem CI e revisão. ChatGPT atua como integrador/revisor dos contratos centrais. A autorização não significa que Claude já tenha entregue qualquer item.
**Etapa 05:** PR #69 (SceneFlow cancelamento lógico) e PR #70 (PerformanceProbe) integradas. Política de ciclo de vida de recursos em revisão nesta branch.
**Restrições de continuidade:** preservar física, Dash, InputMap, multitouch, save schema v1, IDs persistentes, canon narrativo, Android landscape e política de barras/safe area. Não promover blockouts a fases finais por documentação apenas.

---

# Registro histórico de colaboração e desenvolvimento — BOLT · AVENTURA

## Snapshot operacional vigente — 2026-11-27

Main HEAD: `4544efc7082a17e7824ccf46c524db07486e3dc9` — PR #67 integrada por squash.
Hardening integrado: PR #59 SaveSystem; PR #60 lifecycle Android/input; PR #63 Boot/cold-start/threaded loading; PR #65 CampaignProgress sem IDs duplicados; PR #66 integração real SceneFlow→LoadingOverlay; PR #67 validação de domínio CampaignProgress.
Última entrega de gameplay: PR #34 — W1-L2 em blockout; não houve nova fase de campanha nesta unidade.
Escritor ativo: ChatGPT como único escritor; Claude permanece inativo para escrita concorrente.
Etapas: 01–04 concluídas; Etapa 05 em desenvolvimento; Gate 1 em andamento. W1-L1/W1-L2 permanecem blockouts.
CI pós-merge main: Docs 45920441923 SUCCESS; Godot 45920441898 SUCCESS; Android Export 45920441894 SUCCESS.
Godot 4.7.2: 102 testes/1.891 verificações/0 falhas; 20/20 cold boots e mutation test aprovados.
APK debug: 28.465.153 bytes, assinatura v2/v3 verificada, package ID placeholder `com.example.boltaventura`, SHA-256 `cf6c96a48012a27d61db83354c777034ffe18c02fee8c2dd8c20e02acc1f0205`; artifact ID 15164521585.
PRs abertas: #57 polimento visual; #58/#61/#62 branches antigas/sobrepostas à PR #63 e não devem ser integradas automaticamente; #1 PR documental antiga e divergente.
Limites: APK debug não foi instalado. Touch físico, safe area/barras, lifecycle OEM, FPS, memória, temperatura e sessão prolongada permanecem sem validação em dispositivo.
Próxima unidade: Etapa 05 — cancelamento de carregamento, preload, descarregamento seletivo e medições de recursos. Gate 1 permanece independente e depende de validação Android física.


## Snapshot operacional vigente — 2026-11-26

- **Main HEAD:** `6f8e9b8fbaaab9c44247050e5f86e4442bd2622f` (PR #52 integrada; mapa arquitetural revisado e sincronizado).
- **Última correção de gameplay:** PR #47, `TimedEnergyGate.initial_active=false`; CI pós-merge Godot 88 testes/553 verificações/0 falhas, Docs SUCCESS e Android Debug Export SUCCESS.
- **Último componente de plataforma:** PR #46, `OneWayPlatform`; CI pós-merge Godot 87 testes/548 verificações/0 falhas, Docs e Android Export SUCCESS.
- **Última entrega de conteúdo:** PR #34, W1-L2 em blockout e progressão W1-L1→W1-L2.
- **Escritor ativo:** ChatGPT como único escritor, por decisão explícita do usuário; Claude permanece inativo para escrita concorrente.
- **Plano operacional:** 26 etapas em `docs/production/stage-status.md`; matriz integrada em `docs/production/26-stage-traceability-matrix.md`; registro GAP-001…GAP-022 integrado em `docs/production/requirements-gap-register.md`.
- **Etapas atuais:** Etapas 01–03 CONCLUÍDAS; Etapa 04 EM DESENVOLVIMENTO (hardening dos sistemas centrais); Gate 1 continua em andamento. W1-L1 e W1-L2 são blockouts.
- **APK pós-merge PR #47:** artifact `bolt-aventura-android-debug-2636226c4027625649e66c51ff64d7e2e56168a6`, 28.461.057 bytes, SHA-256 `c3ca03958eecf120f1a9f5f1e4fae3851fb7560bca303c8eb5a930f987b58123`, assinatura v2/v3 válida; package ID `com.example.boltaventura` é placeholder; APK não instalado em aparelho.
- **PR #1:** permanece separada e não deve ser integrada/rebaseada automaticamente.
- **Dash:** decisão aprovada e vigente: deve permanecer; ver `docs/production/ADR-001-DASH.md`.
- **Próxima unidade:** auditar Boot, SceneFlow, SaveSystem, CampaignProgress e LoadingOverlay; corrigir edge cases confirmados e adicionar regressões.


**Fonte única para o próximo turno.** Antes de editar, confirme este arquivo contra o HEAD, commits, branches e PRs reais do GitHub.

## Histórico — revisão anterior à sequência PR #38/#39

O snapshot operacional vigente está no topo deste arquivo. As seções abaixo preservam registros históricos de etapas anteriores; não substituem o HEAD, escritor ou estado de 26 etapas atuais.

- **Etapa 0 — Claude Code: ACCEPTED.** Fundação Godot 4.7.2 e protótipo técnico provisório aceitos; hardening integrado pela PR #3.
- **Etapa 1 — ChatGPT: HANDOFF_READY.** Correção de reatribuição de ponteiro em `TouchControls`, regressão e execução da suíte no CI; entrega original `f3ab682`.
- **PRs #2–#13: MERGED.** PR #7 reconciliou documentos raiz; PRs #8–#10 sincronizaram auditoria e continuidade; PR #11 concluiu a auditoria documental e registrou o ADR-001; PR #12 sincronizou o handoff; PR #13 implementou checkpoint/respawn local na sandbox e foi integrada por squash em `09317a2`. PR #13 é a primeira entrega de gameplay desta sequência de PRs.
- **Escritor ativo:** ChatGPT como único desenvolvedor, por decisão explícita do usuário em 2026-11-26. Claude Code está inativo no fluxo de escrita.
- **Projeto executável:** Godot 4.7.2, GDScript, Android em paisagem. A base contém boot/menu, SceneFlow, player, touch/multitouch, HUD, sandbox e testes; não é a campanha completa.
- **Validação máxima comprovada:** L2 (Godot headless/CI). Não há comprovação de APK exportado/instalado, teste visual, touch físico, safe area real ou desempenho em Android.
- **PR #1:** continua OPEN e não mergeável (`mergeable_state=dirty`), com 17 commits exclusivos; a comparação atual de 2026-11-26 após PR #10 indica 139 commits de atraso. A contagem é volátil: consultar o compare atual antes de rebasear. Modifica 17 arquivos: quatro documentos de raiz e a diretiva dividida em 12 partes/índice. Não contém implementação de gameplay. Não mesclar automaticamente.
- **Dash:** decisão explícita do usuário em 2026-11-26: DEVE PERMANECER no jogo. Preservar implementação, Input Map, controles e testes. A exclusão na diretiva não integrada da PR #1 está superada; ver `ADR-001-DASH.md`. Não retunar ou redesenhar sem escopo próprio.
- **Governança da main:** o endpoint de branches confirmou `protected=false` para `main`. A integração não disponibiliza operação administrativa para habilitar proteção/ruleset; o proprietário deve configurar as regras manualmente. Não presumir checks obrigatórios antes de resolver os filtros por caminhos dos workflows.
- **Escritor desta rodada:** ChatGPT, único escritor ativo conforme a diretriz vigente do usuário; PR #34 integrada à main. Criar uma nova branch para a próxima unidade após confirmar o estado pós-merge.

## Estado por etapa — protocolo legado 0–3

**Nota vigente:** este quadro preserva o histórico do antigo fluxo de handoff. A sequência operacional atual é o plano de 26 etapas em `stage-status.md`; ChatGPT permanece como único escritor ativo. Não existe handoff pendente para Claude.

| Etapa | Responsável | Estado | Evidência/entrega | Próximo responsável |
|---|---|---|---|---|
| 0 | Claude Code | ACCEPTED | Fundação e protótipo provisório; hardening PR #3 integrado | ChatGPT |
| 1 | ChatGPT | HANDOFF_READY (histórico) | `f3ab682`: correção multitouch, regressão e CI | ChatGPT |
| 2 | ChatGPT | IN_PROGRESS | PR #34 integrada (`c10ca69`); rota W1-L1→W1-L2, retomada e blockout W1-L2. CI Godot pré/pós-merge 69 testes/439 verificações/0 falhas; Docs CI SUCCESS | ChatGPT |
| 3 | ChatGPT | Aguardando | Próxima unidade após revisão/validação da Etapa 2 | ChatGPT |

## Protocolo de início de turno

1. Confirmar agente, etapa, branch, HEAD, PRs e alterações locais.
2. Ler `MASTER_DIRECTIVE.md`, `CLAUDE.md`, `AGENTS.md`, este arquivo e o protocolo colaborativo.
3. Ler handoff da etapa anterior, roadmap, tracker, stage status, continuidade, Definition of Done, ADRs e especificações pertinentes.
4. Comparar código/cenas reais com o handoff; não confiar apenas em resumos.
5. Separar bugs confirmados, hipóteses e riscos que dependem de Android físico.
6. Corrigir defeitos confirmados relevantes antes de ampliar escopo; não reescrever sistemas funcionais por preferência.
7. Implementar a etapa atribuída, testar, revisar diff e registrar limitações.
8. Atualizar tracker, status, continuidade, histórico e handoff com commit real.
9. O próximo agente só assume após integração e aceite do handoff.

## Máquina de estados

- **PENDING:** atribuído, ainda não iniciado.
- **IN_PROGRESS:** responsável confirmou início e commit-base.
- **HANDOFF_READY:** implementação commitada, testes e transferência registrados.
- **ACCEPTED:** próximo responsável inspecionou a entrega e aceitou a base.
- **BLOCKED:** bloqueio real registrado com evidência, responsável e tarefas independentes permitidas.

Não avançar etapa só porque uma sessão terminou. Não marcar ACCEPTED por autodeclaração do implementador.

## Regras de sincronização

1. `main` é a fonte oficial compartilhada.
2. Um único escritor por vez; não trabalhar em paralelo em arquivos de gameplay.
3. Branch/PR é preferível para mudanças substanciais. Registrar branch, PR, checks e merge commit.
4. Nunca force push, sobrescreva commits posteriores ou integre PR #1 sem revisão independente.
5. Não declarar escrita, teste ou merge sem confirmação do GitHub/runner.
6. O usuário aciona manualmente o próximo agente; não existe transferência automática entre sessões.
7. Agentes consultivos são read-only e não substituem o responsável pela etapa.

## Fontes obrigatórias

- [Protocolo colaborativo](COLLABORATIVE_DEVELOPMENT_PROTOCOL.md)
- [Configuração de acesso](AGENT_ACCESS_SETUP.md)
- [Checklist Etapa 0](ETAPA_0_CLAUDE_CHECKLIST.md)
- [Handoff Etapa 0](handoffs/HANDOFF_ETAPA_0.md)
- [Handoff Etapa 1](handoffs/HANDOFF_ETAPA_1.md)
- [Handoff Etapa 2 — Claude](handoffs/HANDOFF_ETAPA_2_CLAUDE.md)
- [Roadmap](roadmap.md)
- [Estado de produção](stage-status.md)
- [Rastreador](implementation-tracker.md)
- [Continuidade](CONTINUITY.md)

## Atualização pós-PR #11 — 2026-11-26

- PR #11 foi integrada por squash; merge commit `6f97ffc97219bb541e9f36a1c140331c2c621403`.
- Docs CI run #160 (ID `45825228812`) SUCCESS no HEAD da PR #11 `7412e49b27bf135fcaa566bcfce458d19de39cec`; job `Validate project documentation` e todas as etapas concluídos.
- Esta PR curta atualiza os ponteiros de HEAD, o estado da colaboração e o handoff para remover a espera pela PR #11. Claude assume a Etapa 2 após a integração desta sincronização.

## Histórico resumido

- **Etapa 0:** Claude criou a fundação e antecipou movimento, touch, HUD e sandbox a pedido do usuário. A Etapa 1 aceitou a ampliação como provisória.
- **Etapa 1:** ChatGPT corrigiu reatribuição de ponteiro, adicionou regressão e fez CI executar a suíte.
- **PR #2:** melhorias de skills, agentes, validação documental e CI integradas em 2026-11-26.
- **PR #3:** hardening da fundação e registros de governança integrados em 2026-11-26.
- **Etapa 2:** próximo turno de implementação de Claude Code; auditar HEAD e handoff antes de editar.
- **PR #4:** handoff da Etapa 2 integrado em 2026-11-26.
- **PR #5:** auditoria integral e sincronização de continuidade integradas em 2026-11-26.


## Mudança de responsabilidade — 2026-11-26

O usuário autorizou ChatGPT a assumir sozinho todas as etapas de desenvolvimento do BOLT · AVENTURA, sem depender do Claude Code. Esta decisão substitui o fluxo alternado descrito em registros históricos. ChatGPT é o único escritor ativo; manter uma branch/PR por unidade, revisar os diffs, executar CI e integrar somente após evidência. Claude não deve iniciar trabalho concorrente. Estado atual: Etapa 2 em andamento na branch `feat/checkpoint-respawn-system`, base `8c502efaee16a47a31303c77d0efbbd4c847a5e8`.


## Estado pós-PR #13 — 2026-11-26

- `main` HEAD: `09317a2c1b7c1113e7ff2f142a82b495998f7578`.
- PR #13 MERGED: checkpoint reutilizável e respawn local da sandbox. Não implementa persistência de campanha.
- Responsável exclusivo pelas próximas etapas: ChatGPT, conforme decisão explícita do usuário; Claude Code permanece inativo no fluxo de escrita.
- Godot CI #50 (`45841890027`) SUCCESS: Godot 4.7.2, 43 testes, 179 verificações, 0 falhas. Docs CI #167 (`45841889890`) SUCCESS.
- Próximo trabalho: continuar a vertical slice/sistemas centrais sobre a base existente, em branch própria e com testes. Não declarar validação Android sem APK/dispositivo.


## Sessão atual — entrada da campanha

- Base confirmada: `main` em `d6301e887c6c3a54ab532fcc2f75cb983c3e9840`.
- Branch integrada: `feat/campaign-opening-tutorial` → PR #15 → `main` em `783c1d2587ebea39d645a641417e663e561ea710`.
- Implementação: storyboard funcional de abertura, tutorial jogável guiado por robô mensageiro provisório e blockout W1-L1 Cybercore.
- Fluxo: menu → abertura → tutorial → W1-L1. Sandbox permanece ferramenta de desenvolvimento, não fase da campanha.
- Responsável único: ChatGPT; Claude permanece inativo no fluxo de escrita.
- Godot CI #56 e Docs CI #175 passaram; CI pós-merge #57/#176 está em execução. Nenhuma validação Android física foi realizada.


## Sessão atual — combate básico

- Base: `main` após PR #16, commit `2b81211e56677a7f4ee1da97e6d1c4d604e87d77`.
- Branch integrada: `feat/chrono-pistol-combat-core` → PR #17 → `main` em `33fe452d0a6aad2fc87ea19da789dfde9999c93a`.
- Entrega em desenvolvimento: `BoltHealth`, `BoltCombat`, `ChronoProjectile`, alvo estático de treinamento, botão touch TIRO e lição de ataque no tutorial.
- Limite de escopo: alvo não é inimigo de campanha; parâmetros da Pistola Crono são provisórios; outras armas, seleção, IA e dano ao jogador não implementados.
- ChatGPT permanece único escritor; Godot CI #61 e Docs CI #182 passaram. CI pós-merge #62/#183 em execução.


---

## Atualização operacional — plano de 26 etapas e PR #36 — 2026-11-26

- Último merge confirmado: PR #36, squash `afea046b6a481d48299641c9d8e529f6288d5256`.
- CI pós-merge main: Godot run `45877649854` SUCCESS; Docs run `45877649923` SUCCESS.
- ChatGPT continua como único escritor ativo; Claude permanece inativo para escrita concorrente.
- A diretriz operacional de 26 etapas organiza a sequência do trabalho e não substitui MASTER_DIRECTIVE, canon, ADRs ou especificações do repositório.
- O baseline de 26 etapas está em `docs/production/stage-status.md`; nenhuma etapa foi marcada como CONCLUÍDA. Etapa 01 e Etapa 02 permanecem EM ANÁLISE; as demais refletem implementação parcial ou ausência de sistemas.
- Unidade ativa: branch `test/health-pickup-physical-contact`, baseada no merge da PR #36. Objetivo: validar a coleta do item por contato físico real e fazer CI detectar erros específicos de mutação de estado físico.
- Próxima ação: aguardar/revisar CI da branch/PR e atualizar stage-status, tracker e continuidade com resultados efetivos.


---

## Atualização operacional — PR #37 integrada e pipeline Android — 2026-11-26

- Main HEAD: `39b6db8298542c5057c06f509b20d250a888e289`.
- PR #37 integrada por squash; Godot CI pré/pós-merge e Docs CI pré/pós-merge SUCCESS.
- Precisão da cobertura: o fluxo de integração `test_campaign_entry.gd` já exercitava coleta física em W1-L1; PR #37 adiciona teste físico isolado de `BoltHealthPickup` e filtro de log para erro de mutação física bloqueada.
- Diretriz operacional das 26 etapas permanece subordinada ao prompt mestre e aos documentos canônicos.
- Branch ativa: `ci/android-debug-export`.
- Objetivo: exportar APK Android debug via preset existente, Godot 4.7.2 e templates pareados; não é release e não valida dispositivo.
- Package ID `com.example.boltaventura` permanece placeholder. Nenhuma chave/credencial de release foi criada.
- Próxima ação: validar a pipeline na PR e só registrar exportação após confirmar artifact, assinatura, package ID e hash.


## Unidade ativa — hardening do SaveSystem (2026-11-26)

- ChatGPT continua como único escritor ativo; Claude permanece inativo para escrita concorrente.
- Branch atual: `fix/save-system-temp-recovery-2026-11-26`, criada sobre `main` `54fd48e5f49fba877740265aafa0d8f649c2b1e9`.
- Escopo: recuperar `.tmp` completo após interrupção e impedir sobrescrita/rotação/fallback destrutivos diante de formato futuro não suportado; manter `CampaignProgress` compatível com os novos estados de recuperação sem mascarar erros de domínio.
- PR #57 e PR #58 permanecem abertas e não integradas; esta unidade não altera suas branches nem `main`.
- PR #59 aberta e revisada; Godot 95 testes/652 verificações/0 falhas, Docs SUCCESS e Android Debug Export SUCCESS (run `45913709027`). APK debug exportado e verificado; não instalado em aparelho. Não integrar automaticamente. Próxima unidade: concluir auditoria de Boot, SceneFlow e LoadingOverlay na Etapa 04.
