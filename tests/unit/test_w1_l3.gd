extends BoltTest
## W1-L3 Setor de Montagem (blockout): integridade da geometria, travessia por plataformas móveis,
## checkpoints persistentes, conclusão e encadeamento L2 -> L3. Valores de layout são provisórios.

const LEVEL_SCENE: String = "res://scenes/campaign/cybercore_w1_l3.tscn"
const TEST_SAVE_PATH: String = "user://bolt_w1_l3_test.json"
const CHECKPOINT_A: String = "cybercore_w1_l3_checkpoint_a"
const CHECKPOINT_B: String = "cybercore_w1_l3_checkpoint_b"


func _begin() -> void:
	SaveSystem.storage_path_override = TEST_SAVE_PATH
	SaveSystem.delete_save()


func _end() -> void:
	tree.paused = false
	SaveSystem.delete_save()
	SaveSystem.storage_path_override = ""


func _spawn_level() -> Node:
	var packed: PackedScene = load(LEVEL_SCENE) as PackedScene
	check(packed != null, "cena W1-L3 carrega")
	if packed == null:
		return null
	var level: Node = packed.instantiate()
	tree.root.add_child(level)
	await tree.physics_frame
	return level


func _right(block: PlatformBlock) -> float:
	return block.global_position.x + block.size.x


func test_w1_l3_geometry_is_continuous_between_platforms_and_floors() -> bool:
	_begin()
	var level: Node = await _spawn_level()
	if level == null:
		_end()
		return true
	var start_floor: PlatformBlock = level.get_node("Geometry/StartFloor") as PlatformBlock
	var floor_b: PlatformBlock = level.get_node("Geometry/FloorB") as PlatformBlock
	var floor_c: PlatformBlock = level.get_node("Geometry/FloorC") as PlatformBlock
	var ferry: MovingPlatform = level.get_node("Geometry/PitFerry") as MovingPlatform
	var lift: MovingPlatform = level.get_node("Geometry/AssemblyLift") as MovingPlatform
	check(start_floor != null and floor_b != null and floor_c != null and ferry != null and lift != null, "geometria essencial existe")
	# Plataformas já se moveram um frame: compara com a posição inicial real.
	var ferry_start: Vector2 = ferry.get("_start_position")
	var lift_start: Vector2 = lift.get("_start_position")
	# Balsa: encosta no piso inicial na saída e no piso B na chegada (mesma altura).
	check_near(ferry_start.x, _right(start_floor), 0.5, "balsa parte rente ao fim do piso inicial")
	check_near(ferry_start.x + ferry.travel_offset.x + ferry.size.x, floor_b.global_position.x, 0.5, "balsa chega rente ao início do piso B")
	check_near(ferry_start.y, start_floor.global_position.y, 0.5, "balsa viaja na altura dos pisos")
	check_near(floor_b.global_position.y, start_floor.global_position.y, 0.5, "pisos inicial e B estão alinhados")
	# Elevador: base ao lado do piso B, topo alinhado ao piso C.
	check_near(lift_start.x, _right(floor_b), 0.5, "elevador encosta no fim do piso B")
	check_near(lift_start.y, floor_b.global_position.y, 0.5, "elevador parte na altura do piso B")
	check_near(lift_start.y + lift.travel_offset.y, floor_c.global_position.y, 0.5, "elevador chega na altura do piso C")
	check_near(lift_start.x + lift.size.x, floor_c.global_position.x, 0.5, "elevador encosta no início do piso C")
	# Salto máximo de 'degrau' do elevador: nunca exige salto além do piso do fim.
	check(absf(lift.travel_offset.y) <= 240.0, "subida do elevador é feita pela plataforma, não por salto")
	# Posicionamento de objetos de gameplay sobre pisos corretos.
	var checkpoint_a: BoltCheckpoint = level.get_node("%CheckpointA") as BoltCheckpoint
	var checkpoint_b: BoltCheckpoint = level.get_node("%CheckpointB") as BoltCheckpoint
	var goal: Area2D = level.get_node("%Goal") as Area2D
	check(checkpoint_a.global_position.x > floor_b.global_position.x and checkpoint_a.global_position.x < _right(floor_b), "checkpoint A sobre o piso B")
	check(checkpoint_b.global_position.x > floor_c.global_position.x and checkpoint_b.global_position.x < _right(floor_c), "checkpoint B sobre o piso C")
	check(goal.global_position.x > floor_c.global_position.x and goal.global_position.x < _right(floor_c), "saída sobre o piso C")
	for sentry_name: String in ["SentryB", "SentryC"]:
		var sentry: Node2D = level.get_node(sentry_name) as Node2D
		var floor_block: PlatformBlock = floor_b if sentry_name == "SentryB" else floor_c
		check(sentry.global_position.x > floor_block.global_position.x and sentry.global_position.x < _right(floor_block), "%s está sobre seu piso" % sentry_name)
		check_near(sentry.global_position.y, floor_block.global_position.y - 20.0, 1.0, "%s apoiada no topo do piso" % sentry_name)
	check_eq(checkpoint_a.checkpoint_id, &"cybercore_w1_l3_checkpoint_a", "ID do checkpoint A")
	check_eq(checkpoint_b.checkpoint_id, &"cybercore_w1_l3_checkpoint_b", "ID do checkpoint B")
	level.free()
	_end()
	return true


func _spawn_level_without_sentries() -> Node:
	var level: Node = await _spawn_level()
	if level == null:
		return null
	for sentry_name: String in ["SentryB", "SentryC"]:
		(level.get_node(sentry_name) as Node).free()  # isola a travessia do dano dos disparos
	return level


func test_w1_l3_ferry_carries_bolt_across_the_pit() -> bool:
	_begin()
	var level: Node = await _spawn_level_without_sentries()
	if level == null:
		_end()
		return true
	var player: BoltPlayer = level.get_node("%Bolt") as BoltPlayer
	var ferry: MovingPlatform = level.get_node("Geometry/PitFerry") as MovingPlatform
	player.global_position = Vector2(ferry.global_position.x + 64.0, -24.0)
	player.velocity = Vector2.ZERO
	var start_x: float = player.global_position.x
	for _tick in range(150):
		await tree.physics_frame
	check(player.global_position.x > start_x + 60.0, "BOLT parada sobre a balsa é transportada")
	check(player.global_position.y > -40.0 and player.global_position.y < -10.0, "BOLT permanece apoiada na balsa (não afunda nem flutua)")
	level.free()
	_end()
	return true


func test_w1_l3_lift_raises_bolt_to_the_upper_floor_level() -> bool:
	_begin()
	var level: Node = await _spawn_level_without_sentries()
	if level == null:
		_end()
		return true
	var player: BoltPlayer = level.get_node("%Bolt") as BoltPlayer
	var lift: MovingPlatform = level.get_node("Geometry/AssemblyLift") as MovingPlatform
	var floor_c: PlatformBlock = level.get_node("Geometry/FloorC") as PlatformBlock
	player.global_position = Vector2(lift.global_position.x + 64.0, -24.0)
	player.velocity = Vector2.ZERO
	var start_y: float = player.global_position.y
	for _tick in range(60):
		await tree.physics_frame
	check(player.global_position.y < start_y - 40.0, "BOLT parada sobre o elevador sobe com ele")
	# Ciclo completo de subida (3,2 s) + margem: BOLT chega à altura do piso C e pode desembarcar.
	for _tick in range(160):
		await tree.physics_frame
	check(player.global_position.y < floor_c.global_position.y - 10.0, "no topo o elevador deixa BOLT na altura do piso C")
	level.free()
	_end()
	return true


func test_w1_l3_checkpoints_persist_and_resume_restores_latest() -> bool:
	_begin()
	var level: Node = await _spawn_level()
	if level == null:
		_end()
		return true
	check_eq(CampaignProgress.load_state().get("current_level_id"), "W1-L3", "entrada registra W1-L3 como destino de retomada")
	var player: BoltPlayer = level.get_node("%Bolt") as BoltPlayer
	var hud: Hud = level.get_node("%Hud") as Hud
	var checkpoint_a: BoltCheckpoint = level.get_node("%CheckpointA") as BoltCheckpoint
	var checkpoint_b: BoltCheckpoint = level.get_node("%CheckpointB") as BoltCheckpoint
	check_eq(CampaignProgress.get_checkpoint_id("W1-L3"), "", "sem checkpoint ao entrar pela primeira vez")

	player.global_position = checkpoint_a.global_position
	player.velocity = Vector2.ZERO
	for _tick in range(4):
		await tree.physics_frame
	check(checkpoint_a.is_activated(), "BOLT ativa o checkpoint A por contato físico")
	check_eq(CampaignProgress.get_checkpoint_id("W1-L3"), CHECKPOINT_A, "checkpoint A persiste com ID próprio")
	check_eq(hud.get_node("%ProgressNotification").text, "CHECKPOINT ATIVADO", "ativação mostra feedback")

	player.global_position = checkpoint_b.global_position
	player.velocity = Vector2.ZERO
	for _tick in range(4):
		await tree.physics_frame
	check(checkpoint_b.is_activated(), "BOLT ativa o checkpoint B")
	check_eq(CampaignProgress.get_checkpoint_id("W1-L3"), CHECKPOINT_B, "checkpoint B substitui o A na persistência")

	# Queda no vazio: respawn no checkpoint mais recente, com vida restaurada.
	var kill_zone: Area2D = level.get_node("%KillZone") as Area2D
	player.global_position = Vector2(checkpoint_b.global_position.x, kill_zone.global_position.y)
	for _tick in range(6):
		await tree.physics_frame
	check(player.global_position.distance_to(checkpoint_b.get_respawn_position()) < 40.0, "queda reposiciona BOLT no checkpoint B")
	level.free()
	await tree.process_frame

	# Retomada: nova instância restaura o checkpoint salvo e posiciona BOLT nele.
	var resumed: Node = await _spawn_level()
	var resumed_player: BoltPlayer = resumed.get_node("%Bolt") as BoltPlayer
	var resumed_b: BoltCheckpoint = resumed.get_node("%CheckpointB") as BoltCheckpoint
	var resumed_a: BoltCheckpoint = resumed.get_node("%CheckpointA") as BoltCheckpoint
	check(resumed_b.is_activated(), "retomada reativa o checkpoint B salvo")
	check(not resumed_a.is_activated(), "retomada não reativa o checkpoint A superado")
	check(resumed_player.global_position.distance_to(resumed_b.get_respawn_position()) < 8.0, "retomada posiciona BOLT no checkpoint salvo")
	resumed.free()
	_end()
	return true


func test_w1_l3_goal_completes_level_without_next_destination() -> bool:
	_begin()
	var level: Node = await _spawn_level()
	if level == null:
		_end()
		return true
	for sentry_name: String in ["SentryB", "SentryC"]:
		(level.get_node(sentry_name) as Node).free()
	var player: BoltPlayer = level.get_node("%Bolt") as BoltPlayer
	var hud: Hud = level.get_node("%Hud") as Hud
	var goal: Area2D = level.get_node("%Goal") as Area2D
	check(not CampaignProgress.is_level_completed("W1-L3"), "fase começa não concluída")
	player.global_position = goal.global_position
	player.velocity = Vector2.ZERO
	for _tick in range(4):
		await tree.physics_frame
		if hud.get_node("%ResultOverlay").visible:
			break
	check(hud.get_node("%ResultOverlay").visible, "saída física conclui W1-L3")
	check(CampaignProgress.is_level_completed("W1-L3"), "conclusão de W1-L3 persiste")
	check_eq(CampaignProgress.load_state().get("current_level_id"), "W1-L3", "sem fase seguinte implementada, a retomada permanece em W1-L3")
	check_eq(hud.get_node("%AgainButton").text, "JOGAR DE NOVO", "última fase implementada oferece reinício, não destino inexistente")
	level.free()
	_end()
	return true


func test_w1_l3_has_two_sentries_and_two_patrols_with_enemy_contract() -> bool:
	_begin()
	var level: Node = await _spawn_level()
	if level == null:
		_end()
		return true
	var sentries: int = 0
	var patrols: int = 0
	for child: Node in level.get_children():
		if child is CybercoreSentry:
			sentries += 1
			check(child.collision_layer == 4 and child.has_method("apply_damage") and child.has_signal("defeated"), "%s segue o contrato de inimigo (layer 4, apply_damage, defeated)" % child.name)
		elif child is CybercorePatrolEnemy:
			patrols += 1
	check_eq(sentries, 2, "duas Sentinelas na fase")
	check_eq(patrols, 2, "dois inimigos de patrulha na fase")
	level.free()
	_end()
	return true
