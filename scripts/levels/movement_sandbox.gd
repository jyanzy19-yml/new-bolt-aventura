extends Node2D
## SANDBOX DE MOVIMENTO — cena de desenvolvimento para exercitar controles, física e câmera.
##
## NÃO é uma fase da campanha: não corresponde a nenhum ID W#-L# do tracker e não deve ser
## contada como fase implementada. Geometria em múltiplos de 32 px (unidade de trabalho
## provisória): degraus de 1–3 unidades, vão de 4 (pulo), vão de 7 (pulo duplo/dash) e um
## ressalto alto (pulo duplo).

const LEVEL_PATH: String = "res://scenes/levels/sandbox/movement_sandbox.tscn"
## Limites de câmera (px). O mundo vai de x=0 a x=2560.
const CAMERA_LIMITS: Rect2i = Rect2i(0, -432, 2560, 700)

@onready var _player: BoltPlayer = %Bolt
@onready var _spawn: Marker2D = %SpawnPoint
@onready var _kill_zone: Area2D = %KillZone
@onready var _checkpoint: BoltCheckpoint = %Checkpoint
@onready var _goal: Area2D = %Goal
@onready var _hud: Hud = %Hud

var _completed: bool = false
var _respawn_position: Vector2 = Vector2.ZERO


func _ready() -> void:
	var camera: Camera2D = _player.get_camera()
	camera.limit_left = CAMERA_LIMITS.position.x
	camera.limit_top = CAMERA_LIMITS.position.y
	camera.limit_right = CAMERA_LIMITS.end.x
	camera.limit_bottom = CAMERA_LIMITS.end.y
	_hud.bind_player(_player)
	_hud.set_restart_path(LEVEL_PATH)
	_kill_zone.body_entered.connect(_on_kill_zone_body_entered)
	_checkpoint.activated.connect(_on_checkpoint_activated)
	_goal.body_entered.connect(_on_goal_body_entered)
	_respawn_position = _spawn.global_position
	_player.respawn(_respawn_position)


func _on_checkpoint_activated(_checkpoint_id: StringName, respawn_position: Vector2) -> void:
	# O ponto ativo é estado da sessão da sandbox; persistência entre execuções virá com SaveSystem.
	_respawn_position = respawn_position


func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body == _player:
		_player.respawn(_respawn_position)


func _on_goal_body_entered(body: Node2D) -> void:
	if body == _player and not _completed:
		_completed = true
		_hud.show_result("Sandbox concluída")
