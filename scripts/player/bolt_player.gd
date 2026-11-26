class_name BoltPlayer
extends CharacterBody2D
## Controlador de movimento e estado vital de BOLT.
## Movimento e dano são processados no tick fixo; valores de combate são provisórios.

signal state_changed(new_state: State)
signal dash_cooldown_changed(ratio: float)
signal respawned
signal health_changed(current_health: int, max_health: int)
signal defeated

enum State { GROUNDED, RISING, FALLING, DASHING }

@export var tuning: BoltTuning
@export_range(0.1, 3.0, 0.05) var damage_invulnerability: float = 0.9
@export_range(0.0, 1200.0, 10.0) var damage_knockback: float = 300.0

var state: State = State.GROUNDED
var facing: int = 1
var _coyote_left: float = 0.0
var _air_jumps_left: int = 0
var _jump_cut_applied: bool = false
var _dash_time_left: float = 0.0
var _dash_cooldown_left: float = 0.0
var _dash_direction: int = 1
var _air_dash_available: bool = true
var _last_dash_ratio: float = 1.0
var _emitted_state: State = State.GROUNDED
var _invulnerability_left: float = 0.0
var _is_defeated: bool = false

@onready var _buffer: ActionBuffer = %ActionBuffer
@onready var _visual: Node2D = %PlaceholderVisual
@onready var _camera: Camera2D = %Camera
@onready var _health: BoltHealth = %Health
@onready var _combat: BoltCombat = %Combat


func _ready() -> void:
	if tuning == null:
		tuning = load("res://resources/player/bolt_tuning_provisional.tres") as BoltTuning
	_air_jumps_left = tuning.air_jumps
	_health.health_changed.connect(_on_health_changed)
	_health.depleted.connect(_on_health_depleted)
	_on_health_changed(_health.current_health, _health.max_health)


func _notification(what: int) -> void:
	if what == NOTIFICATION_PAUSED or what == NOTIFICATION_UNPAUSED:
		if _buffer != null:
			_buffer.clear()


func get_camera() -> Camera2D:
	return _camera


func take_damage(amount: int, knockback_direction: float = 0.0) -> bool:
	if amount <= 0 or _is_defeated or _invulnerability_left > 0.0:
		return false
	if not _health.apply_damage(amount):
		return false
	_invulnerability_left = damage_invulnerability
	var direction: float = signf(knockback_direction)
	if is_zero_approx(direction):
		direction = -float(facing)
	velocity = Vector2(direction * damage_knockback, -damage_knockback * 0.35)
	return true


func respawn(at: Vector2) -> void:
	global_position = at
	velocity = Vector2.ZERO
	_is_defeated = false
	_invulnerability_left = 0.0
	_health.restore_full()
	_combat.set_enabled(true)
	set_physics_process(true)
	_visual.modulate = Color.WHITE
	_set_state(State.GROUNDED)
	_coyote_left = 0.0
	_air_jumps_left = tuning.air_jumps
	_jump_cut_applied = false
	_dash_time_left = 0.0
	_dash_cooldown_left = 0.0
	_air_dash_available = true
	_buffer.clear()
	_emit_dash_ratio()
	if _camera != null:
		_camera.reset_smoothing()
	respawned.emit()


func _physics_process(delta: float) -> void:
	if _invulnerability_left > 0.0:
		_invulnerability_left = maxf(0.0, _invulnerability_left - delta)
		_visual.modulate = Color(1.0, 1.0, 1.0, 0.45 if int(_invulnerability_left * 18.0) % 2 == 0 else 1.0)
	else:
		_visual.modulate = Color.WHITE

	var direction: float = Input.get_axis(Actions.MOVE_LEFT, Actions.MOVE_RIGHT)
	if direction != 0.0:
		facing = 1 if direction > 0.0 else -1
		_visual.scale.x = float(facing)

	_dash_cooldown_left = maxf(0.0, _dash_cooldown_left - delta)
	_emit_dash_ratio()
	var on_floor: bool = is_on_floor()
	if on_floor:
		_coyote_left = tuning.coyote_time
		_air_jumps_left = tuning.air_jumps
		_air_dash_available = true
		_jump_cut_applied = false
	else:
		_coyote_left = maxf(0.0, _coyote_left - delta)

	if state == State.DASHING:
		_physics_dash(delta)
	elif _can_dash(on_floor) and _buffer.consume(Actions.DASH, tuning.dash_buffer):
		_start_dash(direction, on_floor)
		_physics_dash(delta)
	else:
		_physics_move(delta, direction, on_floor)
	_update_state()


func _physics_move(delta: float, direction: float, on_floor: bool) -> void:
	var target: float = direction * tuning.run_speed
	var accel: float
	if direction == 0.0:
		accel = tuning.ground_decel if on_floor else tuning.air_decel
	else:
		accel = tuning.ground_accel if on_floor else tuning.ground_accel * tuning.air_control
	velocity.x = move_toward(velocity.x, target, accel * delta)

	var can_ground_jump: bool = on_floor or _coyote_left > 0.0
	var can_air_jump: bool = _air_jumps_left > 0
	if (can_ground_jump or can_air_jump) and _buffer.consume(Actions.JUMP, tuning.jump_buffer):
		if can_ground_jump:
			velocity.y = -tuning.jump_velocity()
			_coyote_left = 0.0
		else:
			_air_jumps_left -= 1
			velocity.y = -tuning.jump_velocity() * tuning.air_jump_multiplier
		_jump_cut_applied = false

	if velocity.y < 0.0 and not _jump_cut_applied and not Input.is_action_pressed(Actions.JUMP):
		velocity.y *= tuning.jump_cut_multiplier
		_jump_cut_applied = true

	var gravity: float = tuning.gravity()
	if velocity.y > 0.0:
		gravity *= tuning.fall_gravity_multiplier
	velocity.y = minf(velocity.y + gravity * delta, tuning.max_fall_speed)
	move_and_slide()


func _can_dash(on_floor: bool) -> bool:
	return _dash_cooldown_left <= 0.0 and (on_floor or _air_dash_available)


func _start_dash(direction: float, on_floor: bool) -> void:
	_dash_direction = int(signf(direction)) if direction != 0.0 else facing
	facing = _dash_direction
	_visual.scale.x = float(facing)
	_dash_time_left = tuning.dash_duration
	_dash_cooldown_left = tuning.dash_cooldown
	if not on_floor:
		_air_dash_available = false
	_set_state(State.DASHING)


func _physics_dash(delta: float) -> void:
	_dash_time_left -= delta
	velocity = Vector2(float(_dash_direction) * tuning.dash_speed, 0.0)
	move_and_slide()
	if _dash_time_left <= 0.0 or is_on_wall():
		_dash_time_left = 0.0
		velocity.x = float(_dash_direction) * tuning.run_speed
		state = State.FALLING


func _update_state() -> void:
	if state == State.DASHING:
		return
	if is_on_floor():
		_set_state(State.GROUNDED)
	elif velocity.y < 0.0:
		_set_state(State.RISING)
	else:
		_set_state(State.FALLING)


func _set_state(next: State) -> void:
	state = next
	if next != _emitted_state:
		_emitted_state = next
		state_changed.emit(next)


func _emit_dash_ratio() -> void:
	var ratio: float = 1.0
	if tuning.dash_cooldown > 0.0:
		ratio = 1.0 - clampf(_dash_cooldown_left / tuning.dash_cooldown, 0.0, 1.0)
	if not is_equal_approx(ratio, _last_dash_ratio):
		_last_dash_ratio = ratio
		dash_cooldown_changed.emit(ratio)


func _on_health_changed(current: int, maximum: int) -> void:
	health_changed.emit(current, maximum)


func _on_health_depleted() -> void:
	if _is_defeated:
		return
	_is_defeated = true
	velocity = Vector2.ZERO
	_buffer.clear()
	_combat.set_enabled(false)
	set_physics_process(false)
	defeated.emit()
