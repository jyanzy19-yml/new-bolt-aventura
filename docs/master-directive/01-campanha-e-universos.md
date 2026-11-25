# Parte 01 — Campanha, fases e sete universos

## 4. História oficial

Existem sete universos conectados pela energia do Equilíbrio Temporal e pelo Núcleo da Eternidade. O Grande Colapso rompeu o Núcleo e espalhou sete fragmentos pelos universos; cada fragmento protege uma parte essencial do equilíbrio entre as realidades.

Bolt, um pequeno robô, desperta nas ruínas de Cybercore sem compreender sua origem ou lembrar do passado. Ele encontra uma máquina temporal e desperta NEXO, uma inteligência artificial que se torna sua companheira. NEXO explica que os sete fragmentos precisam ser recuperados para impedir a destruição dos universos.

Ao longo da jornada, Bolt conhece personagens e civilizações, encontra registros antigos e enfrenta guardiões. O antagonista, conhecido como **Arquiteto**, pretende controlar todas as linhas temporais e criar uma realidade única, acreditando que as diferenças entre universos originam sofrimento e instabilidade.

A reviravolta revela que Bolt foi criado para preservar os sete universos e interagir com a energia dos fragmentos. NEXO o protegeu, separando-o do sistema principal e apagando suas memórias. Revelar tudo gradualmente, sem entregar os mistérios no início.

### 4.1. Evolução emocional

NEXO começa técnica, objetiva e aparentemente indiferente; ao longo da jornada desenvolve humor, preocupação, curiosidade, surpresa, afeto pela missão e dúvidas sobre suas decisões. Bolt demonstra personalidade por animações, expressões, reações e interações. NPCs possuem interesses, pequenas histórias e comportamentos próprios.

### 4.2. Final e mensagem

Após os sete fragmentos, Bolt retorna à origem de NEXO e enfrenta o Arquiteto. O Núcleo da Eternidade é reconstruído, as conexões temporais são restauradas e os universos recuperam a possibilidade de existir independentemente.

Mensagem central: equilíbrio não significa que todos sejam iguais; significa que cada universo pode seguir seu caminho sem destruir os outros.

Após os créditos, NEXO recebe um sinal misterioso de um possível oitavo universo. A cena abre possibilidade de expansão sem deixar a história principal incompleta.

**Tagline:** SETE UNIVERSOS. SETE FRAGMENTOS. UMA ÚLTIMA ESPERANÇA.  
**Mensagem final:** O universo não precisa ser perfeito para merecer um futuro.

## 5. Estrutura geral da campanha

- 7 mundos, com 6 fases cada: **42 fases principais**.
- 7 fragmentos, 7 portões dimensionais e 7 chefes guardiões.
- 1 confronto final independente com o Arquiteto, depois do sétimo mundo.
- 9 personagens/aparências jogáveis (skins cosméticas).
- 3 armas principais.
- Inimigos exclusivos, NPCs, itens lendários, segredos, áreas opcionais, recompensas e cinemáticas.
- A fase 6 de cada mundo é o confronto com o guardião daquele universo.

### 5.1. Função das seis fases por mundo

1. **Chegada e descoberta:** introduzir universo, ambiente, NPCs, inimigos básicos e característica exclusiva.
2. **Exploração e domínio:** expandir exploração, introduzir inimigos, obstáculos elaborados, uso de habilidades, segredos e rotas alternativas.
3. **Desafio e aprofundamento:** combinar inimigos, armadilhas, plataformas móveis, trechos verticais/híbridos e revelações.
4. **Região especial:** área visualmente marcante, ecossistema local, comportamentos novos, desafios ambientais e segredos difíceis.
5. **Preparação para guardião:** região perigosa, inimigos avançados, combinação de mecânicas, preparação narrativa e aproximação da arena.
6. **Chefe e conclusão:** arena exclusiva, introdução cinematográfica, chefe em múltiplas etapas, padrões legíveis, recompensa do fragmento, conclusão e liberação do portão seguinte.

Não criar seis percursos equivalentes com troca de paleta. Cada fase tem objetivo de design próprio.

## 6. Dimensões, escala e duração

Referência inicial: resolução lógica 1280×720, paisagem, coordenadas consistentes, tiles preferencialmente 32×32 ou 64×64 conforme a direção de arte, câmera estável e leitura clara, proporções consistentes e colisões independentes da escala visual. Ajustar após testes de jogabilidade e performance; são referências, não limites rígidos.

| Tipo | Duração de referência |
|---|---:|
| Exploração inicial | 4–7 min |
| Exploração avançada | 6–9 min |
| Região especial | 7–10 min |
| Preparação para chefe | 6–9 min |
| Chefe | 5–10 min |

Duração é meta de ritmo, não limite. Dimensionar pelo conteúdo jogável e velocidade do personagem. Fases podem ter segmentos conectados com identidade própria. Evitar corredores vazios, caminhada sem propósito, obstáculos repetidos, salas enormes vazias, saltos injustos, plataformas decorativas e caminhos que parecem exploráveis mas não são.

### 6.1. Estrutura interna variável

Uma fase pode conter entrada, apresentação visual, primeiro desafio, exploração, encontro importante, caminho alternativo, desafio principal, checkpoint, área especial, trecho final e encerramento. Variar a ordem conforme o objetivo.

### 6.2. Exploração vertical real

Incluir plataformas em alturas diferentes, torres, penhascos, elevadores, cavernas multinível, salas empilhadas, ruínas subterrâneas, passagens superiores e rotas inferiores. Elementos verticais precisam ter colisões, plataformas, inimigos, caminhos e recompensas funcionais; não basta decoração.

## 7. Cenários e ecossistemas

Construir profundidade em até seis camadas, conforme necessário:
1. Céu/atmosfera: nuvens, estrelas, neblina, auroras, tempestades, raios e iluminação.
2. Fundo distante: montanhas, cidades, pirâmides, torres, castelos e grandes formas.
3. Fundo intermediário: árvores, edificações, máquinas, ruínas e vegetação.
4. Área jogável: terreno, plataformas, paredes, obstáculos, inimigos, NPCs e objetos.
5. Primeiro plano: vegetação, colunas, galhos, estruturas e partículas, sem esconder perigos.
6. Efeitos atmosféricos: poeira, chuva, neve, faíscas, folhas, névoa e luzes.

Usar parallax com velocidades distintas para profundidade. Cada mundo deve parecer existir sem Bolt: criaturas ambientais, máquinas autônomas, vegetação característica, fontes de energia, animais/entidades, sons, partículas e objetos reativos. Exemplos: criaturas fogem, máquinas acendem, vegetação reage ao vento, lâmpadas piscam, portas respondem a fragmentos e drones executam rotinas. Não tornar tudo interativo; preservar orçamento de CPU/GPU.

## 8. Os sete universos

### Mundo 1 — CYBERCORE: O UNIVERSO PERDIDO
**Identidade:** ficção científica, tecnologia, neon, ruínas e mistério. **Paleta:** azul elétrico, ciano, roxo, preto, branco e magenta. **Arquitetura:** megacidades, laboratórios, fábricas, torres, ruas destruídas, estações de energia, túneis e instalações subterrâneas. **Ecossistema:** drones de manutenção, máquinas danificadas, segurança, robôs autônomos, portas inteligentes, núcleos, hologramas e elevadores.

Fases: (1) Ruínas do Despertar — introdução, mundo e encontro com NEXO; (2) Distrito das Máquinas — ruas, prédios, plataformas e inimigos; (3) Fábrica Abandonada — verticalidade, esteiras e maquinário; (4) Laboratório Esquecido — experimentos, segredos e registros; (5) Torre do Núcleo — desafios avançados e aproximação do guardião; (6) Guardião de Cybercore — protetor do Fragmento da Origem.

**Fragmento:** Origem. **Revelação:** Bolt tem ligação direta com o projeto do Núcleo.

Inimigos: Drone Patrulheiro (rota aérea, disparos em intervalos e acompanhamento); Robô Sentinela (guarda plataforma/corredor, detecta e dispara); Aranha Mecânica (desloca-se por superfícies e aproxima-se rapidamente); Torreta de Segurança (fixa, mira e dispara em sequências previsíveis); Robô de Manutenção Corrompido (patrulha, investida curta e proteção de aliados); Drone Explosivo de Energia (sinaliza antes de uma investida evitável).

Chefe: **Guardião da Origem**, máquina colossal. Fases de reconhecimento, ataques mecânicos/projéteis, movimentação pela arena, janelas de vulnerabilidade, mudança de padrões, segunda etapa mais intensa e encerramento cinematográfico. Exigir observação, movimento e domínio das armas; não apenas vida alta.

### Mundo 2 — EGITO ANTIGO FUTURISTA: O TEMPLO DAS ERAS
**Identidade:** civilização ancestral e tecnologia avançada. **Paleta:** dourado, areia, azul profundo, turquesa e branco. **Arquitetura:** pirâmides, templos, obeliscos, câmaras secretas, salas subterrâneas, pontes, observatórios e estruturas tecnológicas antigas. **Ecossistema:** escaravelhos mecânicos, criaturas do deserto, guardiões, energia, tempestades, mecanismos de pedra e portas por símbolos.

Fases: (1) Dunas do Tempo; (2) Templo dos Símbolos; (3) Cidade Enterrada; (4) Observatório Celestial; (5) Câmara das Eras; (6) Guardião da Memória. **Fragmento:** Memória. **Revelação:** os universos têm origem mais antiga do que Bolt imaginava.

Inimigos: Escaravelho Mecânico (investida terrestre); Sentinela de Pedra (ataques pesados com pausa); Guardião Alado (trajetórias aéreas e ataque superior); Múmia Energética (onda de energia a média distância); Escorpião do Deserto (emboscada sinalizada por contexto); Orbe Solar (flutua e dispara padrões). Chefe: **Guardião da Memória**, entidade ancestral; arena com plataformas móveis, mecanismos, energia, mudanças de posição, vulnerabilidades e alterações visuais.

### Mundo 3 — SPEAKEASY AESTHETIC: A CIDADE DOS SEGREDOS
**Identidade:** anos 1920, Art Déco, jazz, mistério e cidade noturna. **Paleta:** dourado, preto, vermelho escuro, verde-esmeralda e azul noturno. **Arquitetura:** clubes, hotéis, teatros, cassinos, estações, ruas chuvosas, becos, telhados e salas secretas. **Ecossistema:** autômatos urbanos, sistemas elétricos, letreiros, elevadores, trens, portas escondidas e instrumentos.

Fases: (1) Ruas de Neon; (2) Clube das Sombras; (3) Distrito dos Mistérios; (4) Teatro Esquecido; (5) Estação da Meia-Noite; (6) Guardião da Verdade. **Fragmento:** Verdade. **Revelação:** algumas pessoas conheciam os eventos anteriores ao Colapso.

Inimigos: Autômato de Rua (patrulha e contato); Agente Mecânico (projéteis direcionados); Drone de Vigilância (patrulha e alerta aliados); Robô de Palco (movimentos rápidos e sequência); Mímico Mecânico (disfarce de objeto e revelação ao aproximar); Sentinela do Trilho (patrulha ferroviária e investida previsível). Chefe: **Guardião da Verdade**, autômato elegante; iluminação dramática, ataques coreografados, mudanças de posição, arena móvel, telegraphs e fase mais agressiva.

### Mundo 4 — DARK FANTASY: O REINO ESQUECIDO
**Identidade:** fantasia sombria, criaturas antigas e ruínas. **Paleta:** verde escuro, roxo, cinza, azul profundo, vermelho e preto. **Arquitetura:** castelos, florestas, catacumbas, fortalezas, torres, ruínas, pontes, cavernas e salões subterrâneos. **Ecossistema:** criaturas fantásticas, vegetação bioluminescente, cogumelos, névoa, raízes, espíritos e cristais.

Fases: (1) Floresta Esquecida; (2) Vila Abandonada; (3) Catacumbas Profundas; (4) Fortaleza das Sombras; (5) Castelo do Vazio; (6) Guardião da Sombra. **Fragmento:** Sombra. **Revelação:** os fragmentos aprisionam uma força desconhecida que não deve ser libertada sem cuidado.

Inimigos: Lobo Sombrio (investida); Morcego Espectral (voo irregular); Cavaleiro Corrompido (ataque pesado); Planta Predadora (alcance sinalizado); Espírito Errante (flutua e dispara energia); Golem de Raízes (lento, bloqueia e golpeia em área). Chefe: **Guardião da Sombra**, arena em camadas, verticalidade, energia, invocações controladas, vulnerabilidade, iluminação e dificuldade progressiva.

### Mundo 5 — PÔR DO SOL EM CIDADE MEDIEVAL: O REINO DOURADO
**Identidade:** fantasia medieval, aventura, natureza e esperança. **Paleta:** dourado, laranja, verde, azul-claro, marrom e vermelho suave. **Arquitetura:** vilarejos, castelos, pontes, montanhas, cachoeiras, campos, florestas, moinhos, torres, fazendas e ruínas. **Ecossistema:** pássaros, animais, vegetação, rios, cachoeiras, abelhas, borboletas, criaturas fantásticas, vento e folhas.

Fases: (1) Campos Dourados; (2) Vila das Colinas; (3) Floresta das Cachoeiras; (4) Montanhas do Horizonte; (5) Castelo do Último Sol; (6) Guardião da Luz. **Fragmento:** Luz. **Revelação:** alguém tentou reconstruir o Núcleo antes de Bolt e fracassou.

Inimigos: Slime do Campo (saltos); Besouro Blindado (proteção frontal e posicionamento); Arqueiro Mecânico (posição elevada e projéteis); Corvo Guardião (mergulhos); Cavaleiro Errante (patrulha e combate próximo); Treant Corrompido (raízes que limitam espaço e atacam). Chefe: **Guardião da Luz**, iluminação dinâmica, plataformas, ataques em área, movimento e alternância entre defesa/ataque.

### Mundo 6 — VAPORWAVE / LAS VEGAS: A CIDADE DAS ILUSÕES
**Identidade:** retrô-futurismo, vaporwave, neon e arquitetura extravagante. **Paleta:** rosa, roxo, azul, ciano, magenta e pôr do sol. **Arquitetura:** hotéis, cassinos, avenidas, letreiros, telões, palmeiras, torres, prédios futuristas, túneis e centros de entretenimento. **Ecossistema:** hologramas, publicidade animada, automação, drones, ilusões, máquinas e luzes.

Fases: (1) Avenida Neon; (2) Hotel das Miragens; (3) Distrito Holográfico; (4) Torres do Infinito; (5) Centro das Memórias; (6) Guardião da Ilusão. **Fragmento:** Ilusão. **Revelação:** Bolt encontra memórias de si mesmo antes do Colapso.

Inimigos: Holograma Instável (aparência falsa com sinais justos); Drone Neon (patrulha e projéteis); Autômato de Cassino (movimento rápido e ataques curtos); Sentinela Prismática (padrões e posições alternados); Duplicador Holográfico (cópias temporárias); Robô de Segurança (protege áreas e resiste mais). Chefe: **Guardião da Ilusão**, projeções, sinais claros, mudanças de posição, duplicações temporárias, plataformas e revelação da forma real. Ilusões nunca tornam controles imprevisíveis nem ocultam perigos sem indicação.

### Mundo 7 — NATAL / NOVA YORK FUTURISTA: A ÚLTIMA ESPERANÇA
**Identidade:** cidade futurista invernal, Natal, esperança e encerramento épico. **Paleta:** azul-gelo, branco, vermelho, verde, dourado e ciano. **Arquitetura:** arranha-céus, ruas nevadas, praças, árvores de Natal, fábricas de brinquedos, trens, torres, estações, pontes e instalações do Núcleo. **Ecossistema:** neve, vento, aurora, máquinas, drones, pequenos robôs, luzes festivas, trens e energia.

Fases: (1) Ruas da Última Cidade; (2) Distrito Congelado; (3) Fábrica dos Brinquedos; (4) Torre das Memórias; (5) Complexo do Núcleo; (6) Guardião do Equilíbrio. **Fragmento:** Equilíbrio. **Revelação:** origem de Bolt e identidade do Arquiteto.

Inimigos: Drone Glacial (voo e projéteis frios); Robô de Neve (patrulha e investida); Sentinela Natalina (proteção e disparos padronizados); Autômato de Fábrica (máquinas e golpes pesados); Aranha de Gelo (paredes e plataformas); Guardião do Núcleo (energia e defesa da região central). Chefe: **Guardião do Equilíbrio**, ápice de dificuldade; arena cinematográfica, terreno variável, ataques combinados, fases, padrões elaborados, música progressiva, efeitos e encerramento narrativo.
