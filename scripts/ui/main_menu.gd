extends Control
## Menu principal. Na Etapa 0 exibe apenas identidade e versão: nenhum botão sem função.

@onready var _version: Label = %VersionLabel


func _ready() -> void:
	var version: String = str(ProjectSettings.get_setting("application/config/version", "?"))
	_version.text = "v%s · Godot %s" % [version, Engine.get_version_info().get("string", "?")]
