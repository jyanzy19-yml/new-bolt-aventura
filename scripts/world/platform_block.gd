class_name PlatformBlock
extends StaticBody2D
## Bloco sólido retangular para montar geometria de fase. A origem é o canto superior esquerdo.
## Desenho e colisão são gerados a partir de `size`; a forma de colisão é criada por instância
## (nunca compartilhada entre blocos). Arte placeholder: retângulo desenhado em código.

@export var size: Vector2 = Vector2(64.0, 32.0):
	set(value):
		size = value
		_refresh()
@export var fill_color: Color = Color(0.16, 0.2, 0.32, 1.0)
@export var top_color: Color = Color(0.18, 0.9, 1.0, 0.9)

const PANEL_WIDTH: float = 96.0

var _shape_node: CollisionShape2D


func _ready() -> void:
	collision_layer = 1  # world
	collision_mask = 0
	_shape_node = CollisionShape2D.new()
	_shape_node.shape = RectangleShape2D.new()
	add_child(_shape_node)
	_refresh()


func _refresh() -> void:
	if _shape_node != null:
		(_shape_node.shape as RectangleShape2D).size = size
		_shape_node.position = size * 0.5
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), fill_color)
	# Profundidade: faixa de brilho suave sob a borda e painéis verticais (poucos retângulos por bloco).
	draw_rect(Rect2(Vector2(0.0, 4.0), Vector2(size.x, 10.0)), Color(top_color.r, top_color.g, top_color.b, 0.12))
	var seam_color: Color = fill_color.lightened(0.12)
	var x: float = PANEL_WIDTH
	while x < size.x - 2.0:
		draw_rect(Rect2(x, 8.0, 2.0, maxf(0.0, size.y - 8.0)), seam_color)
		x += PANEL_WIDTH
	if size.y >= 48.0:  # base escurecida: o bloco "afunda" no escuro
		draw_rect(Rect2(Vector2(0.0, size.y - 20.0), Vector2(size.x, 20.0)), Color(0.0, 0.0, 0.0, 0.25))
	draw_rect(Rect2(Vector2.ZERO, Vector2(size.x, 4.0)), top_color)
