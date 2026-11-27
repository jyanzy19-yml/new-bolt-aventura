# Contratos entre sistemas — BOLT · AVENTURA

Este documento combina contratos conceituais e contratos já ancorados no projeto Godot 4.7.2. Os nomes de classes, sinais, Resources e autoloads integrados devem corresponder ao código; os contratos ainda sem consumidor executável permanecem requisitos de design, não implementação presumida.

## 1. Input → Player Controller
Input publica ações lógicas e estados/edges de pressionar e soltar. O controller decide o que é permitido no estado atual. UI não deve alterar velocidade ou física diretamente.

## 2. Player/Enemy → Health e dano
Se o jogo usar um sistema comum de vida/dano, definir tipos de evento, origem, alvo, invulnerabilidade, feedback e regras de duplicidade. Não criar uma abstração genérica se houver apenas um consumidor simples.

## 3. Gameplay → HUD
HUD observa estado apresentado por contrato explícito. Não deve ser fonte de verdade de vida, fragmentos, cooldowns ou progresso. Atualizações não devem exigir polling caro sem necessidade.

## 4. Level → Checkpoint/Progress
Level informa eventos de progresso por IDs estáveis. Checkpoint e progress system definem o que persiste e como restaurar. Evitar dependência circular entre cena e save.

## 5. Dialogue/Events → Narrative Flags
Diálogos e cutscenes atualizam flags por IDs definidos e validados. Pular uma cena deve aplicar os mesmos efeitos persistentes obrigatórios de assisti-la.

## 6. Scene Flow → Loading
Um coordenador de transição controla destino, carregamento, cancelamento, erro, bloqueio de input e liberação de recursos. Impedir duas transições incompatíveis simultâneas.

**Implementação atual:** `SceneFlow` controla carregamento threaded, falha e concorrência; `LoadingOverlay` apresenta estado/progresso real. A PR #42 integrou o input lock: pausa a SceneTree, oculta controles touch e retoma após `scene_changed`, restaurando a pausa anterior em falha. A PR #69 adiciona cancelamento lógico opcional da troca: `cancel_transition()` sinaliza a intenção, mas não interrompe a thread do ResourceLoader; a operação é drenada, o destino carregado é descartado sem troca de cena e o estado de pausa anterior é restaurado. O overlay permanece visível com estado de cancelamento durante a drenagem. Preload, descarregamento seletivo e medição de memória continuam pendentes.

## 7. Audio Events → Audio Buses
Gameplay emite eventos sem conhecer detalhes de mixagem. Buses controlam categorias e configurações de usuário. Interrupção/resume deve preservar estado coerente.

## 8. Save System → Persistent State
Persistir somente dados serializáveis e versionados. Não persistir referências diretas a Nodes, objetos temporários ou caminhos frágeis de cena. O commit usa temporário + rotação do último estado íntegro para backup; o backup válido permanece após o commit e deve sobreviver à recuperação seguida de nova gravação.

## 9. Critérios de revisão
Para cada contrato, documentar produtor, consumidor, payload, frequência, ciclo de vida, tratamento de erro, ownership e testes. Revisar dependências circulares, estado duplicado e chamadas síncronas no caminho crítico.

## 10. Moving Platform → CharacterBody2D

- Plataformas estáticas usam `StaticBody2D`; plataformas móveis usam `AnimatableBody2D` com `sync_to_physics = true`.
- O movimento deve ocorrer em `_physics_process(delta)`, com tempo de percurso explícito e sem depender da taxa de renderização.
- A plataforma ocupa a world collision layer 1; o BOLT consulta essa layer pelo collision mask.
- O transporte do `CharacterBody2D` usa a velocidade nativa da plataforma calculada pelo motor. Não somar manualmente a mesma velocidade no controller, evitando duplicação.
- A plataforma deve respeitar a pausa da SceneTree e não continuar se movendo durante pause.
- O componente atual é ping-pong e placeholder; dimensões, percurso, duração, pausa de endpoint e eventual colisão one-way permanecem decisões de level design/playtest, não cânone final.

## 11. OneWayPlatform → colisão unidirecional

- `OneWayPlatform` reutiliza a geometria e o desenho de `PlatformBlock`, configurando `CollisionShape2D.one_way_collision = true`.
- `one_way_collision_direction = Vector2.DOWN` define o sentido bloqueado: o BOLT colide ao descer e pode atravessar a plataforma ao subir por baixo.
- `one_way_collision_margin` é configurável; o valor default atual é provisório e deve ser ajustado somente após playtest.
- Não implementar checagem manual de posição/velocidade no controller do player; a decisão de contato pertence ao motor de física.
- A plataforma não deve ser integrada em uma fase sem critério de level design e validação de gameplay.
