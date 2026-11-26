extends Node
## Armazenamento local versionado. O domínio da campanha define o payload; este serviço
## conhece apenas dados JSON e não mantém referências a Nodes/Resources.
##
## Escritas são explícitas (checkpoint/conclusão/configuração), nunca por frame.
## A substituição usa arquivo temporário + backup para recuperação de interrupções.

const FORMAT_VERSION: int = 1
const SAVE_PATH: String = "user://bolt_save.json"
const TEMP_PATH: String = "user://bolt_save.tmp"
const BACKUP_PATH: String = "user://bolt_save.bak"

var last_error: String = ""
## Sobrescrita isolada para testes headless; vazio no jogo.
var storage_path_override: String = ""


func has_save() -> bool:
	return FileAccess.file_exists(_primary_path()) or FileAccess.file_exists(_backup_path())


func save_payload(payload: Dictionary) -> bool:
	last_error = ""
	if not _is_json_compatible(payload):
		last_error = "payload_not_json_compatible"
		return false

	var payload_json: String = _canonical_json(payload)
	var checksum: String = _checksum(payload_json)
	if checksum.is_empty():
		last_error = "checksum_failed"
		return false

	var envelope: Dictionary = {
		"format_version": FORMAT_VERSION,
		"payload_json": payload_json,
		"checksum": checksum,
	}
	var temp_cleanup_error: Error = _remove_if_exists(_temp_path())
	if temp_cleanup_error != OK:
		last_error = "temp_cleanup_failed"
		return false

	var file: FileAccess = FileAccess.open(_temp_path(), FileAccess.WRITE)
	if file == null:
		last_error = "temp_open_failed:%s" % error_string(FileAccess.get_open_error())
		return false
	file.store_string(JSON.stringify(envelope))
	file.flush()
	var write_error: Error = file.get_error()
	file.close()
	if write_error != OK:
		_remove_if_exists(_temp_path())
		last_error = "temp_write_failed:%s" % error_string(write_error)
		return false

	var had_primary: bool = FileAccess.file_exists(_primary_path())
	if had_primary:
		var backup_cleanup_error: Error = _remove_if_exists(_backup_path())
		if backup_cleanup_error != OK:
			_remove_if_exists(_temp_path())
			last_error = "backup_cleanup_failed"
			return false
		var backup_error: Error = DirAccess.rename_absolute(
			ProjectSettings.globalize_path(_primary_path()),
			ProjectSettings.globalize_path(_backup_path())
		)
		if backup_error != OK:
			_remove_if_exists(_temp_path())
			last_error = "backup_stage_failed:%s" % error_string(backup_error)
			return false

	var commit_error: Error = DirAccess.rename_absolute(
		ProjectSettings.globalize_path(_temp_path()),
		ProjectSettings.globalize_path(_primary_path())
	)
	if commit_error != OK:
		var restore_error: Error = OK
		if had_primary and FileAccess.file_exists(_backup_path()):
			restore_error = DirAccess.rename_absolute(
				ProjectSettings.globalize_path(_backup_path()),
				ProjectSettings.globalize_path(_primary_path())
			)
		last_error = "commit_failed:%s" % error_string(commit_error)
		if restore_error != OK:
			last_error = "commit_and_restore_failed:%s" % error_string(restore_error)
		return false

	_remove_if_exists(_backup_path())
	last_error = ""
	return true


func load_payload() -> Dictionary:
	last_error = ""
	var primary: Dictionary = _decode_file(_primary_path())
	if bool(primary.get("ok", false)):
		return primary["payload"] as Dictionary

	var backup: Dictionary = _decode_file(_backup_path())
	if bool(backup.get("ok", false)):
		last_error = "recovered_backup"
		return backup["payload"] as Dictionary

	if str(primary.get("error", "")) == "missing" and str(backup.get("error", "")) == "missing":
		return {}
	last_error = str(primary.get("error", backup.get("error", "load_failed")))
	return {}


func delete_save() -> bool:
	last_error = ""
	for path: String in [_primary_path(), _temp_path(), _backup_path()]:
		var err: Error = _remove_if_exists(path)
		if err != OK:
			last_error = "delete_failed:%s" % error_string(err)
			return false
	return true


func _decode_file(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {"ok": false, "error": "missing"}
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {"ok": false, "error": "open_failed:%s" % error_string(FileAccess.get_open_error())}
	var raw: String = file.get_as_text()
	file.close()

	var parser: JSON = JSON.new()
	var parse_error: Error = parser.parse(raw)
	if parse_error != OK:
		return {"ok": false, "error": "invalid_json"}
	var parsed: Variant = parser.data
	if typeof(parsed) != TYPE_DICTIONARY:
		return {"ok": false, "error": "invalid_json"}
	var envelope: Dictionary = parsed
	var version: int = int(envelope.get("format_version", 0))
	if version != FORMAT_VERSION:
		return {"ok": false, "error": "unsupported_format_version"}
	var payload_json: String = str(envelope.get("payload_json", ""))
	if payload_json.is_empty():
		return {"ok": false, "error": "invalid_payload"}
	var expected_checksum: String = str(envelope.get("checksum", ""))
	if expected_checksum.is_empty() or _checksum(payload_json) != expected_checksum:
		return {"ok": false, "error": "checksum_mismatch"}
	var payload_parser: JSON = JSON.new()
	if payload_parser.parse(payload_json) != OK:
		return {"ok": false, "error": "invalid_payload"}
	var payload: Variant = payload_parser.data
	if typeof(payload) != TYPE_DICTIONARY:
		return {"ok": false, "error": "invalid_payload"}
	return {"ok": true, "payload": payload, "error": ""}


func _is_json_compatible(value: Variant) -> bool:
	match typeof(value):
		TYPE_NIL, TYPE_BOOL, TYPE_INT, TYPE_STRING:
			return true
		TYPE_FLOAT:
			return is_finite(value)
		TYPE_ARRAY:
			for item: Variant in value:
				if not _is_json_compatible(item):
					return false
			return true
		TYPE_DICTIONARY:
			for key: Variant in value:
				if typeof(key) != TYPE_STRING or not _is_json_compatible(value[key]):
					return false
			return true
		_:
			return false


func _canonical_json(payload: Dictionary) -> String:
	return JSON.stringify(payload, "", true, true)


func _checksum(payload_json: String) -> String:
	var context: HashingContext = HashingContext.new()
	if context.start(HashingContext.HASH_SHA256) != OK:
		return ""
	context.update(payload_json.to_utf8_buffer())
	return context.finish().hex_encode()


func _remove_if_exists(path: String) -> Error:
	if not FileAccess.file_exists(path):
		return OK
	return DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _primary_path() -> String:
	return SAVE_PATH if storage_path_override.is_empty() else storage_path_override


func _temp_path() -> String:
	return TEMP_PATH if storage_path_override.is_empty() else storage_path_override + ".tmp"


func _backup_path() -> String:
	return BACKUP_PATH if storage_path_override.is_empty() else storage_path_override + ".bak"
