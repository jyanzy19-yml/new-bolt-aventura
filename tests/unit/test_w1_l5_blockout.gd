extends BoltTest
## Contratos do blockout provisório W1-L5. Não canoniza conteúdo ou tuning.

const LEVEL_SCENE: String = "res://scenes/campaign/cybercore_w1_l5.tscn"
const TEST_SAVE_PATH: String = "user://bolt_w1_l5_blockout_test.json"


func test_w1_l5_scene_composes_existing_gameplay_systems() -> bool:
	SaveSystem.storage_path_override = TEST_SAVE_PATH
	SaveSystem.delete_save()
	var packed: PackedScene = load(LEVEL_SCENE) as PackedScene
	check(packed != null, "cena W1-L5 carrega")
	if packed == null:
		return true

	var level: Node = packed.instantiate()
	tree.root.add_child(level)
	await tree.physics_frame

	var player: BoltPlayer = level.get_node("Bolt") as BoltPlayer
	var checkpoint: BoltCheckpoint = level.get_node("Checkpoint") as BoltCheckpoint
	var gate: TimedEnergyGate = level.get_node("EnergyGate") as TimedEnergyGate
	var enemy: CybercorePatrolEnemy = level.get_node("PatrolEnemy") as CybercorePatrolEnemy
	var moving_a: MovingPlatform = level.get_node("Geometry/MovingPlatformA") as MovingPlatform
	var moving_b: MovingPlatform = level.get_node("Geometry/MovingPlatformB") as MovingPlatform
	var observatory: PlatformBlock = level.get_node("Geometry/ObservatoryPlatform") as PlatformBlock
	check(player != null and checkpoint != null and gate != null and enemy != null, "BOLT, checkpoint, gate e inimigo instanciam")
	check(moving_a != null and moving_b != null, "duas plataformas móveis existentes instanciam")
	check(observatory != null, "rota opcional do observatório existe")
	check_eq(CampaignProgress.load_state().get("current_level_id"), "W1-L5", "entrada registra W1-L5 como destino de retomada")
	check(gate.is_active(), "janela começa com campo ativo")
	check(checkpoint.global_position.x < gate.global_position.x, "checkpoint fica antes do desafio temporal")
	check_eq(CampaignProgress.get_checkpoint_id("W1-L5"), "", "checkpoint não é persistido antes de ativação")
	level.free()
	SaveSystem.delete_save()
	SaveSystem.storage_path_override = ""
	await tree.process_frame
	return true


func test_w1_l5_checkpoint_and_completion_persist() -> bool:
	SaveSystem.storage_path_override = TEST_SAVE_PATH
	SaveSystem.delete_save()
	var packed: PackedScene = load(LEVEL_SCENE) as PackedScene
	check(packed != null, "cena W1-L5 carrega para teste de persistência")
	if packed == null:
		SaveSystem.storage_path_override = ""
		return true

	var level: Node = packed.instantiate()
	tree.root.add_child(level)
	await tree.physics_frame
	var player: BoltPlayer = level.get_node("Bolt") as BoltPlayer
	var checkpoint: BoltCheckpoint = level.get_node("Checkpoint") as BoltCheckpoint
	var goal: Area2D = level.get_node("Goal") as Area2D
	var hud: Hud = level.get_node("Hud") as Hud
	check(player != null and checkpoint != null and goal != null and hud != null, "W1-L5 possui fluxo de checkpoint e saída")
	player.global_position = checkpoint.global_position
	player.velocity = Vector2.ZERO
	for _tick in 3:
		await tree.physics_frame
	check(checkpoint.is_activated(), "contato físico ativa checkpoint")
	check_eq(CampaignProgress.get_checkpoint_id("W1-L5"), "cybercore_w1_l5_checkpoint", "checkpoint W1-L5 persiste com ID próprio")
	check(hud.get_node("%ProgressNotification").visible, "ativação do checkpoint apresenta feedback visual")
	check_eq(hud.get_node("%ProgressNotification").text, "CHECKPOINT ATIVADO", "notificação identifica o checkpoint")
	player.global_position = goal.global_position
	player.velocity = Vector2.ZERO
	for _tick in 3:
		await tree.physics_frame
		if hud.get_node("%ResultOverlay").visible:
			break
	check(hud.get_node("%ResultOverlay").visible, "contato com a saída conclui W1-L5")
	check(CampaignProgress.is_level_completed("W1-L5"), "conclusão W1-L5 fica persistida")
	check_eq(hud.get_node("%AgainButton").text, "JOGAR DE NOVO", "saída não aponta para fase futura ainda não integrada")
	tree.paused = false
	level.free()
	SaveSystem.delete_save()
	SaveSystem.storage_path_override = ""
	await tree.process_frame
	return true
