# W1-L2 — Ruas sem Sinal: pacote de gameplay em desenvolvimento

**ID:** `w1-l2`  
**Mundo:** Cybercore  
**Fonte de design:** `docs/game-design/EXPANDED-42-LEVEL-CAMPAIGN-BLUEPRINT.md`  
**Estado:** cena conectada ao fluxo W1-L1 → W1-L2; integração automatizada implementada; playtest manual e validação Android ainda pendentes.  
**Arte:** blockout vetorial placeholder. **Balanceamento:** provisório.

## Intenção de design

W1-L2 apresenta exploração urbana ramificada e combate básico. O percurso é avenida destruída → estação de energia → telhados baixos → praça de comunicação. O jogador aprende Pistola, troca entre Pistola/Tríplice/Laser e lê projéteis inimigos. O trio de arquétipos previsto é Sentinela de Patrulha, Drone Vigia e unidade de manutenção. O registro de evacuação é opcional. Religando o repetidor, abre-se a passagem para a zona industrial/W1-L3.

## Implementação incluída neste pacote

- Dados declarativos com geometria, plataformas, checkpoints, saída, interações, inimigos, landmarks e objetivos.
- Validação de IDs, bounds, objetivos, tipos de interação, arquétipos e parâmetros de patrulha/combate.
- `W1L2GameRuntime`: patrulha, disparos inimigos, dano de contato, projéteis do jogador, troca de armas, saúde, checkpoints, respawn, objetivo e interação final.
- `W1L2CanvasRenderer`: blockout com três silhuetas de inimigos, projéteis, laser, vida e HUD.
- Fluxo navegável W1-L1 concluída → W1-L2, com botões touch para tiro e troca de arma.
- Testes unitários para conteúdo, combate, dano inimigo, checkpoint e respawn.

## Limites desta entrega

O pacote está conectado ao bootstrap e ao fluxo de conclusão de W1-L1. O estado persistente de campanha/save, loading assíncrono de assets, áudio e transição W1-L2 → W1-L3 ainda não foram implementados. O playtest browser, WebView e Android físico continuam pendentes. O sistema de combate mantém parâmetros provisórios e não representa balanceamento final.

## Critério para a próxima integração

Executar playtest no browser e corrigir o que for observado; validar troca e disparo nos três armamentos, leitura de projéteis inimigos, morte/respawn por checkpoint, interação do repetidor e rota de conclusão. Em seguida, preparar transição real para W1-L3.
