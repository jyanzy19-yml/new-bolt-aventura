class_name BoltTrainingTarget
extends StaticBody2D
## Alvo estático de treinamento. Não representa um arquétipo de inimigo da campanha.

signal defeated

@onready var _health: BoltHealth = %Health


func _ready() -> void:
	_health.depleted.connect(_on_health_depleted)


func apply_damage(amount: int) -> void:
	_health.apply_damage(amount)


func _on_health_depleted() -> void:
	defeated.emit()
	queue_free()
