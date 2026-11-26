# Auditoria de polimento integral do repositório — 2026-11-26

**Branch auditada:** `main`  
**HEAD auditado:** `9d5381047817ac9fc949583f6645d24eadd88e8c`  
**Branch desta auditoria:** `chore/repository-polish-audit`  
**Tipo:** inspeção estática de integridade, documentação, governança, CI e estrutura executável.  
**Limite:** não equivale a executar Godot localmente, abrir o editor, exportar APK ou testar em Android físico.

## 1. Resumo executivo

A branch `main` contém um projeto Godot 4.7.2 real e executável em nível de importação/testes headless, além de documentação e ferramentas Claude Code. A árvore consultada contém 328 entradas, 39 skills, 11 agentes consultivos, 6 comandos, 9 arquivos de testes unitários e 30 arquivos Godot executáveis (`.gd`/`.tscn`).

A fundação não é apenas documental, mas o jogo completo ainda não existe: a implementação atual é uma base técnica/protótipo com boot, menu, player, controles, HUD, sandbox e testes. Campanha, combate completo, inimigos, chefes, progressão e save ainda não estão implementados conforme o estado de produção.

**Nenhum defeito de gameplay S0–S2 foi confirmado por esta inspeção estática.** Foram confirmados riscos de governança e inconsistências de documentação que podem induzir o próximo agente a recriar o projeto, aplicar uma especificação não integrada ou alterar mecânicas sem resolver o conflito de escopo.

## 2. Inventário confirmado

| Item | Quantidade/estado | Evidência |
|---|---:|---|
| HEAD da main | `9d5381047817ac9fc949583f6645d24eadd88e8c` | Árvore Git recursiva |
| Arquivos/entradas na árvore | 328 | `git/trees/main?recursive=1` |
| Skills | 39 | `.claude/skills/*/SKILL.md` |
| Agentes consultivos | 11 | `.claude/agents/*.md` |
| Comandos Claude | 6 | `.claude/commands/*.md` |
| Testes unitários | 9 arquivos | `tests/unit/test_*.gd` |
| Arquivos Godot executáveis | 30 | Scripts GDScript e cenas TSCN |
| Engine fixada | Godot 4.7.2 | `.godot-version`, `project.godot` |
| Orientação | Sensor landscape | `project.godot` |
| Renderer | GL Compatibility | `project.godot`; ainda provisório |
| Resolução-base | 960×540 | `project.godot`; ainda provisória |
| Package ID | `com.example.boltaventura` | Placeholder; não é identificador de release |
| APK/instalação Android | Não comprovado | Nenhuma evidência de export ou device test |

## 3. Achados confirmados

### POL-001 — Documentos raiz descrevem incorretamente o estado executável

**Severidade:** S2 (risco de processo/continuidade).  
**Evidência:** `README.md`, `CLAUDE.md`, `AGENTS.md` e `MASTER_DIRECTIVE.md` ainda contêm afirmações de que o repositório é apenas um ecossistema documental ou de que não se deve presumir a existência de `project.godot`. A main contém `project.godot`, `.godot-version`, cenas em `scenes/`, scripts em `scripts/` e testes em `tests/`.  
**Risco:** um agente pode iniciar o projeto do zero, duplicar cenas/sistemas ou desconsiderar código já integrado.  
**Tratamento nesta PR:** registrado para reconciliação; os arquivos raiz são alterados pela PR #1 aberta e não foram modificados nesta branch para evitar conflito concorrente.  
**Ação necessária:** reconciliar os documentos raiz com a realidade atual da main depois de revisar/rebasear a PR #1. Preservar o mandato de criar o jogo completo, mas deixar claro que a fundação Godot já existe e deve ser continuada.

### POL-002 — PR #1 está aberta, não mergeável e baseada em estado anterior

**Severidade:** S2.  
**Evidência:** PR #1 (`docs/master-directive-bolt`) continua OPEN; GitHub reporta `mergeable=false`; sua base é `db88a1608f9a6361c942df2e119000fc5c2ab0e7`, anterior às etapas e integrações posteriores. A PR modifica `README.md`, `CLAUDE.md`, `AGENTS.md`, `docs/README.md` e adiciona a diretiva dividida em 12 partes. Não há reviews registrados.  
**Risco:** mesclar sem reconciliação pode reintroduzir descrições obsoletas e criar conflitos com o trabalho integrado depois.  
**Tratamento:** PR #1 foi preservada intacta; não foi atualizada, fechada ou mesclada.  
**Ação necessária:** rebase/reconciliação controlada da PR #1 contra a main atual, revisão de cada documento raiz e CI completa antes de qualquer merge. Não usar o antigo estado “sem projeto Godot” como estado atual.

### POL-003 — Conflito de escopo sobre Dash

**Severidade:** S2 (decisão de produto/contrato).  
**Evidência:** a implementação atual inclui ação `dash` no Input Map, `Actions.DASH`, estado `DASHING`, suporte em controles touch/testes e o tracker SYS-005/SYS-006 descreve dash. A diretiva proposta na PR #1 declara explicitamente que Dash não deve ser implementado. O arquivo raiz `MASTER_DIRECTIVE.md` ainda inclui dash como possibilidade/requisito condicional.  
**Risco:** Claude pode remover, preservar ou expandir uma mecânica sem uma fonte canônica reconciliada.  
**Tratamento:** nenhum código de movimento foi alterado.  
**Ação necessária:** resolver a precedência entre diretiva antiga, nova diretiva da PR #1 e implementação já existente. Até essa reconciliação, tratar dash como implementação legada/provisória, não ampliar nem remover silenciosamente. O usuário deve confirmar a decisão se os documentos aprovados não resolverem o conflito.

### POL-004 — Handoffs e snapshots precisam apontar para o último merge

**Severidade:** S3.  
**Evidência:** após PR #4, alguns documentos ainda usavam o merge da PR #3 (`4ecaff1...`) como base mais recente e não registravam PR #4.  
**Tratamento:** esta branch atualiza estado de colaboração, status de produção, continuidade e handoff para o HEAD da main após PR #4 (`9d538104...`) e registra esta auditoria.

### POL-005 — Branch principal sem proteção confirmada

**Severidade:** S3 (governança).  
**Evidência:** a listagem GitHub de branches retornou `protected=false` para `main` e demais branches consultadas.  
**Risco:** commits diretos podem contornar revisão e checks.  
**Ação recomendada:** configurar ruleset/branch protection para `main`, exigindo PR e os checks aplicáveis. Não alterado nesta PR porque requer configuração administrativa e decisão do proprietário.

### POL-006 — Validação automatizada e validação física são níveis diferentes

**Severidade:** informativo / risco de release.  
**Evidência:** Docs CI #135 passou para a PR #4. Docs CI #137 passou na primeira versão da auditoria e Docs CI #138 passou no HEAD final da PR #5. Godot CI #45 passou no commit da PR #3. A PR #4 alterou somente documentação; não executou nova validação Godot. A suíte 42 testes/171 verificações/0 falhas está comprovada na execução anterior Godot CI #36, não deve ser atribuída à Run #45.  
**Risco:** confundir import/parse/headless com funcionamento visual, touch, safe area ou performance Android.  
**Tratamento:** limites registrados no status e handoff.  
**Ação necessária:** executar APK debug e matriz física Android antes de declarar a vertical slice validada.

## 4. Revisão dos controles e arquivos técnicos

- `.gitignore` exclui cache Godot, artefatos de exportação, builds e arquivos comuns de assinatura/segredo (`.keystore`, `.jks`, `.p12`, `.pem`, `.key`).
- `export_presets.cfg` não contém caminho de APK nem credenciais de assinatura; package ID continua placeholder.
- `godot-validation.yml` executa importação headless e `tests/test_runner.gd`, verifica erros de script/parse no log e documenta que isso não prova Android físico.
- `docs-validation.yml` valida metadados Claude, unicidade de nomes, agentes read-only, arquivos obrigatórios e links Markdown locais.
- O runner rejeita suíte vazia e zero checks; os testes touch e safe area declaram corretamente que eventos sintéticos/lógica pura não provam comportamento em aparelho.
- `TouchControls`, `SafeAreaMargin` e `SceneFlow` continuam com riscos que exigem testes reais de viewport, ciclo de vida, multitouch e loading Android. Nenhum defeito adicional foi confirmado nesta leitura.

## 5. Itens deliberadamente não alterados

- Nenhum script, cena, física, input, hitbox ou tuning de gameplay.
- Nenhum canon narrativo ou decisão de produto.
- Nenhum package ID definitivo, renderer, resolução ou ABI.
- Nenhum secret, preset de assinatura ou configuração de release.
- PR #1 e branches antigas não foram modificadas nem removidas.
- Nenhum APK ou teste físico foi declarado.

## 6. Estado de validação desta auditoria

- **Integração:** PR #5 MERGED em `f5fbff8de138bfec395f45a7fef1ad57c45aa37c`.
- **Docs CI #140:** SUCCESS no HEAD final da PR #5; job de validação documental concluído sem falhas.

- ****Docs CI #137:** SUCCESS na PR #5; job `Validate project documentation`, incluindo `Validate Claude metadata and local links`, concluído sem falhas.

- Inspeção GitHub da árvore recursiva, branches, PRs e arquivos: concluída.
- Contagem de skills/agentes/comandos/testes: calculada a partir da árvore da main.
- Revisão estática de workflows, validador documental, runner, testes de input/touch/safe area/SceneFlow, configuração Godot, preset Android e documentos de produção: realizada.
- Godot local/editor gráfico/emulador: NÃO EXECUTADO.
- APK/exportação/instalação Android: NÃO EXECUTADO.
- Dispositivo físico, toque, safe area, FPS, memória e temperatura: NÃO EXECUTADO.

**Conclusão:** a base técnica e os controles de qualidade estão presentes e coerentes em boa parte. O maior risco atual não é uma falha de gameplay confirmada, mas a divergência entre documentos de autoridade e a realidade integrada, especialmente a PR #1 e a regra de Dash. A próxima implementação deve continuar da main existente, sem reiniciar o projeto, enquanto esses conflitos são tratados explicitamente.


## 7. Revalidação complementar — 2026-11-26 (após PR #6)

**HEAD consultado:** 75159132a7dc2503df68d8ca1abe57fc7e88019c. O repositório permanece privado e a branch padrão é main. A execução mais recente observada antes desta rodada foi Docs CI #143 (SUCCESS) nesse HEAD. A consulta de workflows mostrou 189 execuções no total.

### 7.1 PR #1 — comparação atual

- Estado: OPEN; mergeable=false; mergeable_state=dirty.
- Base: db88a1608f9a6361c942df2e119000fc5c2ab0e7; head: e6785d588838ae3671aab84da4718066101d495a.
- Comparação com a main verificada: 17 commits exclusivos da PR, 135 commits de atraso; 17 arquivos modificados.
- Conteúdo: quatro documentos raiz (README.md, CLAUDE.md, AGENTS.md, docs/README.md) e 13 arquivos da diretiva dividida em 12 partes/índice. Nenhum arquivo de gameplay/cena/script foi alterado.
- A PR foi preservada sem rebase, fechamento ou merge. As alterações de documentos raiz não devem substituir a versão atual sem reconciliação. O conteúdo da diretiva permanece material candidato a revisão, não fonte canônica automaticamente aprovada.

### 7.2 Estado executável e revisão estática focalizada

A árvore Git confirma project.godot, .godot-version, cenas, scripts, recursos e testes. Foram relidos TouchControls, TouchButton, SafeAreaMargin, SceneFlow, BoltPlayer, ActionBuffer, o runner, testes de touch/safe area, project.godot, .gitignore, preset Android e os dois workflows. Nenhum novo defeito S0–S2 foi confirmado por esta inspeção estática focalizada. Isso não substitui execução local/editor ou testes físicos Android.

### 7.3 Segurança, CI e governança

- .gitignore exclui caches Godot, builds, APK/AAB, arquivos de assinatura e segredos comuns.
- export_presets.cfg contém preset Android de debug/teste, ABI arm64-v8a e package ID placeholder com.example.boltaventura; não contém caminho de APK ou credenciais de assinatura. O package ID não foi alterado.
- Godot CI executa importação headless e runner, e o runner falha com zero testes/checks. Docs CI valida metadados e links locais.
- A API de proteção da branch retornou HTTP 403 para a integração; não foi possível confirmar nem alterar a proteção de main nesta rodada. A auditoria anterior reportou protected=false; o proprietário deve verificar/configurar isso na interface administrativa do GitHub.
- Não foi executado Godot local, editor gráfico, exportação APK, instalação, emulador, aparelho físico, toque, medição de FPS/memória/temperatura.

### 7.4 Decisões mantidas em aberto

O código atual contém Dash (Actions.DASH, estado DASHING, touch e testes), enquanto a PR #1 o exclui. A divergência não foi resolvida por fonte canônica confirmada. Nenhuma mecânica foi alterada; não adicionar, remover ou retunar Dash sem decisão explícita do usuário.


### 7.5 Resultado da reconciliação — PR #7

- PR #7 foi integrada por squash em `b8def7a22feee9573c8e4c46c99ed89cb92967c`. Docs CI #144 (PR) e #145 (push após merge) passaram.
- A correção removeu a instrução falsa de que o repositório seria apenas documental e substituiu a criação do projeto “do zero” por continuidade incremental da fundação Godot existente.
- A PR #1 contém princípios úteis sobre autonomia segura, proteção de saves, performance medida, validação Android e QA; esses temas já se sobrepõem em grande parte a especificações e workflows da main e devem permanecer centralizados nos documentos existentes, sem duplicação automática.
- A PR #1 também acrescenta detalhes de lore/encerramento, sequência de produção, requisitos de inimigos, skins/armas e vertical slice Cybercore. Esses detalhes exigem comparação com as bíblias/ADRs atuais antes de serem promovidos a canon; não foram incorporados automaticamente.
- O README da PR #1 declara que a diretiva foi fornecida pelo usuário em 2026-11-25 e a apresenta como autoridade mais recente. O GitHub confirma a existência do texto e do PR, mas não comprova por si só a proveniência dessa decisão no diálogo do usuário. Por isso, a exclusão de Dash continua aguardando confirmação explícita do usuário, apesar da alegação documental.
- PR #1 permanece OPEN, sem rebase/merge/fechamento. Nenhum código ou mecânica foi alterado.


### 7.6 Snapshot pós-PR #7 — verificação final

- **HEAD atual consultado:** `7afb58b190047157f35c5a0e971d0acee87dd999`. A PR #7 foi integrada por squash em `b8def7a22feee9573c8e4c46c99ed89cb92967c`; Docs CI #145 passou no HEAD atual.
- **PR #1 contra a main atual:** OPEN, `mergeable_state=dirty`, 17 commits exclusivos e 137 commits atrás; 17 arquivos exclusivamente documentais. Quatro documentos raiz já foram corrigidos pela PR #7; a diretiva em 12 partes continua não integrada. Nenhum código de gameplay está no diff.
- **Dash:** PR #1 exclui Dash, enquanto o código/Input Map/controles/testes atuais o implementam. Não existe decisão canônica confirmada no repositório. Preservar a implementação sem ampliar/remover/retunar; solicitar confirmação do usuário antes de promover a exclusão da PR #1.
- **Branch protection:** `GET /branches/main` retornou `protected=false`. A integração GitHub disponível não expõe operação administrativa para ativar branch protection/rulesets; o proprietário deve configurar. Os workflows têm filtros por caminhos, então checks específicos podem ser omitidos em PRs fora desses caminhos; configurar um check agregador sempre executado antes de torná-los obrigatórios.
- **Godot CI:** última execução de engine consultada, run `45809258952`, no commit `4ecaff1d67049155d95bcbb5fc9d1c98187d3767`, SUCCESS. Log confirma Godot 4.7.2, import/parse headless e **42 testes, 171 verificações, 0 falhas**. O erro `SceneFlow: cena inexistente` aparece como cenário negativo esperado no teste `test_missing_scene_is_rejected_without_side_effects`; o teste passou. O código não mudou após esse commit nas integrações documentais #5–#7.
- **Docs CI:** run `45816337658` no HEAD `7afb58b`, SUCCESS; job `Validate project documentation` concluído.
- **Validação não executada:** editor gráfico, exportação APK, instalação, emulador, dispositivo físico, toque real, barras/safe area em hardware, FPS/RAM/temperatura.


### 7.7 Estado após PR #9 — fechamento da auditoria

- **PR #9:** MERGED por squash em `caedfee2f790cc78222b281a5b602110d7229043`. Atualizou cinco documentos de produção, sincronizando a divergência da PR #1, o estado de proteção e as evidências CI. Docs CI run `45817363134` no commit de merge: SUCCESS; check `Validate project documentation` passou.
- **PR #1:** permanece OPEN, não rebaseada, não fechada e não mesclada. Compare realizado após PR #9: 17 commits exclusivos da PR e 138 commits atrás da main, com 17 arquivos exclusivamente documentais. Esse número é uma fotografia temporal; consultar o compare atual antes de qualquer reconciliação.
- **PR #1 — decisão de conteúdo:** os quatro documentos raiz foram substituídos/corrigidos pela PR #7; a diretiva em 12 partes ainda não está integrada. Ela contém requisitos potencialmente úteis, mas também declara ausência do projeto Godot (agora falso) e exclui explicitamente Dash. O restante de suas propostas de lore, skins, inimigos, armas, mundo inicial e sequência de produção deve ser comparado às bíblias/ADRs antes de qualquer promoção a canon.
- **Dash:** manter implementação atual intacta até decisão explícita do usuário. Não mesclar a PR #1 nem aplicar sua exclusão de Dash sem essa decisão.
- **Main:** `protected=false`; nenhuma ferramenta administrativa de escrita de proteção/ruleset está disponível nesta integração. Ação administrativa permanece com o proprietário.
- **Godot CI:** run `45809258952`, commit `4ecaff1d67049155d95bcbb5fc9d1c98187d3767`, SUCCESS; Godot 4.7.2, import/parse headless, 42 testes, 171 verificações, zero falhas. Nenhuma alteração de gameplay ocorreu nas PRs #5–#9.
- **Docs CI:** run `45817363134`, commit `caedfee2f790cc78222b281a5b602110d7229043`, SUCCESS.
- **Limite de validação:** não houve execução no editor gráfico, exportação/instalação APK, emulador ou Android físico; toque real, safe area, FPS, RAM e temperatura seguem sem evidência de dispositivo.
