extends BoltTest
## O overlay acompanha apenas sinais reais do SceneFlow e nunca inventa porcentagem.


func _overlay() -> Node:
	return tree.root.get_node_or_null("LoadingOverlay")


func test_overlay_shows_without_fake_progress_and_hides_on_finish() -> bool:
	var overlay: Node = _overlay()
	check(overlay != null, "autoload LoadingOverlay presente")
	if overlay == null:
		return true
	var panel: Control = overlay.get_node("%Overlay") as Control
	var bar: ProgressBar = overlay.get_node("%ProgressBar") as ProgressBar
	var old_progress: float = SceneFlow.progress
	SceneFlow.progress = 0.0
	check(not panel.visible, "overlay inicia oculto")
	SceneFlow.transition_started.emit("res://scenes/campaign/cybercore_w1_l1.tscn")
	check(overlay.is_loading, "overlay entra em estado de carregamento")
	check(panel.visible, "overlay aparece ao iniciar transição real")
	check(not bar.visible, "sem progresso informado não mostra porcentagem falsa")
	SceneFlow.progress = 0.5
	await tree.process_frame
	check(bar.visible, "barra aparece quando ResourceLoader informa progresso")
	check_eq(roundi(bar.value), 50, "barra representa o progresso real informado")
	SceneFlow.transition_finished.emit("res://scenes/campaign/cybercore_w1_l1.tscn")
	check(not overlay.is_loading, "overlay encerra estado ao concluir transição")
	check(not panel.visible, "overlay some após conclusão")
	SceneFlow.progress = old_progress
	return true


func test_overlay_captures_input_and_processes_while_paused() -> bool:
	var overlay: Node = _overlay()
	check(overlay != null, "autoload LoadingOverlay presente")
	if overlay == null:
		return true
	var panel: Control = overlay.get_node("%Overlay") as Control
	check_eq(panel.mouse_filter, Control.MOUSE_FILTER_STOP, "overlay captura input GUI durante transição")
	check_eq(overlay.process_mode, Node.PROCESS_MODE_ALWAYS, "overlay processa durante pausa")
	return true


func test_overlay_hides_when_transition_fails() -> bool:
	var overlay: Node = _overlay()
	if overlay == null:
		check(false, "autoload LoadingOverlay presente")
		return true
	var panel: Control = overlay.get_node("%Overlay") as Control
	SceneFlow.transition_started.emit("res://missing.tscn")
	check(panel.visible, "overlay aparece ao iniciar")
	SceneFlow.transition_failed.emit("res://missing.tscn", "missing")
	check(not panel.visible, "overlay some após falha")
	check(not overlay.is_loading, "falha encerra estado de carregamento")
	return true
