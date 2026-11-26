class_name CybercorePatrolEnemy
extends CharacterBody2D
## Inimigo-base provisório de Cybercore: patrulha simples, contato e vida.
## Não representa ainda um arquétipo canônico nem IA final.

signal defeated

@export_range(10.0, 300.0, 5.0) var patrol_speed: float = 70.0
@export_range(20.0, 400.0, 5.0) var patrol_distance: float = 120.0
@export_range(1, 20, 1) var contact_damage: int = 1

var _origin_x: float = 0.0
var _direction: float = 1.0
var _active: bool = true

@onready var _health: BoltHealth = %Health
@onready var _contact_area: Area2D = %ContactArea


func _ready() -> void:
	_origin_x = global_position.x
	_health.depleted.connect(_on_depleted)
	_contact_area.body_entered.connect(_on_contact_body_entered)


func apply_damage(amount: int) -> void:
	if _active:
		_health.apply_damage(amount)


func _physics_process(_delta: float) -> void:
	if not _active:
		return
	if global_position.x >= _origin_x + patrol_distance:
		_direction = -1.0
	elif global_position.x <= _origin_x - patrol_distance:
		_direction = 1.0
	velocity.x = _direction * patrol_speed
	velocity.y = 0.0
	move_and_slide()


func _on_contact_body_entered(body: Node2D) -> void:
	if body is BoltPlayer:
		var player: BoltPlayer = body as BoltPlayer
		var knockback_direction: float = signf(player.global_position.x - global_position.x)
		player.take_damage(contact_damage, knockback_direction)


func _on_depleted() -> void:
	if not _active:
		return
	_active = false
	defeated.emit()
	queue_free()
