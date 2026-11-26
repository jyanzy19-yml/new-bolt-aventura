extends BoltTest
## Regressões para plataformas que permitem subir por baixo e aterrissar por cima.


const PLATFORM_SCENE: String = "res://scenes/world/one_way_platform.tscn"
const PLAYER_SCENE: String = "res://scenes/player/bolt.tscn"


func _step_physics(frames: int) -> void:
	for _frame in range(frames):
		await tree.physics_frame


func test_one_way_platform_configures_upward_pass_through() -> bool:
	var packed: PackedScene = load(PLATFORM_SCENE) as PackedScene
	check(packed != null, "cena OneWayPlatform carrega")
	if packed == null:
		return true
	var platform: OneWayPlatform = packed.instantiate() as OneWayPlatform
	tree.root.add_child(platform)
	await tree.process_frame
	var shape: CollisionShape2D = platform.get_child(0) as CollisionShape2D
	check(shape != null, "shape de colisão presente")
	if shape != null:
		check(shape.one_way_collision, "colisão unidirecional habilitada")
		check_eq(shape.one_way_collision_direction, Vector2.DOWN, "direção de bloqueio é para baixo")
		check_near(shape.one_way_collision_margin, 2.0, 0.01, "margem unidirecional configurada")
	platform.queue_free()
	await tree.process_frame
	return true


func test_character_passes_from_below_and_lands_from_above() -> bool:
	var platform_packed: PackedScene = load(PLATFORM_SCENE) as PackedScene
	var player_packed: PackedScene = load(PLAYER_SCENE) as PackedScene
	check(platform_packed != null, "plataforma carrega")
	check(player_packed != null, "BOLT carrega")
	if platform_packed == null or player_packed == null:
		return true

	var platform: OneWayPlatform = platform_packed.instantiate() as OneWayPlatform
	platform.position = Vector2(0.0, 120.0)
	platform.size = Vector2(220.0, 24.0)
	tree.root.add_child(platform)

	var landing_player: CharacterBody2D = player_packed.instantiate() as CharacterBody2D
	landing_player.position = Vector2(60.0, 80.0)
	tree.root.add_child(landing_player)
	await _step_physics(20)
	check(landing_player.is_on_floor(), "BOLT aterrissa na face superior")
	check_near(landing_player.position.y, 100.0, 3.0, "BOLT repousa acima da plataforma")

	var rising_player: CharacterBody2D = player_packed.instantiate() as CharacterBody2D
	rising_player.position = Vector2(150.0, 160.0)
	tree.root.add_child(rising_player)
	await tree.process_frame
	rising_player.velocity = Vector2(0.0, -600.0)
	Input.action_press(Actions.JUMP)
	await _step_physics(8)
	Input.action_release(Actions.JUMP)
	check(rising_player.position.y < 120.0, "BOLT atravessa a plataforma ao subir por baixo")
	check(not rising_player.is_on_floor(), "passagem ascendente não é tratada como aterrissagem")

	platform.queue_free()
	landing_player.queue_free()
	rising_player.queue_free()
	await tree.process_frame
	return true
