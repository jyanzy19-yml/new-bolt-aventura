class_name ChronoFragment
extends Area2D
## Recompensa persistente de fragmento. Deve ser posicionada após o guardião do mundo.

signal collected(fragment_id: String)
signal collection_failed(fragment_id: String, reason: String)

@export_enum(
	"fragment_origin",
	"fragment_memory",
	"fragment_truth",
	"fragment_shadow",
	"fragment_light",
	"fragment_illusion",
	"fragment_equilibrium"
) var fragment_id: String = "fragment_origin"


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	if FragmentProgress.has_fragment(fragment_id):
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if not body is BoltPlayer:
		return
	if FragmentProgress.collect_fragment(fragment_id):
		collected.emit(fragment_id)
		queue_free()
	else:
		collection_failed.emit(fragment_id, FragmentProgress.last_error)
