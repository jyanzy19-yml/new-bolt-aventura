extends Node2D
## SANDBOX DE MOVIMENTO — cena de desenvolvimento para exercitar controles, física e câmera.
##
## NÃO é uma fase da campanha: não corresponde a nenhum ID W#-L# do tracker e não deve ser
## contada como fase implementada. Geometria em múltiplos de 32 px (unidade de trabalho
## provisória): degraus de 1–3 unidades, vão de 4 (pulo), vão de 7 (pulo duplo/dash) e um
## ressalto alto (pulo duplo).

const LEVEL_PATH: String = "res://scenes/levels/sandbox/movement_sandbox.tscn"
## ID de desenvolvimento (namespace "dev."): NÃO é um ID de fase da campanha (W#-L#).
const LEVEL_ID: String = "dev.movement_sandbox"
## Limites de câmera (px). O mundo vai de x=0 a x=2560.
const CAMERA_LIMITS: Rect2i = Rect2i(0, -432, 2560, 700)

@onready var _player: BoltPlayer = %Bolt
@onready var _spawn: Marker2D = %SpawnPoint
@onready var _kill_zone: Area2D = %KillZone
@onready var _goal: Area2D = %Goal
@onready var _hud: Hud = %Hud

var _session: LevelSession


func _ready() -> void:
	var camera: Camera2D = _player.get_camera()
	camera.limit_left = CAMERA_LIMITS.position.x
	camera.limit_top = CAMERA_LIMITS.position.y
	camera.limit_right = CAMERA_LIMITS.end.x
	camera.limit_bottom = CAMERA_LIMITS.end.y
	_hud.bind_player(_player)
	_hud.set_restart_path(LEVEL_PATH)
	_kill_zone.body_entered.connect(_on_kill_zone_body_entered)
	_goal.body_entered.connect(_on_goal_body_entered)
	_session = LevelSession.new()
	add_child(_session)
	var checkpoints: Array[Checkpoint] = []
	for node: Node in get_tree().get_nodes_in_group(&"checkpoint"):
		if node is Checkpoint and is_ancestor_of(node):
			checkpoints.append(node)
	_session.start(LEVEL_ID, _player, _spawn.global_position, checkpoints)


func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body == _player:
		_session.respawn_player()


func _on_goal_body_entered(body: Node2D) -> void:
	if body == _player:
		# Idempotente: o objetivo só conclui (e grava) uma vez por sessão.
		_session.complete()
		_hud.show_result("Sandbox concluída")
