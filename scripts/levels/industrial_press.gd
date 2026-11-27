class_name IndustrialPress
extends Area2D
## Prensa industrial cíclica. O aviso antecede o golpe; a área de dano só fica ativa
## durante a descida. A máquina de estados usa delta físico fixo e respeita a pausa da SceneTree.

signal state_changed(state: State)

enum State { WARNING, ACTIVE, RECOVERY }

@export_range(0.1, 5.0, 0.05) var warning_duration: float = 0.9
@export_range(0.05, 2.0, 0.05) var active_duration: float = 0.35
@export_range(0.1, 5.0, 0.05) var recovery_duration: float = 1.2
@export_range(1, 10, 1) var contact_damage: int = 1
@export_range(24.0, 120.0, 1.0) var press_travel: float = 56.0

var _state: State = State.WARNING
var _state_time_left: float = 0.0

@onready var _head: Polygon2D = %Head
@onready var _strike_zone: CollisionShape2D = %StrikeZone


func _ready() -> void:
	collision_layer = 0
	collision_mask = 2
	monitoring = true
	set_physics_process(true)
	body_entered.connect(_on_body_entered)
	_strike_zone.disabled = true
	_enter_state(State.WARNING)


func _physics_process(delta: float) -> void:
	_state_time_left -= delta
	if _state_time_left <= 0.0:
		_on_cycle_timeout()


func get_state() -> State:
	return _state


func is_active() -> bool:
	return _state == State.ACTIVE


func _on_cycle_timeout() -> void:
	match _state:
		State.WARNING:
			_enter_state(State.ACTIVE)
		State.ACTIVE:
			_enter_state(State.RECOVERY)
		State.RECOVERY:
			_enter_state(State.WARNING)


func _enter_state(next_state: State) -> void:
	_state = next_state
	match _state:
		State.WARNING:
			_strike_zone.set_deferred("disabled", true)
			_head.position.y = -press_travel
			_head.color = Color(1.0, 0.72, 0.18, 1.0)
			_state_time_left = warning_duration
		State.ACTIVE:
			_head.position.y = -12.0
			_head.color = Color(1.0, 0.22, 0.18, 1.0)
			_strike_zone.set_deferred("disabled", false)
			_state_time_left = active_duration
		State.RECOVERY:
			_strike_zone.set_deferred("disabled", true)
			_head.position.y = -press_travel
			_head.color = Color(0.22, 0.78, 1.0, 0.72)
			_state_time_left = recovery_duration
	state_changed.emit(_state)


func _on_body_entered(body: Node2D) -> void:
	if _state != State.ACTIVE or not body is BoltPlayer:
		return
	var player: BoltPlayer = body as BoltPlayer
	var knockback_direction: float = signf(player.global_position.x - global_position.x)
	player.take_damage(contact_damage, knockback_direction)
