class_name CybercoreSentry
extends CharacterBody2D
## Sentinela de Cybercore — arquétipo de inimigo PROPOSTO (docs/game-design/proposals/).
## Estacionária: percebe BOLT por linha de visão, TELEGRAFA o disparo e atira um projétil lento.
## Contra-jogo: sair da linha, pular/dashar o projétil, usar abrigo ou interromper o disparo
## acertando-a durante o telegraph. Não depende de reflexo impossível em tela touch: o telegraph
## dura `telegraph_time` e a direção é TRAVADA no início dele.
##
## Máquina de estados: IDLE -> TELEGRAPH -> COOLDOWN -> IDLE; dano em TELEGRAPH -> STAGGER -> COOLDOWN.
## Todos os valores são provisórios (não avaliados em aparelho).

signal defeated
signal hit_received(remaining_health: int)
signal state_changed(new_state: State)
signal fired(bolt: SentryBolt)

enum State { IDLE, TELEGRAPH, COOLDOWN, STAGGER }

## Corpo claro o bastante para ler contra o fundo escuro e contra os pisos (legibilidade do aviso).
const BODY_COLOR: Color = Color(0.46, 0.55, 0.8, 1.0)
const BOLT_SCENE: PackedScene = preload("res://scenes/enemies/sentry_bolt.tscn")

@export var initial_facing: int = -1
@export_range(80.0, 800.0, 10.0) var detection_range: float = 380.0
## Tolerância vertical para considerar BOLT "na linha" de tiro.
@export_range(16.0, 200.0, 4.0) var vertical_tolerance: float = 56.0
@export_range(0.2, 2.0, 0.05) var telegraph_time: float = 0.8
@export_range(0.3, 4.0, 0.05) var cooldown_time: float = 1.6
@export_range(0.1, 2.0, 0.05) var stagger_time: float = 0.6
@export_range(60.0, 400.0, 5.0) var bolt_speed: float = 170.0
@export_range(1, 5, 1) var bolt_damage: int = 1
@export_range(0.03, 0.5, 0.01) var hit_flash_duration: float = 0.12

var state: State = State.IDLE
var facing: int = -1

var _target: BoltPlayer
var _timer: float = 0.0
var _active: bool = true
var _hit_flash_left: float = 0.0
var _locked_direction: int = -1
var _live_bolt: SentryBolt

@onready var _health: BoltHealth = %Health
@onready var _body_visual: Polygon2D = %Visual
@onready var _core: Polygon2D = %Core
@onready var _aim: Line2D = %AimLine
@onready var _sensor: Area2D = %Sensor
@onready var _muzzle: Marker2D = %Muzzle


func _ready() -> void:
	facing = -1 if initial_facing < 0 else 1
	_apply_facing()
	_health.depleted.connect(_on_depleted)
	_sensor.body_entered.connect(_on_sensor_body_entered)
	_sensor.body_exited.connect(_on_sensor_body_exited)
	_aim.visible = false
	_refresh_core()


func apply_damage(amount: int) -> void:
	if not _active or not _health.apply_damage(amount):
		return
	_hit_flash_left = hit_flash_duration
	_body_visual.color = Color(1.0, 0.92, 0.48, 1.0)
	hit_received.emit(_health.current_health)
	if state == State.TELEGRAPH and _health.current_health > 0:
		_set_state(State.STAGGER)  # acertar durante o telegraph cancela o disparo
		_timer = stagger_time


func _physics_process(delta: float) -> void:
	if not _active:
		return
	if _hit_flash_left > 0.0:
		_hit_flash_left = maxf(0.0, _hit_flash_left - delta)
		if _hit_flash_left == 0.0:
			_body_visual.color = BODY_COLOR
	match state:
		State.IDLE:
			if _can_engage():
				_begin_telegraph()
		State.TELEGRAPH:
			_timer -= delta
			_core.color = _telegraph_color()
			if _timer <= 0.0:
				_fire()
		State.COOLDOWN, State.STAGGER:
			_timer -= delta
			if _timer <= 0.0:
				_set_state(State.IDLE)


## BOLT está no alcance, alinhado verticalmente e visível (nada do mundo no caminho).
func _can_engage() -> bool:
	if _target == null or not is_instance_valid(_target):
		return false
	var offset: Vector2 = _target.global_position - _muzzle.global_position
	if absf(offset.x) > detection_range or absf(offset.y) > vertical_tolerance:
		return false
	if _live_bolt != null and is_instance_valid(_live_bolt):
		return false  # no máximo um projétil por Sentinela em voo
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(_muzzle.global_position, _target.global_position, 1)
	return get_world_2d().direct_space_state.intersect_ray(query).is_empty()


func _begin_telegraph() -> void:
	var side: float = _target.global_position.x - global_position.x
	if not is_zero_approx(side):
		facing = 1 if side > 0.0 else -1
		_apply_facing()
	_locked_direction = facing  # direção travada: o jogador pode sair da linha durante o aviso
	_timer = telegraph_time
	_aim.visible = true
	_set_state(State.TELEGRAPH)


func _fire() -> void:
	_aim.visible = false
	var bolt: SentryBolt = BOLT_SCENE.instantiate() as SentryBolt
	get_parent().add_child(bolt)
	bolt.global_position = _muzzle.global_position
	bolt.configure(_locked_direction, bolt_speed, bolt_damage)
	_live_bolt = bolt
	fired.emit(bolt)
	_timer = cooldown_time
	_set_state(State.COOLDOWN)


func _set_state(next: State) -> void:
	if next != State.TELEGRAPH:
		_aim.visible = false
	state = next
	_refresh_core()
	state_changed.emit(next)


func _refresh_core() -> void:
	match state:
		State.IDLE:
			_core.color = Color(0.2, 0.85, 1.0, 1.0)
		State.TELEGRAPH:
			_core.color = _telegraph_color()
		State.COOLDOWN:
			_core.color = Color(0.15, 0.3, 0.4, 1.0)
		State.STAGGER:
			_core.color = Color(1.0, 0.92, 0.48, 1.0)


## Pisca cada vez mais rápido até o disparo: o ritmo comunica "falta pouco".
func _telegraph_color() -> Color:
	var progress: float = 1.0 - clampf(_timer / maxf(telegraph_time, 0.001), 0.0, 1.0)
	var pulse: float = 0.5 + 0.5 * sin(progress * progress * 60.0)
	return Color(1.0, 0.3 + 0.35 * pulse, 0.2, 1.0)


func _apply_facing() -> void:
	_body_visual.scale.x = float(facing)
	_muzzle.position.x = 22.0 * float(facing)
	_aim.scale.x = float(facing)


func _on_sensor_body_entered(body: Node2D) -> void:
	if body is BoltPlayer:
		_target = body as BoltPlayer


func _on_sensor_body_exited(body: Node2D) -> void:
	if body == _target:
		_target = null


func _on_depleted() -> void:
	if not _active:
		return
	_active = false
	defeated.emit()
	queue_free()
