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
**Evidência:** Docs CI #135 passou para a PR #4. Godot CI #45 passou no commit da PR #3. A PR #4 alterou somente documentação; não executou nova validação Godot. A suíte 42 testes/171 verificações/0 falhas está comprovada na execução anterior Godot CI #36, não deve ser atribuída à Run #45.  
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

- Inspeção GitHub da árvore recursiva, branches, PRs e arquivos: concluída.
- Contagem de skills/agentes/comandos/testes: calculada a partir da árvore da main.
- Revisão estática de workflows, validador documental, runner, testes de input/touch/safe area/SceneFlow, configuração Godot, preset Android e documentos de produção: realizada.
- Godot local/editor gráfico/emulador: NÃO EXECUTADO.
- APK/exportação/instalação Android: NÃO EXECUTADO.
- Dispositivo físico, toque, safe area, FPS, memória e temperatura: NÃO EXECUTADO.

**Conclusão:** a base técnica e os controles de qualidade estão presentes e coerentes em boa parte. O maior risco atual não é uma falha de gameplay confirmada, mas a divergência entre documentos de autoridade e a realidade integrada, especialmente a PR #1 e a regra de Dash. A próxima implementação deve continuar da main existente, sem reiniciar o projeto, enquanto esses conflitos são tratados explicitamente.
