class_name CybercoreBackdrop
extends ParallaxBackground
## Fundo de Cybercore em 3 camadas com parallax (céu fixo, horizonte distante, ruínas próximas).
## Montado por código para manter a cena trivial; as camadas são estáticas (nada é redesenhado
## por quadro). Fica atrás de tudo (layer -100) e não interfere em física, entrada ou HUD.

const LAYER_SETTINGS: Array[Dictionary] = [
	{"name": "Sky", "kind": CybercoreBackdropLayer.Kind.SKY, "scale": Vector2(0.0, 0.0)},
	{"name": "FarSkyline", "kind": CybercoreBackdropLayer.Kind.FAR_SKYLINE, "scale": Vector2(0.12, 0.05)},
	{"name": "MidRuins", "kind": CybercoreBackdropLayer.Kind.MID_RUINS, "scale": Vector2(0.32, 0.12)},
]


func _ready() -> void:
	layer = -100
	for setting: Dictionary in LAYER_SETTINGS:
		var parallax: ParallaxLayer = ParallaxLayer.new()
		parallax.name = String(setting["name"])
		parallax.motion_scale = setting["scale"]
		var art: CybercoreBackdropLayer = CybercoreBackdropLayer.new()
		art.kind = setting["kind"]
		parallax.add_child(art)
		add_child(parallax)
