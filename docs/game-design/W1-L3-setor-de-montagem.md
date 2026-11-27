# W1-L3 — Setor de Montagem
## Ficha técnica de blockout e implementação provisória

**ID:** W1-L3  
**Mundo:** W1 — Cybercore  
**Estado:** PROPOSTA DE PRODUÇÃO / BLOCKOUT PROVISÓRIO  
**Etapa principal:** 23 — Construção das fases e integração dos ambientes  
**Etapas relacionadas:** 13 — Sistemas espaciais; 14 — Interações e checkpoints; 15/17 — Inimigos e comportamento  
**Fontes:** `EXPANDED-42-LEVEL-CAMPAIGN-BLUEPRINT.md`, entrada W1-L3; `05-level-design-standard.md`; contratos técnicos de plataformas móveis, checkpoint, campanha e inimigos.

> Esta ficha transforma a proposta existente do blueprint em uma especificação de blockout testável. Não aprova nomes, lore, diálogos, arte final, balanceamento ou layout definitivo. Todos os parâmetros espaciais e de tuning abaixo são provisórios e devem permanecer substituíveis após playtest.

---

## 1. Intenção de design rastreada

A entrada W1-L3 do blueprint define:
- **Função:** combinar combate básico com plataforma em espaço de leitura ampla.
- **Percurso:** salas conectadas por elevadores industriais e plataformas móveis lentas.
- **Mecânica:** inimigos patrulheiros e mecanismos que exigem posicionamento, sem introduzir múltiplos sistemas simultaneamente.
- **Narrativa:** sinais de que as unidades robóticas tinham funções diferentes e de uma comunidade perdida.
- **Opcional:** compartimento lateral com uma mensagem visual, sem longa exposição.
- **Gate:** densidade de inimigos compatível com touch; projéteis não podem ocultar plataformas; plataformas móveis devem ser previsíveis.

A implementação atual usa apenas sistemas já existentes: BOLT, HUD, inimigo-base provisório, MovingPlatform, checkpoint, kill zone e objetivo de saída. Nenhum novo sistema de gameplay ou detalhe narrativo é canonizado por esta ficha.

## 2. Objetivos de gameplay

1. Reforçar o domínio de salto, Dash e combate básico sem tutorialização intrusiva.
2. Fazer o jogador observar o movimento de uma plataforma antes de embarcar.
3. Usar um elevador vertical e uma travessia móvel horizontal como duas aplicações do mesmo vocabulário espacial.
4. Distribuir encontros de patrulha em segmentos distintos, evitando sobrecarga simultânea de touch.
5. Colocar checkpoint em piso estável após a principal travessia móvel.
6. Manter a rota principal legível e concluível sem depender de conteúdo opcional.

## 3. Macro-layout provisório

Coordenadas em pixels do mundo; plataformas usam origem no canto superior esquerdo.

| Elemento | Posição / dimensão | Função |
|---|---|---|
| Piso inicial | (-32, 0), 560×128 | Zona segura de entrada e observação |
| Elevador A | (520, -72), 170×24 | Movimento vertical; offset (0, -48), duração 2,4 s, pausa 0,45 s |
| Piso intermediário | (760, 0), 600×128 | Área ampla de combate e reposicionamento |
| Plataforma superior | (1000, -112), 160×24 | Superfície estática de leitura/variação vertical; uso final a validar |
| Transferência B | (1300, -72), 160×24 | Travessia horizontal; offset (160, 0), duração 3,0 s, pausa 0,45 s |
| Piso final | (1580, 0), 640×128 | Recuperação, checkpoint e saída |
| Checkpoint | (1650, -32) | Recuperação após a travessia principal |
| Objetivo | (2140, -32) | Conclusão do blockout |

A rota é formada por três segmentos: entrada e embarque no elevador; combate e preparação no piso intermediário; travessia horizontal e conclusão no piso final. As duas plataformas móveis devem manter áreas de embarque/desembarque com sobreposição geométrica suficiente para reduzir saltos de precisão incompatíveis com touch.

## 4. Encontros provisórios

| Instância | Segmento | Configuração provisória | Intenção |
|---|---|---|---|
| Patrulheiro A | Piso intermediário | Origem x=950, y=-19; distância 60 px | Primeiro encontro em espaço amplo |
| Patrulheiro B | Piso final | Origem x=1850, y=-19; distância 70 px | Reforço do combate após a travessia |

Ambos usam `CybercorePatrolEnemy`, ainda classificado como inimigo-base provisório. Não representam dois arquétipos distintos. Os encontros não devem ser tratados como prova de que a meta de cinco arquétipos por mundo foi atendida.

## 5. Fluxo de campanha

- ID persistente da fase: `W1-L3`.
- Entrada: registrar `W1-L3` via `CampaignProgress.begin_level()`.
- Checkpoint: ID estável `cybercore_w1_l3_checkpoint`.
- Queda: retornar ao spawn ou ao checkpoint restaurado.
- Conclusão: registrar `W1-L3` como concluída sem apontar para W1-L4, pois W1-L4 ainda não está implementada.
- Retomada: o menu pode resolver `W1-L3` somente depois que a PackedScene existir.

A transição W1-L2 → W1-L3 deve usar o contrato já existente de `mark_level_completed(level_id, next_level_id)`; não alterar schema de save nem inventar novos campos.

## 6. Critérios de blockout

- A cena carrega e instancia na versão Godot fixada.
- BOLT inicia em piso estável, sem interseção com inimigo ou colisão.
- As duas plataformas móveis percorrem os offsets declarados e respeitam pausa da SceneTree.
- O caminho principal é concluível com os controles e habilidades já existentes.
- A rota não depende de saltos de precisão extrema ou de um timing de janela excessivamente curto.
- Inimigos ficam dentro do piso destinado e não ocupam a zona de spawn/checkpoint.
- Checkpoint ativa e restaura após reentrada/respawn.
- Kill zone não captura a rota principal nem cria loop de morte.
- Objetivo conclui W1-L3 uma única vez.
- W1-L2 encaminha para W1-L3; o menu reconhece W1-L3 para continuar.
- A mensagem visual opcional permanece não implementada até existir um contrato de interação e conteúdo aprovado.

## 7. Limites e pendências

- Sem arte final, spritesheets, animações, VFX ou áudio final.
- Geometria, duração de plataformas, posições de inimigos e checkpoint são tuning de blockout, não balanceamento final.
- A plataforma superior e o compartimento opcional precisam de playtest antes de ganhar função definitiva.
- Não há playtest humano ou Android físico associado a esta ficha.
- W1-L3 não deve ser marcada como fase final; trata-se de uma primeira implementação jogável provisória.
