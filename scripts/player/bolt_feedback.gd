class_name BoltFeedback
extends Node
## Feedback visual de BOLT: poeira de pouso, impulso de pulo, rastro de dash, tremor de câmera
## ao sofrer dano e antecipação da câmera na direção do movimento.
##
## SOMENTE apresentação: observa sinais e estado do `BoltPlayer` e nunca altera velocidade,
## estado, dano ou entrada. Remover este nó deixa a jogabilidade idêntica. Todos os valores são
## provisórios (feel não avaliado em aparelho).

## Velocidade de queda mínima (px/s) para gerar poeira de pouso.
@export var landing_min_speed: float = 240.0
## Antecipação horizontal da câmera (px) na direção em que BOLT olha.
@export var look_ahead: float = 56.0
@export var look_ahead_rate: float = 3.5
@export var shake_max_offset: float = 6.0
@export var shake_decay: float = 2.8
## Permite desligar câmera/tremor (acessibilidade / redução de movimento).
@export var camera_effects_enabled: bool = true
@export var dash_trail_interval: float = 0.035

## Contadores observáveis (úteis em testes e telemetria de desenvolvimento).
var landing_bursts: int = 0
var jump_bursts: int = 0
var dash_trail_bursts: int = 0
var damage_bursts: int = 0

var _player: BoltPlayer
var _camera: Camera2D
var _previous_state: BoltPlayer.State = BoltPlayer.State.GROUNDED
var _peak_fall_speed: float = 0.0
var _trail_clock: float = 0.0
var _trauma: float = 0.0
var _last_health: int = -1


func _ready() -> void:
	_player = get_parent() as BoltPlayer
	if _player == null:
		push_error("BoltFeedback precisa ser filho de BoltPlayer.")
		set_process(false)
		set_physics_process(false)
		return
	# Filhos ficam prontos ANTES do pai: `_player.get_camera()` ainda seria nulo aqui.
	_camera = _player.get_node_or_null("Camera") as Camera2D
	_player.state_changed.connect(_on_state_changed)
	_player.respawned.connect(_on_respawned)
	_player.health_changed.connect(_on_health_changed)


func _physics_process(delta: float) -> void:
	if _player.state == BoltPlayer.State.FALLING:
		_peak_fall_speed = maxf(_peak_fall_speed, _player.velocity.y)
	elif _player.state == BoltPlayer.State.DASHING:
		_trail_clock -= delta
		if _trail_clock <= 0.0:
			_trail_clock = dash_trail_interval
			dash_trail_bursts += 1
			Burst.spawn(_player.get_parent(), _player.global_position, Color(0.4, 0.95, 1.0, 0.9), 3, 40.0, 0.22,
					Vector2(-float(_player.facing), 0.0), 40.0, 9.0, 0.0)


func _process(delta: float) -> void:
	if _camera == null or not camera_effects_enabled:
		return
	var target_x: float = float(_player.facing) * look_ahead
	_camera.offset.x = lerpf(_camera.offset.x, target_x, 1.0 - exp(-look_ahead_rate * delta))
	_trauma = maxf(0.0, _trauma - shake_decay * delta)
	var shake: float = _trauma * _trauma * shake_max_offset
	_camera.offset.y = randf_range(-1.0, 1.0) * shake
	_camera.offset.x += randf_range(-1.0, 1.0) * shake


func _feet() -> Vector2:
	return _player.global_position + Vector2(0.0, 20.0)


func _on_state_changed(new_state: BoltPlayer.State) -> void:
	match new_state:
		BoltPlayer.State.GROUNDED:
			if _peak_fall_speed >= landing_min_speed:
				landing_bursts += 1
				var strength: float = clampf(_peak_fall_speed / 720.0, 0.3, 1.0)
				Burst.spawn(_player.get_parent(), _feet(), Color(0.55, 0.8, 0.95, 0.9), int(6.0 + 8.0 * strength),
						70.0 + 60.0 * strength, 0.4, Vector2.UP, 160.0, 6.5, 120.0)
			_peak_fall_speed = 0.0
		BoltPlayer.State.RISING:
			if _previous_state == BoltPlayer.State.GROUNDED:
				jump_bursts += 1
				Burst.spawn(_player.get_parent(), _feet(), Color(0.7, 0.9, 1.0, 0.8), 4, 60.0, 0.25, Vector2.DOWN, 100.0, 5.5, 40.0)
		BoltPlayer.State.DASHING:
			_trail_clock = 0.0
	_previous_state = new_state


func _on_respawned() -> void:
	_peak_fall_speed = 0.0
	_trauma = 0.0
	_last_health = -1
	if _camera != null:
		_camera.offset = Vector2.ZERO


func _on_health_changed(current_health: int, _max_health: int) -> void:
	if _last_health >= 0 and current_health < _last_health:
		damage_bursts += 1
		_trauma = 1.0
		Burst.spawn(_player.get_parent(), _player.global_position, Color(1.0, 0.45, 0.3, 1.0), 12, 170.0, 0.4,
				Vector2.UP, 220.0, 7.0, 200.0)
	_last_health = current_health
