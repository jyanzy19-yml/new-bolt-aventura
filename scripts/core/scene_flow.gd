extends Node
## Coordenador de transições de cena — autoload `SceneFlow`.
##
## Implementa o contrato "Scene Flow → Loading" (docs/technical/05-system-contracts.md §6):
## controla destino, carregamento real em thread, erro, bloqueio de input e impede duas
## transições simultâneas. Não adiciona espera artificial: a transição dura o tempo real de
## carregamento do recurso.

signal transition_started(path: String)
signal transition_finished(path: String)
signal transition_failed(path: String, reason: String)
signal transition_cancel_requested(path: String)
signal transition_cancelled(path: String)

## Progresso do carregamento do destino atual, de 0.0 a 1.0.
var progress: float = 0.0

var _target_path: String = ""
var _busy: bool = false
var _was_paused: bool = false
var _cancelable: bool = false
var _cancel_requested: bool = false


func _ready() -> void:
	# Transições precisam terminar mesmo quando a cena anterior deixou a árvore pausada.
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process(false)
	# Entrada sem acúmulo: os controles touch convertem eventos em ações via
	# Input.parse_input_event. Isso evita depender do acúmulo para propagar a borda do evento.
	# Custo e latência devem ser medidos em Android físico; testes headless não medem latência real.
	Input.use_accumulated_input = false


func is_transitioning() -> bool:
	return _busy


func is_cancel_requested() -> bool:
	return _cancel_requested


## Solicita o cancelamento da troca, não da operação de I/O do ResourceLoader.
## A transição permanece ocupada até a carga em background terminar e o recurso ser descartado.
func cancel_transition() -> bool:
	if not _busy or not _cancelable or _cancel_requested:
		return false
	_cancel_requested = true
	transition_cancel_requested.emit(_target_path)
	return true


## Inicia a troca para `path`. Retorna `false` (sem efeitos) se já houver transição em curso,
## se o recurso não existir ou se o carregamento não puder ser iniciado. `allow_cancel` habilita
## o cancelamento lógico da troca; não interrompe a thread de carregamento do ResourceLoader.
func change_scene(path: String, allow_cancel: bool = false) -> bool:
	if _busy:
		push_warning("SceneFlow: transição ignorada (já em curso para '%s')." % _target_path)
		return false
	if not ResourceLoader.exists(path, "PackedScene"):
		push_error("SceneFlow: cena inexistente: %s" % path)
		transition_failed.emit(path, "missing")
		return false
	var err: Error = ResourceLoader.load_threaded_request(path)
	if err != OK:
		push_error("SceneFlow: falha ao iniciar carregamento de %s (erro %d)." % [path, err])
		transition_failed.emit(path, "request_failed")
		return false
	_busy = true
	_target_path = path
	_cancelable = allow_cancel
	_cancel_requested = false
	progress = 0.0
	_was_paused = get_tree().paused
	get_tree().paused = true
	Actions.release_all_game_actions()
	transition_started.emit(path)
	set_process(true)
	return true


func _notification(what: int) -> void:
	# Perda de foco/suspensão do app: nenhum comando pode permanecer pressionado ao voltar.
	if what in [
		NOTIFICATION_APPLICATION_PAUSED,
		NOTIFICATION_APPLICATION_FOCUS_OUT,
		NOTIFICATION_WM_WINDOW_FOCUS_OUT,
	]:
		Actions.release_all_game_actions()


func _process(_delta: float) -> void:
	if not _busy:
		set_process(false)
		return
	var report: Array = []
	var status: ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(
			_target_path, report)
	if not report.is_empty():
		progress = float(report[0])
	if _cancel_requested:
		if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			return
		set_process(false)
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			# Drain the completed request without committing the scene switch.
			ResourceLoader.load_threaded_get(_target_path)
			_cancel()
		else:
			_fail("load_failed")
		return
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			return
		ResourceLoader.THREAD_LOAD_LOADED:
			set_process(false)
			_complete()
		_:
			set_process(false)
			_fail("load_failed")


func _complete() -> void:
	# Once the scene switch is committed, the cancellation window is closed.
	_cancelable = false
	_cancel_requested = false
	var packed: PackedScene = ResourceLoader.load_threaded_get(_target_path) as PackedScene
	if packed == null:
		_fail("not_a_packed_scene")
		return
	var err: Error = get_tree().change_scene_to_packed(packed)
	if err != OK:
		_fail("change_failed")
		return
	await get_tree().scene_changed
	get_tree().paused = false
	_was_paused = false
	Actions.release_all_game_actions()
	progress = 1.0
	var finished_path: String = _target_path
	_busy = false
	_target_path = ""
	_cancelable = false
	_cancel_requested = false
	transition_finished.emit(finished_path)


func _cancel() -> void:
	var cancelled_path: String = _target_path
	_busy = false
	_target_path = ""
	_cancelable = false
	_cancel_requested = false
	progress = 0.0
	get_tree().paused = _was_paused
	_was_paused = false
	Actions.release_all_game_actions()
	transition_cancelled.emit(cancelled_path)


func _fail(reason: String) -> void:
	var failed_path: String = _target_path
	push_error("SceneFlow: transição para '%s' falhou (%s)." % [failed_path, reason])
	_busy = false
	_target_path = ""
	_cancelable = false
	_cancel_requested = false
	get_tree().paused = _was_paused
	_was_paused = false
	Actions.release_all_game_actions()
	transition_failed.emit(failed_path, reason)
