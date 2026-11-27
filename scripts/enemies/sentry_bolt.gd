class_name SentryBolt
extends Area2D
## Projétil lento da Sentinela de Cybercore (PROPOSTA). Move-se em linha reta, causa dano ao
## jogador e some ao tocar o jogador ou o cenário. É propositalmente lento e pequeno: legível em
## tela de celular, sem ocultar plataformas, e evitável por salto, dash ou abrigo.

signal expired

@export var speed: float = 170.0
@export var damage: int = 1
@export var lifetime: float = 3.0

var _direction: int = -1
var _remaining: float = 0.0


func _ready() -> void:
	collision_layer = 0
	collision_mask = 3  # mundo (1) + jogador (2)
	_remaining = lifetime
	body_entered.connect(_on_body_entered)


func configure(direction: int, bolt_speed: float, bolt_damage: int) -> void:
	_direction = -1 if direction < 0 else 1
	speed = maxf(1.0, bolt_speed)
	damage = maxi(1, bolt_damage)
	scale.x = float(_direction)


func _physics_process(delta: float) -> void:
	global_position.x += float(_direction) * speed * delta
	_remaining -= delta
	if _remaining <= 0.0:
		_finish()


func _on_body_entered(body: Node2D) -> void:
	if body is BoltPlayer:
		(body as BoltPlayer).take_damage(damage, float(_direction))
	_finish()


func _finish() -> void:
	set_physics_process(false)
	expired.emit()
	queue_free()
