class_name ProgressState
extends Node
## Progresso persistente do jogo (autoload `GameState`): dono único do `SaveData` em memória.
##
## Contrato (docs/technical/05-system-contracts.md §4 e §8): fases/gameplay informam EVENTOS por
## IDs estáveis; este serviço decide o que persiste. Não guarda referências a Nodes.
##
## Salva apenas em FRONTEIRAS de progresso (checkpoint alcançado, fase concluída, flag) e na
## interrupção do app — nunca por quadro. Se o armazenamento falhar, o jogo continua e uma nova
## tentativa ocorre na próxima fronteira/interrupção (`is_dirty`).
##
## Scripts de cena devem obter este serviço por `get_node_or_null("/root/GameState")`
## (identificador de autoload direto causou erro de parse em carga em thread; ver doc 06).

signal progress_changed

const DEFAULT_PATH: String = "user://progress.save"

var data: SaveData = SaveData.new()
var last_load_status: SaveStore.Status = SaveStore.Status.FRESH
var _store: SaveStore
## Há mudanças em memória que ainda não chegaram ao disco.
var _dirty: bool = false
## Save de versão mais nova detectado: nada é gravado para não destruí-lo.
var _write_blocked: bool = false


func _ready() -> void:
	# Em testes o runner chama `setup()` antes; aqui só inicializa se ninguém o fez.
	if _store == null:
		setup(DEFAULT_PATH)


## Define o arquivo de save e (re)carrega o progresso. Chamado no _ready e pelos testes.
func setup(save_path: String) -> void:
	_store = SaveStore.new(save_path)
	_dirty = false
	_write_blocked = false
	var result: SaveStore.LoadResult = _store.load_data()
	data = result.data
	last_load_status = result.status
	match result.status:
		SaveStore.Status.UNSUPPORTED_VERSION:
			_write_blocked = true
			push_warning("GameState: save de versão mais nova; progresso não será gravado nesta sessão.")
		SaveStore.Status.RESET_CORRUPT:
			push_warning("GameState: save ilegível; iniciando do zero (arquivos preservados).")
		SaveStore.Status.RECOVERED:
			push_warning("GameState: save atual inválido; recuperado de %s." % result.source.get_file())
	progress_changed.emit()


func get_save_path() -> String:
	return _store.path if _store != null else ""


func is_dirty() -> bool:
	return _dirty


func is_write_blocked() -> bool:
	return _write_blocked


# --- Fases -----------------------------------------------------------------------------------

func is_level_completed(level_id: String) -> bool:
	return data.completed_levels.has(level_id)


## Registra a conclusão (idempotente) e descarta o checkpoint da fase, numa única gravação.
## Retorna true só na PRIMEIRA conclusão (útil para recompensas não duplicáveis).
func complete_level(level_id: String) -> bool:
	if not SaveData.is_valid_level_id(level_id):
		push_error("GameState: ID de fase inválido: %s" % level_id)
		return false
	var first_time: bool = not data.completed_levels.has(level_id)
	if first_time:
		data.completed_levels.append(level_id)
	var had_checkpoint: bool = data.checkpoints.erase(level_id)
	if first_time or had_checkpoint:
		_commit()
	return first_time


# --- Checkpoints -----------------------------------------------------------------------------

func get_checkpoint(level_id: String) -> String:
	return String(data.checkpoints.get(level_id, ""))


## Grava o último checkpoint da fase. Retorna false se inválido ou se nada mudou (sem gravar à toa).
func set_checkpoint(level_id: String, checkpoint_id: String) -> bool:
	if not SaveData.is_valid_level_id(level_id) or not SaveData.is_valid_id(checkpoint_id):
		push_error("GameState: ID inválido (fase=%s, checkpoint=%s)" % [level_id, checkpoint_id])
		return false
	if data.checkpoints.get(level_id, "") == checkpoint_id:
		return false
	data.checkpoints[level_id] = checkpoint_id
	_commit()
	return true


func clear_checkpoint(level_id: String) -> void:
	if data.checkpoints.erase(level_id):
		_commit()


# --- Colecionáveis e flags (anti-duplicação) -------------------------------------------------

func has_collected(id: String) -> bool:
	return data.collected.has(id)


## true só na primeira coleta; repetir o mesmo evento nunca concede de novo.
func collect(id: String) -> bool:
	if not SaveData.is_valid_id(id) or data.collected.has(id):
		return false
	data.collected.append(id)
	_commit()
	return true


func has_flag(id: String) -> bool:
	return data.flags.has(id)


func set_flag(id: String) -> bool:
	if not SaveData.is_valid_id(id) or data.flags.has(id):
		return false
	data.flags.append(id)
	_commit()
	return true


# --- Persistência ----------------------------------------------------------------------------

## Grava se houver algo pendente. Retorna o erro de E/S (OK também quando não havia o que gravar).
func flush() -> Error:
	if not _dirty:
		return OK
	if _write_blocked:
		return ERR_LOCKED
	var error: Error = _store.save(data)
	if error == OK:
		_dirty = false
	else:
		push_warning("GameState: falha ao gravar o save (%s); nova tentativa na próxima fronteira." % error_string(error))
	return error


## Apaga TODO o progresso (uso de desenvolvimento/testes; sem UI nesta etapa).
func reset_progress() -> void:
	data = SaveData.new()
	_commit()


func _commit() -> void:
	_dirty = true
	progress_changed.emit()
	flush()


func _notification(what: int) -> void:
	# Android: ao ir para segundo plano o processo pode ser encerrado sem aviso; fecha pendências.
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_APPLICATION_FOCUS_OUT \
			or what == NOTIFICATION_WM_CLOSE_REQUEST:
		flush()
