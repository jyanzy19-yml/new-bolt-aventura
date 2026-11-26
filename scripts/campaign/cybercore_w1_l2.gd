extends Node2D
## W1-L2 — Rede Interrompida. Blockout jogável com campo energético cíclico.

const LEVEL_PATH: String = "res://scenes/campaign/cybercore_w1_l2.tscn"
const LEVEL_ID: String = "W1-L2"
const CAMERA_LIMITS: Rect2i = Rect2i(0, -360, 1900, 620)

@onready var _player: BoltPlayer = %Bolt
@onready var _spawn: Marker2D = %SpawnPoint
@onready var _kill_zone: Area2D = %KillZone
@onready var _checkpoint: BoltCheckpoint = %Checkpoint
@onready var _goal: Area2D = %Goal
@onready var _hud: Hud = %Hud
@onready var _energy_gate: TimedEnergyGate = %EnergyGate

var _respawn_position: Vector2 = Vector2.ZERO
var _section_finished: bool = false


func _campaign_progress() -> Node:
	return get_node_or_null("/root/CampaignProgress")


func _ready() -> void:
	configure_camera(_player.get_camera())
	_hud.bind_player(_player)
	_hud.set_restart_path(LEVEL_PATH)
	_player.defeated.connect(_on_player_defeated)
	_kill_zone.body_entered.connect(_on_kill_zone_body_entered)
	_checkpoint.activated.connect(_on_checkpoint_activated)
	_goal.body_entered.connect(_on_goal_body_entered)
	_energy_gate.state_changed.connect(_on_energy_gate_state_changed)
	_respawn_position = _spawn.global_position
	var progress: Node = _campaign_progress()
	if progress == null:
		push_warning("W1-L2: autoload CampaignProgress ausente; progresso não será persistido.")
	else:
		if not bool(progress.call("begin_level", LEVEL_ID)):
			push_warning("W1-L2: não foi possível registrar a entrada na fase (%s)." % str(progress.get("last_error")))
		var saved_checkpoint_id: String = str(progress.call("get_checkpoint_id", LEVEL_ID))
		if not str(progress.get("last_error")).is_empty():
			push_warning("W1-L2: progresso persistente indisponível (%s)." % str(progress.get("last_error")))
		if saved_checkpoint_id == String(_checkpoint.checkpoint_id):
			_checkpoint.restore_activation()
			_respawn_position = _checkpoint.get_respawn_position()
	_player.respawn(_respawn_position)


func configure_camera(camera: Camera2D) -> void:
	camera.limit_left = CAMERA_LIMITS.position.x
	camera.limit_top = CAMERA_LIMITS.position.y
	camera.limit_right = CAMERA_LIMITS.end.x
	camera.limit_bottom = CAMERA_LIMITS.end.y
	camera.limit_smoothed = true


func _on_player_defeated() -> void:
	_hud.show_result("BOLT foi derrotado")


func _on_checkpoint_activated(_checkpoint_id: StringName, respawn_position: Vector2) -> void:
	_respawn_position = respawn_position
	var progress: Node = _campaign_progress()
	if progress == null or not bool(progress.call("save_checkpoint", LEVEL_ID, String(_checkpoint.checkpoint_id))):
		var reason: String = "autoload ausente" if progress == null else str(progress.get("last_error"))
		push_warning("W1-L2: não foi possível persistir checkpoint (%s)." % reason)
	_hud.show_progress_notification("CHECKPOINT ATIVADO")


func _on_energy_gate_state_changed(active: bool) -> void:
	_hud.show_progress_notification("CAMPO ENERGÉTICO ATIVO" if active else "JANELA DE ENERGIA")


func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body == _player:
		_player.respawn(_respawn_position)


func _on_goal_body_entered(body: Node2D) -> void:
	if body == _player and not _section_finished:
		_section_finished = true
		var progress: Node = _campaign_progress()
		if progress == null or not bool(progress.call("mark_level_completed", LEVEL_ID)):
			var reason: String = "autoload ausente" if progress == null else str(progress.get("last_error"))
			push_warning("W1-L2: não foi possível persistir a conclusão (%s)." % reason)
		_hud.show_result("Cybercore — Rede Interrompida concluída")
