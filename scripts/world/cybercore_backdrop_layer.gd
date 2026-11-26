class_name CybercoreBackdropLayer
extends Node2D
## Uma camada do cenário de fundo de Cybercore, gerada por código (sem texturas).
##
## DESEMPENHO: toda a geometria da camada (torres, janelas, antenas, faixas do céu) é acumulada
## numa única ArrayMesh com cores por vértice e desenhada com UM draw_mesh. Desenhar centenas de
## retângulos/polígonos soltos custava ~8x mais chamadas de desenho por quadro (medido). A malha é
## montada uma vez em _ready (determinística: mesma arte em toda execução) e reaproveitada.
##
## DIREÇÃO DE ARTE PROVISÓRIA (proposta, não canonizada): ruínas tecnológicas sob céu escuro, em
## azul/ciano, coerente com a paleta já usada nos blocos.

enum Kind { SKY, FAR_SKYLINE, MID_RUINS }

@export var kind: Kind = Kind.SKY
@export var art_seed: int = 7
## Extensão horizontal coberta (px). Deve exceder a fase + o deslocamento do parallax.
@export var span: float = 3600.0
@export var origin_x: float = -600.0

const SKY_TOP: Color = Color(0.02, 0.03, 0.08)
const SKY_MID: Color = Color(0.05, 0.08, 0.18)
const SKY_GLOW: Color = Color(0.09, 0.2, 0.3)
const FAR_COLOR: Color = Color(0.06, 0.1, 0.2)
const FAR_WINDOW: Color = Color(0.12, 0.45, 0.62, 0.55)
const MID_COLOR: Color = Color(0.045, 0.07, 0.14)
const MID_EDGE: Color = Color(0.09, 0.5, 0.7, 0.8)
const MID_WARN: Color = Color(1.0, 0.45, 0.3, 0.8)

var _vertices: PackedVector2Array = PackedVector2Array()
var _colors: PackedColorArray = PackedColorArray()
var _mesh: ArrayMesh
var _triangles: int = 0


func _ready() -> void:
	_build()


## Quantidade de triângulos da malha (diagnóstico/testes).
func triangle_count() -> int:
	return _triangles


func _build() -> void:
	_vertices.clear()
	_colors.clear()
	match kind:
		Kind.SKY:
			_build_sky()
		Kind.FAR_SKYLINE:
			_build_towers(0.0, 380.0, 120.0, 280.0, FAR_COLOR, FAR_WINDOW, false)
		Kind.MID_RUINS:
			_build_towers(1.0, 360.0, 70.0, 200.0, MID_COLOR, MID_EDGE, true)
	var arrays: Array = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = _vertices
	arrays[Mesh.ARRAY_COLOR] = _colors
	_triangles = _vertices.size() / 3
	_mesh = ArrayMesh.new()
	_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	_vertices = PackedVector2Array()  # a malha já guarda os dados
	_colors = PackedColorArray()
	queue_redraw()


func _draw() -> void:
	if _mesh != null:
		draw_mesh(_mesh, null)


# --- primitivas de malha --------------------------------------------------------------------

func _tri(a: Vector2, b: Vector2, c: Vector2, color: Color) -> void:
	_vertices.append_array(PackedVector2Array([a, b, c]))
	_colors.append_array(PackedColorArray([color, color, color]))


func _quad(a: Vector2, b: Vector2, c: Vector2, d: Vector2, ca: Color, cb: Color, cc: Color, cd: Color) -> void:
	_vertices.append_array(PackedVector2Array([a, b, c, a, c, d]))
	_colors.append_array(PackedColorArray([ca, cb, cc, ca, cc, cd]))


func _rect(rect: Rect2, color: Color) -> void:
	_quad(rect.position, Vector2(rect.end.x, rect.position.y), rect.end, Vector2(rect.position.x, rect.end.y), color, color, color, color)


func _line(from: Vector2, to: Vector2, width: float, color: Color) -> void:
	var normal: Vector2 = (to - from).orthogonal().normalized() * (width * 0.5)
	_quad(from - normal, from + normal, to + normal, to - normal, color, color, color, color)


# --- conteúdo ---------------------------------------------------------------------------------

func _build_sky() -> void:
	# Cobre além da tela (aspecto "expand" pode mostrar margens extras).
	var x0: float = -600.0
	var x1: float = 1600.0
	var bands: Array[float] = [-400.0, 120.0, 300.0, 700.0]
	var colors: Array[Color] = [SKY_TOP, SKY_MID, SKY_GLOW, SKY_MID]
	for i in range(bands.size() - 1):
		_quad(Vector2(x0, bands[i]), Vector2(x1, bands[i]), Vector2(x1, bands[i + 1]), Vector2(x0, bands[i + 1]),
				colors[i], colors[i], colors[i + 1], colors[i + 1])


## Torres de silhueta quebrada. `baseline`/`min_h`/`max_h` em px relativos à camada.
func _build_towers(layer_index: float, baseline: float, min_h: float, max_h: float, body: Color, accent: Color, detailed: bool) -> void:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = art_seed + int(layer_index) * 1013
	var x: float = origin_x
	while x < origin_x + span:
		var w: float = rng.randf_range(54.0, 130.0) if detailed else rng.randf_range(70.0, 170.0)
		var h: float = rng.randf_range(min_h, max_h)
		var top: float = baseline - h
		# Topo quebrado: ruína, não prédio intacto.
		var slope: float = rng.randf_range(-0.5, 0.5) * w * 0.5
		var bottom_left: Vector2 = Vector2(x, baseline + 400.0)
		var top_left: Vector2 = Vector2(x, top + maxf(0.0, slope))
		var apex: Vector2 = Vector2(x + w * 0.5, top - absf(slope) * 0.3)
		var top_right: Vector2 = Vector2(x + w, top + maxf(0.0, -slope))
		var bottom_right: Vector2 = Vector2(x + w, baseline + 400.0)
		_tri(bottom_left, top_left, apex, body)
		_tri(bottom_left, apex, top_right, body)
		_tri(bottom_left, top_right, bottom_right, body)
		_add_windows(rng, x, top, w, baseline, accent, detailed)
		if detailed:
			_line(top_left, apex, 2.0, accent)
			_line(apex, top_right, 2.0, accent)
			if rng.randf() < 0.3:  # antena com luz de alerta
				var ax: float = x + w * rng.randf_range(0.2, 0.8)
				_line(Vector2(ax, top), Vector2(ax, top - 38.0), 2.0, MID_EDGE)
				_rect(Rect2(ax - 3.0, top - 43.0, 6.0, 6.0), MID_WARN)
		x += w + rng.randf_range(8.0, 60.0)


func _add_windows(rng: RandomNumberGenerator, x: float, top: float, w: float, baseline: float, accent: Color, detailed: bool) -> void:
	var cell: float = 18.0 if detailed else 24.0
	var cols: int = int((w - 12.0) / cell)
	var rows: int = int(minf(baseline - top - 20.0, 260.0) / cell)
	for r in range(rows):
		for c in range(cols):
			if rng.randf() < (0.16 if detailed else 0.1):  # a maioria apagada: mundo destruído
				_rect(Rect2(x + 8.0 + float(c) * cell, top + 16.0 + float(r) * cell, 6.0, 4.0), accent)
