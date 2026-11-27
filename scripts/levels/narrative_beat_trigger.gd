class_name NarrativeBeatTrigger
extends Area2D
## Gatilho de uma única vez que apenas ANUNCIA um beat narrativo por ID. Não contém diálogo nem
## conteúdo de canon: o consumidor (cutscene/diálogo) ainda não existe. Não persiste flags.

signal beat_requested(beat_id: StringName)

@export var beat_id: StringName = &""

var _fired: bool = false


func _ready() -> void:
	collision_layer = 0
	collision_mask = 2
	body_entered.connect(_on_body_entered)


func has_fired() -> bool:
	return _fired


func _on_body_entered(body: Node2D) -> void:
	if _fired or not body is BoltPlayer:
		return
	_fired = true
	beat_requested.emit(beat_id)
