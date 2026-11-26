# BOLT · AVENTURA — Registro de continuidade entre sessões

**Função:** handoff obrigatório para retomar trabalho após limite de contexto, troca de sessão ou interrupção.  
**Fonte de verdade do estado:** repositório e evidências; este arquivo é um índice de retomada, não substitui código, QA, ADRs ou tracker.

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
- **CI:** Godot Run #31 SUCCESS (`f3ab682`): Godot 4.7.2 headless, import e `tests/test_runner.gd` exit 0. 42 métodos de teste identificados em 9 arquivos. Docs Run #119 SUCCESS. Nível L2.
- **Ambiente local:** Godot não instalado; execução local NÃO EXECUTADA. Editor gráfico, APK, Android físico, toque real, barras, FPS e memória NÃO EXECUTADOS.
- **Mutação:** não executada nesta sessão para a nova regressão; não declarar cobertura por mutação adicional.
- **Arquivos de implementação:** `scripts/input/touch_controls.gd`, `tests/unit/test_touch_controls.gd`, `.github/workflows/godot-validation.yml`.
- **Documentação:** tracker, stage-status, COLLABORATION_STATE, este arquivo e `handoffs/HANDOFF_ETAPA_1.md`.
- **Decisões/ADRs:** nenhuma alterada. Valores de movimento, layout touch e “All Jump” continuam provisórios.
- **Próxima ação:** Claude Code assume Etapa 2, revisa HEAD/handoff e continua Gate 1 conforme roadmap; não tratar a sandbox como fase final.
