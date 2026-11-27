class_name ChronoProjectile
extends Area2D
## Projétil da Pistola Crono. Velocidade, dano e alcance são parâmetros de protótipo.

@export var speed: float = 720.0
@export var damage: int = 1
@export var lifetime: float = 1.4

var _direction: int = 1
var _remaining_lifetime: float = 0.0
var _spent: bool = false


func _ready() -> void:
	_remaining_lifetime = lifetime
	body_entered.connect(_on_body_entered)


func configure(direction: int, shot_speed: float, shot_damage: int, shot_lifetime: float) -> void:
	_direction = -1 if direction < 0 else 1
	speed = maxf(1.0, shot_speed)
	damage = maxi(1, shot_damage)
	lifetime = maxf(0.05, shot_lifetime)
	_remaining_lifetime = lifetime


func _physics_process(delta: float) -> void:
	if _spent:
		return
	global_position.x += float(_direction) * speed * delta
	_remaining_lifetime -= delta
	if _remaining_lifetime <= 0.0:
		_spent = true
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if _spent:
		return
	# queue_free() só remove o Node ao fim do frame; o guard evita impactos duplicados.
	_spent = true
	if body.has_method("apply_damage"):
		body.call("apply_damage", damage)
	queue_free()
