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
	# Clamp the final physics step to the active patrol endpoint. Reversing
	# only after crossing the endpoint permits visible overshoot at high speed.
	var direction_sign: float = -1.0 if _direction < 0.0 else 1.0
	var patrol_extent: float = maxf(0.0, patrol_distance)
	var target_x: float = _origin_x + patrol_extent * direction_sign
	var remaining_distance: float = (target_x - global_position.x) * direction_sign
	var safe_delta: float = maxf(delta, 0.000001)
	var maximum_step: float = maxf(0.0, patrol_speed) * maxf(delta, 0.0)

	if remaining_distance <= 0.001:
		velocity.x = 0.0
		_direction = -direction_sign
	elif maximum_step >= remaining_distance:
		velocity.x = direction_sign * remaining_distance / safe_delta
		_direction = -direction_sign
	else:
		velocity.x = direction_sign * maxf(0.0, patrol_speed)
	velocity.y = 0.0
	move_and_slide()


func _on_contact_body_entered(body: Node2D) -> void:
	# A defeated enemy can remain in the physics tree until queue_free is flushed.
	# Ignore any late overlap callback after its active lifecycle has ended.
	if not _active or not body is BoltPlayer:
		return
	var player: BoltPlayer = body as BoltPlayer
	var knockback_direction: float = signf(player.global_position.x - global_position.x)
	player.take_damage(contact_damage, knockback_direction)


func _on_depleted() -> void:
	if not _active:
		return
	_active = false
	defeated.emit()
	queue_free()
