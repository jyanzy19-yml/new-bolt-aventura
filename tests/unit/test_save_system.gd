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
	check(system.call("save_payload", payload), "cria save de referência")
	var copy_error: Error = DirAccess.copy_absolute(
		ProjectSettings.globalize_path(TEST_SAVE_PATH),
		ProjectSettings.globalize_path(TEST_SAVE_PATH + ".bak")
	)
	check_eq(copy_error, OK, "cria backup de recuperação")
	var corrupted: FileAccess = FileAccess.open(TEST_SAVE_PATH, FileAccess.WRITE)
	check(corrupted != null, "abre o arquivo principal para simular corrupção")
	if corrupted != null:
		corrupted.store_string("{invalid-json")
		corrupted.flush()
		corrupted.close()
	check_eq(system.call("load_payload"), payload, "recupera o payload válido do backup")
	check_eq(system.get("last_error"), "recovered_backup", "registra que houve recuperação do backup")
	check(system.call("delete_save"), "remove arquivos temporários após o teste")
	_cleanup()
	return true


func test_future_format_is_rejected_and_non_json_values_are_blocked() -> bool:
	var system: Node = _system()
	if system == null:
		check(false, "autoload SaveSystem presente")
		return true
	system.call("delete_save")
	var future_file: FileAccess = FileAccess.open(TEST_SAVE_PATH, FileAccess.WRITE)
	check(future_file != null, "cria fixture com versão futura")
	if future_file != null:
		future_file.store_string(JSON.stringify({
			"format_version": 999,
			"payload": {},
			"checksum": "not-used",
		}))
		future_file.close()
	check_eq(system.call("load_payload"), {}, "não interpreta formato futuro como save atual")
	check_eq(system.get("last_error"), "unsupported_format_version", "expõe erro de versão incompatível")

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
