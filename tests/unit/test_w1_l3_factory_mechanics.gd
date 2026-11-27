extends BoltTest
## Regressões dos sistemas provisórios de esteira e prensa usados em W1-L3.

const PLAYER_SCENE: String = "res://scenes/player/bolt.tscn"
const CONVEYOR_SCENE: String = "res://scenes/world/conveyor_belt.tscn"
const PRESS_SCENE: String = "res://scenes/levels/industrial_press.tscn"


func _step_physics(frames: int) -> void:
	for _frame in range(frames):
		await tree.physics_frame


func test_conveyor_transfers_surface_velocity_to_bolt() -> bool:
	var conveyor_packed: PackedScene = load(CONVEYOR_SCENE) as PackedScene
	var player_packed: PackedScene = load(PLAYER_SCENE) as PackedScene
	check(conveyor_packed != null and player_packed != null, "esteira e BOLT carregam")
	if conveyor_packed == null or player_packed == null:
		return true

	var root: Node2D = Node2D.new()
	tree.root.add_child(root)
	var conveyor: ConveyorBelt = conveyor_packed.instantiate() as ConveyorBelt
	conveyor.size = Vector2(320.0, 32.0)
	conveyor.surface_speed = 120.0
	var player: BoltPlayer = player_packed.instantiate() as BoltPlayer
	player.damage_invulnerability = 0.0
	player.position = Vector2(64.0, -24.0)
	root.add_child(conveyor)
	root.add_child(player)
	await _step_physics(3)
	var initial_x: float = player.global_position.x
	await _step_physics(36)
	check(player.is_on_floor(), "BOLT permanece apoiado sobre a esteira")
	check(player.global_position.x > initial_x + 8.0, "esteira transfere velocidade positiva sem input horizontal")
	root.queue_free()
	await tree.process_frame
	return true


func test_industrial_press_warns_before_damage_and_recovers() -> bool:
	var press_packed: PackedScene = load(PRESS_SCENE) as PackedScene
	var player_packed: PackedScene = load(PLAYER_SCENE) as PackedScene
	check(press_packed != null and player_packed != null, "prensa e BOLT carregam")
	if press_packed == null or player_packed == null:
		return true

	var root: Node2D = Node2D.new()
	tree.root.add_child(root)
	var press: IndustrialPress = press_packed.instantiate() as IndustrialPress
	press.warning_duration = 0.12
	press.active_duration = 0.22
	press.recovery_duration = 0.5
	var player: BoltPlayer = player_packed.instantiate() as BoltPlayer
	player.damage_invulnerability = 0.0
	player.position = Vector2(0.0, -24.0)
	root.add_child(press)
	root.add_child(player)
	await _step_physics(2)
	var health: BoltHealth = player.get_node("%Health") as BoltHealth
	check_eq(press.get_state(), IndustrialPress.State.WARNING, "prensa inicia em aviso visual")
	check((press.get_node("%StrikeZone") as CollisionShape2D).disabled, "zona de golpe fica desativada durante o aviso")
	check_eq(health.current_health, 3, "aviso não causa dano")
	tree.paused = true
	for _frame in range(12):
		await tree.process_frame
	check_eq(press.get_state(), IndustrialPress.State.WARNING, "pausa congela o ciclo da prensa")
	tree.paused = false
	await _step_physics(10)
	check_eq(press.get_state(), IndustrialPress.State.ACTIVE, "prensa desce após o aviso")
	check(not (press.get_node("%StrikeZone") as CollisionShape2D).disabled, "zona de golpe só ativa na descida")
	check(health.current_health < 3, "contato durante a descida causa dano")
	await _step_physics(16)
	check_eq(press.get_state(), IndustrialPress.State.RECOVERY, "prensa entra em recuperação após o golpe")
	check((press.get_node("%StrikeZone") as CollisionShape2D).disabled, "zona de golpe desativa durante a recuperação")
	root.queue_free()
	await tree.process_frame
	return true
