extends Control
## Menu principal com entrada explícita em campanha nova ou retomada de progresso válido.

const OPENING_PATH: String = "res://scenes/campaign/opening_cinematic.tscn"
const W1_L1_ID: String = "W1-L1"
const W1_L1_PATH: String = "res://scenes/campaign/cybercore_w1_l1.tscn"

@onready var _version: Label = %VersionLabel
@onready var _play: Button = %PlayButton
@onready var _continue: Button = %ContinueButton
@onready var _progress_status: Label = %ProgressStatusLabel


func _ready() -> void:
	var version: String = str(ProjectSettings.get_setting("application/config/version", "?"))
	_version.text = "v%s · Godot %s" % [version, Engine.get_version_info().get("string", "?")]
	_play.pressed.connect(_on_new_game_pressed)
	_continue.pressed.connect(_on_continue_pressed)
	_refresh_continue_state()
	_play.grab_focus()


func _refresh_continue_state() -> void:
	var state: Dictionary = CampaignProgress.load_state()
	var current_level_id: String = str(state.get("current_level_id", ""))
	var load_error: String = CampaignProgress.last_error
	var can_continue: bool = load_error.is_empty() and current_level_id == W1_L1_ID
	can_continue = can_continue and ResourceLoader.exists(W1_L1_PATH, "PackedScene")
	_continue.disabled = not can_continue

	if not load_error.is_empty():
		_progress_status.text = "SAVE INDISPONÍVEL · Você ainda pode iniciar uma nova jornada."
	elif current_level_id.is_empty():
		_progress_status.text = "Nenhuma campanha salva."
	elif current_level_id != W1_L1_ID or not ResourceLoader.exists(W1_L1_PATH, "PackedScene"):
		_progress_status.text = "O progresso salvo aponta para uma fase ainda indisponível."
	elif SaveSystem.last_error == "recovered_backup":
		_progress_status.text = "Progresso recuperado do backup · Cybercore disponível."
	elif CampaignProgress.is_level_completed(W1_L1_ID):
		_progress_status.text = "Trecho concluído · Cybercore disponível para revisitar."
	else:
		_progress_status.text = "Progresso disponível · Cybercore."


func _resolve_continue_path() -> String:
	var state: Dictionary = CampaignProgress.load_state()
	if not CampaignProgress.last_error.is_empty():
		return ""
	if str(state.get("current_level_id", "")) != W1_L1_ID:
		return ""
	if not ResourceLoader.exists(W1_L1_PATH, "PackedScene"):
		return ""
	return W1_L1_PATH


func _on_new_game_pressed() -> void:
	_play.disabled = true
	_continue.disabled = true
	if not CampaignProgress.start_new_campaign():
		# Corrupt/unreadable storage must not prevent entering gameplay. The session can
		# continue, but checkpoint/progress persistence will report its own write failure.
		push_warning("MainMenu: nova jornada iniciada sem redefinir o save (%s)." % CampaignProgress.last_error)
		_progress_status.text = "Save indisponível · esta sessão pode não ser persistida."
	_transition_to(OPENING_PATH)


func _on_continue_pressed() -> void:
	var resume_path: String = _resolve_continue_path()
	if resume_path.is_empty():
		_refresh_continue_state()
		return
	_transition_to(resume_path)


func _transition_to(path: String) -> void:
	# Resolve SceneFlow at runtime: it is also used by scenes loaded on a worker thread.
	var flow: Node = get_node_or_null("/root/SceneFlow")
	if flow == null:
		push_error("MainMenu: autoload SceneFlow ausente.")
		_restore_menu()
		return
	if not flow.change_scene(path):
		_restore_menu()


func _restore_menu() -> void:
	_play.disabled = false
	_refresh_continue_state()
	_play.grab_focus()
