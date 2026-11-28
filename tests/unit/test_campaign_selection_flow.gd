extends BoltTest
## Integração ponta a ponta do fluxo de seleção de campanha.
## Exercita os sinais reais dos botões e o SceneFlow threaded, sem mocks.

const MAIN_MENU_PATH: String = "res://scenes/ui/main_menu.tscn"
const WORLD_SELECTION_PATH: String = "res://scenes/ui/world_selection.tscn"
const PHASE_SELECTION_PATH: String = "res://scenes/ui/phase_selection.tscn"
const W1_L1_PATH: String = "res://scenes/campaign/cybercore_w1_l1.tscn"
const TEST_SAVE_PATH: String = "user://bolt_campaign_selection_e2e_test.json"


func _wait_for_transition(flow: Node) -> bool:
	var frames: int = 0
	while flow.is_transitioning() and frames < 600:
		await tree.process_frame
		frames += 1
	return not flow.is_transitioning()


func test_menu_world_phase_and_level_navigation_uses_real_scene_flow() -> bool:
	var flow: Node = tree.root.get_node_or_null("SceneFlow")
	check(flow != null, "autoload SceneFlow disponível para navegação real")
	if flow == null:
		return true

	var save_system: Node = tree.root.get_node_or_null("SaveSystem")
	check(save_system != null, "autoload SaveSystem disponível para isolamento")
	if save_system == null:
		return true

	tree.paused = false
	save_system.storage_path_override = TEST_SAVE_PATH
	save_system.delete_save()
	if tree.root.has_meta("campaign_selection_world_id"):
		tree.root.remove_meta("campaign_selection_world_id")

	var menu_packed: PackedScene = load(MAIN_MENU_PATH) as PackedScene
	check(menu_packed != null, "menu principal carrega")
	if menu_packed == null:
		save_system.delete_save()
		save_system.storage_path_override = ""
		return true

	var menu: Node = menu_packed.instantiate()
	tree.root.add_child(menu)
	tree.current_scene = menu
	await tree.process_frame

	var selection_button: Button = menu.get_node_or_null("Center/Column/CampaignSelectionButton") as Button
	check(selection_button != null, "menu expõe entrada Selecionar Mundo / Fase")
	if selection_button != null:
		selection_button.pressed.emit()
		check(flow.is_transitioning(), "toque/click no menu inicia transição threaded")
		check(await _wait_for_transition(flow), "transição menu → mundos termina")
		check(tree.current_scene != null and tree.current_scene.scene_file_path == WORLD_SELECTION_PATH, "destino real é a seleção de mundos")

	if tree.current_scene != null and tree.current_scene.scene_file_path == WORLD_SELECTION_PATH:
		var world_grid: GridContainer = tree.current_scene.find_child("WorldGrid", true, false) as GridContainer
		check(world_grid != null and world_grid.get_child_count() == 7, "tela apresenta os sete mundos")
		if world_grid != null and world_grid.get_child_count() == 7:
			var cybercore_button: Button = world_grid.get_child(0) as Button
			check(cybercore_button != null and not cybercore_button.disabled, "Cybercore está disponível em campanha nova")
			if cybercore_button != null and not cybercore_button.disabled:
				cybercore_button.pressed.emit()
				check(flow.is_transitioning(), "selecionar Cybercore inicia transição threaded")
				check(await _wait_for_transition(flow), "transição mundos → fases termina")
				check(tree.current_scene != null and tree.current_scene.scene_file_path == PHASE_SELECTION_PATH, "destino real é a seleção de fases")

	if tree.current_scene != null and tree.current_scene.scene_file_path == PHASE_SELECTION_PATH:
		var phase_grid: GridContainer = tree.current_scene.find_child("PhaseGrid", true, false) as GridContainer
		check(phase_grid != null and phase_grid.get_child_count() == 6, "Cybercore apresenta seis fases")
		if phase_grid != null and phase_grid.get_child_count() == 6:
			var first_phase: Button = phase_grid.get_child(0) as Button
			var second_phase: Button = phase_grid.get_child(1) as Button
			check(first_phase != null and not first_phase.disabled, "W1-L1 pode ser iniciada")
			check(second_phase != null and second_phase.disabled, "W1-L2 permanece bloqueada antes de concluir W1-L1")
			if first_phase != null and not first_phase.disabled:
				first_phase.pressed.emit()
				check(flow.is_transitioning(), "selecionar W1-L1 inicia transição threaded")
				check(await _wait_for_transition(flow), "transição fases → W1-L1 termina")
				check(tree.current_scene != null and tree.current_scene.scene_file_path == W1_L1_PATH, "W1-L1 real é instanciada pelo fluxo de seleção")
				check_eq(str(CampaignProgress.load_state().get("current_level_id", "")), "W1-L1", "entrada registra W1-L1 no save de teste")

	# Não deixa cena, pausa ou arquivo temporário contaminarem os testes seguintes.
	if flow.is_transitioning():
		await _wait_for_transition(flow)
	if tree.current_scene != null:
		var active_scene: Node = tree.current_scene
		tree.current_scene = null
		active_scene.queue_free()
		await tree.process_frame
	tree.paused = false
	if tree.root.has_meta("campaign_selection_world_id"):
		tree.root.remove_meta("campaign_selection_world_id")
	save_system.delete_save()
	save_system.storage_path_override = ""
	return true
