extends BoltTest
## ActionBuffer: um pressionamento que começa e termina entre dois ticks de física não pode se
## perder (cenário de queda momentânea de FPS exigido por CLAUDE.md / docs/technical/02 §2).


func _make_buffer() -> ActionBuffer:
	var buffer: ActionBuffer = ActionBuffer.new()
	tree.root.add_child(buffer)
	return buffer


func _press_release(action: StringName) -> void:
	# Pressionar E soltar antes de qualquer tick de física.
	var down: InputEventAction = InputEventAction.new()
	down.action = action
	down.pressed = true
	tree.root.push_input(down, false)
	var up: InputEventAction = InputEventAction.new()
	up.action = action
	up.pressed = false
	tree.root.push_input(up, false)


func test_tap_released_before_next_tick_is_still_buffered() -> bool:
	var buffer: ActionBuffer = _make_buffer()
	_press_release(Actions.JUMP)
	check(not Input.is_action_pressed(Actions.JUMP), "pré-condição: o botão já foi solto")
	check(buffer.has_pending(Actions.JUMP), "o toque curto continua pendente no buffer")
	check(buffer.consume(Actions.JUMP), "consumido com sucesso uma vez")
	check(not buffer.consume(Actions.JUMP), "não pode ser consumido duas vezes")
	buffer.queue_free()
	return true


func test_press_expires_after_window() -> bool:
	var buffer: ActionBuffer = _make_buffer()
	_press_release(Actions.JUMP)
	# A janela é em tempo de jogo (ticks de física), não de relógio: 5 ticks = 0,083 s de jogo.
	for i in 5:
		await tree.physics_frame
	check(not buffer.has_pending(Actions.JUMP, 0.03), "fora de uma janela curta (0,03 s)")
	check(buffer.has_pending(Actions.JUMP, 5.0), "dentro de uma janela larga")
	buffer.clear()
	check(not buffer.has_pending(Actions.JUMP, 5.0), "clear() descarta pendências")
	buffer.queue_free()
	return true


func test_untracked_action_is_ignored() -> bool:
	var buffer: ActionBuffer = _make_buffer()
	_press_release(Actions.PAUSE)
	check(not buffer.has_pending(Actions.PAUSE), "ação não rastreada não é registrada")
	buffer.queue_free()
	return true


func test_window_is_game_time_not_wall_clock() -> bool:
	# Um quadro lento em tempo real (200 ms de relógio) NÃO pode expirar um toque se a simulação
	# avançou só 1 tick: o pressionamento ainda deve valer.
	var buffer: ActionBuffer = _make_buffer()
	_press_release(Actions.JUMP)
	await tree.physics_frame
	OS.delay_msec(200)
	check(buffer.has_pending(Actions.JUMP), "toque válido após 200 ms de relógio e 1 tick de jogo")
	buffer.queue_free()
	return true
