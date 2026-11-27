extends CanvasLayer
## Overlay persistente de carregamento. Exibe somente transições reais do SceneFlow.
## A porcentagem aparece apenas quando ResourceLoader fornece progresso mensurável.

@onready var _overlay: Control = %Overlay
@onready var _status: Label = %StatusLabel
@onready var _progress: ProgressBar = %ProgressBar

var is_loading: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_overlay.visible = false
	_progress.visible = false
	set_process(false)
	SceneFlow.transition_started.connect(_on_transition_started)
	SceneFlow.transition_cancel_requested.connect(_on_transition_cancel_requested)
	SceneFlow.transition_cancelled.connect(_on_transition_cancelled)
	SceneFlow.transition_finished.connect(_on_transition_finished)
	SceneFlow.transition_failed.connect(_on_transition_failed)


func _process(_delta: float) -> void:
	if SceneFlow.is_cancel_requested():
		_status.text = "Cancelando carregamento…"
		return
	var actual_progress: float = clampf(SceneFlow.progress, 0.0, 1.0)
	if actual_progress > 0.0:
		_progress.visible = true
		_progress.value = actual_progress * 100.0
		_status.text = "Carregando recursos · %d%%" % roundi(actual_progress * 100.0)
	else:
		# Sem dado do ResourceLoader, não inventar porcentagem nem barra falsa.
		_progress.visible = false
		_status.text = "Carregando recursos…"


func _on_transition_started(_path: String) -> void:
	is_loading = true
	_progress.value = 0.0
	_progress.visible = false
	_status.text = "Preparando a próxima área…"
	_overlay.visible = true
	set_process(true)


func _on_transition_cancel_requested(_path: String) -> void:
	_status.text = "Cancelando carregamento…"


func _on_transition_cancelled(_path: String) -> void:
	_hide_overlay()


func _on_transition_finished(_path: String) -> void:
	_hide_overlay()


func _on_transition_failed(_path: String, _reason: String) -> void:
	_hide_overlay()


func _hide_overlay() -> void:
	is_loading = false
	_overlay.visible = false
	_progress.visible = false
	set_process(false)
