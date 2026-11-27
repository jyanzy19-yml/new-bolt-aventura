extends Control
## Seleção dos sete mundos. A progressão é derivada de CampaignProgress v1.
const CATALOG = preload("res://scripts/campaign/campaign_catalog.gd")
const PHASE_SELECTION_PATH: String = "res://scenes/ui/phase_selection.tscn"
const MAIN_MENU_PATH: String = "res://scenes/ui/main_menu.tscn"
const COLOR_BG: Color = Color("#07111f")
const COLOR_PANEL: Color = Color("#10243a")
const COLOR_ACCENT: Color = Color("#38d9ff")
const COLOR_MUTED: Color = Color("#8ca6bd")
const COLOR_LOCKED: Color = Color("#526477")
const COLOR_COMPLETE: Color = Color("#54e0a2")
var _safe_area: SafeAreaMargin
var _grid: GridContainer

func _ready() -> void:
	_build_interface()

func _build_interface() -> void:
	var background := ColorRect.new()
	background.color = COLOR_BG
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	_safe_area = SafeAreaMargin.new()
	_safe_area.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(_safe_area)

	var padding := MarginContainer.new()
	padding.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	padding.add_theme_constant_override("margin_left", 20)
	padding.add_theme_constant_override("margin_right", 20)
	padding.add_theme_constant_override("margin_top", 12)
	padding.add_theme_constant_override("margin_bottom", 12)
	_safe_area.add_child(padding)

	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 10)
	padding.add_child(column)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 16)
	column.add_child(header)
	var title := Label.new()
	title.text = "SELEÇÃO DE MUNDOS"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_font_size_override("font_size", 30)
	title.add_theme_color_override("font_color", Color.WHITE)
	header.add_child(title)

	var state: Dictionary = CampaignProgress.load_state()
	var completed: Array = state.get("completed_level_ids", [])
	var progress := Label.new()
	progress.text = "%d / %d FASES" % [CATALOG.get_total_completed_count(completed), CATALOG.get_total_phase_count()]
	progress.add_theme_font_size_override("font_size", 20)
	progress.add_theme_color_override("font_color", COLOR_ACCENT)
	header.add_child(progress)

	var subtitle := Label.new()
	subtitle.text = "Escolha um mundo para consultar suas fases."
	subtitle.add_theme_font_size_override("font_size", 15)
	subtitle.add_theme_color_override("font_color", COLOR_MUTED)
	column.add_child(subtitle)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	column.add_child(scroll)
	_grid = GridContainer.new()
	_grid.name = "WorldGrid"
	_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_grid.add_theme_constant_override("h_separation", 12)
	_grid.add_theme_constant_override("v_separation", 12)
	scroll.add_child(_grid)
	_safe_area.resized.connect(_update_grid_columns)
	get_viewport().size_changed.connect(_update_grid_columns)
	call_deferred("_update_grid_columns")
	for world_index in range(CATALOG.get_world_count()):
		_grid.add_child(_make_world_card(world_index, completed))
	if _grid.get_child_count() > 0:
		_grid.get_child(0).grab_focus()

	var footer := HBoxContainer.new()
	footer.alignment = BoxContainer.ALIGNMENT_END
	column.add_child(footer)
	var back := _make_button("VOLTAR AO MENU", 52)
	back.custom_minimum_size.x = 220
	back.pressed.connect(_return_to_menu)
	footer.add_child(back)

func _update_grid_columns() -> void:
	if _grid == null or not is_instance_valid(_grid):
		return
	var available_width: float = maxf(0.0, _safe_area.size.x - 40.0)
	_grid.columns = clampi(floori((available_width + 12.0) / 202.0), 2, 4)

func _make_world_card(world_index: int, completed: Array) -> Button:
	var world_id: String = CATALOG.WORLD_IDS[world_index]
	var scene_exists: bool = CATALOG.is_scene_available(CATALOG.get_level_id(world_index, 0))
	var state: String = CATALOG.get_world_state(world_index, completed, scene_exists)
	var count: int = CATALOG.get_world_completed_count(world_index, completed)
	var button := Button.new()
	button.custom_minimum_size = Vector2(190, 128)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.size_flags_vertical = Control.SIZE_EXPAND_FILL
	button.text = "%s\n%s\n%d / 6 FASES\n%s" % [world_id, CATALOG.get_world_name(world_index), count, _status_label(state)]
	button.add_theme_font_size_override("font_size", 17)
	button.add_theme_color_override("font_color", Color.WHITE if state != "locked" else COLOR_MUTED)
	button.add_theme_stylebox_override("normal", _card_style(state, false))
	button.add_theme_stylebox_override("hover", _card_style(state, true))
	button.add_theme_stylebox_override("pressed", _card_style(state, true))
	button.add_theme_stylebox_override("disabled", _card_style(state, false))
	button.disabled = state != "available" and state != "completed"
	button.pressed.connect(_open_world.bind(world_id))
	return button

func _card_style(state: String, hovered: bool) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = COLOR_PANEL.lightened(0.10) if hovered else COLOR_PANEL
	style.set_corner_radius_all(10)
	style.set_border_width_all(2)
	match state:
		"completed": style.border_color = COLOR_COMPLETE
		"available": style.border_color = COLOR_ACCENT
		"coming_soon": style.border_color = COLOR_LOCKED
		_: style.border_color = COLOR_LOCKED.darkened(0.25)
	return style

func _make_button(label: String, min_height: float) -> Button:
	var button := Button.new()
	button.text = label
	button.custom_minimum_size.y = min_height
	button.add_theme_font_size_override("font_size", 18)
	return button

func _status_label(state: String) -> String:
	match state:
		"completed": return "CONCLUÍDO"
		"available": return "DISPONÍVEL"
		"coming_soon": return "EM BREVE"
		_: return "BLOQUEADO"

func _open_world(world_id: String) -> void:
	var flow: Node = get_node_or_null("/root/SceneFlow")
	if flow == null:
		push_error("WorldSelection: autoload SceneFlow ausente.")
		return
	if flow.change_scene(PHASE_SELECTION_PATH):
		get_tree().root.set_meta("campaign_selection_world_id", world_id)

func _return_to_menu() -> void:
	var flow: Node = get_node_or_null("/root/SceneFlow")
	if flow != null:
		flow.change_scene(MAIN_MENU_PATH)
