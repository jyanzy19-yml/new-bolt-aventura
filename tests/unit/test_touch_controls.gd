extends BoltTest
## Multitouch com eventos sintéticos (InputEventScreenTouch/Drag). Prova a lógica de rastreamento
## por dedo; NÃO prova latência nem comportamento real de digitalizador em aparelho Android.

const HUD_SCENE: String = "res://scenes/ui/hud.tscn"

var _hud: Hud
var _controls: TouchControls


func _setup() -> void:
	_hud = (load(HUD_SCENE) as PackedScene).instantiate() as Hud
	tree.root.add_child(_hud)
	await tree.process_frame
	_controls = _hud.get_node("%TouchControls") as TouchControls
	Actions.release_all_game_actions()


func _teardown() -> void:
	_controls.release_all()
	tree.paused = false
	_hud.queue_free()
	await tree.process_frame
	Actions.release_all_game_actions()


func _center(action: StringName) -> Vector2:
	return _controls.get_button(action).get_global_rect().get_center()


# Os eventos são entregues em coordenadas LOCAIS do viewport (push_input(..., true)): em aparelho o
# motor já converte a posição da tela para o espaço do viewport antes de chamar `_input`.
func _touch(index: int, position: Vector2, pressed: bool) -> void:
	var event: InputEventScreenTouch = InputEventScreenTouch.new()
	event.index = index
	event.position = position
	event.pressed = pressed
	tree.root.push_input(event, true)


func _drag(index: int, position: Vector2) -> void:
	var event: InputEventScreenDrag = InputEventScreenDrag.new()
	event.index = index
	event.position = position
	tree.root.push_input(event, true)


func test_two_fingers_hold_different_actions_independently() -> bool:
	await _setup()
	_touch(0, _center(Actions.MOVE_RIGHT), true)
	_touch(1, _center(Actions.JUMP), true)
	check(Input.is_action_pressed(Actions.MOVE_RIGHT), "dedo 0 segura move_right")
	check(Input.is_action_pressed(Actions.JUMP), "dedo 1 segura jump")
	_touch(1, _center(Actions.JUMP), false)
	check(not Input.is_action_pressed(Actions.JUMP), "soltar o dedo 1 solta jump")
	check(Input.is_action_pressed(Actions.MOVE_RIGHT), "move_right continua pressionada pelo dedo 0")
	_touch(0, _center(Actions.MOVE_RIGHT), false)
	check(not Input.is_action_pressed(Actions.MOVE_RIGHT), "soltar o dedo 0 solta move_right")
	await _teardown()
	return true


func test_three_simultaneous_actions() -> bool:
	await _setup()
	_touch(0, _center(Actions.MOVE_LEFT), true)
	_touch(1, _center(Actions.JUMP), true)
	_touch(2, _center(Actions.DASH), true)
	check(Input.is_action_pressed(Actions.MOVE_LEFT), "move_left")
	check(Input.is_action_pressed(Actions.JUMP), "jump")
	check(Input.is_action_pressed(Actions.DASH), "dash")
	await _teardown()
	return true


func test_two_fingers_on_same_button_release_only_when_both_lift() -> bool:
	await _setup()
	var c: Vector2 = _center(Actions.JUMP)
	_touch(0, c, true)
	_touch(1, c, true)
	_touch(0, c, false)
	check(Input.is_action_pressed(Actions.JUMP), "ainda pressionada: o dedo 1 segue nela")
	_touch(1, c, false)
	check(not Input.is_action_pressed(Actions.JUMP), "solta quando o último dedo sai")
	await _teardown()
	return true


func test_slide_between_direction_buttons_switches_direction() -> bool:
	await _setup()
	_touch(0, _center(Actions.MOVE_LEFT), true)
	check(Input.is_action_pressed(Actions.MOVE_LEFT), "começa na esquerda")
	_drag(0, _center(Actions.MOVE_RIGHT))
	check(not Input.is_action_pressed(Actions.MOVE_LEFT), "esquerda solta ao deslizar")
	check(Input.is_action_pressed(Actions.MOVE_RIGHT), "direita acionada sem levantar o dedo")
	_touch(0, _center(Actions.MOVE_RIGHT), false)
	check(not Input.is_action_pressed(Actions.MOVE_RIGHT), "solta ao levantar")
	await _teardown()
	return true


func test_dragging_off_a_non_slide_button_releases_it() -> bool:
	await _setup()
	_touch(0, _center(Actions.JUMP), true)
	_drag(0, Vector2(300, 100))  # longe de qualquer botão
	check(not Input.is_action_pressed(Actions.JUMP), "jump solta quando o dedo sai do botão")
	await _teardown()
	return true


func test_touch_far_from_any_button_does_nothing() -> bool:
	await _setup()
	_touch(0, Vector2(480, 200), true)
	for action: StringName in [Actions.MOVE_LEFT, Actions.MOVE_RIGHT, Actions.JUMP, Actions.DASH]:
		check(not Input.is_action_pressed(action), "nada pressionado: %s" % action)
	await _teardown()
	return true


func test_cancelled_touch_releases_action() -> bool:
	await _setup()
	_touch(0, _center(Actions.JUMP), true)
	var cancel: InputEventScreenTouch = InputEventScreenTouch.new()
	cancel.index = 0
	cancel.position = _center(Actions.JUMP)
	cancel.pressed = false
	cancel.canceled = true
	tree.root.push_input(cancel, true)
	check(not Input.is_action_pressed(Actions.JUMP), "toque cancelado solta a ação")
	await _teardown()
	return true


func test_pause_releases_everything_and_hides_controls() -> bool:
	await _setup()
	_touch(0, _center(Actions.MOVE_RIGHT), true)
	_touch(1, _center(Actions.JUMP), true)
	_hud.set_paused(true)
	check(tree.paused, "árvore pausada")
	check(not Input.is_action_pressed(Actions.MOVE_RIGHT), "move_right solta na pausa")
	check(not Input.is_action_pressed(Actions.JUMP), "jump solta na pausa")
	check(not _controls.visible, "controles ocultos na pausa")
	# Toque durante a pausa não pode acionar nada.
	_touch(2, _center(Actions.DASH), true)
	check(not Input.is_action_pressed(Actions.DASH), "toque em dash ignorado durante a pausa")
	_hud.set_paused(false)
	check(not tree.paused, "retomado")
	check(_controls.visible, "controles visíveis ao retomar")
	check(not Input.is_action_pressed(Actions.MOVE_RIGHT), "nada preso ao retomar")
	await _teardown()
	return true


func test_visual_state_follows_logical_state() -> bool:
	await _setup()
	var button: TouchButton = _controls.get_button(Actions.JUMP)
	check(not button.visual_pressed, "inicia sem destaque")
	_touch(0, _center(Actions.JUMP), true)
	_touch(1, _center(Actions.JUMP), true)
	_touch(0, _center(Actions.JUMP), false)
	check(button.visual_pressed, "destaque permanece enquanto um dedo segura")
	_touch(1, _center(Actions.JUMP), false)
	check(not button.visual_pressed, "destaque some quando todos soltam")
	await _teardown()
	return true
