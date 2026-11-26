class_name BoltHealth
extends Node
## Componente reutilizável de vida. Não conhece HUD, player, inimigo ou origem do dano.

signal health_changed(current_health: int, max_health: int)
signal depleted

@export_range(1, 999, 1) var max_health: int = 1

var current_health: int = 1


func _ready() -> void:
	current_health = maxi(1, max_health)
	health_changed.emit(current_health, current_health)


func apply_damage(amount: int) -> bool:
	if amount <= 0 or current_health <= 0:
		return false
	current_health = maxi(0, current_health - amount)
	health_changed.emit(current_health, maxi(1, max_health))
	if current_health == 0:
		depleted.emit()
	return true


func restore_full() -> void:
	current_health = maxi(1, max_health)
	health_changed.emit(current_health, current_health)
