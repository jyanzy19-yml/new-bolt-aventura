class_name BoltHealthPickup
extends Area2D
## Coletável de recuperação. Cura apenas BOLT e não é consumido se a vida já estiver cheia.

signal collected(amount: int)

@export_range(1, 10, 1) var heal_amount: int = 1

var _available: bool = true


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if not _available or not body is BoltPlayer:
		return
	var player: BoltPlayer = body as BoltPlayer
	if not player.heal(heal_amount):
		return
	_available = false
	monitoring = false
	visible = false
	collected.emit(heal_amount)
	queue_free()
