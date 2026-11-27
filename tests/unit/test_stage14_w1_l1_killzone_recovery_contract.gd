extends BoltTest
## Integra o contato físico com a KillZone de W1-L1 ao checkpoint de campanha persistido.

const LEVEL_SCENE: String = "res://scenes/campaign/cybercore_w1_l1.tscn"
const TEST_SAVE_PATH: String = "user://bolt_stage14_w1_l1_killzone_test.json"


func _step_physics(frames: int) -> void:
	for _frame in range(frames):
		await tree.physics_frame


func test_w1_l1_killzone_returns_player_to_persisted_checkpoint_once() -> bool:
	Actions.release_all_game_actions()
	tree.paused = false
	SaveSystem.storage_path_override = TEST_SAVE_PATH
	SaveSystem.delete_save()

	var packed: PackedScene = load(LEVEL_SCENE) as PackedScene
	check(packed != null, "cena real W1-L1 carrega para a regressão de queda")
	if packed == null:
		SaveSystem.storage_path_override = ""
		return true

	var level: Node = packed.instantiate()
	tree.root.add_child(level)
	await tree.physics_frame

	var player: BoltPlayer = level.get_node("Bolt") as BoltPlayer
	var checkpoint: BoltCheckpoint = level.get_node("Checkpoint") as BoltCheckpoint
	var kill_zone: Area2D = level.get_node("KillZone") as Area2D
	var hud: Hud = level.get_node("Hud") as Hud
	var health: BoltHealth = player.get_node("%Health") as BoltHealth
	var result_overlay: Control = hud.get_node("%ResultOverlay") as Control
	var expected_respawn: Vector2 = checkpoint.get_respawn_position()
	var respawn_events: Array[int] = [0]
	player.respawned.connect(func() -> void: respawn_events[0] += 1)

	check(checkpoint != null and kill_zone != null, "W1-L1 contém checkpoint e KillZone reais")
	check_eq(CampaignProgress.load_state().get("current_level_id"), "W1-L1", "entrada registra W1-L1 no progresso")
	check_eq(health.current_health, health.max_health, "BOLT inicia com vida íntegra")

	# Ativa o checkpoint pelo contato físico da Area2D, não pelo handler privado da fase.
	player.global_position = checkpoint.global_position
	player.velocity = Vector2.ZERO
	await _step_physics(3)
	check(checkpoint.is_activated(), "contato físico ativa o checkpoint de W1-L1")
	check_eq(CampaignProgress.get_checkpoint_id("W1-L1"), "cybercore_w1_l1_checkpoint",
		"ID estável do checkpoint fica persistido")
	check(hud.get_node("%ProgressNotification").visible, "HUD apresenta feedback da ativação")
	check_eq(hud.get_node("%ProgressNotification").text, "CHECKPOINT ATIVADO",
		"feedback identifica a ativação do checkpoint")

	check(player.take_damage(1, 1.0), "BOLT pode sofrer dano antes da queda")
	check_eq(health.current_health, health.max_health - 1, "dano reduz a vida antes do respawn")
	player.global_position = kill_zone.global_position
	player.velocity = Vector2.ZERO
	await _step_physics(3)

	check_eq(respawn_events[0], 1, "contato real com KillZone provoca exatamente um respawn")
	check(player.global_position.distance_to(expected_respawn) < 2.0,
		"queda retorna BOLT à posição do checkpoint persistido")
	check_eq(health.current_health, health.max_health, "respawn recupera a vida conforme o contrato atual")
	check(checkpoint.is_activated(), "checkpoint permanece ativo após a queda")
	check_eq(CampaignProgress.get_checkpoint_id("W1-L1"), "cybercore_w1_l1_checkpoint",
		"queda não apaga o ID persistido")
	check(not result_overlay.visible, "queda recuperável não abre o overlay terminal de derrota")
	check(not tree.paused, "queda recuperável não pausa a fase")
	await _step_physics(3)
	check_eq(respawn_events[0], 1, "após sair da KillZone não há respawn duplicado")

	tree.paused = false
	Actions.release_all_game_actions()
	level.free()
	SaveSystem.delete_save()
	SaveSystem.storage_path_override = ""
	await tree.process_frame
	return true
