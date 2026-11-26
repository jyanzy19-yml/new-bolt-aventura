# BOLT · AVENTURA — Visão geral e pilares de design

## 1. Identidade do produto
- Nome: BOLT · AVENTURA.
- Gênero: aventura, plataforma e ação 2D.
- Engine: Godot 4.7.2, GDScript, conforme projeto atual.
- Plataforma-alvo: aplicativo Android empacotado.
- Orientação: paisagem.
- Hardware de referência: Android com aproximadamente 4 GB de RAM e MediaTek Helio G99 ou inferior.
- Estado: projeto executável Godot existente, com menu, abertura, tutorial, sistemas iniciais de combate e W1-L1 em blockout. Consultar `docs/production/stage-status.md` e `docs/production/CONTINUITY.md` para estado real atualizado.

## 2. Premissa central consolidada
Um robô desperta em um mundo destruído e encontra uma máquina temporal que se une a ele. A máquina, chamada NEXO, permite viajar entre eras e mundos. A missão é recuperar um fragmento em cada um dos sete mundos; cada fragmento é protegido pelo guardião ao final do mundo e está ligado ao mistério da máquina temporal e ao equilíbrio dos universos. O Grande Colapso rompeu o Núcleo da Eternidade. O antagonista central, o Arquiteto, busca impor uma única realidade. BOLT foi criado para preservar os universos.

## 3. Pilares
1. Aventura com progressão clara.
2. Movimento expressivo e responsivo.
3. Mundos distintos em identidade visual, sonora e mecânica.
4. Narrativa integrada a gameplay e consequências.
5. Desafio justo e legível.
6. Personagens com personalidade transmitida por ação.
7. Qualidade mobile e confiabilidade touch.
8. Arquitetura sustentável e testável.
9. Acessibilidade e estabilidade.
10. Produção baseada em evidências.

## 4. Escopo
- Sete mundos, seis fases por mundo, 42 fases planejadas.
- Cinco fases de exploração/progressão e uma sexta de guardião/fragmento/transição.
- Meta de ao menos cinco arquétipos de inimigo distintos por mundo.
- NPCs com função narrativa ou de gameplay.
- Tutorial integrado.
- Menus, HUD, pausa, configurações e progressão.
- Checkpoints, segredos, recompensas e save confiável.
- Cutscenes com skip e função narrativa.
- Acessibilidade básica e controles touch robustos.

## 5. Limites e proteção
- Não criar navegador como plataforma-alvo.
- Não migrar de engine sem aprovação explícita.
- Não remover Dash; consultar ADR-001-DASH.
- Não tratar sandbox como fase de campanha.
- Não criar fases ainda inexistentes como se fossem implementadas.
- Não canonizar números provisórios.
- Não otimizar por intuição sem medição.
- Não afirmar validação Android sem execução física.

## 6. Métricas
| Área | Evidência |
|---|---|
| Controle | ações registradas, multitouch, buffer e latência |
| Movimento | física previsível e estados consistentes |
| Leitura | perigos, plataformas, pickups e objetivos distinguíveis |
| Progressão | mecânicas ensinadas antes de combinações |
| Narrativa | causalidade e coerência com bíblias |
| Android | exportação e testes em dispositivo |
| Performance | frame time p50/p95/p99, memória e temperatura |
| Robustez | save/load, pausa, foco e transições |
| Acessibilidade | contraste, legibilidade e redução de efeitos |

## 7. Classificação do conteúdo
Separar canon consolidado, expansão autoral proposta, requisito, decisão técnica, hipótese e conteúdo a definir. O usuário autorizou expansão criativa ampla; propostas podem orientar protótipos reversíveis, mas devem ser registradas sem confundir proposta com implementação ou canon aprovado.

## 8. Documentos de autoridade
- `docs/prompts/master-game-design-and-gameplay-prompt.md`: mandato operacional.
- `docs/game-design/01-narrative-bible.md`: canon narrativo consolidado.
- `docs/game-design/02-world-bible.md`: sete mundos, fragmentos e guardiões.
- `docs/game-design/03-character-bible.md`: personagens.
- `docs/game-design/04-gameplay-systems.md`: sistemas de gameplay.
- `docs/game-design/EXPANDED-NARRATIVE-DOSSIER.md`: aprofundamento narrativo proposto.
- `docs/game-design/EXPANDED-GAMEPLAY-SYSTEMS.md`: especificação expandida de sistemas.
- `docs/game-design/EXPANDED-42-LEVEL-CAMPAIGN-BLUEPRINT.md`: proposta de macrodesign das 42 fases, com percurso, mecânica, narrativa, opcionais e gates de cada fase.
- `docs/production/stage-status.md` e `CONTINUITY.md`: estado executável e continuidade.
