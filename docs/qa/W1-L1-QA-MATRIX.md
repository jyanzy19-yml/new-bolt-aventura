# W1-L1 — Matriz de QA

**Task:** BOLT-001 · Prefixo de casos: `QA-W1L1-`. Severidade: **S1** bloqueia progresso/perde dados · **S2** quebra uma regra de design ou controle · **S3** leitura/polimento.
**Estado:** coluna *Resultado* só registra o que foi **executado**. "Não executado" significa sem evidência. Nenhum caso foi testado por humano ou em Android.

## A. Dados e contrato
| Caso | Verificação | Esperado | Sev. | Resultado |
|---|---|---|---|---|
| QA-W1L1-001 | `validateLevelDefinition` sobre `w1-l1.level.json` (PR #161 @ `3ef8215`) | aceito; 23 sólidos, 14 unidirecionais, 3 checkpoints, 1 saída | S1 | **Passou** (`runtime-probes/check-contract.js`; controle negativo rejeitou ID inválido) |
| QA-W1L1-002 | `LevelRuntime.load` e `CollisionWorld` a partir do arquivo | carrega; 37 colliders | S1 | **Passou** (mesmo script) |
| QA-W1L1-003 | Validador estático do pacote | 0 erros; 1 aviso conhecido (`FALL_NEAR_DORMANT_ENEMY`) | S1 | **Passou** (`node scripts/levels/validate-level-package.js`) |
| QA-W1L1-004 | Testes `tests/content/w1-l1-level-package.test.js` (4 de dados + 11 de mutação) | 15/15 | S2 | **Passou sob shim mínimo de Vitest**; Vitest real **não executado** (sem rede para instalar); CI **não executou** |
| QA-W1L1-005 | Assets `SPECIFIED`, aprovação `NONE` | nenhum asset declarado existente | S2 | **Passou** (teste 003 do arquivo acima) |
| QA-W1L1-006 | Schema de conteúdo v2 aceita enemies/events/assets | carregamento do `content.json` pelo runtime | S1 | **Não executado** (extensão inexistente, D-14) |

## B. Alcançabilidade e rota
| Caso | Verificação | Esperado | Sev. | Resultado |
|---|---|---|---|---|
| QA-W1L1-010 | Bot por perna: 26 pernas de rota + 4 saídas de vala no `PlayerMotor` real | cada perna tem entrada que conclui a 100% e 90% | S1 | **Passou** (`legbot.js`, 30/30) |
| QA-W1L1-011 | Pernas de pulo duplo sem solução com pulo simples a 100% | `rn-13`, `rn-22`, `ro-cw-2`, `ro-sec-ledge` | S2 | **Passou** a 100% e 90% |
| QA-W1L1-012 | Sensibilidade +10% de tuning | pulo duplo continua necessário | S2 | **Falhou parcialmente (informativo)**: a 110%, `rn-22-pad-4` (8 entradas) e `ro-cw-2` (16) admitem pulo simples. Risco registrado; reavaliar quando o tuning for aprovado |
| QA-W1L1-013 | Rota principal sem Dash/tiro | nenhum nó exige | S1 | **Passou** (validador estático) |
| QA-W1L1-014 | Teto da seção 6 inalcançável (rise 288 px vs pulo duplo 258 px) | `s6-roof` não alcançável | S3 | Passou no cálculo; margem ≈ 11% e some se o pulo duplo crescer ≥ 11,5% (registrado) |
| QA-W1L1-015 | Percurso completo por humano, spawn → saída | concluível sem ajuda | S1 | **Não executado** |

## C. Fluxo, eventos e softlock
| Caso | Verificação | Esperado | Sev. | Resultado |
|---|---|---|---|---|
| QA-W1L1-020 | Console de despertar sem interação 90 s | failsafe abre a porta | S1 | Dados presentes; **não executado** (runtime sem interação, D-09) |
| QA-W1L1-021 | Terminal de sincronização sem interação 90 s | failsafe ativa | S1 | idem |
| QA-W1L1-022 | Gate colide até abrir; abre uma vez e persiste | sem atravessar, sem recolidir | S1 | **Não executado** (D-08) |
| QA-W1L1-023 | Ordem de eventos e ausência de eventos órfãos/ciclos | grafo válido | S2 | **Passou** (validador estático) |
| QA-W1L1-024 | Morte em vala/pool/inimigo → respawn no último checkpoint | posição, vida, flags corretos | S1 | **Não executado** (D-06, D-10) |
| QA-W1L1-025 | Sair e reabrir no meio da fase | checkpoint/flags restaurados | S1 | **Não executado** (D-11) |
| QA-W1L1-026 | Conclusão → `w1-l2` e salvamento | progresso gravado | S1 | **Não executado** |

## D. Controles, desempenho e dispositivo
| Caso | Verificação | Esperado | Sev. | Resultado |
|---|---|---|---|---|
| QA-W1L1-030 | Toque multitoque: andar + pular + pulo duplo | sem perda de comando | S1 | **Não executado** |
| QA-W1L1-031 | Pulo/Dash registrados durante queda de FPS | comando não some | S1 | **Não executado** |
| QA-W1L1-032 | Distribuição de tempo de quadro (hardware de referência) | a medir; sem meta declarada | S2 | **Não executado** |
| QA-W1L1-033 | Câmera: aterrissagens visíveis e quedas ≤ 180 px abaixo | leitura da seção 5 | S2 | **Não executado**; câmera de zona morta atual não olha para baixo (D-15) |
| QA-W1L1-034 | Safe areas e orientação paisagem | HUD/dicas fora do entalhe | S2 | **Não executado** |
| QA-W1L1-035 | Memória/carregamento da fase | a medir | S2 | **Não executado** |

## E. Combate e perigos
| Caso | Verificação | Esperado | Sev. | Resultado |
|---|---|---|---|---|
| QA-W1L1-040 | Telegraph ≥ 1,0 s antes de a unidade agir | 1,2 s | S2 | Dados validados; **não executado** em jogo |
| QA-W1L1-041 | Unidade evitável pela passarela e por salto | sim | S2 | Passarela: bot (pernas `ro-cw-*`); salto sobre a unidade: **não executado** |
| QA-W1L1-042 | Queda da passarela perto da unidade dormente | sem dano imediato; aviso do telegraph | S2 | **Não executado** (aviso estático registrado) |
| QA-W1L1-043 | Zona letal só após `cp-03`, com pouso legível | respawn ≤ 400 px antes | S1 | Distâncias validadas estaticamente; **não executado** |
| QA-W1L1-044 | Comportamento sem arma disponível (D-01) | objetivo opcional oculto/inativo | S2 | **Não executado** |

## F. Conteúdo e continuidade
| Caso | Verificação | Esperado | Sev. | Resultado |
|---|---|---|---|---|
| QA-W1L1-050 | Revisão de continuidade narrativa | sem cânone inventado; falas aprovadas | S2 | **Não executado** (todas `RASCUNHO`) |
| QA-W1L1-051 | Aprovação de pulo duplo, vínculo BOLT–NEXO, armas | decisões D-01..D-04 | S1 | **Pendente de decisão** |
| QA-W1L1-052 | Rastreabilidade IDs de doc ↔ JSON | todos os IDs citados existem | S3 | Varredura ad hoc dos IDs entre crases nos 4 docs W1-L1: 0 ausentes (script não versionado) |

Rodar: `node scripts/levels/validate-level-package.js`; probes de runtime em `scripts/levels/runtime-probes/` (dependem das PRs #149–#161).
