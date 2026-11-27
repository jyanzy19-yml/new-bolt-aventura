extends Button
## Entrada independente para a seleção de campanha.
const WORLD_SELECTION_PATH: String = "res://scenes/ui/world_selection.tscn"

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	var flow: Node = get_node_or_null("/root/SceneFlow")
	if flow == null:
		push_error("CampaignSelectionEntry: autoload SceneFlow ausente.")
		return
	disabled = true
	if not flow.change_scene(WORLD_SELECTION_PATH):
		disabled = false
