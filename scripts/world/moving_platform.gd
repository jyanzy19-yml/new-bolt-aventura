class_name MovingPlatform
extends AnimatableBody2D
## Plataforma móvel ping-pong. A origem é o canto superior esquerdo, como PlatformBlock.
## Atualiza o transform no tick de física para que CharacterBody2D receba a velocidade da plataforma.

@export var size: Vector2 = Vector2(160.0, 24.0):
	set(value):
		size = Vector2(maxf(value.x, 1.0), maxf(value.y, 1.0))
		_refresh()
@export var travel_offset: Vector2 = Vector2(0.0, -120.0)
@export_range(0.1, 10.0, 0.05) var travel_duration: float = 1.5
@export_range(0.0, 3.0, 0.05) var endpoint_pause: float = 0.35
@export var fill_color: Color = Color(0.16, 0.2, 0.32, 1.0)
@export var top_color: Color = Color(0.18, 0.9, 1.0, 0.9)

var _shape_node: CollisionShape2D
var _start_position: Vector2 = Vector2.ZERO
var _progress: float = 0.0
var _direction: float = 1.0
var _pause_remaining: float = 0.0


func _ready() -> void:
	collision_layer = 1  # world
	collision_mask = 0
	sync_to_physics = true
	_shape_node = CollisionShape2D.new()
	_shape_node.name = "CollisionShape2D"
	add_child(_shape_node)
	_refresh()
	_start_position = position
	_pause_remaining = 0.0
	set_physics_process(travel_duration > 0.0 and travel_offset.length_squared() > 0.0001)


func _physics_process(delta: float) -> void:
	if travel_duration <= 0.0 or travel_offset.length_squared() <= 0.0001:
		set_physics_process(false)
		return

	var remaining: float = delta
	while remaining > 0.000001:
		if _pause_remaining > 0.0:
			var pause_step: float = minf(remaining, _pause_remaining)
			_pause_remaining -= pause_step
			remaining -= pause_step
			if remaining <= 0.000001:
				break

		var distance_to_endpoint: float = 1.0 - _progress if _direction > 0.0 else _progress
		var seconds_to_endpoint: float = distance_to_endpoint * travel_duration
		if remaining < seconds_to_endpoint:
			_progress += _direction * remaining / travel_duration
			remaining = 0.0
		else:
			_progress = 1.0 if _direction > 0.0 else 0.0
			remaining -= seconds_to_endpoint
			_direction *= -1.0
			_pause_remaining = endpoint_pause

	position = _start_position + travel_offset * _progress


func _refresh() -> void:
	if _shape_node != null:
		var rectangle: RectangleShape2D = _shape_node.shape as RectangleShape2D
		if rectangle == null:
			rectangle = RectangleShape2D.new()
			_shape_node.shape = rectangle
		rectangle.size = size
		_shape_node.position = size * 0.5
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), fill_color)
	draw_rect(Rect2(Vector2.ZERO, Vector2(size.x, 4.0)), top_color)
