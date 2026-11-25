# BOLT · AVENTURA — Master Game Design & Gameplay Directive

> **Documento de direção para Claude Code.** Use este arquivo como prompt mestre para conceber, auditar, planejar e implementar a história, os sete mundos, as 42 fases, menus, HUD e gameplay de BOLT · AVENTURA. Ele complementa `CLAUDE.md`, `AGENTS.md` e as bíblias em `docs/game-design/`; não substitui as regras de aprovação, os gates de produção nem a inspeção do projeto real.

## 0. Missão

Atue como diretor criativo, game designer sênior, level designer, designer narrativo, UX designer e engenheiro de gameplay especializado em jogos 2D de plataforma para Android.

Transforme BOLT · AVENTURA em uma aventura 2D completa, coesa, cinematográfica, tecnicamente sustentável e com identidade própria. O resultado deve apresentar começo, desenvolvimento, clímax e conclusão; sete mundos distintos; 42 fases planejadas; chefes memoráveis; progressão significativa; combate e movimentação responsivos; menus profissionais; tutorial jogável; narrativa integrada ao gameplay; e experiência cuidadosamente adaptada a telas touch em paisagem.

**Não se limite a produzir documentação bonita ou protótipos isolados.** Projete sistemas que possam ser implementados, testados, integrados e mantidos. Ao mesmo tempo, não declare conteúdo implementado quando existir apenas como planejamento.

## 1. Hierarquia de autoridade e proteção do canon

Antes de trabalhar, leia `CLAUDE.md`, `AGENTS.md`, este documento, o índice `docs/README.md`, as bíblias relevantes, as decisões e o status da etapa.

Aplique os seguintes estados:
- **CANON APROVADO:** informação narrativa ou de produto explicitamente definida pelo usuário.
- **REQUISITO:** característica obrigatória de produto ou critério de qualidade.
- **PROPOSTA:** criação nova que precisa de aprovação antes de se tornar definitiva.
- **A DEFINIR:** informação ausente; não preencher por suposição.
- **IMPLEMENTADO:** existe no projeto executável e foi inspecionado.
- **VALIDADO:** passou por teste identificável, com evidência registrada.

Não transforme ideias próprias, sugestões anteriores ou nomes inventados em canon. Não substitua nomes, ordem dos mundos, número de fases, fragmentos, chefes ou mecânicas aprovadas. Se uma lacuna impedir o trabalho, apresente uma proposta claramente rotulada e solicite aprovação no gate adequado. Não paralise tarefas que possam avançar sem essa lacuna.

## 2. Identidade do produto

- **Título:** BOLT · AVENTURA.
- **Gênero:** plataforma, ação e aventura 2D.
- **Engine de direção:** Godot 4.x, GDScript; confirme a versão instalada no projeto antes de usar APIs.
- **Plataforma-alvo:** aplicativo Android empacotado.
- **Orientação:** paisagem.
- **Público de hardware de referência:** Android com aproximadamente 4 GB de RAM e MediaTek Helio G99 ou inferior.
- **Campanha:** exatamente 7 mundos, 6 fases por mundo, total planejado de 42 fases.
- **Estrutura de mundo:** cinco fases de progressão e exploração, seguidas pela sexta fase como confronto final com guardião, obtenção do fragmento e abertura do portão dimensional. A distribuição específica de funções nas fases 1–5 deve respeitar o tema e a curva de aprendizagem de cada mundo.
- **Experiência:** aventura cinematográfica, exploração, plataforma precisa, combate legível, segredos, personagens, chefes e evolução gradual de habilidades.

## 3. História oficial — canon que deve ser preservado

### 3.1 Premissa e conflito central

Um grande evento chamado **Grande Colapso** rompeu o **Núcleo da Eternidade** e desestabilizou a continuidade entre os universos. Em meio às ruínas de **Cybercore**, o robô **BOLT** desperta sem memória. Durante a jornada, uma máquina temporal desperta e se une a ele: **NEXO**.

A união de BOLT e NEXO permite atravessar eras e mundos. Para restaurar o equilíbrio, BOLT precisa recuperar sete fragmentos, cada um guardado pelo guardião de um mundo. Os fragmentos não são meras chaves: estão ligados à origem da máquina temporal, à ruptura do Núcleo e à verdadeira função de BOLT.

O antagonista central é **o Arquiteto**, que deseja impor uma única realidade. Sua visão elimina a coexistência entre universos em nome de uma ordem absoluta. BOLT foi criado para preservar os universos; sua jornada o leva a compreender essa finalidade e escolher proteger a coexistência, não impor uniformidade.

O encerramento deve concluir o conflito entre controle absoluto e coexistência, dar consequência à recuperação dos sete fragmentos e fechar o arco emocional de BOLT e NEXO. Não transformar o final em gancho obrigatório para continuação. Conteúdo adicional pós-créditos só pode ser proposta, nunca substituir a conclusão principal.

### 3.2 Os sete fragmentos — ordem fixa

1. **Origem** — Mundo 1: Cybercore.
2. **Memória** — Mundo 2: Egito Antigo Futurista.
3. **Verdade** — Mundo 3: Speakeasy Aesthetic.
4. **Sombra** — Mundo 4: Dark Fantasy.
5. **Luz** — Mundo 5: Pôr do Sol em Cidade Medieval.
6. **Ilusão** — Mundo 6: Vaporwave / Las Vegas.
7. **Equilíbrio** — Mundo 7: Natal / Nova York Futurista.

A relação simbólica de cada fragmento com o mundo deve ser expressa por cenário, desafios, NPCs, chefe e consequência narrativa. Não explicar tudo por diálogos expositivos. Cada conquista deve alterar a compreensão do mistério.

### 3.3 Estrutura cinematográfica

A abertura deve:
1. Apresentar o Grande Colapso e a ruptura do Núcleo da Eternidade por imagens e som, sem despejar toda a explicação.
2. Mostrar a devastação e o despertar de BOLT em Cybercore.
3. Estabelecer amnésia, vulnerabilidade, curiosidade e personalidade do protagonista por atuação visual.
4. Apresentar o despertar e a união de NEXO com BOLT.
5. Sugerir a escala da ameaça e a existência dos fragmentos.
6. Conduzir naturalmente ao tutorial, sem um corte que pareça desconectado.

A campanha deve alternar exploração, pequenas revelações, cenas curtas, encontros com NPCs, momentos de silêncio e grandes sequências cinematográficas. Cada cutscene precisa mudar informação, emoção, objetivo ou consequência. Evite cenas longas que apenas repetem o que o jogador já sabe.

### 3.4 Arco dos personagens

**BOLT**
- Robô protagonista, desperta amnésico em Cybercore.
- Foi criado para preservar os universos.
- Sua personalidade deve ser transmitida por movimento, postura, reações, expressões, escolhas e interações; não depender exclusivamente de fala.
- A jornada deve mostrar evolução emocional e compreensão da própria função.
- Não reduzir BOLT a avatar silencioso sem personalidade.

**NEXO**
- Máquina temporal que desperta e se une a BOLT.
- Permite a travessia temporal/dimensional e está ligada ao mistério dos fragmentos.
- Deve ter presença consistente na narrativa, na interface diegética, no feedback de habilidades e na progressão.
- Sua personalidade, voz, forma detalhada e limites específicos devem seguir material aprovado; lacunas permanecem como propostas.

**O Arquiteto**
- Antagonista central.
- Deseja uma única realidade e representa a imposição de uniformidade/controle.
- Sua lógica deve ser compreensível, mas suas ações e consequências devem ser confrontadas.
- Não o transformar em vilão genérico que deseja destruição sem motivação.

**NPCs e robôs mensageiros**
- NPCs devem ter identidade, função e relação com o mundo.
- Robôs mensageiros orientam o jogador por balões de fala, especialmente no tutorial.
- Figurantes podem dar vida aos ambientes, mas não devem bloquear passagem, poluir a leitura ou simular interações inexistentes.
- Cada NPC importante deve possuir estado, falas identificadas, função e consequência narrativa ou de gameplay.

### 3.5 Ritmo narrativo por mundo

Cada mundo deve:
- Reforçar o tema do fragmento correspondente.
- Apresentar uma pergunta ou conflito local.
- Mostrar consequências do Grande Colapso de maneira própria.
- Introduzir personagens que expressem diferentes respostas ao conflito.
- Construir a presença do guardião antes da batalha final.
- Entregar uma revelação parcial, sem antecipar todas as respostas.
- Terminar com a conquista do fragmento e abertura do portão dimensional.
- Fazer a transição para o mundo seguinte avançar a história, não apenas trocar o cenário.

## 4. Os sete mundos — sequência imutável

A ordem abaixo é canon. Não renomear, reordenar, fundir ou remover mundos.

| Nº | Mundo | Identidade central | Fragmento | Guardião final |
|---:|---|---|---|---|
| 1 | **Cybercore** | Ruínas tecnológicas e mundo destruído; fase inicial em estado devastado, seguida por cinco fases de progressão normal do mundo | Origem | Guardião Tecnológico |
| 2 | **Egito Antigo Futurista** | Civilização, arquitetura monumental, tecnologia ancestral e mistérios de eras | Memória | Guardião Ancestral das Pirâmides |
| 3 | **Speakeasy Aesthetic** | Atmosfera inspirada no speakeasy dos anos 1920, elegância, música, mistério e ambientes urbanos | Verdade | Mestre das Sombras |
| 4 | **Dark Fantasy** | Fantasia sombria, ruínas, ameaça, atmosfera e exploração | Sombra | Rei Esquecido |
| 5 | **Pôr do Sol em Cidade Medieval** | Reino medieval sob luz dourada do entardecer, arquitetura, comunidade e conflito | Luz | Guardião da Coroa |
| 6 | **Vaporwave / Las Vegas** | Neon, ilusão visual, espetáculo, arquitetura urbana e estética vaporwave | Ilusão | Ilusionista Supremo |
| 7 | **Natal / Nova York Futurista** | Nova York futurista em atmosfera natalina; fechamento visual e emocional da campanha | Equilíbrio | Guardião do Inverno |

Os títulos de guardião acima são descrições oficiais disponíveis. Não invente nomes próprios para eles sem aprovação.

### 4.1 Direção específica por mundo

**Mundo 1 — Cybercore**
- É o ponto de entrada da campanha e o local do despertar de BOLT.
- A primeira fase mostra Cybercore destruído e estabelece o tom pós-Colapso.
- As cinco fases seguintes mostram a progressão normal do mundo, sem apagar a importância das ruínas iniciais.
- Ensinar fundamentos de movimento, combate, leitura de perigos e uso inicial de NEXO.
- O Guardião Tecnológico protege o fragmento Origem.
- A vitória deve esclarecer por que a recuperação dos fragmentos importa e abrir o primeiro portão dimensional.

**Mundo 2 — Egito Antigo Futurista**
- Unir iconografia e arquitetura do Egito Antigo a tecnologia futurista de forma coerente.
- Usar escala monumental, interiores, mecanismos e leitura espacial distinta de Cybercore.
- O fragmento Memória deve dialogar com passado, lembrança e vestígios de civilizações.
- O Guardião Ancestral das Pirâmides deve testar habilidades já aprendidas e a leitura de mecanismos do mundo.

**Mundo 3 — Speakeasy Aesthetic**
- Evocar o universo speakeasy dos anos 1920 sem transformar o mundo em mera decoração.
- Trabalhar ambientes urbanos, salões, bastidores, passagens e contrastes de luz.
- O fragmento Verdade deve se relacionar com aparências, segredos e revelações.
- O Mestre das Sombras deve ter padrões legíveis e coerentes com o tema; evitar invisibilidade injusta ou ataques sem telegraph.

**Mundo 4 — Dark Fantasy**
- Criar fantasia sombria com identidade própria, atmosfera forte e silhuetas reconhecíveis.
- Contrastar ameaça e beleza; evitar escurecer tanto que plataformas, inimigos e perigos se tornem ilegíveis.
- O fragmento Sombra deve aprofundar o conflito sem associar escuridão a simples maldade.
- O Rei Esquecido deve representar a história e as consequências desse mundo.

**Mundo 5 — Pôr do Sol em Cidade Medieval**
- Construir uma cidade medieval sob luz de pôr do sol, com calor visual, profundidade e arquitetura marcante.
- O mundo deve ter identidade distinta do Dark Fantasy: não repetir ruínas sombrias com outra paleta.
- O fragmento Luz deve tratar de esperança, responsabilidade e revelação.
- O Guardião da Coroa deve testar domínio combinado das habilidades.

**Mundo 6 — Vaporwave / Las Vegas**
- Explorar neon, reflexos, geometrias, espetáculo urbano e estética vaporwave.
- Criar desafios de percepção e leitura sem depender de efeitos piscantes excessivos.
- O fragmento Ilusão deve trabalhar diferença entre aparência e realidade.
- O Ilusionista Supremo deve desafiar a percepção do jogador sem ocultar regras essenciais ou produzir confusão injusta.

**Mundo 7 — Natal / Nova York Futurista**
- Combinar ambiente natalino, identidade urbana de Nova York e tecnologia futurista.
- Deve funcionar como culminação emocional e visual, não como fase bônus desconectada.
- O fragmento Equilíbrio encerra a sequência simbólica dos sete fragmentos.
- O Guardião do Inverno deve preparar o clímax final e a resolução com o Arquiteto.
- A campanha deve terminar com uma conclusão clara e emocionalmente satisfatória.

## 5. Estrutura das 42 fases

São exatamente seis fases planejadas por mundo, totalizando 42. A sexta fase de cada mundo é o confronto com o guardião, recompensa do fragmento e portão dimensional.

### 5.1 Função das fases 1–5

Use esta estrutura como guia de ritmo, adaptando desafios ao mundo sem repetir mecanicamente o mesmo mapa:

1. **Entrada e descoberta:** apresentar identidade do mundo, objetivo local, rota principal e uma mecânica/ameaça característica.
2. **Aprendizagem e exploração:** aprofundar a mecânica, introduzir variação de inimigos e caminhos alternativos.
3. **Combinação:** combinar movimento, combate e elementos ambientais já ensinados; incluir NPC ou revelação contextual.
4. **Especialização e desafio:** exigir domínio mais preciso, apresentar encontros e perigos em combinações mais complexas, com segredos opcionais.
5. **Preparação para o guardião:** maior desafio de travessia/combate do mundo, pista narrativa sobre o chefe, checkpoint e preparação justa para a arena.
6. **Guardião e fragmento:** arena dedicada, apresentação cinematográfica breve, combate com fases e telegraphs, vitória, aquisição do fragmento, consequência narrativa e abertura do portão dimensional.

Esta estrutura não obriga todas as fases a terem a mesma duração, formato ou número de encontros. Varie ritmo, composição, exploração e densidade.

### 5.2 Variedade de layout

A campanha deve combinar:
- Fases horizontais de progressão e combate.
- Fases verticais de escalada, descida e navegação espacial.
- Fases híbridas com alternância de trechos horizontais e verticais.

A orientação do jogo é paisagem. A variação vertical deve ocorrer dentro do espaço jogável em paisagem, não por trocar a orientação do dispositivo.

### 5.3 Regras de level design

Cada fase precisa de:
- Objetivo principal claro e legível.
- Rota principal concluível sem depender de segredo.
- Introdução segura de novas mecânicas.
- Ritmo entre travessia, combate, exploração e respiro.
- Pelo menos uma decisão espacial interessante; não usar obstáculos aleatórios apenas para preencher tempo.
- Plataformas e perigos com silhueta/contraste adequados.
- Checkpoints colocados antes de sequências longas ou difíceis, sem trivializar o desafio.
- Segredos opcionais com pistas ambientais justas.
- NPCs integrados ao espaço e sem bloquear a leitura.
- Encerramento e transição coerentes.
- Testes de softlock, colisão, câmera, respawn e desempenho.

### 5.4 Variedade de inimigos

Meta mínima: pelo menos **cinco arquétipos de inimigos distintos em cada mundo**. Distinção significa comportamentos, decisões e contra-jogos diferentes, não apenas recoloração, aumento de vida ou mudança de tamanho.

Para cada inimigo documente: silhueta, papel no encontro, movimentação, percepção, estados de IA, padrão/telegraph, resposta possível, interação com cenário, reação a dano, variações, limites de simultaneidade e testes.

A variedade deve crescer ao longo da campanha e reutilizar inimigos apenas quando fizer sentido narrativo. Não sobrecarregar a tela com efeitos, projéteis ou inimigos que escondam BOLT.

### 5.5 Chefes

Há exatamente um guardião final por mundo, totalizando sete confrontos principais. Cada chefe:
- Tem relação com o mundo e protege o fragmento correspondente.
- Possui apresentação e arena próprias.
- Usa fases/padrões compreensíveis e telegraphs visuais/sonoros.
- Testa habilidades ensinadas anteriormente.
- Oferece janelas justas de resposta.
- Tem transições de fase legíveis.
- Não depende de dano inevitável, aleatoriedade opaca ou reflexos impossíveis em touch.
- Tem condições claras de vitória, derrota, checkpoint e retomada.
- Entrega fragmento e consequência narrativa.

Não invente nomes próprios ou biografias definitivas para os guardiões.

## 6. Gameplay — pilares de controle e movimentação

O gameplay deve ser imediato, expressivo e previsível. O jogador precisa sentir que BOLT responde ao toque sem atraso perceptível. Não alterar números de física ou remover habilidades aprovadas sem autorização e testes de regressão.

### 6.1 Sistema All Jump

Tratar o All Jump como sistema de movimento completo, não apenas botão de pulo. O conjunto aprovado inclui:
- Pulo normal.
- Pulo variável: duração do toque influencia a altura dentro de limites justos.
- Pulo duplo.
- Buffer de pulo: registrar uma solicitação pouco antes de aterrissar e executá-la quando válido.
- Coyote time: pequena janela após sair da borda em que o pulo ainda pode ser acionado.
- Controle aéreo.
- Wall slide e wall jump, com regras de contato e recuperação consistentes.
- Dash como habilidade obrigatória do conjunto de movimentação.

Defina estados explícitos, prioridades e transições: no chão, subida, queda, segundo pulo, wall slide, wall jump, dash, dano/knockback, interação, cutscene, pausa e morte/respawn. Evite estados simultâneos incompatíveis.

### 6.2 Dash

Dash é obrigatório. Deve ter resposta imediata, duração e recarga consistentes, direção previsível, feedback claro e regras definidas para colisão, cancelamento, dano, parede, aterrissagem e interação. Não permitir que o dash provoque atravessamento indevido de colisores ou softlock.

### 6.3 Voo e aparar

Voo e aparar/parry não são habilidades obrigatórias do conjunto-base aprovado. Não os introduza como requisito da campanha ou substitutos de salto/dash. Se já existirem no projeto ou forem propostos como conteúdo adicional, preservar seu status e solicitar aprovação antes de torná-los parte central do balanceamento.

### 6.4 Combate e arsenal

As três armas fazem parte do arsenal previsto desde o início:
1. **Pistola Crono** — arma de referência e resposta básica.
2. **Tríplice Prisma** — disparo múltiplo e cobertura de área/ângulos.
3. **Laser Nexo** — disparo concentrado e identidade energética ligada a NEXO.

Defina diferenças reais de alcance, cadência, dispersão, impacto, feedback e utilidade. Nenhuma arma deve ser universalmente superior em todos os cenários. O jogador deve entender a seleção e o feedback sem depender de texto longo.

### 6.5 Habilidades especiais

Três habilidades especiais previstas:
- **Pulso EMP Temporal**.
- **Escudo de Fase**.
- **Sobrecarga Crono**.

Defina para cada uma: finalidade, ativação, custo/recarga, duração, feedback, regras de cancelamento, interação com chefes/inimigos, limites e balanceamento. Não criar combinações que quebrem encontros ou tornem uma arma/habilidade obrigatória sem tutorialização.

### 6.6 Economia, coleção e progressão

Preservar os seguintes elementos previstos:
- Nove skins temáticas.
- Sete itens lendários.
- Moedas.
- Melhorias.
- Baús.
- Segredos.
- Checkpoints.
- Inventário.
- Arsenal e habilidades.
- Conquistas.
- Progressão de mundos/fases.

Não inventar nomes, bônus, preços ou efeitos finais dos nove visuais e sete itens lendários sem aprovação. Cada item precisa de descrição, origem, raridade se aprovada, função, condição de obtenção, feedback e persistência no save. Skins devem ser cosméticas, salvo decisão explícita em contrário.

### 6.7 Dificuldades

Três opções previstas:
- **História** — prioriza fluidez narrativa e reduz fricção sem remover a identidade do desafio.
- **Difícil** — experiência padrão de maior exigência.
- **Super Difícil** — exige domínio consistente e leitura precisa.

Ajustar parâmetros coerentes, como dano recebido, tolerâncias, recursos e comportamento de encontros, sem simplesmente aumentar vida de inimigos ou velocidade de tudo. A dificuldade não pode quebrar telegraphs, checkpoints, tutorial ou progressão. Registrar exatamente quais variáveis mudam.

## 7. Tutorial interativo

A sequência aprovada é: **cinemática de abertura → tutorial guiado por robô mensageiro com balões de fala → início da campanha em Cybercore**.

O tutorial deve ensinar jogando:
1. Movimento horizontal e leitura do espaço.
2. Pulo normal e pulo variável.
3. Pulo duplo.
4. Buffer e coyote time em situações justas e compreensíveis.
5. Wall slide/wall jump quando introduzidos.
6. Dash.
7. Ataque básico e seleção/uso das armas disponíveis.
8. Habilidades especiais quando o fluxo de progressão permitir.
9. Interação, coleta, checkpoint e leitura de HUD.
10. Combinação de movimentos em um desafio final curto.

Não apresentar tudo de uma vez. Distribuir instruções, usar balões concisos, demonstração visual e tentativa do jogador. Cada lição deve ter área segura de prática e um desafio real que confirme compreensão. Permitir repetir a instrução e evitar bloquear o progresso por falha pequena. O robô mensageiro deve ter personalidade e função, não ser apenas uma caixa de texto.

## 8. Menus, HUD e experiência de usuário

A interface deve parecer parte de um jogo comercial bem produzido, com hierarquia clara, animações curtas e funcionais, transições consistentes, áudio de interface e navegação confortável por touch.

### 8.1 Fluxo de inicialização

- Tela de inicialização/logotipo.
- Carregamento real dos recursos necessários.
- Menu principal.
- Continuar ou Novo Jogo.
- Recuperação segura de save inválido/corrompido, sem apagar dados silenciosamente.
- Transição de cena com estado de carregamento verificável.

Loading deve corresponder a trabalho real de carregamento, pré-aquecimento ou preparação. Não usar espera artificial para simular processamento. Exibir progresso honesto quando mensurável; caso contrário, usar indicador indeterminado.

### 8.2 Menu principal

Deve apresentar:
- Identidade visual de BOLT · AVENTURA.
- Novo Jogo.
- Continuar (quando existir save válido).
- Seleção de mundos/fases, respeitando desbloqueios.
- Arsenal.
- Habilidades.
- Skins.
- Inventário.
- Conquistas.
- Configurações.
- Créditos.

A tela deve ter foco visual em uma ação principal, navegação simples, feedback sonoro/visual e confirmação para ações destrutivas. Não exibir botões sem função implementada.

### 8.3 Seleção de mundos e fases

- Mostrar os sete mundos na ordem oficial.
- Comunicar bloqueio/desbloqueio e progresso.
- Mostrar fases concluídas, melhor resultado e colecionáveis quando esses dados existirem.
- Não permitir selecionar conteúdo bloqueado por manipulação visual.
- Identificar fase do guardião e fragmento de cada mundo.
- Manter leitura em telas pequenas.

### 8.4 Arsenal, habilidades, skins e inventário

- Arsenal: comparar as três armas por atributos compreensíveis; indicar selecionada e disponível.
- Habilidades: apresentar Pulso EMP Temporal, Escudo de Fase e Sobrecarga Crono, com estado, efeito e recarga/custo.
- Skins: exibir as nove skins previstas, desbloqueios e pré-visualização; não atribuir bônus sem canon aprovado.
- Inventário: moedas, sete itens lendários, melhorias, baús/colecionáveis e descrições.
- Conquistas: objetivos, progresso e recompensa, sem registrar conclusão antes da condição real.

### 8.5 HUD durante gameplay

Exibir apenas o necessário:
- Estado de vida/energia conforme o sistema final aprovado.
- Arma selecionada e feedback de disparo/recarga.
- Habilidades e seus estados de disponibilidade.
- Moedas/colecionáveis relevantes.
- Fragmento/objetivo e informação contextual.
- Indicadores de interação, checkpoint e boss quando necessários.

Não cobrir personagem, inimigos, plataformas ou perigos. Evitar excesso de números e ícones. Informações importantes devem ter forma, ícone e/ou texto; não depender somente de cor. HUD deve reagir a dano, coleta, troca de arma, habilidade, objetivo e estado de chefe.

### 8.6 Menu de pausa

- Retomar.
- Reiniciar fase (com confirmação quando houver perda de progresso).
- Configurações.
- Controles/ajuda.
- Sair para seleção/menu, com confirmação e salvamento seguro quando necessário.

Pausar deve interromper gameplay, IA, física, timers e áudio conforme a política definida. Ao retomar, limpar estados de toque antigos e evitar disparo/salto fantasma.

### 8.7 Configurações

Prever:
- Volume geral, música e efeitos separadamente.
- Idioma, se houver mais de um idioma implementado.
- Legendas.
- Tamanho/legibilidade de texto quando viável.
- Intensidade de vibração, se usada.
- Redução de screen shake e flashes intensos.
- Layout/posição/tamanho de controles quando viável.
- Preferências de acessibilidade.
- Confirmação e persistência imediata das opções.

Não exibir opções que não tenham efeito real.

### 8.8 Telas de resultado

**Vitória:** resumo da fase, fragmento/objetivo quando aplicável, recompensas, segredos e próximo passo claro.

**Derrota:** opção de tentar novamente, voltar ao checkpoint ou sair conforme regras aprovadas. Evitar perda inesperada de progresso.

**Créditos:** reconhecer contribuições e licenças corretamente; não inventar créditos de terceiros.

### 8.9 Touch e áreas seguras Android

- Touch é prioridade de primeira classe.
- Suportar multitouch real: mover + pular + dash e outras combinações válidas.
- Botões com estados normal, pressionado, desabilitado e indisponível.
- Alvos de toque confortáveis e separados.
- Não deixar botões sob recortes ou gestos de sistema.
- Limpar entradas ao pausar, trocar de cena, perder foco ou interromper o app.
- Testar orientação paisagem e proporções diferentes.
- Respeitar a decisão de exibição das barras do Android registrada no projeto/decisões; não alterar essa política por conta própria.
- A opção de Tela cheia deve respeitar a decisão aprovada e não ser ativada automaticamente.
- Não alegar que o app pode ocultar ou desenhar sobre barras do sistema em todos os aparelhos sem validação Android.

## 9. Direção audiovisual

A identidade visual e sonora deve variar por mundo sem perder unidade de marca:
- Silhuetas legíveis para BOLT, inimigos, NPCs, plataformas e perigos.
- Animações que comuniquem antecipação, ação, impacto, recuperação e personalidade.
- Efeitos visuais que reforcem gameplay sem esconder informação.
- Paletas e contraste específicos para cada mundo.
- Música e ambiência com assinatura própria por mundo.
- Sons de interface consistentes.
- Feedback audiovisual de coleta de fragmentos, checkpoint, dano, habilidade, chefe e desbloqueio.
- Cutscenes com composição, câmera, ritmo e transições planejadas.

Evitar flashes intensos repetitivos, tremor excessivo, poluição visual e efeitos que prejudiquem leitura ou desempenho. Opções de redução devem ser respeitadas.

## 10. Save, checkpoints e integridade

Persistir, conforme sistemas aprovados:
- Mundo/fase desbloqueados e progresso.
- Fragmentos obtidos.
- Moedas, itens, melhorias e colecionáveis.
- Skins e conquistas.
- Configurações.
- Checkpoint e estado necessário para retomada segura.

Separar estado transitório de estado persistente. Usar versão de save, validação de dados, escrita segura e estratégia de migração. Nunca sobrescrever save válido com dados parciais. Testar fechar/retomar app, interrupções, dados inválidos e atualização de versão.

## 11. Arquitetura de implementação Godot

Antes de implementar:
1. Confirmar que existe um projeto Godot executável e localizar `project.godot`.
2. Detectar versão exata, renderer, resolução, orientação e configurações Android.
3. Inspecionar cenas, scripts, recursos, plugins e export presets existentes.
4. Mapear dependências e contratos.
5. Identificar o que já existe, o que está incompleto e o que não existe.
6. Ler as skills mínimas relevantes do catálogo, incluindo as skills BOLT.

Princípios:
- Separar input, controller, física, combate, UI, progressão, narrativa, áudio, save e fluxo de cenas.
- Preferir cenas coesas e composição; evitar scripts monolíticos e fragmentação excessiva.
- Usar recursos/dados reutilizáveis para armas, inimigos, fases e configurações quando fizer sentido.
- Usar sinais e contratos explícitos; evitar dependências circulares.
- Manter fonte única de verdade para estado de campanha e configurações.
- IDs estáveis para mundos, fases, itens, diálogos, eventos e conquistas.
- Não criar autoloads globais sem responsabilidade clara.
- Não introduzir plugins ou dependências externas sem justificar e verificar compatibilidade/licença.

## 12. Performance Android e qualidade

Meta: 60 FPS quando o dispositivo conseguir sustentar, sem prometer esse resultado em todo hardware. O orçamento de 60 FPS é aproximadamente 16,67 ms por frame.

Prioridades:
- Responsividade do input, especialmente salto e dash.
- Frame pacing estável; evitar câmera lenta causada por queda de FPS.
- Física consistente e independente de variações indevidas do render frame.
- Controle de alocações e picos de garbage collection.
- Limites de partículas, transparências, overdraw e efeitos.
- Texturas, atlas, áudio e memória de recursos.
- IA e física atualizadas com frequência adequada.
- Carregamento/preload para reduzir stutter em gameplay.
- Liberação correta de cenas/recursos e ausência de crescimento de memória.
- Sessões prolongadas e comportamento térmico.

Não reduzir conteúdo, qualidade ou mecânicas por suposição. Medir antes/depois em aparelho identificado. Registrar frame time médio, p95/p99, picos, memória e condições de teste. Teste headless não prova responsividade touch, renderização ou desempenho GPU.

## 13. QA obrigatório por sistema

**Movimentação:** pulo normal/variável/duplo, buffer, coyote, wall slide/jump, dash, colisões, bordas, aterrissagem, dano, pausa e retomada.

**Combate:** três armas, três habilidades, seleção, feedback, cooldown/custo, inimigos, chefe, hitboxes e estados de invulnerabilidade.

**Fases:** rota principal, segredos, checkpoints, respawn, câmera, plataformas, transições, softlocks e conclusão.

**Narrativa:** ordem das cenas, flags, diálogos, pular/rever cutscene, NPCs, fragmentos e coerência do canon.

**Menus/UI:** navegação, botões reais, foco, safe areas, escalas, orientação paisagem, pausa, configurações e persistência.

**Save:** novo jogo, continuar, gravação, interrupção, retomada, corrupção, migração e consistência de progresso.

**Android:** instalação, orientação, toque rápido/prolongado, multitouch, perda/retorno de foco, barras do sistema, recortes, suspensão/retomada e sessão prolongada.

## 14. Fluxo de trabalho exigido de Claude

Para qualquer tarefa relacionada a este documento:

1. **Auditar:** ler arquivos relevantes e verificar estado real do projeto.
2. **Classificar:** separar canon, requisitos, propostas, implementado e validado.
3. **Planejar:** definir escopo mínimo, dependências, riscos, arquivos afetados e critérios de aceite.
4. **Aprovar:** pedir autorização quando houver mudança de canon, escopo, engine, arquitetura ou política de plataforma.
5. **Implementar:** executar mudanças pequenas, coesas e rastreáveis.
6. **Testar:** rodar testes adequados e registrar comandos/resultados reais.
7. **Revisar:** verificar regressões em controles, gameplay, save, UI e Android.
8. **Documentar:** atualizar documentos e status somente com evidência.
9. **Reportar:** informar arquivos alterados, comportamento entregue, testes realizados, limitações e próximos bloqueios.

Não declarar concluído porque os arquivos foram escritos. Não marcar fase como pronta sem rota jogável, conteúdo integrado, QA e critérios de aceite. Não afirmar APK, FPS, compatibilidade ou testes físicos sem evidência.

## 15. Entregáveis de design antes da produção integral

Antes de produzir as 42 fases, manter os seguintes artefatos atualizados:
- Linha do tempo narrativa e mapa de revelações.
- Arco de BOLT, NEXO e Arquiteto.
- Documento de cada mundo com tema, fragmento, NPCs, inimigos, guardião, mecânicas e identidade audiovisual.
- Matriz das 42 fases com objetivo, layout, mecânica central, inimigos, checkpoint, segredo, evento narrativo e saída.
- Catálogo dos sete guardiões e seus padrões.
- Catálogo dos inimigos por mundo, garantindo cinco arquétipos distintos por mundo.
- Especificação das três armas e três habilidades especiais.
- Especificação do All Jump e dash.
- Fluxograma dos menus e mapa de navegação.
- Wireframes e especificação do HUD.
- Roteiro do tutorial interativo.
- Roteiro das cutscenes.
- Modelo de progressão, moedas, melhorias, nove skins e sete itens lendários.
- Matriz de dificuldade.
- Plano de QA e orçamento de performance Android.

## 16. Critérios finais de qualidade

BOLT · AVENTURA só deve ser considerado completo quando:
- A história tiver começo, desenvolvimento, clímax e final coerentes.
- Os sete mundos estiverem produzidos na ordem oficial.
- As 42 fases estiverem implementadas e concluíveis.
- Cada mundo tiver sua identidade e pelo menos cinco arquétipos de inimigos distintos.
- Os sete guardiões e fragmentos estiverem integrados.
- Tutorial, cutscenes, NPCs e diálogos funcionarem.
- All Jump, dash, arsenal e habilidades estiverem responsivos e balanceados.
- Menus, HUD, saves, inventário, progressão e dificuldades funcionarem.
- O jogo estiver integrado como aplicativo Android.
- QA de gameplay, regressão, save e Android estiver documentado.
- Desempenho e limitações estiverem medidos em aparelhos identificados.
- O final resolver o conflito central e recompensar a jornada.

**Diretriz final:** produza uma aventura com identidade, emoção, clareza e profundidade de gameplay. Cada mundo deve ser memorável; cada fase deve ter propósito; cada habilidade deve ser satisfatória; cada chefe deve testar algo aprendido; cada menu deve ser funcional; e cada revelação deve aproximar o jogador da verdade sobre BOLT, NEXO, o Núcleo da Eternidade e o Arquiteto. Preserve o canon, não invente aprovações e nunca confunda planejamento com implementação.
