class_name OneWayPlatform
extends PlatformBlock
## Plataforma estática unidirecional: BOLT pode subir através dela e aterrissar por cima.

@export_range(0.0, 16.0, 0.1) var one_way_margin: float = 2.0


func _ready() -> void:
	super._ready()
	_shape_node.one_way_collision = true
	_shape_node.one_way_collision_direction = Vector2.DOWN
	_shape_node.one_way_collision_margin = one_way_margin
