class_name TimedEnergyGate
extends Area2D
## Campo energético cíclico de Cybercore. O ciclo pausa junto com a árvore do jogo.

signal state_changed(active: bool)

@export_range(0.1, 10.0, 0.1) var active_duration: float = 1.8
@export_range(0.1, 10.0, 0.1) var inactive_duration: float = 1.2
@export_range(1, 10, 1) var contact_damage: int = 1
@export var initial_active: bool = true

## Janela (s) antes de ativar em que o campo avisa visualmente.
const TELEGRAPH_TIME: float = 0.45

var _active: bool = false
var _state_initialized: bool = false

@onready var _cycle_timer: Timer = %CycleTimer
@onready var _visual: Polygon2D = %Visual


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_cycle_timer.timeout.connect(_on_cycle_timeout)
	_set_active(initial_active)
	_cycle_timer.start(_duration_for_current_state())


func _process(_delta: float) -> void:
	# Telégrafo (só visual): na reta final da fase inativa o campo pisca em alerta, para o
	# jogador ler o ritmo do perigo. Não altera monitoring, tempos nem dano.
	if _active or _cycle_timer.is_stopped():
		return
	if _cycle_timer.time_left <= TELEGRAPH_TIME:
		var pulse: float = 0.5 + 0.5 * sin(_cycle_timer.time_left * 40.0)
		_visual.color = Color(1.0, 0.55, 0.3, 0.25 + 0.4 * pulse)


func is_active() -> bool:
	return _active


func _on_cycle_timeout() -> void:
	_set_active(not _active)
	_cycle_timer.start(_duration_for_current_state())


func _duration_for_current_state() -> float:
	return active_duration if _active else inactive_duration


func _set_active(active: bool) -> void:
	if _state_initialized and _active == active:
		return
	_state_initialized = true
	_active = active
	# monitoring pode ser alterado em resposta a eventos de física; adiar a mutação.
	set_deferred("monitoring", _active)
	# Perigo ativo = vermelho-alaranjado (mesma leitura do inimigo); ciano fica para o que é seguro.
	_visual.color = Color(1.0, 0.42, 0.28, 0.92) if _active else Color(0.12, 0.22, 0.34, 0.28)
	state_changed.emit(_active)


func _on_body_entered(body: Node2D) -> void:
	if not _active or not body is BoltPlayer:
		return
	var player: BoltPlayer = body as BoltPlayer
	var knockback_direction: float = signf(player.global_position.x - global_position.x)
	player.take_damage(contact_damage, knockback_direction)
