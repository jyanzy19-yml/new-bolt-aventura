extends Control
## Seleção das seis fases de um mundo, com desbloqueio sequencial aprovado.
const CATALOG = preload("res://scripts/campaign/campaign_catalog.gd")
const WORLD_SELECTION_PATH: String = "res://scenes/ui/world_selection.tscn"
const COLOR_BG: Color = Color("#07111f")
const COLOR_PANEL: Color = Color("#10243a")
const COLOR_ACCENT: Color = Color("#38d9ff")
const COLOR_MUTED: Color = Color("#8ca6bd")
const COLOR_LOCKED: Color = Color("#526477")
const COLOR_COMPLETE: Color = Color("#54e0a2")
var _world_id: String = ""
var _world_index: int = -1

func _ready() -> void:
	_world_id = str(get_tree().root.get_meta("campaign_selection_world_id", ""))
	if get_tree().root.has_meta("campaign_selection_world_id"):
		get_tree().root.remove_meta("campaign_selection_world_id")
	_world_index = CATALOG.get_world_index(_world_id)
	if _world_index < 0:
		_return_to_worlds()
		return
	_build_interface()

func _build_interface() -> void:
	var background := ColorRect.new()
	background.color = COLOR_BG
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)
	var safe := SafeAreaMargin.new()
	safe.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	safe.add_theme_constant_override("margin_left", 24)
	safe.add_theme_constant_override("margin_right", 24)
	safe.add_theme_constant_override("margin_top", 12)
	safe.add_theme_constant_override("margin_bottom", 12)
	add_child(safe)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 10)
	safe.add_child(column)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 14)
	column.add_child(header)
	var title := Label.new()
	title.text = CATALOG.get_world_name(_world_index).to_upper()
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_font_size_override("font_size", 28)
	title.add_theme_color_override("font_color", Color.WHITE)
	header.add_child(title)

	var state: Dictionary = CampaignProgress.load_state()
	var completed: Array = state.get("completed_level_ids", [])
	var count: int = CATALOG.get_world_completed_count(_world_index, completed)
	var progress := Label.new()
	progress.text = "%d / 6" % count
	progress.add_theme_font_size_override("font_size", 22)
	progress.add_theme_color_override("font_color", COLOR_ACCENT)
	header.add_child(progress)

	var detail := Label.new()
	detail.text = "FRAGMENTO: %s   ·   GUARDIÃO: %s" % [CATALOG.get_fragment_name(_world_index), CATALOG.get_guardian_title(_world_index)]
	detail.add_theme_font_size_override("font_size", 14)
	detail.add_theme_color_override("font_color", COLOR_MUTED)
	column.add_child(detail)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	column.add_child(scroll)
	var grid := GridContainer.new()
	grid.columns = 3
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("h_separation", 14)
	grid.add_theme_constant_override("v_separation", 14)
	scroll.add_child(grid)
	var current_level_id: String = str(state.get("current_level_id", ""))
	for phase_index in range(CATALOG.get_phase_count_per_world()):
		grid.add_child(_make_phase_card(phase_index, completed, current_level_id))
	if grid.get_child_count() > 0:
		grid.get_child(0).grab_focus()

	var footer := HBoxContainer.new()
	footer.alignment = BoxContainer.ALIGNMENT_END
	column.add_child(footer)
	var back := Button.new()
	back.text = "VOLTAR AOS MUNDOS"
	back.custom_minimum_size = Vector2(240, 52)
	back.add_theme_font_size_override("font_size", 18)
	back.pressed.connect(_return_to_worlds)
	footer.add_child(back)

func _make_phase_card(phase_index: int, completed: Array, current_level_id: String) -> Button:
	var level_id: String = CATALOG.get_level_id(_world_index, phase_index)
	var phase_state: String = CATALOG.get_phase_state(_world_index, phase_index, completed, CATALOG.is_scene_available(level_id))
	var is_current: bool = current_level_id == level_id
	var button := Button.new()
	button.custom_minimum_size = Vector2(250, 132)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.text = "%s\n%s\n%s" % [level_id, CATALOG.get_phase_title(level_id, phase_index), ("FASE ATUAL · " if is_current else "") + _status_label(phase_state)]
	button.add_theme_font_size_override("font_size", 17)
	button.add_theme_color_override("font_color", Color.WHITE if phase_state != "locked" else COLOR_MUTED)
	button.add_theme_stylebox_override("normal", _card_style(phase_state, is_current))
	button.add_theme_stylebox_override("hover", _card_style(phase_state, is_current, true))
	button.add_theme_stylebox_override("pressed", _card_style(phase_state, is_current, true))
	button.add_theme_stylebox_override("disabled", _card_style(phase_state, is_current))
	button.disabled = phase_state == "locked" or phase_state == "coming_soon"
	button.pressed.connect(_open_phase.bind(level_id))
	return button

func _card_style(state: String, is_current: bool, hovered: bool = false) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = COLOR_PANEL.lightened(0.10) if hovered else COLOR_PANEL
	style.set_corner_radius_all(10)
	style.set_border_width_all(3 if is_current else 2)
	match state:
		"completed": style.border_color = COLOR_COMPLETE
		"available": style.border_color = COLOR_ACCENT
		"coming_soon": style.border_color = COLOR_LOCKED
		_: style.border_color = COLOR_LOCKED.darkened(0.25)
	if is_current:
		style.border_color = Color.WHITE
	return style

func _status_label(state: String) -> String:
	match state:
		"completed": return "CONCLUÍDA · REJOGÁVEL"
		"available": return "DISPONÍVEL"
		"coming_soon": return "EM BREVE"
		_: return "BLOQUEADA"

func _open_phase(level_id: String) -> void:
	var path: String = CATALOG.get_scene_path(level_id)
	if path.is_empty() or not ResourceLoader.exists(path, "PackedScene"):
		return
	var state: Dictionary = CampaignProgress.load_state()
	var completed: Array = state.get("completed_level_ids", [])
	var phase_index: int = int(level_id.get_slice("-", 1).trim_prefix("L")) - 1
	if not CATALOG.is_phase_unlocked(_world_index, phase_index, completed) and not completed.has(level_id):
		return
	var flow: Node = get_node_or_null("/root/SceneFlow")
	if flow != null:
		flow.change_scene(path)

func _return_to_worlds() -> void:
	var flow: Node = get_node_or_null("/root/SceneFlow")
	if flow != null:
		flow.change_scene(WORLD_SELECTION_PATH)
