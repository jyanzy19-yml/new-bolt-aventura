class_name EnergyRelay
extends StaticBody2D
## Interruptor de energia reutilizável. É ativado por um disparo da Pistola Crono (contrato de alvo
## existente: camada 4 + apply_damage), logo é DELIBERADO — andar perto nunca o aciona. A decisão de
## aceitar/rejeitar pertence ao controlador do puzzle; o relé só reporta o golpe e exibe estado.
##
## Estado visual NÃO depende só de cor: ENERGIZED mostra halo, REJECTED mostra um X, e cada relé
## tem um glifo próprio (losango/círculo/triângulo) que também aparece no mural de pistas.

signal struck(relay_id: StringName)

enum Glyph { DIAMOND, CIRCLE, TRIANGLE }
enum VisualState { OFF, ENERGIZED, REJECTED }

const COLOR_OFF: Color = Color(0.30, 0.38, 0.55, 1.0)
const COLOR_ENERGIZED: Color = Color(0.25, 1.0, 0.85, 1.0)
const COLOR_REJECTED: Color = Color(1.0, 0.32, 0.25, 1.0)

@export var relay_id: StringName = &"relay"
@export var glyph: Glyph = Glyph.DIAMOND
@export_range(0.1, 2.0, 0.05) var reject_flash_duration: float = 0.6

var _resting_state: VisualState = VisualState.OFF
var _shown_state: VisualState = VisualState.OFF

@onready var _glyph_fill: Polygon2D = %GlyphFill
@onready var _halo: Polygon2D = %Halo
@onready var _reject_mark: Node2D = %RejectMark
@onready var _flash_timer: Timer = %FlashTimer


static func glyph_polygon(shape: Glyph, radius: float) -> PackedVector2Array:
	match shape:
		Glyph.DIAMOND:
			return PackedVector2Array([Vector2(0, -radius), Vector2(radius, 0), Vector2(0, radius), Vector2(-radius, 0)])
		Glyph.CIRCLE:
			var points: PackedVector2Array = PackedVector2Array()
			for i in range(12):
				var angle: float = TAU * float(i) / 12.0
				points.append(Vector2(cos(angle), sin(angle)) * radius)
			return points
		_:
			return PackedVector2Array([Vector2(0, -radius), Vector2(radius, radius * 0.85), Vector2(-radius, radius * 0.85)])


func _ready() -> void:
	_glyph_fill.polygon = glyph_polygon(glyph, 11.0)
	_flash_timer.one_shot = true
	_flash_timer.timeout.connect(_on_flash_timeout)
	_show(VisualState.OFF)


## Contrato de alvo da Pistola Crono. Pode ser chamado mais de uma vez por golpe: o controlador deduplica.
func apply_damage(_amount: int) -> void:
	struck.emit(relay_id)


## Estado de repouso (lógico). Cancela qualquer flash de rejeição em andamento.
func set_state(state: VisualState) -> void:
	_resting_state = state
	_flash_timer.stop()
	_show(state)


func flash_rejected() -> void:
	_show(VisualState.REJECTED)
	_flash_timer.start(reject_flash_duration)


func get_visual_state() -> VisualState:
	return _shown_state


func _on_flash_timeout() -> void:
	_show(_resting_state)


func _show(state: VisualState) -> void:
	_shown_state = state
	match state:
		VisualState.OFF:
			_glyph_fill.color = COLOR_OFF
		VisualState.ENERGIZED:
			_glyph_fill.color = COLOR_ENERGIZED
		VisualState.REJECTED:
			_glyph_fill.color = COLOR_REJECTED
	_halo.visible = state == VisualState.ENERGIZED
	_reject_mark.visible = state == VisualState.REJECTED
