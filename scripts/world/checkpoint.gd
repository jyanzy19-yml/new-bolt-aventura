class_name Checkpoint
extends Area2D
## Ponto de retorno. A origem do nó é a posição de reaparecimento do jogador (posição do corpo
## de BOLT, não do chão). Só avisa "alcançado" — quem decide o que persiste é o LevelSession
## (docs/technical/05-system-contracts.md §4). Visual provisório (placeholder).

signal reached(checkpoint: Checkpoint)

## ID estável (a:z, 0:9, _ . -). Persistido no save: não renomear depois de publicado.
@export var checkpoint_id: StringName = &""

var active: bool = false


func _ready() -> void:
	add_to_group(&"checkpoint")
	body_entered.connect(_on_body_entered)


func get_respawn_position() -> Vector2:
	return global_position


func set_active(value: bool) -> void:
	if active != value:
		active = value
		queue_redraw()


func _on_body_entered(body: Node2D) -> void:
	if body is BoltPlayer:
		reached.emit(self)


func _draw() -> void:
	var pole_color: Color = Color(0.75, 0.8, 0.85)
	var flag_color: Color = Color(0.35, 1.0, 0.55) if active else Color(0.5, 0.55, 0.6)
	draw_rect(Rect2(-2.0, -40.0, 4.0, 64.0), pole_color)
	draw_colored_polygon(PackedVector2Array([Vector2(2, -40), Vector2(28, -32), Vector2(2, -24)]), flag_color)
