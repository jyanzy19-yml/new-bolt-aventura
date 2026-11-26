extends BoltTest
## Movimento de BOLT em física real (headless). Valida o comportamento do controlador contra os
## parâmetros PROVISÓRIOS de BoltTuning; NÃO valida "sensação" nem desempenho em aparelho.

const BOLT_SCENE: String = "res://scenes/player/bolt.tscn"
const PLATFORM_SCENE: String = "res://scenes/world/platform_block.tscn"

var _root: Node2D
var _bolt: BoltPlayer


## Piso largo com topo em y=0; opcionalmente um piso curto (ledge) para testar coyote time.
func _setup(tuning_override: BoltTuning = null, ledge_only: bool = false) -> void:
	Actions.release_all_game_actions()
	_root = Node2D.new()
	tree.root.add_child(_root)
	var floor_block: PlatformBlock = (load(PLATFORM_SCENE) as PackedScene).instantiate() as PlatformBlock
	floor_block.size = Vector2(300.0, 64.0) if ledge_only else Vector2(6000.0, 64.0)
	floor_block.position = Vector2(-150.0, 0.0) if ledge_only else Vector2(-3000.0, 0.0)
	_root.add_child(floor_block)
	_bolt = (load(BOLT_SCENE) as PackedScene).instantiate() as BoltPlayer
	if tuning_override != null:
		_bolt.tuning = tuning_override
	_root.add_child(_bolt)
	_bolt.global_position = Vector2(0.0, -20.0)
	await _frames(20)  # assenta no chão


func _teardown() -> void:
	Actions.release_all_game_actions()
	_root.queue_free()
	await tree.process_frame


func _frames(count: int) -> void:
	for i in count:
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
	Input.parse_input_event(event)


## Mantém `action` pressionada por `frames` ticks e acompanha a menor posição Y (ápice).
func _hold_and_track_apex(action: StringName, frames: int) -> float:
	var apex: float = _bolt.global_position.y
	_press(action)
	for i in frames:
		await tree.physics_frame
		apex = minf(apex, _bolt.global_position.y)
	_release(action)
	return apex


func _track_apex_for(frames: int) -> float:
	var apex: float = _bolt.global_position.y
	for i in frames:
		await tree.physics_frame
		apex = minf(apex, _bolt.global_position.y)
	return apex


## Menor velocidade vertical (mais "para cima") observada nos próximos `frames` ticks.
## Observar vários ticks é necessário: `Input.parse_input_event` só é entregue no quadro seguinte,
## então o efeito de um pressionamento aparece 1–2 ticks depois.
func _min_vy_over(frames: int) -> float:
	var lowest: float = _bolt.velocity.y
	for i in frames:
		await tree.physics_frame
		lowest = minf(lowest, _bolt.velocity.y)
	return lowest


func _tuning_copy() -> BoltTuning:
	return (load("res://resources/player/bolt_tuning_provisional.tres") as BoltTuning).duplicate() as BoltTuning


func test_lands_and_stays_grounded() -> bool:
	await _setup()
	check_eq(_bolt.state, BoltPlayer.State.GROUNDED, "estado GROUNDED após assentar")
	check(_bolt.is_on_floor(), "is_on_floor verdadeiro")
	check_near(_bolt.global_position.y, -20.0, 1.0, "apoiado no piso (centro a 20 px do topo)")
	await _teardown()
	return true


func test_full_jump_reaches_configured_height() -> bool:
	await _setup()
	var start_y: float = _bolt.global_position.y
	var apex: float = await _hold_and_track_apex(Actions.JUMP, 40)
	var height: float = start_y - apex
	# Integração discreta a 60 Hz: tolerância de 10% sobre a altura configurada.
	check_near(height, _bolt.tuning.jump_height, _bolt.tuning.jump_height * 0.10, "altura do pulo completo")
	await _teardown()
	return true


func test_variable_jump_tap_is_lower_than_hold() -> bool:
	await _setup()
	var start_y: float = _bolt.global_position.y
	# Toque curto: pressiona por 2 ticks e solta.
	var tap_apex: float = await _hold_and_track_apex(Actions.JUMP, 2)
	tap_apex = minf(tap_apex, await _track_apex_for(40))
	var tap_height: float = start_y - tap_apex
	await _frames(60)  # pousa
	var hold_apex: float = await _hold_and_track_apex(Actions.JUMP, 40)
	var hold_height: float = start_y - hold_apex
	check(tap_height > 8.0, "o toque curto ainda salta (altura %.1f)" % tap_height)
	check(tap_height < hold_height * 0.6, "toque curto bem menor que o pulo completo (%.1f vs %.1f)" % [tap_height, hold_height])
	await _teardown()
	return true


func test_tap_shorter_than_one_physics_tick_still_jumps() -> bool:
	await _setup()
	# Pressiona e solta SEM nenhum tick de física no meio (queda de FPS): o buffer deve guardar.
	_press(Actions.JUMP)
	_release(Actions.JUMP)
	var start_y: float = _bolt.global_position.y
	var apex: float = await _track_apex_for(30)
	check(start_y - apex > 8.0, "BOLT saltou apesar de o botão já estar solto (%.1f px)" % (start_y - apex))
	await _teardown()
	return true


func test_double_jump_adds_height_and_third_press_does_nothing() -> bool:
	await _setup()
	var start_y: float = _bolt.global_position.y
	await _hold_and_track_apex(Actions.JUMP, 3)
	await _frames(10)
	var after_first: float = _bolt.global_position.y
	_press(Actions.JUMP)  # segundo pulo, no ar
	var apex2: float = await _track_apex_for(30)
	check(apex2 < after_first - 20.0, "o pulo aéreo ganha altura extra")
	check(start_y - apex2 > _bolt.tuning.jump_height * 0.9, "somando os dois pulos passa da altura de um pulo")
	_release(Actions.JUMP)
	# Terceiro pressionamento: sem pulos aéreos restantes, nada pode impulsionar para cima.
	await _frames(2)
	var vy_before: float = _bolt.velocity.y
	_press(Actions.JUMP)
	_release(Actions.JUMP)
	var lowest: float = await _min_vy_over(6)
	check(lowest >= vy_before - 1.0, "terceiro pressionamento não impulsiona para cima (min vy %.1f, antes %.1f)" % [lowest, vy_before])
	await _teardown()
	return true


func _walk_off_ledge() -> void:
	_bolt.global_position = Vector2(140.0, -20.0)  # perto da borda direita (x=150) do piso curto
	_press(Actions.MOVE_RIGHT)
	var frames: int = 0
	while _bolt.is_on_floor() and frames < 90:
		await tree.physics_frame
		frames += 1
	_release(Actions.MOVE_RIGHT)


func test_coyote_time_allows_late_ground_jump() -> bool:
	var tuning: BoltTuning = _tuning_copy()
	tuning.air_jumps = 0  # isola o coyote: sem pulo aéreo, só o coyote permite saltar
	await _setup(tuning, true)
	await _walk_off_ledge()
	check(not _bolt.is_on_floor(), "BOLT saiu da borda")
	# Pressiona 1 tick após sair da borda; o pulo é efetivado ≤2 ticks depois (≈0,05 s < 0,10 s de coyote).
	await _frames(1)
	_press(Actions.JUMP)
	var lowest: float = await _min_vy_over(5)
	check(lowest < -300.0, "pulo logo após sair da borda funciona com coyote (min vy %.1f)" % lowest)
	_release(Actions.JUMP)
	await _teardown()
	return true


func test_no_jump_after_coyote_expires_without_air_jumps() -> bool:
	var tuning: BoltTuning = _tuning_copy()
	tuning.air_jumps = 0
	await _setup(tuning, true)
	await _walk_off_ledge()
	await _frames(14)  # ≈0,23 s: bem além do coyote (0,10 s), ainda em queda livre
	check(not _bolt.is_on_floor(), "ainda no ar")
	var vy_before: float = _bolt.velocity.y
	_press(Actions.JUMP)
	_release(Actions.JUMP)
	var lowest: float = await _min_vy_over(6)
	check(lowest >= vy_before - 1.0, "sem coyote e sem pulo aéreo nada impulsiona (min vy %.1f, antes %.1f)" % [lowest, vy_before])
	await _teardown()
	return true


func test_jump_buffer_triggers_on_landing_and_expires_when_too_early() -> bool:
	var tuning: BoltTuning = _tuning_copy()
	tuning.air_jumps = 0  # sem pulo aéreo: só o buffer pode produzir um pulo ao pousar
	# Queda livre a partir do repouso com gravidade de queda g = 1400 × 1,5 = 2100 px/s²:
	# distância em t ticks = ½·g·(t/60)². Teleportar deixa o coyote ativo por 6 ticks, então o
	# pressionamento só ocorre depois de 12 ticks para que NÃO seja um pulo coyote.
	# (a) Cai 84 px (≈17 ticks): pressiona no tick 12 → pousa ≈5 ticks (0,083 s) depois, dentro
	#     da janela de 0,12 s → deve pular ao pousar.
	await _setup(tuning)
	_bolt.global_position = Vector2(0.0, -20.0 - 84.0)
	await _frames(12)
	check(not _bolt.is_on_floor(), "(a) pré-condição: ainda no ar quando pressiona")
	_press(Actions.JUMP)
	_release(Actions.JUMP)
	var lowest: float = await _min_vy_over(30)
	# Toque já solto => salto curto (variável): ≈ -0,45 × 560 px/s; basta distinguir de "sem pulo".
	check(lowest < -150.0, "(a) pressionamento pouco antes de pousar vira pulo (min vy %.1f)" % lowest)
	await _teardown()
	# (b) Cai 400 px (≈37 ticks): pressiona no tick 12 → pousa ≈25 ticks (0,42 s) depois, fora
	#     da janela → o pressionamento expira e NÃO pode gerar pulo.
	await _setup(tuning)
	_bolt.global_position = Vector2(0.0, -20.0 - 400.0)
	await _frames(12)
	check(not _bolt.is_on_floor(), "(b) pré-condição: ainda no ar quando pressiona")
	_press(Actions.JUMP)
	_release(Actions.JUMP)
	lowest = await _min_vy_over(50)
	check(lowest >= -1.0, "(b) pressionamento cedo demais expira e não gera pulo (min vy %.1f)" % lowest)
	await _teardown()
	return true


func test_dash_moves_fast_then_cools_down() -> bool:
	await _setup()
	var start_x: float = _bolt.global_position.x
	_press(Actions.DASH)
	_release(Actions.DASH)
	await tree.physics_frame
	await tree.physics_frame
	check_eq(_bolt.state, BoltPlayer.State.DASHING, "entrou em DASHING")
	check_near(absf(_bolt.velocity.x), _bolt.tuning.dash_speed, 1.0, "velocidade do dash")
	await _frames(int(_bolt.tuning.dash_duration * 60.0) + 4)
	check(_bolt.state != BoltPlayer.State.DASHING, "dash terminou")
	var travelled: float = _bolt.global_position.x - start_x
	check(travelled > _bolt.tuning.dash_speed * _bolt.tuning.dash_duration * 0.8, "percorreu a distância esperada (%.1f px)" % travelled)
	# Cooldown: novo dash imediatamente é recusado.
	_press(Actions.DASH)
	_release(Actions.DASH)
	await _frames(2)
	check(_bolt.state != BoltPlayer.State.DASHING, "dash em cooldown é recusado")
	await _frames(int(_bolt.tuning.dash_cooldown * 60.0) + 4)
	_press(Actions.DASH)
	_release(Actions.DASH)
	await _frames(2)
	check_eq(_bolt.state, BoltPlayer.State.DASHING, "dash disponível após o cooldown")
	await _teardown()
	return true


func test_air_dash_only_once_until_landing() -> bool:
	var tuning: BoltTuning = _tuning_copy()
	tuning.dash_cooldown = 0.10  # cooldown curto: isola a regra "um dash aéreo por salto"
	tuning.dash_duration = 0.10
	await _setup(tuning)
	_press(Actions.JUMP)
	await _frames(14)  # subindo, bem acima do chão
	check(not _bolt.is_on_floor(), "pré-condição: no ar")
	_press(Actions.DASH)
	_release(Actions.DASH)
	var dashed: bool = false
	for i in 6:
		await tree.physics_frame
		dashed = dashed or _bolt.state == BoltPlayer.State.DASHING
	check(dashed, "primeiro dash aéreo acontece")
	await _frames(10)  # cooldown (0,10 s) já passou
	_release(Actions.JUMP)
	if _bolt.is_on_floor():
		check(false, "pré-condição: ainda no ar para a segunda tentativa")
	else:
		_press(Actions.DASH)
		_release(Actions.DASH)
		var second: bool = false
		for i in 6:
			await tree.physics_frame
			second = second or _bolt.state == BoltPlayer.State.DASHING
		check(not second, "segundo dash aéreo é recusado antes de pousar")
	# Após pousar, o dash volta a ficar disponível.
	var guard: int = 0
	while not _bolt.is_on_floor() and guard < 120:
		await tree.physics_frame
		guard += 1
	await _frames(8)
	_press(Actions.DASH)
	_release(Actions.DASH)
	var third: bool = false
	for i in 6:
		await tree.physics_frame
		third = third or _bolt.state == BoltPlayer.State.DASHING
	check(third, "dash volta a funcionar depois de pousar")
	await _teardown()
	return true


func test_respawn_clears_transient_state() -> bool:
	await _setup()
	_press(Actions.DASH)
	_release(Actions.DASH)
	await _frames(2)
	_bolt.respawn(Vector2(200.0, -20.0))
	check_eq(_bolt.velocity, Vector2.ZERO, "velocidade zerada")
	check_eq(_bolt.state, BoltPlayer.State.GROUNDED, "estado reiniciado")
	check_near(_bolt.global_position.x, 200.0, 0.01, "posição aplicada")
	await _teardown()
	return true
