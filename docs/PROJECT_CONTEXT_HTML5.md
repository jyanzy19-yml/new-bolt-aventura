# BOLT · AVENTURA — Contexto Consolidado para Implementação HTML5

> **Bíblia consolidada vigente (28/11/2026):** consulte também [BOLT_MASTER_BIBLE_HTML5_V2.md](game-design/BOLT_MASTER_BIBLE_HTML5_V2.md). Ela reúne os requisitos de produto, canon, campanha, mecânicas e engenharia sob a decisão HTML5. Este contexto continua complementar e não comprova implementação ou validação.


**Finalidade:** adaptar o dossiê mestre de contexto fornecido pelo usuário à decisão tecnológica mais recente. Este documento é contexto de produto e engenharia, não substitui `MASTER_DIRECTIVE.md`, bíblias aprovadas, ADRs ou código real.

## 1. Regime de autoridade e evidência

A decisão explícita mais recente do usuário prevalece sobre este documento e sobre qualquer referência histórica incompatível. O dossiê recebido em 26/11/2026 descrevia Godot 4.7.2/GDScript; essa tecnologia foi superada pela decisão posterior: criar o jogo do zero em HTML5. Não tratar esta iniciativa como port ou migração.

Classifique informações como CANON APROVADO, REQUISITO, IMPLEMENTADO, TESTADO, VALIDADO, PROPOSTA, PROVISÓRIO, A DEFINIR, PENDENTE ou DESCARTADO. A existência de arquivo não comprova integração ou funcionamento.

## 2. Identidade do produto

BOLT · AVENTURA é um jogo original 2D de plataforma, ação e aventura, com foco em aplicativo Android em orientação paisagem. A experiência combina exploração lateral, movimentação de precisão, combate, progressão por mundos, narrativa de ficção científica, personagens robóticos, hazards ambientais, chefes e campanha longa.

Pilares: controle responsivo; legibilidade; progressão significativa; identidade própria por mundo; integração narrativa; qualidade mobile; confiabilidade de save/loading; produção rastreável.

## 3. Canon preservado

- BOLT é o protagonista robótico.
- NEXO é a máquina temporal que se une a BOLT.
- O Grande Colapso é um evento central.
- O Núcleo da Eternidade integra a mitologia temporal/cósmica.
- O Arquiteto integra o núcleo da mitologia e antagonismo.
- A campanha contempla sete mundos e sete fragmentos ligados ao equilíbrio dos universos.
- Escala planejada: 42 fases, seis por mundo.
- O plano macro descrito no dossiê prevê cinco fases de progressão/exploração e uma sexta fase culminante de guardião/fragmento/transição por mundo; validar o blueprint narrativo antes de fixar conteúdo específico.
- Preservar início, desenvolvimento, clímax e conclusão.

Não inventar nomes próprios de guardiões, revelações, motivações, relações ou diálogos definitivos onde a fonte aprovada mantém lacunas. Propostas devem permanecer identificadas como propostas.

## 4. Campanha e level design

Cada mundo deve ter identidade visual/sonora, arquitetura ambiental, paleta, vocabulário de plataformas, hazards, curva de dificuldade, inimigos, NPCs, segredos e encontro culminante próprios. A meta documentada é de pelo menos cinco arquétipos de inimigos significativamente distintos por mundo; recoloração não satisfaz a meta.

Cada fase precisa de ID estável, objetivo, posição na campanha, resumo narrativo, fluxo espacial, mecânica ensinada/praticada/testada, inimigos/hazards, checkpoint, segredos/recompensas, curva de dificuldade, dependências, critérios de conclusão e QA. Aplicar ensinar → praticar → combinar → dominar. Projetar para touch sem exigir precisão injusta.

Blockout valida geometria e fluxo; não equivale a fase final. Sandbox de desenvolvimento não é fase de campanha.

## 5. Gameplay

Preservar Dash como mecânica aprovada. Não remover ou redesenhar silenciosamente. Definir movimento, salto, controle aéreo, colisões, combate, arsenal, dano, knockback, invulnerabilidade e estados de forma explícita, consultando a fonte de game design correspondente.

Toda habilidade precisa de regras de ativação, duração, interrupção, cancelamento, recarga, prioridade e término. Inimigos precisam de arquétipo, leitura, telegraph, contra-jogo e função distintos. Chefes precisam de padrões legíveis, fases coerentes e janelas de resposta justas.

## 6. Plataforma e UX mobile

Android é a plataforma de produto. Touch é prioridade, com multitouch real. Jump e Dash precisam registrar de forma confiável mesmo durante quedas de FPS. Eventos de toque devem ser limpos em pause, troca de cena, perda de foco, suspensão e retomada. Input edge events não podem depender exclusivamente do frame de renderização.

Requisitos adicionais: orientação paisagem; safe areas; tratamento consistente entre modo normal e fullscreen/display mode; cobertura de status/navigation bars conforme o shell Android permitir; HUD legível; alvos touch confortáveis; lifecycle confiável; áudio que suspenda/retome corretamente.

## 7. Stack e arquitetura atual

- HTML5 e CSS3.
- JavaScript ES Modules.
- Canvas 2D.
- Vite.
- Web Audio API.
- Pointer Events.
- Capacitor como candidato para empacotamento Android, condicionado a prova de compatibilidade e necessidade.

Arquitetura modular por responsabilidades: bootstrap/lifecycle, core/clock, runtime/loop, gameplay/entities/physics/combat, input, rendering/camera, levels/content data, UI, audio/assets, persistence, platform adapters e tests/tooling. Evitar monólitos, fragmentação excessiva, dependências circulares e estado global mutável.

Separar simulação e renderização. Preferir timestep fixo para simulação quando apropriado. Usar relógio monotônico, clamp de delta e política explícita de pausa/retomada. Renderização não deve alterar estado autoritativo de gameplay.

## 8. Loading, assets e áudio

Loading deve representar trabalho real, sem atraso artificial. Pré-carregar recursos críticos, decodificar assets antes do gameplay quando necessário, tratar erros/retry/cancelamento e liberar memória por mundo. Manifesto de assets deve conter IDs estáveis, caminhos, dimensões/duração, formato, origem/licença, uso, política de preload e estimativa de memória.

Web Audio precisa lidar com unlock por gesto do usuário, buses master/music/SFX, limites de vozes, mute, pausa e lifecycle.

## 9. Save e progressão

Separar estado transitório, estado de checkpoint e estado persistente de campanha. Usar IDs estáveis e schema versionado. Validar dados, tratar corrupção e migração, evitar duplicação de recompensas e preservar consistência entre flags narrativas, fases, fragmentos e inventário. Testar cold start, encerramento inesperado, retomada, corrupção e atualização de schema.

## 10. Performance

Hardware de referência: Android com aproximadamente 4 GB RAM e MediaTek Helio G99 ou inferior. Meta próxima de 60 FPS quando sustentável, sem promessa universal. Medir frame time p50/p95/p99, long tasks, input latency, memória, decode, GC e thermal behavior com aparelho, OS, WebView, resolução, DPR, build e duração identificados.

Controlar custo do backing store/DPR, overdraw, partículas, superfícies transparentes, filtros, alocações, parsing, layout e decodificação. Otimizar com medições e não sacrificar resposta dos controles, física, identidade visual ou conteúdo sem aprovação.

## 11. QA e estados de conclusão

Camadas: unit tests, integration tests, browser tests, production build checks e validação manual em Android físico. Cobrir timestep, colisões, Dash, multitouch, pointercancel, input sob baixo FPS, lifecycle, loading failure, áudio, save migration, checkpoints, softlocks e transições repetidas.

- PLANNED: planejado.
- IMPLEMENTED: código implementado e inspecionado.
- TESTED: testes nomeados executados com resultado.
- VERIFIED: evidência representativa no runtime/plataforma-alvo.

CI verde não prova experiência visual/touch em dispositivo físico. APK gerado não prova instalação ou release.

## 12. Colaboração de agentes

ChatGPT e Claude Code são agentes autorizados. Cada tarefa deve ter escritor primário e revisor, branch isolada, paths permitidos/proibidos, base commit, critérios de aceite e testes. Não editar simultaneamente os mesmos arquivos. O usuário controla sequência e merge. Handoff deve registrar commits, PR, testes, validação, riscos e próximo responsável.

## 13. Fonte e limitações

Este documento deriva do dossiê mestre enviado pelo usuário em 26/11/2026, reinterpretado sob a decisão HTML5 posterior e as instruções atuais do repositório. Ele não comprova o estado atual da implementação, não enumera todos os arquivos do GitHub e não substitui a inspeção do branch e dos arquivos reais.
