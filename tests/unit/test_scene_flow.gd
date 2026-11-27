extends BoltTest
## SceneFlow (contrato "Scene Flow → Loading"): destino inexistente, transição real e bloqueio
## de transições simultâneas. SceneFlow é um autoload; aqui é acessado pela raiz da árvore.

const MAIN_MENU: String = "res://scenes/ui/main_menu.tscn"


func _flow() -> Node:
	return tree.root.get_node_or_null("SceneFlow")


func test_scene_flow_processes_while_tree_is_paused() -> bool:
	var flow: Node = _flow()
	check(flow != null, "autoload SceneFlow presente")
	if flow == null:
		return true
	check_eq(flow.process_mode, Node.PROCESS_MODE_ALWAYS, "SceneFlow continua processando durante pausa")
	return true


func test_failed_transition_restores_previous_pause_state() -> bool:
	var flow: Node = _flow()
	check(flow != null, "autoload SceneFlow presente")
	if flow == null:
		return true
	var previous_pause: bool = tree.paused
	var previous_busy: bool = flow._busy
	var previous_target: String = flow._target_path
	var previous_was_paused: bool = flow._was_paused

	tree.paused = true
	flow._busy = true
	flow._target_path = "res://test_failure_from_unpaused_state.tscn"
	flow._was_paused = false
	flow._fail("test_failure")
	check(not tree.paused, "falha restaura estado anteriormente despausado")
	check(not flow.is_transitioning(), "falha encerra estado de transição")

	tree.paused = true
	flow._busy = true
	flow._target_path = "res://test_failure_from_paused_state.tscn"
	flow._was_paused = true
	flow._fail("test_failure")
	check(tree.paused, "falha preserva estado anteriormente pausado")
	check(not flow.is_transitioning(), "segunda falha encerra estado de transição")

	tree.paused = previous_pause
	flow._busy = previous_busy
	flow._target_path = previous_target
	flow._was_paused = previous_was_paused
	return true


func test_application_pause_releases_held_game_actions() -> bool:
	var flow: Node = _flow()
	check(flow != null, "autoload SceneFlow presente")
	if flow == null:
		return true
	Input.action_press(Actions.JUMP)
	check(Input.is_action_pressed(Actions.JUMP), "jump lógico está pressionado antes da suspensão")
	flow.notification(Node.NOTIFICATION_APPLICATION_PAUSED)
	check(not Input.is_action_pressed(Actions.JUMP), "SceneFlow libera ações mantidas na suspensão do aplicativo")
	Input.action_release(Actions.JUMP)
	return true


func test_missing_scene_is_rejected_without_side_effects() -> bool:
	var flow: Node = _flow()
	check(flow != null, "autoload SceneFlow presente")
	if flow == null:
		return true
	var failures: Array[String] = []
	var on_failed: Callable = func(path: String, reason: String) -> void: failures.append("%s:%s" % [path, reason])
	flow.transition_failed.connect(on_failed)
	# push_error esperado: este teste provoca o erro de propósito.
	var started: bool = flow.change_scene("res://nao_existe.tscn")
	flow.transition_failed.disconnect(on_failed)
	check(not started, "change_scene devolve false")
	check_eq(failures.size(), 1, "transition_failed emitido uma vez")
	check(not flow.is_transitioning(), "não ficou preso em transição")
	return true


func test_cancelable_transition_drains_load_and_preserves_current_scene() -> bool:
	var flow: Node = _flow()
	check(flow != null, "autoload SceneFlow presente")
	if flow == null:
		return true
	var loading_overlay: Node = tree.root.get_node_or_null("LoadingOverlay")
	check(loading_overlay != null, "autoload LoadingOverlay presente")
	if loading_overlay == null:
		return true
	var overlay_panel: Control = loading_overlay.get_node("%Overlay") as Control
	var status_label: Label = loading_overlay.get_node("%StatusLabel") as Label
	var previous_scene: Node = tree.current_scene
	var previous_pause: bool = tree.paused
	var cancelled: Array[String] = []
	var finished: Array[String] = []
	var failed: Array[String] = []
	var on_cancelled: Callable = func(path: String) -> void: cancelled.append(path)
	var on_finished: Callable = func(path: String) -> void: finished.append(path)
	var on_failed: Callable = func(path: String, reason: String) -> void: failed.append("%s:%s" % [path, reason])
	flow.transition_cancelled.connect(on_cancelled)
	flow.transition_finished.connect(on_finished)
	flow.transition_failed.connect(on_failed)

	var started: bool = flow.change_scene(MAIN_MENU, true)
	check(started, "transição explicitamente cancelável é aceita")
	check(flow.is_transitioning(), "carga permanece rastreada")
	check(loading_overlay.is_loading and overlay_panel.visible, "overlay acompanha a transição cancelável")
	check(flow.cancel_transition(), "pedido de cancelamento aceito")
	check(not flow.cancel_transition(), "pedido duplicado de cancelamento rejeitado")
	check(flow.is_cancel_requested(), "SceneFlow registra cancelamento pendente")
	check_eq(status_label.text, "Cancelando carregamento…", "overlay informa que está drenando a carga")
	check(flow.is_transitioning(), "não libera concorrência antes de a carga terminar")

	var frames: int = 0
	while flow.is_transitioning() and frames < 600:
		await tree.process_frame
		frames += 1

	flow.transition_cancelled.disconnect(on_cancelled)
	flow.transition_finished.disconnect(on_finished)
	flow.transition_failed.disconnect(on_failed)
	check(not flow.is_transitioning(), "cancelamento conclui em até 600 frames")
	check_eq(cancelled.size(), 1, "transition_cancelled emitido uma vez")
	check(finished.is_empty(), "transição cancelada não emite transition_finished")
	check(failed.is_empty(), "carga drenada sem falha não emite transition_failed")
	check(tree.current_scene == previous_scene, "cena atual permanece intacta")
	check_eq(tree.paused, previous_pause, "cancelamento restaura o estado anterior de pausa")
	check(not loading_overlay.is_loading and not overlay_panel.visible, "overlay encerra após drenar a carga")
	check_eq(flow.progress, 0.0, "progresso é reiniciado após cancelamento")
	return true


func test_transition_loads_scene_and_blocks_concurrent_transition() -> bool:
	var flow: Node = _flow()
	if flow == null:
		check(false, "autoload SceneFlow presente")
		return true
	var loading_overlay: Node = tree.root.get_node_or_null("LoadingOverlay")
	check(loading_overlay != null, "autoload LoadingOverlay presente para integração real")
	if loading_overlay == null:
		return true
	var overlay_panel: Control = loading_overlay.get_node("%Overlay") as Control

	var finished: Array[String] = []
	var on_finished: Callable = func(path: String) -> void: finished.append(path)
	flow.transition_finished.connect(on_finished)
	var started: bool = flow.change_scene(MAIN_MENU)
	check(started, "primeira transição aceita")
	check(flow.is_transitioning(), "em transição logo após o pedido")
	check(tree.paused, "simulação pausada durante o carregamento")
	check(not flow.cancel_transition(), "transição padrão não habilita cancelamento")
	check(loading_overlay.is_loading, "transição real ativa o estado do LoadingOverlay")
	check(overlay_panel.visible, "transição real exibe o overlay enquanto carrega")
	var second: bool = flow.change_scene(MAIN_MENU)
	check(not second, "segunda transição simultânea rejeitada")
	var frames: int = 0
	while flow.is_transitioning() and frames < 600:
		await tree.process_frame
		frames += 1
	flow.transition_finished.disconnect(on_finished)
	check(not flow.is_transitioning(), "transição concluiu em até 600 frames")
	check(not loading_overlay.is_loading, "transição real encerra o estado do LoadingOverlay")
	check(not overlay_panel.visible, "transição real oculta o overlay após concluir")
	check(not tree.paused, "simulação retomada após carregar a nova cena")
	check_eq(finished.size(), 1, "transition_finished emitido uma vez")
	check(tree.current_scene != null and tree.current_scene.scene_file_path == MAIN_MENU, "cena atual é o menu principal")
	if tree.current_scene != null:
		tree.current_scene.queue_free()
		await tree.process_frame
	return true
