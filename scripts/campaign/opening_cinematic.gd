extends Control
## Storyboard funcional da abertura. Arte, animação e áudio cinematográficos finais ainda são pendentes.

const TUTORIAL_PATH: String = "res://scenes/tutorial/tutorial.tscn"

const PAGES: Array[String] = [
	"O Grande Colapso rompeu o Núcleo da Eternidade. A continuidade entre os universos foi desestabilizada.",
	"Em Cybercore, entre ruínas tecnológicas, BOLT desperta sem memória.",
	"Uma máquina temporal chamada NEXO desperta e se une a BOLT. Juntos, eles podem atravessar eras e mundos.",
	"Sete fragmentos estão ligados ao mistério da ruptura. A jornada para restaurar o equilíbrio começa em Cybercore."
]

@onready var _page_label: Label = %PageLabel
@onready var _counter_label: Label = %CounterLabel
@onready var _next_button: Button = %NextButton
@onready var _skip_button: Button = %SkipButton

var _page_index: int = 0


func _ready() -> void:
	_next_button.pressed.connect(_advance)
	_skip_button.pressed.connect(_go_to_tutorial)
	_render_page()


func _render_page() -> void:
	_page_label.text = PAGES[_page_index]
	_counter_label.text = "%d / %d" % [_page_index + 1, PAGES.size()]
	_next_button.text = "IR AO TUTORIAL" if _page_index == PAGES.size() - 1 else "CONTINUAR"


func _advance() -> void:
	if _page_index < PAGES.size() - 1:
		_page_index += 1
		_render_page()
	else:
		_go_to_tutorial()


func _go_to_tutorial() -> void:
	_next_button.disabled = true
	_skip_button.disabled = true
	var flow: Node = get_node_or_null("/root/SceneFlow")
	if flow == null:
		push_error("OpeningCinematic: autoload SceneFlow ausente.")
		_next_button.disabled = false
		_skip_button.disabled = false
		return
	if not flow.change_scene(TUTORIAL_PATH):
		_next_button.disabled = false
		_skip_button.disabled = false
