extends BoltTest
## Regressões do blockout vertical W1-L4 — Laboratório de Memórias.

const LEVEL_SCENE: String = "res://scenes/campaign/cybercore_w1_l4.tscn"
const MAIN_MENU_SCENE: String = "res://scenes/ui/main_menu.tscn"
const PHASE_SELECTION_SCENE: String = "res://scenes/ui/phase_selection.tscn"
const ALTERNATING_PLATFORM_SCENE: String = "res://scenes/world/alternating_platform.tscn"
const TEST_SAVE_PATH: String = "user://bolt_w1_l4_memory_lab_test.json"


func _step_physics(frames: int) -> void:
	for _frame in range(frames):
		await tree.physics_frame


func _prepare_save() -> void:
	tree.paused = false
	SaveSystem.storage_path_override = TEST_SAVE_PATH
	SaveSystem.delete_save()


func _clear_save() -> void:
	tree.paused = false
	SaveSystem.delete_save()
	SaveSystem.storage_path_override = ""


func test_w1_l4_vertical_composition_matches_memory_lab_blueprint() -> bool:
	_prepare_save()
	var packed: PackedScene = load(LEVEL_SCENE) as PackedScene
	check(packed != null, "cena W1-L4 Laboratório de Memórias carrega")
	if packed == null:
		_clear_save()
		return true

	var level: Node2D = packed.instantiate() as Node2D
	tree.root.add_child(level)
	await tree.physics_frame
	var player: BoltPlayer = level.get_node("Bolt") as BoltPlayer
	var lift_a: MovingPlatform = level.get_node("LiftA") as MovingPlatform
	var lift_b: MovingPlatform = level.get_node("LiftB") as MovingPlatform
	var lift_c: MovingPlatform = level.get_node("LiftC") as MovingPlatform
	var alternating_a: AlternatingPlatform = level.get_node("Geometry/AlternatingA") as AlternatingPlatform
	var alternating_c: AlternatingPlatform = level.get_node("Geometry/AlternatingC") as AlternatingPlatform
	var laser_a: TimedEnergyGate = level.get_node("LaserA") as TimedEnergyGate
	var laser_b: TimedEnergyGate = level.get_node("LaserB") as TimedEnergyGate
	var record: NarrativeBeatTrigger = level.get_node("MemoryRecordTrigger") as NarrativeBeatTrigger
	var echo: NarrativeBeatTrigger = level.get_node("MemoryEchoTrigger") as NarrativeBeatTrigger
	var checkpoint_archive: BoltCheckpoint = level.get_node("CheckpointArchive") as BoltCheckpoint
	var checkpoint_chambers: BoltCheckpoint = level.get_node("CheckpointChambers") as BoltCheckpoint

	check(player != null, "BOLT está presente no laboratório")
	check(lift_a != null and lift_b != null and lift_c != null, "três elevadores compõem a rota vertical")
	check(alternating_a != null and alternating_c != null, "plataformas alternantes compõem câmaras de teste")
	check(laser_a != null and laser_b != null, "lasers ambientais estão presentes")
	check(record != null and echo != null, "arquivo central e memória secreta emitem beats por ID")
	check(checkpoint_archive != null and checkpoint_chambers != null, "dois checkpoints dividem a subida")
	if lift_a != null and lift_b != null and lift_c != null:
		check_eq(lift_a.travel_offset, Vector2(0.0, -200.0), "elevador A sobe verticalmente")
		check_eq(lift_b.travel_offset, Vector2(0.0, -220.0), "elevador B sobe verticalmente")
		check_eq(lift_c.travel_offset, Vector2(0.0, -220.0), "elevador C sobe verticalmente")
	if alternating_a != null and alternating_c != null:
		check_eq(alternating_a.get_state(), AlternatingPlatform.State.ACTIVE, "plataforma alternante inicia sólida")
		check(alternating_a.is_solid() and alternating_c.is_solid(), "plataformas começam com colisão habilitada")
	if laser_a != null and laser_b != null:
		check(not laser_a.is_active() and not laser_b.is_active(), "lasers começam na janela segura previsível")
	check_eq(CampaignProgress.load_state().get("current_level_id"), "W1-L4", "entrada registra W1-L4")
	if player != null:
		var camera: Camera2D = player.get_camera()
		check(camera.limit_top <= -1800, "câmera cobre a extensão vertical do laboratório")
	level.free()
	await tree.process_frame
	_clear_save()
	return true


func test_alternating_platform_warns_before_losing_and_restoring_collision() -> bool:
	var packed: PackedScene = load(ALTERNATING_PLATFORM_SCENE) as PackedScene
	check(packed != null, "cena de plataforma alternante carrega")
	if packed == null:
		return true
	var platform: AlternatingPlatform = packed.instantiate() as AlternatingPlatform
	platform.size = Vector2(180.0, 24.0)
	platform.active_duration = 0.12
	platform.warning_duration = 0.12
	platform.inactive_duration = 0.12
	platform.reactivation_warning_duration = 0.12
	tree.root.add_child(platform)
	await _step_physics(2)
	check_eq(platform.get_state(), AlternatingPlatform.State.ACTIVE, "plataforma inicia ativa")
	check(platform.is_collision_enabled(), "plataforma ativa é sólida")

	tree.paused = true
	for _frame in range(12):
		await tree.process_frame
	check_eq(platform.get_state(), AlternatingPlatform.State.ACTIVE, "pausa congela a alternância")
	tree.paused = false

	await _step_physics(10)
	check_eq(platform.get_state(), AlternatingPlatform.State.WARNING_OFF, "aviso antecede a desativação")
	check(platform.is_collision_enabled(), "plataforma permanece sólida durante o aviso de saída")
	await _step_physics(10)
	check_eq(platform.get_state(), AlternatingPlatform.State.INACTIVE, "plataforma entra no estado inativo")
	check(not platform.is_collision_enabled(), "colisão é removida somente após o aviso")
	await _step_physics(10)
	check_eq(platform.get_state(), AlternatingPlatform.State.WARNING_ON, "aviso antecede a reativação")
	check(not platform.is_collision_enabled(), "plataforma ainda não é sólida durante o aviso de retorno")
	var saw_active: bool = false
	for _frame in range(20):
		if platform.get_state() == AlternatingPlatform.State.ACTIVE:
			saw_active = true
			break
		await tree.physics_frame
	check(saw_active, "plataforma retorna ao estado ativo após o aviso")
	check(platform.is_collision_enabled(), "colisão retorna depois do aviso")
	platform.free()
	await tree.process_frame
	return true


func test_w1_l4_requires_preservation_record_and_emits_optional_memory() -> bool:
	_prepare_save()
	var packed: PackedScene = load(LEVEL_SCENE) as PackedScene
	check(packed != null, "W1-L4 carrega para teste do registro central")
	if packed == null:
		_clear_save()
		return true
	var level: Node2D = packed.instantiate() as Node2D
	tree.root.add_child(level)
	await tree.physics_frame
	var player: BoltPlayer = level.get_node("Bolt") as BoltPlayer
	var goal: Area2D = level.get_node("Goal") as Area2D
	var record: NarrativeBeatTrigger = level.get_node("MemoryRecordTrigger") as NarrativeBeatTrigger
	var echo: NarrativeBeatTrigger = level.get_node("MemoryEchoTrigger") as NarrativeBeatTrigger
	var hud: Hud = level.get_node("Hud") as Hud
	(level.get_node("PatrolEnemyArchive") as Node).queue_free()
	(level.get_node("PatrolEnemyChamber") as Node).queue_free()
	check(player != null and goal != null and record != null and echo != null and hud != null,
		"jogador, saída, registro, segredo e HUD estão presentes")
	if player == null or goal == null or record == null or echo == null or hud == null:
		level.free()
		await tree.process_frame
		_clear_save()
		return true

	player.global_position = goal.global_position
	player.velocity = Vector2.ZERO
	await _step_physics(3)
	check(not CampaignProgress.is_level_completed("W1-L4"), "saída não conclui sem recuperar o registro central")
	check_eq(hud.get_node("%ProgressNotification").text, "REGISTRO CENTRAL NECESSÁRIO",
		"saída comunica a condição de conclusão ausente")

	player.global_position = echo.global_position
	player.velocity = Vector2.ZERO
	await _step_physics(3)
	check(level.has_recovered_secret_memory(), "rota opcional emite memória corrompida")
	check(echo.has_fired(), "evento secreto é one-shot")
	check_eq(hud.get_node("%ProgressNotification").text, "MEMÓRIA CORROMPIDA RECUPERADA",
		"HUD confirma a memória opcional")

	player.global_position = record.global_position
	player.velocity = Vector2.ZERO
	await _step_physics(3)
	check(level.has_recovered_record(), "arquivo holográfico emite o registro de preservação")
	check(record.has_fired(), "registro central é one-shot")
	check_eq(hud.get_node("%ProgressNotification").text, "REGISTRO DE PRESERVAÇÃO RECUPERADO",
		"HUD confirma o registro central")

	goal.body_entered.emit(player)
	check(CampaignProgress.is_level_completed("W1-L4"), "recuperar o registro libera a conclusão")
	check(hud.get_node("%ResultOverlay").visible, "conclusão apresenta o overlay de resultado")
	check_eq(hud.get_node("%ResultTitle").text, "Laboratório de Memórias concluído",
		"resultado identifica a fase canônica")
	tree.paused = false
	level.free()
	await tree.process_frame
	_clear_save()
	return true


func test_w1_l4_checkpoint_restores_vertical_progress_after_reentry() -> bool:
	_prepare_save()
	var packed: PackedScene = load(LEVEL_SCENE) as PackedScene
	check(packed != null, "W1-L4 carrega para teste de checkpoint")
	if packed == null:
		_clear_save()
		return true
	var level: Node2D = packed.instantiate() as Node2D
	tree.root.add_child(level)
	await tree.physics_frame
	var player: BoltPlayer = level.get_node("Bolt") as BoltPlayer
	var checkpoint: BoltCheckpoint = level.get_node("CheckpointChambers") as BoltCheckpoint
	check(player != null and checkpoint != null, "checkpoint das câmaras está presente")
	if player == null or checkpoint == null:
		level.free()
		await tree.process_frame
		_clear_save()
		return true
	player.global_position = checkpoint.global_position
	player.velocity = Vector2.ZERO
	await _step_physics(3)
	check(checkpoint.is_activated(), "contato físico ativa checkpoint das câmaras")
	check_eq(CampaignProgress.get_checkpoint_id("W1-L4"), "cybercore_w1_l4_chambers_checkpoint",
		"checkpoint das câmaras persiste com ID estável")
	level.free()
	await tree.process_frame

	level = packed.instantiate() as Node2D
	tree.root.add_child(level)
	await tree.physics_frame
	player = level.get_node("Bolt") as BoltPlayer
	checkpoint = level.get_node("CheckpointChambers") as BoltCheckpoint
	check(checkpoint.is_activated(), "checkpoint das câmaras restaura após reentrada")
	check(player.global_position.distance_to(checkpoint.get_respawn_position()) < 2.0,
		"BOLT reaparece no ponto vertical persistido")
	level.free()
	await tree.process_frame
	_clear_save()
	return true


func test_w1_l4_unlocks_after_w1_l3_and_main_menu_can_resume_it() -> bool:
	_prepare_save()
	check(CampaignProgress.start_new_campaign(), "campanha de teste inicia")
	check(CampaignProgress.mark_level_completed("W1-L1", "W1-L2"), "W1-L1 concluída")
	check(CampaignProgress.mark_level_completed("W1-L2", "W1-L3"), "W1-L2 concluída")
	check(CampaignProgress.mark_level_completed("W1-L3"), "W1-L3 concluída")
	tree.root.set_meta("campaign_selection_world_id", "W1")
	var phase_packed: PackedScene = load(PHASE_SELECTION_SCENE) as PackedScene
	check(phase_packed != null, "seleção de fases carrega")
	if phase_packed == null:
		tree.root.remove_meta("campaign_selection_world_id")
		_clear_save()
		return true
	var phase_screen: Node = phase_packed.instantiate()
	tree.root.add_child(phase_screen)
	await tree.process_frame
	var grid: GridContainer = phase_screen.find_child("PhaseGrid", true, false) as GridContainer
	check(grid != null and grid.get_child_count() == 6, "Cybercore apresenta seis cards")
	if grid != null and grid.get_child_count() == 6:
		var w1_l4: Button = grid.get_child(3) as Button
		check(w1_l4 != null and not w1_l4.disabled, "W1-L4 fica disponível após concluir W1-L3")
	phase_screen.free()
	await tree.process_frame
	if tree.root.has_meta("campaign_selection_world_id"):
		tree.root.remove_meta("campaign_selection_world_id")

	check(CampaignProgress.begin_level("W1-L4"), "save registra W1-L4 como fase atual")
	var menu_packed: PackedScene = load(MAIN_MENU_SCENE) as PackedScene
	check(menu_packed != null, "menu principal carrega")
	if menu_packed != null:
		var menu: Node = menu_packed.instantiate()
		tree.root.add_child(menu)
		await tree.process_frame
		var continue_button: Button = menu.get_node("%ContinueButton") as Button
		check(continue_button != null and not continue_button.disabled, "Continuar fica habilitado para W1-L4")
		check_eq(menu.call("_resolve_continue_path"), LEVEL_SCENE, "Continuar resolve a cena Laboratório de Memórias")
		menu.free()
		await tree.process_frame
	_clear_save()
	return true
