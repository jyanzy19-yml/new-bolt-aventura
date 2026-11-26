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

## Progresso do carregamento do destino atual, de 0.0 a 1.0.
var progress: float = 0.0

var _target_path: String = ""
var _busy: bool = false


func _ready() -> void:
	set_process(false)
	# Entrada sem acúmulo: os controles touch convertem eventos em ações via
	# Input.parse_input_event. Isso evita depender do acúmulo para propagar a borda do evento.
	# Custo e latência devem ser medidos em Android físico; testes headless não medem latência real.
	Input.use_accumulated_input = false


func is_transitioning() -> bool:
	return _busy


## Inicia a troca para `path`. Retorna `false` (sem efeitos) se já houver transição em curso,
## se o recurso não existir ou se o carregamento não puder ser iniciado.
func change_scene(path: String) -> bool:
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
	progress = 0.0
	Actions.release_all_game_actions()
	transition_started.emit(path)
	set_process(true)
	return true


func _notification(what: int) -> void:
	# Perda de foco/suspensão do app: nenhum comando pode permanecer pressionado ao voltar.
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT or what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
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
	var packed: PackedScene = ResourceLoader.load_threaded_get(_target_path) as PackedScene
	if packed == null:
		_fail("not_a_packed_scene")
		return
	var err: Error = get_tree().change_scene_to_packed(packed)
	if err != OK:
		_fail("change_failed")
		return
	await get_tree().scene_changed
	Actions.release_all_game_actions()
	progress = 1.0
	var finished_path: String = _target_path
	_busy = false
	_target_path = ""
	transition_finished.emit(finished_path)


func _fail(reason: String) -> void:
	var failed_path: String = _target_path
	push_error("SceneFlow: transição para '%s' falhou (%s)." % [failed_path, reason])
	_busy = false
	_target_path = ""
	transition_failed.emit(failed_path, reason)
