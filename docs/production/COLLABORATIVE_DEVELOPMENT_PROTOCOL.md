# Protocolo de desenvolvimento colaborativo — Claude Code + ChatGPT

**Projeto:** BOLT · AVENTURA  
**Status:** protocolo operacional proposto para uso no fluxo de produção  
**Escopo:** planejamento, implementação, revisão independente, correção e transferência de trabalho  
**Autoridade:** subordinado a `MASTER_DIRECTIVE.md`, às decisões aprovadas e ao protocolo de qualidade.

## 1. Objetivo

Estabelecer um fluxo coordenado no qual Claude Code seja o principal agente de implementação do jogo e ChatGPT atue como revisor técnico independente, consultor de arquitetura, analista de requisitos e auditor de qualidade quando solicitado.

A colaboração deve reduzir erros acumulados, regressões, contradições e perda de contexto. Ela não garante ausência de defeitos e não substitui testes executados no Godot, emulador ou aparelho Android.

O protocolo complementa — não substitui — os documentos existentes:
- `quality-control-protocol.md`: qualidade técnica, níveis de validação, severidade e evidências.
- `CONTINUITY.md`: retomada entre sessões.
- `implementation-tracker.md`: estado verificável dos sistemas e das 42 fases.
- `roadmap.md`: gates e sequência de produção.
- `change-management.md`: controle de mudanças.

## 2. Papéis e responsabilidades

### 2.1 Usuário — proprietário do produto e autoridade de decisão

O usuário:
- define prioridades e fornece decisões materiais;
- aprova alterações de canon, escopo, experiência, plataforma ou arquitetura quando exigido pela hierarquia do projeto;
- decide sobre conflitos que não possam ser resolvidos pelas fontes aprovadas;
- fornece credenciais, assinatura e acessos que só ele pode fornecer;
- decide se aceita riscos residuais de release quando o processo exigir aprovação explícita.

O usuário não deve precisar aprovar cada alteração técnica pequena que já esteja dentro do escopo autorizado.

### 2.2 Claude Code — principal implementador

Claude Code é responsável por:
- ler as instruções e fontes de verdade do repositório;
- inspecionar o estado real antes de editar;
- planejar e implementar o escopo aprovado;
- criar e manter o projeto Godot, cenas, scripts, dados, UI, conteúdo, testes e configuração Android;
- executar as verificações disponíveis no ambiente;
- corrigir problemas identificados;
- manter commits, documentação, tracker e continuidade atualizados;
- fornecer um pacote de transferência reproduzível para revisão.

Claude permanece responsável pela integração final. Uma revisão do ChatGPT não transfere a responsabilidade de implementação nem comprova que uma correção foi aplicada.

### 2.3 ChatGPT — revisor independente e consultor

Quando o usuário fornecer acesso ou uma cópia atualizada do estado do projeto, ChatGPT poderá:
- revisar requisitos, arquitetura, código, cenas, dados, diffs e documentação;
- procurar bugs lógicos, acoplamento, inconsistências, casos-limite e riscos de regressão;
- avaliar se a implementação corresponde às bíblias, ADRs e critérios de aceite;
- propor testes reproduzíveis e correções específicas;
- revisar resultados de testes, logs, capturas e medições fornecidos;
- preparar relatórios de revisão e recomendações priorizadas.

Limites:
- ChatGPT não deve afirmar que inspecionou arquivos que não recebeu ou não conseguiu acessar.
- Não deve declarar que executou Godot, testes, builds ou testes em dispositivo se isso não ocorreu.
- Não deve tratar uma análise estática como validação em runtime.
- Não deve alterar o repositório ou os mesmos arquivos de trabalho por conta própria durante uma etapa de implementação do Claude, salvo solicitação explícita do usuário para uma alteração específica.
- Suas recomendações não alteram canon, ADRs ou escopo por si só.
- Uma revisão não é aprovação automática de gate ou release.

### 2.4 Agentes especializados do repositório

Os agentes em `.claude/agents/` continuam sendo revisores consultivos especializados, conforme suas instruções. Claude pode acioná-los durante a implementação. Eles não substituem a autoridade do usuário, o QA executável nem a revisão independente solicitada ao ChatGPT.

## 3. Regra de propriedade dos arquivos

**Deve existir um único escritor ativo por conjunto de arquivos durante cada etapa.**

- Durante a implementação, Claude Code é o escritor responsável.
- Durante a revisão independente, ChatGPT trabalha em modo de análise/recomendação; não edita os mesmos arquivos.
- Depois da revisão, Claude aplica as correções aprovadas e executa novamente os testes pertinentes.
- Se o usuário pedir explicitamente que ChatGPT edite um arquivo, essa edição deve ocorrer em uma etapa separada, com estado-base identificado e sem alterações concorrentes do Claude.

Não manter Claude e ChatGPT editando simultaneamente a mesma branch ou os mesmos arquivos. Isso evita sobrescrita, conflitos, perda de alterações e divergência entre cópias.

## 4. Fluxo operacional de cada ciclo

### Etapa A — definição do trabalho

Claude identifica:
1. objetivo e resultado esperado;
2. fontes documentais e decisões aplicáveis;
3. arquivos/sistemas provavelmente afetados;
4. dependências e riscos;
5. critérios de aceite;
6. testes necessários.

Mudanças comuns dentro do escopo autorizado avançam sem pedir autorização. Questões materiais seguem a hierarquia de autoridade do projeto.

### Etapa B — implementação por Claude

Claude:
1. confirma branch, commit e estado do diretório de trabalho;
2. lê os arquivos relevantes e skills mínimas;
3. implementa uma unidade coerente, evitando misturar refatorações não relacionadas;
4. executa testes e verificações proporcionais;
5. revisa o diff completo;
6. atualiza tracker, decisões e continuidade quando aplicável;
7. registra commit ou referência imutável da entrega.

Claude não deve marcar uma funcionalidade como concluída apenas porque criou arquivos ou escreveu código.

### Etapa C — pacote de transferência

Ao solicitar revisão, Claude deve fornecer:
- repositório e branch;
- hash completo do commit a revisar;
- comparação com o commit-base, quando houver;
- lista de arquivos alterados e finalidade de cada alteração;
- requisito e documento-fonte atendidos;
- resumo do comportamento implementado;
- comandos de teste executados e resultados reais;
- testes não executados e motivo;
- logs/erros relevantes;
- limitações do ambiente;
- bugs conhecidos e riscos;
- perguntas específicas que precisam de julgamento técnico.

A revisão deve se referir ao commit exato, não a uma descrição vaga nem a uma cópia possivelmente desatualizada.

### Etapa D — revisão independente por ChatGPT

O usuário disponibiliza o commit/arquivos/diff ou habilita um meio de acesso apropriado. ChatGPT então:
1. confirma o escopo e a referência revisada;
2. verifica os arquivos realmente disponíveis;
3. compara implementação com requisitos e decisões;
4. procura falhas funcionais, arquiteturais, de integração e manutenção;
5. identifica casos-limite e regressões prováveis;
6. avalia a adequação dos testes apresentados;
7. separa fatos observados de hipóteses;
8. entrega achados priorizados e recomendações acionáveis.

A revisão não deve reescrever todo o sistema quando uma correção localizada for suficiente.

### Etapa E — triagem e correção

Claude avalia cada achado:
- **Aceito:** reproduzido ou confirmado; corrigir e testar.
- **Parcialmente aceito:** o risco existe, mas a correção precisa ser adaptada; registrar justificativa.
- **Não reproduzido:** executar passos adicionais ou pedir evidência; não descartar sem análise.
- **Rejeitado:** apresentar justificativa técnica e evidência; registrar quando o achado for material.

Achados S0/S1 do protocolo de qualidade bloqueiam a aprovação do gate afetado até correção ou decisão formal prevista pelo processo. Achados S2 exigem plano e avaliação explícita de risco. S3/S4 podem ser priorizados sem paralisar trabalho independente.

Claude aplica as correções, executa novamente os testes pertinentes e registra o resultado. A resposta do ChatGPT, sozinha, não fecha o achado.

### Etapa F — fechamento e próxima etapa

Claude entrega:
- commit corrigido;
- lista de achados resolvidos e não resolvidos;
- testes reexecutados;
- evidências e nível L0–L5;
- riscos residuais;
- tracker e continuidade atualizados;
- próxima ação executável.

O usuário decide quando uma aprovação humana for exigida. Depois disso, inicia-se o próximo ciclo.

## 5. Quando alternar entre Claude e ChatGPT

Não é obrigatório alternar depois de toda pequena tarefa. A revisão deve ser proporcional ao risco.

| Tipo de trabalho | Responsável principal | Revisão recomendada |
|---|---|---|
| Auditoria inicial e inventário | Claude | ChatGPT revisa lacunas e consistência |
| Arquitetura/fundação Godot | Claude | Revisão independente antes de consolidar contratos importantes |
| Movimento, input e multitouch | Claude | Revisão prioritária + testes práticos |
| Combate, inimigos e chefes | Claude | Revisão de estados, balanceamento, telegraphs e casos-limite |
| Menus, HUD e UX | Claude | Revisão de fluxo, acessibilidade e touch |
| Produção de mundos e fases | Claude | Revisão por lote/mundo, com amostragem e critérios de fase |
| Save, progressão e migração | Claude | Revisão prioritária por risco de perda de progresso |
| Otimização Android | Claude | Revisão de método, medições e regressões |
| Release candidate | Claude prepara | ChatGPT audita evidências; usuário decide aprovação final |

A revisão completa é especialmente recomendada para mudanças de arquitetura, input, física, save/load, progressão, fluxo de cenas, sistemas compartilhados, integração de mundos e preparação de release. Alterações cosméticas isoladas podem usar revisão mais leve.

## 6. Estratégia de produção para BOLT · AVENTURA

A sequência abaixo é uma referência de colaboração, não uma substituição do roadmap oficial:

1. **Gate 0 — auditoria e alinhamento:** Claude inspeciona o repositório e o ambiente; ChatGPT revisa a auditoria, os conflitos e os riscos.
2. **Gate 1 — fundação e vertical slice:** Claude cria e implementa a fundação Godot/Android; ChatGPT revisa arquitetura, contratos e evidências da fatia jogável.
3. **Gate 2 — sistemas centrais:** Claude implementa input, personagem, combate, inimigos-base, UI, save e fluxo; ChatGPT revisa os sistemas de maior risco.
4. **Gate 3 — sete mundos e 42 fases:** Claude produz e integra o conteúdo em lotes; ChatGPT revisa cada mundo ou lote significativo contra as bíblias e os critérios de fase.
5. **Gate 4 — integração e polimento:** Claude integra narrativa, áudio, arte, menus, progressão e acessibilidade; ChatGPT procura inconsistências e regressões.
6. **Gate 5 — QA Android e release candidate:** Claude prepara builds e executa a matriz disponível; ChatGPT audita relatórios e cobertura; o usuário toma decisões de release que lhe cabem.

A campanha continua sendo responsabilidade de implementação do Claude. ChatGPT não deve criar uma implementação paralela que depois precise ser fundida sem planejamento.

## 7. Critérios para uma revisão útil

Todo relatório de revisão deve usar esta estrutura:

| Campo | Conteúdo exigido |
|---|---|
| Referência | Branch, commit e escopo revisado |
| Resultado | Sem achados relevantes / achados encontrados / revisão incompleta |
| Severidade | S0 a S4 conforme o protocolo de qualidade |
| Localização | Arquivo, função/cena e linha ou símbolo quando disponível |
| Evidência | Trecho, fluxo, log ou cenário que sustenta o achado |
| Impacto | O que pode falhar e em quais condições |
| Recomendação | Correção mínima e coerente |
| Teste sugerido | Passos reproduzíveis para confirmar a correção |
| Limitação | O que não foi possível inspecionar ou executar |

Não inventar linhas, logs, resultados, reproduções ou certeza. Se não houver evidência suficiente, classificar como hipótese ou pergunta de investigação.

## 8. Gestão de divergências

- Fontes aprovadas do projeto prevalecem sobre sugestões de qualquer modelo.
- ChatGPT pode discordar de uma decisão técnica, mas deve explicar risco, evidência e alternativa; não pode alterar a decisão unilateralmente.
- Claude pode contestar um achado do ChatGPT com evidência e justificativa.
- Se a divergência afetar canon, escopo, experiência, plataforma ou arquitetura aprovada, o usuário decide.
- Se for uma questão técnica reversível dentro do escopo, Claude pode escolher a solução mais simples e robusta, registrando a justificativa.
- Nenhum modelo deve apresentar uma preferência própria como se fosse decisão do usuário.

## 9. Continuidade entre sessões e transferência de contexto

O estado oficial está no repositório, não na memória presumida de uma conversa.

Ao fim de cada etapa substancial:
- Claude atualiza `docs/production/CONTINUITY.md`;
- Claude atualiza `docs/production/implementation-tracker.md` somente com evidência;
- decisões materiais são registradas em `docs/decisions/`;
- o commit de referência é incluído no pacote de transferência.

Ao retomar, Claude e ChatGPT devem verificar a referência mais recente disponível. Se o repositório mudou depois da revisão, a revisão anterior não deve ser tratada como válida para o novo estado sem comparar os commits.

## 10. Condições para encerrar uma etapa

Uma etapa colaborativa só está pronta para avançar quando:
- os critérios de aceite da tarefa foram atendidos;
- o diff foi revisado pelo implementador;
- os testes aplicáveis foram executados ou suas limitações foram registradas;
- achados bloqueadores foram corrigidos;
- divergências materiais foram resolvidas pelo responsável adequado;
- documentação, tracker e continuidade refletem o estado real;
- existe um commit identificável para a próxima etapa.

A revisão do ChatGPT é uma camada adicional de detecção, não um substituto do QA nem uma garantia de ausência de erros.

## 11. Princípio final

**Claude constrói; ChatGPT examina criticamente; Claude corrige e comprova; o usuário decide as questões que exigem sua autoridade.**

O propósito é aumentar a qualidade e reduzir retrabalho, mantendo uma única implementação, uma fonte de verdade e evidências verificáveis em todas as etapas.
