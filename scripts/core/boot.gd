extends Control
## Cena de entrada do projeto. Valida o contrato de input e entrega o fluxo ao menu principal.

const MAIN_MENU_PATH: String = "res://scenes/ui/main_menu.tscn"
const MAIN_MENU_SCRIPT_PATH: String = "res://scripts/ui/main_menu.gd"

@onready var _status: Label = %StatusLabel

var _main_menu_script: Script


func _ready() -> void:
	var missing: Array[StringName] = Actions.missing()
	if not missing.is_empty():
		# Erro de configuração do projeto: não seguir adiante silenciosamente.
		push_error("Boot: ações ausentes no Input Map: %s" % [missing])
		_status.text = "Erro de configuração: Input Map incompleto."
		return
	# Compila/carrega o script leve do menu na thread principal antes do PackedScene
	# ser solicitado por SceneFlow via ResourceLoader threaded.
	_main_menu_script = load(MAIN_MENU_SCRIPT_PATH) as Script
	if _main_menu_script == null:
		push_error("Boot: falha ao carregar o script do menu.")
		_status.text = "Falha ao preparar o menu principal."
		return
	SceneFlow.transition_failed.connect(_on_transition_failed, CONNECT_ONE_SHOT)
	SceneFlow.change_scene(MAIN_MENU_PATH)


func _on_transition_failed(_path: String, reason: String) -> void:
	_status.text = "Falha ao carregar o menu (%s)." % reason
