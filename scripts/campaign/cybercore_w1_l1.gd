extends Node2D
## W1-L1 — Cybercore. Blockout de campanha com inimigo-base provisório.

const LEVEL_PATH: String = "res://scenes/campaign/cybercore_w1_l1.tscn"
const CAMERA_LIMITS: Rect2i = Rect2i(0, -360, 2200, 620)

@onready var _player: BoltPlayer = %Bolt
@onready var _spawn: Marker2D = %SpawnPoint
@onready var _kill_zone: Area2D = %KillZone
@onready var _checkpoint: BoltCheckpoint = %Checkpoint
@onready var _health_pickup: BoltHealthPickup = %HealthPickup
@onready var _goal: Area2D = %Goal
@onready var _hud: Hud = %Hud

var _respawn_position: Vector2 = Vector2.ZERO
var _section_finished: bool = false


func _ready() -> void:
	var camera: Camera2D = _player.get_camera()
	camera.limit_left = CAMERA_LIMITS.position.x
	camera.limit_top = CAMERA_LIMITS.position.y
	camera.limit_right = CAMERA_LIMITS.end.x
	camera.limit_bottom = CAMERA_LIMITS.end.y
	_hud.bind_player(_player)
	_hud.set_restart_path(LEVEL_PATH)
	_player.defeated.connect(_on_player_defeated)
	_kill_zone.body_entered.connect(_on_kill_zone_body_entered)
	_checkpoint.activated.connect(_on_checkpoint_activated)
	_health_pickup.collected.connect(_on_health_pickup_collected)
	_goal.body_entered.connect(_on_goal_body_entered)
	_respawn_position = _spawn.global_position
	_player.respawn(_respawn_position)


func _on_player_defeated() -> void:
	_hud.show_result("BOLT foi derrotado")


func _on_checkpoint_activated(_checkpoint_id: StringName, respawn_position: Vector2) -> void:
	_respawn_position = respawn_position
	_hud.show_progress_notification("CHECKPOINT ATIVADO")


func _on_health_pickup_collected(amount: int) -> void:
	_hud.show_progress_notification("RECUPERAÇÃO +%d" % amount)


func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body == _player:
		_player.respawn(_respawn_position)


func _on_goal_body_entered(body: Node2D) -> void:
	if body == _player and not _section_finished:
		_section_finished = true
		_hud.show_result("Cybercore — trecho inicial concluído")
