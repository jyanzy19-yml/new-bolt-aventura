# Registro de lacunas e decisões — Etapa 02

**Data:** 2026-11-26  
**Base:** PR #49 integrada em d03cd744b2354bd9711894eab431dbc6912ca9d3.  
**Objetivo:** transformar as lacunas identificadas nas fontes canônicas em itens explícitos de decisão, produção e validação. Este registro não cria canon, não define balanceamento e não autoriza implementação irreversível.

## 1. Regras de classificação

- **CANON APROVADO:** já definido em prompt mestre, bíblia ou ADR; não reabrir sem instrução do usuário.
- **REQUISITO:** comportamento obrigatório que precisa ser implementado e testado.
- **PROPOSTA:** solução criativa/técnica sugerida; pode orientar protótipo reversível, mas não é canon.
- **A DEFINIR:** falta informação suficiente para fechar o requisito.
- **IMPLEMENTADO / VALIDADO:** estados distintos; validar exige evidência identificada.
- **BLOQUEIO:** só quando a lacuna impede uma tarefa concreta; não usar como desculpa para parar trabalho independente.

A hierarquia da fonte é a do MASTER_DIRECTIVE.md e da diretriz mestra de design. Esta lista complementa a matriz de 26 etapas, não a substitui.

## 2. Lacunas priorizadas

| ID | Prioridade | Domínio | Estado atual / fato confirmado | Lacuna ou decisão necessária | Fonte principal | Etapas |
|---|---|---|---|---|---|---|
| GAP-001 | P0 | Vertical slice W1 | W1-L1 e W1-L2 existem em blockout; W1-L2 tem checkpoint, campo energético e progressão persistente | Fechar blueprint detalhado de cada segmento, ritmo, encounters, rotas, checkpoints, objetivos e QA humano; não apresentar blockout como fase final | game-design/05-level-design-standard.md; blueprint de 42 fases; cenas W1-L1/W1-L2 | 02, 16, 18, 19, 20 |
| GAP-002 | P0 | Movimento / física | BoltPlayer, Dash, salto, pulo duplo, coyote e ActionBuffer existem; BoltTuning é provisório | Aprovar tuning por playtest e captura comparativa; documentar prioridade de ações simultâneas e regras de cancelamento | game-design/04-gameplay-systems.md; EXPANDED-GAMEPLAY-SYSTEMS.md; ADR-001-DASH | 02, 06, 07, 25 |
| GAP-003 | P0 | Android / touch | Touch/multitouch e safe area têm testes sintéticos; preset Android e APK debug exportável | Executar instalação, cold start, toque físico, pausa, foco, retomada, barras, recortes e safe area em aparelho identificado | ADR-0001/0003; technical/02-touch-and-display.md; templates QA Android | 02, 21, 24, 25 |
| GAP-004 | P0 | Save / progressão | SaveSystem v1 e CampaignProgress v1 existem; checkpoints W1-L1/W1-L2 | Validar persistência após encerramento forçado e lifecycle Android; definir política de reset seletivo e migrações antes de ampliar domínios | ADR-0004/0005; technical/07-save-system.md; technical/08-campaign-progress.md | 02, 04, 10, 20, 25 |
| GAP-005 | P1 | BOLT | Protagonista robô desperta sem memória em Cybercore; função original ligada à preservação dos universos é canon | Definir aparência final, silhueta, personalidade, voz/ausência de voz, expressões, origem técnica específica, limitações e arco emocional | game-design/03-character-bible.md; narrativa bíblia; prompt mestre | 02, 06, 08, 20, 22 |
| GAP-006 | P1 | NEXO | Máquina temporal chamada NEXO une-se a BOLT e permite viajar por eras/mundos; ligada aos fragmentos | Definir forma, comunicação, personalidade/consciência, origem, limites, custo/risco de viagem e evolução audiovisual | game-design/03-character-bible.md; EXPANDED-NARRATIVE-DOSSIER.md (proposta) | 02, 16, 20, 22 |
| GAP-007 | P1 | Arquiteto | Antagonista central canon; deseja impor uma única realidade e eliminar a coexistência | Definir história completa, métodos, motivação secundária, presença por mundo e relação específica com guardiões sem contradizer o conflito central | game-design/01-narrative-bible.md; prompt mestre | 02, 15, 20 |
| GAP-008 | P1 | Fragmentos | Sete fragmentos e sua ordem são canon: Origem, Memória, Verdade, Sombra, Luz, Ilusão, Equilíbrio | Definir origem, funcionamento, manifestação, efeito de cada aquisição e regra final de recomposição do Núcleo; não presumir criador | game-design/02-world-bible.md; narrativa bíblia; prompt mestre | 02, 16, 17, 20 |
| GAP-009 | P1 | 42 fases | Estrutura fixa: sete mundos × seis fases; fase 6 culmina em guardião/fragmento/transição | Converter cada proposta do blueprint em ficha de fase aprovada com fluxo, mapa, duração-alvo, conteúdo, assets, checkpoints, acessibilidade e budgets | EXPANDED-42-LEVEL-CAMPAIGN-BLUEPRINT.md (propostas); 05-level-design-standard.md | 02, 16, 17, 18 |
| GAP-010 | P1 | Inimigos | Meta de pelo menos cinco arquétipos realmente distintos por mundo; existe patrulheiro Cybercore provisório | Definir catálogo por mundo, estados, percepção, telegraphs, contra-jogo, limites simultâneos e testes; evitar recolor como arquétipo | game-design/03-character-bible.md; EXPANDED-GAMEPLAY-SYSTEMS.md | 02, 13, 14, 17, 18 |
| GAP-011 | P1 | Chefes | Um guardião protege o fragmento ao final de cada mundo; títulos descritivos são canon | Definir fichas de sete chefes, fases, padrões, telegraphs, vulnerabilidade, arenas, retry e recompensa; não inventar nomes próprios | Bíblias de mundo/personagem; blueprint de 42 fases | 02, 15, 17, 18, 20 |
| GAP-012 | P1 | Arsenal | Pistola Crono conectada ao combate básico; valores provisórios | Definir função/progressão/limites de Tríplice Prisma e Laser Nexo (ambos propostas), slots, cooldown, dano e UX antes de implementar | EXPANDED-GAMEPLAY-SYSTEMS.md; game-design/04-gameplay-systems.md | 02, 11, 12, 21 |
| GAP-013 | P1 | Arte | Placeholders geométricos e ícone placeholder; estilo final não foi confirmado | Aprovar resolução-base, pixel-art/estilo, escala, paletas, silhuetas, atlas, animações e pipeline/licenças | game-design/07-art-audio-direction.md; production/ASSET_PIPELINE.md | 02, 08, 17, 22 |
| GAP-014 | P1 | Áudio | Não foi identificada implementação de áudio de gameplay | Definir tema, assinaturas dos mundos, buses, mix, controles de volume, foco/retomada, SFX críticos e licenças | game-design/07-art-audio-direction.md; prompt mestre | 02, 21, 23 |
| GAP-015 | P1 | Narrativa / NPCs | Premissa, sequência de abertura e conflito central definidos; abertura/tutorial são provisórios | Criar elenco funcional, diálogos por IDs, flags, cenas e revelações progressivas; manter causalidade e skip/replay | game-design/01-narrative-bible.md; EXPANDED-NARRATIVE-DOSSIER.md (proposta) | 02, 17, 20 |
| GAP-016 | P1 | UI / acessibilidade | Menu, HUD, pausa, loading e touch básicos existem | Completar configurações, escalas/contraste, volume, redução de efeitos, feedback de estados touch, navegação e acessibilidade aprovada | game-design/06-ui-ux.md; technical/02-touch-and-display.md | 02, 21, 24 |
| GAP-017 | P1 | Performance | Android debug exporta; meta de hardware inclui aparelhos modestos de 4 GB / classe Helio G99 ou inferior | Definir cenários/budgets, coletar p50/p95/p99, memória, temperatura, load time e sessões longas em hardware identificado | technical/01-android-performance.md; templates QA | 02, 05, 24, 25 |
| GAP-018 | P2 | Package identity | com.example.boltaventura é placeholder; APK atual é debug | Proprietário deve escolher application ID definitivo e manter compatibilidade/migração; não inventar domínio | export_presets.cfg; android-release-checklist.md | 02, 24, 26 |
| GAP-019 | P2 | Inventário / economia | Inventário, moedas, melhorias e skins não estão implementados; não são necessários à vertical slice atual sem loop aprovado | Decidir se existe economia real e qual função; não criar moedas/colecionáveis sem uso de design | game-design/04-gameplay-systems.md; prompt mestre; tracker SYS-013/016 | 02, 12, 16, 20 |
| GAP-020 | P2 | Localização | Documentos e UI atual usam pt-BR | Definir idiomas-alvo, pipeline de strings/IDs, fontes, expansão de texto e QA; não atrasar gameplay por idiomas não aprovados | game-design/01-narrative-bible.md; prompt mestre | 02, 20, 21, 26 |
| GAP-021 | P1 | Legado do protótipo | O protótipo HTML histórico continha Blast, Voar e seleção de armas 1–3; o escopo Godot atual não apresenta equivalência explícita para todos esses comandos | Comparar o protótipo legado com o prompt/canon atual e registrar para cada habilidade: preservada, substituída, removida por decisão ou pendente. Não reintroduzir nem descartar silenciosamente | Histórico técnico do projeto; MASTER_DIRECTIVE.md; prompt mestre; ADRs | 02, 06, 07, 11, 12 |
| GAP-022 | P2 | Release / créditos | Campanha, arte e áudio finais ainda não existem; release candidate não iniciado | Definir créditos, proveniência, assinatura release, versão, changelog, migração e checklist de publicação | definition-of-done.md; android-release-checklist.md; prompt mestre | 02, 22, 23, 25, 26 |

## 3. Decisões já fechadas — não reabrir sem solicitação

| ID | Decisão | Fonte |
|---|---|---|
| DEC-001 | Godot 4.7.2 e GDScript; não migrar de engine sem aprovação | ADR-0002; .godot-version |
| DEC-002 | Android empacotado, orientação paisagem; navegador não é plataforma-alvo | ADR-0001; 00-game-overview.md |
| DEC-003 | Dash permanece; não remover nem retunar incidentalmente | ADR-001-DASH |
| DEC-004 | Política imersiva do Android oculta status/navigation bars durante o jogo, inclusive com toggle de tela cheia da UI desligado; não prometer ocultação absoluta contra o SO | ADR-0003; 06-ui-ux.md |
| DEC-005 | Sete mundos, ordem e fragmentos fixos; 42 fases planejadas, seis por mundo | 02-world-bible.md; prompt mestre |
| DEC-006 | Abertura → tutorial guiado por robô mensageiro → campanha em Cybercore | narrativa bíblia; prompt mestre |
| DEC-007 | BOLT foi criado para preservar os universos; Arquiteto busca impor uma única realidade | narrativa bíblia; prompt mestre |
| DEC-008 | Um único escritor ativo; ChatGPT conduz até decisão diferente do usuário | COLLABORATION_STATE.md |\n| DEC-009 | CampaignProgress v1 persiste W1-L1→W1-L2; sem destino W1-L3 até existir cena e integração reais | ADR-0006 |

## 4. Sequência de resolução

1. Fechar GAP-001 a GAP-004 para elevar Gate 1 e estabilizar a vertical slice; validar em CI e aparelho quando disponível.
2. Fechar GAP-005 a GAP-008 em documentos de design com canon/proposta explícitos, antes de escrever revelações irreversíveis.
3. Transformar GAP-009 a GAP-011 em fichas de produção de mundo/fase/inimigo/chefe, começando por Cybercore.
4. Fechar GAP-012 a GAP-017 conforme a vertical slice justificar; evitar expandir arsenal, arte, áudio e UI em paralelo sem contratos.
5. Resolver GAP-018 e GAP-022 antes de release; GAP-019/020 somente quando o loop e a distribuição exigirem.
6. Resolver GAP-021 por comparação de fontes do protótipo legado com o escopo atual, preservando a intenção original sem assumir que todo botão antigo permanece canon.

## 5. Critério de conclusão da Etapa 02

Etapa 02 só pode ser marcada como concluída quando:
- cada requisito de produto tem fonte e classificação;
- conflitos entre documentos foram corrigidos ou registrados;
- todas as lacunas materiais têm ID, prioridade, dependências e decisão/owner;
- propostas criativas permanecem identificadas como propostas;
- requisitos P0 do Gate 1 têm critérios de aceite verificáveis;
- a matriz de 26 etapas e o tracker apontam para as mesmas evidências;
- não há instrução operacional obsoleta contradizendo o estado real do repositório.


## 6. Owners, dependencies e aceite dos requisitos P0

### 6.1 Ownership e dependências

O escritor operacional é ChatGPT. O usuário mantém autoridade final sobre canon, identidade, escopo de produto, package ID e decisões materiais. Para QA físico, ChatGPT prepara build/checklist e interpreta evidência; a execução no aparelho depende de dispositivo disponível e participação do usuário.

| ID | Responsável pela preparação/implementação | Autoridade de decisão / validação | Dependências principais |
|---|---|---|---|
| GAP-001 | ChatGPT — blueprint, blockout e regressões | Usuário aprova experiência e decisões de design; QA humano valida | GAP-002, GAP-003, GAP-004, GAP-016 |
| GAP-002 | ChatGPT — tuning, instrumentação e testes | Usuário avalia sensação; aprovação de mudanças de física | GAP-003 |
| GAP-003 | ChatGPT — build, checklist e correções | Usuário executa/observa teste físico; resultados vinculados ao aparelho | GAP-018 apenas para release |
| GAP-004 | ChatGPT — save schema, migrações e testes | Usuário valida recuperação e política de progresso; dados não podem ser apagados sem decisão | GAP-003 |
| GAP-005 | ChatGPT — proposta de personagem e documentação | Usuário aprova canon | GAP-008 |
| GAP-006 | ChatGPT — proposta de NEXO e regras de viagem | Usuário aprova canon | GAP-008, GAP-015 |
| GAP-007 | ChatGPT — proposta de antagonista e estrutura de revelações | Usuário aprova canon | GAP-008, GAP-015 |
| GAP-008 | ChatGPT — proposta de funcionamento dos fragmentos | Usuário aprova canon | GAP-005, GAP-006, GAP-007 |
| GAP-009 | ChatGPT — fichas das 42 fases | Usuário aprova alterações de canon/títulos finais | GAP-005…GAP-017 conforme a fase |
| GAP-010 | ChatGPT — catálogo de inimigos e protótipos | Usuário aprova conteúdo autoral relevante | GAP-005, GAP-009, GAP-013 |
| GAP-011 | ChatGPT — fichas de chefes e protótipos | Usuário aprova conteúdo autoral relevante | GAP-008, GAP-009, GAP-010, GAP-012 |
| GAP-012 | ChatGPT — proposta de armas, contratos e testes | Usuário aprova arsenal/loop de progressão | GAP-002, GAP-005, GAP-006 |
| GAP-013 | ChatGPT — pipeline, proveniência e propostas visuais | Usuário aprova direção visual final | GAP-005, GAP-006, GAP-009 |
| GAP-014 | ChatGPT — arquitetura de áudio e especificação | Usuário aprova direção musical/sonora | GAP-013, GAP-015 |
| GAP-015 | ChatGPT — estrutura de cenas, NPCs e diálogos | Usuário aprova canon e diálogos definitivos | GAP-005, GAP-006, GAP-007, GAP-008 |
| GAP-016 | ChatGPT — fluxos, componentes e QA de UI | Usuário aprova opções de produto/acessibilidade material | GAP-003, GAP-005 |
| GAP-017 | ChatGPT — budgets, captura e análise | Usuário disponibiliza aparelho; critérios de release aprovados pelo proprietário | GAP-003, GAP-013, GAP-014 |
| GAP-018 | ChatGPT — documentar e preparar export | Usuário escolhe application ID definitivo | GAP-022 |
| GAP-019 | ChatGPT — estudo de loop e alternativas | Usuário decide se economia/inventário fazem parte do produto | GAP-009, GAP-012 |
| GAP-020 | ChatGPT — avaliar pipeline e custo | Usuário define idiomas-alvo | GAP-015, GAP-016 |
| GAP-021 | ChatGPT — comparar escopo legado com fontes disponíveis | Usuário decide preservação, substituição ou retirada de cada habilidade | GAP-002, GAP-012 |
| GAP-022 | ChatGPT — checklist e proveniência | Usuário controla assinatura/credenciais e aprovação de release | GAP-013, GAP-014, GAP-017, GAP-018 |

### 6.2 Critérios de aceite verificáveis dos P0 do Gate 1

| ID | Critério verificável | Evidência obrigatória |
|---|---|---|
| GAP-001 | W1-L1 e W1-L2 possuem blueprints versionados; rota principal concluível; objetivos claros; checkpoints recuperáveis; sem softlock; encontros usam somente regras ensinadas; blockout e final art não são confundidos | Fichas de fase aprovadas, testes de cena/integração, playtest registrado e captura de issues |
| GAP-002 | Movimento independente do FPS renderizado; regras de salto/Dash/coyote/buffer determinísticas; input simultâneo e cancelamento definidos; nenhuma ação essencial perdida ou presa | Testes headless de borda, captura comparativa de física, playtest touch e frame pacing no aparelho de referência |
| GAP-003 | APK instala e abre; orientação paisagem; barras seguem ADR-0003; botões essenciais permanecem tocáveis; multitouch funciona; pause/focus/background/retomada não deixam input preso | Matriz por modelo/Android/build, vídeo/capturas, checklist preenchido e logs de falha |
| GAP-004 | Save válido persiste após encerramento normal e forçado; backup recupera corrupção; versão futura não sobrescreve dados; Nova Jornada reseta apenas o domínio aprovado; checkpoint não produz estado impossível | Testes automatizados de serialização/migração, teste de lifecycle Android e evidência de save antes/depois |

Os critérios acima são gates de aceite, não resultados já alcançados. A existência de CI headless e APK exportado não satisfaz, por si só, os itens de playtest e dispositivo. A vertical slice não deve esperar pelo catálogo completo de inimigos ou pelo arsenal futuro: W1-L1/W1-L2 podem ser aprovadas com os componentes representativos já existentes, desde que o design os justifique; GAP-010 e GAP-012 avançam conforme a necessidade real de conteúdo.

## 7. Conflitos e lacunas de documentação identificados

| ID | Observação | Tratamento |
|---|---|---|
| DOC-001 | Direção de arte dizia que os temas específicos dos sete mundos ainda seriam definidos, embora a Bíblia dos Mundos já fixe suas identidades centrais | Clarificado em game-design/07-art-audio-direction.md: identidade central aprovada; paletas, materiais e assinaturas detalhadas ainda a aprovar |
| DOC-002 | Character Bible listava a origem de BOLT como pendente sem separar sua função original já canonizada | Clarificado em game-design/03-character-bible.md: função de preservação dos universos é canon; origem técnica específica permanece pendente |
| DOC-003 | Seção 50 do prompt mestre apontava como próxima prioridade um bug de coletável já resolvido e dizia para não criar W1-L2, embora W1-L2 exista em blockout | Corrigido pela PR #49; próxima prioridade passou a consultar a matriz/Etapa 02 e a vertical slice real |
| DOC-004 | Snapshot de continuidade e colaboração estava em PR #45/#46 e não refletia PR #47/#48 | Corrigido pela PR #49; snapshots passam a refletir HEAD atual e evidências pós-merge |
| DOC-005 | Arquitetura técnica dizia que o repositório ainda não continha projeto executável nem versão comprovada | Corrigido nesta unidade: Godot 4.7.2, projeto, cenas e pipeline CI confirmados | 
| DOC-006 | Fundação técnica dizia que não havia cenas de campanha, export Android ou autoloads além de SceneFlow; Input attack aparecia sem consumidor | Corrigido nesta unidade: W1-L1/W1-L2, APK debug CI, quatro autoloads e BoltCombat documentados | 
| DOC-007 | Documento de loading referia-se a branch temporária fix/scene-flow-input-lock como unidade não integrada | Corrigido: referência substituída pela PR #42 integrada | 
| DOC-008 | Contratos de sistemas ainda descreviam todos os nomes como conceituais, apesar de contratos implementados de SceneFlow, plataformas e loading | Corrigido: documento distingue contratos já ancorados no código e requisitos ainda conceituais |
| DOC-009 | SaveSystem/ CampaignProgress technical docs ainda diziam que o modelo de campanha não estava integrado e que somente W1-L1 existia | Corrigido: CampaignProgress persiste W1-L1 e W1-L2; SaveSystem continua agnóstico aos domínios | 
| DOC-010 | ADR-0004 e ADR-0005 preservavam como estado atual que W1-L2 não existia e Continuar aceitava somente W1-L1 | Corrigido sem reescrever histórico: ADR-0006 formaliza a extensão W1-L1→W1-L2; ADRs originais recebem emendas históricas | 
| DOC-011 | Game Overview citava somente W1-L1 como blockout de campanha | Corrigido: W1-L1 e W1-L2 são blockouts; demais 40 fases ainda não existem |

## 8. Estado de conclusão da Etapa 02

O registro cobre 22 lacunas, oito decisões fechadas, owners, dependências, critérios verificáveis para os quatro requisitos P0 e onze conflitos/documentos obsoletos identificados (DOC-001…DOC-011). Ainda falta revisar cada linha contra o prompt mestre e todas as especificações, confirmar se há lacunas omitidas, registrar aprovação das decisões materiais e manter a matriz/tracker sincronizados. **Etapa 02 permanece EM DESENVOLVIMENTO.**
