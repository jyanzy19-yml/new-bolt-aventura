class_name BoltCheckpoint
extends Area2D
## Ponto de retorno reutilizável. A ativação é local à sessão; não grava progresso persistente.

signal activated(checkpoint_id: StringName, respawn_position: Vector2)

@export var checkpoint_id: StringName = &"checkpoint"
@export var respawn_offset: Vector2 = Vector2(0.0, -24.0)

@onready var _indicator: Polygon2D = %Indicator

var _is_activated: bool = false


func _ready() -> void:
	collision_layer = 0
	collision_mask = 2  # player
	body_entered.connect(_on_body_entered)


func activate() -> void:
	if _is_activated:
		return
	_is_activated = true
	_indicator.color = Color(0.35, 1.0, 0.68, 1.0)
	activated.emit(checkpoint_id, get_respawn_position())


func get_respawn_position() -> Vector2:
	return global_position + respawn_offset


func _on_body_entered(body: Node2D) -> void:
	if body is BoltPlayer:
		activate()
