class_name DistributionGate
extends StaticBody2D
## Barreira de energia que bloqueia a saída até o puzzle ser resolvido. Terminal: depois de aberta
## não volta a fechar na mesma instância da fase (evita prender BOLT dentro da colisão).

signal opened

@onready var _shape: CollisionShape2D = %CollisionShape2D
@onready var _visual: Polygon2D = %Visual
@onready var _bars: Node2D = %Bars

var _open: bool = false


func open() -> void:
	if _open:
		return
	_open = true
	_shape.set_deferred("disabled", true)
	_visual.color = Color(0.3, 1.0, 0.9, 0.08)
	_bars.visible = false
	opened.emit()


func is_open() -> bool:
	return _open


## Altura da barreira (px), para invariantes de level design (sem contorno por salto).
func get_barrier_height() -> float:
	return (_shape.shape as RectangleShape2D).size.y
