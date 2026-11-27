extends BoltTest
## Regressões do ciclo temporal do campo energético de Cybercore.

const GATE_SCENE: String = "res://scenes/levels/timed_energy_gate.tscn"
const PLAYER_SCENE: String = "res://scenes/player/bolt.tscn"
const LEVEL_SCENE: String = "res://scenes/campaign/cybercore_w1_l2.tscn"
const TEST_SAVE_PATH: String = "user://bolt_w1_l2_progression_test.json"


func test_energy_gate_honors_inactive_initial_state() -> bool:
	var gate_scene: PackedScene = load(GATE_SCENE) as PackedScene
	var player_scene: PackedScene = load(PLAYER_SCENE) as PackedScene
	check(gate_scene != null and player_scene != null, "cena do campo e cena de BOLT carregam")
	if gate_scene == null or player_scene == null:
		return true

	var root: Node2D = Node2D.new()
	tree.root.add_child(root)
	var gate: TimedEnergyGate = gate_scene.instantiate() as TimedEnergyGate
	gate.initial_active = false
	gate.active_duration = 5.0
	gate.inactive_duration = 5.0
	var player: BoltPlayer = player_scene.instantiate() as BoltPlayer
	player.damage_invulnerability = 0.0
	player.position = Vector2(0.0, -24.0)
	root.add_child(gate)
	root.add_child(player)
	await tree.process_frame
	await tree.physics_frame

	check(not gate.is_active(), "campo respeita initial_active=false")
	check(not gate.monitoring, "Area2D não monitora durante estado inicial inativo")
	var visual: Polygon2D = gate.get_node("%Visual") as Polygon2D
	check_near(visual.color.a, 0.28, 0.01, "visual inicia com aparência inativa")
	var health: BoltHealth = player.get_node("%Health") as BoltHealth
	for _tick in range(3):
		await tree.physics_frame
	check_eq(health.current_health, 3, "campo inicialmente inativo não causa dano por contato")

	root.queue_free()
	await tree.process_frame
	return true


func test_energy_gate_cycles_and_only_damages_while_active() -> bool:
	var gate_scene: PackedScene = load(GATE_SCENE) as PackedScene
	var player_scene: PackedScene = load(PLAYER_SCENE) as PackedScene
	check(gate_scene != null and player_scene != null, "cena do campo e cena de BOLT carregam")
	if gate_scene == null or player_scene == null:
		return true

	var root: Node2D = Node2D.new()
	tree.root.add_child(root)
	var player: BoltPlayer = player_scene.instantiate() as BoltPlayer
	var gate: TimedEnergyGate = gate_scene.instantiate() as TimedEnergyGate
	player.damage_invulnerability = 0.0
	player.global_position = Vector2(300.0, -24.0)
	root.add_child(player)
	root.add_child(gate)
	await tree.physics_frame
	var health: BoltHealth = player.get_node("%Health") as BoltHealth
	check(gate.is_active(), "campo começa ativo")

	# Usa o sinal body_entered real da Area2D, não chama o handler diretamente.
	player.global_position = Vector2(0.0, -24.0)
	for _tick in range(3):
		await tree.physics_frame
	check_eq(health.current_health, 2, "contato físico com o campo ativo causa dano")

	player.respawn(Vector2(300.0, -24.0))
	gate.call("_on_cycle_timeout")
	await tree.physics_frame
	check(not gate.is_active(), "primeiro ciclo abre uma janela inativa")
	player.global_position = Vector2(0.0, -24.0)
	for _tick in range(3):
		await tree.physics_frame
	check_eq(health.current_health, 3, "contato físico com o campo inativo não causa dano")

	player.global_position = Vector2(300.0, -24.0)
	await tree.physics_frame
	gate.call("_on_cycle_timeout")
	await tree.physics_frame
	check(gate.is_active(), "segundo ciclo reativa o campo")
	player.global_position = Vector2(0.0, -24.0)
	for _tick in range(3):
		await tree.physics_frame
	check_eq(health.current_health, 2, "contato físico volta a causar dano após reativação")
	root.queue_free()
	await tree.process_frame
	return true


func test_w1_l2_registers_progress_checkpoint_and_completion() -> bool:
	SaveSystem.storage_path_override = TEST_SAVE_PATH
	SaveSystem.delete_save()
	var packed: PackedScene = load(LEVEL_SCENE) as PackedScene
	check(packed != null, "cena W1-L2 carrega")
	if packed == null:
		SaveSystem.storage_path_override = ""
		return true

	var level: Node = packed.instantiate()
	tree.root.add_child(level)
	await tree.physics_frame
	var player: BoltPlayer = level.get_node("Bolt") as BoltPlayer
	var gate: TimedEnergyGate = level.get_node("EnergyGate") as TimedEnergyGate
	var checkpoint: BoltCheckpoint = level.get_node("Checkpoint") as BoltCheckpoint
	var goal: Area2D = level.get_node("Goal") as Area2D
	var hud: Hud = level.get_node("Hud") as Hud
	var end_floor: PlatformBlock = level.get_node("Geometry/EndFloor") as PlatformBlock
	check(player != null and gate != null and checkpoint != null and goal != null and hud != null, "W1-L2 instancia os sistemas essenciais")
	check_eq(CampaignProgress.load_state().get("current_level_id"), "W1-L2", "entrada registra W1-L2 como destino de retomada")
	check(gate.is_active(), "campo energético está ativo na entrada")
	check(checkpoint.global_position.x >= end_floor.global_position.x and checkpoint.global_position.x <= end_floor.global_position.x + end_floor.size.x, "checkpoint fica sobre o piso final seguro")
	player.global_position = checkpoint.global_position
	player.velocity = Vector2.ZERO
	for _tick in range(3):
		await tree.physics_frame
	check(checkpoint.is_activated(), "checkpoint de W1-L2 pode ser ativado")
	check(hud.get_node("%ProgressNotification").visible, "ativação do checkpoint apresenta feedback visual")
	check_eq(hud.get_node("%ProgressNotification").text, "CHECKPOINT ATIVADO", "notificação identifica o checkpoint")
	check_eq(CampaignProgress.get_checkpoint_id("W1-L2"), "cybercore_w1_l2_checkpoint", "checkpoint de W1-L2 persiste com ID próprio")
	player.global_position = goal.global_position
	player.velocity = Vector2.ZERO
	for _tick in range(3):
		await tree.physics_frame
		if hud.get_node("%ResultOverlay").visible:
			break
	check(hud.get_node("%ResultOverlay").visible, "saída física conclui W1-L2")
	check(CampaignProgress.is_level_completed("W1-L2"), "conclusão de W1-L2 fica persistida")
	check_eq(hud.get_node("%AgainButton").text, "PRÓXIMA FASE", "conclusão de W1-L2 oferece entrada direta em W1-L3")
	check_eq(CampaignProgress.load_state().get("current_level_id"), "W1-L3", "conclusão de W1-L2 avança a retomada para W1-L3")
	tree.paused = false
	level.free()
	SaveSystem.delete_save()
	SaveSystem.storage_path_override = ""
	return true
