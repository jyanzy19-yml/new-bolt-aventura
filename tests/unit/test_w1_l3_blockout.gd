extends BoltTest
## Integração do blockout W1-L3 com progressão, checkpoints e retomada.

const W1_L2_SCENE: String = "res://scenes/campaign/cybercore_w1_l2.tscn"
const W1_L3_SCENE: String = "res://scenes/campaign/cybercore_w1_l3.tscn"
const MAIN_MENU_SCENE: String = "res://scenes/ui/main_menu.tscn"
const TEST_SAVE_PATH: String = "user://bolt_w1_l3_blockout_test.json"


func _step_physics(frames: int) -> void:
	for _frame in range(frames):
		await tree.physics_frame


func _prepare_save() -> void:
	SaveSystem.storage_path_override = TEST_SAVE_PATH
	SaveSystem.delete_save()


func _clear_save() -> void:
	tree.paused = false
	SaveSystem.delete_save()
	SaveSystem.storage_path_override = ""


func test_w1_l3_composition_and_checkpoint_survive_scene_reentry() -> bool:
	_prepare_save()
	var packed: PackedScene = load(W1_L3_SCENE) as PackedScene
	check(packed != null, "cena W1-L3 carrega")
	if packed == null:
		_clear_save()
		return true

	var level: Node2D = packed.instantiate() as Node2D
	tree.root.add_child(level)
	await tree.physics_frame

	var player: BoltPlayer = level.get_node("Bolt") as BoltPlayer
	var mid_floor: PlatformBlock = level.get_node("Geometry/MidFloor") as PlatformBlock
	var end_floor: PlatformBlock = level.get_node("Geometry/EndFloor") as PlatformBlock
	var lift: MovingPlatform = level.get_node("LiftA") as MovingPlatform
	var transfer: MovingPlatform = level.get_node("TransferPlatform") as MovingPlatform
	var enemy_a: CybercorePatrolEnemy = level.get_node("PatrolEnemyA") as CybercorePatrolEnemy
	var enemy_b: CybercorePatrolEnemy = level.get_node("PatrolEnemyB") as CybercorePatrolEnemy
	var checkpoint: BoltCheckpoint = level.get_node("Checkpoint") as BoltCheckpoint
	var goal: Area2D = level.get_node("Goal") as Area2D

	check(player != null and mid_floor != null and end_floor != null, "BOLT e pisos principais estão presentes")
	check(lift != null and transfer != null, "blockout contém elevador e plataforma de transferência")
	check(enemy_a != null and enemy_b != null, "blockout contém dois encontros provisórios")
	check(checkpoint != null and goal != null, "blockout contém checkpoint e objetivo")
	check_eq(CampaignProgress.load_state().get("current_level_id"), "W1-L3",
		"entrada registra W1-L3 como destino de retomada")
	if player == null or mid_floor == null or end_floor == null or lift == null or transfer == null or checkpoint == null:
		level.free()
		await tree.process_frame
		_clear_save()
		return true
	check_eq(lift.travel_offset, Vector2(0.0, -48.0), "elevador usa percurso vertical documentado")
	check_eq(transfer.travel_offset, Vector2(160.0, 0.0), "plataforma de transferência usa percurso horizontal documentado")
	if enemy_a != null and mid_floor != null:
		check(enemy_a.global_position.x - enemy_a.patrol_distance >= mid_floor.global_position.x,
			"limite esquerdo do primeiro patrulheiro permanece no piso intermediário")
		check(enemy_a.global_position.x + enemy_a.patrol_distance <= mid_floor.global_position.x + mid_floor.size.x,
			"limite direito do primeiro patrulheiro permanece no piso intermediário")
	if enemy_b != null and end_floor != null:
		check(enemy_b.global_position.x - enemy_b.patrol_distance >= end_floor.global_position.x,
			"limite esquerdo do segundo patrulheiro permanece no piso final")
		check(enemy_b.global_position.x + enemy_b.patrol_distance <= end_floor.global_position.x + end_floor.size.x,
			"limite direito do segundo patrulheiro permanece no piso final")

	if player != null and checkpoint != null:
		player.global_position = checkpoint.global_position
		player.velocity = Vector2.ZERO
		await _step_physics(3)
		check(checkpoint.is_activated(), "contato físico ativa o checkpoint W1-L3")
		var checkpoint_hud: Hud = level.get_node("Hud") as Hud
		check(checkpoint_hud.get_node("%ProgressNotification").visible,
			"HUD notifica ativação mesmo quando a persistência é bem-sucedida")
		check_eq(checkpoint_hud.get_node("%ProgressNotification").text, "CHECKPOINT ATIVADO",
			"notificação do checkpoint apresenta o estado correto")
		check_eq(CampaignProgress.get_checkpoint_id("W1-L3"), "cybercore_w1_l3_checkpoint",
			"checkpoint persiste com ID estável")
	level.free()
	await tree.process_frame

	level = packed.instantiate() as Node2D
	tree.root.add_child(level)
	await tree.physics_frame
	checkpoint = level.get_node("Checkpoint") as BoltCheckpoint
	player = level.get_node("Bolt") as BoltPlayer
	check(checkpoint.is_activated(), "checkpoint restaurado ao reentrar em W1-L3")
	check(player.global_position.distance_to(checkpoint.get_respawn_position()) < 2.0,
		"BOLT retorna ao ponto persistido do checkpoint")

	level.free()
	await tree.process_frame
	_clear_save()
	return true


func test_w1_l2_completion_routes_to_w1_l3_and_menu_can_resume_it() -> bool:
	_prepare_save()
	var packed: PackedScene = load(W1_L2_SCENE) as PackedScene
	check(packed != null, "cena W1-L2 carrega para validar transição de campanha")
	if packed == null:
		_clear_save()
		return true

	var level: Node2D = packed.instantiate() as Node2D
	tree.root.add_child(level)
	await tree.physics_frame
	var player: BoltPlayer = level.get_node("Bolt") as BoltPlayer
	var goal: Area2D = level.get_node("Goal") as Area2D
	var hud: Hud = level.get_node("Hud") as Hud
	check(player != null and goal != null and hud != null, "W1-L2 expõe jogador, objetivo e HUD")
	if player == null or goal == null or hud == null:
		level.free()
		await tree.process_frame
		_clear_save()
		return true
	player.global_position = goal.global_position
	player.velocity = Vector2.ZERO
	await _step_physics(3)

	var state: Dictionary = CampaignProgress.load_state()
	check(CampaignProgress.is_level_completed("W1-L2"), "conclusão de W1-L2 fica persistida")
	check_eq(state.get("current_level_id"), "W1-L3", "W1-L2 define W1-L3 como próximo destino")
	check(hud.get_node("%ResultOverlay").visible, "conclusão apresenta o overlay de resultado")
	check_eq(hud.get_node("%AgainButton").text, "PRÓXIMA FASE", "HUD oferece avanço para W1-L3")

	tree.paused = false
	level.free()
	await tree.process_frame

	var menu_packed: PackedScene = load(MAIN_MENU_SCENE) as PackedScene
	check(menu_packed != null, "menu principal carrega para teste de retomada")
	if menu_packed != null:
		var menu: Control = menu_packed.instantiate() as Control
		tree.root.add_child(menu)
		await tree.process_frame
		check_eq(menu.call("_resolve_level_path", "W1-L3"), W1_L3_SCENE,
			"menu resolve o destino salvo W1-L3")
		menu.free()
		await tree.process_frame

	_clear_save()
	return true
