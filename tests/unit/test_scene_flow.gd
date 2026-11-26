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


func test_transition_loads_scene_and_blocks_concurrent_transition() -> bool:
	var flow: Node = _flow()
	if flow == null:
		check(false, "autoload SceneFlow presente")
		return true
	var finished: Array[String] = []
	var on_finished: Callable = func(path: String) -> void: finished.append(path)
	flow.transition_finished.connect(on_finished)
	var started: bool = flow.change_scene(MAIN_MENU)
	check(started, "primeira transição aceita")
	check(flow.is_transitioning(), "em transição logo após o pedido")
	var second: bool = flow.change_scene(MAIN_MENU)
	check(not second, "segunda transição simultânea rejeitada")
	var frames: int = 0
	while flow.is_transitioning() and frames < 600:
		await tree.process_frame
		frames += 1
	flow.transition_finished.disconnect(on_finished)
	check(not flow.is_transitioning(), "transição concluiu em até 600 frames")
	check_eq(finished.size(), 1, "transition_finished emitido uma vez")
	check(tree.current_scene != null and tree.current_scene.scene_file_path == MAIN_MENU, "cena atual é o menu principal")
	if tree.current_scene != null:
		tree.current_scene.queue_free()
		await tree.process_frame
	return true
