class_name BoltPlayer
extends CharacterBody2D
## BOLT — controlador de movimento (SYS-005/SYS-006, parcial).
##
## Estados explícitos: GROUNDED, RISING, FALLING, DASHING. Todo movimento roda em
## `_physics_process` (tick fixo de 60 Hz), independente da taxa de renderização. A entrada é
## lida como AÇÕES lógicas; bordas de pressionar vêm do ActionBuffer (não se perdem em quedas
## momentâneas de FPS).
##
## Implementado: corrida com aceleração, pulo normal/variável/duplo, coyote time, buffer de
## pulo, controle aéreo e dash (um dash aéreo até pousar). NÃO implementado: wall slide/jump,
## dano/knockback, combate, animação final. Valores: ver BoltTuning (provisórios).
## Regra provisória: pulo é ignorado durante o dash (registrado em docs).

signal state_changed(new_state: State)
## 1.0 = dash pronto; menor que 1.0 = recarregando (valor = progresso).
signal dash_cooldown_changed(ratio: float)
signal respawned

enum State { GROUNDED, RISING, FALLING, DASHING }

@export var tuning: BoltTuning

var state: State = State.GROUNDED
## +1 direita, -1 esquerda.
var facing: int = 1

@onready var _buffer: ActionBuffer = %ActionBuffer
@onready var _visual: Node2D = %PlaceholderVisual
@onready var _camera: Camera2D = %Camera

var _coyote_left: float = 0.0
var _air_jumps_left: int = 0
var _jump_cut_applied: bool = false
var _dash_time_left: float = 0.0
var _dash_cooldown_left: float = 0.0
var _dash_direction: int = 1
var _air_dash_available: bool = true
var _last_dash_ratio: float = 1.0
var _emitted_state: State = State.GROUNDED


func _ready() -> void:
	if tuning == null:
		tuning = load("res://resources/player/bolt_tuning_provisional.tres") as BoltTuning
	_air_jumps_left = tuning.air_jumps


func _notification(what: int) -> void:
	# Pausa/retomada: nenhum pressionamento antigo pode disparar ação ao voltar.
	if what == NOTIFICATION_PAUSED or what == NOTIFICATION_UNPAUSED:
		if _buffer != null:
			_buffer.clear()


## Câmera do jogador (para o nível definir limites).
func get_camera() -> Camera2D:
	return _camera


## Reposiciona BOLT e zera todo o estado transitório (queda no vazio, início de fase).
func respawn(at: Vector2) -> void:
	global_position = at
	velocity = Vector2.ZERO
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
	else:
		if _can_dash(on_floor) and _buffer.consume(Actions.DASH, tuning.dash_buffer):
			_start_dash(direction, on_floor)
			_physics_dash(delta)
		else:
			_physics_move(delta, direction, on_floor)
	_update_state()


func _physics_move(delta: float, direction: float, on_floor: bool) -> void:
	# Horizontal.
	var target: float = direction * tuning.run_speed
	var accel: float
	if direction == 0.0:
		accel = tuning.ground_decel if on_floor else tuning.air_decel
	else:
		accel = tuning.ground_accel if on_floor else tuning.ground_accel * tuning.air_control
	velocity.x = move_toward(velocity.x, target, accel * delta)

	# Pulo (coyote para o primeiro salto; pulos aéreos consomem `_air_jumps_left`).
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

	# Pulo variável: soltar durante a subida (inclusive um toque que já terminou) corta a altura.
	if velocity.y < 0.0 and not _jump_cut_applied and not Input.is_action_pressed(Actions.JUMP):
		velocity.y *= tuning.jump_cut_multiplier
		_jump_cut_applied = true

	# Gravidade (mais forte na queda).
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
		state = State.FALLING  # saída do dash; _update_state() escolhe o estado real e notifica


func _update_state() -> void:
	if state == State.DASHING:
		return
	if is_on_floor():
		_set_state(State.GROUNDED)
	elif velocity.y < 0.0:
		_set_state(State.RISING)
	else:
		_set_state(State.FALLING)


## Atualiza `state` e notifica somente quando o estado visível ao exterior muda.
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
