class_name BoltCombat
extends Node
## Controlador da arma básica Pistola Crono. Valores exportados são provisórios, não balanceamento final.

@export var projectile_scene: PackedScene
@export_range(0.05, 1.5, 0.01) var attack_cooldown: float = 0.30
@export_range(1, 10, 1) var projectile_damage: int = 1
@export_range(100.0, 1600.0, 10.0) var projectile_speed: float = 720.0
@export_range(0.1, 4.0, 0.1) var projectile_lifetime: float = 1.4

var _player: BoltPlayer
var _buffer: ActionBuffer
var _cooldown_left: float = 0.0
var _enabled: bool = true


func _ready() -> void:
	_player = get_parent() as BoltPlayer
	if _player == null:
		push_error("BoltCombat precisa ser filho de BoltPlayer.")
		set_physics_process(false)
		return
	_buffer = _player.get_node("%ActionBuffer") as ActionBuffer


func set_enabled(enabled: bool) -> void:
	_enabled = enabled
	if _buffer != null:
		_buffer.clear()


## Reinicia o estado transitório de combate ao recuperar BOLT após derrota/respawn.
func reset_for_respawn() -> void:
	_cooldown_left = 0.0
	set_enabled(true)


func _physics_process(delta: float) -> void:
	if not _enabled or _player == null or not _player.is_physics_processing():
		return
	_cooldown_left = maxf(0.0, _cooldown_left - delta)
	if _cooldown_left > 0.0 or not _buffer.consume(Actions.ATTACK, 0.16):
		return
	_fire()


func _fire() -> void:
	if projectile_scene == null:
		push_error("BoltCombat: cena do projétil não configurada.")
		return
	var projectile: ChronoProjectile = projectile_scene.instantiate() as ChronoProjectile
	if projectile == null:
		push_error("BoltCombat: recurso configurado não é ChronoProjectile.")
		return
	var level_root: Node = _player.get_parent()
	if level_root == null:
		projectile.free()
		return
	level_root.add_child(projectile)
	projectile.global_position = _player.global_position + Vector2(26.0 * float(_player.facing), -4.0)
	projectile.configure(_player.facing, projectile_speed, projectile_damage, projectile_lifetime)
	_cooldown_left = attack_cooldown
