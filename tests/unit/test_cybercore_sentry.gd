extends BoltTest
## Regressões da Sentinela de Cybercore (arquétipo PROPOSTO): percepção por linha de visão,
## telegraph, direção travada, interrupção por dano, limite de um projétil e dano ao jogador.

const PLAYER_SCENE: String = "res://scenes/player/bolt.tscn"
const SENTRY_SCENE: String = "res://scenes/enemies/cybercore_sentry.tscn"
const BOLT_SCENE: String = "res://scenes/enemies/sentry_bolt.tscn"


## Monta um piso (topo em y=0), a Sentinela em x=0 e BOLT em player_x. Retorna [root, sentry, player].
func _build_arena(player_x: float, telegraph: float = 0.2, cooldown: float = 0.3) -> Array:
	var root: Node2D = Node2D.new()
	tree.root.add_child(root)
	var floor_body: StaticBody2D = StaticBody2D.new()
	floor_body.collision_layer = 1
	var floor_shape: CollisionShape2D = CollisionShape2D.new()
	var rect: RectangleShape2D = RectangleShape2D.new()
	rect.size = Vector2(4000.0, 40.0)
	floor_shape.shape = rect
	floor_body.add_child(floor_shape)
	floor_body.position = Vector2(0.0, 20.0)
	root.add_child(floor_body)
	var player: BoltPlayer = (load(PLAYER_SCENE) as PackedScene).instantiate() as BoltPlayer
	player.damage_invulnerability = 0.0
	player.position = Vector2(player_x, -24.0)
	root.add_child(player)
	var sentry: CybercoreSentry = (load(SENTRY_SCENE) as PackedScene).instantiate() as CybercoreSentry
	sentry.telegraph_time = telegraph
	sentry.cooldown_time = cooldown
	sentry.position = Vector2(0.0, -20.0)
	root.add_child(sentry)
	return [root, sentry, player]


func _wait_ticks(count: int) -> void:
	for _tick in range(count):
		await tree.physics_frame


func _cleanup(root: Node2D) -> void:
	root.queue_free()
	await tree.process_frame


func test_sentry_telegraphs_then_fires_a_bolt_toward_bolt() -> bool:
	var arena: Array = _build_arena(-200.0)
	var sentry: CybercoreSentry = arena[1]
	var fired: Array = []
	sentry.fired.connect(func(b: SentryBolt) -> void: fired.append(b))
	check_eq(sentry.state, CybercoreSentry.State.IDLE, "Sentinela inicia ociosa")
	var saw_telegraph: bool = false
	for _tick in range(60):
		await tree.physics_frame
		if sentry.state == CybercoreSentry.State.TELEGRAPH:
			saw_telegraph = true
			break
	check(saw_telegraph, "BOLT visível e alinhada inicia o telegraph")
	check(fired.is_empty(), "nenhum projétil é emitido durante o aviso")
	check(sentry.get_node("%AimLine").visible, "linha de mira é exibida durante o telegraph")
	await _wait_ticks(30)
	check_eq(fired.size(), 1, "o telegraph termina em exatamente um disparo")
	check_eq(sentry.state, CybercoreSentry.State.COOLDOWN, "após o disparo a Sentinela entra em recarga")
	if fired.size() == 1:
		var bolt: SentryBolt = fired[0]
		check(is_instance_valid(bolt) and bolt.scale.x < 0.0, "projétil segue na direção de BOLT (esquerda)")
	check(not sentry.get_node("%AimLine").visible, "linha de mira some após o disparo")
	await _cleanup(arena[0])
	return true


func test_sentry_ignores_out_of_range_and_misaligned_targets() -> bool:
	var far: Array = _build_arena(900.0)
	await _wait_ticks(40)
	check_eq((far[1] as CybercoreSentry).state, CybercoreSentry.State.IDLE, "alvo fora do alcance não provoca telegraph")
	await _cleanup(far[0])

	var high: Array = _build_arena(-200.0)
	(high[2] as BoltPlayer).position = Vector2(-200.0, -260.0)
	(high[2] as BoltPlayer).velocity = Vector2.ZERO
	await _wait_ticks(6)
	check_eq((high[1] as CybercoreSentry).state, CybercoreSentry.State.IDLE, "alvo muito acima da linha de tiro é ignorado")
	await _cleanup(high[0])
	return true


func test_cover_blocks_line_of_sight() -> bool:
	var arena: Array = _build_arena(-200.0)
	var cover: StaticBody2D = StaticBody2D.new()
	cover.collision_layer = 1
	var shape: CollisionShape2D = CollisionShape2D.new()
	var rect: RectangleShape2D = RectangleShape2D.new()
	rect.size = Vector2(24.0, 200.0)
	shape.shape = rect
	cover.add_child(shape)
	cover.position = Vector2(-100.0, -60.0)
	(arena[0] as Node2D).add_child(cover)
	var fired: Array = []
	(arena[1] as CybercoreSentry).fired.connect(func(b: SentryBolt) -> void: fired.append(b))
	await _wait_ticks(60)
	check_eq((arena[1] as CybercoreSentry).state, CybercoreSentry.State.IDLE, "abrigo no mundo bloqueia a linha de visão: sem telegraph")
	check(fired.is_empty(), "com abrigo não há disparo")
	cover.queue_free()
	await _wait_ticks(60)
	check_eq(fired.size(), 1, "removido o abrigo, a Sentinela engaja e dispara")
	await _cleanup(arena[0])
	return true


func test_hit_during_telegraph_staggers_and_cancels_the_shot() -> bool:
	var arena: Array = _build_arena(-200.0, 0.5)
	var sentry: CybercoreSentry = arena[1]
	var fired: Array = []
	sentry.fired.connect(func(b: SentryBolt) -> void: fired.append(b))
	for _tick in range(60):
		await tree.physics_frame
		if sentry.state == CybercoreSentry.State.TELEGRAPH:
			break
	check_eq(sentry.state, CybercoreSentry.State.TELEGRAPH, "pré-condição: Sentinela em telegraph")
	sentry.apply_damage(1)
	check_eq(sentry.state, CybercoreSentry.State.STAGGER, "dano durante o telegraph causa stagger")
	check(not sentry.get_node("%AimLine").visible, "stagger esconde a linha de mira")
	await _wait_ticks(40)
	check(fired.is_empty(), "o disparo cancelado não gera projétil")
	await _cleanup(arena[0])
	return true


func test_telegraph_locks_direction_so_moving_away_dodges() -> bool:
	var arena: Array = _build_arena(-200.0, 0.5)
	var sentry: CybercoreSentry = arena[1]
	var player: BoltPlayer = arena[2]
	var fired: Array = []
	sentry.fired.connect(func(b: SentryBolt) -> void: fired.append(b))
	for _tick in range(60):
		await tree.physics_frame
		if sentry.state == CybercoreSentry.State.TELEGRAPH:
			break
	player.global_position = Vector2(200.0, -24.0)
	player.velocity = Vector2.ZERO
	await _wait_ticks(45)
	check_eq(fired.size(), 1, "o disparo ocorre mesmo após BOLT trocar de lado")
	if fired.size() == 1:
		check((fired[0] as SentryBolt).scale.x < 0.0, "direção foi travada no início do aviso (continua à esquerda)")
	await _cleanup(arena[0])
	return true


func test_only_one_bolt_in_flight_then_fires_again_after_it_expires() -> bool:
	var arena: Array = _build_arena(-300.0, 0.2, 0.3)
	var sentry: CybercoreSentry = arena[1]
	sentry.bolt_speed = 60.0
	var fired: Array = []
	sentry.fired.connect(func(b: SentryBolt) -> void: fired.append(b))
	await _wait_ticks(150)
	check_eq(fired.size(), 1, "enquanto o projétil lento está em voo não há segundo disparo")
	check(is_instance_valid(fired[0]), "o primeiro projétil ainda está em voo")
	var waited: int = 0
	while fired.size() < 2 and waited < 240:
		await tree.physics_frame
		waited += 1
	check_eq(fired.size(), 2, "após o projétil expirar a Sentinela pode atirar de novo")
	await _cleanup(arena[0])
	return true


func test_bolt_damages_player_once_and_despawns_on_world() -> bool:
	var root: Node2D = Node2D.new()
	tree.root.add_child(root)
	var player: BoltPlayer = (load(PLAYER_SCENE) as PackedScene).instantiate() as BoltPlayer
	player.position = Vector2(0.0, -24.0)
	root.add_child(player)
	var health: BoltHealth = player.get_node("%Health") as BoltHealth
	var bolt: SentryBolt = (load(BOLT_SCENE) as PackedScene).instantiate() as SentryBolt
	root.add_child(bolt)
	bolt.global_position = Vector2(-40.0, -24.0)
	bolt.configure(1, 170.0, 1)
	var expired: Array = []
	bolt.expired.connect(func() -> void: expired.append(true))
	await _wait_ticks(30)
	check_eq(health.current_health, 2, "projétil causa exatamente 1 de dano em BOLT")
	check_eq(expired.size(), 1, "projétil expira ao acertar")
	await tree.process_frame
	check(not is_instance_valid(bolt), "projétil é liberado após o impacto")

	var wall: StaticBody2D = StaticBody2D.new()
	wall.collision_layer = 1
	var shape: CollisionShape2D = CollisionShape2D.new()
	var rect: RectangleShape2D = RectangleShape2D.new()
	rect.size = Vector2(20.0, 200.0)
	shape.shape = rect
	wall.add_child(shape)
	wall.position = Vector2(500.0, -24.0)
	root.add_child(wall)
	var bolt2: SentryBolt = (load(BOLT_SCENE) as PackedScene).instantiate() as SentryBolt
	root.add_child(bolt2)
	bolt2.global_position = Vector2(400.0, -24.0)
	bolt2.configure(1, 170.0, 1)
	await _wait_ticks(40)
	await tree.process_frame
	check(not is_instance_valid(bolt2), "projétil é liberado ao colidir com o mundo")
	check_eq(health.current_health, 2, "colidir com o mundo não causa dano")
	await _cleanup(root)
	return true


func test_sentry_has_no_contact_damage_and_defeat_emits_signal() -> bool:
	var arena: Array = _build_arena(0.0, 5.0, 5.0)
	var sentry: CybercoreSentry = arena[1]
	var player: BoltPlayer = arena[2]
	var health: BoltHealth = player.get_node("%Health") as BoltHealth
	await _wait_ticks(20)
	check_eq(health.current_health, 3, "encostar na Sentinela não causa dano (o perigo é o disparo)")
	var defeated: Array = []
	sentry.defeated.connect(func() -> void: defeated.append(true))
	sentry.apply_damage(1)
	check(defeated.is_empty(), "uma pancada não derrota (2 de vida)")
	sentry.apply_damage(1)
	check_eq(defeated.size(), 1, "segunda pancada derrota a Sentinela")
	await tree.process_frame
	check(not is_instance_valid(sentry), "Sentinela derrotada é liberada")
	await _cleanup(arena[0])
	return true


## Um Polygon2D auto-intersectante não triangula e simplesmente não é desenhado (bug visual silencioso).
func test_all_polygons_in_enemy_scenes_triangulate_so_they_render() -> bool:
	for path: String in [SENTRY_SCENE, BOLT_SCENE, "res://scenes/campaign/cybercore_w1_l3.tscn"]:
		var root_node: Node = (load(path) as PackedScene).instantiate()
		var polygons: Array[Node] = root_node.find_children("*", "Polygon2D", true, false)
		check(not polygons.is_empty(), "%s contém polígonos visuais" % path)
		for node: Node in polygons:
			var polygon: Polygon2D = node as Polygon2D
			check(not Geometry2D.triangulate_polygon(polygon.polygon).is_empty(), "%s/%s triangula (é desenhado)" % [path.get_file(), polygon.name])
		root_node.free()
	return true
