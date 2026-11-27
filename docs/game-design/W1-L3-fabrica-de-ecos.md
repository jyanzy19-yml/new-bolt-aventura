# W1-L3 — Fábrica de Ecos

**ID persistente:** `W1-L3`  
**Mundo:** W1 — Cybercore  
**Estado:** BLOCKOUT PROVISÓRIO · ALINHAMENTO COM O ATLAS OFICIAL  
**Etapa:** 23 — Construção das fases e integração dos ambientes

## 1. Fonte de design

Esta ficha segue a entrada W1-L3 do Atlas Mestre de 42 fases:

- **Função:** combinar plataforma e combate em cenário industrial.
- **Estrutura:** híbrida, com esteiras, elevadores e poços de manutenção.
- **Percurso:** docas → linha de montagem → núcleo de esteiras → torre de controle.
- **Mecânica prevista:** Tríplice para cobertura ampla e Laser para alvos resistentes/precisos.
- **Desafios:** esteiras com direção variável, prensas claramente sinalizadas e plataformas móveis.
- **Inimigos previstos:** Operário Corrompido, Drone Vigia e Sentinela.
- **Narrativa:** registros mostram que a fábrica produzia componentes ligados ao Núcleo da Eternidade.
- **Segredo:** rota por dutos que evita uma arena secundária e oferece item de lore.
- **Conclusão:** desativar a linha de montagem sem destruir os registros.

A ficha anterior “Setor de Montagem” não refletia integralmente esta fonte e foi substituída. O nome canônico da fase é **Fábrica de Ecos**.

## 2. Estado implementado neste blockout

| Requisito do Atlas | Estado no repositório |
|---|---|
| Percurso híbrido | IMPLEMENTADO em geometria provisória |
| Elevador vertical | IMPLEMENTADO via `MovingPlatform` |
| Plataforma móvel horizontal | IMPLEMENTADO via `MovingPlatform` |
| Esteiras em direções variáveis | IMPLEMENTADO via `ConveyorBelt`, uma para cada direção |
| Prensas sinalizadas | IMPLEMENTADO via `IndustrialPress`, com aviso, golpe e recuperação |
| Combate industrial | PARCIAL; usa `CybercorePatrolEnemy` como inimigo-base, não como arquétipo canônico |
| Tríplice e Laser | PENDENTE; os sistemas/armas não estão completos na build atual |
| Operário Corrompido, Drone Vigia e Sentinela | PENDENTE; não afirmar que o inimigo-base representa esses arquétipos |
| Registros sobre o Núcleo | PENDENTE como evento narrativo interativo; a sinalização atual é apenas placeholder |
| Rota por dutos e item de lore | PARCIAL/PENDENTE; plataforma superior é apenas geometria provisória, sem pickup narrativo |
| Desativação da linha sem destruir registros | PENDENTE; o contato com a saída ainda é um placeholder de conclusão |

## 3. Composição provisória atual

Coordenadas em unidades do mundo Godot; origens de `PlatformBlock` e `ConveyorBelt` no canto superior esquerdo.

- Piso inicial e área de observação.
- `LiftA`: elevador vertical de offset `(0, -48)`.
- Piso intermediário para combate e reposicionamento.
- `ConveyorBeltA`: superfície com velocidade positiva, indicando deslocamento à direita.
- `IndustrialPressA`: aviso visual antes da janela de golpe.
- Plataforma superior de serviço, ainda sem função secreta aprovada.
- `TransferPlatform`: plataforma móvel horizontal de transferência.
- `ConveyorBeltB`: superfície com velocidade negativa, indicando deslocamento à esquerda.
- `IndustrialPressB`: segunda aplicação do mesmo vocabulário de perigo.
- Piso final, checkpoint persistente, torre de controle placeholder e saída.

Velocidades, posições, durações e dimensões são valores de blockout, não tuning final.

## 4. Contratos dos componentes

### ConveyorBelt

- Deriva de `PlatformBlock` e preserva a camada de colisão do mundo.
- Expõe `surface_speed` e `get_surface_velocity()`.
- Usa `PhysicsBody2D.constant_linear_velocity` para transferir movimento horizontal ao corpo apoiado.
- A direção é legível por chevrons desenhados na superfície.
- Não altera o controlador de BOLT nem o InputMap.

### IndustrialPress

- Ciclo determinístico: `WARNING → ACTIVE → RECOVERY → WARNING`.
- A zona de golpe permanece desativada durante aviso e recuperação.
- O golpe só causa dano durante `ACTIVE`.
- O Timer respeita a pausa da SceneTree.
- Dano, duração e deslocamento permanecem parametrizados para playtest.

## 5. Persistência e progressão

- ID persistente: `W1-L3` (inalterado).
- Checkpoint: `cybercore_w1_l3_checkpoint` (inalterado).
- Entrada e conclusão continuam usando `CampaignProgress` schema v1.
- W1-L2 encaminha para W1-L3.
- Menu e catálogo exibem o nome canônico Fábrica de Ecos.
- W1-L4 continua indisponível até sua cena canônica Laboratório de Memórias existir.
- Nenhum campo novo é adicionado ao save.

## 6. Critérios de blockout e regressão

- A cena importa e instancia em Godot 4.7.2.
- Esteiras direita/esquerda expõem velocidades opostas e transferem movimento ao jogador apoiado.
- Prensas exibem aviso antes de ativar a zona de golpe.
- A zona de golpe só fica ativa no estado `ACTIVE`.
- O ciclo da prensa entra em recuperação e desativa o dano.
- Elevador e plataforma de transferência preservam seus contratos existentes.
- Checkpoint, reentrada, conclusão e retomada W1-L2 → W1-L3 continuam funcionando.
- Nenhum teste declara armas, arquétipos, segredo ou narrativa como concluídos quando ainda estão pendentes.

## 7. Limites de validação

CI/headless valida parsing, contratos e regressões. Não comprova sensação das esteiras, justiça temporal das prensas, legibilidade em tela touch, duração de fase, equilíbrio de combate, clipping, FPS, memória ou temperatura em Android físico. A fase permanece BLOCKOUT PROVISÓRIO.
