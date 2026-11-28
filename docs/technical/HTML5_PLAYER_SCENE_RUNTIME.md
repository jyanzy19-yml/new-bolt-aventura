# PlayerSceneRuntime — composição da cena do jogador

**Status:** camada de composição para ligar InputManager, PlayerMotor, Camera2D e renderer.  
**Loop:** implementa a interface `update(deltaSeconds)` e `render(alpha)` esperada pelo FixedStepLoop, sem possuir o scheduler.

## Responsabilidades

- Consumir exatamente um frame normalizado de input por tick de simulação.
- Atualizar PlayerMotor com delta fixo.
- Atualizar Camera2D a partir do AABB e velocidade horizontal do jogador.
- Interpolar apenas a apresentação entre snapshots anterior/atual durante render.
- Encaminhar level, player interpolado e camera interpolada ao renderer.
- Resetar jogador e câmera juntos para evitar interpolação através de respawn.

## Limites

A classe recebe dependências já construídas e uma fase já carregada/validada. Não cria InputManager, PlayerMotor, Camera2D, renderer, level, CollisionWorld ou FixedStepLoop. Não controla pause, loading, save, HUD, áudio, inimigos ou lifecycle da aplicação. O chamador é responsável por pausar o loop antes de resetar ou trocar de fase.
