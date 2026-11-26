class_name SaveStore
extends RefCounted
## Leitura/escrita do save em disco com escrita atômica, backup e recuperação.
##
## Arquivos (todos ao lado de `path`): `<path>` (atual), `<path>.tmp` (escrita em andamento),
## `<path>.bak` (versão anterior válida).
##
## Gravação: (1) escreve `.tmp` e RELÊ/verifica; (2) se o atual é válido, ele vira `.bak`
## (um atual corrompido NUNCA substitui um backup bom); (3) `.tmp` vira o atual (rename).
## Uma interrupção em qualquer ponto deixa pelo menos um arquivo válido. Leitura tenta, em
## ordem: atual → tmp → bak; o primeiro que passar na verificação de integridade vence.
##
## Formato do arquivo: JSON `{"sha256": "...", "payload": "<JSON do SaveData>"}`. O hash cobre
## o TEXTO do payload (e não o Dictionary reanalisado), porque JSON devolve inteiros como float.

enum Status {
	OK,  ## carregado do arquivo atual
	FRESH,  ## nenhum arquivo existe (primeira execução)
	RECOVERED,  ## o atual faltava/estava corrompido; usado tmp ou bak
	RESET_CORRUPT,  ## nada utilizável; começou do zero (arquivos corrompidos preservados)
	UNSUPPORTED_VERSION,  ## save de versão mais nova: NÃO sobrescrever
}

class LoadResult:
	extends RefCounted
	var status: Status = Status.FRESH
	var data: SaveData = SaveData.new()
	var source: String = ""

var path: String


func _init(save_path: String) -> void:
	path = save_path


func tmp_path() -> String:
	return path + ".tmp"


func backup_path() -> String:
	return path + ".bak"


## Grava `data`. Retorna OK ou o erro de E/S (armazenamento indisponível não derruba o jogo).
func save(data: SaveData) -> Error:
	# Nunca destruir um save de versão mais nova do que este jogo entende.
	for existing: String in [path, backup_path()]:
		if FileAccess.file_exists(existing) and _read_valid(existing).status == _Check.UNSUPPORTED:
			return ERR_LOCKED
	var payload: String = JSON.stringify(data.to_dict(), "", true)
	var envelope: String = JSON.stringify({"sha256": payload.sha256_text(), "payload": payload})
	var error: Error = _write_text(tmp_path(), envelope)
	if error != OK:
		return error
	# Releitura: só promove o tmp se ele realmente está íntegro no disco.
	if _read_valid(tmp_path()).status != _Check.VALID:
		DirAccess.remove_absolute(tmp_path())
		return ERR_FILE_CORRUPT
	if FileAccess.file_exists(path) and _read_valid(path).status == _Check.VALID:
		if FileAccess.file_exists(backup_path()):
			DirAccess.remove_absolute(backup_path())
		error = DirAccess.rename_absolute(path, backup_path())
		if error != OK:
			return error
	elif FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)  # corrompido: some, o backup bom fica intacto
	return DirAccess.rename_absolute(tmp_path(), path)


func load_data() -> LoadResult:
	var result: LoadResult = LoadResult.new()
	var any_file: bool = false
	var newer_version: bool = false
	var candidates: Array[String] = [path, tmp_path(), backup_path()]
	for candidate: String in candidates:
		if not FileAccess.file_exists(candidate):
			continue
		any_file = true
		var checked: _Check = _read_valid(candidate)
		if checked.status == _Check.UNSUPPORTED:
			newer_version = true
			break
		if checked.status == _Check.VALID:
			result.data = checked.data
			result.source = candidate
			result.status = Status.OK if candidate == path else Status.RECOVERED
			return result
	if newer_version:
		result.status = Status.UNSUPPORTED_VERSION
	elif any_file:
		result.status = Status.RESET_CORRUPT
	else:
		result.status = Status.FRESH
	return result


## Resultado interno de verificar um arquivo.
class _Check:
	extends RefCounted
	const VALID: int = 0
	const INVALID: int = 1
	const UNSUPPORTED: int = 2
	var status: int = INVALID
	var data: SaveData


func _read_valid(file_path: String) -> _Check:
	var check: _Check = _Check.new()
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		return check
	var text: String = file.get_as_text()
	file.close()
	var envelope: Variant = _parse_json(text)
	if not (envelope is Dictionary):
		return check
	var payload: Variant = envelope.get("payload")
	var hash_value: Variant = envelope.get("sha256")
	if not (payload is String) or not (hash_value is String) or payload.sha256_text() != hash_value:
		return check
	var raw: Variant = _parse_json(payload)
	var parsed: Array = []
	match SaveData.parse(raw, parsed):
		SaveData.ParseStatus.OK:
			check.status = _Check.VALID
			check.data = parsed[0]
		SaveData.ParseStatus.UNSUPPORTED_VERSION:
			check.status = _Check.UNSUPPORTED
	return check


## JSON.parse_string registra ERROR no log para entrada inválida; um save corrompido é um caso
## esperado e tratado, então usamos a instância, que apenas devolve o código de erro.
func _parse_json(text: String) -> Variant:
	var json: JSON = JSON.new()
	if json.parse(text) != OK:
		return null
	return json.data


func _write_text(file_path: String, text: String) -> Error:
	var file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string(text)
	file.flush()
	var error: Error = file.get_error()
	file.close()
	return error
