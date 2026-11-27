class_name EnergyConduit
extends Line2D
## Conduíte visual do puzzle. Aceso = largo e brilhante; apagado = fino e opaco (forma + cor).

const DIM_COLOR: Color = Color(0.25, 0.33, 0.5, 0.75)
const LIT_COLOR: Color = Color(0.3, 1.0, 0.9, 1.0)
const DIM_WIDTH: float = 2.0
const LIT_WIDTH: float = 6.0

var _lit: bool = false


func _ready() -> void:
	z_index = -10
	set_lit(_lit)


func set_lit(lit: bool) -> void:
	_lit = lit
	default_color = LIT_COLOR if lit else DIM_COLOR
	width = LIT_WIDTH if lit else DIM_WIDTH


func is_lit() -> bool:
	return _lit
