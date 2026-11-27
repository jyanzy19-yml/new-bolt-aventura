extends BoltTest
## Regressões de geometria e física para plataformas unidirecionais.

const PLATFORM_SCENE: String = "res://scenes/world/one_way_platform.tscn"
const SOLID_PLATFORM_SCENE: String = "res://scenes/world/platform_block.tscn"
const PLAYER_SCENE: String = "res://scenes/player/bolt.tscn"


func _step_physics(frames: int) -> void:
	for _frame in range(frames):
		await tree.physics_frame


func _send_action(action: StringName, pressed: bool) -> void:
	var event: InputEventAction = InputEventAction.new()
	event.action = action
	event.pressed = pressed
	event.strength = 1.0 if pressed else 0.0
	Input.parse_input_event(event)


func test_one_way_platform_configures_upward_pass_through() -> bool:
	var packed: PackedScene = load(PLATFORM_SCENE) as PackedScene
	check(packed != null, "cena OneWayPlatform carrega")
	if packed == null:
		return true

	var platform: OneWayPlatform = packed.instantiate() as OneWayPlatform
	platform.size = Vector2(180.0, 20.0)
	platform.one_way_margin = 3.5
	tree.root.add_child(platform)
	await tree.process_frame

	var shape: CollisionShape2D = platform.get_child(0) as CollisionShape2D
	check(shape != null, "shape de colisão presente")
	if shape != null:
		var rectangle: RectangleShape2D = shape.shape as RectangleShape2D
		check(rectangle != null, "shape de colisão é retangular")
		if rectangle != null:
			check_eq(rectangle.size, Vector2(180.0, 20.0), "dimensões da colisão acompanham a geometria visual")
		check_eq(shape.position, Vector2(90.0, 10.0), "shape centralizada na origem superior esquerda")
		check(shape.one_way_collision, "colisão unidirecional habilitada")
		check_eq(shape.one_way_collision_direction, Vector2.DOWN, "direção de bloqueio é para baixo")
		check_near(shape.one_way_collision_margin, 3.5, 0.01, "margem unidirecional configurada")

	platform.queue_free()
	await tree.process_frame
	return true


func test_character_jumps_through_from_below_and_lands_from_above() -> bool:
	Actions.release_all_game_actions()
	var platform_packed: PackedScene = load(PLATFORM_SCENE) as PackedScene
	var solid_packed: PackedScene = load(SOLID_PLATFORM_SCENE) as PackedScene
	var player_packed: PackedScene = load(PLAYER_SCENE) as PackedScene
	check(platform_packed != null, "plataforma unidirecional carrega")
	check(solid_packed != null, "piso sólido carrega")
	check(player_packed != null, "BOLT carrega")
	if platform_packed == null or solid_packed == null or player_packed == null:
		return true

	var root: Node2D = Node2D.new()
	tree.root.add_child(root)

	var floor_block: PlatformBlock = solid_packed.instantiate() as PlatformBlock
	floor_block.size = Vector2(600.0, 32.0)
	floor_block.position = Vector2(-300.0, 220.0)
	root.add_child(floor_block)

	var platform: OneWayPlatform = platform_packed.instantiate() as OneWayPlatform
	platform.position = Vector2(0.0, 120.0)
	platform.size = Vector2(220.0, 24.0)
	root.add_child(platform)

	var player: BoltPlayer = player_packed.instantiate() as BoltPlayer
	player.position = Vector2(100.0, 200.0)
	root.add_child(player)
	await _step_physics(20)
	check(player.is_on_floor(), "BOLT inicia apoiado no piso sólido inferior")

	_send_action(Actions.JUMP, true)
	var apex_y: float = player.global_position.y
	for _tick in 30:
		await tree.physics_frame
		apex_y = minf(apex_y, player.global_position.y)
	_send_action(Actions.JUMP, false)
	check(apex_y < 95.0, "BOLT atravessa a plataforma ao subir (ápice y=%.2f)" % apex_y)

	await _step_physics(90)
	check(player.is_on_floor(), "BOLT aterrissa na face superior após atravessar por baixo")
	check_near(player.global_position.y, 100.0, 2.0, "BOLT repousa acima da plataforma unidirecional")

	Actions.release_all_game_actions()
	root.queue_free()
	await tree.process_frame
	return true
