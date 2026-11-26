extends BoltTest
## Testes do armazenamento versionado sem tocar no slot real do usuário.

const TEST_SAVE_PATH: String = "user://bolt_save_test.json"

var _previous_storage_path_override: String = ""


func _system() -> Node:
	var system: Node = tree.root.get_node_or_null("SaveSystem")
	if system != null:
		_previous_storage_path_override = str(system.get("storage_path_override"))
		system.set("storage_path_override", TEST_SAVE_PATH)
	return system


func _cleanup() -> void:
	var system: Node = tree.root.get_node_or_null("SaveSystem")
	if system == null:
		return
	if str(system.get("storage_path_override")) == TEST_SAVE_PATH:
		system.call("delete_save")
		system.set("storage_path_override", _previous_storage_path_override)


func _write_envelope(path: String, payload: Dictionary, version: Variant = 1) -> bool:
	var system: Node = tree.root.get_node_or_null("SaveSystem")
	if system == null:
		return false
	var payload_json: String = str(system.call("_canonical_json", payload))
	var envelope: Dictionary = {
		"format_version": version,
		"payload_json": payload_json,
		"checksum": str(system.call("_checksum", payload_json)),
	}
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify(envelope))
	file.flush()
	var write_error: Error = file.get_error()
	file.close()
	return write_error == OK


func _write_future_envelope(path: String) -> bool:
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify({
		"format_version": 999,
		"payload_json": "{\"future\":true}",
		"checksum": "future-checksum",
	}))
	file.flush()
	var write_error: Error = file.get_error()
	file.close()
	return write_error == OK


func _read_text(path: String) -> String:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return ""
	var value: String = file.get_as_text()
	file.close()
	return value


func test_save_payload_round_trips_overwrites_and_deletes() -> bool:
	var system: Node = _system()
	check(system != null, "autoload SaveSystem presente")
	if system == null:
		return true
	check(system.call("delete_save"), "limpa somente o slot temporário de teste")
	var first_payload: Dictionary = {
		"level_id": "W1-L1",
		"checkpoint_id": "cybercore_w1_l1_checkpoint",
		"completed": ["tutorial"],
		"stats": {"deaths": 2, "energy": 3},
	}
	check(system.call("save_payload", first_payload), "grava payload JSON versionado")
	check(system.call("has_save"), "slot fica disponível após gravação")
	var first_loaded: Dictionary = system.call("load_payload")
	check_eq(first_loaded.get("level_id"), "W1-L1", "campo textual de fase é recuperado")
	check_eq(first_loaded.get("checkpoint_id"), "cybercore_w1_l1_checkpoint", "ID estável do checkpoint é recuperado")
	check_eq(first_loaded.get("completed"), ["tutorial"], "lista de progresso é recuperada")
	var loaded_stats: Dictionary = first_loaded.get("stats", {})
	check_eq(int(loaded_stats.get("deaths", -1)), 2, "valor numérico inteiro pode ser convertido pelo domínio")
	check_eq(int(loaded_stats.get("energy", -1)), 3, "segundo valor numérico pode ser convertido pelo domínio")

	var second_payload: Dictionary = {"level_id": "W1-L2", "completed": ["tutorial", "W1-L1"]}
	check(system.call("save_payload", second_payload), "substitui o save anterior")
	check_eq(system.call("load_payload"), second_payload, "leitura retorna a versão mais recente")
	check(system.call("delete_save"), "delete_save remove os arquivos do slot de teste")
	check(not system.call("has_save"), "slot deixa de existir após remoção")
	check_eq(system.call("load_payload"), {}, "save ausente retorna payload vazio")
	_cleanup()
	return true


func test_corrupt_primary_recovers_valid_backup() -> bool:
	var system: Node = _system()
	if system == null:
		check(false, "autoload SaveSystem presente")
		return true
	system.call("delete_save")
	var payload: Dictionary = {"level_id": "W1-L1", "checkpoint_id": "cp_01"}
	var newer_payload: Dictionary = {"level_id": "W1-L2", "checkpoint_id": "cp_02"}
	check(system.call("save_payload", payload), "cria primeiro save de referência")
	check(system.call("save_payload", newer_payload), "grava uma versão mais recente")
	check(FileAccess.file_exists(TEST_SAVE_PATH + ".bak"), "mantém backup automático da última versão íntegra")
	var corrupted: FileAccess = FileAccess.open(TEST_SAVE_PATH, FileAccess.WRITE)
	check(corrupted != null, "abre o arquivo principal para simular corrupção")
	if corrupted != null:
		corrupted.store_string("{invalid-json")
		corrupted.flush()
		corrupted.close()
	check_eq(system.call("load_payload"), payload, "recupera a versão anterior íntegra do backup")
	check_eq(system.get("last_error"), "recovered_backup", "registra que houve recuperação do backup")

	var recovered_update: Dictionary = {"level_id": "W1-L3", "checkpoint_id": "cp_03"}
	check(system.call("save_payload", recovered_update), "grava após recuperação do backup")
	check_eq(system.call("load_payload"), recovered_update, "novo estado passa a ser o principal")
	check(FileAccess.file_exists(TEST_SAVE_PATH + ".bak"), "backup last-known-good continua presente após novo commit")
	var corrupted_again: FileAccess = FileAccess.open(TEST_SAVE_PATH, FileAccess.WRITE)
	check(corrupted_again != null, "reabre o principal para validar o backup após a gravação recuperada")
	if corrupted_again != null:
		corrupted_again.store_string("{invalid-json-again")
		corrupted_again.flush()
		corrupted_again.close()
	check_eq(system.call("load_payload"), payload, "backup permanece íntegro após recuperação seguida de nova gravação")
	check_eq(system.get("last_error"), "recovered_backup", "segunda recuperação é identificada")
	check(system.call("delete_save"), "remove arquivos temporários após o teste")
	_cleanup()
	return true


func test_future_format_is_rejected_and_non_json_values_are_blocked() -> bool:
	var system: Node = _system()
	if system == null:
		check(false, "autoload SaveSystem presente")
		return true
	system.call("delete_save")
	check(_write_future_envelope(TEST_SAVE_PATH), "cria fixture com versão futura")
	check_eq(system.call("load_payload"), {}, "não interpreta formato futuro como save atual")
	check_eq(system.get("last_error"), "unsupported_format_version", "expõe erro de versão incompatível")
	system.call("delete_save")

	var runtime_node: Node = Node.new()
	check(not system.call("save_payload", {"runtime_node": runtime_node}), "recusa referências a Nodes no payload")
	check_eq(system.get("last_error"), "payload_not_json_compatible", "expõe payload não serializável")
	runtime_node.free()
	check(system.call("delete_save"), "limpa fixture de versão futura")
	_cleanup()
	return true


func test_missing_save_is_a_clean_empty_state() -> bool:
	var system: Node = _system()
	if system == null:
		check(false, "autoload SaveSystem presente")
		return true
	system.call("delete_save")
	check_eq(system.call("load_payload"), {}, "slot inexistente é um estado vazio")
	check_eq(system.get("last_error"), "", "ausência de save não é erro de corrupção")
	_cleanup()
	return true


func test_format_version_rejects_fractional_and_textual_values() -> bool:
	var system: Node = _system()
	check(system != null, "autoload SaveSystem presente")
	if system == null:
		return true
	system.call("delete_save")
	var payload_json: String = JSON.stringify({"settings": {"music": 0.5}})
	var checksum: String = str(system.call("_checksum", payload_json))
	var envelope: Dictionary = {
		"format_version": 1.5,
		"payload_json": payload_json,
		"checksum": checksum,
	}
	var file: FileAccess = FileAccess.open(TEST_SAVE_PATH, FileAccess.WRITE)
	check(file != null, "cria envelope com versão fracionária")
	if file != null:
		file.store_string(JSON.stringify(envelope))
		file.close()
	check_eq(system.call("load_payload"), {}, "versão fracionária é rejeitada")
	check_eq(system.get("last_error"), "unsupported_format_version", "versão fracionária informa incompatibilidade")

	envelope["format_version"] = "1"
	file = FileAccess.open(TEST_SAVE_PATH, FileAccess.WRITE)
	check(file != null, "cria envelope com versão textual")
	if file != null:
		file.store_string(JSON.stringify(envelope))
		file.close()
	check_eq(system.call("load_payload"), {}, "versão textual não é convertida para inteiro")
	check_eq(system.get("last_error"), "unsupported_format_version", "versão textual informa incompatibilidade")

	envelope["format_version"] = 1.0
	file = FileAccess.open(TEST_SAVE_PATH, FileAccess.WRITE)
	check(file != null, "cria envelope com número integral em representação float")
	if file != null:
		file.store_string(JSON.stringify(envelope))
		file.close()
	check_eq(system.call("load_payload"), {"settings": {"music": 0.5}}, "aceita número float exatamente integral")
	check_eq(system.get("last_error"), "", "representação numérica integral não gera erro")
	_cleanup()
	return true


func test_complete_temp_is_recovered_before_older_backup() -> bool:
	var system: Node = _system()
	check(system != null, "autoload SaveSystem presente")
	if system == null:
		return true
	system.call("delete_save")
	var backup_payload: Dictionary = {"level_id": "W1-L1", "revision": 1}
	var interrupted_payload: Dictionary = {"level_id": "W1-L2", "revision": 2}
	check(system.call("save_payload", backup_payload), "grava estado inicial")
	check(system.call("save_payload", interrupted_payload), "cria backup anterior e principal novo")
	check(DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_SAVE_PATH)) == OK, "simula interrupção após principal ser movido para backup")
	check(_write_envelope(TEST_SAVE_PATH + ".tmp", {"level_id": "W1-L3", "revision": 3}), "prepara temporário completo de gravação interrompida")
	check(system.call("has_save"), "slot reconhece temporário recuperável")
	var recovered: Dictionary = system.call("load_payload")
	check_eq(recovered.get("level_id"), "W1-L3", "prefere temporário íntegro ao backup mais antigo")
	check_eq(int(recovered.get("revision", -1)), 3, "recupera revisão numérica do temporário")
	check_eq(system.get("last_error"), "recovered_temp", "identifica recuperação do temporário")
	check(FileAccess.file_exists(TEST_SAVE_PATH), "promove temporário recuperado ao arquivo principal")
	check(not FileAccess.file_exists(TEST_SAVE_PATH + ".tmp"), "remove temporário após promoção bem-sucedida")
	check_eq(system.call("load_payload"), recovered, "segunda leitura usa o principal recuperado")

	# Uma nova gravação não pode apagar um temporário completo ainda pendente.
	var pending_payload: Dictionary = {"level_id": "W1-L4", "revision": 4}
	var replacement_payload: Dictionary = {"level_id": "W1-L5", "revision": 5}
	check(DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_SAVE_PATH)) == OK, "simula principal ausente antes de nova gravação")
	check(_write_envelope(TEST_SAVE_PATH + ".tmp", pending_payload), "prepara commit pendente anterior")
	check(system.call("save_payload", replacement_payload), "nova gravação consolida o temporário anterior antes de substituir")
	var replacement_loaded: Dictionary = system.call("load_payload")
	check_eq(replacement_loaded.get("level_id"), "W1-L5", "nova gravação torna-se o principal")
	check_eq(int(replacement_loaded.get("revision", -1)), 5, "nova revisão fica persistida")
	var corrupt_after_write: FileAccess = FileAccess.open(TEST_SAVE_PATH, FileAccess.WRITE)
	check(corrupt_after_write != null, "corrompe principal para verificar backup da gravação pendente")
	if corrupt_after_write != null:
		corrupt_after_write.store_string("{corrupt-after-pending-write")
		corrupt_after_write.close()
	var pending_loaded: Dictionary = system.call("load_payload")
	check_eq(pending_loaded.get("level_id"), "W1-L4", "backup preserva o temporário que existia antes da nova gravação")
	check_eq(int(pending_loaded.get("revision", -1)), 4, "backup preserva a revisão pendente anterior")
	check_eq(system.get("last_error"), "recovered_backup", "identifica recuperação do estado pendente preservado")

	# Um principal íntegro continua sendo autoridade sobre qualquer .tmp residual.
	system.call("delete_save")
	var authoritative_payload: Dictionary = {"level_id": "W1-L6", "revision": 6}
	var stale_temp_payload: Dictionary = {"level_id": "W1-L5", "revision": 5}
	check(system.call("save_payload", authoritative_payload), "grava principal autoritativo")
	check(_write_envelope(TEST_SAVE_PATH + ".tmp", stale_temp_payload), "prepara temporário residual")
	var authoritative_loaded: Dictionary = system.call("load_payload")
	check_eq(authoritative_loaded.get("level_id"), "W1-L6", "principal íntegro tem precedência sobre temporário residual")
	check_eq(int(authoritative_loaded.get("revision", -1)), 6, "principal autoritativo preserva revisão")
	check(FileAccess.file_exists(TEST_SAVE_PATH + ".tmp"), "leitura do principal não consome temporário não confirmado")

	# Um temporário inválido não impede a recuperação do backup válido.
	system.call("delete_save")
	check(system.call("save_payload", backup_payload), "cria backup íntegro para fallback")
	check(system.call("save_payload", authoritative_payload), "cria principal mais recente")
	var invalid_primary: FileAccess = FileAccess.open(TEST_SAVE_PATH, FileAccess.WRITE)
	check(invalid_primary != null, "abre principal para simular corrupção")
	if invalid_primary != null:
		invalid_primary.store_string("{broken-primary")
		invalid_primary.close()
	var invalid_temp: FileAccess = FileAccess.open(TEST_SAVE_PATH + ".tmp", FileAccess.WRITE)
	check(invalid_temp != null, "cria temporário incompleto")
	if invalid_temp != null:
		invalid_temp.store_string("{broken-temp")
		invalid_temp.close()
	var recovered_backup: Dictionary = system.call("load_payload")
	check_eq(recovered_backup.get("level_id"), "W1-L1", "temporário inválido é ignorado e backup válido recuperado")
	check_eq(int(recovered_backup.get("revision", -1)), 1, "backup recuperado preserva revisão")
	check_eq(system.get("last_error"), "recovered_backup", "fallback para backup informa recuperação")
	_cleanup()
	return true


func test_future_format_in_any_slot_blocks_writes_without_mutation() -> bool:
	var system: Node = _system()
	check(system != null, "autoload SaveSystem presente")
	if system == null:
		return true
	var payload: Dictionary = {"level_id": "W1-L1", "revision": 1}
	var replacement: Dictionary = {"level_id": "W1-L2", "revision": 2}

	# Um principal futuro impede fallback e impede que uma gravação atual o substitua.
	system.call("delete_save")
	check(system.call("save_payload", payload), "prepara backup atual")
	check(DirAccess.rename_absolute(ProjectSettings.globalize_path(TEST_SAVE_PATH), ProjectSettings.globalize_path(TEST_SAVE_PATH + ".bak")) == OK, "move estado atual para backup")
	check(_write_future_envelope(TEST_SAVE_PATH), "grava envelope futuro no principal")
	var future_primary_before: String = _read_text(TEST_SAVE_PATH)
	var backup_before: String = _read_text(TEST_SAVE_PATH + ".bak")
	check(not system.call("save_payload", replacement), "recusa gravação quando principal usa versão futura")
	check_eq(system.get("last_error"), "unsupported_format_version", "informa bloqueio por versão futura")
	check_eq(_read_text(TEST_SAVE_PATH), future_primary_before, "preserva bytes do principal futuro")
	check_eq(_read_text(TEST_SAVE_PATH + ".bak"), backup_before, "preserva backup durante bloqueio")
	check_eq(system.call("load_payload"), {}, "não faz downgrade para backup antigo quando principal é futuro")
	check_eq(system.get("last_error"), "unsupported_format_version", "leitura mantém diagnóstico de versão futura")

	# Um backup futuro também não pode ser apagado durante a rotação do principal.
	system.call("delete_save")
	check(system.call("save_payload", payload), "cria principal atual para teste de backup")
	check(_write_future_envelope(TEST_SAVE_PATH + ".bak"), "grava envelope futuro no backup")
	var primary_before: String = _read_text(TEST_SAVE_PATH)
	var future_backup_before: String = _read_text(TEST_SAVE_PATH + ".bak")
	check_eq(system.call("load_payload"), {}, "backup futuro impede leitura de principal possivelmente antigo")
	check_eq(system.get("last_error"), "unsupported_format_version", "leitura identifica formato futuro no backup")
	check_eq(_read_text(TEST_SAVE_PATH), primary_before, "leitura bloqueada não altera o principal")
	check(not system.call("save_payload", replacement), "recusa rotação quando backup usa versão futura")
	check_eq(_read_text(TEST_SAVE_PATH), primary_before, "principal atual permanece intacto")
	check_eq(_read_text(TEST_SAVE_PATH + ".bak"), future_backup_before, "backup futuro permanece intacto")

	# Um temporário futuro é preservado e bloqueia fallback para backup antigo.
	system.call("delete_save")
	check(system.call("save_payload", payload), "cria backup antigo antes de simular temporário futuro")
	check(DirAccess.rename_absolute(ProjectSettings.globalize_path(TEST_SAVE_PATH), ProjectSettings.globalize_path(TEST_SAVE_PATH + ".bak")) == OK, "move estado antigo para backup")
	check(_write_future_envelope(TEST_SAVE_PATH + ".tmp"), "grava envelope futuro no temporário")
	var future_temp_before: String = _read_text(TEST_SAVE_PATH + ".tmp")
	check_eq(system.call("load_payload"), {}, "temporário futuro impede fallback para backup antigo")
	check_eq(system.get("last_error"), "unsupported_format_version", "leitura informa formato futuro no temporário")
	check(not system.call("save_payload", replacement), "recusa gravação quando temporário usa versão futura")
	check_eq(_read_text(TEST_SAVE_PATH + ".tmp"), future_temp_before, "temporário futuro permanece intacto")
	_cleanup()
	return true
