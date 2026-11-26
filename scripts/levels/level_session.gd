class_name LevelSession
extends Node
## Sessão de uma fase: ponte entre o nível (cena) e o progresso persistente.
##
## O nível informa EVENTOS por IDs estáveis (checkpoint alcançado, queda, objetivo); o
## `ProgressState` decide o que persiste. A fase não conhece o formato do save e o save não
## conhece Nodes (docs/technical/05-system-contracts.md §4 e §8).
##
## - Reaparecimento: último checkpoint alcançado, ou o ponto inicial. Todo estado transitório do
##   jogador é zerado por `BoltPlayer.respawn`, então a queda nunca "prende" um dash/pulo.
## - Retomada: ao iniciar, restaura o checkpoint salvo. Se o ID salvo não existe mais na cena
##   (conteúdo mudou), ele é descartado e a fase começa do início — nunca fica sem saída.
## - Sem `ProgressState` (testes, cena aberta isolada) tudo funciona só em memória.

signal checkpoint_changed(checkpoint_id: StringName)

var level_id: String = ""
var progress: ProgressState

var _player: BoltPlayer
var _spawn_position: Vector2 = Vector2.ZERO
var _checkpoints: Dictionary = {}  # StringName -> Checkpoint
var _current: Checkpoint
var _completed: bool = false


## `progress` nulo = tenta o autoload `/root/GameState`; em testes passe um ProgressState próprio.
func start(level: String, player: BoltPlayer, spawn_position: Vector2, checkpoint_nodes: Array[Checkpoint], progress_service: ProgressState = null) -> void:
	level_id = level
	_player = player
	_spawn_position = spawn_position
	progress = progress_service if progress_service != null else get_node_or_null("/root/GameState") as ProgressState
	for checkpoint: Checkpoint in checkpoint_nodes:
		if checkpoint.checkpoint_id == &"" or _checkpoints.has(checkpoint.checkpoint_id):
			push_error("LevelSession: checkpoint com ID vazio/duplicado em %s" % level_id)
			continue
		_checkpoints[checkpoint.checkpoint_id] = checkpoint
		checkpoint.reached.connect(_on_checkpoint_reached)
	_restore_saved_checkpoint()
	_player.respawn(current_respawn_position())


func current_checkpoint_id() -> StringName:
	return _current.checkpoint_id if _current != null else &""


func current_respawn_position() -> Vector2:
	return _current.get_respawn_position() if _current != null else _spawn_position


## Queda no vazio / dano fatal: volta ao último ponto seguro.
func respawn_player() -> void:
	_player.respawn(current_respawn_position())


## Objetivo alcançado. Retorna true só na primeira conclusão desta fase.
func complete() -> bool:
	if _completed:
		return false
	_completed = true
	if progress == null:
		return true
	return progress.complete_level(level_id)


func _restore_saved_checkpoint() -> void:
	if progress == null:
		return
	var saved: String = progress.get_checkpoint(level_id)
	if saved == "":
		return
	var found: Checkpoint = _checkpoints.get(StringName(saved)) as Checkpoint
	if found == null:
		push_warning("LevelSession: checkpoint salvo '%s' não existe em %s; reiniciando a fase." % [saved, level_id])
		progress.clear_checkpoint(level_id)
		return
	_activate(found)


func _on_checkpoint_reached(checkpoint: Checkpoint) -> void:
	if checkpoint == _current:
		return  # repetir o mesmo checkpoint não regrava nada
	_activate(checkpoint)
	if progress != null:
		progress.set_checkpoint(level_id, String(checkpoint.checkpoint_id))


func _activate(checkpoint: Checkpoint) -> void:
	_current = checkpoint
	for other: Checkpoint in _checkpoints.values():
		other.set_active(other == checkpoint)
	checkpoint_changed.emit(checkpoint.checkpoint_id)
