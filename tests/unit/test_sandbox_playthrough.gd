extends BoltTest
## Percurso automatizado da sandbox de movimento: um "bot" com entrada sintética (mesmas ações
## lógicas dos botões touch) tem de ir da largada até o objetivo. Prova que a geometria é
## transponível com as habilidades implementadas (corrida, pulo, pulo duplo, dash). NÃO prova
## que o percurso é divertido, justo ou bem calibrado — apenas que não está quebrado.

const SANDBOX: String = "res://scenes/levels/sandbox/movement_sandbox.tscn"
const MAX_TICKS: int = 60 * 40  # 40 s de tempo de jogo

var _bolt: BoltPlayer
var _air_jump_used: bool = false
var _dash_used_this_air: bool = false
var _jump_hold_ticks: int = 0
var _takeoff_y: float = 0.0


func _action(action: StringName, pressed: bool) -> void:
	var event: InputEventAction = InputEventAction.new()
	event.action = action
	event.pressed = pressed
	event.strength = 1.0 if pressed else 0.0
	Input.parse_input_event(event)


func _tap(action: StringName) -> void:
	_action(action, true)
	_action(action, false)


## Pulo "segurado" como um jogador faria: um toque curto vira salto baixo (pulo variável).
func _hold_jump(ticks: int = 24) -> void:
	_action(Actions.JUMP, false)  # garante uma nova borda de pressionar (necessária p/ pulo aéreo)
	_action(Actions.JUMP, true)
	_jump_hold_ticks = ticks


func _ray(from: Vector2, to: Vector2) -> bool:
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(from, to, 1)
	return not _bolt.get_world_2d().direct_space_state.intersect_ray(query).is_empty()


func _ground_below(x_offset: float, depth: float) -> bool:
	var origin: Vector2 = _bolt.global_position + Vector2(x_offset, 18.0)
	return _ray(origin, origin + Vector2(0.0, depth))


func _bot_tick() -> void:
	if _jump_hold_ticks > 0:
		_jump_hold_ticks -= 1
		if _jump_hold_ticks == 0:
			_action(Actions.JUMP, false)
	if _bolt.is_on_floor():
		_air_jump_used = false
		_dash_used_this_air = false
		var wall_ahead: bool = _ray(_bolt.global_position + Vector2(0.0, 10.0), _bolt.global_position + Vector2(34.0, 10.0))
		# Salta rente à borda (como um jogador) para aproveitar todo o alcance do pulo.
		var ledge_ahead: bool = not _ground_below(14.0, 40.0)
		if wall_ahead or ledge_ahead:
			_takeoff_y = _bolt.global_position.y
			_hold_jump()
	else:
		# Pulo duplo e dash só TARDE: quando já desceu à altura de decolagem e ainda não há chão perto.
		var descending: bool = _bolt.velocity.y > 40.0
		var floor_soon: bool = _ground_below(0.0, 60.0) or _ground_below(30.0, 60.0)
		if descending and not floor_soon and _bolt.global_position.y > _takeoff_y - 30.0:
			if not _air_jump_used:
				_air_jump_used = true
				_hold_jump()
			elif not _dash_used_this_air:
				_dash_used_this_air = true
				_tap(Actions.DASH)


func test_bot_can_complete_the_sandbox() -> bool:
	Actions.release_all_game_actions()
	var packed: PackedScene = load(SANDBOX) as PackedScene
	var level: Node = packed.instantiate()
	tree.root.add_child(level)
	await tree.physics_frame
	await tree.physics_frame
	_bolt = level.get_node("%Bolt") as BoltPlayer
	var hud: Hud = level.get_node("%Hud") as Hud
	var result_overlay: Control = hud.get_node("%ResultOverlay") as Control
	var respawns: Array[int] = [0]
	_bolt.respawned.connect(func() -> void: respawns[0] += 1)
	respawns[0] = 0  # ignora o respawn inicial da cena
	_action(Actions.MOVE_RIGHT, true)
	var ticks: int = 0
	var furthest_x: float = _bolt.global_position.x
	while ticks < MAX_TICKS and not result_overlay.visible:
		_bot_tick()
		await tree.physics_frame
		furthest_x = maxf(furthest_x, _bolt.global_position.x)
		ticks += 1
	var reached: bool = result_overlay.visible
	_action(Actions.MOVE_RIGHT, false)
	check(reached, "o bot chegou ao objetivo (mais longe: x=%.0f após %d ticks, %d quedas)" % [furthest_x, ticks, respawns[0]])
	check_eq(respawns[0], 0, "sem quedas no vazio durante o percurso")
	# Limpeza: o resultado pausa a árvore.
	tree.paused = false
	Actions.release_all_game_actions()
	level.queue_free()
	await tree.process_frame
	return true
