# BOLT · AVENTURA

> **AVISO DE AUTORIDADE — CONTEXTO HISTÓRICO (28/11/2026):** Este dossiê foi consolidado quando o projeto adotava Godot 4.7.2/GDScript. A decisão posterior e soberana determina reconstrução clean-start em HTML5, CSS3, JavaScript ES Modules, Canvas 2D e Vite. Conteúdo narrativo, de produto e requisitos ainda compatível permanece como referência; instruções Godot, estado de implementação, paths, comandos, métricas e afirmações de engine estão superados e não podem orientar a implementação ativa. Consulte `MASTER_DIRECTIVE.md`, `AGENTS.md`, `docs/PROJECT_CONTEXT_HTML5.md` e o estado atual do GitHub. O histórico Git preserva o original integral.

---

# DOSSIÊ MESTRE DE CONTEXTO, BÍBLIA TÉCNICA E ENGENHARIA DE PRODUÇÃO
## Documento de referência integral para continuidade do desenvolvimento por agentes de engenharia de jogos 2D

**Identificador:** BOLT-MASTER-CONTEXT  
**Versão documental:** 1.0  
**Data de consolidação:** 26 de novembro de 2026  
**Projeto:** BOLT · AVENTURA  
**Repositório de referência:** `jyanzy19-yml/new-bolt-aventura`  
**URL:** https://github.com/jyanzy19-yml/new-bolt-aventura  
**Engine:** Godot 4.7.2 (versão declarada/fixada no projeto; confirmar no ambiente antes de usar APIs)  
**Linguagem:** GDScript  
**Gênero:** plataforma, ação e aventura 2D  
**Plataforma de produto:** aplicativo Android empacotado  
**Orientação:** paisagem (landscape)  
**Público deste documento:** engenheiros de gameplay, arquitetos de software, technical designers, level designers, artistas técnicos, especialistas em UX, QA engineers, engenheiros de performance mobile e agentes de desenvolvimento.

---

# 0. PROPÓSITO, ESCOPO E REGIME DE AUTORIDADE

Este documento constitui uma camada de contexto consolidado para orientar a compreensão, análise, manutenção e evolução de BOLT · AVENTURA. Seu propósito é reduzir perda de contexto entre sessões, impedir regressões arquiteturais, preservar decisões aprovadas e fornecer a um agente de desenvolvimento uma visão sistêmica do produto e do repositório.

Este documento não substitui os arquivos especializados do GitHub. Ele funciona como um mapa de alto nível, um dossiê de continuidade e um índice técnico interpretativo. Quando houver diferença entre este documento e o estado real do repositório, prevalecem o estado verificável do código, os registros de decisão aprovados e a hierarquia estabelecida em `MASTER_DIRECTIVE.md`.

O projeto deve ser tratado como um produto de software interativo de longo prazo, não como um protótipo descartável. A missão é entregar uma aventura 2D completa, coesa, jogável, tecnicamente sustentável e instalável em Android.

## 0.1. Princípio de evidência

Toda informação relevante deve ser classificada em uma das seguintes categorias:

- **CANON APROVADO:** informação narrativa, criativa ou de produto confirmada pelo usuário ou registrada como decisão aprovada.
- **REQUISITO:** obrigação técnica, de experiência, plataforma, qualidade ou produção.
- **IMPLEMENTADO:** comportamento ou estrutura existente no projeto executável, confirmado por inspeção de cenas, scripts, configurações ou recursos.
- **VALIDADO:** comportamento aprovado por teste reproduzível, com ambiente, versão, execução e resultado documentados.
- **PROPOSTA:** alternativa criativa ou técnica ainda não aprovada como canon.
- **PROVISÓRIO:** conteúdo implementado para viabilizar desenvolvimento, mas sujeito a revisão de balanceamento, apresentação ou conteúdo.
- **A DEFINIR:** lacuna que não deve ser preenchida por suposição quando a decisão alterar canon, arquitetura, escopo ou experiência aprovada.
- **PENDENTE:** trabalho reconhecido que ainda não foi concluído.
- **DESCARTADO:** decisão ou proposta rejeitada; não reintroduzir sem autorização.

É proibido transformar a presença de um arquivo em prova de funcionalidade. Uma cena pode existir sem estar integrada ao fluxo principal; um script pode existir sem ser instanciado; um teste estrutural pode passar sem comprovar qualidade visual; uma exportação de APK pode ocorrer sem que o aplicativo tenha sido instalado em aparelho físico.

## 0.2. Hierarquia de autoridade

Em caso de conflito, aplicar a seguinte ordem:

1. Instrução explícita mais recente do usuário para a tarefa atual.
2. Decisões aprovadas e registradas em `docs/decisions/` e ADRs.
3. Canon consolidado nas bíblias de `docs/game-design/`.
4. Requisitos e contratos técnicos aprovados em `docs/technical/`.
5. `MASTER_DIRECTIVE.md`, `CLAUDE.md`, `AGENTS.md` e diretivas operacionais.
6. Roadmap, tracker, QA e documentos de produção.
7. Propostas, skills, exemplos externos e recomendações de agentes.

Nenhum agente consultivo, skill, arquivo importado, biblioteca externa ou sugestão automática tem autoridade para substituir uma decisão do usuário.

## 0.3. Fontes de verdade do repositório

O agente deve consultar os arquivos originais antes de executar tarefas substanciais:

- `MASTER_DIRECTIVE.md`: missão, hierarquia, fontes de verdade e regras de execução.
- `CLAUDE.md`: orientação operacional para Claude Code e agentes compatíveis.
- `AGENTS.md`: instruções gerais de agentes, segurança, workflow e continuidade.
- `docs/README.md`: índice documental.
- `docs/decisions/`: decisões arquiteturais e de produto.
- `docs/game-design/`: bíblias de game design.
- `docs/technical/`: especificações técnicas.
- `docs/production/`: roadmap, status, continuidade, tracker, gates e colaboração.
- `docs/qa/`: matriz de testes e critérios de validação.
- `.claude/skills/`: skills especializadas.
- `.claude/agents/`: revisores consultivos read-only.
- `.claude/commands/`: comandos operacionais.

A leitura deste dossiê nunca elimina a obrigação de consultar a documentação específica da tarefa.

---

# 1. IDENTIDADE E VISÃO DO PRODUTO

## 1.1. Identidade

**BOLT · AVENTURA** é um jogo original 2D de plataforma, ação e aventura, concebido para uma experiência mobile Android em orientação paisagem. O produto combina exploração lateral, movimentação de precisão, combate, progressão por mundos, narrativa de ficção científica, personagens robóticos, desafios ambientais, encontros com chefes e uma estrutura de campanha de longa duração.

O projeto utiliza Godot 4.7.2 e GDScript. O repositório contém um projeto executável inicial, cenas, scripts, recursos, testes automatizados, especificações, documentação narrativa, ferramentas de produção e instruções para agentes.

A fundação técnica já existe. O trabalho futuro deve evoluir essa base de forma incremental, sem recriar o projeto, duplicar sistemas existentes ou substituir a arquitetura sem justificativa e aprovação.

## 1.2. Objetivo final

Entregar uma experiência completa com:

- campanha narrativa fechada;
- sete mundos distintos;
- 42 fases planejadas, seis por mundo;
- cinco fases de progressão/exploração e uma sexta fase de guardião/fragmento/transição por mundo, conforme o blueprint aprovado;
- inimigos com arquétipos e comportamentos relevantes;
- NPCs funcionais;
- chefes com padrões legíveis, fases e contra-jogo;
- movimentação precisa e consistente;
- Dash preservado como mecânica aprovada;
- combate e arsenal conforme as especificações;
- tutorial integrado ao gameplay;
- cutscenes, diálogos e eventos narrativos;
- checkpoints e progressão persistente;
- menus, HUD, configurações, pausa, vitória, derrota e créditos;
- áudio, música, feedback visual e identidade artística;
- suporte robusto a touch e multitouch;
- carregamento e transições confiáveis;
- exportação Android, instalação e validação em dispositivos reais.

A meta de produção não é apenas obter um APK. O APK deve conter uma campanha funcional, com conteúdo suficiente, qualidade visual consistente, controles confiáveis e sistemas integrados.

## 1.3. Plataforma e restrições

- Produto final: aplicativo Android empacotado.
- Não tratar navegador desktop ou navegador móvel como plataforma de produto.
- Engine: Godot 4.x, versão de referência 4.7.2.
- Linguagem: GDScript.
- Orientação: paisagem.
- Entrada: touch prioritário, com suporte a teclado apenas como conveniência de desenvolvimento quando aplicável.
- Hardware de referência: Android com aproximadamente 4 GB de RAM e MediaTek Helio G99 ou inferior.
- Meta de desempenho: estabilidade próxima de 60 FPS quando o dispositivo, a temperatura, a cena e a carga permitirem.
- Não prometer 60 FPS universal.
- Preservar qualidade visual, física, resposta dos controles e conteúdo durante otimizações, salvo decisão específica.

## 1.4. Pilares de experiência

1. **Controle responsivo:** o jogador deve confiar na resposta de movimento, salto, Dash e ações essenciais.
2. **Legibilidade:** perigos, inimigos, projéteis, plataformas e telegraphs devem ser compreensíveis.
3. **Progressão significativa:** cada mundo deve introduzir, combinar e aprofundar vocabulário de gameplay.
4. **Identidade por mundo:** cenário, paleta, áudio, arquitetura, inimigos, obstáculos e ritmo não podem ser meras trocas cosméticas.
5. **Integração narrativa:** a história deve avançar por eventos, ambientes, personagens e consequências.
6. **Qualidade mobile:** HUD, touch targets, multitouch, safe areas, lifecycle e performance devem ser tratados como requisitos centrais.
7. **Confiabilidade:** checkpoints, salvamento, carregamento e retomada devem proteger o progresso.
8. **Produção rastreável:** cada requisito deve ter implementação, teste e estado explícitos.

---

# 2. UNIVERSO NARRATIVO E CANON

## 2.1. Premissa central aprovada

A história acompanha BOLT, um robô que desperta em um mundo destruído. Nesse cenário, ele encontra uma máquina temporal chamada NEXO, que se une a ele. A partir dessa união, BOLT passa a atravessar diferentes eras e mundos para recuperar sete fragmentos associados ao equilíbrio dos universos.

A campanha está ligada ao Grande Colapso, ao Núcleo da Eternidade, à união entre BOLT e NEXO e ao mistério dos fragmentos. A recuperação dos sete fragmentos é necessária para restaurar o equilíbrio entre os universos.

O antagonista central registrado nas bíblias é o Arquiteto. A natureza completa de sua participação, motivações, revelações e caracterização deve ser obtida diretamente das fontes narrativas aprovadas, sem improvisação apresentada como canon.

## 2.2. Elementos narrativos que devem permanecer coerentes

- BOLT é o protagonista robótico.
- NEXO é a máquina temporal que se une a BOLT.
- O Grande Colapso é um evento central da história.
- O Núcleo da Eternidade está relacionado à estrutura temporal/cósmica da narrativa.
- Existem sete mundos.
- Existem sete fragmentos ligados ao equilíbrio dos universos.
- Cada mundo culmina em um encontro de guardião/chefe associado à progressão do fragmento.
- O Arquiteto integra o núcleo da mitologia narrativa.
- A campanha deve ter início, desenvolvimento, clímax e conclusão.

Não inventar nomes próprios de guardiões quando as fontes aprovadas usam títulos descritivos. Não criar revelações, relações, diálogos definitivos ou motivações como se já estivessem aprovados quando os documentos mantêm esses pontos como pendentes.

## 2.3. Tratamento de lacunas narrativas

O projeto distingue canon de conteúdo provisório. Lacunas secundárias podem receber propostas temporárias, desde que identificadas como provisórias e isoladas para revisão. Lacunas que alterem o significado do Grande Colapso, a identidade de BOLT/NEXO, a ordem dos mundos, a natureza dos fragmentos ou o desfecho exigem consulta à fonte aprovada e, se necessário, decisão do usuário.

A narrativa deve ser implementável. Diálogos, cutscenes, flags, eventos, objetivos e consequências precisam ter contratos de dados e comportamento definidos. Não construir uma história apenas em texto desconectado do jogo.

## 2.4. Estrutura narrativa e progressão

A sequência macro deve respeitar a Bíblia dos Mundos e o blueprint de 42 fases. O fluxo geral envolve:

1. apresentação do colapso e do estado do universo;
2. despertar de BOLT;
3. descoberta e união com NEXO;
4. tutorial contextualizado;
5. entrada na campanha;
6. exploração progressiva dos sete mundos;
7. aquisição dos fragmentos;
8. revelações e escalada dramática;
9. confronto de clímax;
10. resolução e conclusão.

Os detalhes de cada ato, cena e mundo devem ser lidos em:
- `docs/game-design/01-narrative-bible.md`;
- `docs/game-design/02-world-bible.md`;
- `docs/game-design/03-character-bible.md`;
- `docs/game-design/EXPANDED-NARRATIVE-DOSSIER.md`;
- `docs/game-design/EXPANDED-42-LEVEL-CAMPAIGN-BLUEPRINT.md`.

## 2.5. Cutscenes, diálogos e NPCs

Cutscenes devem ter função dramática ou contextual clara. Devem ser puláveis e, quando apropriado, revisáveis. A abertura já possui um storyboard funcional de quatro páginas registrado no histórico de produção, mas isso não deve ser confundido com uma cinemática final animada.

NPCs precisam ter finalidade de gameplay, narrativa ou orientação. Um NPC não deve ser considerado funcional apenas por possuir sprite ou caixa de diálogo. A implementação pode exigir:
- identificação estável;
- área de interação;
- estados de disponibilidade;
- diálogos e ramificações;
- flags narrativas;
- condições de progressão;
- resposta visual/sonora;
- persistência de eventos quando necessária.

O robô mensageiro usado no tutorial foi descrito como provisório; não inferir que sua personalidade, nome ou história estejam canonizados.

---

# 3. CAMPANHA, MUNDOS E LEVEL DESIGN

## 3.1. Escala de campanha

O escopo macro aprovado é de sete mundos e 42 fases. A estrutura de produção prevê seis fases por mundo, com progressão/exploração nas primeiras cinco e encontro culminante de guardião/fragmento na sexta, conforme o blueprint.

Meta mínima documentada: cinco arquétipos de inimigo significativamente distintos por mundo. Essa meta não deve ser atendida por simples alteração de cor ou valores numéricos. Arquétipos devem diferir em comportamento, papel de combate, leitura, mobilidade, alcance, vulnerabilidades ou interação com o espaço.

## 3.2. Identidade de mundo

Cada mundo deve ter:
- identidade visual própria;
- paleta e iluminação coerentes;
- arquitetura ambiental específica;
- vocabulário de plataformas e obstáculos;
- hazards e interações;
- ritmo e curva de dificuldade;
- identidade sonora;
- inimigos e encontros adequados;
- NPCs ou elementos narrativos quando previstos;
- segredos e recompensas;
- chefe/guardião com linguagem própria;
- conexão narrativa com o fragmento correspondente.

Não produzir sete mundos que sejam o mesmo conjunto de plataformas com paletas diferentes.

## 3.3. Padrão de construção de fase

Cada fase deve ser documentada por uma matriz rastreável contendo, no mínimo:

- `world_id`;
- `level_id`;
- função narrativa;
- objetivo primário;
- objetivos secundários;
- mecânicas introduzidas;
- mecânicas combinadas;
- inimigos e arquétipos;
- hazards;
- checkpoints;
- itens e segredos;
- eventos e flags;
- assets necessários;
- áudio e música;
- curva de dificuldade;
- critérios de conclusão;
- critérios de QA;
- dependências;
- estado de produção.

A fase deve possuir fluxo espacial, ritmo, leitura e variação. O jogador precisa aprender, experimentar, dominar e combinar mecânicas. O level design deve evitar dificuldade baseada apenas em punição, surpresa injusta ou precisão incompatível com touch.

## 3.4. Boss design

Cada chefe deve apresentar:
- identidade temática vinculada ao mundo;
- arena e composição espacial próprias;
- telegraphs legíveis;
- padrões distinguíveis;
- janelas de contra-ataque;
- fases ou escalada de comportamento;
- feedback de dano;
- critérios de vitória;
- recompensa narrativa/de progressão;
- transição pós-encontro;
- testes de estados e regressão.

Não implementar chefes como inimigos com vida elevada e ataque repetitivo. A dificuldade deve emergir de leitura, posicionamento, timing, domínio de mecânicas e adaptação.

## 3.5. Conteúdo em blockout versus conteúdo final

W1-L1 e W1-L2 estão registrados como blockouts. Blockout é etapa legítima de produção para validar geometria, fluxo e mecânicas, mas não equivale a fase final. Os assets, áudio, composição, polimento, balanceamento, playtest e QA final permanecem gates separados.

O sandbox de movimento é uma ferramenta/cena de desenvolvimento, não uma das 42 fases da campanha.

---

# 4. PERSONAGEM, MOVIMENTO E GAMEPLAY

## 4.1. BOLT como entidade jogável

BOLT deve ser tratado como um sistema de gameplay composto por:
- estado de movimento;
- estado de combate;
- estado de dano/recuperação;
- animação e apresentação;
- entrada do jogador;
- colisões;
- interação com o mundo;
- progressão/habilidades;
- feedback de ações.

A implementação deve evitar que UI, persistência, câmera e lógica de campanha se tornem dependências internas do controlador do jogador sem necessidade.

## 4.2. Movimento

A fundação atual possui implementação parcial de:
- corrida/movimento horizontal;
- salto variável;
- pulo duplo provisório;
- coyote time;
- jump buffer;
- Dash;
- colisões e aterrissagem.

Os parâmetros atuais devem ser consultados nos scripts e recursos reais. Não assumir valores de tuning a partir de protótipos HTML antigos. O projeto atual é Godot/GDScript e suas fontes executáveis são a referência.

## 4.3. Dash — decisão aprovada

Dash é uma mecânica aprovada e deve permanecer no jogo. A decisão está registrada em `docs/production/ADR-001-DASH.md`.
Regras:
- não remover Dash;
- não substituir sua implementação por uma versão genérica;
- preservar Input Map, controles e testes existentes;
- não retunar duração, velocidade, cooldown, alcance ou comportamento sem tarefa específica;
- qualquer alteração deve ser isolada, justificada e coberta por regressões;
- garantir que o controle touch continue confiável.

## 4.4. Combate

O estado de implementação documentado inclui uma base inicial de combate:
- componente reutilizável de vida/dano (`BoltHealth`);
- controlador de combate (`BoltCombat`);
- projétil `ChronoProjectile`;
- alvo de treinamento (`BoltTrainingTarget`);
- Pistola Crono básica;
- botão touch de tiro;
- lição de ataque no tutorial.

Parâmetros de cadência, dano, velocidade e alcance foram descritos como provisórios. O alvo estático é um alvo de treino, não um inimigo completo da campanha.

O escopo maior inclui armas, seleção, inimigos, IA, dano ao jogador, feedback, chefes e progressão de arsenal, conforme as bíblias. O documento de gameplay deve ser consultado antes de definir comportamento final.

## 4.5. Inimigos e IA

O inimigo-base de patrulha Cybercore é provisório. Não confundir a existência de um script/cena com um ecossistema de IA completo.

A arquitetura de IA deve permitir:
- estados explícitos;
- percepção e detecção;
- navegação/steering quando aplicável;
- telegraphs;
- ataque e recuperação;
- dano e morte;
- reação a colisões;
- variação de arquétipos;
- integração com level design;
- testes de transições e edge cases.

As skills de `game-ai`, `enemy-ai` e documentos relacionados podem servir de referência técnica, mas os contratos do projeto e a compatibilidade Godot devem ser respeitados.

## 4.6. Feedback e game feel

O projeto precisa de feedback audiovisual coerente para:
- salto e aterrissagem;
- Dash;
- disparo;
- acerto;
- dano recebido;
- invulnerabilidade;
- coleta;
- checkpoint;
- interação;
- objetivo concluído;
- derrota/vitória;
- transição de fase.

Feedback não deve comprometer legibilidade, performance ou acessibilidade. Efeitos devem ter limites de emissão, duração e custo.

---

# 5. ANDROID, TOUCH, DISPLAY E UX

## 5.1. Android como plataforma de produto

Toda decisão de UX, arquitetura, performance, input e release deve considerar o aplicativo Android empacotado. Não desenvolver a experiência principal para navegador.

## 5.2. Orientação e apresentação

A orientação do jogo é paisagem. A política de barras do sistema, modo imersivo, fullscreen e safe areas está registrada em ADRs e documentos técnicos. Não alterar a política de status bar/navigation bar por preferência estética ou suposição.

A implementação deve respeitar recortes, áreas seguras e regiões de gestos. A área útil de gameplay deve ser calculada de forma consistente com a configuração real do dispositivo.

## 5.3. Touch e multitouch

Touch é sistema central, não acessório. A arquitetura deve considerar:
- identificadores de ponteiros;
- press/release;
- multitouch simultâneo;
- cancelamento de toque;
- reatribuição de índices;
- perda de foco;
- pausa e suspensão;
- retomada;
- troca de cena;
- limpeza de ações pendentes;
- prevenção de input preso ou fantasma.

Ações essenciais, especialmente movimento, salto e Dash, não podem perder eventos durante pequenos engasgos. O buffer de ações deve ser determinístico e coberto por testes.

O projeto possui `ActionBuffer`, `Actions`, `TouchButton` e `TouchControls`. O ciclo de vida Android recebeu correção para limpar edges pendentes em pausa, suspensão e perda de foco, integrada pela PR #39 segundo os registros consultados.

Testes sintéticos/headless são necessários, mas não substituem validação em aparelho físico.

## 5.4. HUD e UI

A UI deve ser desenhada para telas mobile em paisagem, com:
- alvos de toque dimensionados;
- hierarquia visual clara;
- leitura em diferentes densidades;
- safe area;
- estados de foco/pressionado/desabilitado;
- prevenção de sobreposição;
- feedback de ação;
- consistência entre telas;
- navegação funcional.

O HUD atual é parcial e contém controles e informações provisórias. Menus e telas precisam de comportamento real, não apenas aparência.

## 5.5. Lifecycle Android

O jogo deve sobreviver corretamente a:
- perda de foco;
- alternância de aplicativo;
- bloqueio/desbloqueio de tela;
- pausa;
- suspensão;
- retomada;
- interrupções do sistema;
- mudança de orientação quando aplicável;
- encerramento inesperado.

A validação headless pode simular notificações, mas não comprova o comportamento integral do sistema operacional em dispositivo real.

---

# 6. ARQUITETURA TÉCNICA E ORGANIZAÇÃO DO PROJETO

## 6.1. Stack

- Godot 4.7.2.
- GDScript.
- Cenas `.tscn`.
- Scripts `.gd`.
- Resources `.tres`.
- Configuração principal `project.godot`.
- Android export preset.
- Testes GDScript/headless e workflows GitHub Actions.
- Documentação Markdown.
- Skills e agentes auxiliares em `.claude/`.

## 6.2. Princípios arquiteturais

- coesão alta e acoplamento controlado;
- composição em vez de hierarquias excessivamente profundas;
- cenas com responsabilidade definida;
- scripts com ownership explícito;
- dados de conteúdo separados da lógica quando isso facilitar manutenção;
- Resources para parâmetros/configurações reutilizáveis;
- sinais com contratos claros;
- IDs estáveis para conteúdo e progresso;
- persistência separada do estado transitório;
- dependências dirigidas e sem ciclos;
- autoloads restritos a serviços realmente globais;
- testes próximos dos contratos críticos;
- evitar monólitos e abstrações prematuras.

## 6.3. Mapa estrutural observado

A árvore observada no repositório inclui, entre outros, os seguintes elementos:

```text
.
├── .claude/
│   ├── agents/
│   ├── commands/
│   └── skills/
├── .github/
│   ├── workflows/
│   ├── ISSUE_TEMPLATE/
│   └── PULL_REQUEST_TEMPLATE.md
├── docs/
│   ├── decisions/
│   ├── game-design/
│   ├── production/
│   ├── prompts/
│   ├── qa/
│   ├── skills/
│   ├── technical/
│   └── templates/
├── resources/
│   └── player/
├── scenes/
│   ├── boot/
│   ├── campaign/
│   ├── combat/
│   ├── enemies/
│   ├── levels/
│   ├── player/
│   ├── tutorial/
│   ├── ui/
│   └── world/
├── scripts/
│   ├── campaign/
│   ├── combat/
│   ├── core/
│   ├── enemies/
│   ├── input/
│   ├── levels/
│   ├── player/
│   ├── tutorial/
│   ├── ui/
│   └── world/
├── tests/
│   ├── unit/
│   └── ...
├── project.godot
├── .godot-version
├── MASTER_DIRECTIVE.md
├── CLAUDE.md
└── AGENTS.md
```

Esta árvore é um mapa resumido, não uma listagem exaustiva de todos os 411 caminhos retornados pela árvore consultada. Sempre inspecionar a árvore atual antes de mover ou criar arquivos.

## 6.4. Cenas e scripts identificados

### Boot e fluxo central
- `scenes/boot/boot.tscn`
- `scripts/core/boot.gd`
- `scripts/core/scene_flow.gd`

### Campanha
- `scenes/campaign/cybercore_w1_l1.tscn`
- `scenes/campaign/cybercore_w1_l2.tscn`
- `scenes/campaign/opening_cinematic.tscn`
- `scripts/campaign/campaign_progress.gd`
- `scripts/campaign/cybercore_w1_l1.gd`
- `scripts/campaign/cybercore_w1_l2.gd`
- `scripts/campaign/opening_cinematic.gd`

### Player
- `scenes/player/bolt.tscn`
- `scripts/player/bolt_player.gd`
- `scripts/player/bolt_tuning.gd`
- `resources/player/bolt_tuning_provisional.tres`

### Input
- `scripts/input/action_buffer.gd`
- `scripts/input/actions.gd`
- `scripts/input/touch_button.gd`
- `scripts/input/touch_controls.gd`

### Combate
- `scenes/combat/bolt_health_pickup.tscn`
- `scenes/combat/chrono_projectile.tscn`
- `scenes/combat/training_target.tscn`
- `scripts/combat/bolt_combat.gd`
- `scripts/combat/bolt_health.gd`
- `scripts/combat/bolt_health_pickup.gd`
- `scripts/combat/chrono_projectile.gd`
- `scripts/combat/training_target.gd`

### Inimigos
- `scenes/enemies/cybercore_patrol_enemy.tscn`
- `scripts/enemies/cybercore_patrol_enemy.gd`

### Levels e mundo
- `scenes/levels/checkpoint.tscn`
- `scenes/levels/timed_energy_gate.tscn`
- `scenes/levels/sandbox/movement_sandbox.tscn`
- `scenes/world/moving_platform.tscn`
- `scenes/world/one_way_platform.tscn`
- `scenes/world/platform_block.tscn`
- scripts correspondentes em `scripts/levels/` e `scripts/world/`

### Tutorial e UI
- `scenes/tutorial/tutorial.tscn`
- `scripts/tutorial/tutorial.gd`
- `scenes/ui/hud.tscn`
- `scenes/ui/loading_overlay.tscn`
- `scenes/ui/main_menu.tscn`
- `scripts/ui/hud.gd`
- `scripts/ui/loading_overlay.gd`
- `scripts/ui/main_menu.gd`
- `scripts/ui/safe_area_margin.gd`

### Core e persistência
- `scripts/core/save_system.gd`
- `scripts/core/scene_flow.gd`
- `scripts/campaign/campaign_progress.gd`

A listagem é indicativa e deve ser confrontada com a árvore e o conteúdo atual.

## 6.5. Contratos e ownership

O mapa arquitetural atual e os contratos entre sistemas estão documentados em `docs/technical/05-system-contracts.md` e `docs/technical/09-current-architecture-map.md`.

A integração Player/Combat foi objeto de revisão documental nas PRs #51/#52 segundo os snapshots de continuidade. O agente deve consultar os arquivos atualizados antes de alterar sinais, ownership de dano, entrada ou dependências.

Evitar:
- jogador conhecendo detalhes internos de UI;
- HUD controlando lógica de combate;
- sistemas de campanha manipulando diretamente detalhes internos de física;
- persistência executando por frame;
- dependências circulares entre autoloads;
- scripts de fase acumulando lógica global;
- IDs derivados de nomes de apresentação;
- estado persistente armazenado em nós de cena sem serialização definida.

---

# 7. INPUT BUFFER, MOVIMENTO E CONTRATOS DE CONTROLE

O input deve ser tratado como fluxo de eventos e não apenas como consulta de estado instantâneo. Em dispositivos touch, a perda de um release ou a reatribuição incorreta de ponteiros pode causar ações presas, ausência de salto ou disparos indevidos.

O `ActionBuffer` mantém edges de ações para que comandos essenciais possam ser consumidos pelo gameplay dentro de janelas controladas. A janela de buffer e os valores de física não devem ser alterados incidentalmente em correções de lifecycle.

A PR #39, integrada segundo o registro consultado, limpou edges pendentes em notificações de pausa, suspensão e perda de foco. A cobertura documentada atingiu 72 testes, 451 verificações e zero falhas na execução CI indicada no snapshot histórico. Isso não comprova testes de lifecycle em aparelho físico.

Requisitos de regressão:
- pressionar e soltar;
- toque simultâneo em movimento e salto;
- salto + Dash;
- reatribuição de ponteiro;
- cancelamento de toque;
- pausa durante ação;
- perda de foco;
- suspensão e retomada;
- troca de cena;
- evitar ação fantasma ao retornar;
- evitar input preso após interrupção.

---

# 8. CÂMERA, MUNDO E SISTEMAS DE PLATAFORMA

A arquitetura deve manter o contrato da câmera independente da lógica de UI e de persistência. A câmera deve oferecer leitura de movimento e antecipação espacial sem gerar enjoo, atraso involuntário ou enquadramento que esconda perigos.

A base atual possui testes de contrato de câmera e componentes de plataforma identificados, incluindo:
- plataforma móvel (`MovingPlatform`);
- plataforma unidirecional (`OneWayPlatform`);
- bloco de plataforma;
- checkpoint;
- campo/portão energético temporizado (`TimedEnergyGate`).

A PR #45 adicionou `MovingPlatform`; PR #46 adicionou `OneWayPlatform`; PR #47 corrigiu o estado inicial de `TimedEnergyGate` para `initial_active=false`, conforme registros de continuidade. Cada componente precisa de testes de física, bordas, colisões, ativação, desativação e integração com o jogador.

Não presumir que os componentes existentes já cobrem todos os hazards ou sistemas ambientais dos sete mundos.

---

# 9. CHECKPOINT, SAVE SYSTEM E PROGRESSÃO

## 9.1. Separação conceitual

O projeto separa:
- armazenamento técnico;
- estado de campanha;
- estado transitório da fase;
- estado visual do checkpoint;
- lógica de respawn.

O `SaveSystem` é infraestrutura de serialização e persistência. `CampaignProgress` representa o domínio da campanha. Não fundir esses papéis sem decisão arquitetural.

## 9.2. SaveSystem v1

O registro de produção descreve:
- autoload `SaveSystem`;
- arquivo `user://bolt_save.json`;
- arquivo temporário e backup;
- envelope com `format_version=1`;
- payload `Dictionary` JSON-safe;
- checksum SHA-256;
- rejeição de tipos runtime como Node/Resource;
- rejeição de chaves que não sejam String;
- escrita por temporário/backup;
- recuperação pelo backup quando o principal está ausente/inválido;
- falha fechada para versão desconhecida.

A API é síncrona e deve ser chamada em marcos discretos, nunca por frame. A migração de versões, integração com todos os domínios e validação em Android real permanecem aspectos de evolução.

## 9.3. CampaignProgress v1

O registro descreve um autoload `CampaignProgress` separado do `SaveSystem`, com schema de domínio v1 dentro da chave `campaign_progress`.

Campos registrados:
- `campaign_id=main`;
- `current_level_id`;
- `active_checkpoint_id`;
- `completed_level_ids`.

Os IDs devem ser estáveis. W1-L1 possui persistência e restauração de checkpoint e conclusão que define W1-L2 como destino salvo. W1-L2 recebeu progressão/checkpoint em desenvolvimento conforme registros, mas os estados exatos devem ser confirmados na main atual.

## 9.4. Critérios de integridade

- round-trip de save/load;
- corrupção do arquivo principal;
- recuperação de backup;
- versão futura/desconhecida;
- payload inválido;
- dados incompletos;
- IDs de fase inexistentes;
- checkpoint inexistente;
- progresso duplicado;
- encerramento inesperado;
- migração;
- retomada após cold start;
- consistência entre conclusão de fase e destino seguinte.

Não declarar persistência completa enquanto não houver validação em Android físico, integração de todos os domínios e estratégia de migração adequada.

---

# 10. LOADING, ASSETS E TRANSIÇÕES

O projeto possui `SceneFlow` com carregamento threaded e bloqueio de transições concorrentes, além de `LoadingOverlay` e cena `scenes/ui/loading_overlay.tscn`.

O registro de implementação do overlay indica:
- autoload `LoadingOverlay`;
- overlay persistente;
- integração com sinais de transição;
- texto sem percentual quando o engine não reporta progresso;
- barra somente quando existe progresso real;
- ocultação em sucesso e falha;
- `PROCESS_MODE_ALWAYS` para concluir transições mesmo com a árvore pausada.

Loading deve refletir trabalho real. Não adicionar espera artificial de quatro segundos ou qualquer duração fixa apenas para mascarar problemas. Pré-carregamento, importação, cache, aquecimento e transição devem ser usados quando tecnicamente justificáveis.

O pipeline de assets deve considerar:
- formato e compressão;
- resolução e densidade;
- tamanho de textura;
- memória residente;
- import settings;
- atlas e batching quando adequados;
- carregamento sob demanda;
- descarte seguro;
- proveniência e licença;
- fallback e placeholders;
- relatório de assets.

Placeholder não deve ser apresentado como arte final. O inventário de assets e sua proveniência devem ser rastreáveis.

---

# 11. DIREÇÃO DE ARTE, ANIMAÇÃO E ÁUDIO

A identidade visual deve manter coerência entre personagem, ambientes, inimigos, UI, efeitos e cinematics. Cada mundo precisa de linguagem visual e sonora própria, mas o jogo deve manter unidade de produto.

As fontes principais são:
- `docs/game-design/07-art-audio-direction.md`;
- `.claude/skills/create-game-assets/`;
- documentos de pipeline e proveniência;
- manifestos de assets presentes no repositório.

Princípios:
- silhuetas legíveis em resolução mobile;
- contraste funcional entre gameplay e cenário;
- animações com antecipação, ação e recuperação;
- feedback responsivo sem excesso de partículas;
- consistência de escala;
- paleta por mundo;
- UI com hierarquia;
- efeitos visuais com custo controlado;
- áudio com função de feedback e atmosfera;
- trilha que respeite identidade e ritmo;
- assets externos com licença e origem documentadas.

Não copiar arte, música, sprites, personagens ou materiais protegidos sem autorização. Assets gerados ou adquiridos precisam de registro de origem, licença e condições de uso.

---

# 12. PERFORMANCE E OTIMIZAÇÃO ANDROID

## 12.1. Perfil-alvo

A referência é hardware Android de entrada/intermediário, com cerca de 4 GB de RAM e Helio G99 ou inferior. A otimização deve considerar CPU, GPU, memória, largura de banda, aquecimento, bateria, alocação, stutter e latência de input.

## 12.2. Métricas

Registrar sempre que possível:
- frame time médio;
- p95/p99 de frame time;
- FPS sustentado;
- spikes;
- tempo de cold start;
- tempo de transição;
- memória;
- uso de CPU/GPU quando mensurável;
- comportamento térmico;
- tamanho do APK;
- custo de importação;
- comportamento em sessões longas.

A meta de 60 FPS deve ser avaliada por cenário e aparelho. Um número isolado de FPS sem condições de teste não é evidência suficiente.

## 12.3. Estratégias

- evitar trabalho redundante em `_process`/`_physics_process`;
- limitar atualizações de UI;
- controlar quantidade de partículas e efeitos;
- reutilizar objetos quando profiling justificar;
- reduzir alocações temporárias em loops quentes;
- evitar carregamento pesado no meio da ação;
- dimensionar texturas e áudio;
- evitar nós/processamento desnecessários;
- usar sinais com parcimônia e contratos claros;
- reduzir consultas físicas redundantes;
- evitar processamento de inimigos distantes quando seguro;
- manter física determinística e independente de FPS;
- validar mudanças por comparação antes/depois.

Não otimizar por microbenchmark isolado se a mudança prejudicar game feel, legibilidade ou manutenção. Não sacrificar controles, Dash, conteúdo ou identidade visual sem justificativa e autorização quando necessário.

---

# 13. TESTES, QA E NÍVEIS DE VALIDAÇÃO

## 13.1. Camadas

Distinguir explicitamente:
- validação estática/documental;
- parsing/importação Godot;
- testes unitários;
- testes de integração;
- testes de cena/fluxo;
- testes headless;
- observação no editor;
- validação visual;
- teste em emulador;
- exportação Android;
- instalação em aparelho;
- validação touch/multitouch física;
- profiling em dispositivo;
- playtest humano.

Uma camada não substitui outra.

## 13.2. Suíte existente

A árvore observada inclui testes para:
- ActionBuffer;
- contrato de câmera;
- entrada de campanha;
- CampaignProgress;
- checkpoints;
- combate;
- inimigo/combate;
- contrato de input;
- loading overlay;
- MovingPlatform;
- OneWayPlatform;
- movimento do player;
- configuração de projeto;
- safe area;
- sandbox playthrough;
- SaveSystem;
- SceneFlow;
- cenas e scripts;
- touch controls;
- progressão W1-L2;
- isolamento do runner.

O número exato de testes e verificações muda conforme novas alterações são integradas. Nunca copiar contagem histórica como se fosse a contagem atual.

## 13.3. Severidade

Os bugs devem ser classificados por impacto:
- bloqueador: impede inicialização, progressão essencial ou release;
- crítico: perda de progresso, input essencial quebrado, crash recorrente ou softlock;
- alto: falha significativa de gameplay/UX;
- médio: comportamento incorreto limitado;
- baixo: polimento ou problema cosmético;
- melhoria: evolução sem defeito confirmado.

Todo bug deve ter reprodução, contexto, impacto, hipótese, evidência, correção e regressão.

## 13.4. Definition of Done

Uma unidade não está concluída apenas porque o código foi escrito. Deve possuir:
- escopo e critérios de aceite;
- implementação integrada;
- testes adequados;
- revisão de diff;
- ausência de regressões conhecidas;
- documentação atualizada;
- estado do tracker atualizado;
- limitações registradas;
- evidência reproduzível.

---

# 14. GITHUB, BRANCHES, CI E RELEASE ANDROID

## 14.1. Repositório

Repositório observado: `jyanzy19-yml/new-bolt-aventura`, branch padrão `main`, visibilidade pública na consulta de 26/11/2026.

O nome anterior `bolt-aventura` foi usado em conversas e etapas de preparação, mas a referência atual localizada na conexão GitHub é `new-bolt-aventura`. Não confundir o nome do projeto com o nome atual do repositório.

## 14.2. CI

O repositório possui workflows de validação documental, validação Godot e exportação Android debug. A documentação do pipeline está em `docs/production/CI_AND_VALIDATION_PIPELINE.md`.

A exportação Android debug descrita utiliza:
- download de Godot e templates pareados;
- JDK 17;
- Android SDK;
- chave de debug efêmera;
- importação e testes;
- exportação APK;
- verificação de assinatura;
- verificação de package ID;
- hash SHA-256;
- publicação de artifact temporário.

O package ID registrado como `com.example.boltaventura` é placeholder e não deve ser tratado como identificador definitivo de produto.

## 14.3. Evidência histórica

Os registros de continuidade consultados apontam:
- PR #46: `OneWayPlatform`, checks CI pré-merge reportados como SUCCESS, com 87 testes/548 verificações/0 falhas no snapshot associado;
- PR #47: correção do estado inicial de `TimedEnergyGate`, CI pós-merge reportado como SUCCESS, com 88 testes/553 verificações/0 falhas;
- PR #48: matriz de rastreabilidade de 26 etapas integrada;
- PRs #51/#52: revisão e sincronização do mapa arquitetural, incluindo acoplamento Player/Combat;
- artifact Android debug exportado em CI, assinatura v2/v3 verificada e SHA-256 registrado no snapshot;
- instalação em dispositivo físico não comprovada.

Esses são registros históricos. Antes de qualquer release ou declaração de estado, consultar runs atuais e a branch `main`.

## 14.4. Disciplina Git

- confirmar branch e HEAD antes de editar;
- criar branch de trabalho para unidade coerente;
- commits pequenos e rastreáveis;
- revisar diff;
- executar checks relevantes;
- integrar somente quando critérios forem atendidos;
- atualizar documentos após merge;
- não executar force push;
- não alterar visibilidade do repositório;
- não apagar branches/arquivos ou executar operações destrutivas sem solicitação explícita;
- não manipular secrets/credenciais;
- não publicar release de produção sem autorização.

PR #1 foi registrada como antiga, divergente e separada; não integrar ou rebasear automaticamente. Consultar o estado atual antes de qualquer decisão sobre ela.

---

# 15. MODELO DE PRODUÇÃO: 26 ETAPAS, 24 SISTEMAS E 42 FASES

O projeto utiliza um plano operacional de 26 etapas e uma matriz de rastreabilidade. O tracker acompanha 24 sistemas globais e as 42 fases planejadas. A sequência operacional deve ser consultada em `docs/production/stage-status.md` e `docs/production/26-stage-traceability-matrix.md`.

Snapshot de continuidade consultado em 26/11/2026:
- Etapas 01–03: concluídas.
- Etapa 04: em desenvolvimento, hardening dos sistemas centrais.
- Gate 0 estático: concluído.
- Gate 1: em andamento.
- W1-L1 e W1-L2: blockouts.
- APK debug: exportado por CI.
- Instalação e validação Android física: pendentes.
- Responsável de escrita ativo registrado: ChatGPT como único escritor.
- Claude permanece inativo para escrita concorrente, conforme o estado canônico de colaboração consultado.

A matriz de 26 etapas é instrumento de organização e rastreabilidade, não autorização para ignorar gates. O prompt/diretiva mestre no repositório continua sendo a fonte normativa do que deve ser implementado.

## 15.1. Regras de avanço

- não encerrar trabalho substancial após auditoria ou planejamento;
- implementar unidades funcionais aprovadas;
- não declarar etapa concluída sem critérios e evidências;
- manter tracker e continuidade sincronizados;
- preservar canon e ADRs;
- continuar trabalho independente e seguro quando houver bloqueio localizado;
- pedir decisão apenas para mudanças materiais não cobertas por decisões aprovadas, credenciais que só o usuário pode fornecer ou riscos irreversíveis;
- deixar próximo passo concreto no handoff.

## 15.2. Vertical slice

A vertical slice deve validar um fluxo representativo de ponta a ponta:
inicialização → menu → abertura/tutorial → fase → movimento/combate → inimigo → checkpoint → loading/transição → resultado → save/load.

A vertical slice é um gate de qualidade e integração, não o produto final. Não repetir indefinidamente o protótipo sem avançar para a campanha.

---

# 16. SKILLS, AGENTES E COMANDOS DO REPOSITÓRIO

O repositório contém um ecossistema de instruções e ferramentas para apoiar a produção. O README registra 39 skills, incluindo 26 selecionadas de uma coleção comunitária, uma adaptação de estrutura Godot e skills originais BOLT. Também registra 11 agentes consultivos read-only e seis comandos de workflow.

As skills devem ser carregadas seletivamente conforme a tarefa. Não carregar a coleção inteira sem necessidade.

Exemplos de domínios cobertos:
- arquitetura de jogo;
- gameplay;
- narrativa;
- level design;
- Android/performance;
- QA;
- UI/UX;
- arte e áudio;
- integração Godot;
- release Android;
- persistência;
- touch;
- boss encounters;
- cinemáticas;
- pipeline de conteúdo;
- debugging;
- regressão;
- continuidade de mundos.

Comandos documentados incluem:
- `/bolt-audit`;
- `/bolt-plan`;
- `/bolt-qa`;
- `/bolt-android-review`;
- `/bolt-continue`;
- `/bolt-release-check`.

Comandos e agentes são auxiliares. Não substituem execução, testes, evidências ou aprovação do usuário.

---

# 17. ESTADO DO PROJETO NA CONSOLIDAÇÃO

## 17.1. Estado geral

O projeto não é apenas documentação: existe uma fundação Godot executável com cenas, scripts, recursos, testes e configuração Android. Entretanto, essa fundação não representa a campanha completa.

O estado consultado aponta um protótipo técnico e blockouts iniciais, com sistemas centrais em hardening e expansão progressiva.

## 17.2. Estado por área

| Área | Estado conhecido | Limite importante |
|---|---|---|
| Projeto Godot | Implementado | Confirmar importação e versão no ambiente atual |
| Boot/menu | Parcialmente implementado | Validação visual/Android física pendente |
| SceneFlow | Implementado parcialmente | Cobrir edge cases e validação de runtime |
| LoadingOverlay | Implementado parcialmente | Validar transições em dispositivo |
| Player/movimento | Implementado parcialmente | Tuning provisório e validação física pendente |
| Dash | Aprovado e presente | Preservar implementação e comportamento |
| Touch/multitouch | Parcialmente implementado | Teste real em Android pendente |
| Safe area | Parcialmente implementada | Validar recortes e barras em aparelho |
| HUD | Parcial/provisório | Acabamento e validação de layout pendentes |
| Sandbox | Implementado | Ferramenta de desenvolvimento, não fase de campanha |
| Abertura/tutorial | Fluxo funcional inicial | Não equivale a cinematics/arte finais |
| W1-L1 | Blockout | Conteúdo, arte, áudio, playtest e QA final pendentes |
| W1-L2 | Blockout | Conteúdo, arte, áudio, playtest e QA final pendentes |
| Combate | Base inicial | Arsenal, IA e balanceamento incompletos |
| Inimigos | Base provisória | Arquétipos e IA de campanha incompletos |
| Chefes | Não implementados no escopo completo observado | Necessários para campanha |
| SaveSystem | v1 implementado parcialmente | Migrações e validação física pendentes |
| CampaignProgress | v1 parcial | Integração de todos os níveis/domínios pendente |
| Checkpoints | Integração inicial | Validar persistência/cold start em Android |
| Assets finais | Não identificados como integrados de forma completa | Placeholders permanecem |
| Áudio final | Não identificado como integrado | Produção e mixagem pendentes |
| Android debug APK | Exportado por CI em registros | Não confundir exportação com instalação |
| Android físico | Pendente | Touch, lifecycle, safe area, desempenho e playtest |
| Campanha 7 mundos/42 fases | Planejada | Não implementada integralmente |

## 17.3. Snapshot de colaboração

O arquivo `docs/production/COLLABORATION_STATE.md` consultado registra ChatGPT como único escritor ativo e Claude inativo para escrita concorrente. Esse estado deve ser confirmado no repositório antes de iniciar qualquer fluxo de colaboração entre agentes.

O protocolo de colaboração histórico pode continuar documentado, mas não sobrepõe o escritor ativo atual.

## 17.4. Próxima unidade registrada

O snapshot de continuidade consultado indica como próxima unidade a auditoria de:
- Boot;
- SceneFlow;
- SaveSystem;
- CampaignProgress;
- LoadingOverlay.

A tarefa consiste em encontrar edge cases confirmados, corrigir defeitos reais e adicionar regressões, sem alterar schema/canon desnecessariamente. Antes de executar, confirmar se essa unidade ainda é a próxima no HEAD atual.

---

# 18. PROCEDIMENTO OBRIGATÓRIO PARA QUALQUER AGENTE QUE RETOMAR O PROJETO

Antes de editar:

1. Confirmar acesso real ao repositório.
2. Confirmar nome completo do repositório e branch.
3. Obter HEAD atual, árvore e estado de PRs relevantes.
4. Ler `MASTER_DIRECTIVE.md`.
5. Ler `CLAUDE.md` e `AGENTS.md`.
6. Ler `docs/README.md`.
7. Ler `docs/production/stage-status.md`.
8. Ler `docs/production/COLLABORATION_STATE.md`.
9. Ler `docs/production/CONTINUITY.md`.
10. Ler `docs/production/implementation-tracker.md`.
11. Ler ADRs pertinentes.
12. Ler a especificação de design/técnica da tarefa.
13. Inspecionar cenas, scripts e testes reais relacionados.
14. Confirmar a versão Godot no projeto.
15. Identificar estado implementado, provisório, pendente e validado.
16. Formular uma unidade de mudança pequena e verificável.
17. Implementar sem refatorações não relacionadas.
18. Rodar testes apropriados.
19. Revisar diff e impactos.
20. Atualizar documentação, tracker e continuidade.

Nunca iniciar uma implementação baseada apenas neste dossiê ou em uma conversa antiga quando o estado do repositório puder ser consultado.

## 18.1. Relatório obrigatório ao final de tarefa substancial

- objetivo;
- branch e commit-base;
- arquivos alterados;
- sistemas afetados;
- canon/ADR afetados ou declaração de que nenhum foi alterado;
- implementação realizada;
- testes executados;
- resultados exatos;
- testes não executados e motivo;
- validação Android realizada ou não;
- riscos e limitações;
- status do gate;
- próximo passo concreto.

---

# 19. REGRAS DE NÃO REGRESSÃO E PROTEÇÃO DO PRODUTO

1. Não recriar `project.godot` ou a fundação existente.
2. Não migrar de engine por iniciativa própria.
3. Não converter o projeto para web como plataforma-alvo.
4. Não remover Dash.
5. Não alterar física, controles ou tuning sem escopo.
6. Não quebrar multitouch.
7. Não comprometer salto ou Dash durante stutter.
8. Não modificar modo imersivo, barras do sistema ou safe areas sem consultar ADRs.
9. Não alterar schema de save sem plano de compatibilidade/migração.
10. Não criar IDs instáveis para conteúdo persistente.
11. Não usar espera artificial como substituto de loading real.
12. Não declarar blockout como fase final.
13. Não declarar sandbox como fase da campanha.
14. Não declarar alvo de treino como inimigo completo.
15. Não declarar APK exportado como instalado.
16. Não declarar CI headless como validação Android física.
17. Não declarar placeholder como arte final.
18. Não inventar canon narrativo.
19. Não transformar proposta em aprovação.
20. Não executar operações destrutivas ou force push.
21. Não expor, alterar ou buscar credenciais sem necessidade e autorização.
22. Não marcar etapa, sistema ou fase como concluída sem evidência.
23. Não duplicar documentação quando já existir fonte especializada.
24. Não permitir escrita concorrente por agentes sem reativação explícita do fluxo.

---

# 20. GLOSSÁRIO TÉCNICO E DE PRODUÇÃO

- **ADR:** Architecture Decision Record; registro de decisão arquitetural.
- **APK:** pacote instalável Android.
- **Blockout:** versão preliminar da fase para validar geometria, fluxo e mecânicas.
- **CampaignProgress:** domínio de estado persistente da campanha.
- **Cold start:** inicialização do aplicativo a partir de estado encerrado.
- **Coyote time:** janela de tolerância após sair de uma plataforma em que o salto ainda é permitido.
- **Dash:** deslocamento rápido aprovado como mecânica de gameplay.
- **Definition of Done:** critérios verificáveis para considerar uma unidade concluída.
- **Frame time:** tempo de processamento de um frame; métrica mais informativa que FPS isolado para stutter.
- **Gate:** marco de validação que precisa ser satisfeito antes de avançar.
- **Godot headless:** execução/testes sem interface gráfica.
- **HUD:** interface sobreposta ao gameplay.
- **Input buffer:** armazenamento temporário de comandos para preservar intenção do jogador.
- **Lifecycle:** estados de foco, pausa, suspensão e retomada do aplicativo.
- **Multitouch:** registro simultâneo de múltiplos contatos.
- **p95/p99:** percentis de distribuição de frame time ou latência.
- **Safe area:** região da tela livre de recortes e áreas reservadas pelo sistema.
- **SceneFlow:** serviço de transição/carregamento entre cenas.
- **SaveSystem:** infraestrutura de serialização e armazenamento.
- **Softlock:** estado em que o jogo continua executando, mas o progresso fica impossível.
- **Telemetry:** medição estruturada de comportamento/desempenho, quando adotada.
- **Vertical slice:** fatia pequena, porém representativa, do produto integrada de ponta a ponta.

---

# 21. ÍNDICE DE DOCUMENTOS QUE DEVEM SER CONSULTADOS

## Diretrizes
- `MASTER_DIRECTIVE.md`
- `CLAUDE.md`
- `AGENTS.md`
- `docs/README.md`
- `docs/production/from-zero-implementation-directive.md`

## Game design
- `docs/game-design/00-game-overview.md`
- `docs/game-design/01-narrative-bible.md`
- `docs/game-design/02-world-bible.md`
- `docs/game-design/03-character-bible.md`
- `docs/game-design/04-gameplay-systems.md`
- `docs/game-design/05-level-design-standard.md`
- `docs/game-design/06-ui-ux.md`
- `docs/game-design/07-art-audio-direction.md`
- `docs/game-design/EXPANDED-42-LEVEL-CAMPAIGN-BLUEPRINT.md`
- `docs/game-design/EXPANDED-GAMEPLAY-SYSTEMS.md`
- `docs/game-design/EXPANDED-NARRATIVE-DOSSIER.md`

## Técnica
- `docs/technical/00-architecture-principles.md`
- `docs/technical/01-android-performance.md`
- `docs/technical/02-touch-and-display.md`
- `docs/technical/03-loading-and-assets.md`
- `docs/technical/04-android-build-checklist.md`
- `docs/technical/05-system-contracts.md`
- `docs/technical/06-godot-project-foundation.md`
- `docs/technical/07-save-system.md`
- `docs/technical/08-campaign-progress.md`
- `docs/technical/09-current-architecture-map.md`

## Produção e continuidade
- `docs/production/stage-status.md`
- `docs/production/COLLABORATION_STATE.md`
- `docs/production/CONTINUITY.md`
- `docs/production/implementation-tracker.md`
- `docs/production/26-stage-traceability-matrix.md`
- `docs/production/requirements-gap-register.md`
- `docs/production/CI_AND_VALIDATION_PIPELINE.md`
- `docs/production/quality-control-protocol.md`
- `docs/production/definition-of-done.md`
- `docs/production/ADR-001-DASH.md`

## QA
- `docs/qa/test-matrix.md`
- templates de plano, decisão, handoff e relatórios em `docs/templates/`

---

# 22. DECLARAÇÃO FINAL DE CONTEXTO

BOLT · AVENTURA deve ser desenvolvido como um produto de jogo 2D profissional, com engenharia de gameplay, arquitetura modular sustentável, direção de arte consistente, narrativa rastreável, level design autoral e validação Android real.

O projeto já possui uma fundação Godot executável e um ecossistema documental amplo. A prioridade não é recomeçar, trocar de tecnologia ou produzir documentação redundante. A prioridade é continuar a implementação real, fechar contratos entre sistemas, fortalecer a confiabilidade, validar a experiência mobile e expandir progressivamente a campanha.

O agente deve agir com rigor de engenharia:
- inspecionar antes de modificar;
- compreender ownership e dependências;
- respeitar canon e decisões;
- implementar incrementalmente;
- testar regressões;
- medir antes de otimizar;
- distinguir evidência de expectativa;
- manter rastreabilidade;
- preservar continuidade;
- nunca declarar conclusão sem critérios.

**Objetivo permanente:** transformar a fundação atual em BOLT · AVENTURA completo, coeso, responsivo, visualmente consistente, tecnicamente robusto e pronto para distribuição Android.

---

# APÊNDICE A — METADADOS DA CONSULTA DE REPOSITÓRIO

Esta consolidação foi preparada a partir da árvore e de arquivos do repositório consultados em 26/11/2026.

- Repositório: `jyanzy19-yml/new-bolt-aventura`
- Branch consultada: `main`
- Árvore Git retornada: `fc4839e4a36b914514d8a6c8ca86fd29b6e47807`
- Linguagem primária reportada pelo GitHub: GDScript
- Visibilidade observada: pública
- Tamanho reportado pelo GitHub na consulta: 1105 KB (valor sujeito a mudança)
- Quantidade de entradas na árvore recursiva consultada: 411
- A árvore é mutável; não usar o SHA da árvore como substituto do commit HEAD.
- O snapshot de continuidade presente nos documentos consultados indicava `main` HEAD `6f8e9b8fbaaab9c44247050e5f86e4442bd2622f` após PR #52. Como os dados podem mudar entre consultas, confirmar commit atual antes de qualquer implementação.

Este apêndice registra procedência e limitações da consolidação. Ele não afirma que todos os 411 arquivos foram integralmente auditados nesta operação. Os documentos especializados e o código executável continuam sendo as fontes completas.

# APÊNDICE B — PROMPT OPERACIONAL CURTO PARA USO DESTE DOSSIÊ

Ao receber este documento, trate-o como contexto consolidado de BOLT · AVENTURA. Não comece a programar apenas com base nele. Primeiro confirme o estado atual do repositório GitHub, branch, HEAD, documentação de autoridade, ADRs, tracker e continuidade. Depois leia as fontes especializadas relacionadas à tarefa e inspecione os arquivos reais. Preserve a fundação Godot 4.7.2, Android landscape, Dash aprovado, touch/multitouch, safe areas, persistência e decisões narrativas. Diferencie canon, requisito, proposta, provisório, implementado e validado. Faça mudanças pequenas e integradas, execute testes pertinentes, não invente evidências e atualize a continuidade. A missão é avançar a implementação real até a campanha completa de sete mundos e 42 fases, sem recriar o projeto ou encerrar o trabalho apenas em planejamento.
