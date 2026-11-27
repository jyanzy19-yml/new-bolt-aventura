# Etapa 23 — integração do blockout provisório Cybercore W1-L3

**Data:** 27/11/2026  
**Branch:** `integration/campaign-w1-l3-provisional-blockout-2026-11-27`  
**Origem:** consolidação da PR #84  
**Estado de conteúdo:** BLOCKOUT PROVISÓRIO / PROPOSTA DE PRODUÇÃO

## 1. Objetivo

Adicionar a terceira fase provisória do mundo Cybercore e conectar o fluxo de campanha W1-L2 → W1-L3, preservando o blueprint de 42 fases e sem declarar W1-L3 como conteúdo final ou canon narrativo.

## 2. Composição de blockout

- Piso inicial para entrada e observação.
- Elevador industrial vertical lento.
- Piso intermediário para combate/reposicionamento.
- Plataforma superior estática de leitura espacial.
- Plataforma móvel horizontal de transferência.
- Piso final com recuperação, checkpoint e objetivo.
- Dois encontros com o inimigo-base provisório.
- KillZone e saída de conclusão.

As dimensões, coordenadas, durações e distâncias estão documentadas em `docs/game-design/W1-L3-fabrica-de-ecos.md` e são parâmetros de blockout sujeitos a playtest, não balanceamento final.

## 3. Integração de campanha

- W1-L2 conclui via `CampaignProgress.mark_level_completed("W1-L2", "W1-L3")`.
- O HUD de W1-L2 oferece `PRÓXIMA FASE` apontando para a PackedScene W1-L3.
- O menu resolve W1-L3 por ID estável e permite retomada.
- W1-L3 registra a entrada com `CampaignProgress.begin_level("W1-L3")`.
- Checkpoint usa ID persistente `cybercore_w1_l3_checkpoint`.
- A conclusão de W1-L3 não aponta para W1-L4, que permanece não implementada.

## 4. Testes

Novo teste `tests/unit/test_w1_l3_blockout.gd` cobre:
1. composição da cena, pisos, plataformas, inimigos, checkpoint e objetivo;
2. parâmetros de movimento das duas plataformas;
3. limites de patrulha dentro dos pisos;
4. contato físico, persistência e restauração do checkpoint após reentrada;
5. conclusão de W1-L2, atualização do destino W1-L3, resolução efetiva por Continuar e habilitação do botão no menu;
6. fallback local do checkpoint quando o save está corrompido, incluindo retorno pela KillZone;
7. conclusão física de W1-L3, registro único da fase concluída e ausência de destino W1-L4 não implementado.

O teste existente `test_w1_l2_progression.gd` foi atualizado para exigir o próximo destino W1-L3, preservando os cenários de checkpoint/falha de save já integrados.

## 5. Preservação e limites

- W1-L3 permanece BLOCKOUT PROVISÓRIO, derivado da proposta W1-L3 do blueprint.
- Nenhum novo detalhe narrativo é canonizado.
- Nenhuma arte final, spritesheet, animação, VFX, áudio ou asset final é criado.
- Não altera schema de save, IDs anteriores, Dash, InputMap, física do Player ou tuning já estabelecido.
- Não anuncia W1-L4 nem inventa fluxo de campanha além do conteúdo implementado.
- Usa sistemas já existentes: Player, HUD, inimigo-base, MovingPlatform, checkpoint, KillZone e objetivo.

## 6. Critérios de aceite

- Godot 4.7.2: importação, parsing e suíte headless passam.
- Documentation Validation: SUCCESS.
- Godot Validation `46075124332`: SUCCESS; Documentation Validation `46075124349`: SUCCESS; Android Debug Export `46075124490`: SUCCESS.
- Suíte Godot e Android: **130 testes / 2.142 verificações / 0 falhas**; 20/20 boots smoke e mutation check do prewarm aprovados.
- APK Debug Godot 4.7.2: 28.478.036 bytes; package ID placeholder `com.example.boltaventura`; SHA-256 `4fa4a81ca7e5f0b048f05f9a14bc41bec9a0c4c4f0344c1445538a01ca4dc892`; assinatura v2/v3 verificada.
- Artifact `15234169146`; ZIP SHA-256 `41ee39850c322e6be341053b666b887edcb9cade9c3c81c1a30cff354142f84a`; [artefato Android Debug](https://github.com/jyanzy19-yml/new-bolt-aventura/actions/runs/46075124490/artifacts/15234169146).
- W1-L2 conclui e aponta para W1-L3; menu retoma W1-L3.
- Checkpoint W1-L3 persiste e restaura após reentrada.
- Nenhum teste afirma que W1-L3 é fase final ou que W1-L4 existe.

## 7. Limitações

Headless/CI não substitui playtest humano/Android físico. Legibilidade touch, tempos de embarque, câmera, clipping, FPS, memória e sensação das plataformas móveis continuam pendentes. Etapa 23 permanece EM ANDAMENTO.


---

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
