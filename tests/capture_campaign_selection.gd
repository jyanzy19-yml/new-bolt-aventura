extends SceneTree
## Captura evidências visuais de UI em viewport desktop 16:9 via Xvfb.
## Uso: godot --path . --script res://tests/capture_campaign_selection.gd

const CAPTURES_DIR: String = "res://artifacts/campaign-selection"
const MAIN_MENU_PATH: String = "res://scenes/ui/main_menu.tscn"
const WORLD_SELECTION_PATH: String = "res://scenes/ui/world_selection.tscn"
const PHASE_SELECTION_PATH: String = "res://scenes/ui/phase_selection.tscn"


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	await process_frame
	DisplayServer.window_set_size(Vector2i(1280, 720))
	await process_frame
	var output_dir: String = ProjectSettings.globalize_path(CAPTURES_DIR)
	var mkdir_error: Error = DirAccess.make_dir_recursive_absolute(output_dir)
	if mkdir_error != OK and mkdir_error != ERR_ALREADY_EXISTS:
		push_error("UI capture: não foi possível criar diretório (%d)." % mkdir_error)
		quit(1)
		return

	if not await _capture_scene(MAIN_MENU_PATH, "01-main-menu.png"):
		quit(1)
		return
	if not await _capture_scene(WORLD_SELECTION_PATH, "02-world-selection.png"):
		quit(1)
		return
	get_root().set_meta("campaign_selection_world_id", "W1")
	if not await _capture_scene(PHASE_SELECTION_PATH, "03-phase-selection-cybercore.png"):
		quit(1)
		return

	print("UI captures generated: main menu, worlds, Cybercore phases.")
	quit(0)


func _capture_scene(scene_path: String, filename: String) -> bool:
	var packed: PackedScene = load(scene_path) as PackedScene
	if packed == null:
		push_error("UI capture: cena não carrega: %s" % scene_path)
		return false

	var instance: Node = packed.instantiate()
	get_root().add_child(instance)
	current_scene = instance
	await process_frame
	await RenderingServer.frame_post_draw

	var viewport_texture: ViewportTexture = get_root().get_texture()
	var screenshot: Image = viewport_texture.get_image()
	if screenshot == null or screenshot.is_empty():
		push_error("UI capture: viewport vazio para %s." % scene_path)
		instance.queue_free()
		await process_frame
		current_scene = null
		return false

	var output_path: String = ProjectSettings.globalize_path("%s/%s" % [CAPTURES_DIR, filename])
	var save_error: Error = screenshot.save_png(output_path)
	if save_error != OK:
		push_error("UI capture: falha ao salvar %s (%d)." % [filename, save_error])
		instance.queue_free()
		await process_frame
		current_scene = null
		return false

	current_scene = null
	instance.queue_free()
	await process_frame
	return true
