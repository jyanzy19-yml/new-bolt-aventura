class_name ConveyorBelt
extends PlatformBlock
## Plataforma de esteira: transfere velocidade horizontal constante a corpos apoiados.
## A direção é indicada por chevrons no topo; valores positivos movem à direita.

@export_range(-240.0, 240.0, 5.0) var surface_speed: float = 100.0


func _ready() -> void:
	super._ready()
	constant_linear_velocity = Vector2(surface_speed, 0.0)


func get_surface_velocity() -> Vector2:
	return Vector2(surface_speed, 0.0)


func _draw() -> void:
	super._draw()
	if absf(surface_speed) < 0.01:
		return
	var direction: float = signf(surface_speed)
	var x: float = 18.0
	while x < size.x - 12.0:
		var center: Vector2 = Vector2(x, size.y * 0.5)
		var tip: Vector2 = center + Vector2(direction * 7.0, 0.0)
		var base: Vector2 = center - Vector2(direction * 7.0, 0.0)
		var tint: Color = Color(0.25, 0.95, 1.0, 0.9)
		draw_line(base, tip, tint, 2.0)
		draw_line(tip, base + Vector2(0.0, -5.0), tint, 2.0)
		draw_line(tip, base + Vector2(0.0, 5.0), tint, 2.0)
		x += 36.0
