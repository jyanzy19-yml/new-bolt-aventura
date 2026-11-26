# BOLT · AVENTURA
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
