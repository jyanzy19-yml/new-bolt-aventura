extends BoltTest
## Integração de regressão: percorre SceneFlow.change_scene(), que usa
## ResourceLoader.load_threaded_request/status/get, em ciclos repetidos.

const SCENES: Array[String] = [
	"res://scenes/ui/main_menu.tscn",
	"res://scenes/campaign/opening_cinematic.tscn",
	"res://scenes/campaign/cybercore_w1_l1.tscn",
	"res://scenes/campaign/cybercore_w1_l2.tscn",
]
const LOAD_REPETITIONS: int = 30


func _transition_via_scene_flow(path: String, repetition: int) -> void:
	var flow: Node = tree.root.get_node_or_null("SceneFlow")
	check(flow != null, "autoload SceneFlow disponível")
	if flow == null:
		return

	var finished: Array[String] = []
	var failed: Array[String] = []
	var on_finished: Callable = func(loaded_path: String) -> void:
		finished.append(loaded_path)
	var on_failed: Callable = func(failed_path: String, reason: String) -> void:
		failed.append("%s:%s" % [failed_path, reason])

	flow.connect("transition_finished", on_finished)
	flow.connect("transition_failed", on_failed)
	var started: bool = bool(flow.call("change_scene", path))
	check(started, "SceneFlow aceita %s (ciclo %d)" % [path, repetition + 1])
	if started:
		var frames_waited: int = 0
		while bool(flow.call("is_transitioning")) and frames_waited < 600:
			await tree.process_frame
			frames_waited += 1
		check(not bool(flow.call("is_transitioning")), "SceneFlow termina %s em até 600 frames" % path)
		check_eq(finished.size(), 1, "emite transition_finished uma vez para %s" % path)
		check(failed.is_empty(), "não emite transition_failed para %s" % path)
		check(tree.current_scene != null, "SceneFlow define current_scene para %s" % path)
		if tree.current_scene != null:
			check_eq(tree.current_scene.scene_file_path, path, "cena atual corresponde ao destino threaded")
		check(not tree.paused, "SceneFlow retoma a SceneTree após %s" % path)

	if flow.is_connected("transition_finished", on_finished):
		flow.disconnect("transition_finished", on_finished)
	if flow.is_connected("transition_failed", on_failed):
		flow.disconnect("transition_failed", on_failed)
	await tree.process_frame


func test_scene_flow_repeatedly_loads_menu_and_both_campaign_levels() -> bool:
	var save_system: Node = tree.root.get_node_or_null("SaveSystem")
	check(save_system != null, "autoload SaveSystem disponível no runner")
	if save_system != null:
		save_system.set("storage_path_override", "user://threaded_scene_load_regression.json")
		save_system.call("delete_save")

	for repetition in range(LOAD_REPETITIONS):
		for path: String in SCENES:
			await _transition_via_scene_flow(path, repetition)

	tree.paused = false
	var flow: Node = tree.root.get_node_or_null("SceneFlow")
	if flow != null:
		check(not bool(flow.call("is_transitioning")), "nenhuma transição permanece ativa ao final do laço")
	if save_system != null:
		save_system.call("delete_save")
		save_system.set("storage_path_override", "")
	return true
