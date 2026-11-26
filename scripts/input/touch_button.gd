class_name TouchButton
extends Control
## Botão touch apenas visual + geometria de acerto. O estado LÓGICO da ação pertence a
## `TouchControls`; aqui `visual_pressed` só reflete esse estado (docs/technical/02 §2:
## "separar estado visual do botão do estado lógico da ação").
##
## ARTE PLACEHOLDER: formas desenhadas em código, sem assets finais.

## Ação lógica do Input Map disparada por este botão.
@export var action: StringName = &""
@export var label_text: String = ""
## -1 = seta para a esquerda, 0 = nenhuma, 1 = seta para a direita.
@export_range(-1, 1) var arrow: int = 0
## Se true, um dedo arrastado para dentro deste botão (vindo de outro botão `slide_enter`)
## o aciona. Usado para troca de direção sem levantar o dedo.
@export var slide_enter: bool = false

## Reflexo visual do estado lógico (definido por TouchControls).
var visual_pressed: bool = false:
	set(value):
		if visual_pressed != value:
			visual_pressed = value
			queue_redraw()
## 0.0–1.0. Abaixo de 1.0 o botão é desenhado como "indisponível/recarregando".
var availability: float = 1.0:
	set(value):
		var clamped: float = clampf(value, 0.0, 1.0)
		if not is_equal_approx(availability, clamped):
			availability = clamped
			queue_redraw()

var _style_normal: StyleBoxFlat = StyleBoxFlat.new()
var _style_pressed: StyleBoxFlat = StyleBoxFlat.new()
var _style_unavailable: StyleBoxFlat = StyleBoxFlat.new()


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_configure_style(_style_normal, Color(1, 1, 1, 0.16), Color(1, 1, 1, 0.55))
	_configure_style(_style_pressed, Color(0.18, 0.9, 1.0, 0.55), Color(1, 1, 1, 0.95))
	_configure_style(_style_unavailable, Color(0.2, 0.2, 0.25, 0.30), Color(1, 1, 1, 0.25))
	resized.connect(queue_redraw)


## Ponto (coordenadas do viewport) dentro do botão, com folga opcional `slop`.
func contains_point(point: Vector2, slop: float = 0.0) -> bool:
	return get_global_rect().grow(slop).has_point(point)


func center_distance(point: Vector2) -> float:
	return get_global_rect().get_center().distance_to(point)


func _configure_style(style: StyleBoxFlat, fill: Color, border: Color) -> void:
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(3)
	style.set_corner_radius_all(roundi(minf(size.x, size.y) * 0.5))
	style.anti_aliasing = true


func _draw() -> void:
	var style: StyleBoxFlat = _style_normal
	if visual_pressed:
		style = _style_pressed
	elif availability < 1.0:
		style = _style_unavailable
	style.set_corner_radius_all(roundi(minf(size.x, size.y) * 0.5))
	draw_style_box(style, Rect2(Vector2.ZERO, size))
	var center: Vector2 = size * 0.5
	var unit: float = minf(size.x, size.y) * 0.22
	if arrow != 0:
		var dir: float = float(arrow)
		draw_colored_polygon(PackedVector2Array([
			center + Vector2(dir * unit, 0.0),
			center + Vector2(-dir * unit * 0.8, -unit),
			center + Vector2(-dir * unit * 0.8, unit),
		]), Color(1, 1, 1, 0.9))
	if label_text != "":
		var font: Font = ThemeDB.fallback_font
		var font_size: int = 20
		var baseline: float = center.y + font.get_ascent(font_size) * 0.5 - 2.0
		draw_string(font, Vector2(0.0, baseline), label_text,
				HORIZONTAL_ALIGNMENT_CENTER, size.x, font_size, Color(1, 1, 1, 0.95))
	if availability < 1.0:
		var bar: Rect2 = Rect2(size.x * 0.2, size.y - 16.0, size.x * 0.6 * availability, 5.0)
		draw_rect(bar, Color(0.18, 0.9, 1.0, 0.9))
