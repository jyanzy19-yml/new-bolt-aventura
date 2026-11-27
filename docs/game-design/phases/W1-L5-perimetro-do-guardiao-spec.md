# BOLT · AVENTURA — Especificação de design de fase W1-L5

**ID persistente:** `W1-L5`  
**Mundo:** W1 — Cybercore  
**Rótulo de produção:** Perímetro do Guardião  
**Versão do documento:** 0.1  
**Estado:** especificação de pré-produção; proposta derivada do blueprint, não aprovada como conteúdo final/canon  
**Data:** 27/11/2026

> Este documento detalha a ficha W1-L5 do blueprint expandido. Não declara a fase implementada, não cria lore adicional e não autoriza arte final, novas mecânicas, alterações de física ou integração de assets.

---

## 1. Autoridade e limites

### 1.1 Fontes normativas

1. `docs/game-design/02-world-bible.md`: identidade oficial de Cybercore, fragmento Origem, Guardião Tecnológico e estrutura de seis fases.
2. `docs/game-design/EXPANDED-42-LEVEL-CAMPAIGN-BLUEPRINT.md`: função, percurso, mecânica, narrativa, opcional e gate específicos de W1-L5.
3. `docs/game-design/05-level-design-standard.md`: blueprint de fase, ritmo, legibilidade, desafio justo e QA.
4. `docs/game-design/06-ui-ux.md`: orientação paisagem, touch-first, safe areas e acessibilidade.
5. Contratos existentes de movimento, Dash, inimigos, plataformas, checkpoints, energia e carregamento threaded no projeto.

O blueprint classifica os 42 títulos e fichas como propostas de produção. Portanto, “Perímetro do Guardião” é um rótulo de trabalho e não um nome narrativo definitivo.

### 1.2 Escopo desta unidade

- Especificar a função de W1-L5 como preparação do clímax local W1-L6.
- Organizar o percurso em segmentos que reutilizam regras já ensinadas.
- Definir a composição de encontros, checkpoints, riscos, recuperação e rota opcional.
- Definir critérios verificáveis para blockout e revisão.

### 1.3 Fora de escopo

- Construção da cena Godot ou integração na campanha.
- Implementação de novos inimigos, poderes, controles, hazards ou sistemas.
- Alterações a `BoltTuning`, física, Dash, InputMap, multitouch ou schema de save.
- Definição de padrões, fases ou hitboxes do Guardião Tecnológico; isso pertence a W1-L6.
- Diálogos, nomes próprios, NPCs, explicações adicionais sobre o Núcleo ou novas revelações do Arquiteto.
- Arte final, spritesheets, animações, música, efeitos ou assets não aprovados.

---

## 2. Função no arco de Cybercore

W1-L5 é a quinta fase de progressão/exploração do primeiro mundo. Sua função é consolidar domínio do movimento, combate básico e leitura de hazards antes da sexta fase, sem antecipar o confronto.

O jogador deve terminar a fase compreendendo que:
- a infraestrutura de Cybercore conduz a uma região protegida;
- existe um guardião associado ao fragmento Origem;
- as regras necessárias para atravessar o perímetro já foram ensinadas;
- W1-L6 é o próximo clímax, não uma continuação de tutorial.

A fase não deve explicar a origem completa do Grande Colapso, revelar a história integral do Núcleo ou resolver o mistério de NEXO.

---

## 3. Objetivos

### 3.1 Objetivo de gameplay

Atravessar uma rota industrial mais extensa, combinando plataformas móveis, um encontro de combate e uma janela ambiental de energia, usando somente sistemas já apresentados nas fases anteriores.

### 3.2 Objetivo narrativo

Apresentar sinais visuais e ambientais de que o Guardião Tecnológico protege o fragmento Origem. A informação deve ser comunicada por composição, escala e elementos de cenário, sem exposição textual longa.

### 3.3 Objetivo de aprendizagem

Consolidar a sequência:

1. observar o ciclo ou o movimento antes de agir;
2. escolher posicionamento seguro;
3. atravessar a seção de plataforma;
4. resolver o encontro com as ferramentas já disponíveis;
5. combinar as regras em uma seção final sem introduzir novo comando.

A fase deve avaliar domínio, não ensinar uma nova habilidade obrigatória.

---

## 4. Estrutura espacial proposta

### 4.1 Macrofluxo

`Entrada segura → leitura do perímetro → travessia industrial → encontro controlado → checkpoint pré-clímax → janela de energia → aproximação visual da região do guardião → saída para W1-L6`

O percurso principal deve ser predominantemente horizontal, com variações verticais curtas e legíveis. A topologia pode usar plataformas em níveis diferentes, mas não deve depender de uma sequência longa de saltos de precisão.

### 4.2 Segmento A — Entrada e orientação

**Função:** estabelecer o objetivo espacial e dar ao jogador tempo para observar.

- Área inicial segura, sem dano inevitável ou inimigo surgindo fora da tela.
- A saída da fase deve ser sugerida por arquitetura, luz ou continuidade de cenário.
- Um elemento visual do perímetro deve indicar que a infraestrutura adiante está protegida.
- Nenhum texto longo ou cutscene obrigatória deve interromper o controle.

**Critério:** em poucos segundos de observação, o jogador deve distinguir piso seguro, plataformas, rota principal e direção de progressão.

### 4.3 Segmento B — Travessia de plataformas móveis

**Função:** reforçar leitura de movimento e temporização.

- Reutilizar o contrato existente de plataforma móvel; não criar um novo tipo de plataforma.
- Preferir movimento lento e previsível, com extremos e trajetória legíveis.
- Incluir uma área segura de observação antes da primeira travessia.
- Evitar que uma plataforma móvel seja ocultada por foreground, efeitos ou HUD.
- Falha deve permitir recuperação sem reiniciar uma sequência extensa.

**Critério:** a seção deve ser concluível com movimento e salto já ensinados; Dash pode facilitar uma rota opcional, mas não pode ser requisito da rota principal.

### 4.4 Segmento C — Encontro de combate

**Função:** combinar posicionamento com um encontro familiar.

- Reutilizar somente arquétipos e contratos de inimigo já aprovados e disponíveis na branch integrada.
- A arena deve manter espaço suficiente para observar o inimigo e continuar se movimentando.
- Projéteis, partículas e feedback de dano não podem ocultar bordas, plataformas ou telegraphs.
- Não introduzir um novo padrão de ataque obrigatório nesta fase.
- O jogador deve poder recuperar-se de um erro sem ficar preso entre inimigo e geometria.

**Critério:** combate e plataforma devem permanecer legíveis em tela de celular e com controles touch.

### 4.5 Segmento D — Checkpoint pré-clímax

**Função:** reduzir repetição antes da combinação final.

- Posicionar checkpoint após a seção de aprendizagem e antes da janela ambiental de energia/trecho final.
- Usar o sistema existente de checkpoint e persistência.
- O feedback de ativação deve ser inequívoco.
- Respawn deve restaurar o estado da fase de forma determinística, sem duplicar recompensas ou manter inimigos em estado inválido.

**Critério:** após morrer, o jogador retorna a uma área segura antes do desafio final e não perde progresso já persistido.

### 4.6 Segmento E — Janela de energia e combinação final

**Função:** testar observação e temporização sem criar uma regra nova.

- Reutilizar o comportamento de energia cíclica já apresentado em W1-L2 ou a gramática de energia efetivamente aprovada em W1-L4, após auditoria das respectivas implementações integradas.
- A janela deve possuir indicação visual antecipada e estado ativo/inativo distinguível por mais de cor.
- Atravessar durante a janela adequada não deve exigir frame-perfect input.
- Plataformas móveis, encontro e janela de energia devem ser distribuídos em subtrechos, não empilhados todos no mesmo instante.
- Não permitir que o jogador seja atingido por um hazard fora de câmera sem telegraph.

**Critério:** o jogador consegue observar ao menos um ciclo completo em segurança antes de ser solicitado a atravessar.

### 4.7 Segmento F — Aproximação e saída

**Função:** preparar o clímax sem iniciar o combate do chefe.

- Mostrar escala ou presença do perímetro protegido por composição de cenário.
- Sugerir visualmente que a região seguinte contém o guardião do fragmento Origem.
- Não iniciar uma luta, cutscene extensa ou transição de chefe nesta fase.
- A saída deve ser inequívoca e conduzir ao fluxo de campanha para W1-L6, conforme a política de progressão já aprovada.

**Critério:** o jogador entende que concluiu a preparação e que o confronto principal pertence à próxima fase.

---

## 5. Rota opcional — Observatório lateral

O blueprint prevê um observatório lateral que mostra Cybercore em escala maior.

Requisitos:
- A entrada deve ser visível o bastante para recompensar observação, sem parecer parte obrigatória da rota principal.
- O acesso pode exigir domínio de movimento já ensinado, incluindo Dash, mas não pode ser necessário para concluir a fase.
- A recompensa primária é contextual/visual; não inventar item persistente, estatística, moeda ou nova habilidade.
- O desvio deve retornar à rota principal sem softlock.
- A vista deve ampliar a leitura do mundo destruído, sem introduzir novos fatos narrativos não aprovados.

O conteúdo exato do observatório permanece a definir em revisão de level design e aprovação visual.

---

## 6. Ritmo e densidade

A fase deve alternar:
- observação e exploração;
- travessia de movimento;
- encontro de combate;
- breve descanso após o checkpoint;
- desafio combinado;
- recompensa visual de aproximação.

Evitar:
- combate contínuo sem descanso;
- múltiplas regras ambientais novas;
- sequência longa de plataformas móveis sem ponto seguro;
- hazards simultâneos que disputem a atenção;
- repetição excessiva do mesmo obstáculo;
- texto narrativo que interrompa o controle.

A duração-alvo deve ser definida por playtest, não estimada como requisito rígido nesta especificação.

---

## 7. Contratos técnicos a preservar

| Sistema | Regra para W1-L5 |
|---|---|
| Movimento e salto | Consumir os contratos existentes; sem retuning |
| Dash | Permanecer habilitado; rota principal não depende dele |
| InputMap e multitouch | Nenhuma alteração; ações simultâneas continuam suportadas |
| Plataformas móveis | Reutilizar cena/script existente e seus limites declarados |
| Inimigos | Usar apenas inimigos disponíveis e aprovados; dano pelo contrato existente |
| Energia | Reutilizar sistema existente após inspeção de W1-L2/W1-L4 integradas |
| Checkpoint | Reutilizar persistência existente; sem novo schema |
| Progressão | ID `W1-L5`; conclusão libera W1-L6 pela regra sequencial aprovada |
| Carregamento | Entrada/saída via SceneFlow threaded |
| Safe areas | Respeitar ADR-0003 e áreas tocáveis em paisagem |

Nenhuma dependência deve ser considerada disponível apenas porque existe numa PR aberta. Antes de iniciar a cena, confirmar que W1-L3 e W1-L4 foram integradas na base de trabalho e revisar seus contratos reais.

---

## 8. Regras de legibilidade e touch

- Rota principal visualmente dominante.
- Plataformas, foreground e fundo claramente separados.
- Perigos com forma, movimento ou sinal redundante; não depender somente de cor.
- Telegraphs visíveis antes do início do efeito.
- Espaço de pouso identificável antes do salto.
- Nenhum elemento essencial sob recortes ou regiões de gesto do Android.
- Alvos interativos com dimensões compatíveis com o padrão touch do projeto.
- Sem dependência de precisão incompatível com o controle móvel.
- Acessibilidade e safe area devem ser validadas em aparelho físico; captura Xvfb não comprova isso.

---

## 9. Plano de blockout

### Passo 1 — Auditoria de dependências
- Confirmar a integração de W1-L3 e W1-L4.
- Ler os scripts e cenas efetivamente integrados.
- Registrar os sistemas reutilizáveis e suas limitações.
- Não copiar código de branches abertas para uma nova cena sem reconciliação.

### Passo 2 — Geometria principal
- Construir somente a rota principal com blocos temporários.
- Definir entrada, saída, segmentos e checkpoint.
- Validar que o percurso não contém softlock.
- Usar os contratos atuais de movimento sem alteração de tuning.

### Passo 3 — Plataformas e energia
- Inserir instâncias dos sistemas existentes.
- Verificar limites, temporização, colisões e retorno após falha.
- Separar os desafios para que o jogador aprenda cada leitura.

### Passo 4 — Encontro
- Inserir um encontro familiar e controlado.
- Validar espaço de combate e recuperação.
- Não introduzir inimigo novo sem proposta separada.

### Passo 5 — Rota opcional
- Adicionar o observatório como desvio não obrigatório.
- Confirmar que não interfere na rota principal nem na saída.

### Passo 6 — Revisão
- Capturar início, primeira travessia, encontro, checkpoint, janela de energia, rota opcional e saída.
- Executar testes de contrato e regressão da fase.
- Registrar limitações de validação física Android.

---

## 10. Matriz de aceitação

| ID | Critério | Evidência exigida |
|---|---|---|
| W1L5-AC-01 | Rota principal concluível sem Dash obrigatório | teste/percorrimento controlado |
| W1L5-AC-02 | Plataformas móveis têm trajetória previsível | captura e inspeção de runtime |
| W1L5-AC-03 | Janela de energia é observável antes da travessia | captura dos estados e teste |
| W1L5-AC-04 | Encontro não bloqueia movimento injustamente | teste de combate/recuperação |
| W1L5-AC-05 | Checkpoint restaura estado seguro | teste de persistência/respawn |
| W1L5-AC-06 | Rota opcional não bloqueia saída | teste de rota principal e opcional |
| W1L5-AC-07 | Guardião não é combatido nesta fase | inspeção da sequência e saída |
| W1L5-AC-08 | Nenhuma alteração a física, Dash, InputMap ou save | diff e testes de contrato |
| W1L5-AC-09 | Sem assets não aprovados integrados | inventário de assets |
| W1L5-AC-10 | Entrada/saída usa SceneFlow threaded | teste de integração |
| W1L5-AC-11 | Nenhum softlock em queda, falha ou retorno | percorrimentos de recuperação |
| W1L5-AC-12 | UI e gameplay permanecem legíveis em paisagem | capturas e revisão visual |

---

## 11. Riscos e mitigação

| Risco | Mitigação |
|---|---|
| Combinação de sistemas parecer uma mecânica nova | dividir em subtrechos e ensinar cada leitura antes |
| Plataforma móvel reduzir precisão touch | movimento previsível, área segura e janela generosa |
| Energia comunicar estado apenas por cor | forma, animação, ícone e contraste redundantes |
| Combate encobrir o hazard | separar espacialmente ou temporalmente os encontros |
| Checkpoint gerar estado inconsistente | usar o contrato existente e testar respawn |
| W1-L3/W1-L4 não estarem na base | bloquear implementação até integração/revisão das dependências |
| Cenário antecipar lore do chefe | limitar narrativa à proteção do fragmento Origem |

---

## 12. Decisões ainda abertas

As questões abaixo não devem ser resolvidas por inferência durante a implementação:

1. Composição visual exata do perímetro e do observatório.
2. Duração, velocidade e quantidade de plataformas móveis, a definir no blockout/playtest.
3. Inimigo exato do encontro, condicionado ao catálogo realmente aprovado e integrado.
4. Representação visual da janela de energia, condicionada aos sistemas existentes.
5. Recompensa contextual do observatório, sem criar novo item ou lore.
6. Duração total da fase, definida por playtest.

Essas decisões devem ser propostas com capturas ou protótipo e revisadas antes de congelar o blockout.

---

## 13. Gate de saída

W1-L5 só pode avançar para construção de cena quando:
- W1-L3 e W1-L4 estiverem integradas e auditadas;
- a especificação for revisada contra os contratos reais dos sistemas;
- os pontos em aberto que afetam geometria ou gameplay forem resolvidos;
- o usuário aprovar a direção visual correspondente quando houver assets ou linguagem visual nova.

O blockout resultante continuará provisório até playtest, revisão de legibilidade e aprovação visual.