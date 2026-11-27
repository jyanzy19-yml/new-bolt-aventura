extends BoltTest
## Contratos observáveis de recuperação do estado transitório de movimentação.

const PLAYER_SCENE: String = "res://scenes/player/bolt.tscn"
const PLATFORM_SCENE: String = "res://scenes/world/platform_block.tscn"

var _root: Node2D
var _player: BoltPlayer


func _setup() -> void:
	Actions.release_all_game_actions()
	_root = Node2D.new()
	tree.root.add_child(_root)

	var floor_block: PlatformBlock = (load(PLATFORM_SCENE) as PackedScene).instantiate() as PlatformBlock
	floor_block.size = Vector2(6000.0, 64.0)
	floor_block.position = Vector2(-3000.0, 0.0)
	_root.add_child(floor_block)

	_player = (load(PLAYER_SCENE) as PackedScene).instantiate() as BoltPlayer
	_root.add_child(_player)
	_player.global_position = Vector2(0.0, -20.0)
	await _frames(20)


func _teardown() -> void:
	Actions.release_all_game_actions()
	_root.queue_free()
	await tree.process_frame


func _frames(count: int) -> void:
	for _i in count:
		await tree.physics_frame


func _press(action: StringName) -> void:
	var event: InputEventAction = InputEventAction.new()
	event.action = action
	event.pressed = true
	event.strength = 1.0
	Input.parse_input_event(event)


func _release(action: StringName) -> void:
	var event: InputEventAction = InputEventAction.new()
	event.action = action
	event.pressed = false
	event.strength = 0.0
	Input.parse_input_event(event)


func _tap(action: StringName) -> void:
	_press(action)
	_release(action)


func test_respawn_interrupts_ground_dash_and_clears_its_cooldown() -> bool:
	await _setup()
	_tap(Actions.DASH)
	await _frames(2)
	check_eq(_player.state, BoltPlayer.State.DASHING, "dash terrestre iniciou antes do respawn")

	_player.respawn(Vector2(200.0, -20.0))
	check_eq(_player.velocity, Vector2.ZERO, "respawn interrompe o deslocamento residual")
	check_eq(_player.state, BoltPlayer.State.GROUNDED, "respawn encerra o estado DASHING")
	await _frames(2)
	check(_player.is_on_floor(), "BOLT estabiliza no ponto de retorno sobre o piso")

	_tap(Actions.DASH)
	await _frames(2)
	check_eq(_player.state, BoltPlayer.State.DASHING, "dash terrestre fica disponível imediatamente após respawn")
	await _teardown()
	return true


func test_respawn_restores_air_dash_availability() -> bool:
	await _setup()
	_tap(Actions.JUMP)
	await _frames(14)
	check(not _player.is_on_floor(), "BOLT está no ar antes de consumir o dash aéreo")

	_tap(Actions.DASH)
	await _frames(2)
	check_eq(_player.state, BoltPlayer.State.DASHING, "primeiro dash aéreo iniciou")
	_player.respawn(Vector2(200.0, -160.0))
	await _frames(1)
	check(not _player.is_on_floor(), "ponto de retorno permanece no ar")

	_tap(Actions.DASH)
	await _frames(2)
	check_eq(_player.state, BoltPlayer.State.DASHING, "dash aéreo volta a ficar disponível após respawn no ar")
	await _teardown()
	return true


func test_respawn_restores_air_jump_budget() -> bool:
	await _setup()
	_tap(Actions.JUMP)
	await _frames(3)
	check(not _player.is_on_floor(), "primeiro salto deixou o piso")

	_tap(Actions.JUMP)
	await _frames(2)
	check(_player.velocity.y < 0.0, "salto aéreo inicial foi executado")

	_player.respawn(Vector2(200.0, -200.0))
	await _frames(1)
	check(not _player.is_on_floor(), "BOLT permanece no ar após reposicionamento")

	_tap(Actions.JUMP)
	await _frames(2)
	check(_player.velocity.y < 0.0, "orçamento de salto aéreo é restaurado no respawn")
	await _teardown()
	return true


func _tap_buffered(action: StringName) -> void:
	var down: InputEventAction = InputEventAction.new()
	down.action = action
	down.pressed = true
	tree.root.push_input(down, false)
	var up: InputEventAction = InputEventAction.new()
	up.action = action
	up.pressed = false
	tree.root.push_input(up, false)


func test_respawn_discards_pending_jump_and_dash_taps() -> bool:
	await _setup()
	var buffer: ActionBuffer = _player.get_node("%ActionBuffer") as ActionBuffer
	_tap_buffered(Actions.JUMP)
	_tap_buffered(Actions.DASH)
	check(buffer.has_pending(Actions.JUMP), "toque curto de salto está pendente antes do respawn")
	check(buffer.has_pending(Actions.DASH), "toque curto de dash está pendente antes do respawn")

	_player.respawn(Vector2(200.0, -20.0))
	check(not buffer.has_pending(Actions.JUMP), "respawn descarta salto antigo ainda não consumido")
	check(not buffer.has_pending(Actions.DASH), "respawn descarta dash antigo ainda não consumido")
	await _frames(2)
	check_eq(_player.state, BoltPlayer.State.GROUNDED, "comandos anteriores à morte não são executados após respawn")
	check(_player.is_on_floor(), "BOLT permanece no ponto de retorno sem salto residual")
	await _teardown()
	return true
