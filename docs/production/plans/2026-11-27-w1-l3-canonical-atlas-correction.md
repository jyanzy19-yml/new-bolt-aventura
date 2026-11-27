# Correção de alinhamento canônico — W1-L3 Fábrica de Ecos

**Data:** 27/11/2026  
**Branch:** `fix/cybercore-w1-l3-atlas-alignment-2026-11-27`  
**Base:** `4b9c5824c3ab294a72f8a0b09ad662ceae5d3f76`  
**Estado:** EM VALIDAÇÃO

## 1. Motivo

A auditoria do Atlas Mestre revelou que o nome e a composição anterior de W1-L3 estavam incompletos em relação ao blueprint oficial. A fase é **Fábrica de Ecos**, não “Setor de Montagem”, e requer esteiras de direção variável, prensas sinalizadas e combinação de plataformas móveis.

## 2. Alterações

- Corrige o título em `CampaignCatalog`, `MainMenu`, cena e resultado da fase.
- Alinha também os títulos catalogados de W1-L1, W1-L2 e W1-L4 aos nomes oficiais.
- Adiciona `ConveyorBelt`, baseado em `PlatformBlock`, com velocidade de superfície e direção visual.
- Adiciona `IndustrialPress`, com ciclo de aviso, golpe e recuperação.
- Integra duas esteiras em sentidos opostos e duas prensas à composição W1-L3.
- Adiciona testes de transporte da esteira, aviso/dano/recuperação da prensa e composição da fase.
- Substitui a ficha de design antiga por uma matriz explícita de requisitos e lacunas.

## 3. Preservação

- IDs `W1-L1` a `W1-L3` e checkpoint persistente preservados.
- CampaignProgress schema v1 preservado.
- Sem alteração de movimento, física base, Dash, InputMap, multitouch ou tuning de BOLT.
- `CybercorePatrolEnemy` continua identificado como inimigo-base provisório; não é renomeado silenciosamente para Operário/Drone/Sentinela.
- Tríplice, Laser, arquétipos específicos, item de lore, interação com painel e conclusão narrativa permanecem pendentes.
- W1-L4 oficial é Laboratório de Memórias; W1-L5 oficial é Torre do Núcleo. PRs antigas de “Núcleo de Distribuição” e “Perímetro do Guardião” foram fechadas sem merge por divergência do Atlas.

## 4. Critérios de aceite

1. Godot Validation passa.
2. Documentation Validation passa.
3. Android Debug Export passa e repete a suíte headless.
4. Teste de esteira comprova transporte de BOLT sem input horizontal.
5. Teste da prensa comprova aviso anterior ao dano e recuperação.
6. Testes anteriores de checkpoint, retomada e progressão continuam passando.
7. Nenhum resultado é tratado como validação física Android.
