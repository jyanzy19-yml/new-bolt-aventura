# Sondas de runtime (W1-L1)

Scripts que exercitam o **runtime HTML5 real** contra os dados de `content/levels/`. Dependem de módulos das PRs abertas #149–#161 (`src/physics`, `src/gameplay/player-motor.js`, `src/levels/*`) e do tuning de **debug** (`DEBUG_PLAYER_TUNING`), não aprovado. Enquanto essas PRs não forem integradas na `main`, estes scripts **não rodam** aqui.

| Script | O que faz |
|---|---|
| `check-contract.js` | `validateLevelDefinition` + `LevelRuntime.load` + construção do `CollisionWorld`, com controle negativo. |
| `measure.js` | Mede o envelope de movimento (altura/alcance de saltos, Dash) com `PlayerMotor`. |
| `legbot.js` | Para cada perna da rota (e saída de valas) procura uma entrada que a conclua com 100% / 90% / 110% de velocidade e pulo; exige que pernas de pulo duplo não tenham solução com pulo simples. |

Última execução: head `3ef8215` da PR #161, Node 22. Resultado: todas as 30 pernas viáveis a 100% e 90%; a 110% quatro pernas (`rn-22-pad-4`, `ro-cw-2` e as duas de pulo duplo) passam a admitir pulo simples em poucas entradas — risco de sensibilidade registrado na matriz de QA. Isto é uma sonda por bot, **não** playtest humano nem teste em dispositivo.
