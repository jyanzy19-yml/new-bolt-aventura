# Plano Mestre de Produção — BOLT · AVENTURA
## Estrutura operacional aprovada em 32 etapas

**Versão:** 1.0 · **Aprovação do usuário:** 27/11/2026  
**Engine:** Godot 4.7.2 / GDScript · **Produto:** Android empacotado, paisagem  
**Escopo macro:** sete mundos e 42 fases, conforme as fontes canônicas do repositório  
**Autoridade:** subordinado às instruções atuais do usuário, ADRs, bíblias e `MASTER_DIRECTIVE.md`

---

## 1. Autoridade, propósito e regras de leitura

Este documento formaliza a divisão aprovada de 32 etapas em oito fases de produção. É o plano operacional primário; não substitui a diretiva mestra, bíblias, especificações, ADRs, contratos técnicos, QA ou estado verificável do projeto.

A aprovação da estrutura não aprova automaticamente conteúdo, canon, arte, arquitetura, implementação, merge ou release. Em caso de conflito, prevalecem as fontes de maior autoridade descritas em `MASTER_DIRECTIVE.md`. Propostas devem continuar identificadas como propostas. Lacunas narrativas e de design não podem ser preenchidas silenciosamente como fatos.

### Vocabulário obrigatório

| Estado | Significado |
|---|---|
| NÃO INICIADA | Nenhuma execução rastreável identificada |
| EM ANDAMENTO | Trabalho parcial; critérios não atendidos |
| IMPLEMENTADA | Entrega executável presente, validação ainda incompleta |
| VALIDADA | Critérios aplicáveis passaram com evidências e ambiente registrados |
| BLOQUEADA | Dependência real impede avanço; impacto e responsável documentados |
| NÃO APLICÁVEL | Exclusão justificada e aprovada |

Não usar percentuais subjetivos. Arquivo criado, documento escrito, APK exportado, feature implementada e etapa validada são estados diferentes.

### Princípios transversais

1. Inspecionar HEAD, branch, PRs, arquivos, dependências e contratos antes de editar.
2. Evoluir a fundação Godot existente; não recriar o projeto nem duplicar sistemas.
3. Rastrear requisito → fonte → etapa → sistema/fase/asset → implementação → teste → evidência.
4. Preservar IDs persistentes, schema de save, InputMap, Dash aprovado, física, multitouch, progressão, canon, orientação e decisões Android.
5. Otimizar com medições comparáveis; não degradar qualidade por suposição.
6. Separar blockout, placeholder, concept, asset aprovado, integrado e verificado.
7. Touch, safe areas, barras do sistema, lifecycle e Android físico são critérios de produto.
8. Cada fase e mundo deve ter propósito, identidade e variação real; não produzir recolorações ou conteúdo intercambiável.
9. Um bloqueio localizado não paralisa tarefas independentes e reversíveis.
10. Retomar do último checkpoint verificável, sem reiniciar ou duplicar trabalho.

---

## 2. Plano detalhado — 32 etapas

# FASE I — ENGENHARIA E PREPARAÇÃO

### 01 — Auditoria integral do repositório
**Objetivo:** estabelecer o estado real do produto e do repositório.  
**Escopo:** branch/HEAD/histórico; árvore; versão Godot; project/export settings; cenas; scripts; recursos; autoloads; dependências; plugins; workflows; testes; ADRs; documentação; PRs; riscos.  
**Entregáveis:** inventário; mapa arquitetural observado; classificação implementado/parcial/provisório/ausente/defeituoso/não verificado; baseline de CI e lista de riscos.  
**Aceite:** evidências ligadas a arquivos/commits; nenhuma alegação de teste físico sem aparelho; divergências e limites explicitados.

### 02 — Consolidação de requisitos, canon e documentação
**Objetivo:** reconciliar intenção do produto e fontes oficiais sem inventar decisões.  
**Escopo:** bíblias; Atlas de 42 fases; gameplay; personagens; mundos; UI/UX; arte/áudio; ADRs; requisitos Android; lacunas e conflitos.  
**Entregáveis:** registro de requisitos/lacunas; matriz de fontes; decisões pendentes; canon e escopo classificados.  
**Aceite:** requisitos materiais possuem fonte, classificação, etapa e critério verificável; conflitos de canon permanecem abertos até decisão autorizada.

### 03 — Arquitetura técnica e contratos dos sistemas
**Objetivo:** definir limites de responsabilidade, ownership e interfaces.  
**Escopo:** arquitetura Godot; composição de cenas; autoloads; sinais; recursos de dados; persistência; input; fluxo de cenas; interfaces entre player, fase, UI, narrativa e conteúdo.  
**Entregáveis:** mapa arquitetural; contratos; dependências; convenções de nomes/IDs; ADRs necessárias.  
**Aceite:** ownership explícito; dependências sem ciclos indevidos; contratos verificáveis; nenhuma duplicação de autoridade.

### 04 — Infraestrutura central, inicialização, salvamento e progressão
**Objetivo:** garantir runtime confiável para a campanha.  
**Escopo:** Boot; SceneFlow; LoadingOverlay; SaveSystem; CampaignProgress; integridade; checkpoints; novo jogo/continuar; falhas e lifecycle.  
**Entregáveis:** serviços integrados; schema/contratos; regressões; fluxo inicial e recuperação segura.  
**Aceite:** boot/transições previsíveis; concorrência controlada; save versionado/validado; dados válidos preservados; CI aprovada. CI não substitui validação física.

# FASE II — FUNDAÇÃO VISUAL E IDENTIDADE ARTÍSTICA

### 05 — Direção de arte e identidade visual global
**Objetivo:** definir linguagem visual unificadora e permitir identidades próprias dos mundos.  
**Escopo:** estilo; proporções; silhuetas; paleta global; contraste; iluminação; materialidade; composição; legibilidade mobile; relação entre personagem, cenário, UI e VFX.  
**Entregáveis:** documento de direção de arte; referências autorizadas; princípios de consistência; critérios de leitura; distinção entre canon visual e proposta.  
**Aceite:** direção documentada, coerente com as bíblias e aprovada pelo usuário quando constituir decisão visual material.

### 06 — Guia técnico de produção de sprites e assets
**Objetivo:** tornar a direção de arte reproduzível e tecnicamente importável.  
**Escopo:** dimensões; resolução-base; escala; alpha; pivôs; margens; frame grid; ordem; FPS; nomenclatura; formatos; compressão; filtros; atlas; colisões; budgets e proveniência.  
**Entregáveis:** guia técnico; templates; convenções; manifesto; checklist de revisão e budgets iniciais marcados como hipóteses.  
**Aceite:** especificação suficiente para produção/importação sem adivinhação; campos não aplicáveis são omitidos, não inventados.

### 07 — Concept art do protagonista BOLT e aprovação visual
**Objetivo:** estabelecer a representação visual consistente do protagonista.  
**Escopo:** silhueta; proporções; materiais; face/expressão; elementos distintivos; vistas; poses; leitura em escala de gameplay.  
**Entregáveis:** concepts identificados por versão; folha de personagem; brief técnico preliminar; feedback e decisão registrados.  
**Aceite:** aprovação explícita do usuário para a direção escolhida; concept não aprovado não pode ser integrado como arte oficial.

### 08 — Spritesheets e animações de BOLT, com aprovação
**Objetivo:** produzir recursos finais a partir do concept aprovado.  
**Escopo:** estados aprovados; consistência entre frames; pivôs; alpha; margens; timing; exportação; otimização.  
**Entregáveis:** spritesheets; mapa de frames; especificação de animação; exports; proveniência; prévia em escala nativa e contexto de gameplay.  
**Aceite:** apresentar cada entrega e aguardar aprovação explícita antes de integrar; depois verificar import, alinhamento, timing e custo no Godot.

### 09 — Primeiros elementos de interface e HUD, com aprovação
**Objetivo:** estabelecer linguagem visual funcional da interface.  
**Escopo:** hierarquia; tipografia; ícones; botões; painéis; estados; HUD; paisagem e safe areas.  
**Entregáveis:** concepts; kit visual inicial; estados; layouts de referência; catálogo de componentes.  
**Aceite:** proposta visual aprovada antes da integração; funcionalidade, legibilidade e acessibilidade também precisam de validação técnica.

# FASE III — PERSONAGEM E GAMEPLAY

### 10 — Implementação definitiva do personagem
**Objetivo:** consolidar arquitetura e comportamento de runtime do protagonista.  
**Escopo:** composição; estados; vida/recuperação conforme especificação; interfaces; tuning; câmera; animação; input e progressão.  
**Entregáveis:** personagem integrado; contratos; testes de estado/lifecycle; separação lógica/apresentação.  
**Aceite:** comportamento coerente com fontes aprovadas; sem duplicação de autoridade; regressões automatizadas; arte final apenas após aprovação.

### 11 — Física, movimentação e controles touchscreen
**Objetivo:** garantir controle previsível e responsivo em Android.  
**Escopo:** movimento; aceleração; salto e variantes aprovadas; buffer; coyote time; Dash aprovado; colisões; multitouch; ponteiros; pausa/foco/retomada; frame-time elevado.  
**Entregáveis:** tuning documentado; testes automatizados; matriz de combinações touch; procedimento de teste físico.  
**Aceite:** input essencial confiável; física independente de renderização quando exigido; Dash preservado; feel final validado por playtest e aparelho real.

### 12 — Animações integradas e sincronização com gameplay
**Objetivo:** sincronizar apresentação com estado de runtime sem acoplar animação à física.  
**Escopo:** state mapping; transições; interrupções; prioridades; callbacks; aterrissagem; feedback e sincronização de ações.  
**Entregáveis:** mapa estado→animação; controladores; testes de transição; revisão visual/performance.  
**Aceite:** animação não altera física, não bloqueia input essencial nem contradiz estado de gameplay.

### 13 — Câmera, colisões e sistemas espaciais
**Objetivo:** consolidar apresentação espacial e contratos de mundo.  
**Escopo:** câmera; limites; zonas; áreas de ativação; colisões; plataformas; volumes; transições e proporções de tela.  
**Entregáveis:** contratos espaciais; cenas reutilizáveis; testes de borda; padrões de composição.  
**Aceite:** sem áreas inválidas expostas, informação crítica cortada, colisões inconsistentes ou softlocks geométricos; revisão visual Android.

### 14 — Interações, sobrevivência, checkpoints e recuperação
**Objetivo:** consolidar interação ambiental e continuidade do jogador.  
**Escopo:** objetos; pickups; hazards; checkpoints; respawn; recuperação conforme design; falhas; persistência e feedback.  
**Entregáveis:** contratos; cenas reutilizáveis; testes de contato/estado; integração com SaveSystem/CampaignProgress.  
**Aceite:** sem eventos duplicados, perda indevida de progresso ou softlocks; estado persistente e transitório separados.

# FASE IV — INIMIGOS E CONFRONTOS

### 15 — Arquitetura técnica dos inimigos
**Objetivo:** estabelecer base modular para entidades com papéis distintos.  
**Escopo:** composição; percepção; estados; navegação local; lifecycle; dados; limites de arena; telegraphs e contratos de encontro.  
**Entregáveis:** arquitetura de referência; componentes; documentação de estados; harnesses de teste.  
**Aceite:** ownership claro; comportamento testável; sem acoplamento indevido à fase; arquétipos distintos por função.

### 16 — Concept art, sprites e animações dos inimigos, com aprovação
**Objetivo:** definir e produzir a linguagem visual dos arquétipos.  
**Escopo:** silhuetas; escala; identidade por mundo; poses; ciclos; estados visuais; leitura em tela pequena.  
**Entregáveis:** concepts; folhas; spritesheets; mapas de frames; manifesto e proveniência.  
**Aceite:** aprovação do usuário antes da integração de cada conjunto visual; assets em revisão/rejeitados nunca entram em cenas de produção.

### 17 — Inteligência artificial e comportamentos
**Objetivo:** implementar comportamentos que diferenciem papéis e criem desafios legíveis.  
**Escopo:** máquinas de estado; percepção; patrulha; navegação; recuperação; interação com arena e telegraphs conforme design aprovado.  
**Entregáveis:** comportamentos por arquétipo; tuning; testes de estado/limite; diagnóstico de encontros.  
**Aceite:** comportamento legível, consistente e sem softlocks; dificuldade validada por playtest; custo dentro dos budgets medidos.

### 18 — Desenvolvimento visual e técnico dos sete chefes, com aprovação
**Objetivo:** estabelecer identidade e especificação de cada guardião.  
**Escopo:** canon; silhueta; escala; fases; linguagem visual; telegraphs; estados; animações; relação com arena, fragmento e narrativa.  
**Entregáveis:** sete dossiers; concepts; folhas de animação; especificações de estado; QA por encontro.  
**Aceite:** concepts apresentados e aprovados antes de integrar sprites; lore segue fontes aprovadas e lacunas continuam propostas.

### 19 — Arenas e confrontos dos chefes
**Objetivo:** implementar e validar encontros culminantes.  
**Escopo:** geometria; limites; checkpoints; fases de encontro; telegraphs; vitória/derrota; recompensa; transição e persistência.  
**Entregáveis:** arenas jogáveis; encontros integrados; testes; playtests e relatórios de justiça/acessibilidade.  
**Aceite:** encontro concluível e reiniciável; sem softlock; sinais legíveis; recompensa e progressão corretas.

# FASE V — MUNDOS E CONSTRUÇÃO DA CAMPANHA

### 20 — Arquitetura dos sete mundos e das 42 fases
**Objetivo:** consolidar matriz de campanha e navegação.  
**Escopo:** IDs W#-L#; ordem; dependências; função de cada fase; objetivos; transições; fragmentos; checkpoints; conclusão e rastreabilidade.  
**Entregáveis:** Atlas reconciliado; matriz de dependências; fichas; mapa de progressão; contratos de roteamento.  
**Aceite:** 42 entradas rastreáveis; seis posições por mundo conforme blueprint; fase planejada não aparece como implementada sem evidência.

### 21 — Direção visual e concept art dos sete mundos, com aprovação
**Objetivo:** definir identidade artística de cada mundo mantendo coerência global.  
**Escopo:** paletas; arquitetura; atmosfera; materiais; iluminação; fundos; formas; composição; contraste e assinatura visual.  
**Entregáveis:** sete world-art bibles; concepts; moodboards; paletas; layouts; decisões de aprovação.  
**Aceite:** propostas distinguíveis e coerentes com canon; usuário aprova a direção antes de produzir/integrar assets finais.

### 22 — Produção dos tilesets, cenários e elementos ambientais
**Objetivo:** produzir kits visuais a partir das direções aprovadas.  
**Escopo:** tilesets; fundos; parallax; plataformas; módulos; decoração; hazards visuais; sinalização; colisões visuais e budgets.  
**Entregáveis:** kits por mundo; manifests; atlas/import presets; catálogo de variantes.  
**Aceite:** cada entrega artística aprovada antes da integração; escala, encaixe, leitura, proveniência e performance verificados.

### 23 — Construção das fases e integração dos ambientes
**Objetivo:** transformar fichas e blockouts em fases jogáveis e autorais.  
**Escopo:** layout; ritmo; rotas; checkpoints; encontros; assets aprovados; iluminação; parallax; objetivos; segredos e composição.  
**Entregáveis:** cenas; fichas atualizadas; ambientes integrados; relatórios de rota principal/opcional e QA por fase.  
**Aceite:** fase concluível, sem softlock, com função própria e assets aprovados; cena existente não basta para declarar fase final.

### 24 — Obstáculos, exploração, segredos e elementos interativos
**Objetivo:** enriquecer os mundos com desafios sistêmicos e exploração significativa.  
**Escopo:** hazards; plataformas especiais; puzzles; rotas alternativas; segredos; objetos; eventos ambientais; recompensas e acessibilidade.  
**Entregáveis:** catálogo; implementação por fase; testes espaciais/físicos; regras e pistas documentadas.  
**Aceite:** elementos compreensíveis e justos; segredos não bloqueiam rota principal; persistência correta; performance medida em cenas densas.

# FASE VI — NARRATIVA E EXPERIÊNCIA DO JOGADOR

### 25 — Narrativa, diálogos, cutscenes e progressão
**Objetivo:** integrar arco narrativo à campanha jogável.  
**Escopo:** cenas; diálogos; NPCs; flags; objetivos; eventos; fragmentos; cutscenes puláveis; consequências e encerramento.  
**Entregáveis:** roteiro rastreável; IDs; grafo de flags; integração de eventos e cenas.  
**Aceite:** continuidade canônica; cenas puláveis sem perda de estado obrigatório; diálogos funcionais; progressão compreensível; final coerente com fontes aprovadas.

### 26 — Interface completa, menus, HUD e experiência do usuário
**Objetivo:** completar interação e apresentação do produto.  
**Escopo:** boot; menu; novo jogo/continuar; seleção de mundos/fases; HUD; pausa; configurações; resultados; acessibilidade; touch e safe areas.  
**Entregáveis:** fluxos; biblioteca de componentes; layouts responsivos; estados de erro/vazio; navegação e testes de usabilidade.  
**Aceite:** ações visíveis funcionam; navegação previsível; targets touch confortáveis; legibilidade/acessibilidade verificadas; assets finais aprovados antes da integração.

### 27 — Áudio, trilhas sonoras e efeitos audiovisuais
**Objetivo:** estabelecer experiência sonora coerente, integrada e controlável.  
**Escopo:** música por mundo; ambiência; efeitos; mix; buses; ducking; mute/volume; foco; interrupção/retomada Android; sincronização audiovisual.  
**Entregáveis:** mapa sonoro; assets originais/licenciados; manifesto; mix; testes de lifecycle.  
**Aceite:** licença/proveniência registrada; mix legível; controles funcionais; sem reprodução indevida após suspensão; aprovação de conteúdo final antes da integração.

# FASE VII — ANDROID E QUALIDADE TÉCNICA

### 28 — Integração Android, touchscreen, safe areas e ciclo de vida
**Objetivo:** validar a aplicação no ambiente real de distribuição.  
**Escopo:** export preset; package ID; orientação; barras de status/navegação; modo imersivo conforme decisão; recortes; safe areas; multitouch; permissões; foco; suspensão/retomada; instalação/atualização.  
**Entregáveis:** checklist; matriz de aparelhos; builds identificadas; relatórios físicos; identidade de pacote aprovada.  
**Aceite:** instalação e fluxos essenciais validados em aparelhos identificados; barras/safe areas respeitam decisão do usuário; touch e lifecycle confiáveis.

### 29 — Otimização de CPU, GPU, memória e estabilidade
**Objetivo:** atingir performance sustentável sem degradar experiência.  
**Escopo:** profiling; frame time; p95/p99; alocações; memória; draw calls; overdraw; texturas; áudio; loading; ownership; temperatura e regressões.  
**Entregáveis:** baselines; budgets medidos; relatórios; otimizações justificadas; mitigação por classe de aparelho.  
**Aceite:** hipótese e comparação antes/depois para cada otimização; física/input/arte preservados; 60 FPS declarado apenas para aparelho/cena/duração medidos. O trabalho da antiga Etapa 05 (recursos, loading, PerformanceProbe) migra para esta etapa.

### 30 — Testes de qualidade, regressão e validação das 42 fases
**Objetivo:** verificar integridade funcional e qualidade da campanha.  
**Escopo:** unit/integration; fluxo de campanha; fases; chefes; save/load; touch; acessibilidade; interrupções; sessões longas; regressão visual e compatibilidade.  
**Entregáveis:** matriz 42/42; relatórios por mundo/fase; backlog de bugs; evidências L0–L5; risco residual.  
**Aceite:** fases implementadas concluíveis; blockers/criticals corrigidos; pendências classificadas; teste físico sempre associado a aparelho identificado.

# FASE VIII — FINALIZAÇÃO E LANÇAMENTO

### 31 — Polimento artístico, audiovisual e de gameplay
**Objetivo:** eliminar inconsistências e elevar qualidade sem alterar silenciosamente decisões aprovadas.  
**Escopo:** animação; timing; feedback; transições; efeitos; áudio; legibilidade; acessibilidade; ritmo; UX e tuning autorizado.  
**Entregáveis:** backlog de polimento; revisão de consistência; builds comparáveis; changelog; registro de assets aprovados.  
**Aceite:** sem regressões; canon/física/controles preservados; assets aprovados e licenciados; problemas conhecidos registrados.

### 32 — Consolidação da campanha, auditoria final e Release Candidate
**Objetivo:** produzir candidato a lançamento reproduzível e auditável.  
**Escopo:** auditoria; integridade de conteúdo; campanha; saves; package ID; assinatura; exportação; checklist; licenças; documentação; riscos e rollback.  
**Entregáveis:** RC identificada por commit/build; artefato verificável; relatório QA; inventário de assets/licenças; documentação; riscos residuais.  
**Aceite:** gates aplicáveis atendidos; build reproduzível/assinável; nenhum blocker/critical conhecido; evidências completas; autorização explícita antes de publicação oficial. RC não significa release publicado.

---

## 3. Pipeline obrigatório de arte e assets

**ChatGPT cria os assets visuais do jogo e apresenta cada entrega ao usuário. A integração no repositório/Godot só pode ocorrer depois da aprovação explícita do usuário.** A regra vale para BOLT, NPCs, inimigos, chefes, tilesets, cenários, objetos, VFX, UI, ícones e demais elementos visuais.

Estados: `PLANNED → SPECIFIED → CONCEPT_CREATED → AWAITING_USER_APPROVAL → APPROVED → INTEGRATED → VERIFIED`. Também são permitidos `REVISION_REQUESTED`, `REJECTED` e `PLACEHOLDER`.

Cada brief registra ID, função, consumidor, direção visual, dimensões, proporção, alpha, frames, ordem, FPS, pivô, margens, escala, paleta, legibilidade, formato, destino, proveniência e limitações. Campos não aplicáveis são omitidos.

Aprovação vale somente para a versão e finalidade apresentadas. Silêncio, aprovação de outro asset, geração concluída ou presença de arquivo não equivalem a aprovação. Após feedback, revisar e reapresentar. Não substituir asset aprovado sem nova aprovação.

Após integração, validar import settings na versão Godot fixada, transparência, pivô, frames, escala, legibilidade, cenas consumidoras e custo Android quando pertinente. Atualizar manifesto, fila, tracker e commit. Placeholder nunca é arte final.

---

## 4. Migração do plano histórico de 26 etapas

A matriz `26-stage-traceability-matrix.md` permanece preservada como histórico e crosswalk; deixa de ser o plano operacional primário após a integração deste documento. Não apagar IDs, evidências ou status antigos.

| Etapa histórica | Nova etapa | Tratamento |
|---:|---|---|
| 01 Auditoria | 01 | Correspondência direta; preservar evidências e limites |
| 02 Requisitos | 02 | Correspondência direta; preservar lacunas/decisões |
| 03 Arquitetura | 03 | Correspondência direta; preservar ADRs/mapa |
| 04 Infraestrutura | 04 | Correspondência direta; preservar aceite L2 |
| 05 Recursos/loading | 29 | Migrar SceneFlow, lifecycle, loading e PerformanceProbe; não confundir com nova Etapa 05 artística |
| 06 Personagem | 07–08 e 10 | Separar concept/arte do runtime |
| 07 Física/movimento | 11 | Correspondência predominante |
| 08 Animações/feedback | 08, 12, 16 | Separar produção de asset e integração |
| 09 Câmera/espaço | 13 | Correspondência predominante |
| 10 Interações/sobrevivência | 14, 24 | Separar sistemas centrais de conteúdo por fase |
| 11 Arquitetura de combate | 15 e contratos de gameplay | Reconciliar sem duplicar sistemas |
| 12 Arsenal | contratos de gameplay existentes | Rastrear apenas requisitos autorizados; não criar etapa duplicada |
| 13 Arquitetura inimigos | 15 | Correspondência predominante |
| 14 IA | 17 | Correspondência predominante |
| 15 Chefes | 18–19 | Separar conceito aprovado e encontro jogável |
| 16 Arquitetura mundos/fases | 20 | Correspondência direta |
| 17 Construção mundos | 21–23 | Separar direção visual, kits e integração |
| 18 Construção fases | 20, 23 | Separar planejamento e execução |
| 19 Obstáculos/exploração | 24 | Correspondência predominante |
| 20 Narrativa/progressão | 25 | Persistência técnica continua na Etapa 04 |
| 21 Interface/UX | 09, 26 | Separar kit visual e implementação funcional |
| 22 Arte/VFX | 05–09, 16, 18, 21–22, 31 | Distribuir por tipo; aprovação obrigatória |
| 23 Áudio/apresentação | 27, 31 | Separar produção de polimento |
| 24 Android/touch | 11, 28 | Separar controles de integração Android |
| 25 Otimização/QA | 29–30 | Separar profiling e validação da campanha |
| 26 Polimento/finalização | 31–32 | Separar polimento e RC |

### Preservação de estado no checkpoint de migração

- Antigas Etapas 01–04: registradas como concluídas no nível automatizado/documental indicado pelos snapshots; manter evidências e limites.
- Antiga Etapa 05: continua EM ANDAMENTO e migra principalmente para nova Etapa 29.
- Novas Etapas 05–09 não herdam conclusão da antiga Etapa 05.
- Novas Etapas 10–32 recebem estado próprio conforme inventário e evidência; mapeamento não implica conclusão.
- Gate 1 permanece em andamento; W1-L1/W1-L2 continuam blockouts; validação Android física permanece pendente.
- Não alterar IDs persistentes, schema de save, InputMap, física, Dash, canon ou decisões de display por causa da migração.

---

## 5. Relação com Gates 0–5

Gates são marcos transversais de qualidade; etapas são unidades de execução. Não renumerar nem substituir os Gates.

| Gate | Foco | Etapas relacionadas |
|---|---|---|
| 0 | Auditoria e alinhamento | 01–03 |
| 1 | Fundação e vertical slice | 04, 10–14, 28 |
| 2 | Sistemas centrais | 04, 10–19, 25–27 |
| 3 | Produção dos mundos | 20–24 |
| 4 | Narrativa e polimento | 25–27, 31 |
| 5 | QA Android e RC | 28–32 |

Aprovar uma etapa não aprova automaticamente um Gate.

---

## 6. Governança de agentes

**ChatGPT:** arquitetura, sistemas centrais, integração, desempenho Android, regressão, QA e criação dos assets visuais. Apresenta cada asset ao usuário e aguarda aprovação antes de integrar.

**Claude:** autorizado pelo usuário para construção de fases, inimigos/chefes, elementos interativos, UI/conteúdo visual e sistemas independentes de gameplay. Não pode contornar o checkpoint de aprovação, integrar assets não aprovados ou substituir assets aprovados.

**Coordenação:** um escritor por arquivo/unidade; branches e PRs independentes; declarar escopo/arquivos/contratos; revisar diff e CI antes de merge; não presumir entrega sem commit/PR observável. ChatGPT integra/revisa mudanças que afetem contratos centrais. O usuário mantém autoridade sobre canon, decisões materiais e aprovação visual.

---

## 7. Definition of Done e evidências

Uma etapa só pode ser VALIDADA quando:
1. objetivo/escopo atendidos;
2. entregáveis ligados aos requisitos;
3. contratos e decisões preservados;
4. diff revisado;
5. testes aplicáveis executados e aprovados;
6. testes não executados e limitações declarados;
7. assets aprovados e com proveniência, quando aplicável;
8. tracker/continuidade/documentação atualizados;
9. branch, commit, PR e CI identificados;
10. nível L0–L5 explícito;
11. blockers/criticals tratados;
12. aprovações exigidas obtidas.

L0 inspeção; L1 estático; L2 Godot/headless/CI; L3 editor/emulador; L4 Android físico identificado; L5 sessão prolongada. Nenhum nível substitui automaticamente o seguinte.

---

## 8. Protocolo de manutenção

Em cada entrega substancial:
- atualizar `stage-status.md`;
- atualizar `implementation-tracker.md` para sistemas/fases;
- atualizar `CONTINUITY.md` com HEAD/branch/PR/evidências/próximo passo;
- atualizar `COLLABORATION_STATE.md` quando ownership mudar;
- atualizar manifesto e fila de assets;
- manter a matriz 26 etapas como histórico/crosswalk;
- confirmar HEAD real após merge; nunca usar SHA presumido.

### Próximas ações após adoção
1. Manter Etapas 01–04 concluídas conforme evidências existentes.
2. Continuar nova Etapa 29 (migração da antiga Etapa 05), preparando captura Android e medições reais, sem tuning especulativo.
3. Iniciar nova Etapa 05 com direção de arte baseada nas bíblias; não integrar arte não aprovada.
4. Preparar Etapa 06 e fila/manifesto de assets.
5. Manter W1-L1/W1-L2 como blockouts até construção, arte, áudio, playtest e QA.
6. Não declarar Gate 1 concluído enquanto validação Android física e demais critérios estiverem pendentes.
