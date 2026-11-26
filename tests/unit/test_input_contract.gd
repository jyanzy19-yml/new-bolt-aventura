extends BoltTest
## Contrato de Input (SYS-004 — apenas a base): as ações lógicas existem e têm binding.


func test_all_logical_actions_exist() -> bool:
	check_eq(Actions.missing().size(), 0, "nenhuma ação obrigatória ausente")
	for action: StringName in Actions.ALL:
		check(InputMap.has_action(action), "ação existe: %s" % action)
		check(InputMap.action_get_events(action).size() > 0, "ação tem binding de desenvolvimento: %s" % action)
	return true


func test_release_all_game_actions_clears_pressed_state() -> bool:
	Input.action_press(Actions.MOVE_RIGHT)
	Input.action_press(Actions.JUMP)
	check(Input.is_action_pressed(Actions.MOVE_RIGHT), "pré-condição: move_right pressionada")
	Actions.release_all_game_actions()
	check(not Input.is_action_pressed(Actions.MOVE_RIGHT), "move_right solta")
	check(not Input.is_action_pressed(Actions.JUMP), "jump solta")
	return true


func test_touch_generated_actions_apply_immediately() -> bool:
	# Regressão: com entrada acumulada, parse_input_event atrasava o estado em 1 quadro.
	check_eq(Input.use_accumulated_input, false, "entrada sem acúmulo (SceneFlow)")
	var press: InputEventAction = InputEventAction.new()
	press.action = Actions.JUMP
	press.pressed = true
	press.strength = 1.0
	Input.parse_input_event(press)
	check(Input.is_action_pressed(Actions.JUMP), "ação pressionada no mesmo instante, sem esperar um quadro")
	Actions.release_all_game_actions()
	return true
