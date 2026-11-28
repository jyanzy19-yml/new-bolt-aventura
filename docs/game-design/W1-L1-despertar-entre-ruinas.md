# W1-L1 — Despertar entre Ruínas · Documento de produção

**Task:** BOLT-001 · **Escritor:** Claude Code · **Revisor:** a designar · **Estado:** `SPECIFIED_NOT_INTEGRATED` (evidência: PLANNED + dados validados estaticamente; **não implementada no runtime, não aprovada**).
**Dados:** `content/levels/w1-l1.level.json` (schema v1) · `content/levels/w1-l1.content.json` (proposta `0.1.0-proposal`).
**Complementos:** [espacial e encontros](W1-L1-spatial-and-encounters.md) · [inventário de assets e áudio](../assets/W1-L1-ASSET-AUDIO-INVENTORY.md) · [matriz de QA](../qa/W1-L1-QA-MATRIX.md) · [pendências](../production/W1-L1-PENDING-AND-DEPENDENCIES.md).

> **Aviso de propriedade:** a PR #162 (ChatGPT) declara a mesma task BOLT-001 com um blockout de design diferente (3600×700). Este pacote não é compatível com ele sem decisão do dono; ver seção 0 de [pendências](../production/W1-L1-PENDING-AND-DEPENDENCIES.md).

> Marcações: **CANON** = vem do blueprint/Bíblia; **REQ** = requisito do blueprint da fase; **PROPOSTA** = decisão desta task, sujeita à aprovação; **PROVISÓRIO** = valor sem aprovação (tuning de debug).

## 1. Identidade e função
- Mundo 1 — Cybercore, fase 1 de 6 (passo "Introdução" da estrutura). Fragmento do mundo: Origem (CANON).
- Função: estabelecer a identidade do jogo, apresentar BOLT e NEXO e ensinar movimento, salto e pulo duplo em ordem, sem ameaça obrigatória.
- Tom: isolamento tecnológico, ruína industrial, sinal fragmentado que guia para leste.
- Duração-alvo (PROPOSTA, não medida): 4–6 min na primeira jogada; mundo de 7040×960 px, rota principal ≈ 6,9 mil px (spawn x=96 até saída x=6960).

## 2. Narrativa (sem inventar cânone)
BOLT desperta em uma câmara de manutenção após o Grande Colapso. Um sinal fragmentado guia até um abrigo onde o primeiro ponto de sincronização é ativado e NEXO responde com uma frase curta. Todas as falas estão em `content.json` como `RASCUNHO`; falantes são rótulos de interface ("SINAL", "NEXO", "DIAGNÓSTICO").
- Aberto (D-02): em que momento o vínculo BOLT–NEXO é declarado; a fala de NEXO é só "Conexão estabelecida." até decisão.
- Aberto (D-07): relação entre a cinemática/tutorial de abertura do jogo e o despertar da câmara.
- Segredo opcional: três linhas de diagnóstico que sugerem origem não catalogada de BOLT. É **insinuação aberta**, sem afirmar fatos de cânone; exige revisão de continuidade.

## 3. Objetivos
| ID | Tipo | Texto (rascunho) | Completa por |
|---|---|---|---|
| obj-leave-chamber | principal | Saia da câmara. | evt-console-used |
| obj-reach-shelter | principal | Alcance o abrigo de manutenção. | evt-shelter-entered |
| obj-activate-sync | principal | Ative o ponto de sincronização. | evt-sync-activated |
| obj-opt-find-diagnostic | opcional | Encontre o compartimento de diagnóstico. | evt-secret-found |
| obj-opt-defeat-unit | opcional | Neutralize a unidade defeituosa. | evt-unit-defeated (exige arma, D-01) |

Conclusão: `evt-level-complete` após `evt-sync-activated`, próxima fase `w1-l2`.

## 4. Curva de dificuldade (6 passos)
Métrica: razão da perna = max(vão ÷ alcance medido com redução por subida, desnível ÷ altura de salto). 1,0 = limite físico. Limites por seção são orçamentos desta proposta.
| # | Seção | x (px) | Fase do ritmo | Ensina | Limite | Máx. na rota principal |
|---|---|---|---|---|---|---|
| 1 | sec-01-chamber | 0–1024 | apresentação segura | andar, acelerar, interagir | 0 | 0,00 |
| 2 | sec-02-corridor | 1024–2176 | desafios simples | salto, salto sustentado, vãos com recuperação | 0,60 | 0,56 |
| 3 | sec-03-climb | 2176–3392 | combinação | saltos encadeados, primeiro pulo duplo | 0,75 | 0,68 |
| 4 | sec-04-courtyard | 3392–5312 | aplicação | leitura de vãos, encontro opcional, rota alternativa | 0,65 | 0,49 |
| 5 | sec-05-residue-chain | 5312–6336 | maior domínio (letal) | sequência de saltos sobre energia residual | 0,78 | 0,71 |
| 6 | sec-06-shelter | 6336–7040 | encerramento | descanso, sincronização | 0,50 | 0,25 |
Valores "Máx." gerados por `validate-level-package.js`. A seção 5 só é letal ao final, após `cp-03`, com quatro almofadas de pouso sinalizadas por luz.

## 5. Mecânicas
| Mecânica | Status | Uso na fase |
|---|---|---|
| Mover/acelerar | REQ | Seção 1 |
| Pulo e pulo sustentado | REQ | Seções 2–5 |
| Pulo duplo | REQ; aprovação formal pendente (D-03) | Obrigatório em 2 pernas (`rn-13`, `rn-22`) e nos opcionais |
| Interagir | REQ; sem ação no runtime #161; #162 propõe E/Enter (D-09) | 3 interáveis, todos com failsafe por tempo nos que abrem portão |
| Dash | **Aprovado (ADR-001)** | Não é obrigatório. Rota opcional `route-catwalk-bypass` aceita Dash como alternativa (PROPOSTA D-04). Nenhuma alteração de Dash. |
| Tiro/arma | A definir (D-01) | Só objetivo opcional; blueprint ensina arma na W1-L2. A diretiva V5.2 anexada diz que as 3 armas existem desde o início: conflito a decidir pelo dono. |
Nenhuma mecânica nova de cânone foi criada. Não há voo, parry, wall jump ou stomp.

## 6. Inimigos e perigos (resumo)
Um inimigo: `en-maint-unit-01`, unidade de manutenção defeituosa, **opcional**, dormente, com telegraph de 1,2 s e janela de núcleo exposto; cinco perigos: 4 valas de recuperação (sem dano) e 1 zona letal de energia residual. Detalhes em [espacial e encontros](W1-L1-spatial-and-encounters.md). Dano, vida e cura **não têm contrato** (D-06): valores são `RELATIVE_UNIT`.

## 7. Direção audiovisual
Estados: **FINAL** = nenhum; **PLACEHOLDER** = geometria desenhada pelo debug do runtime (retângulos); **NECESSÁRIO** = os 34 assets de `content.json`, todos `SPECIFIED`, aprovação `NONE`.
- Paleta (PROPOSTA): metal frio escuro com realces ciano; âmbar para avisos; vermelho-laranja somente para perigo letal. Perigo nunca depende só de cor (luz de borda `vfx-w1-pit-edge-light`).
- Camadas: horizonte distante, ruínas intermediárias, estruturas próximas fora do plano jogável; interiores próprios para câmara e abrigo.
- Áudio: três faixas (despertar, exploração, abrigo), ambiência do corredor, 2 sfx e 2 stingers. Tudo a criar com origem e licença rastreadas; nenhuma síntese provisória é final.
- Leitura: plataformas e perigos têm contraste acima do cenário; plano jogável sem elementos do fundo próximo.

## 8. Critérios de aceitação (resumo)
Lista completa na matriz de QA. Mínimo: pacote validado; carrega sem erro no runtime; todas as pernas jogáveis em dispositivo-alvo com toque; checkpoints e respawn corretos; nenhum softlock; sem perda de comando de salto durante queda de quadros.

## 9. Estado de evidência
| Item | Nível |
|---|---|
| Geometria v1 aceita pelo validador oficial (PR #161 @ `3ef8215`) | TESTED (por script, fora do CI) |
| Pernas de rota por bot no `PlayerMotor` real com tuning de debug | TESTED (bot, não humano) |
| Validador estático + 15 testes | TESTED sob shim mínimo; Vitest real **não** executado |
| Jogabilidade, leitura visual, dificuldade, FPS, Android | **Não validado** |
