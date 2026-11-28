# W1-L1 — Pendências, decisões abertas e dependências de integração

**Task:** BOLT-001 (pacote de produção de conteúdo). Base: `origin/main` @ `27c3407`. Registrado em 28/11/2026.

## 0. Conflito de propriedade a resolver primeiro (BLOQUEANTE para integração)
Ao fechar este pacote, a PR **#162** (`agent/chatgpt/w1-l1-production-playable`, escritor ChatGPT, base #161) declara **a mesma task BOLT-001** e implementa um blockout jogável de W1-L1 com geometria própria (mundo 3600×700, spawn (72,504), `src/levels/w1-l1.js`). A PR #165 repete essa base e adiciona W1-L2. Os dois trabalhos **divergem**:

| Aspecto | Este pacote (`content/levels/w1-l1.*`) | PR #162 |
|---|---|---|
| Escala | 7040×960, rota principal ≈ 6,9 mil px | 3600×700 |
| Dash | aprovado, **opcional**, nunca obrigatório | dica de Dash no pátio |
| Interação | requisito; failsafe por tempo (runtime sem ação) | E/Enter e botão AÇÃO |
| Validação | validador estático + bot por perna no `PlayerMotor` real | testes `w1-l1-production.test.js` (não executados aqui) |
| Status | `SPECIFIED_NOT_INTEGRATED` | "IMPLEMENTADO como blockout" |

Nenhum arquivo deste pacote colide por caminho com #162/#165, mas **não são compatíveis em design**. Esta PR não toca em `src/`. Decisão necessária do usuário/dono: (a) usar este pacote como alvo de produção e portar o blockout; (b) retroalimentar este pacote com a geometria de #162; ou (c) descartar um deles. Até lá nada aqui deve ser integrado ao runtime. A PR **#164** (Bíblia mestre HTML5 v2) **não foi lida** nesta task; reconciliar canon/armas com ela antes de aprovar falas e D-01.

## 1. Decisões de design abertas
| ID | Questão | Estado atual no pacote |
|---|---|---|
| D-01 | Armas em W1-L1: o blueprint ensina arma na W1-L2; a diretiva V5.2 anexada pelo usuário diz que as três armas existem desde o início | Só objetivo opcional (`obj-opt-defeat-unit`, `requiresAbility: shoot`); inimigo com vida provisória |
| D-02 | Quando o vínculo BOLT–NEXO é declarado | Fala de NEXO mínima ("Conexão estabelecida."), rascunho |
| D-03 | Aprovação formal do pulo duplo (existe `jumpCount=2` só no tuning de debug) | Duas pernas obrigatórias dependem dele |
| D-04 | Uso de Dash na W1-L1 | Apenas alternativa opcional na passarela; nada obrigatório |
| D-05 | Dano de queda | Assumido inexistente |
| D-06 | Contrato de dano/vida/cura (efeito da zona letal, dano de contato, kit de reparo) | Valores `RELATIVE_UNIT`, `PROVISORIO` |
| D-07 | Relação entre cinemática de abertura/tutorial e o despertar da câmara | Pacote inicia em `evt-level-enter` |
| D-08 | Portões como colliders dinâmicos | Requer add/remove no `CollisionWorld` |
| D-09 | Ação de interação | Ausente no runtime #161; #162 propõe E/Enter + AÇÃO. Failsafe mantido nos dois interáveis que abrem portão |
| D-10 | Convenção de posição do corpo ao respawn (pés em x,y do checkpoint) | Pés em (x,y) |
| D-11 | Esquema de save (flags, checkpoint, coletáveis, segredos) | Campos listados em `persistence` |
| D-12 | Nome/entrada do arquétipo da unidade de manutenção no World Bible | Nome proposto |
| D-13 | Escala de arte final por px lógico | Não definida |
| D-14 | Extensão versionada do schema (inimigos, eventos, assets, diálogos) | `content.json` é proposta `0.1.0-proposal` |
| D-15 | Câmera: sem olhar para baixo; quedas > 180 px não são legíveis | Quedas > 180 px evitadas na rota principal; 1 aviso aceito |

## 2. Dependências técnicas de integração (HTML5)
1. PRs #145–#161 (e/ou #162) integradas na `main`; hoje não existem módulos de runtime na `main`.
2. Loader de conteúdo que lê `content.json` conforme schema v2 (D-14) e valida com `validate-level-package.js` no CI.
3. `CollisionWorld` com colliders adicionáveis/removíveis (gates).
4. Sistema de eventos/objetivos/diálogo, interação, dano/vida (D-06), checkpoints/respawn e save (D-11).
5. Manifesto de assets (#160) consumindo os IDs `SPECIFIED`.
6. Câmera: suporte a descidas verticais (D-15).
7. Troca do fixture `w1-l1-debug.js` pelos dados reais, sem remover o fixture de testes.
8. Reexecutar `scripts/levels/runtime-probes/` quando o tuning mudar ou for aprovado.

## 3. Limitações conhecidas
- Envelope medido com tuning de debug não aprovado; sensibilidade +10% registrada na matriz de QA (QA-W1L1-012).
- Nenhum teste humano, em navegador real ou em Android. Vitest real, ESLint, Prettier e CI não foram executados (sem rede para instalar dependências).
- Arte e áudio inexistentes (34 itens `SPECIFIED`).
- O ZIP "bolt-aventura-v5.2-atualizado" anexado pelo usuário é um código-base legado diferente da base limpa do repositório (contém `src/levels/data/world1.js` etc.). Não foi analisado a fundo nem usado como fonte; qualquer reaproveitamento exige decisão e verificação de proveniência.
