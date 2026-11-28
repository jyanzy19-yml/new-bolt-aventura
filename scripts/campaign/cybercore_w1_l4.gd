extends Node2D
## W1-L4 — Laboratório de Memórias. Fase vertical provisória alinhada ao Atlas Mestre.

const LEVEL_PATH: String = "res://scenes/campaign/cybercore_w1_l4.tscn"
const LEVEL_ID: String = "W1-L4"
const CAMERA_LIMITS: Rect2i = Rect2i(-80, -1850, 1400, 2050)
const PRESERVATION_RECORD_BEAT: StringName = &"w1_l4_preservation_project_record"
const ARCHITECT_MEMORY_BEAT: StringName = &"w1_l4_corrupted_architect_memory"

@onready var _player: BoltPlayer = %Bolt
@onready var _spawn: Marker2D = %SpawnPoint
@onready var _kill_zone: Area2D = %KillZone
@onready var _checkpoint_archive: BoltCheckpoint = %CheckpointArchive
@onready var _checkpoint_chambers: BoltCheckpoint = %CheckpointChambers
@onready var _memory_record: NarrativeBeatTrigger = %MemoryRecordTrigger
@onready var _memory_echo: NarrativeBeatTrigger = %MemoryEchoTrigger
@onready var _goal: Area2D = %Goal
@onready var _hud: Hud = %Hud

var _respawn_position: Vector2 = Vector2.ZERO
var _record_recovered: bool = false
var _secret_memory_recovered: bool = false
var _section_finished: bool = false


func _ready() -> void:
	configure_camera(_player.get_camera())
	_hud.bind_player(_player)
	_hud.set_restart_path(LEVEL_PATH)
	_player.defeated.connect(_on_player_defeated)
	_kill_zone.body_entered.connect(_on_kill_zone_body_entered)
	_checkpoint_archive.activated.connect(_on_checkpoint_activated)
	_checkpoint_chambers.activated.connect(_on_checkpoint_activated)
	_memory_record.beat_requested.connect(_on_narrative_beat_requested)
	_memory_echo.beat_requested.connect(_on_narrative_beat_requested)
	_goal.body_entered.connect(_on_goal_body_entered)
	_respawn_position = _spawn.global_position

	if not CampaignProgress.begin_level(LEVEL_ID):
		push_warning("W1-L4: não foi possível registrar a entrada na fase (%s)." % CampaignProgress.last_error)
	var saved_checkpoint_id: String = CampaignProgress.get_checkpoint_id(LEVEL_ID)
	if not CampaignProgress.last_error.is_empty():
		push_warning("W1-L4: progresso persistente indisponível (%s)." % CampaignProgress.last_error)
	if saved_checkpoint_id == String(_checkpoint_archive.checkpoint_id):
		_checkpoint_archive.restore_activation()
		_respawn_position = _checkpoint_archive.get_respawn_position()
	elif saved_checkpoint_id == String(_checkpoint_chambers.checkpoint_id):
		_checkpoint_chambers.restore_activation()
		_respawn_position = _checkpoint_chambers.get_respawn_position()
	_player.respawn(_respawn_position)


func configure_camera(camera: Camera2D) -> void:
	camera.limit_left = CAMERA_LIMITS.position.x
	camera.limit_top = CAMERA_LIMITS.position.y
	camera.limit_right = CAMERA_LIMITS.end.x
	camera.limit_bottom = CAMERA_LIMITS.end.y
	camera.limit_smoothed = true


func _on_player_defeated() -> void:
	_hud.show_result("BOLT foi derrotado")


func _on_checkpoint_activated(checkpoint_id: StringName, respawn_position: Vector2) -> void:
	_respawn_position = respawn_position
	if not CampaignProgress.save_checkpoint(LEVEL_ID, String(checkpoint_id)):
		push_warning("W1-L4: não foi possível persistir checkpoint (%s)." % CampaignProgress.last_error)
	_hud.show_progress_notification("CHECKPOINT ATIVADO")


func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body == _player:
		_player.respawn(_respawn_position)


func _on_narrative_beat_requested(beat_id: StringName) -> void:
	match beat_id:
		PRESERVATION_RECORD_BEAT:
			_record_recovered = true
			_hud.show_progress_notification("REGISTRO DE PRESERVAÇÃO RECUPERADO")
		ARCHITECT_MEMORY_BEAT:
			_secret_memory_recovered = true
			_hud.show_progress_notification("MEMÓRIA CORROMPIDA RECUPERADA")


func _on_goal_body_entered(body: Node2D) -> void:
	if body != _player or _section_finished:
		return
	if not _record_recovered:
		_hud.show_progress_notification("REGISTRO CENTRAL NECESSÁRIO")
		return
	_section_finished = true
	if not CampaignProgress.mark_level_completed(LEVEL_ID):
		push_warning("W1-L4: não foi possível persistir a conclusão (%s)." % CampaignProgress.last_error)
	_hud.show_result("Laboratório de Memórias concluído")


func has_recovered_secret_memory() -> bool:
	return _secret_memory_recovered
