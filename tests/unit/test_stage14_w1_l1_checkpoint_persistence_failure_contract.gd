extends BoltTest
## Garante que a sessão mantém o checkpoint local quando o domínio persistido é incompatível.

const LEVEL_SCENE: String = "res://scenes/campaign/cybercore_w1_l1.tscn"
const TEST_SAVE_PATH: String = "user://bolt_stage14_w1_l1_checkpoint_failure_test.json"


func _step_physics(frames: int) -> void:
	for _frame in range(frames):
		await tree.physics_frame


func test_w1_l1_uses_session_checkpoint_when_campaign_persistence_fails() -> bool:
	Actions.release_all_game_actions()
	tree.paused = false
	SaveSystem.storage_path_override = TEST_SAVE_PATH
	SaveSystem.delete_save()

	# Um schema de domínio futuro é válido como payload físico, mas não pode ser
	# interpretado nem sobrescrito pelo CampaignProgress v1.
	var future_progress: Dictionary = {
		"campaign_id": "main",
		"schema_version": 999,
		"current_level_id": "W1-L1",
		"active_checkpoint_id": "",
		"completed_level_ids": [],
	}
	check(SaveSystem.save_payload({"campaign_progress": future_progress}),
		"fixture grava domínio de campanha com schema futuro")

	var packed: PackedScene = load(LEVEL_SCENE) as PackedScene
	check(packed != null, "cena real W1-L1 carrega para teste de fallback local")
	if packed == null:
		return true

	var level: Node = packed.instantiate()
	tree.root.add_child(level)
	await tree.physics_frame

	var player: BoltPlayer = level.get_node("Bolt") as BoltPlayer
	var checkpoint: BoltCheckpoint = level.get_node("Checkpoint") as BoltCheckpoint
	var kill_zone: Area2D = level.get_node("KillZone") as Area2D
	var hud: Hud = level.get_node("Hud") as Hud
	var health: BoltHealth = player.get_node("%Health") as BoltHealth
	var expected_respawn: Vector2 = checkpoint.get_respawn_position()

	check_eq(CampaignProgress.last_error, "unsupported_progress_schema",
		"W1-L1 identifica a incompatibilidade sem normalizar o domínio")
	check(not checkpoint.is_activated(), "checkpoint não aparece ativo antes do contato físico")

	# O contato físico atualiza primeiro o destino transitório da sessão.
	player.global_position = checkpoint.global_position
	player.velocity = Vector2.ZERO
	await _step_physics(3)

	check(checkpoint.is_activated(), "contato físico ativa o checkpoint local")
	check(hud.get_node("%ProgressNotification").visible,
		"HUD mantém feedback mesmo quando a persistência falha")
	check_eq(hud.get_node("%ProgressNotification").text, "CHECKPOINT ATIVADO",
		"feedback do checkpoint permanece consistente")
	check_eq(CampaignProgress.last_error, "unsupported_progress_schema",
		"falha de persistência permanece diagnosticada")

	var preserved_payload: Dictionary = SaveSystem.load_payload()
	var preserved_progress: Dictionary = preserved_payload.get("campaign_progress", {})
	check_eq(preserved_progress.get("schema_version"), 999,
		"falha não sobrescreve o schema de campanha desconhecido")
	check_eq(preserved_progress.get("active_checkpoint_id"), "",
		"falha não simula persistência de checkpoint inexistente")

	check(player.take_damage(1, 1.0), "BOLT recebe dano antes da queda")
	player.global_position = kill_zone.global_position
	player.velocity = Vector2.ZERO
	await _step_physics(3)

	check(player.global_position.distance_to(expected_respawn) < 2.0,
		"KillZone usa o checkpoint transitório desta sessão como fallback")
	check_eq(health.current_health, health.max_health,
		"fallback local preserva a recuperação de vida do respawn")
	check(checkpoint.is_activated(), "checkpoint local continua ativo após a recuperação")
	check(not hud.get_node("%ResultOverlay").visible,
		"falha de save não converte queda recuperável em derrota terminal")
	check(not tree.paused, "falha de save não pausa a fase")

	tree.paused = false
	Actions.release_all_game_actions()
	level.free()
	SaveSystem.delete_save()
	SaveSystem.storage_path_override = ""
	await tree.process_frame
	return true
