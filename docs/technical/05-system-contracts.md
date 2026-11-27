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


## 12. Enemy → Health / Contact / Lifecycle

### Implementação provisória atual

- A raiz `CybercorePatrolEnemy` (`CharacterBody2D`) é dona do movimento de patrulha, direção, estado ativo e coordenação do ciclo de vida.
- O componente filho `BoltHealth` é dono dos valores de vida e dos sinais `health_changed`/`depleted`; o inimigo não duplica o contador de vida.
- `ContactArea` detecta contato físico com BOLT. O callback encaminha o dano por `BoltPlayer.take_damage()`, preservando invulnerabilidade, knockback e feedback do domínio do jogador.
- `apply_damage(amount)` encaminha a mutação para `BoltHealth` e emite `hit_received(remaining_health)` somente quando o dano é aceito.
- A transição para derrotado é idempotente: o inimigo marca seu ciclo como inativo, emite `defeated` uma única vez e solicita remoção com `queue_free()`.
- Como `queue_free()` posterga a remoção física até o fim do frame, callbacks de contato tardios precisam ser ignorados quando o inimigo já estiver inativo. O estado de lifecycle, e não a existência temporária do nó na SceneTree, é a autoridade.

### Limites de arquitetura

- `CybercorePatrolEnemy` continua sendo um inimigo-base provisório, não um arquétipo canônico nem uma implementação final de IA.
- Não criar agora uma hierarquia genérica de inimigos, sistema universal de dano ou máquina de estados abstrata sem pelo menos um segundo consumidor real que demonstre a necessidade.
- Novos arquétipos devem reutilizar contratos comprovados (vida, sinais de lifecycle, dano ao Player) e manter movimento/percepção específicos por composição.
- UI/HUD observa sinais de apresentação; não altera vida, estado ativo ou ciclo de vida diretamente.
- Assets visuais finais permanecem sujeitos ao pipeline de aprovação e não fazem parte deste contrato.

### Cobertura de regressão

Os testes devem cobrir vida inicial, dano aceito/rejeitado, feedback, contato físico, invulnerabilidade do jogador, derrota idempotente, callback tardio após derrota e remoção do inimigo. Testes headless não comprovam leitura visual, balanceamento ou playtest Android.


### Arquitetura de referência para novos arquétipos

A arquitetura deve separar dois eixos de estado:

1. **Lifecycle:** `ACTIVE` → `DEFEATED` (e, somente se um caso real exigir, `DESPAWNED` ou `DISABLED`). Lifecycle governa se a entidade ainda pode processar movimento, contato, dano e sinais.
2. **Behavior:** estados próprios do arquétipo, como patrulha, alerta, preparação, execução e recuperação. Não criar estados comportamentais no inimigo que não os utiliza.

A entidade raiz deve manter ownership de:
- transform, corpo físico e uma única chamada de movimento por tick;
- lifecycle e transição terminal;
- coordenação entre componentes;
- sinais públicos consumidos pela fase.

Componentes/filhos opcionais:
- `BoltHealth`: vida e evento de esgotamento;
- `ContactArea`: volume de contato físico e encaminhamento para a API do alvo;
- `DetectionArea` ou sensores direcionais: percepção, separados do volume de contato;
- comportamento de locomoção: somente quando mais de um comportamento real justificar extração;
- apresentação: recebe eventos/estado, sem controlar vida ou física.

Não é obrigatório que todos os inimigos tenham todos os componentes. Uma composição menor é preferível a uma cena-base inchada.

### Percepção

- Percepção deve produzir observações (por exemplo, alvo entrou/saiu de alcance), não aplicar dano nem alterar CampaignProgress.
- `DetectionArea` não deve reutilizar `ContactArea`: proximidade de detecção e contato físico têm semânticas diferentes.
- Linha de visão, cones, alcance e memória de alvo só devem ser adicionados quando um arquétipo aprovado precisar deles.
- A percepção deve ter limites explícitos de frequência, alcance e quantidade de alvos; a fase não deve ser consultada por caminhos frágeis ou nomes de nós.
- **Estado atual:** o inimigo provisório implementa contato, não percepção/alerta. Não declarar detecção ou perseguição implementadas.

### Locomoção e navegação local

- O comportamento calcula uma intenção de movimento; a raiz aplica velocidade e executa a resolução física uma única vez.
- Não combinar múltiplos `move_and_slide()` no mesmo tick nem somar duas vezes a velocidade de plataformas móveis.
- Limites de patrulha devem ser definidos em coordenadas locais/âncora estável ou por contrato explícito da fase; não inferir limites a partir de nomes de nós.
- Navegação local não equivale a pathfinding global. Para plataformas 2D, usar soluções específicas por arquétipo (patrulha, salto entre plataformas, perseguição limitada) e não adicionar um sistema global sem necessidade comprovada.
- **Estado atual:** `CybercorePatrolEnemy` usa patrulha horizontal relativa à posição inicial. Não possui navegação por plataformas nem percepção de obstáculos.

### Telegraphs e contratos de encontro

- Um telegraph comunica intenção e janela temporal; não causa dano por si só.
- O comportamento deve emitir eventos de início/fim de telegraph com identidade estável do padrão e duração definida; a camada de apresentação observa esses eventos.
- A fase/arena define limites, condições de ativação e regras de encerramento do encontro. O inimigo não deve conhecer o HUD, o objetivo da fase, o SaveSystem ou CampaignProgress.
- A fase reage a `defeated` para atualizar o encontro/progresso. Recompensas e flags persistentes pertencem ao domínio da campanha, não ao script do inimigo.
- **Estado atual:** o inimigo-base provisório não possui telegraphs nem lógica de encontro; esses contratos são requisitos para arquétipos e chefes futuros.

### Dados e extensibilidade

- Valores exportados no inimigo atual são provisórios e locais à cena.
- Criar um `Resource` de definição somente quando dois ou mais arquétipos compartilharem dados estáveis que precisem de autoria/reuso; evitar antecipar um catálogo genérico sem consumidores.
- IDs de arquétipo e de instância persistente, quando necessários, devem ser separados de nomes de apresentação. O inimigo provisório atual ainda não participa de persistência.
- Novos componentes devem declarar produtor, consumidor, payload, lifecycle, ownership, falha e testes antes de integração.

### Harnesses e critérios de aceite da arquitetura

Para cada novo arquétipo, criar harnesses headless que instanciem a cena isoladamente e verifiquem:
- lifecycle inicial, transições válidas e transição terminal idempotente;
- movimento dentro dos limites declarados e respeito à pausa;
- percepção com entrada/saída e perda de alvo, quando implementada;
- separação entre detecção, contato e telegraph;
- dano, invulnerabilidade do alvo e callback tardio;
- sinais de encontro sem dependência direta do HUD ou da campanha;
- remoção/retorno ao pool apenas se pooling vier a ser justificado.

A arquitetura de referência está documentada; percepção, navegação por plataformas, telegraphs, pooling e arquétipos adicionais continuam não implementados e não devem ser promovidos a estado validado.
