class_name EnergyClueMural
extends Node2D
## Mural de pistas: desenha FONTE -> glifos dos relés (na ordem exigida) -> barreira. Os glifos vêm
## dos próprios relés, então a pista nunca diverge da regra real.

@export var relay_paths: Array[NodePath] = []

var _glyphs: Array[int] = []


func _ready() -> void:
	z_index = -9
	for path: NodePath in relay_paths:
		var relay: EnergyRelay = get_node_or_null(path) as EnergyRelay
		if relay != null:
			_glyphs.append(relay.glyph)
	queue_redraw()


func get_glyph_sequence() -> Array[int]:
	return _glyphs


func _draw() -> void:
	var step: float = 56.0
	var line_color: Color = Color(0.55, 0.85, 1.0, 0.9)
	var fill_color: Color = Color(0.3, 0.38, 0.55, 0.9)
	var count: int = _glyphs.size() + 2
	draw_rect(Rect2(-36.0, -30.0, step * float(count - 1) + 72.0, 60.0), Color(0.05, 0.08, 0.16, 0.75))
	draw_rect(Rect2(-36.0, -30.0, step * float(count - 1) + 72.0, 60.0), line_color, false, 2.0)
	# Fonte (quadrado)
	draw_rect(Rect2(-12.0, -12.0, 24.0, 24.0), Color(0.3, 1.0, 0.9, 0.9))
	for index in range(_glyphs.size()):
		var center: Vector2 = Vector2(step * float(index + 1), 0.0)
		_draw_arrow(center.x - step + 16.0, center.x - 16.0, line_color)
		var poly: PackedVector2Array = EnergyRelay.glyph_polygon(_glyphs[index] as EnergyRelay.Glyph, 11.0)
		var moved: PackedVector2Array = PackedVector2Array()
		for point: Vector2 in poly:
			moved.append(point + center)
		draw_colored_polygon(moved, fill_color)
		moved.append(moved[0])
		draw_polyline(moved, line_color, 2.0)
	# Barreira (retângulo vertical com barras)
	var gate_x: float = step * float(count - 1)
	_draw_arrow(gate_x - step + 16.0 + 0.0, gate_x - 14.0, line_color)
	draw_rect(Rect2(gate_x - 8.0, -16.0, 16.0, 32.0), line_color, false, 2.0)
	draw_line(Vector2(gate_x - 3.0, -16.0), Vector2(gate_x - 3.0, 16.0), line_color, 2.0)
	draw_line(Vector2(gate_x + 3.0, -16.0), Vector2(gate_x + 3.0, 16.0), line_color, 2.0)


func _draw_arrow(from_x: float, to_x: float, color: Color) -> void:
	draw_line(Vector2(from_x, 0.0), Vector2(to_x, 0.0), color, 2.0)
	draw_colored_polygon(PackedVector2Array([Vector2(to_x, 0.0), Vector2(to_x - 7.0, -5.0), Vector2(to_x - 7.0, 5.0)]), color)
