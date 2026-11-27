# Proposta de direção visual global — BOLT · AVENTURA

**ID:** ART-BOLT-001  
**Etapa:** 05 — Direção de arte e identidade visual global  
**Estado:** PROPOSTA PARA AVALIAÇÃO DO USUÁRIO  
**Versão:** 0.1  
**Base:** main `d90ac2c78e96b32233f8d003ea6673a38079ecb3`  
**Escopo:** linguagem visual, princípios de consistência, legibilidade e critérios de aprovação  
**Fora de escopo:** sprites finais, tilesets, fundos finais, VFX finais, tipografia licenciada, áudio final e integração de assets.

> Este documento não estabelece canon visual aprovado. Todas as decisões estéticas específicas abaixo são propostas de direção. A aprovação deve ser explícita e pode aceitar, rejeitar ou solicitar revisão de partes independentes.

---

## 1. Objetivo de produção

Estabelecer uma gramática visual capaz de unificar sete mundos com identidades muito diferentes sem torná-los visualmente intercambiáveis. A direção deve funcionar em gameplay 2D de rolagem lateral, em tela Android paisagem, com personagem, plataformas, inimigos, perigos, pickups, HUD e controles touch simultaneamente visíveis.

A direção precisa satisfazer quatro requisitos que competem entre si:

1. **Identidade:** cada mundo deve ser reconhecível por composição, silhueta, materiais e atmosfera.
2. **Leitura de gameplay:** o jogador deve distinguir imediatamente superfície jogável, perigo, personagem, interação e objetivo.
3. **Coesão:** BOLT, NEXO, interface, efeitos e cenários devem pertencer ao mesmo produto.
4. **Viabilidade mobile:** detalhe, transparência, partículas, animação e resolução devem ser controláveis sem reduzir a clareza.

A qualidade visual não será medida por quantidade de detalhe. O critério primário é a leitura correta e rápida do estado do jogo.

## 2. Fontes e limites de autoridade

### 2.1 Fatos confirmados nas bíblias

- BOLT é o protagonista robótico que desperta em um mundo destruído.
- NEXO é a máquina temporal que se une a BOLT e permite viajar entre eras e mundos.
- O Arquiteto é o antagonista central; o conflito opõe uniformidade imposta e coexistência entre universos.
- A campanha tem sete mundos, sete fragmentos e 42 fases planejadas.
- Cybercore é o mundo de despertar: ruínas tecnológicas e infraestrutura quebrada.
- Os outros mundos têm identidades temáticas descritas em `02-world-bible.md`; suas paletas, materiais detalhados e composições finais ainda não estão aprovados.
- A interface precisa priorizar legibilidade em celular, áreas de toque e segurança em relação às regiões de gesto do Android.
- O estilo final de pixel art, resolução-base, escala de sprites, paletas e proporções ainda não foi confirmado.

### 2.2 Lacunas que permanecem abertas

Não estão definidos por esta proposta: estilo final (pixel art, ilustração raster ou solução híbrida), resolução lógica, escala de sprite, proporções finais de BOLT, paleta cromática oficial, espessura de contorno, densidade de detalhe, FPS de animação, tipografia, dimensões de atlas, formatos de compressão e budgets numéricos.

Esses parâmetros exigem avaliação visual e, quando aplicável, teste em contexto de gameplay e aparelho Android. Não devem ser tratados como decisões técnicas fechadas por aparecerem como exemplos neste documento.

## 3. Hipótese de direção global

### 3.1 Proposta principal

Avaliar uma direção de **aventura 2D estilizada, com silhuetas fortes, formas de leitura imediata, cenários em camadas e iluminação atmosférica controlada**. A linguagem pode combinar personagens de desenho limpo com cenários ricos em profundidade, desde que a separação entre plano jogável e fundo permaneça inequívoca.

A imagem conceitual de Cybercore produzida em 27/11/2026 pode ser usada apenas como referência exploratória de atmosfera/composição. Ela não é arte oficial, não fixa o estilo final e não está aprovada para integração.

### 3.2 Princípios formais propostos

- **Silhueta antes de textura:** reconhecer BOLT, inimigos, plataformas e perigos em escala reduzida.
- **Hierarquia de planos:** fundo atmosférico; plano de percurso; primeiro plano decorativo, sem ocultar colisões ou ameaças.
- **Contraste funcional:** o que pode ser tocado, atravessado, coletado ou causar dano deve ter leitura distinta.
- **Detalhe localizado:** reservar maior densidade para pontos de interesse, landmarks e momentos narrativos; reduzir ruído em áreas de execução precisa.
- **Cor redundante:** nunca depender apenas da cor para comunicar estado; combinar forma, padrão, ícone, movimento ou posição.
- **Animação informativa:** antecipação, ação e recuperação devem comunicar estados; efeitos não podem esconder a origem ou o resultado de uma ação.
- **Coerência material:** metal, pedra, energia, vegetação, vidro e superfícies artificiais precisam de tratamentos consistentes dentro de cada mundo.
- **Identidade por mundo:** manter uma gramática global, mas permitir que arquitetura, ritmo de formas, materiais e atmosfera mudem substancialmente.

### 3.3 Alternativas ainda abertas

A avaliação deve comparar pelo menos estas alternativas antes de fechar o estilo:

| Alternativa | Benefício potencial | Risco principal |
|---|---|---|
| Pixel art de resolução lógica baixa | Identidade forte e controle de detalhe/frame | Exige disciplina rígida de escala, grade e iluminação |
| Ilustração 2D raster estilizada | Grande liberdade de atmosfera e materialidade | Pode elevar custo de produção, memória e inconsistência entre assets |
| Híbrido controlado | Personagens muito legíveis e cenários atmosféricos | Exige regras claras para evitar mistura visual incoerente |

A escolha não está feita. A alternativa deve ser validada com um pequeno conjunto de prova: BOLT em escala de gameplay, uma plataforma, um perigo, um inimigo provisório e um trecho de fundo de Cybercore. Nenhum desses testes deve substituir a aprovação do usuário.

## 4. Gramática visual de gameplay

### 4.1 Categorias de leitura

Cada elemento deve pertencer a uma categoria visual identificável:

- **Jogável:** chão, plataforma estática, plataforma móvel e superfície one-way.
- **Perigo:** zona de dano, obstáculo, área de ameaça e limite de queda.
- **Interativo:** interruptor, mecanismo, porta, terminal e objeto acionável.
- **Entidade:** BOLT, NPC, inimigo e chefe.
- **Recompensa:** pickup, item opcional e fragmento.
- **Navegação:** entrada, saída, checkpoint, objetivo e rota opcional.
- **Atmosfera:** arquitetura distante, partículas ambientais, vegetação decorativa e ruínas sem colisão.

A mesma silhueta não deve ser usada para duas categorias com consequências diferentes. Se houver semelhança inevitável, adicionar sinal redundante de estado.

### 4.2 Contraste e composição

- Manter contraste local suficiente entre pés de BOLT e superfície de aterrissagem.
- Não colocar detalhes de fundo que simulem bordas, plataformas ou projéteis.
- Evitar linhas de arquitetura que pareçam hitboxes.
- Não permitir que partículas, bloom, sombras ou foreground cubram telegraphs.
- Preservar espaço negativo em torno de objetos interativos e objetivos.
- Manter a rota principal visualmente dominante sem eliminar exploração opcional.
- Evitar que o HUD se funda com elementos de cenário de alto contraste.

### 4.3 Leitura em movimento

A prova visual deve ser avaliada em três condições: imagem estática, captura durante movimento e observação em velocidade normal. A leitura de um sprite parado não comprova legibilidade de Dash, salto, queda, dano ou interação.

## 5. Identidade do protagonista e NEXO

### 5.1 BOLT — requisitos visuais, não concept final

- Silhueta distinguível em movimento e em tamanho reduzido.
- Centro visual e orientação reconhecíveis sem depender de detalhes faciais minúsculos.
- Pose de salto, queda e Dash com direção inequívoca.
- Estados de dano e invulnerabilidade perceptíveis sem flashes excessivos.
- Pivô e origem coerentes entre animações, sem deslocamento visual involuntário.
- A arte não define nem substitui a hitbox física.
- A aparência final permanece pendente de concept e aprovação.

### 5.2 NEXO — presença visual pendente

NEXO deve ser reconhecível como parte da premissa de viagem temporal, não apenas como ícone de menu. A forma física, presença acoplada a BOLT, linguagem de comunicação, animação e assinatura visual permanecem a definir. Esta proposta não escolhe formato, rosto, cor ou voz para NEXO.

### 5.3 Relação BOLT/NEXO

A futura direção deve permitir que os dois sejam reconhecidos como um sistema narrativo conjunto sem confundir suas funções. Sinais visuais de viagem temporal, fragmentos e eventos de NEXO precisam ser consistentes entre HUD, cenário, cutscenes e transições.

## 6. Identidade visual por mundo — matriz de direção

As descrições abaixo derivam das identidades temáticas da bíblia dos mundos. São eixos de exploração, não paletas, assets ou decisões finais.

| Mundo | Identidade já definida | Eixos visuais a explorar | Risco de legibilidade |
|---|---|---|---|
| 1. Cybercore | Ruínas tecnológicas e infraestrutura quebrada | Sistemas industriais, circuitos residuais, arquitetura funcional em colapso | Luzes/circuitos confundirem-se com perigos ou plataformas |
| 2. Egito Antigo Futurista | Monumentalidade ancestral e tecnologia futurista | Escala arquitetônica, inscrições, geometria monumental, mecanismos | Ornamentos e padrões competirem com pistas interativas |
| 3. Speakeasy Aesthetic | Urbano, anos 1920, elegância, música e mistério | Interiores urbanos, ritmo vertical, superfícies refinadas, sinais de mistério | Baixa iluminação e decoração esconderem ameaças |
| 4. Dark Fantasy | Fantasia sombria, ruínas e exploração | Silhuetas dramáticas, estruturas antigas, atmosfera de ameaça | Escuridão reduzir contraste e antecipação |
| 5. Pôr do Sol em Cidade Medieval | Cidade medieval sob luz de fim de tarde | Arquitetura histórica, telhados, muralhas, profundidade urbana | Silhuetas de telhados confundirem-se com plataformas |
| 6. Vaporwave / Las Vegas | Neon, espetáculo, reflexos e geometrias | Formas gráficas, arquitetura de entretenimento, reflexos controlados | Neon e brilho produzirem ruído ou excesso de bloom |
| 7. Natal / Nova York Futurista | Nova York futurista em atmosfera natalina | Skyline, arquitetura urbana, sinais sazonais, tecnologia | Decoração sazonal ocultar sinais de navegação e perigos |

### 6.1 Regras de diferenciação

Cada mundo deverá ter uma ficha visual própria com:
- formas dominantes e escala arquitetônica;
- materiais primários e secundários;
- tratamento de superfícies e desgaste;
- relação entre primeiro plano, plano jogável e fundo;
- estratégia de contraste para entidades e perigos;
- iluminação e atmosfera;
- partículas ambientais permitidas;
- ícones e sinais de interação;
- landmarks e elementos de navegação;
- restrições de densidade e legibilidade mobile.

A diferenciação não deve depender somente de paletas. Dois mundos com cores semelhantes ainda precisam ser distinguíveis por arquitetura, silhueta, materialidade e composição.

## 7. Cenários, tilesets e composição

- Separar visualmente geometria com colisão de decoração sem colisão.
- Definir uma convenção visual para bordas, quinas, superfícies superiores e laterais de plataformas.
- Garantir continuidade de tiles sem costuras, mudanças de escala ou padrões repetitivos acidentais.
- Não inferir colisão pela arte; a geometria física é configurada e testada separadamente.
- Manter landmarks legíveis em rolagem lateral e em diferentes proporções de tela.
- Evitar parallax excessivo que prejudique orientação ou leitura de velocidade.
- Usar foreground com parcimônia; nunca encobrir BOLT, inimigos, perigos, pickups ou controles.
- Distinguir claramente elementos de cenário que são sólidos, atravessáveis, interativos ou decorativos.

## 8. Personagens, inimigos e chefes

A direção visual deve apoiar a leitura funcional definida nas fichas de personagem:

- Silhueta do inimigo comunica locomoção, alcance espacial e papel do encontro.
- Telegraph visual/sonoro é distinguível do cenário e permanece legível em tela pequena.
- Estado de preparação, ação, recuperação, dano e derrota não pode depender de microdetalhes.
- Chefes precisam de assinatura visual por mundo e leitura clara de fases/transições.
- Variações de inimigos devem refletir comportamento e decisões diferentes, não apenas recoloração.
- Não definir aparência final de arquétipos ou guardiões antes de dossiers e aprovação.

## 9. VFX e feedback

Cada efeito deverá declarar causa, alvo, direção, duração, área, estado inicial/final e prioridade visual.

Prioridades propostas:
1. feedback de dano/risco imediato;
2. feedback de input e habilidade do jogador;
3. telegraph e mudança de estado de inimigo/chefe;
4. interação, checkpoint e objetivo;
5. recompensa e fragmento;
6. atmosfera e decoração.

Regras:
- Efeitos críticos não podem ser mascarados por efeitos atmosféricos.
- Flashes devem ter duração e intensidade controladas.
- Screen shake não pode deslocar a referência visual a ponto de prejudicar aterrissagens.
- Partículas devem ter limite por efeito e por cena, definido após perfil real.
- Prever redução de flashes, shake e partículas quando tecnicamente viável.
- Efeitos de sucesso precisam ser distinguíveis de efeitos de perigo.

## 10. UI, HUD e controles

A estética da interface deve ser subordinada à clareza e aos contratos de UI/UX existentes.

- Hierarquia de informação consistente entre menu, HUD, pausa e telas de resultado.
- Ícones devem ter silhueta clara e rótulo/tooltip quando o significado não for universal.
- Estado pressionado de botões touch precisa ser visível sem atrasar o reconhecimento da ação.
- Botões essenciais permanecem em área segura, fora de recortes e regiões de gesto.
- A interface não deve cobrir a zona provável de aterrissagem, inimigos ou perigos.
- A HUD apresenta estado; não é fonte de verdade de vida, progresso ou cooldown.
- Não adicionar uma opção de tela cheia que contradiga ADR-0003.
- As barras de status e navegação seguem a política imersiva aprovada, independentemente da opção de tela cheia da interface.

A direção final da UI/HUD depende de prova em proporções Android reais e não pode ser aprovada somente em mockup isolado.

## 11. Animação e consistência temporal

A futura especificação de animação deve registrar por estado: finalidade, início, loop, saída, prioridade, cancelabilidade, duração, FPS, pivô, hitbox relacionada e evento de gameplay sincronizado.

Estados de referência a cobrir conforme existirem no design: idle, início/fim de locomoção, salto, queda, aterrissagem, Dash, dano, interação, vitória e derrota. A lista não cria novos estados de gameplay.

Requisitos:
- Evitar mudança involuntária de escala ou posição entre frames.
- Preservar o alinhamento dos pés nas animações de locomoção/aterrissagem.
- Sincronizar VFX e áudio com eventos reais, não com temporizadores independentes frágeis.
- Priorizar leitura do movimento sobre fluidez ornamental.
- Não alterar a física para acomodar uma animação; a arte deve respeitar o contrato de gameplay.

## 12. Áudio como camada da direção audiovisual

A identidade sonora precisa acompanhar a função do mundo e a hierarquia de gameplay, mas as assinaturas musicais específicas ainda não estão definidas.

Categorias a especificar: ambiência, música, UI, movimento, habilidade, interação, inimigo, chefe, checkpoint, fragmento e transição. Cada evento precisa de prioridade, volume relativo, duração, variação, condição de repetição e comportamento durante pause/interrupção.

Não definir BPM, instrumentos, temas, samples ou vozes como canon neste documento. Evitar sons contínuos ou repetitivos que concorram com telegraphs importantes.

## 13. Requisitos técnicos e mobile

Os budgets numéricos serão estabelecidos após escolha do estilo e medição de um slice representativo. Até lá, usar estes requisitos qualitativos:

- evitar texturas enormes sem necessidade;
- evitar múltiplas cópias de atlas por cena;
- controlar transparências sobrepostas e overdraw;
- limitar partículas e efeitos simultâneos;
- evitar animações decorativas permanentes fora da área visível;
- usar formatos/import settings coerentes com a plataforma Android e a versão Godot;
- carregar recursos por dependência real, evitando preload global especulativo;
- preservar resolução lógica e escala consistente após decisão técnica;
- testar em build Android, não apenas no editor;
- registrar memória de textura, tempo de carregamento e frame time quando a etapa de validação exigir.

Nenhuma meta de FPS ou memória é declarada atendida por este documento.

## 14. Protocolo de prova visual

Antes de aprovar a direção, produzir um slice visual controlado, não um conjunto completo de assets:

1. BOLT em escala de gameplay, com poses essenciais provisórias.
2. Uma plataforma jogável e uma plataforma decorativa.
3. Um perigo ambiental e sua sinalização.
4. Um inimigo provisório com telegraph.
5. Um pickup/interativo.
6. Fundo com ao menos duas camadas.
7. HUD e controles touch em paisagem.
8. Capturas estáticas e durante movimento.
9. Comparação em escala reduzida, brilho moderado e contraste limitado.
10. Build Android para avaliação de tela, quando disponível.

O slice deve ter IDs/versões, consumidor, origem e status. Não pode ser integrado como arte final sem aprovação explícita da versão exata.

## 15. Critérios de avaliação e aprovação

Avaliar cada critério em escala ordinal documentada (reprovado / precisa revisão / aceitável / forte), sempre acompanhado de observação reproduzível:

| Critério | Pergunta de revisão |
|---|---|
| Reconhecimento | BOLT e entidades são reconhecidos rapidamente? |
| Gameplay | Plataformas, perigos e interativos são distinguíveis? |
| Movimento | Salto, queda e Dash mantêm leitura durante ação? |
| Hierarquia | O jogador identifica o que exige atenção primeiro? |
| Mundo | A identidade temática é perceptível sem depender apenas de cor? |
| Coesão | Personagem, cenário, HUD e VFX pertencem ao mesmo universo? |
| Mobile | A leitura se mantém em escala e resolução de celular? |
| Acessibilidade | Estados críticos usam sinais redundantes? |
| Viabilidade | A direção permite budgets e produção sustentáveis? |
| Proveniência | Referências e assets têm origem/licença rastreáveis? |

A direção só pode ser marcada como aprovada após decisão explícita do usuário. Aprovar a direção não aprova automaticamente concepts, sprites, tilesets, UI ou assets futuros.

## 16. Decisões que exigem validação do usuário

| ID | Decisão | Estado atual | Consequência |
|---|---|---|---|
| VDIR-01 | Estilo-base: pixel art, raster estilizado ou híbrido | A DEFINIR | Afeta pipeline, escala, animação e budgets |
| VDIR-02 | Resolução lógica e escala de apresentação | A DEFINIR | Afeta todos os assets e UI |
| VDIR-03 | Tratamento de contorno/silhueta | A DEFINIR | Afeta leitura e consistência |
| VDIR-04 | Densidade de detalhe e profundidade de cenário | PROPOSTA | Afeta legibilidade e custo |
| VDIR-05 | Paletas e materiais por mundo | A DEFINIR | Afeta identidade dos sete mundos |
| VDIR-06 | Linguagem visual de BOLT e NEXO | A DEFINIR | Depende de concepts aprovados |
| VDIR-07 | Gramática de UI/HUD e ícones | A DEFINIR | Depende de prova mobile |
| VDIR-08 | Linguagem de VFX e feedback | A DEFINIR | Depende de gameplay e acessibilidade |

## 17. Próximas unidades de produção

Após revisão desta proposta:

1. Consolidar feedback e registrar as decisões de direção aprovadas.
2. Criar o guia técnico de sprites/assets da Etapa 06, sem antecipar parâmetros ainda não decididos.
3. Preparar concept de BOLT para a Etapa 07 e apresentar versões separadas para aprovação.
4. Só depois da aprovação do concept, especificar e produzir spritesheets da Etapa 08.
5. Desenvolver o kit visual de UI/HUD da Etapa 09 com prova em escala Android.
6. Manter assets não aprovados fora do projeto executável.

## 18. Estado de conclusão desta entrega

**Entregue:** proposta de direção visual global, matriz dos sete mundos, princípios de legibilidade, requisitos de UI/mobile, critérios de avaliação e decisões pendentes.

**Não entregue:** estilo visual final aprovado, paletas finais, concepts, sprites, animações, tilesets, UI final, VFX finais, áudio final ou validação em aparelho.

**Próximo gate:** revisão do usuário sobre VDIR-01 a VDIR-08. Nenhuma lacuna foi convertida silenciosamente em canon ou parâmetro final.
