extends Control
## Menu principal. Só expõe o que funciona: entrar na sandbox de movimento (desenvolvimento).
## Continuar, configurações, seleção de mundo etc. aparecerão quando existirem de verdade.

const OPENING_PATH: String = "res://scenes/campaign/opening_cinematic.tscn"

@onready var _version: Label = %VersionLabel
@onready var _play: Button = %PlayButton


func _ready() -> void:
	var version: String = str(ProjectSettings.get_setting("application/config/version", "?"))
	_version.text = "v%s · Godot %s" % [version, Engine.get_version_info().get("string", "?")]
	_play.pressed.connect(_on_play_pressed)
	_play.grab_focus()


func _on_play_pressed() -> void:
	# SceneFlow é resolvido em runtime (não pelo identificador global): este script é compilado
	# numa thread do carregamento assíncrono e a referência direta ao autoload falhava de forma
	# intermitente (ver docs/technical/06-godot-project-foundation.md §6).
	var flow: Node = get_node_or_null("/root/SceneFlow")
	if flow == null:
		push_error("MainMenu: autoload SceneFlow ausente.")
		return
	_play.disabled = true  # evita segundo toque durante o carregamento
	if not flow.change_scene(OPENING_PATH):
		_play.disabled = false
