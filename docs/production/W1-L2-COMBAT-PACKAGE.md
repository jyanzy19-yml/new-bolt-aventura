# W1-L2 — Ruas sem Sinal: pacote de gameplay em desenvolvimento

**ID:** `w1-l2`  
**Mundo:** Cybercore  
**Fonte de design:** `docs/game-design/EXPANDED-42-LEVEL-CAMPAIGN-BLUEPRINT.md`  
**Estado:** pacote de dados e orquestração implementados; integração completa de cena e validação manual ainda pendentes.  
**Arte:** blockout vetorial placeholder. **Balanceamento:** provisório.

## Intenção de design

W1-L2 apresenta exploração urbana ramificada e combate básico. O percurso é avenida destruída → estação de energia → telhados baixos → praça de comunicação. O jogador aprende Pistola, troca entre Pistola/Tríplice/Laser e lê projéteis inimigos. O trio de arquétipos previsto é Sentinela de Patrulha, Drone Vigia e unidade de manutenção. O registro de evacuação é opcional. Religando o repetidor, abre-se a passagem para a zona industrial/W1-L3.

## Implementação incluída neste pacote

- Dados declarativos com geometria, plataformas, checkpoints, saída, interações, inimigos, landmarks e objetivos.
- Validação de IDs, bounds, objetivos, tipos de interação, arquétipos e parâmetros de patrulha/combate.
- `W1L2GameRuntime`: patrulha, disparos inimigos, dano de contato, projéteis do jogador, troca de armas, saúde, objetivo e interação final.
- Testes unitários para contrato de conteúdo e orquestração.

## Limites desta entrega

O pacote ainda não está ligado ao bootstrap `src/main.js`, aos controles touch, HUD/renderer, pause/loading ou transição desde W1-L1. O teste de integração de cena, playtest browser, WebView e Android físico continuam pendentes. O sistema de combate mantém parâmetros provisórios e não representa balanceamento final.

## Critério para a próxima integração

Montar uma cena W1-L2 usando os contratos existentes de FixedStepLoop, PlayerMotor, PlayerSceneRuntime, InputManager, TouchControls, Camera2D e CanvasSurface; renderizar os inimigos/projéteis/beam/vida; permitir concluir W1-L1 → W1-L2; validar troca e disparo nos três armamentos, leitura de projéteis inimigos, morte/respawn, interação do repetidor e saída para W1-L3.
