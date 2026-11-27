extends Control
## Menu principal com retomada limitada às fases de campanha realmente disponíveis.

const OPENING_PATH: String = "res://scenes/campaign/opening_cinematic.tscn"
const LEVEL_PATHS: Dictionary = {
	"W1-L1": "res://scenes/campaign/cybercore_w1_l1.tscn",
	"W1-L2": "res://scenes/campaign/cybercore_w1_l2.tscn",
	"W1-L3": "res://scenes/campaign/cybercore_w1_l3.tscn",
}
const LEVEL_LABELS: Dictionary = {
	"W1-L1": "Despertar entre Ruínas",
	"W1-L2": "Ruas sem Sinal",
	"W1-L3": "Fábrica de Ecos",
}

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


func _resolve_level_path(level_id: String) -> String:
	var path: String = str(LEVEL_PATHS.get(level_id, ""))
	if path.is_empty() or not ResourceLoader.exists(path, "PackedScene"):
		return ""
	return path


func _refresh_continue_state() -> void:
	var state: Dictionary = CampaignProgress.load_state()
	var current_level_id: String = str(state.get("current_level_id", ""))
	var load_error: String = CampaignProgress.last_error
	var resume_path: String = _resolve_level_path(current_level_id)
	var can_continue: bool = load_error.is_empty() and not resume_path.is_empty()
	_continue.disabled = not can_continue

	if not load_error.is_empty():
		_progress_status.text = "SAVE INDISPONÍVEL · Você ainda pode iniciar uma nova jornada."
	elif current_level_id.is_empty():
		_progress_status.text = "Nenhuma campanha salva."
	elif resume_path.is_empty():
		_progress_status.text = "O progresso salvo aponta para uma fase ainda indisponível."
	elif SaveSystem.last_error == "recovered_backup":
		_progress_status.text = "Progresso recuperado do backup · %s disponível." % str(LEVEL_LABELS.get(current_level_id, current_level_id))
	elif CampaignProgress.is_level_completed(current_level_id):
		_progress_status.text = "Trecho concluído · %s disponível para revisitar." % str(LEVEL_LABELS.get(current_level_id, current_level_id))
	else:
		_progress_status.text = "Progresso disponível · %s." % str(LEVEL_LABELS.get(current_level_id, current_level_id))


func _resolve_continue_path() -> String:
	var state: Dictionary = CampaignProgress.load_state()
	if not CampaignProgress.last_error.is_empty():
		return ""
	return _resolve_level_path(str(state.get("current_level_id", "")))


func _on_new_game_pressed() -> void:
	_play.disabled = true
	_continue.disabled = true
	if not CampaignProgress.start_new_campaign():
		# Save ilegível não deve ser apagado implicitamente; a sessão ainda pode começar.
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
