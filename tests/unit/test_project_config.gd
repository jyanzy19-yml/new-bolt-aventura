extends BoltTest
## Verifica a configuração fundacional do projeto (SYS-001, SYS-002). Não prova nada sobre
## comportamento em aparelho Android — apenas que o que está declarado é o que foi decidido.


func test_pinned_godot_version() -> bool:
	var pinned: String = FileAccess.get_file_as_string("res://.godot-version").strip_edges()
	var info: Dictionary = Engine.get_version_info()
	var actual: String = "%d.%d.%d" % [info["major"], info["minor"], info["patch"]]
	check_eq(actual, pinned, ".godot-version coincide com o runtime")
	check_eq(info["status"], "stable", "runtime é uma versão estável")
	return true


func test_landscape_and_display() -> bool:
	# 4 = Sensor Landscape (retrato nunca é oferecido); ver docs/technical/06-godot-project-foundation.md
	check_eq(ProjectSettings.get_setting("display/window/handheld/orientation"), 4, "orientação paisagem")
	check_eq(ProjectSettings.get_setting("display/window/size/viewport_width"), 960, "largura base")
	check_eq(ProjectSettings.get_setting("display/window/size/viewport_height"), 540, "altura base")
	check_eq(ProjectSettings.get_setting("display/window/stretch/mode"), "canvas_items", "stretch mode")
	check_eq(ProjectSettings.get_setting("display/window/stretch/aspect"), "expand", "stretch aspect")
	return true


func test_renderer_and_android_texture_support() -> bool:
	check_eq(ProjectSettings.get_setting("rendering/renderer/rendering_method"), "gl_compatibility", "renderer desktop")
	check_eq(ProjectSettings.get_setting("rendering/renderer/rendering_method.mobile"), "gl_compatibility", "renderer mobile")
	check_eq(ProjectSettings.get_setting("rendering/textures/vram_compression/import_etc2_astc"), true, "ETC2/ASTC (exigido pelo export Android)")
	return true


func test_physics_rate_is_fixed() -> bool:
	check_eq(ProjectSettings.get_setting("physics/common/physics_ticks_per_second"), 60, "ticks de física")
	check_eq(Engine.physics_ticks_per_second, 60, "ticks de física em runtime")
	return true


func test_main_scene_exists_and_autoloads() -> bool:
	var main_scene: String = ProjectSettings.get_setting("application/run/main_scene")
	check(ResourceLoader.exists(main_scene, "PackedScene"), "cena principal existe: %s" % main_scene)
	check(ProjectSettings.has_setting("autoload/SceneFlow"), "autoload SceneFlow registrado")
	check(ProjectSettings.has_setting("autoload/SaveSystem"), "autoload SaveSystem registrado")
	return true


func test_no_fullscreen_toggle_and_system_bars_policy_is_export_side() -> bool:
	# ADR-0003: Tela cheia permanece desligada; o jogo não cria alternância. A política imersiva
	# é aplicada pelo preset de export Android (screen/immersive_mode), verificado abaixo.
	var presets: ConfigFile = ConfigFile.new()
	check_eq(presets.load("res://export_presets.cfg"), OK, "export_presets.cfg carrega")
	var found_android: bool = false
	for section: String in presets.get_sections():
		if section.ends_with(".options"):
			continue
		if presets.get_value(section, "platform", "") == "Android":
			found_android = true
			var options: String = section + ".options"
			check_eq(presets.get_value(options, "screen/immersive_mode", false), true, "immersive_mode ligado (ADR-0003)")
			for key: String in presets.get_section_keys(options):
				if key.begins_with("keystore/"):
					check_eq(str(presets.get_value(options, key)), "", "sem material de assinatura no repositório: %s" % key)
			check_eq(presets.get_value(options, "architectures/arm64-v8a", false), true, "arm64-v8a habilitado")
			check_eq(presets.get_value(section, "export_path", ""), "", "sem caminho de export fixado")
	check(found_android, "preset Android presente")
	return true
