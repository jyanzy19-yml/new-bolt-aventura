extends BoltTest
## Regressões para movimento determinístico e transporte via AnimatableBody2D.


const PLATFORM_SCENE: String = "res://scenes/world/moving_platform.tscn"
const PLAYER_SCENE: String = "res://scenes/player/bolt.tscn"


func _step_physics(frames: int) -> void:
	for _frame in range(frames):
		await tree.physics_frame


func _new_platform() -> Node:
	var packed: PackedScene = load(PLATFORM_SCENE) as PackedScene
	check(packed != null, "cena MovingPlatform carrega")
	if packed == null:
		return null
	return packed.instantiate()


func test_platform_uses_animatable_body_and_world_collision() -> bool:
	var platform: Node = _new_platform()
	if platform == null:
		return true
	tree.root.add_child(platform)
	await tree.process_frame
	check(platform is AnimatableBody2D, "plataforma usa AnimatableBody2D")
	check(platform.sync_to_physics, "movimento sincronizado à física")
	check_eq(platform.collision_layer, 1, "plataforma pertence à layer world")
	check_eq(platform.collision_mask, 0, "plataforma não consulta layers desnecessárias")
	var shape: CollisionShape2D = platform.get_node("CollisionShape2D") as CollisionShape2D
	check(shape != null, "shape de colisão criado")
	if shape != null:
		var rectangle: RectangleShape2D = shape.shape as RectangleShape2D
		check(rectangle != null, "shape retangular")
		if rectangle != null:
			check_eq(rectangle.size, Vector2(160.0, 24.0), "shape corresponde ao tamanho visual")
		check_eq(shape.position, Vector2(80.0, 12.0), "shape centralizada na origem superior esquerda")
	platform.queue_free()
	await tree.process_frame
	return true


func test_platform_travels_ping_pong_and_waits_at_endpoints() -> bool:
	var platform: Node = _new_platform()
	if platform == null:
		return true
	platform.position = Vector2(100.0, 200.0)
	platform.travel_offset = Vector2(120.0, 0.0)
	platform.travel_duration = 0.5
	platform.endpoint_pause = 0.2
	tree.root.add_child(platform)
	await _step_physics(36)
	check_near(platform.position.x, 220.0, 4.0, "alcança endpoint após duração configurada")
	await _step_physics(6)
	check_near(platform.position.x, 220.0, 4.0, "permanece no endpoint durante espera")
	await _step_physics(12)
	check(platform.position.x < 216.0, "inverte direção após a espera")
	platform.queue_free()
	await tree.process_frame
	return true


func test_platform_carries_characterbody2d_on_top_surface() -> bool:
	var platform: Node = _new_platform()
	var player_packed: PackedScene = load(PLAYER_SCENE) as PackedScene
	check(player_packed != null, "cena de BOLT carrega")
	if platform == null or player_packed == null:
		if platform != null:
			platform.free()
		return true

	platform.position = Vector2(0.0, 120.0)
	platform.size = Vector2(200.0, 24.0)
	platform.travel_offset = Vector2(120.0, 0.0)
	platform.travel_duration = 2.0
	platform.endpoint_pause = 0.0
	var player: CharacterBody2D = player_packed.instantiate() as CharacterBody2D
	player.position = Vector2(80.0, 90.0)
	tree.root.add_child(platform)
	tree.root.add_child(player)
	await _step_physics(15)
	check(player.is_on_floor(), "BOLT aterrissa na plataforma móvel")
	var platform_start_x: float = platform.position.x
	var player_start_x: float = player.position.x
	await _step_physics(30)
	var platform_delta: float = platform.position.x - platform_start_x
	var player_delta: float = player.position.x - player_start_x
	check(platform_delta > 20.0 and platform_delta < 40.0, "plataforma percorre distância esperada")
	check(player_delta > 15.0 and player_delta < 40.0, "BOLT é transportado pela velocidade da plataforma")
	platform.queue_free()
	player.queue_free()
	await tree.process_frame
	return true


func test_platform_respects_scene_tree_pause() -> bool:
	var platform: Node = _new_platform()
	if platform == null:
		return true
	platform.position = Vector2.ZERO
	platform.travel_offset = Vector2(120.0, 0.0)
	platform.travel_duration = 1.0
	platform.endpoint_pause = 0.0
	tree.root.add_child(platform)
	await _step_physics(6)
	var before_pause: Vector2 = platform.position
	var was_paused: bool = tree.paused
	tree.paused = true
	await _step_physics(12)
	check_eq(platform.position, before_pause, "plataforma para quando a SceneTree pausa")
	tree.paused = was_paused
	await _step_physics(6)
	check(platform.position.x > before_pause.x, "plataforma retoma após despausar")
	platform.queue_free()
	await tree.process_frame
	return true
