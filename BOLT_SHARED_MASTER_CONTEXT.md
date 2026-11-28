# BOLT · AVENTURA
# DOSSIÊ MESTRE COMPARTILHADO — PRODUTO, CANON, ENGENHARIA E CONTINUIDADE

**Identificador:** BOLT-SHARED-MASTER-CONTEXT  
**Versão:** 2.0 — HTML5 clean-start  
**Data de consolidação:** 28/11/2026  
**Repositório:** https://github.com/jyanzy19-yml/new-bolt-aventura  
**Branch de referência:** main  
**Commit-base verificado:** 9c32df4225b4e410340b2254a098167023593625  
**Público:** ChatGPT, Claude Code, revisores técnicos e responsáveis pela produção  
**Autoridade final:** usuário/proprietário do produto

> **AVISO DE AUTORIDADE:** este documento consolida contexto e continuidade. Não substitui as bíblias, ADRs, diretivas ou o código. A decisão posterior do usuário de criar o jogo do zero em HTML5 prevalece sobre toda instrução Godot/GDScript presente no dossiê histórico. Isto não é uma migração nem um port.

---

# 0. COMO USAR ESTE DOCUMENTO

## 0.1 Finalidade

Este arquivo é a memória operacional compartilhada de BOLT · AVENTURA. Deve permitir que ChatGPT e Claude Code retomem o trabalho sem depender de lembranças incompletas de conversas, sem contradizer o canon e sem confundir documentação, protótipo, implementação e validação.

Use-o para compreender o produto, reconhecer canon e lacunas, conhecer a tecnologia vigente, compreender o estado real do repositório, respeitar ownership, selecionar tarefas sem sobreposição, planejar arquitetura/conteúdo/QA e registrar evidências.

Não use este documento como autorização para alterar canon, reestruturar arquitetura amplamente, apagar arquivos ou integrar PRs sem a autoridade apropriada.

## 0.2 Regime de evidência

| Estado | Significado |
|---|---|
| CANON | Informação narrativa/criativa confirmada nas fontes aprovadas |
| REQUISITO | Obrigação de produto, UX, plataforma, engenharia ou qualidade |
| DECISÃO | Escolha técnica/operacional aprovada e registrada |
| PROPOSTA | Solução sugerida, ainda não aprovada como canon ou decisão |
| PROVISÓRIO | Conteúdo temporário sujeito a revisão |
| PLANNED | Planejado, sem implementação comprovada |
| IMPLEMENTED | Código/conteúdo existe e foi inspecionado |
| TESTED | Teste nomeado executado, com resultado registrado |
| VERIFIED | Evidência representativa comprova o comportamento no ambiente-alvo |
| PENDING | Trabalho reconhecido, ainda não concluído |
| DEPRECATED | Instrução substituída; mantida apenas por histórico |
| REJECTED | Proposta rejeitada; não reintroduzir sem autorização |

A existência de um arquivo não comprova integração. Teste unitário não comprova UX. Build verde não comprova gameplay. APK gerado não comprova instalação. Teste desktop não comprova Android WebView.

## 0.3 Hierarquia de autoridade

1. Instrução explícita mais recente do usuário para a tarefa atual.
2. Decisões aprovadas e ADRs vigentes.
3. Bíblias de game design aprovadas para canon e produto.
4. Diretivas operacionais atuais: MASTER_DIRECTIVE.md, AGENTS.md, CLAUDE.md.
5. Contratos técnicos HTML5 vigentes.
6. Este dossiê e documentos de continuidade.
7. Roadmaps, trackers, templates e registros históricos.
8. Skills, exemplos, propostas e recomendações de agentes.

Quando fontes de autoridade equivalente discordarem, não resolver silenciosamente. Identificar arquivos, trechos, impacto e recomendação; pedir decisão do usuário quando afetar canon, escopo, experiência ou arquitetura.

## 0.4 Fontes primárias

Antes de tarefa substancial, consultar no estado atual do GitHub:
- MASTER_DIRECTIVE.md
- AGENTS.md
- CLAUDE.md
- docs/README.md
- docs/PROJECT_CONTEXT_HTML5.md
- docs/game-design/00-game-overview.md
- docs/game-design/01-narrative-bible.md
- docs/game-design/02-world-bible.md
- docs/game-design/03-character-bible.md
- docs/game-design/04-gameplay-systems.md
- docs/game-design/05-level-design-standard.md
- docs/game-design/06-ui-ux.md
- docs/game-design/07-art-audio-direction.md
- docs/game-design/EXPANDED-42-LEVEL-CAMPAIGN-BLUEPRINT.md
- docs/game-design/EXPANDED-GAMEPLAY-SYSTEMS.md
- docs/game-design/EXPANDED-NARRATIVE-DOSSIER.md
- docs/production/COLLABORATION_STATE.md
- docs/production/CONTINUITY.md
- docs/production/REPOSITORY_CLEANUP_2026-11-28.md
- docs/production/definition-of-done.md
- docs/qa/
- ADRs e contratos pertinentes;
- código, testes, workflows e configurações reais.

Alguns documentos ainda contêm frases antigas sobre Godot. Conteúdo de produto pode continuar válido; instruções específicas da engine antiga não são tecnologia ativa.

---

# 1. IDENTIDADE DO PRODUTO

## 1.1 Visão

BOLT · AVENTURA é um jogo original 2D de plataforma, ação e aventura, com narrativa de ficção científica, protagonista robótico, exploração lateral, movimentação expressiva, combate, desafios ambientais, chefes, progressão por mundos e campanha planejada de longa duração.

O produto é destinado principalmente a Android, em orientação paisagem. A experiência deve priorizar controles touch confiáveis, leitura visual, desempenho sustentável em aparelhos de entrada/intermediários e progressão persistente.

## 1.2 Promessa de experiência

O jogador deve:
- compreender intuitivamente como se mover e interagir;
- sentir que BOLT tem peso, resposta e expressividade;
- aprender mecânicas em ambientes seguros antes de dominá-las sob pressão;
- reconhecer mundos por identidade visual, sonora, espacial e mecânica;
- enfrentar inimigos e chefes com padrões legíveis e contra-jogo justo;
- descobrir narrativa por ambientes, eventos, personagens e consequências;
- confiar que checkpoints e salvamento preservam progresso;
- jogar em tela móvel sem que controles disputem com o sistema operacional.

## 1.3 Pilares

1. Controle responsivo.
2. Legibilidade de ameaças, plataformas, telegraphs, pickups e objetivos.
3. Progressão significativa de mecânicas.
4. Identidade própria por mundo.
5. Narrativa integrada ao gameplay.
6. Qualidade mobile como requisito central.
7. Loading, transições, checkpoints e save confiáveis.
8. Produção rastreável, com critérios e evidências.

## 1.4 Escopo-alvo

- narrativa completa;
- sete mundos e sete fragmentos;
- 42 fases planejadas, seis por mundo;
- inimigos com arquétipos distintos;
- NPCs funcionais;
- chefes com padrões, fases, telegraphs e janelas de resposta;
- movimento, salto e Dash;
- combate e arsenal conforme especificações;
- tutorial integrado;
- menus, HUD, configurações, pausa, vitória, derrota e créditos;
- cutscenes e diálogos;
- checkpoints, progressão e persistência;
- áudio, música, efeitos e feedback;
- pipeline de assets com proveniência/licença;
- aplicativo Android empacotado e validado.

O escopo acima é a visão-alvo, não declaração de implementação concluída.

---

# 2. CANON NARRATIVO

## 2.1 Premissa consolidada

BOLT, robô ligado à preservação dos universos, desperta sem memória nas ruínas de Cybercore, um mundo destruído. Ele encontra NEXO, uma máquina temporal que desperta e se une a ele. Essa união permite atravessar eras e mundos.

O Grande Colapso rompeu o Núcleo da Eternidade e desestabilizou a continuidade entre universos. A jornada exige recuperar sete fragmentos, um em cada mundo. Cada fragmento é protegido por um guardião ao final do arco daquele mundo. Os fragmentos são necessários para restaurar o equilíbrio dos universos.

O antagonista central é o Arquiteto. Seu objetivo definido é impor uma única realidade, eliminando a coexistência entre universos em nome de uma ordem absoluta. O conflito central opõe controle/uniformidade à coexistência/preservação dos universos.

## 2.2 Elementos de canon

- BOLT: protagonista robótico; desperta sem memória em Cybercore; função original ligada à preservação dos universos.
- NEXO: máquina temporal que se une a BOLT; permite viajar entre eras/mundos; ligada ao mistério dos fragmentos.
- Grande Colapso: evento que rompeu o Núcleo da Eternidade e desestabilizou os universos.
- Núcleo da Eternidade: elemento central da mitologia temporal/cósmica.
- Arquiteto: antagonista central; pretende impor uma única realidade.
- Sete mundos e sete fragmentos na sequência aprovada.
- Campanha planejada: 42 fases, seis por mundo.
- Guardiões: títulos descritivos aprovados; não inventar nomes próprios como canon.

## 2.3 Sequência oficial dos mundos

| Ordem | Mundo | Identidade central | Fragmento | Guardião final |
|---:|---|---|---|---|
| 1 | Cybercore | Ruínas tecnológicas; despertar de BOLT e união com NEXO | Origem | Sentinela do Fragmento |
| 2 | Egito Antigo Futurista | Arquitetura monumental, civilização ancestral, mecanismos e tecnologia futurista | Memória | Guardião Ancestral das Pirâmides |
| 3 | Speakeasy Aesthetic | Atmosfera urbana inspirada nos speakeasies dos anos 1920; elegância, música, mistério e segredos | Verdade | Mestre das Sombras |
| 4 | Dark Fantasy | Fantasia sombria, ruínas, exploração e ameaça | Sombra | Rei Esquecido |
| 5 | Pôr do Sol em Cidade Medieval | Cidade medieval sob luz de fim de tarde; arquitetura histórica e transição | Luz | Guardião da Coroa |
| 6 | Vaporwave / Las Vegas | Neon, espetáculo urbano, reflexos, geometrias e estética vaporwave | Ilusão | Ilusionista Supremo |
| 7 | Natal / Nova York Futurista | Nova York futurista em atmosfera natalina; encerramento visual e emocional | Equilíbrio | Guardião do Inverno |

A ordem e os nomes são fixos conforme a Bíblia dos Mundos. Paletas finais, referências visuais, NPCs, mecânicas exclusivas, arquitetura detalhada e assinaturas musicais precisam de desenvolvimento e aprovação. Não preencher lacunas com fatos inventados.

## 2.4 Arcos e lacunas

Macroestrutura:
1. Despertar de BOLT em Cybercore.
2. Encontro e união com NEXO.
3. Estabelecimento da travessia entre mundos.
4. Busca progressiva dos sete fragmentos.
5. Revelações sobre Grande Colapso, Núcleo e Arquiteto.
6. Convergência narrativa.
7. Confronto do conflito central.
8. Restauração/definição do equilíbrio e conclusão.

A ordem geral está definida; distribuição exata de revelações, diálogos, cenas, consequências e caracterização detalhada ainda exige desenvolvimento. Aparência, voz, personalidade, origem específica e limites de NEXO ainda precisam de definição. História completa e métodos do Arquiteto também precisam de desenvolvimento sem contradizer seu objetivo aprovado.

## 2.5 Regras de continuidade

- Não alterar nomes, ordem de mundos ou fragmentos.
- Não inventar nomes próprios de guardiões.
- Não afirmar quem causou diretamente o Grande Colapso se a fonte não confirmar.
- Não atribuir origem ou intenção não aprovada a NEXO.
- Não transformar proposta de agente em canon.
- Manter IDs estáveis para personagens, cenas, diálogos, flags e eventos.
- Toda cutscene deve ter função dramática/contextual, duração e transição definidas, legendas quando necessário, opção de pular e atualização determinística de flags.
- NPCs devem cumprir função narrativa ou de gameplay.
- A narrativa deve continuar compreensível quando conteúdo opcional é ignorado.

---

# 3. CAMPANHA E LEVEL DESIGN

## 3.1 Estrutura macro

Cada mundo possui seis fases planejadas:
- Fases 1–5: exploração, aprendizagem, prática, combinações, encontros e progressão narrativa.
- Fase 6: conclusão do arco local, confronto do guardião, aquisição do fragmento, consequência narrativa e transição.

O blueprint expandido das 42 fases é proposta de produção para transformar em especificações detalhadas. Não significa que as 42 fases estejam implementadas ou aprovadas como conteúdo final.

## 3.2 Diversidade de inimigos

Meta mínima documentada: cinco arquétipos significativamente distintos por mundo. Recolorir um inimigo ou apenas alterar HP/dano não satisfaz a meta. A distinção deve aparecer na decisão exigida do jogador: locomoção, percepção, alcance, defesa, ataque, telegraph, vulnerabilidade, relação com terreno ou papel no encontro.

## 3.3 Curva de aprendizagem

1. Apresentar: introduzir regra em ambiente seguro e legível.
2. Praticar: permitir repetição com risco controlado.
3. Combinar: integrar com habilidades já conhecidas.
4. Dominar: exigir leitura e execução em desafio expressivo, mas justo.

Não introduzir várias regras novas simultaneamente. Chefes testam habilidades ensinadas, não mecânicas inéditas sem tutorialização.

## 3.4 Especificação obrigatória por fase

Cada ficha deve incluir:
- ID estável (ex.: W1-L1), mundo, posição e status;
- objetivo narrativo, principal e opcionais;
- resumo de entrada e saída;
- layout, fluxo espacial e landmarks;
- rota principal e rotas opcionais;
- mecânica ensinada/praticada/combinada/testada;
- plataformas, obstáculos e hazards;
- inimigos, arquétipos, encontros e telegraphs;
- checkpoints, respawn e persistência;
- NPCs, diálogos, eventos e flags;
- colecionáveis, segredos e recompensas;
- assets e áudio;
- curva de dificuldade e acessibilidade touch;
- orçamento de performance;
- dependências e riscos;
- critérios de conclusão;
- plano de QA e evidências.

## 3.5 W1-L1 — Despertar entre Ruínas

O blueprint descreve W1-L1 assim:
- Função: tutorial orgânico e apresentação de BOLT.
- Estrutura: percurso predominantemente horizontal, pequenas elevações e seção vertical curta.
- Percurso sugerido: câmara de despertar → corredor desmoronado → pátio aberto → abrigo de manutenção.
- Ensinar: andar, aceleração, salto, altura variável, pulo duplo e interação, cada ação em espaço seguro antes de combinar.
- Desafios: plataformas largas, vãos moderados e sequência de saltos com aterrissagens visíveis.
- Inimigo: unidade de manutenção defeituosa introduzida isoladamente; encontro leve/opcional conforme balanceamento.
- Narrativa: BOLT desperta sem memória; NEXO emite sinal fragmentado e orienta a saída.
- Segredo: compartimento de diagnóstico sugerindo que BOLT não é um robô comum.
- Conclusão: alcançar abrigo e ativar primeiro ponto de sincronização.

É uma proposta de produção baseada no blueprint. Antes de fixar implementação, verificar as bíblias e arquivos atuais. Dash é mecânica geral aprovada, mas a nota de reconciliação do blueprint W1 informa que W1 não deve exigir Dash como único meio de progressão até que a lista canônica de habilidades e contratos seja reconciliada.

## 3.6 Boss design

Todo chefe precisa de arena legível, estados/fases com gatilhos explícitos, padrões identificáveis, telegraphs, janela de resposta, contra-jogo, adaptação às habilidades ensinadas, transições sem dano inevitável, regras de retry, feedback, recompensa e testes de todas as transições.

HP alto não é design de chefe. Aleatoriedade sem leitura não é desafio justo.

## 3.7 Blockout versus conteúdo final

Blockout valida geometria, fluxo, câmera, ritmo, colisões e desafio; não equivale a fase final. Sandbox é ferramenta de desenvolvimento, não fase da campanha. Placeholder não é asset final. Aprovação de fase exige revisão de conteúdo, gameplay, arte, áudio, performance e QA.

---

# 4. PERSONAGEM, MOVIMENTO E GAMEPLAY

## 4.1 BOLT como sistema

BOLT deve ser concebido como conjunto de subsistemas com ownership explícito:
- movimento;
- física/colisão;
- estado de gameplay;
- combate;
- dano/recuperação;
- animação/apresentação;
- input;
- interação com mundo;
- câmera;
- progressão/habilidades.

UI, persistência, áudio e fluxo de campanha não devem ser dependências internas do controlador sem necessidade.

## 4.2 Movimento

A implementação HTML5 ainda não contém gameplay. Não transportar valores numéricos de protótipos ou da antiga engine como parâmetros aprovados. Primeiro definir e medir:
- aceleração/desaceleração horizontal;
- velocidade;
- controle aéreo;
- gravidade e velocidade terminal;
- impulso e altura do salto;
- altura variável, se aprovada;
- pulo duplo conforme contrato;
- coyote time e jump buffer;
- Dash;
- colisão e aterrissagem;
- knockback e invulnerabilidade;
- estados e transições de animação.

Toda habilidade declara ativação, duração, interrupção, cancelamento, prioridade, recarga, invulnerabilidade e término. Valores finais vêm de especificação e playtest.

## 4.3 Dash — mecânica aprovada

Dash é mecânica aprovada e deve ser preservada. Não remover, substituir ou redesenhar silenciosamente. A antiga ADR-001-DASH é fonte histórica da aprovação de produto; adaptar contratos à stack nova sem reintroduzir código Godot. Mudanças de tuning/comportamento exigem tarefa explícita, justificativa e testes.

## 4.4 Combate e arsenal

O jogo inclui combate fictício de plataforma e arsenal conforme as bíblias. Cada arma/habilidade deve ter propósito distinto, alcance, cadência/cooldown ou custo, feedback, telegraph, limites e compatibilidade touch. Não assumir parâmetros antigos como cânone. Evitar habilidades redundantes e efeitos que ocultem ameaças.

## 4.5 Inimigos e IA

Cada inimigo especifica ID/mundo, papel, silhueta, locomoção, percepção, máquina de estados, ataques, telegraphs, janelas de resposta, contra-jogo, interação com terreno, dano/morte, variações, limites de instâncias, orçamento de CPU/memória e QA.

IA deve ser determinística o suficiente para testes e depuração. Evitar aleatoriedade que torne encontros injustos ou testes instáveis.

## 4.6 Feedback e game feel

Planejar feedback coerente para salto, aterrissagem, Dash, tiro, acerto, dano recebido, invulnerabilidade, coleta, checkpoint, interação, objetivo, derrota, vitória e transição. Feedback comunica causa e resultado sem comprometer legibilidade, acessibilidade ou performance.

---

# 5. ANDROID, TOUCH E UX

## 5.1 Plataforma

Android é a plataforma de produto. Orientação paisagem. Browser desktop pode servir como ambiente de desenvolvimento e teste preliminar, não como alvo final de distribuição.

Capacitor é candidato de empacotamento Android, sujeito a validação técnica. Não afirmar integração, APK ou instalação sem evidência.

## 5.2 Touch como sistema central

Requisitos:
- Pointer Events com pointerId e ciclo completo;
- multitouch simultâneo;
- press/release confiáveis;
- pointercancel e perda de contato;
- reatribuição de ponteiros;
- cancelamento ao perder foco;
- pausa, suspensão, retomada e troca de cena;
- prevenção de input preso ou fantasma;
- captura imediata da intenção;
- buffer de ações para não depender exclusivamente do frame de renderização.

Jump e Dash são prioritários. Pequenos engasgos não devem fazer desaparecer o evento de pressionar/soltar. Distinguir edge events (pressed/released) de estado contínuo (held), com timestamps/frames lógicos quando apropriado.

## 5.3 Display, fullscreen e safe areas

- Layout consistente entre modos de apresentação.
- Respeitar viewport-fit e safe-area-inset.
- Alvos touch confortáveis.
- HUD não pode cobrir perigos ou ser cortado por recortes.
- Status/navigation bars podem exigir configuração do shell Android; CSS sozinho não garante cobertura de barras do sistema.
- Não prometer ocultação de barras sem validação em WebView/Capacitor e configuração nativa.
- Fullscreen e modo normal preservam proporção, input, câmera e escala.
- Testar resoluções, densidades e aspect ratios.

## 5.4 Lifecycle

Tratar visibilitychange, pagehide/pageshow, blur/focus, pause/resume nativo, interrupções, suspensão, encerramento inesperado, áudio suspenso, limpeza de ponteiros e retomada sem input fantasma.

## 5.5 UI/HUD

Menus e HUD precisam de hierarquia visual, legibilidade, navegação, estados de pressionado/desabilitado, acessibilidade básica, safe areas e feedback. Tela desenhada não significa fluxo funcional; controles precisam de comportamento e testes.

---

# 6. STACK E ARQUITETURA HTML5

## 6.1 Decisão vigente

**Reconstrução clean-start do zero em HTML5. Não é migração nem port.**

Stack:
- HTML5;
- CSS3;
- JavaScript ES Modules;
- Canvas 2D;
- Vite;
- Web Audio API;
- Pointer Events;
- Capacitor como candidato de empacotamento Android após validação.

Godot/GDScript não fazem parte da implementação ativa. Não restaurar cenas, scripts, addons, autoloads, project settings, testes ou workflows Godot.

## 6.2 Princípios

Coesão alta; acoplamento controlado; dependências direcionadas e sem ciclos; composição; estado autoritativo separado de apresentação; simulação separada de renderização; input capturado independentemente do frame; dados separados da lógica quando útil; IDs estáveis; persistência separada do estado transitório; contratos explícitos; testes dos contratos críticos; evitar monólito, microfragmentação e estado global mutável; lifecycle e ownership explícitos; profiling antes de otimização.

## 6.3 Arquitetura lógica-alvo — proposta a validar

A organização abaixo representa responsabilidades, não módulos já implementados. Criar apenas o mínimo necessário para a primeira vertical slice; não gerar dezenas de módulos vazios.

~~~text
src/
  main.js
  app/
    application.js
    app-state.js
  core/
    clock.js
    fixed-step-loop.js
    events.js
    math.js
    diagnostics.js
  platform/
    browser-lifecycle.js
    display-mode.js
    safe-area.js
    capacitor-adapter.js
  input/
    input-manager.js
    pointer-router.js
    action-state.js
    action-buffer.js
    touch-layout.js
  runtime/
    game-runtime.js
    scene-director.js
    loading-coordinator.js
  gameplay/
    entities/
    player/
    physics/
    collision/
    combat/
    enemies/
    bosses/
    interactions/
  world/
    camera/
    platforms/
    hazards/
    triggers/
  levels/
    level-loader.js
    level-schema.js
    catalog/
    data/
  rendering/
    canvas-renderer.js
    render-layers.js
    sprites/
    effects/
  ui/
    screens/
    hud/
    components/
  audio/
    audio-manager.js
    buses.js
    asset-decode.js
  assets/
    asset-manifest.js
    asset-loader.js
  persistence/
    save-store.js
    save-schema.js
    migrations/
  config/
    game-config.js
    performance-profile.js
tests/
  unit/
  integration/
  browser/
~~~

## 6.4 Runtime e game loop

Requisitos a validar:
- relógio monotônico;
- simulação e render separados;
- avaliar fixed timestep para física;
- clamp de delta após suspensão/frame longo;
- política de catch-up e máximo de substeps;
- não executar centenas de passos ao retornar de background;
- interpolar render quando apropriado;
- renderer não altera estado de gameplay;
- pause/resume/visibility;
- métricas de frame time e input latency;
- determinismo suficiente para testes.

Valores de timestep, substeps e budgets devem ser definidos após implementação e profiling.

## 6.5 Canvas

Definir resolução lógica e política de scaling; controlar devicePixelRatio e backing store; não redimensionar canvas a cada frame; separar camadas quando justificável; evitar alocação no hot path; reutilizar recursos; limitar partículas; evitar filtros caros; considerar culling; preservar legibilidade e identidade; medir em dispositivos representativos.

## 6.6 Dados de conteúdo

Fases, inimigos e encontros usam schemas versionados e IDs estáveis. Validar conteúdo antes de entrar no runtime. Separar configuração de comportamento. Erro de conteúdo deve gerar diagnóstico útil, não falha silenciosa.

---

# 7. LOADING, ASSETS E ÁUDIO

## 7.1 Loading real

Loading representa trabalho real: carregar assets, decodificar imagem/áudio, preparar dados, inicializar subsistemas, construir estruturas de mundo, verificar dependências e liberar recursos anteriores.

Não usar espera artificial. Exibir progresso real ou estados honestos. Tratar falha, retry, cancelamento e retorno seguro. Pré-carregar somente o necessário para evitar picos de memória.

## 7.2 Manifesto de assets

Cada asset registra ID, path, tipo/formato, dimensões/duração, tamanho estimado, origem/autor, licença/proveniência, uso, mundo/fase, prioridade, preload, descarte, estado (placeholder/candidato/aprovado/final) e checksum quando útil.

Não integrar arte final sem aprovação explícita da versão exata pelo usuário. Aprovação de um asset não aprova versões futuras.

## 7.3 Áudio

Web Audio API deve considerar desbloqueio de AudioContext por gesto do usuário, buses master/music/SFX/UI/ambience, volume/mute persistentes, limite de vozes, prioridade de sons, pausa/suspensão/retomada, decode assíncrono, fallback e prevenção de clipping/latência desnecessária.

---

# 8. SAVE, CHECKPOINTS E PROGRESSÃO

Separar:
1. estado transitório de runtime;
2. estado de checkpoint/respawn;
3. estado persistente de campanha.

Requisitos: schema versionado; IDs estáveis para mundo/fase/fragmento/item/NPC/diálogo/flags; validação ao carregar; tratamento de corrupção; migrações explícitas; gravação atômica quando possível; proteção contra duplicação de recompensas; consistência entre fase/checkpoint/fragmentos/inventário/flags; encerramento inesperado; testes de cold start, save/load, corrupção e migração.

Não copiar schema antigo sem análise. Não alterar formato persistido sem estratégia de migração.

---

# 9. PERFORMANCE ANDROID

## 9.1 Perfil-alvo

Referência: Android com cerca de 4 GB RAM e MediaTek Helio G99 ou inferior. Meta próxima de 60 FPS quando aparelho e carga permitirem. Não prometer 60 FPS universal.

## 9.2 Métricas

- frame time p50/p95/p99;
- FPS médio e quedas;
- long tasks;
- input-to-action latency;
- memória JS/heap quando mensurável;
- backing store;
- custo de draw;
- decode;
- GC/alocações;
- cold start;
- loading/transições;
- temperatura/thermal throttling;
- tamanho do pacote Android.

Registrar dispositivo, Android, WebView, versão do app, resolução, DPR, modo de tela, duração, cena e condição térmica.

## 9.3 Estratégia

1. Criar baseline reproduzível.
2. Identificar gargalo com profiling.
3. Formular hipótese mensurável.
4. Alterar uma área por vez.
5. Reexecutar benchmark comparável.
6. Verificar regressão visual, física e input.
7. Registrar resultado e limitações.

Não otimizar por intuição nem sacrificar controles, física, conteúdo ou fidelidade sem decisão explícita.

---

# 10. QA E DEFINITION OF DONE

## 10.1 Camadas

- Unit tests: matemática, relógio, input, schemas, save.
- Integration tests: runtime, entidades, combate, loading, persistência.
- Browser tests: DOM, Canvas boot, resize, lifecycle e interações.
- Build checks: lint, testes e build de produção.
- Android WebView: compatibilidade, touch, fullscreen, lifecycle e áudio.
- Dispositivo físico: instalação, orientação, safe areas, barras, desempenho, memória, temperatura e sessões prolongadas.

Uma camada não substitui outra.

## 10.2 Casos críticos

Salto/Dash em sequência e simultâneos; multitouch; pointercancel; perda de foco durante ação; pausa/retomada; troca de cena com ponteiros ativos; frame longo/retorno de background; timestep/catch-up; colisão em alta velocidade; plataformas móveis; telegraph/hitbox; checkpoint/respawn; save corrompido; migração; loading interrompido; falha de asset; áudio bloqueado/suspenso; resize/safe area; fullscreen; softlocks.

## 10.3 Definition of Done

Tarefa substancial concluída somente quando critérios foram cumpridos, alterações limitadas ao escopo, testes adicionados/atualizados, lint/test/build executados quando aplicáveis, diff revisado, documentação/continuidade atualizada, limitações declaradas, estado sustentado por evidência e PR pronta para revisão.

---

# 11. ESTADO REAL DO REPOSITÓRIO — SNAPSHOT 28/11/2026

## 11.1 Repositório

- Repositório: jyanzy19-yml/new-bolt-aventura
- URL: https://github.com/jyanzy19-yml/new-bolt-aventura
- Branch principal: main
- HEAD de referência consultado: 9c32df4225b4e410340b2254a098167023593625
- Este HEAD é snapshot temporal; reconfirmar antes de qualquer tarefa.

## 11.2 Fundação HTML5 integrada

A fundação HTML5/Vite foi integrada por PR #121, após reconciliação da PR #117 e correções documentais da PR #120. PR #121 removeu 169 paths exclusivamente Godot da árvore ativa, preservando histórico Git e conteúdo de design.

Inventário do baseline: 417 paths classificados individualmente:
- 151 KEEP;
- 53 ADAPT;
- 44 ARCHIVE;
- 169 REMOVE;
- 0 REVIEW.

Não houve force-push nem reescrita de histórico. Arquivos removidos continuam recuperáveis nos commits anteriores.

## 11.3 Estado técnico implementado no HEAD de referência

- index.html monta #app.
- src/main.js renderiza somente shell/boot screen.
- src/styles.css contém estilo da tela inicial.
- src/core/math.js contém função clamp.
- tests/core/math.test.js testa clamp.
- Vite configurado.
- ESLint configurado.
- Vitest configurado.
- package.json contém scripts dev/build/preview/test/lint/format.
- package-lock.json versionado.
- CI usa Node 22, npm ci, lint, Vitest, build Vite e upload do artefato web.
- CodeQL configurado.
- Dependabot configurado.
- validação documental configurada.

**Limite:** isso é fundação de tooling e shell visual. Não existe neste snapshot gameplay HTML5 comprovado, player funcional, física, colisões, combate, fase jogável, save de jogo, Canvas runtime completo, áudio de gameplay, Capacitor, APK ou validação Android física.

## 11.4 Dependências

Dependências declaradas:
- @eslint/js
- eslint
- globals
- prettier
- vite
- vitest

Engines declaradas: Node >=22 e npm >=10. Lockfile v3 versionado. Não adicionar dependências sem justificativa de função, licença, manutenção, superfície de ataque, tamanho e impacto de build. Não executar npm audit fix --force automaticamente.

## 11.5 CI e PRs

Na PR #121:
- Documentation validation: SUCCESS;
- Web CI: SUCCESS (lint, testes, build e artefato);
- CodeQL: SUCCESS.

Na PR #132:
- npm ci: SUCCESS;
- lint: SUCCESS;
- Vitest: SUCCESS;
- build Vite: SUCCESS;
- CodeQL: SUCCESS.

PR #132 foi integrada por squash no commit de referência da main.

A PR #133, de sincronização documental, estava aberta no momento deste snapshot, com head 4961ec08932b03a109d885888a3896b1d54abd8b. Documentation validation, Web CI e CodeQL passaram nesse head. **Não afirmar que PR #133 está mesclada.** O usuário controla o merge.

## 11.6 Limpeza Godot

Removidos da árvore ativa apenas artefatos exclusivos:
- projeto/configurações/export Godot;
- cenas .tscn;
- recursos .tres;
- scripts .gd e UIDs;
- testes GDScript;
- workflows de validação/export Godot;
- skills exclusivas Godot;
- revisor específico da engine.

Preservados:
- bíblias e canon;
- narrativa, personagens e mundos;
- blueprint das 42 fases;
- documentos de produção úteis;
- histórico Git;
- validador documental Python;
- testes JS do scaffold;
- ícone SVG genérico;
- skills engine-neutral/HTML5;
- agentes e comandos compatíveis.

## 11.7 Documentos potencialmente desatualizados

O repositório mantém documentação histórica. Alguns arquivos ainda podem conter descrições Godot ou estados antigos:
- BOLT_MASTER_CONTEXT.md (dossiê original/histórico);
- documentos técnicos antigos em docs/technical/;
- trechos de docs/game-design/00-game-overview.md;
- registros históricos em COLLABORATION_STATE.md;
- snapshots anteriores a 28/11/2026.

Não usar instruções Godot como comandos ativos. Reaproveitar somente canon, requisitos, decisões e conteúdo engine-neutral. Manter explícito o que é histórico ao atualizar documentos.

---

# 12. GOVERNANÇA CHATGPT + CLAUDE CODE

## 12.1 Autoridade

ChatGPT e Claude Code são agentes implementadores autorizados. O usuário é proprietário do produto e mantém autoridade final sobre canon, escopo, decisões materiais, aprovação de arte e merge.

## 12.2 Um escritor primário

Cada tarefa deve ter:
- um escritor primário;
- um revisor read-only;
- branch isolada;
- commit-base;
- objetivo e escopo;
- paths permitidos e proibidos;
- dependências;
- critérios de aceite;
- testes;
- riscos;
- entregável e próximo responsável.

Não editar os mesmos arquivos simultaneamente. Se ambos precisarem do mesmo path, sequenciar o trabalho.

## 12.3 Divisão padrão recomendada

| Área | Liderança padrão | Observações |
|---|---|---|
| Arquitetura cross-system | ChatGPT | Claude pode implementar módulo delimitado |
| Runtime e loop | ChatGPT | Contratos centrais exigem revisão |
| Física e input | ChatGPT | Prioridade por risco de regressão |
| Performance, profiling e Android | ChatGPT | Exige evidência em aparelho |
| Level design e conteúdo | Claude | Bíblias e IDs estáveis |
| Inimigos e chefes | Claude | Contratos e testes de gameplay |
| NPCs, diálogos e eventos | Claude | Não canonizar conteúdo não aprovado |
| UI/UX e fluxos | Claude | Respeitar touch/safe areas |
| QA/revisão | Agente não autor | Read-only e achados por severidade |
| Integração | Agente designado | Um integrador por PR |

A tabela é roteamento padrão, não proibição de capacidade.

## 12.4 Política Git

- Usar agent/claude/<task> ou agent/chatgpt/<task>.
- Não fazer force-push.
- Não reescrever histórico.
- Não editar diretamente main em tarefas substanciais.
- Não mesclar PR própria.
- Não presumir integração.
- Inspecionar PRs/branches abertas antes de criar trabalho.
- Commits pequenos e semanticamente claros.
- Registrar commit e evidência na continuidade.

## 12.5 Template de handoff

~~~text
TASK ID:
PRIMARY WRITER:
REVIEWER:
BASE COMMIT:
BRANCH:
OBJECTIVE:
IN SCOPE:
ALLOWED PATHS:
FORBIDDEN / RESERVED PATHS:
DEPENDENCIES:
ACCEPTANCE CRITERIA:
REQUIRED TESTS:
KNOWN RISKS:
DELIVERABLE / PR:
NEXT OWNER:
~~~

## 12.6 Relatório obrigatório

ID da tarefa; escritor/revisor; commit-base/final; branch/PR; paths alterados; comportamento entregue; testes e resultados exatos; testes não executados e motivos; nível de validação; riscos; impacto em canon/ADR; próximo responsável.

---

# 13. PRÓXIMA FASE DE DESENVOLVIMENTO

## 13.1 Situação

A fundação de tooling existe, mas o runtime de jogo ainda precisa ser implementado. Não iniciar produção de dezenas de fases sem estabelecer runtime e vertical slice integrados.

## 13.2 Estratégia paralela recomendada

**Trilha A — ChatGPT: arquitetura/runtime**
1. Inspecionar HEAD e PRs abertas.
2. Formalizar arquitetura mínima e ADR HTML5, se necessário.
3. Criar boot/lifecycle e game loop.
4. Definir clock/timestep e política de pausa.
5. Definir input action model com Pointer Events e action buffer.
6. Criar Canvas renderer e resize policy.
7. Criar player/controller/physics mínimo.
8. Criar colisões e terreno simples.
9. Criar testes unitários e de integração.
10. Preparar contratos para conteúdo de fase.

**Trilha B — Claude Code: produção de conteúdo**
1. Ler fontes narrativas e de game design.
2. Criar pacote completo de Level Design W1-L1 sem modificar runtime.
3. Definir layout, fluxo, checkpoints, encontros, hazards, objetivos e segredos.
4. Produzir inventário de assets e áudio sem integrar arte final não aprovada.
5. Criar dados/schema somente após alinhar com contrato de nível.
6. Escrever critérios de QA e casos de teste.
7. Entregar em branch/PR isolada.
8. Aguardar revisão do ChatGPT e decisão do usuário.

Esta divisão permite paralelismo sem disputa de arquivos. A tarefa W1-L1 é recomendação de próxima atribuição, não deve ser tratada como já iniciada ou concluída sem handoff explícito.

## 13.3 Tarefa recomendada para Claude — BOLT-001

**TASK ID:** BOLT-001-W1L1-PRODUCTION-PACKAGE  
**PRIMARY WRITER:** Claude Code  
**REVIEWER:** ChatGPT  
**BASE COMMIT:** confirmar HEAD da main e PRs abertas antes de iniciar  
**BRANCH:** agent/claude/w1-l1-production-package  
**OBJECTIVE:** preparar especificação de produção de W1-L1 pronta para futura implementação HTML5.  
**IN SCOPE:** level design, conteúdo, encontros, narrativa local não-canônica marcada como proposta, checkpoints, hazards, segredos, assets, áudio, orçamento e QA.  
**ALLOWED PATHS:** novos documentos específicos sob docs/levels/w1-l1/ (ou diretório aprovado após inspeção), e eventual schema somente se previamente acordado.  
**FORBIDDEN:** src/**, tests/** do runtime, package.json, package-lock.json, workflows, loop, física, input, Canvas renderer, save schema, arquitetura central e paths de outro escritor.  
**DEPENDENCIES:** Bíblia dos Mundos, Bíblia Narrativa, Character Bible, Gameplay Systems, Level Design Standard, blueprint 42 fases e política de assets.  
**ACCEPTANCE:** ficha integral; mapa de fluxo; sequência ensinar/praticar/combinar/dominar; layout legível em paisagem; encontros justos; nenhum softlock; inventário de assets com status/proveniência; critérios testáveis; distinção entre canon e proposta.  
**TESTS:** validador documental, links locais, schema validation se criar dados, revisão narrativa e revisão de level design.  
**DELIVERABLE:** commits e PR com relatório completo.  
**NEXT OWNER:** ChatGPT para revisão e integração dos contratos.

Claude não deve inventar nome novo de guardião, alterar sequência narrativa ou exigir Dash como única forma de progressão em W1-L1. O blueprint indica movimento básico e introdução gradual; Dash permanece aprovado como mecânica do produto, mas não deve ser imposto como gate de W1-L1 sem reconciliação formal.

## 13.4 Critério para primeira vertical slice

A primeira vertical slice deve conter seção pequena e representativa:
- boot até gameplay;
- uma fase carregável;
- BOLT controlável;
- movimento e salto;
- Dash sob contrato aprovado;
- colisão com chão/plataformas;
- câmera;
- input touch multitouch;
- feedback visual mínimo;
- pausa/retomada;
- checkpoint simples;
- testes automatizados dos contratos essenciais;
- execução em browser e Android WebView, com limitações registradas.

Não precisa conter toda a campanha, mas deve provar integração real. Não declarar pronta sem teste touch em dispositivo físico quando exigido pela plataforma-alvo.

---

# 14. PROTOCOLO DE CONTINUIDADE

Antes de começar:
1. Consultar GitHub e confirmar HEAD.
2. Consultar PRs abertas e branches de agentes.
3. Ler estado de colaboração e continuidade.
4. Identificar ownership de paths.
5. Ler documentos específicos da tarefa.
6. Inspecionar código/testes reais.
7. Confirmar conflito de fonte ou ADR.
8. Definir mudança pequena e verificável.
9. Criar branch isolada.
10. Registrar baseline e critérios.

Durante:
- manter escopo;
- não refatorar áreas não relacionadas;
- adicionar testes para comportamento;
- documentar decisões;
- preservar canon e assets;
- parar em conflito material ou ownership ambíguo.

Ao concluir:
- rodar testes apropriados;
- revisar diff;
- validar links e documentação;
- atualizar continuidade;
- abrir PR;
- relatar o que foi e não foi testado;
- não mesclar sem autorização do usuário.

---

# 15. REGRAS DE NÃO REGRESSÃO

1. Não reintroduzir Godot/GDScript como stack ativa sem decisão explícita.
2. Não tratar HTML5 como port da implementação antiga.
3. Não remover Dash.
4. Não alterar física/tuning sem escopo e testes.
5. Não quebrar multitouch, jump ou Dash.
6. Não fazer input depender somente do frame de renderização.
7. Não ignorar lifecycle, pausa ou retomada.
8. Não ignorar safe areas ou diferenças fullscreen/normal.
9. Não prometer cobertura de status/navigation bars sem suporte/validação nativa.
10. Não alterar save schema sem migração.
11. Não usar espera artificial para loading.
12. Não declarar blockout como fase final.
13. Não declarar blueprint como conteúdo implementado.
14. Não declarar proposta como canon.
15. Não declarar build verde como prova de gameplay.
16. Não declarar APK como instalação.
17. Não declarar teste desktop como validação Android.
18. Não integrar assets sem proveniência/licença e aprovação exigida.
19. Não criar dependências sem justificativa.
20. Não executar npm audit fix --force automaticamente.
21. Não fazer force-push ou reescrever histórico.
22. Não mesclar PR sem decisão do usuário.
23. Não escrever simultaneamente nos mesmos paths.
24. Não inventar evidências, métricas ou resultados.
25. Não prometer ausência absoluta de bugs; reduzir risco com engenharia e validação.

---

# 16. GLOSSÁRIO

- ADR: Architecture Decision Record.
- APK/AAB: formatos de pacote Android.
- Blockout: geometria preliminar para validar fluxo e mecânicas.
- Canvas backing store: buffer de pixels do Canvas.
- Coyote time: tolerância de salto após sair de plataforma.
- Dash: deslocamento rápido aprovado como mecânica.
- Definition of Done: critérios objetivos de conclusão.
- Frame time: duração de processamento de um frame.
- Gate: marco de qualidade/produção.
- Input edge: evento de pressionar/soltar, distinto de held.
- Input buffer: retenção temporária de intenção de ação.
- Lifecycle: foco, pausa, suspensão e retomada.
- Multitouch: múltiplos ponteiros simultâneos.
- p95/p99: percentis de latência/frame time.
- Pointercancel: cancelamento do fluxo de ponteiro pelo navegador/sistema.
- Safe area: região livre de recortes e áreas reservadas.
- Softlock: estado que impede progressão sem necessariamente travar software.
- Vertical slice: recorte integrado que prova o fluxo principal.
- WebView: componente de navegador incorporado ao aplicativo Android.

---

# 17. DECLARAÇÃO FINAL

BOLT · AVENTURA é um produto 2D em reconstrução clean-start HTML5. Seu valor está na combinação de canon narrativo próprio, sete mundos distintos, campanha de 42 fases planejadas, gameplay responsivo, direção audiovisual coerente, UX mobile confiável e engenharia sustentável.

A fundação de repositório, tooling, lint, testes iniciais, build web, CodeQL e lockfile foi estabelecida. O runtime de gameplay e a vertical slice ainda precisam ser construídos. O trabalho seguinte deve avançar implementação real sem perder qualidade documental e rastreabilidade.

**Para ChatGPT:** liderar arquitetura, runtime, física/input, integração, profiling, Android e QA cross-system por tarefas delimitadas.  
**Para Claude Code:** liderar pacotes independentes de conteúdo, level design, inimigos, chefes, UI e sistemas atribuídos, com ownership explícito.  
**Para ambos:** respeitar canon, stack HTML5, estado real do GitHub, critérios de aceite e protocolo de um escritor primário.  
**Para o usuário:** manter autoridade sobre canon, escopo, decisões materiais, assets e merge.

A missão não é produzir o maior número de arquivos ou commits. É construir um jogo completo, integrado, jogável, verificável e sustentável, com cada avanço apoiado por evidência.

---

# APÊNDICE A — FONTES UTILIZADAS

1. Dossiê Mestre de Contexto enviado pelo usuário em 26/11/2026. Seu conteúdo foi tratado como fonte de produto/requisitos, mas a stack Godot foi superada.
2. MASTER_DIRECTIVE.md, incluindo addendum HTML5 clean-start e protocolo de colaboração.
3. AGENTS.md e CLAUDE.md.
4. docs/PROJECT_CONTEXT_HTML5.md.
5. Bíblias de narrativa, mundos, personagens, gameplay, level design e direção de arte/áudio.
6. Blueprint expandido de 42 fases.
7. COLLABORATION_STATE.md e CONTINUITY.md.
8. Inventário de limpeza de 28/11/2026.
9. Arquivos executáveis/configuração do scaffold HTML5 consultados no HEAD indicado.
10. Estado de workflows e PRs observado durante a consolidação.

# APÊNDICE B — LIMITES DO SNAPSHOT

- HEAD e estado de PR são fotografias temporais; reconfirmar no GitHub.
- O conteúdo detalhado das 42 fases deve ser consultado no blueprint original.
- A implementação real deve ser inspecionada antes de qualquer alteração.
- A arquitetura lógica proposta não equivale a módulos já implementados.
- Capacitor permanece candidato, não integração concluída.
- Não há gameplay HTML5 ou vertical slice comprovada neste snapshot.
- PR #133 estava aberta e não mesclada, embora os checks conhecidos tenham passado.
- Documentos históricos podem conter estados contraditórios; aplicar a hierarquia e registrar reconciliações.
