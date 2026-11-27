class_name AlternatingPlatform
extends PlatformBlock
## Plataforma cíclica de laboratório. A transição de saída é avisada antes de perder
## colisão; a reativação também recebe um estado visual próprio antes de ficar sólida.

signal state_changed(state: State)

enum State { ACTIVE, WARNING_OFF, INACTIVE, WARNING_ON }

@export_range(0.2, 8.0, 0.05) var active_duration: float = 2.2
@export_range(0.1, 3.0, 0.05) var warning_duration: float = 0.65
@export_range(0.2, 8.0, 0.05) var inactive_duration: float = 1.4
@export_range(0.1, 3.0, 0.05) var reactivation_warning_duration: float = 0.65
@export var initial_active: bool = true

var _state: State = State.ACTIVE
var _state_time_left: float = 0.0
var _base_fill_color: Color
var _base_top_color: Color


func _ready() -> void:
	super._ready()
	_base_fill_color = fill_color
	_base_top_color = top_color
	set_physics_process(true)
	_enter_state(State.ACTIVE if initial_active else State.INACTIVE)


func _physics_process(delta: float) -> void:
	_state_time_left -= delta
	if _state_time_left <= 0.0:
		_advance_state()


func get_state() -> State:
	return _state


func is_solid() -> bool:
	return _state == State.ACTIVE or _state == State.WARNING_OFF


func _advance_state() -> void:
	match _state:
		State.ACTIVE:
			_enter_state(State.WARNING_OFF)
		State.WARNING_OFF:
			_enter_state(State.INACTIVE)
		State.INACTIVE:
			_enter_state(State.WARNING_ON)
		State.WARNING_ON:
			_enter_state(State.ACTIVE)


func _enter_state(next_state: State) -> void:
	_state = next_state
	match _state:
		State.ACTIVE:
			_shape_node.set_deferred("disabled", false)
			_set_visual(_base_fill_color, _base_top_color)
			_state_time_left = active_duration
		State.WARNING_OFF:
			_shape_node.set_deferred("disabled", false)
			_set_visual(Color(0.32, 0.22, 0.08, 1.0), Color(1.0, 0.68, 0.12, 1.0))
			_state_time_left = warning_duration
		State.INACTIVE:
			_shape_node.set_deferred("disabled", true)
			_set_visual(Color(0.035, 0.07, 0.12, 0.55), Color(0.12, 0.24, 0.34, 0.35))
			_state_time_left = inactive_duration
		State.WARNING_ON:
			_shape_node.set_deferred("disabled", true)
			_set_visual(Color(0.08, 0.2, 0.3, 0.8), Color(0.18, 0.92, 1.0, 1.0))
			_state_time_left = reactivation_warning_duration
	state_changed.emit(_state)


func _set_visual(fill: Color, top: Color) -> void:
	fill_color = fill
	top_color = top
	queue_redraw()
