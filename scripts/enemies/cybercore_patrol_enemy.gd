class_name CybercorePatrolEnemy
extends CharacterBody2D
## Inimigo-base provisório de Cybercore: patrulha simples, contato e vida.
## Não representa ainda um arquétipo canônico nem IA final.

signal defeated
signal hit_received(remaining_health: int)

@export_range(10.0, 300.0, 5.0) var patrol_speed: float = 70.0
@export_range(20.0, 400.0, 5.0) var patrol_distance: float = 120.0
@export_range(1, 20, 1) var contact_damage: int = 1
@export_range(0.03, 0.5, 0.01) var hit_flash_duration: float = 0.12

var _origin_x: float = 0.0
var _direction: float = 1.0
var _active: bool = true
var _hit_flash_left: float = 0.0
var _base_visual_color: Color = Color.WHITE

@onready var _health: BoltHealth = %Health
@onready var _visual: Polygon2D = %Visual
@onready var _contact_area: Area2D = %ContactArea


func _ready() -> void:
	_origin_x = global_position.x
	_health.depleted.connect(_on_depleted)
	_base_visual_color = _visual.color
	_contact_area.body_entered.connect(_on_contact_body_entered)


func apply_damage(amount: int) -> void:
	if not _active or not _health.apply_damage(amount):
		return
	_hit_flash_left = hit_flash_duration
	_visual.color = Color(1.0, 0.92, 0.48, 1.0)
	hit_received.emit(_health.current_health)


func _physics_process(delta: float) -> void:
	if not _active:
		return
	if _hit_flash_left > 0.0:
		_hit_flash_left = maxf(0.0, _hit_flash_left - delta)
		if _hit_flash_left == 0.0:
			_visual.color = _base_visual_color
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
