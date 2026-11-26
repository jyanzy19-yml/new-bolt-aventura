# BOLT · AVENTURA — DIRETRIZ MESTRA DE CRIAÇÃO, PRODUÇÃO E EXECUÇÃO

**Edição expandida:** 2.0  
**Papel:** contrato operacional de direção criativa, design, engenharia e qualidade.  
**Projeto:** repositório Godot existente; nunca reiniciar do zero.  
**Autoridade operacional:** ChatGPT é o único escritor ativo até decisão diferente do usuário.

> Esta diretiva amplia o universo, o escopo de design e os critérios de produção. Ela não afirma que conteúdo planejado já esteja implementado. O estado real do jogo é sempre determinado pelo código, cenas, testes, CI e documentos de continuidade do repositório.

---

# PARTE I — MANDATO E MÉTODO

## 1. Missão superior

Desenvolver BOLT · AVENTURA como um jogo 2D de plataforma, ação e aventura com identidade autoral, progressão inteligível, narrativa emocional, combate legível, controles touch robustos e arquitetura sustentável. O objetivo não é maximizar a quantidade de sistemas; é construir uma experiência integrada na qual cada mecânica, personagem, ambiente, recompensa e cena tenha propósito verificável.

A produção deve evoluir continuamente o projeto existente em Godot 4.7.2, preservando decisões aprovadas, evitando regressões e priorizando uma vertical slice real antes de multiplicar conteúdo. O alvo é um aplicativo Android empacotado em paisagem, com atenção especial a aparelhos de aproximadamente 4 GB de RAM e SoC de classe Helio G99 ou inferior. Não tratar navegador como plataforma de produto.

## 2. Autoridade documental e hierarquia

Em caso de divergência, aplicar esta ordem:
1. Decisão explícita mais recente do usuário, registrada em ADR quando estrutural.
2. Código, cenas, recursos e testes integrados em `main`, para descrever o estado implementado.
3. ADRs aprovados, bíblias de design e documentos canônicos.
4. Diretriz mestra e planos de produção.
5. Handoffs e notas históricas, que podem estar desatualizados.

Não interpretar um plano como implementação. Não interpretar um placeholder como asset final. Não interpretar um teste headless como validação física Android.

## 3. Sistema de classificação de conteúdo

Todo detalhe novo deve receber uma destas classificações:
- **CANON CONSOLIDADO:** fato de história ou produto já aprovado e presente nas fontes canônicas.
- **EXPANSÃO AUTORAL PROPOSTA:** detalhe novo criado sob a autorização de expansão do usuário; pode orientar protótipos reversíveis, mas deve permanecer identificável como proposta até ser incorporado formalmente à bíblia.
- **DECISÃO TÉCNICA:** escolha de implementação justificada por engenharia e registrada em ADR quando tiver impacto duradouro.
- **REQUISITO DE PRODUTO:** comportamento que precisa existir e ser verificável.
- **HIPÓTESE:** explicação ainda sem evidência.
- **A DEFINIR:** lacuna que não bloqueia outras tarefas.
- **IMPLEMENTADO:** existe no projeto real.
- **VALIDADO:** passou em teste identificado; indicar nível e evidência.

A autorização do usuário para preencher lacunas permite produzir expansões criativas substanciais, não declarar automaticamente cada invenção como fato histórico aprovado. Use as propostas como baseline de desenvolvimento, registre a origem e evite contradições. Quando uma proposta alterar o sentido central do jogo, o destino de personagem ou uma decisão irreversível de produção, criar gate explícito.

## 4. Protocolo de execução

Executar em ciclos curtos:
**INSPECT → RECONCILE → DIAGNOSE → PRIORITIZE → DESIGN → IMPLEMENT → TEST → REVIEW → INTEGRATE → COMMIT → UPDATE → REPEAT.**

Antes de cada alteração:
- confirmar branch, HEAD e estado da árvore;
- ler o arquivo integral e seus consumidores;
- pesquisar chamadas, sinais, recursos, cenas e testes;
- determinar riscos de regressão;
- escolher a menor unidade vertical que produza valor real;
- registrar critérios de aceitação antes de codificar.

Depois:
- executar a suíte relevante e os validadores disponíveis;
- inspecionar logs, não apenas o código de saída;
- comparar comportamento antes/depois quando possível;
- documentar limitações e evidências;
- abrir PR focada;
- integrar somente quando checks exigidos passarem e o diff for coerente;
- atualizar continuidade pós-merge.

Nunca afirmar que executou algo que não foi executado. Se o ambiente não oferece Godot local, emulador, APK ou aparelho, usar CI disponível e registrar os gates físicos pendentes.

## 5. Regras invioláveis de continuidade

- Manter os sete mundos, sua ordem, os sete fragmentos e os guardiões já definidos.
- Manter o plano de 42 fases: seis por mundo.
- Manter Dash; a decisão está registrada em ADR-001-DASH. Não remover nem retunar incidentalmente.
- Não inventar W1-L2 ou outras fases como se já existissem.
- Não converter sandbox em fase canônica.
- Não transformar valores provisórios de combate/física em balanceamento final.
- Não substituir a narrativa existente por outra premissa.
- Não alterar IDs estáveis de save sem migração.
- Não destruir dados de save ilegíveis automaticamente.
- Não integrar PR divergente antiga por conveniência.
- Não usar mudanças globais de arquitetura sem medir necessidade.

---

# PARTE II — IDENTIDADE E EXPERIÊNCIA

## 6. Identidade do produto

- Título: **BOLT · AVENTURA**.
- Gênero: plataforma 2D, ação e aventura, exploração e progressão narrativa.
- Engine: Godot 4.7.2 conforme projeto atual.
- Linguagem: GDScript.
- Destino: aplicativo Android empacotado.
- Orientação: paisagem.
- Campanha: sete mundos, seis fases por mundo, 42 fases planejadas.
- Estrutura: cinco fases de desenvolvimento local e uma sexta fase de guardião/fragmento/transição por mundo.
- Público técnico de referência: Android modesto; otimizar por medição, sem prometer 60 FPS universais.

## 7. Fantasia do jogador

O jogador controla um robô que desperta num mundo quebrado, descobre uma ligação com uma máquina temporal e gradualmente entende que sua jornada não é simplesmente recuperar objetos: é reconstruir relações entre realidades. O jogo deve alternar domínio físico, curiosidade, descoberta, tensão, alívio e recompensa.

A fantasia central deve aparecer em três escalas:
1. **Corporal:** BOLT responde com precisão ao toque; o jogador sente domínio do movimento.
2. **Local:** cada sala, plataforma, inimigo e segredo ensina algo sobre o mundo.
3. **Cósmica:** cada fragmento muda a leitura da história e a relação entre mundos.

## 8. Pilares de qualidade

### 8.1 Controle responsivo
Input touch não pode ser tratado como acessório. Multitouch, buffer, prioridade, cancelamento, reatribuição de ponteiros e perda de foco são requisitos de primeira classe. Nenhuma animação ou efeito pode tornar o botão de salto/Dash imprevisível.

### 8.2 Leitura justa
Perigos precisam de silhueta, contraste, antecipação e janela de resposta. A dificuldade deve nascer de decisão e execução, não de informação invisível.

### 8.3 Progressão ensinada
Toda mecânica nova segue a cadeia: apresentar → demonstrar → praticar → combinar → dominar. Chefes não exigem uma regra que nunca foi ensinada.

### 8.4 Identidade por mundo
Mudar apenas paleta não basta. Cada mundo deve diferir em composição, arquitetura, ritmo, materiais, inimigos, áudio, mecânica ambiental e linguagem de encontro.

### 8.5 Narrativa jogável
A história deve ser percebida por cenário, ação, reação, NPCs, chefes, objetos e mudanças de estado, não apenas por exposição textual.

### 8.6 Produção sustentável
Sistemas devem ser modulares onde isso reduz acoplamento real, mas não fragmentados em abstrações vazias. Preferir componentes testáveis e interfaces explícitas.

### 8.7 Qualidade Android
Priorizar frame pacing, latência de toque, memória, aquecimento, consumo de bateria, safe area, barras do sistema e estabilidade em retomada.

---

# PARTE III — NARRATIVA E UNIVERSO

## 9. Canon narrativo consolidado

O **Grande Colapso** rompeu o **Núcleo da Eternidade** e desestabilizou a continuidade entre universos. Em meio às ruínas de **Cybercore**, BOLT desperta sem memória. A máquina temporal **NEXO** desperta e se une a ele, permitindo atravessar eras e mundos. BOLT precisa recuperar sete fragmentos, cada um protegido pelo guardião de um mundo. Os fragmentos estão ligados à origem/função de NEXO, à ruptura do Núcleo e à finalidade de BOLT.

O antagonista central, **o Arquiteto**, deseja impor uma única realidade e eliminar a coexistência entre universos em nome de uma ordem absoluta. BOLT foi criado para preservar os universos. O conflito central opõe controle uniforme à coexistência. O final deve resolver esse conflito, dar consequência à reunião dos fragmentos e encerrar o arco principal sem depender de continuação.

## 10. Fragmentos e mundos — sequência fixa

| Ordem | Mundo | Fragmento | Guardião |
|---:|---|---|---|
| 1 | Cybercore | Origem | Guardião Tecnológico |
| 2 | Egito Antigo Futurista | Memória | Guardião Ancestral das Pirâmides |
| 3 | Speakeasy Aesthetic | Verdade | Mestre das Sombras |
| 4 | Dark Fantasy | Sombra | Rei Esquecido |
| 5 | Pôr do Sol em Cidade Medieval | Luz | Guardião da Coroa |
| 6 | Vaporwave / Las Vegas | Ilusão | Ilusionista Supremo |
| 7 | Natal / Nova York Futurista | Equilíbrio | Guardião do Inverno |

Não criar nomes próprios para guardiões sem decisão registrada. Títulos descritivos são a identificação disponível.

## 11. Macroestrutura dramática expandida — proposta autoral

A campanha deve operar como uma história em sete movimentos, sem transformar cada mundo em episódio desconectado:

1. **Despertar e pertencimento (Cybercore):** o jogador aprende a sobreviver, reconhece a ruína e estabelece o vínculo funcional BOLT–NEXO. A pergunta dramática é “o que sou e por que ainda funciono?”.
2. **Memória e vestígios (Egito Antigo Futurista):** o mundo preserva registros incompletos. O jogador percebe que memória não é cópia perfeita do passado; é também interpretação e responsabilidade.
3. **Verdade e aparência (Speakeasy Aesthetic):** informação é moeda, reputação é máscara e o jogador aprende a distinguir evidência, rumor e manipulação.
4. **Sombra e consequência (Dark Fantasy):** a campanha confronta aquilo que foi esquecido, negado ou abandonado. Sombra não equivale a maldade; revela custos e partes não resolvidas.
5. **Luz e responsabilidade (Pôr do Sol em Cidade Medieval):** esperança é apresentada como ação coletiva, não como solução mágica. A conquista exige proteger algo vulnerável.
6. **Ilusão e escolha (Vaporwave / Las Vegas):** o jogador questiona percepções e certezas; a ilusão pode proteger, seduzir ou esconder, e o espetáculo não deve substituir a verdade.
7. **Equilíbrio e coexistência (Natal / Nova York Futurista):** as ideias anteriores convergem. O desfecho confronta a promessa de ordem absoluta do Arquiteto com uma solução que preserva diferenças e aceita complexidade.

Esta estrutura é uma proposta de organização temática. Não altera a ordem nem o significado nominal dos fragmentos.

## 12. Regras de causalidade narrativa

Toda revelação importante deve responder:
- O que o jogador acreditava antes?
- Que evidência concreta muda essa crença?
- Qual personagem ou lugar é afetado?
- Que decisão ou objetivo muda em consequência?
- Como a revelação prepara uma pergunta posterior?
- O que permanece sem resposta de propósito?

Evitar coincidências convenientes, profecias que substituam agência, personagens que conheçam fatos sem fonte, viagem temporal sem custo narrativo, fragmentos que funcionem como chaves arbitrárias e antagonistas que mudem de motivação conforme a cena.

## 13. BOLT — ficha de direção

**Confirmado:** robô protagonista, desperta sem memória em Cybercore, função original ligada à preservação dos universos.

**Direção proposta:** personalidade comunicada principalmente por atuação visual; curiosidade observável, persistência, capacidade de aprender, humor físico discreto e empatia demonstrada por ações. Não torná-lo invulnerável emocionalmente nem excessivamente falante. O jogador deve reconhecer seu estado emocional por postura, ritmo, olhar/luzes, hesitação e resposta ao ambiente.

**Regras:** nunca fazer BOLT agir contra o objetivo central sem causa dramática; não atribuir memória recuperada sem gatilho; não confundir silêncio com ausência de personalidade; não transformar upgrades em mudança arbitrária de caráter.

## 14. NEXO — ficha de direção

**Confirmado:** máquina temporal que desperta e se une a BOLT; permite atravessar eras/mundos e está ligada aos fragmentos.

**Direção proposta:** NEXO funciona simultaneamente como companheiro, mecanismo de travessia, interface diegética e contraponto dramático. A presença visual deve ser reconhecível sem poluir a ação. Sua comunicação deve ter gramática consistente (pulsos, símbolos, som, projeção ou fala — definir em protótipo de apresentação). O vínculo deve evoluir de ferramenta desconhecida para relação de confiança construída por eventos observáveis.

**Limites obrigatórios:** NEXO não resolve obstáculos por conveniência; viagens precisam de regra; não pode abrir qualquer portal a qualquer momento; fragmentos não devem ser substituídos por combustível genérico; suas limitações devem ser compreensíveis e antecipadas.

## 15. O Arquiteto — ficha de direção

**Confirmado:** antagonista central que deseja uma única realidade, eliminando coexistência em nome de ordem absoluta.

**Direção proposta:** construir a ameaça por consequências antes de exposição direta. O jogador deve encontrar vestígios de sistemas que eliminaram divergências, ambientes excessivamente uniformes e personagens que foram protegidos de uma forma que também os privou de escolha. O Arquiteto deve possuir lógica interna, não razão moral automaticamente correta. Mostrar por que a proposta seduz pessoas assustadas pelo caos, e por que o custo de impor essa ordem é inaceitável.

**Não fazer:** vilão que deseja destruir tudo sem relação com o tema; monólogo que explica toda a trama; derrota resolvida apenas por força; redenção súbita sem preparação.

## 16. Personagens secundários e NPCs

Cada NPC nomeado deve possuir:
- função dramática e/ou função sistêmica;
- objetivo imediato;
- necessidade ou contradição;
- informação conhecida e desconhecida;
- estado de entrada e estado de saída;
- relação com o fragmento/mundo;
- falas com IDs e condições;
- resposta à progressão do jogador;
- linguagem visual e sonora;
- custo de produção e plano de reutilização.

Distribuir funções sem inflar elenco: guia, testemunha, sobrevivente, especialista, opositor local, comerciante/serviço apenas se houver sistema real, personagem recorrente e contraponto temático. Um NPC não deve existir apenas para entregar exposição que o cenário poderia comunicar.

## 17. Cutscenes e narrativa ambiental

Cada cutscene deve mudar pelo menos um elemento: objetivo, conhecimento, vínculo, risco, estado do mundo ou expectativa. Usar cenas curtas e controláveis, skip consistente, retorno correto ao gameplay, suporte a pausa e retomada. Narrativa ambiental deve usar composição, repetição transformada, objetos e consequências persistentes.

---

# PARTE IV — DIREÇÃO DOS SETE MUNDOS

## 18. Matriz expandida de identidade

### Mundo 1 — Cybercore / Origem
- **Identidade:** tecnologia em ruínas, estruturas industriais, energia residual, escala legível e vestígios de uma civilização interrompida.
- **Emoção:** estranhamento que evolui para propósito.
- **Paleta proposta:** metal frio, grafite, sinais de energia controlados e pontos quentes de alerta; preservar contraste de plataformas.
- **Gameplay proposto:** leitura de maquinaria, plataformas industriais, energia instável, circuitos ambientais e rotas de manutenção.
- **Narrativa:** despertar de BOLT, encontro com NEXO, primeiros indícios do Grande Colapso.
- **Guardião:** Guardião Tecnológico.
- **Risco de design:** excesso de ruído visual e estética genérica sci-fi.
- **Assinatura sonora:** pulsos industriais, motores distantes, ruído elétrico ritmado; música evolui de isolamento a movimento.

### Mundo 2 — Egito Antigo Futurista / Memória
- **Identidade:** arquitetura monumental, pedra trabalhada, metal cerimonial, astronomia, mecanismos e tecnologia ancestral.
- **Emoção:** reverência, descoberta e escala.
- **Gameplay proposto:** alinhamento de mecanismos, orientação por luz/sombra, salas de proporção monumental e leitura de símbolos.
- **Narrativa:** registros incompletos e memória coletiva; evitar transformar cultura histórica em decoração superficial.
- **Guardião:** Guardião Ancestral das Pirâmides.
- **Risco:** puzzles arbitrários, símbolos sem gramática e apropriação visual rasa.
- **Áudio:** percussão orgânica, ressonância mineral e texturas sintéticas discretas.

### Mundo 3 — Speakeasy Aesthetic / Verdade
- **Identidade:** interiores urbanos inspirados nos anos 1920, salões, bastidores, corredores, letreiros, geometria art déco e contrastes.
- **Emoção:** curiosidade, tensão social e ambiguidade.
- **Gameplay proposto:** rotas ocultas, observação de padrões, disfarces ambientais não dependentes de leitura textual extensa e encontros ritmados.
- **Narrativa:** rumores, reputação, segredos e evidências conflitantes.
- **Guardião:** Mestre das Sombras.
- **Risco:** confundir dificuldade com baixa visibilidade ou esconder regras essenciais.
- **Áudio:** jazz instrumental original em linguagem de época, baixo acústico, metais e percussão; evitar imitação de gravações existentes.

### Mundo 4 — Dark Fantasy / Sombra
- **Identidade:** fantasia sombria autoral, ruínas antigas, vegetação invasiva, arquitetura monumental e beleza ameaçada.
- **Emoção:** vulnerabilidade, respeito e confronto.
- **Gameplay proposto:** plataformas de risco calculado, terreno orgânico, luz como recurso de leitura e inimigos com telegraphs contrastantes.
- **Narrativa:** consequências esquecidas e custo das decisões.
- **Guardião:** Rei Esquecido.
- **Risco:** escuridão que prejudica leitura; inimigos que se confundem com cenário.
- **Áudio:** cordas graves, sopros, texturas ambientais e silêncio intencional.

### Mundo 5 — Pôr do Sol em Cidade Medieval / Luz
- **Identidade:** cidade medieval viva, muralhas, telhados, praças, oficinas, pontes e luz dourada de fim de tarde.
- **Emoção:** calor, comunidade e esperança responsável.
- **Gameplay proposto:** travessia de telhados, mecanismos comunitários, rotas verticais e proteção de espaços habitados.
- **Narrativa:** esperança como cooperação e responsabilidade.
- **Guardião:** Guardião da Coroa.
- **Risco:** parecer outro mundo de castelos genéricos ou repetir Dark Fantasy.
- **Áudio:** cordas, flautas, percussão leve e ambiente urbano acolhedor.

### Mundo 6 — Vaporwave / Las Vegas / Ilusão
- **Identidade:** neon, superfícies reflexivas, geometria, espetáculo urbano e arquitetura impossível, com hierarquia visual.
- **Emoção:** fascínio, desconfiança e vertigem controlada.
- **Gameplay proposto:** perspectiva cenográfica, plataformas que revelam estado real, rotas de aparência enganosa com regras comunicadas e desafios de observação.
- **Narrativa:** diferença entre percepção, desejo e realidade.
- **Guardião:** Ilusionista Supremo.
- **Risco:** flashes intensos, excesso de partículas, ilusão que quebra previsibilidade e acessibilidade.
- **Áudio:** synthwave/vaporwave original, motivos melódicos reconhecíveis e transições suaves.

### Mundo 7 — Natal / Nova York Futurista / Equilíbrio
- **Identidade:** cidade vertical futurista, neve, luzes natalinas, trânsito aéreo, interiores acolhedores e espaços públicos.
- **Emoção:** urgência, reunião e resolução.
- **Gameplay proposto:** síntese das habilidades anteriores, travessia urbana em múltiplas alturas, clima como camada visual sem ocultar colisões.
- **Narrativa:** coexistência, escolha e resolução do conflito.
- **Guardião:** Guardião do Inverno.
- **Risco:** sobrecarga de luzes/partículas e final que pareça fase sazonal desconectada.
- **Áudio:** motivos da campanha reorquestrados com timbres festivos sem cair em jingle genérico.

## 19. Diferenciação mensurável entre mundos

Cada mundo deve ter uma ficha de identidade com:
- 3 formas arquitetônicas dominantes;
- 3 materiais dominantes;
- 1 regra de composição de cenário;
- 1 família de perigos;
- 1 família de inimigos;
- 1 mecânica ambiental principal;
- 1 assinatura de áudio;
- 1 gesto visual do fragmento;
- 1 motivo recorrente de história;
- 1 elemento que deliberadamente não será usado para evitar repetição.

A diferença precisa ser percebida em silhueta monocromática e em escala reduzida de tela de celular. Cor não pode ser o único identificador.

---

# PARTE V — CAMPANHA, FASES E LEVEL DESIGN

## 20. Estrutura das 42 fases

Cada mundo tem seis fases planejadas:
1. entrada e descoberta;
2. aprendizagem e exploração;
3. combinação;
4. especialização;
5. preparação do guardião;
6. guardião, fragmento e transição.

A estrutura é uma macrofunção, não uma receita de layout. Variar fases horizontais, verticais, híbridas, arenas, travessias e espaços de exploração. Não repetir a mesma sequência com cenário recolorido.

## 21. Contrato de fase

Cada fase deve possuir:
- ID estável (ex.: W1-L1);
- objetivo primário e critério inequívoco de conclusão;
- objetivos opcionais sem bloquear campanha;
- briefing narrativo e mudança de estado;
- mapa de fluxo e grafo de rotas;
- ritmo por segmentos;
- mecânica principal e pré-requisitos;
- inimigos, perigos e encontros;
- checkpoints e política de respawn;
- segredos, recompensas e condições;
- orçamento de câmera e composição;
- telemetria de teste;
- orçamento de performance;
- critérios de acessibilidade;
- plano de QA e casos de falha.

## 22. Gramática de encontro

Todo encontro deve seguir:
- **sinalização:** o jogador percebe a situação antes do dano;
- **leitura:** identifica ameaça e comportamento;
- **decisão:** escolhe mover, saltar, Dash, atacar, esperar ou reposicionar;
- **execução:** a resposta é tecnicamente possível com touch;
- **feedback:** sucesso/falha é comunicado;
- **recuperação:** existe espaço para retomar controle, salvo exceções claramente ensinadas.

Evitar spawn de inimigo em cima do jogador, projéteis fora de tela sem indicação, dano de contato inevitável, lock de animação excessivo e checkpoints que reaparecem dentro de ameaça.

## 23. Plataformas e geometria

- Usar medidas consistentes em relação à caixa de colisão do player.
- Diferenciar plataforma sólida, unidirecional, móvel, temporária e perigosa.
- Não usar arte visual como substituto de colisão bem definida.
- Validar folga para salto, dash e pulo duplo conforme física real.
- Verificar cantos, paredes, teto, inclinações e transições de câmera.
- Não exigir precisão de pixel em touch.
- Todo caminho obrigatório deve ter rota alcançável e sem softlock.

## 24. Checkpoints, morte e retomada

Checkpoint deve comunicar ativação, posição de respawn, estado restaurado e persistência. Definir explicitamente o que reseta: inimigos, pickups, portas, objetos móveis, vida, recursos, flags e fragmentos. Testar morte durante cutscene, transição, dano, queda, chefe e pause. Nenhum save deve registrar estado impossível.

## 25. Segredos e recompensas

Segredos devem recompensar observação, exploração ou domínio, sem esconder a única rota de progresso. Toda recompensa deve ter categoria, função, feedback, persistência, limite, tela de inventário (se existir) e consequência de design. Evitar moedas sem economia real ou collectibles sem propósito.

---

# PARTE VI — MOVIMENTO, COMBATE E SISTEMAS

## 26. Movimento de BOLT

Especificar estados, transições e prioridade para:
- idle, run, rise, fall, land;
- salto, pulo duplo se aprovado no build atual;
- Dash (preservar ADR-001-DASH);
- knockback e invulnerabilidade;
- dano, derrota, respawn e recuperação;
- interação e cutscene;
- pause e perda/retorno de foco.

Cada ação precisa definir início, duração, cancelamento, consumo de input, término e prioridade. Não ajustar física sem teste comparativo. A curva de aceleração e desaceleração deve manter previsibilidade. Coyote time e input buffer precisam ter limites documentados e testes de borda.

## 27. Combate

O combate deve ser legível, responsivo e apropriado à tela touch. Cada arma define:
- fantasia e função;
- cadência, alcance e janela de uso;
- projétil/efeito;
- custo ou cooldown;
- dano e relação com defesa inimiga;
- feedback de disparo/acerto;
- limites de instâncias;
- interação com paredes/terreno;
- acessibilidade e legibilidade;
- testes de regressão.

Armas já mencionadas no projeto de design: Pistola Crono, Tríplice Prisma e Laser Nexo. Não presumir que todas estejam implementadas ou balanceadas. Valores atuais da Pistola Crono são provisórios.

## 28. Inimigos

Meta mínima de design: cinco arquétipos distintos por mundo. Arquétipo significa decisão diferente exigida do jogador, não apenas cor ou vida adicional. Para cada um, definir percepção, locomoção, estados, telegraph, ataque fictício, contra-jogo, reação, limites simultâneos e comportamento em terreno. Evitar IA complexa sem impacto claro na experiência.

## 29. Chefes

Cada chefe deve ter:
- identidade temática e narrativa;
- arena com limites compreensíveis;
- leitura de fases;
- padrões com telegraph;
- janelas de resposta;
- adaptação a touch;
- transições sem estados inválidos;
- checkpoints e retry justos;
- feedback de dano;
- vulnerabilidade explicada visualmente;
- conclusão ligada ao fragmento.

O chefe final de mundo testa o que foi ensinado naquele mundo e não deve exigir habilidade inédita sem tutorialização.

## 30. NEXO e progressão

A progressão pode incluir capacidades, modificadores, recursos ou ferramentas, mas cada desbloqueio deve responder:
- que problema de gameplay resolve?
- que novas rotas permite?
- como é ensinado?
- como altera encontros antigos?
- como evita tornar habilidades anteriores obsoletas?
- como é persistido e migrado?
- como pode ser testado?

Não criar árvore de habilidades inflada sem loop de decisão real.

---

# PARTE VII — UI, UX, ACESSIBILIDADE E ANDROID

## 31. Interface

Menu, abertura, tutorial, HUD, pausa, configurações, seleção de fase/progresso, inventário se justificado e resultados devem compartilhar linguagem visual e hierarquia. A UI deve explicar estado, não competir com ação.

## 32. Controles touch

Requisitos:
- multitouch simultâneo;
- pressionar/soltar consistente;
- identificador de ponteiro estável;
- reatribuição após cancelamento;
- buffer de ações;
- limpeza de input em pause, foco e mudança de cena;
- botões com feedback visual/sonoro;
- área segura;
- nenhuma ação essencial dependente de gesto minúsculo;
- teste de salto + Dash + ataque simultâneos;
- tolerância a frame pacing irregular.

## 33. Safe area e sistema Android

A experiência deve respeitar o requisito aprovado de imersão e cobertura de barras conforme ADR e comportamento real do Android. Validar em aparelho a barra de status, navegação, recortes, gestos de borda, teclado, perda/retorno de foco, rotação bloqueada em paisagem e retomada. Não assumir que configuração de projeto garante comportamento em todos os fabricantes.

## 34. Acessibilidade

Planejar:
- escala e contraste de texto;
- redundância de cor + forma + ícone;
- redução de screen shake e flashes;
- volume separado;
- controle de música/efeitos;
- opção de pular cutscene;
- dificuldade configurável se aprovada;
- controles touch ajustáveis;
- instruções curtas e contextualizadas;
- não usar flashes repetitivos de alta intensidade.

## 35. Performance e estabilidade

Medir frame time p50/p95/p99, picos de GC quando aplicável, memória, quantidade de nós, draw calls, partículas, instâncias de projéteis, tempo de carregamento, temperatura e consumo. Fazer perfil em cenas representativas e em hardware real. Preferir pooling somente quando medição provar benefício e lifecycle for seguro. Evitar alocação por frame em loops críticos; liberar referências; limitar partículas e inimigos; usar carregamento assíncrono com estados de loading previsíveis.

Metas iniciais devem ser classificadas como **alvo**, não como resultado. Registrar modelo, versão Android, build, duração, temperatura inicial/final e condições de teste.

---

# PARTE VIII — ARQUITETURA E DADOS

## 36. Arquitetura de projeto

Manter separação clara entre:
- core e bootstrap;
- fluxo de cenas;
- player/input;
- combate;
- inimigos;
- campanha/progressão;
- save/load;
- UI;
- conteúdo de fase;
- ferramentas e testes.

Criar abstrações somente quando houver mais de um consumidor real ou contrato de extensão justificado. Evitar singleton para estado local, dependências circulares, referências frágeis por caminho e scripts monolíticos. Preferir IDs estáveis, sinais tipados, recursos de dados e composição.

## 37. SaveSystem

Persistência deve ser versionada, validada, tolerante a falhas e migrável. Separar envelope técnico de domínios de gameplay. Nunca apagar automaticamente um save ilegível; preservar backup e comunicar falha. Testar corrupção, versão futura, campo ausente, tipos inválidos, gravação interrompida, migração e reset seletivo. Não armazenar objetos runtime.

## 38. Fluxo de cenas

Transições devem bloquear concorrência, limpar input, apresentar loading quando necessário, reportar falhas e permitir recuperação. Testar troca durante pause, morte, cutscene e retorno de background. Não manter referências a nós liberados.

## 39. Observabilidade

Logs devem distinguir erro, warning e informação; não inundar release. Erros de gameplay precisam conter contexto suficiente sem dados pessoais. CI deve executar importação, análise, testes e validação documental. Artefatos de build precisam ser rastreáveis por commit.

---

# PARTE IX — QA, TESTES E CRITÉRIOS DE ACEITAÇÃO

## 40. Pirâmide de testes

- **Unitários:** regras puras, estado, cálculos, serialização.
- **Integração:** interação entre componentes reais.
- **Cena:** carregamento, nós obrigatórios, sinais, recursos.
- **Regressão:** bug previamente observado.
- **Fluxo:** início, pausa, derrota, retry, checkpoint, conclusão, save.
- **Dispositivo:** toque, safe area, desempenho, retomada, instalação e exportação.

Testes sintéticos não substituem toque físico. Testes headless não substituem validação visual.

## 41. Matriz mínima de regressão

Executar após mudanças relevantes:
- abrir menu e iniciar Nova Jornada;
- Continuar com save válido;
- Continuar indisponível quando destino não existe;
- abrir e pular cinemática;
- tutorial com mensageiro;
- mover/saltar/Dash/atacar;
- multitouch e reatribuição de ponteiro;
- pausar e retomar;
- perder foco e retornar;
- receber dano e respawn;
- checkpoint e persistência;
- pickup com vida incompleta e cheia;
- derrotar inimigo;
- concluir fase;
- save corrompido e backup;
- trocar cena sem input preso.

## 42. Gates de qualidade

- **G0 — Repositório íntegro:** projeto importa, estrutura e CI estáveis.
- **G1 — Controle:** movimento, touch, pausa e safe area confiáveis.
- **G2 — Vertical slice:** uma experiência de campanha completa, com começo, combate, checkpoint, recuperação, objetivo e save.
- **G3 — Conteúdo replicável:** pipeline de fase/inimigo/chefe validado.
- **G4 — Campanha:** sete mundos e 42 fases produzidos e testados.
- **G5 — Android release:** exportação, instalação, dispositivo, estabilidade, performance, áudio, UX e checklist de publicação.

Não declarar gate concluído sem evidências.

---

# PARTE X — DIREÇÃO DE ARTE E ÁUDIO

## 43. Arte

Cada asset deve ter função de leitura e identidade. Definir silhueta, escala, pivot, estados, atlas, compressão, resolução, contraste, animações e orçamento. Evitar placeholders confundidos com final. Reutilizar famílias visuais sem apagar identidade dos mundos.

## 44. Animação

BOLT precisa de estados legíveis para antecipação, ação, impacto, recuperação e emoção. Animação nunca deve atrasar input essencial. Definir blend e cancel windows. Inimigos e chefes precisam comunicar intenção antes de causar dano.

## 45. Áudio

Criar linguagem original para tema principal, mundo, chefe, fragmento, interface e feedback. Música adaptativa deve ter transições sem cortes abruptos e sem competir com efeitos críticos. Não usar gravações, melodias ou assets sem licença adequada. Documentar fontes e licenças.

---

# PARTE XI — PRODUÇÃO E EXPANSÃO

## 46. Pacotes de criação

Dividir a criação em pacotes auditáveis:
1. narrativa macro e cronologia;
2. personagens e relações;
3. atlas de mundo;
4. bíblia de mecânicas;
5. gramática de inimigos;
6. gramática de chefes;
7. padrão de fase;
8. UI/UX;
9. arte e animação;
10. áudio;
11. arquitetura e dados;
12. QA e performance;
13. pipeline Android;
14. localização e acessibilidade;
15. produção, riscos e critérios de aceite.

Cada pacote deve conter visão, regras, exemplos, anti-exemplos, dependências, riscos, protótipo mínimo e critérios de aprovação.

## 47. Regras de expansão criativa

É permitido propor:
- personagens secundários;
- histórias locais;
- conflitos e dilemas;
- mecânicas ambientais;
- inimigos e padrões de chefe;
- segredos e recompensas;
- diálogos e cenas;
- história pregressa e conexões temáticas;
- organização detalhada de fases;
- novos documentos e divisões de criação.

Toda criação nova precisa ser coerente com o canon consolidado, classificada como proposta, vinculada ao tema do mundo e testável em gameplay. Evitar lore ornamental sem consequência. Não inventar nomes de guardiões, nomes oficiais de fases ou detalhes que contradigam fontes sem registrar a mudança.

## 48. Definition of Ready

Uma tarefa só está pronta para implementação quando:
- objetivo está claro;
- comportamento atual foi inspecionado;
- arquivos impactados são conhecidos;
- contrato e critérios de aceite estão escritos;
- riscos e rollback estão identificados;
- testes relevantes foram escolhidos.

## 49. Definition of Done

Uma tarefa só está concluída quando:
- implementação existe;
- testes relevantes passam;
- regressões conhecidas são cobertas;
- documentação está sincronizada;
- CI relevante passa;
- PR e commit estão identificados;
- limitações e testes não executados estão declarados;
- main foi atualizada somente após integração confirmada.

## 50. Próxima prioridade técnica

O item histórico sobre a alteração síncrona de `Area2D.monitoring` no coletável de vida já foi resolvido e integrado pela PR #37; não repetir essa tarefa. A PR #34 já criou W1-L2 como blockout jogável, portanto não afirmar que essa fase inexiste nem recriá-la. A correção de estado inicial do `TimedEnergyGate` foi integrada pela PR #47, e a matriz operacional de 26 etapas foi integrada pela PR #48. **Prioridade operacional atual:** consultar `docs/production/stage-status.md`, `docs/production/implementation-tracker.md` e `docs/production/26-stage-traceability-matrix.md`; concluir a revisão de requisitos da Etapa 02, classificar canon/propostas/lacunas e selecionar a próxima unidade que avance o Gate 1 usando W1-L1/W1-L2 e os sistemas reais existentes. Não reiniciar o projeto, não reimplementar trabalho já integrado e não criar fases fictícias.

---

# PARTE XII — FORMATO DE ENTREGA

## 51. Relatório por unidade

Toda entrega técnica deve informar:
- objetivo;
- diagnóstico;
- decisão;
- arquivos alterados;
- comportamento novo;
- testes executados e resultados;
- CI e commit/PR;
- riscos residuais;
- validações ainda não realizadas;
- próxima unidade concreta.

## 52. Regra final

A qualidade de BOLT · AVENTURA será julgada pelo jogo executável e pela experiência real, não pelo tamanho da documentação. A documentação deve tornar o desenvolvimento mais coerente e profundo; a implementação deve provar que essas decisões funcionam. Expanda com ambição, implemente com disciplina e nunca confunda intenção com evidência.
