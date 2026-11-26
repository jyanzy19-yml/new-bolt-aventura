extends BoltTest
## ProgressState (autoload GameState): fronteiras de gravação, idempotência e falhas de disco.

const BASE: String = "user://test_progress_state"


func _clean() -> void:
	for suffix: String in ["", ".tmp", ".bak"]:
		if FileAccess.file_exists(BASE + suffix):
			DirAccess.remove_absolute(BASE + suffix)


func _make() -> ProgressState:
	var state: ProgressState = ProgressState.new()
	state.setup(BASE)
	return state


func _reload() -> ProgressState:
	return _make()  # nova instância = o que o próximo lançamento do app enxerga


func test_complete_level_is_idempotent_and_persists() -> bool:
	_clean()
	var state: ProgressState = _make()
	check_eq(state.complete_level("W1-L1"), true, "primeira conclusão devolve true")
	check_eq(state.complete_level("W1-L1"), false, "repetir não concede de novo")
	check(not state.is_dirty(), "gravado imediatamente na fronteira")
	var again: ProgressState = _reload()
	check(again.is_level_completed("W1-L1"), "persistiu entre sessões")
	check_eq(again.data.completed_levels.size(), 1, "sem duplicata")
	state.free()
	again.free()
	_clean()
	return true


func test_complete_level_discards_checkpoint_in_one_write() -> bool:
	_clean()
	var state: ProgressState = _make()
	state.set_checkpoint("W1-L1", "cp_a")
	state.complete_level("W1-L1")
	var again: ProgressState = _reload()
	check(again.is_level_completed("W1-L1"), "fase concluída")
	check_eq(again.get_checkpoint("W1-L1"), "", "checkpoint descartado: replay começa do início")
	state.free()
	again.free()
	_clean()
	return true


func test_checkpoint_set_get_clear_and_no_redundant_write() -> bool:
	_clean()
	var state: ProgressState = _make()
	var changes: Array[int] = [0]
	state.progress_changed.connect(func() -> void: changes[0] += 1)
	check_eq(state.set_checkpoint("W1-L2", "cp_a"), true, "novo checkpoint gravado")
	check_eq(state.set_checkpoint("W1-L2", "cp_a"), false, "mesmo checkpoint: nada a gravar")
	check_eq(changes[0], 1, "um único evento/gravação")
	check_eq(_reload().get_checkpoint("W1-L2"), "cp_a", "persistido")
	state.set_checkpoint("W1-L2", "cp_b")
	check_eq(state.get_checkpoint("W1-L2"), "cp_b", "avança para o checkpoint seguinte")
	state.clear_checkpoint("W1-L2")
	check_eq(_reload().get_checkpoint("W1-L2"), "", "limpar persiste")
	state.free()
	_clean()
	return true


func test_invalid_ids_are_rejected_without_changing_state() -> bool:
	_clean()
	var state: ProgressState = _make()
	check_eq(state.complete_level("nope"), false, "fase inválida")
	check_eq(state.set_checkpoint("W1-L1", "BAD ID"), false, "checkpoint inválido")
	check_eq(state.set_checkpoint("bad", "cp_a"), false, "fase inválida em checkpoint")
	check_eq(state.collect("A B"), false, "colecionável inválido")
	check_eq(state.set_flag(""), false, "flag inválida")
	check(not state.is_dirty() and not FileAccess.file_exists(BASE), "nada foi gravado")
	state.free()
	_clean()
	return true


func test_collectibles_and_flags_cannot_be_duplicated() -> bool:
	_clean()
	var state: ProgressState = _make()
	check_eq(state.collect("gem_1"), true, "primeira coleta")
	check_eq(state.collect("gem_1"), false, "evento repetido não duplica a recompensa")
	check_eq(state.set_flag("met_npc"), true, "flag nova")
	check_eq(state.set_flag("met_npc"), false, "flag repetida")
	var again: ProgressState = _reload()
	check(again.has_collected("gem_1") and again.has_flag("met_npc"), "persistiram")
	check_eq(again.data.collected.size(), 1, "uma única entrada")
	state.free()
	again.free()
	_clean()
	return true


func test_newer_version_save_blocks_all_writes() -> bool:
	_clean()
	var payload: String = JSON.stringify({"version": 2})
	var future: String = JSON.stringify({"sha256": payload.sha256_text(), "payload": payload})
	var file: FileAccess = FileAccess.open(BASE, FileAccess.WRITE)
	file.store_string(future)
	file.close()
	var state: ProgressState = _make()
	check_eq(state.last_load_status, SaveStore.Status.UNSUPPORTED_VERSION, "detectado")
	check(state.is_write_blocked(), "escrita bloqueada")
	state.complete_level("W1-L1")  # continua jogável em memória
	check(state.is_level_completed("W1-L1"), "progresso em memória na sessão")
	check_eq(state.flush(), ERR_LOCKED, "flush recusado")
	check_eq(FileAccess.get_file_as_string(BASE), future, "arquivo da versão futura intacto")
	state.free()
	_clean()
	return true


func test_corrupt_save_starts_fresh_and_game_keeps_working() -> bool:
	_clean()
	var file: FileAccess = FileAccess.open(BASE, FileAccess.WRITE)
	file.store_string("\u0000\u0001 não é save")
	file.close()
	var state: ProgressState = _make()
	check_eq(state.last_load_status, SaveStore.Status.RESET_CORRUPT, "ilegível detectado")
	check_eq(state.data.completed_levels.size(), 0, "começa do zero")
	check_eq(state.complete_level("W1-L1"), true, "jogo segue e grava")
	check(_reload().is_level_completed("W1-L1"), "novo save válido")
	state.free()
	_clean()
	return true


func test_storage_failure_keeps_progress_dirty_and_retries_on_interruption() -> bool:
	var dir: String = "user://test_progress_dir"
	var path: String = dir + "/p.save"
	if DirAccess.dir_exists_absolute(dir):
		for f: String in DirAccess.get_files_at(dir):
			DirAccess.remove_absolute(dir.path_join(f))
		DirAccess.remove_absolute(dir)
	var state: ProgressState = ProgressState.new()
	state.setup(path)  # diretório não existe: toda gravação falha
	check_eq(state.set_checkpoint("W1-L1", "cp_a"), true, "evento aceito em memória")
	check(state.is_dirty(), "marcado como pendente")
	check_eq(state.get_checkpoint("W1-L1"), "cp_a", "jogo continua com o estado em memória")
	# O armazenamento "volta": a interrupção do app (ir para segundo plano) tenta de novo.
	DirAccess.make_dir_absolute(dir)
	state.notification(Node.NOTIFICATION_APPLICATION_PAUSED)
	check(not state.is_dirty(), "pendência gravada ao pausar o app")
	var again: ProgressState = ProgressState.new()
	again.setup(path)
	check_eq(again.get_checkpoint("W1-L1"), "cp_a", "persistido após a recuperação")
	for f: String in DirAccess.get_files_at(dir):
		DirAccess.remove_absolute(dir.path_join(f))
	DirAccess.remove_absolute(dir)
	state.free()
	again.free()
	return true


func test_reset_progress_wipes_everything() -> bool:
	_clean()
	var state: ProgressState = _make()
	state.complete_level("W1-L1")
	state.collect("gem_1")
	state.reset_progress()
	var again: ProgressState = _reload()
	check_eq(again.data.completed_levels.size() + again.data.collected.size(), 0, "tudo apagado e persistido")
	state.free()
	again.free()
	_clean()
	return true
