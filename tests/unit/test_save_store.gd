extends BoltTest
## SaveStore: gravação atômica, backup, recuperação e recusa de versões futuras.
## Todos os arquivos ficam em user://test_store_* e são removidos ao final de cada teste.

const BASE: String = "user://test_store_save"


func _clean() -> void:
	for suffix: String in ["", ".tmp", ".bak"]:
		if FileAccess.file_exists(BASE + suffix):
			DirAccess.remove_absolute(BASE + suffix)


func _data(level: String) -> SaveData:
	var data: SaveData = SaveData.new()
	data.completed_levels = [level]
	return data


func _write_raw(path: String, text: String) -> void:
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(text)
	file.close()


func _read_raw(path: String) -> String:
	return FileAccess.get_file_as_string(path)


func _envelope(payload: String) -> String:
	return JSON.stringify({"sha256": payload.sha256_text(), "payload": payload})


func test_fresh_when_no_file() -> bool:
	_clean()
	var result: SaveStore.LoadResult = SaveStore.new(BASE).load_data()
	check_eq(result.status, SaveStore.Status.FRESH, "sem arquivo = FRESH")
	check_eq(result.data.completed_levels.size(), 0, "dados vazios")
	return true


func test_save_and_load_roundtrip() -> bool:
	_clean()
	var store: SaveStore = SaveStore.new(BASE)
	check_eq(store.save(_data("W1-L1")), OK, "grava")
	var result: SaveStore.LoadResult = SaveStore.new(BASE).load_data()  # instância nova = leitura do disco
	check_eq(result.status, SaveStore.Status.OK, "carrega do arquivo atual")
	check(result.data.completed_levels.has("W1-L1"), "conteúdo preservado")
	check(not FileAccess.file_exists(BASE + ".tmp"), "tmp não sobra após gravar")
	_clean()
	return true


func test_second_save_rotates_previous_to_backup() -> bool:
	_clean()
	var store: SaveStore = SaveStore.new(BASE)
	store.save(_data("W1-L1"))
	store.save(_data("W1-L2"))
	check(FileAccess.file_exists(BASE + ".bak"), "backup criado")
	check(store.load_data().data.completed_levels.has("W1-L2"), "atual tem o save novo")
	_write_raw(BASE, "lixo")
	var recovered: SaveStore.LoadResult = store.load_data()
	check_eq(recovered.status, SaveStore.Status.RECOVERED, "atual corrompido recupera do backup")
	check(recovered.data.completed_levels.has("W1-L1"), "backup tem o save anterior")
	_clean()
	return true


func test_truncated_and_garbage_files_are_never_loaded() -> bool:
	_clean()
	var store: SaveStore = SaveStore.new(BASE)
	store.save(_data("W1-L1"))
	var good: String = _read_raw(BASE)
	for broken: String in ["", "{", good.left(good.length() / 2), "null", "[]", "{\"payload\": 3}", good.replace("W1-L1", "W1-L2")]:
		_write_raw(BASE, broken)
		var result: SaveStore.LoadResult = store.load_data()
		check_eq(result.status, SaveStore.Status.RESET_CORRUPT, "recusado: '%s'" % broken.left(24).replace("\n", " "))
		check_eq(result.data.completed_levels.size(), 0, "nada aproveitado de arquivo inválido")
	_clean()
	return true


func test_tampered_payload_fails_checksum() -> bool:
	_clean()
	var store: SaveStore = SaveStore.new(BASE)
	store.save(_data("W1-L1"))
	# JSON continua válido, mas o conteúdo mudou: só o hash denuncia.
	_write_raw(BASE, _read_raw(BASE).replace("W1-L1", "W7-L6"))
	check_eq(store.load_data().status, SaveStore.Status.RESET_CORRUPT, "alteração detectada pelo hash")
	_clean()
	return true


func test_interrupted_write_leaves_previous_save_intact() -> bool:
	_clean()
	var store: SaveStore = SaveStore.new(BASE)
	store.save(_data("W1-L1"))
	_write_raw(BASE + ".tmp", "{\"sha256\": \"abc\", \"payl")  # queda no meio da escrita do tmp
	var result: SaveStore.LoadResult = store.load_data()
	check_eq(result.status, SaveStore.Status.OK, "atual válido prevalece sobre tmp parcial")
	check(result.data.completed_levels.has("W1-L1"), "save anterior intacto")
	check_eq(store.save(_data("W1-L2")), OK, "próxima gravação funciona e substitui o tmp velho")
	check(store.load_data().data.completed_levels.has("W1-L2"), "save novo gravado")
	_clean()
	return true


func test_crash_between_rotation_and_promotion_recovers_newest() -> bool:
	_clean()
	var store: SaveStore = SaveStore.new(BASE)
	store.save(_data("W1-L1"))
	# Estado deixado por uma queda após "atual -> backup" e antes de "tmp -> atual":
	# atual ausente, backup = save antigo, tmp = save novo completo.
	DirAccess.rename_absolute(BASE, BASE + ".bak")
	_write_raw(BASE + ".tmp", _envelope(JSON.stringify(_data("W1-L2").to_dict(), "", true)))
	var result: SaveStore.LoadResult = store.load_data()
	check_eq(result.status, SaveStore.Status.RECOVERED, "recuperado")
	check(result.data.completed_levels.has("W1-L2"), "usa o tmp completo (mais novo)")
	_clean()
	return true


func test_corrupt_main_never_replaces_good_backup() -> bool:
	_clean()
	var store: SaveStore = SaveStore.new(BASE)
	store.save(_data("W1-L1"))
	store.save(_data("W1-L2"))  # atual=L2, backup=L1
	_write_raw(BASE, "corrompido")
	check_eq(store.save(_data("W1-L3")), OK, "grava por cima do atual corrompido")
	check(store.load_data().data.completed_levels.has("W1-L3"), "atual novo")
	# O backup precisa continuar sendo o save BOM (L1), não o arquivo corrompido.
	DirAccess.remove_absolute(BASE)
	var from_backup: SaveStore.LoadResult = store.load_data()
	check_eq(from_backup.status, SaveStore.Status.RECOVERED, "backup utilizável")
	check(from_backup.data.completed_levels.has("W1-L1"), "backup bom preservado")
	_clean()
	return true


func test_newer_version_is_reported_and_never_overwritten() -> bool:
	_clean()
	var future: String = _envelope(JSON.stringify({"version": 2, "completed_levels": ["W1-L1"]}))
	_write_raw(BASE, future)
	var store: SaveStore = SaveStore.new(BASE)
	check_eq(store.load_data().status, SaveStore.Status.UNSUPPORTED_VERSION, "versão futura detectada")
	check_eq(store.save(_data("W1-L1")), ERR_LOCKED, "gravação recusada")
	check_eq(_read_raw(BASE), future, "arquivo da versão futura intacto")
	check(not FileAccess.file_exists(BASE + ".bak"), "nenhum backup/rotação criado")
	_clean()
	return true


func test_unavailable_storage_returns_error_without_crashing() -> bool:
	var store: SaveStore = SaveStore.new("user://test_store_missing_dir/x.save")
	check(store.save(_data("W1-L1")) != OK, "erro de E/S devolvido")
	check_eq(store.load_data().status, SaveStore.Status.FRESH, "leitura sem diretório = FRESH")
	return true
