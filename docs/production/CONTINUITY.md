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

Na ausência de uma implementação Godot real:
1. Confirmar o estado atual do branch e se project.godot passou a existir.
2. Auditar ambiente, versão Godot 4.x estável compatível, export templates, renderer e caminho de export Android.
3. Registrar a versão exata e as limitações do ambiente.
4. Criar o projeto Godot real e a fundação Android conforme a diretiva from-zero.
5. Criar uma cena inicial que abra no editor e em execução; validar parse/importação.
6. Implementar a vertical slice do BOLT com input touch real e fluxo de save/load, sem substituir o produto por demo genérica.
7. Atualizar tracker e stage status com evidências e prosseguir pelos gates.

Se o projeto Godot já existir ao retomar, não recriar. Inspecionar e continuar a partir do estado executável.

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
