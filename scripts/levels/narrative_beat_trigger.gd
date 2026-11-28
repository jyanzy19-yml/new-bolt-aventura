class_name NarrativeBeatTrigger
extends Area2D
## Emissor de beat por ID. Não contém diálogo nem altera o save; o sistema narrativo
## pode consumir o sinal sem acoplar texto/canon à cena da fase.

signal beat_requested(beat_id: StringName)

@export var beat_id: StringName
@export var one_shot: bool = true

var _fired: bool = false


func _ready() -> void:
	collision_layer = 0
	collision_mask = 2
	body_entered.connect(_on_body_entered)


func has_fired() -> bool:
	return _fired


func _on_body_entered(body: Node2D) -> void:
	if not body is BoltPlayer or (one_shot and _fired):
		return
	if String(beat_id).is_empty():
		push_warning("NarrativeBeatTrigger: beat_id vazio; evento ignorado.")
		return
	_fired = true
	beat_requested.emit(beat_id)
