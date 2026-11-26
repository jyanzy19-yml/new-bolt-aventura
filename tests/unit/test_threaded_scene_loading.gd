extends BoltTest
## Regressão para a compilação de scripts de cenas solicitadas pelo carregador threaded.
## O ciclo request/status/get replica o caminho de ResourceLoader usado por SceneFlow.

const THREADED_SCENES: Array[String] = [
	"res://scenes/ui/main_menu.tscn",
	"res://scenes/campaign/cybercore_w1_l1.tscn",
	"res://scenes/campaign/cybercore_w1_l2.tscn",
]
const LOAD_REPETITIONS: int = 30


func _load_threaded_scene(path: String) -> PackedScene:
	var request_error: Error = ResourceLoader.load_threaded_request(
		path, "PackedScene", false, ResourceLoader.CACHE_MODE_REPLACE
	)
	check_eq(request_error, OK, "threaded request aceito: %s" % path)
	if request_error != OK:
		return null

	var status: ResourceLoader.ThreadLoadStatus = ResourceLoader.THREAD_LOAD_IN_PROGRESS
	var frames_waited: int = 0
	while status == ResourceLoader.THREAD_LOAD_IN_PROGRESS and frames_waited < 600:
		await tree.process_frame
		status = ResourceLoader.load_threaded_get_status(path)
		frames_waited += 1

	check_eq(status, ResourceLoader.THREAD_LOAD_LOADED, "threaded load conclui: %s" % path)
	if status != ResourceLoader.THREAD_LOAD_LOADED:
		return null

	var packed: PackedScene = ResourceLoader.load_threaded_get(path) as PackedScene
	check(packed != null, "PackedScene compila/carrega pelo caminho threaded: %s" % path)
	return packed


func test_menu_and_campaign_scenes_survive_repeated_threaded_loading() -> bool:
	var save_system: Node = tree.root.get_node_or_null("SaveSystem")
	check(save_system != null, "autoload SaveSystem disponível no runner")
	if save_system != null:
		save_system.set("storage_path_override", "user://threaded_scene_load_regression.json")
		save_system.call("delete_save")

	for repetition in range(LOAD_REPETITIONS):
		for path: String in THREADED_SCENES:
			var packed: PackedScene = await _load_threaded_scene(path)
			if packed == null:
				continue
			var instance: Node = packed.instantiate()
			check(instance != null, "instancia %s na repetição %d" % [path, repetition + 1])
			if instance == null:
				continue
			tree.root.add_child(instance)
			await tree.process_frame
			check(instance.is_inside_tree(), "cena entra na árvore: %s" % path)
			instance.free()
			await tree.process_frame

	tree.paused = false
	if save_system != null:
		save_system.call("delete_save")
		save_system.set("storage_path_override", "")
	return true
