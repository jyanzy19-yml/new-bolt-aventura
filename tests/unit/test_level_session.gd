extends BoltTest
## LevelSession + Checkpoint: reaparecimento, retomada, persistência e conclusão.
## Usa o BoltPlayer e o Checkpoint reais (física headless) numa cena mínima, sem chão.

const BOLT_SCENE: String = "res://scenes/player/bolt.tscn"
const CHECKPOINT_SCENE: String = "res://scenes/world/checkpoint.tscn"
const SAVE: String = "user://test_level_session"
const LEVEL: String = "dev.test_level"
const SPAWN: Vector2 = Vector2(100.0, 0.0)

var _root: Node2D
var _player: BoltPlayer
var _cp_a: Checkpoint
var _cp_b: Checkpoint
var _progress: ProgressState
var _session: LevelSession


func _clean() -> void:
	for suffix: String in ["", ".tmp", ".bak"]:
		if FileAccess.file_exists(SAVE + suffix):
			DirAccess.remove_absolute(SAVE + suffix)


func _build(progress_path: String = SAVE) -> void:
	Actions.release_all_game_actions()
	_root = Node2D.new()
	_player = (load(BOLT_SCENE) as PackedScene).instantiate() as BoltPlayer
	_cp_a = (load(CHECKPOINT_SCENE) as PackedScene).instantiate() as Checkpoint
	_cp_b = (load(CHECKPOINT_SCENE) as PackedScene).instantiate() as Checkpoint
	_cp_a.checkpoint_id = &"cp_a"
	_cp_a.position = Vector2(1000.0, 0.0)
	_cp_b.checkpoint_id = &"cp_b"
	_cp_b.position = Vector2(2000.0, 0.0)
	_root.add_child(_cp_a)
	_root.add_child(_cp_b)
	_root.add_child(_player)
	tree.root.add_child(_root)
	_progress = ProgressState.new()
	_progress.setup(progress_path)
	_session = LevelSession.new()
	_root.add_child(_session)
	_session.start(LEVEL, _player, SPAWN, [_cp_a, _cp_b] as Array[Checkpoint], _progress)
	await tree.physics_frame


func _teardown(keep_save: bool = false) -> void:
	_root.queue_free()
	_progress.free()
	await tree.process_frame
	if not keep_save:
		_clean()


## Põe BOLT dentro da área do checkpoint e espera a física detectar a entrada.
func _walk_into(checkpoint: Checkpoint) -> void:
	_player.global_position = checkpoint.global_position
	_player.velocity = Vector2.ZERO
	await tree.physics_frame
	await tree.physics_frame


func test_starts_at_spawn_without_save() -> bool:
	_clean()
	await _build()
	check_eq(_session.current_checkpoint_id(), &"", "sem checkpoint ativo")
	check_near(_player.global_position.x, SPAWN.x, 1.0, "BOLT começa no ponto inicial")
	check(not _cp_a.active and not _cp_b.active, "nenhum visual ativo")
	await _teardown()
	return true


func test_reaching_checkpoint_activates_and_persists() -> bool:
	_clean()
	await _build()
	await _walk_into(_cp_a)
	check_eq(_session.current_checkpoint_id(), &"cp_a", "checkpoint atual")
	check(_cp_a.active and not _cp_b.active, "só o atual aparece ativo")
	check_eq(_progress.get_checkpoint(LEVEL), "cp_a", "persistido no serviço")
	var from_disk: ProgressState = ProgressState.new()
	from_disk.setup(SAVE)
	check_eq(from_disk.get_checkpoint(LEVEL), "cp_a", "persistido em disco")
	from_disk.free()
	await _teardown()
	return true


func test_respawn_uses_last_checkpoint_and_resets_motion() -> bool:
	_clean()
	await _build()
	await _walk_into(_cp_a)
	await _walk_into(_cp_b)
	check_eq(_session.current_checkpoint_id(), &"cp_b", "avançou para cp_b")
	check(_cp_b.active and not _cp_a.active, "visual migra para o novo")
	_player.global_position = Vector2(-5000.0, 3000.0)  # "caiu no vazio"
	_player.velocity = Vector2(300.0, 700.0)
	_session.respawn_player()
	check_near(_player.global_position.x, 2000.0, 0.5, "reaparece em cp_b (x)")
	check_near(_player.global_position.y, 0.0, 0.5, "reaparece em cp_b (y)")
	check_eq(_player.velocity, Vector2.ZERO, "velocidade zerada: sem herdar a queda")
	_session.respawn_player()
	check_near(_player.global_position.x, 2000.0, 0.5, "repetir leva ao mesmo ponto (sem ciclo de morte)")
	await _teardown()
	return true


func test_revisiting_same_checkpoint_does_not_rewrite() -> bool:
	_clean()
	await _build()
	var changes: Array[int] = [0]
	_progress.progress_changed.connect(func() -> void: changes[0] += 1)
	await _walk_into(_cp_a)
	_player.global_position = Vector2(500.0, 0.0)
	await tree.physics_frame
	await tree.physics_frame
	await _walk_into(_cp_a)
	check_eq(changes[0], 1, "uma única gravação para o mesmo checkpoint")
	await _teardown()
	return true


func test_checkpoint_can_go_back_to_earlier_one() -> bool:
	# Regra: vale o ÚLTIMO alcançado, não o mais distante (nenhuma ordem é presumida aqui).
	_clean()
	await _build()
	await _walk_into(_cp_b)
	await _walk_into(_cp_a)
	check_eq(_session.current_checkpoint_id(), &"cp_a", "último alcançado")
	await _teardown()
	return true


func test_resume_restores_saved_checkpoint() -> bool:
	_clean()
	await _build()
	await _walk_into(_cp_b)
	await _teardown(true)  # o save fica em disco, como ao fechar o app
	# Novo lançamento do app: mesma fase, mesmo arquivo de save.
	await _build()
	check_eq(_session.current_checkpoint_id(), &"cp_b", "checkpoint restaurado")
	check_near(_player.global_position.x, 2000.0, 0.5, "BOLT retoma em cp_b")
	check(_cp_b.active, "visual restaurado")
	await _teardown()
	return true


func test_unknown_saved_checkpoint_falls_back_to_start() -> bool:
	_clean()
	var seed: ProgressState = ProgressState.new()
	seed.setup(SAVE)
	seed.set_checkpoint(LEVEL, "cp_removed_in_update")
	seed.free()
	await _build()
	check_eq(_session.current_checkpoint_id(), &"", "checkpoint inexistente ignorado")
	check_near(_player.global_position.x, SPAWN.x, 1.0, "começa do início (sem softlock)")
	check_eq(_progress.get_checkpoint(LEVEL), "", "ID órfão removido do save")
	await _teardown()
	return true


func test_complete_is_once_and_clears_checkpoint() -> bool:
	_clean()
	await _build()
	await _walk_into(_cp_a)
	check_eq(_session.complete(), true, "primeira conclusão")
	check_eq(_session.complete(), false, "objetivo repetido não conclui de novo")
	check(_progress.is_level_completed(LEVEL), "fase marcada como concluída")
	check_eq(_progress.get_checkpoint(LEVEL), "", "checkpoint descartado")
	await _teardown()
	await _build()
	check_eq(_session.current_checkpoint_id(), &"", "nova sessão começa do início")
	await _teardown()
	return true


func test_works_without_progress_service() -> bool:
	_clean()
	await _build()
	var bare: LevelSession = LevelSession.new()
	_root.add_child(bare)
	# Sem serviço explícito e sem o autoload acessível por este caminho de teste, o tipo nulo é tolerado.
	bare.level_id = LEVEL
	check_eq(bare.complete(), true, "conclui sem persistência")
	await _teardown()
	return true


func test_duplicate_or_empty_checkpoint_ids_are_rejected() -> bool:
	_clean()
	await _build()
	_cp_b.checkpoint_id = &"cp_a"  # duplicado (cenário de erro de autoria)
	var other: LevelSession = LevelSession.new()
	_root.add_child(other)
	other.start("dev.other", _player, SPAWN, [_cp_a, _cp_b] as Array[Checkpoint], _progress)
	_player.global_position = _cp_b.global_position
	await tree.physics_frame
	await tree.physics_frame
	check_eq(other.current_checkpoint_id(), &"", "checkpoint de ID duplicado não foi registrado")
	check_eq(_progress.get_checkpoint("dev.other"), "", "nada gravado para ele")
	await _teardown()
	return true
