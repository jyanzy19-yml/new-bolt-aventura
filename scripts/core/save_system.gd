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


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH) or FileAccess.file_exists(BACKUP_PATH)


func save_payload(payload: Dictionary) -> bool:
	last_error = ""
	if not _is_json_compatible(payload):
		last_error = "payload_not_json_compatible"
		return false

	var payload_json: String = JSON.stringify(payload)
	var checksum: String = _checksum(payload_json)
	if checksum.is_empty():
		last_error = "checksum_failed"
		return false

	var envelope: Dictionary = {
		"format_version": FORMAT_VERSION,
		"payload": payload,
		"checksum": checksum,
	}
	var temp_cleanup_error: Error = _remove_if_exists(TEMP_PATH)
	if temp_cleanup_error != OK:
		last_error = "temp_cleanup_failed"
		return false

	var file: FileAccess = FileAccess.open(TEMP_PATH, FileAccess.WRITE)
	if file == null:
		last_error = "temp_open_failed:%s" % error_string(FileAccess.get_open_error())
		return false
	file.store_string(JSON.stringify(envelope))
	file.flush()
	var write_error: Error = file.get_error()
	file.close()
	if write_error != OK:
		_remove_if_exists(TEMP_PATH)
		last_error = "temp_write_failed:%s" % error_string(write_error)
		return false

	var had_primary: bool = FileAccess.file_exists(SAVE_PATH)
	if had_primary:
		var backup_cleanup_error: Error = _remove_if_exists(BACKUP_PATH)
		if backup_cleanup_error != OK:
			_remove_if_exists(TEMP_PATH)
			last_error = "backup_cleanup_failed"
			return false
		var backup_error: Error = DirAccess.rename_absolute(
			ProjectSettings.globalize_path(SAVE_PATH),
			ProjectSettings.globalize_path(BACKUP_PATH)
		)
		if backup_error != OK:
			_remove_if_exists(TEMP_PATH)
			last_error = "backup_stage_failed:%s" % error_string(backup_error)
			return false

	var commit_error: Error = DirAccess.rename_absolute(
		ProjectSettings.globalize_path(TEMP_PATH),
		ProjectSettings.globalize_path(SAVE_PATH)
	)
	if commit_error != OK:
		var restore_error: Error = OK
		if had_primary and FileAccess.file_exists(BACKUP_PATH):
			restore_error = DirAccess.rename_absolute(
				ProjectSettings.globalize_path(BACKUP_PATH),
				ProjectSettings.globalize_path(SAVE_PATH)
			)
		last_error = "commit_failed:%s" % error_string(commit_error)
		if restore_error != OK:
			last_error = "commit_and_restore_failed:%s" % error_string(restore_error)
		return false

	_remove_if_exists(BACKUP_PATH)
	last_error = ""
	return true


func load_payload() -> Dictionary:
	last_error = ""
	var primary: Dictionary = _decode_file(SAVE_PATH)
	if bool(primary.get("ok", false)):
		return primary["payload"] as Dictionary

	var backup: Dictionary = _decode_file(BACKUP_PATH)
	if bool(backup.get("ok", false)):
		last_error = "recovered_backup"
		return backup["payload"] as Dictionary

	if str(primary.get("error", "")) == "missing" and str(backup.get("error", "")) == "missing":
		return {}
	last_error = str(primary.get("error", backup.get("error", "load_failed")))
	return {}


func delete_save() -> bool:
	last_error = ""
	for path: String in [SAVE_PATH, TEMP_PATH, BACKUP_PATH]:
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

	var parsed: Variant = JSON.parse_string(raw)
	if typeof(parsed) != TYPE_DICTIONARY:
		return {"ok": false, "error": "invalid_json"}
	var envelope: Dictionary = parsed
	var version: int = int(envelope.get("format_version", 0))
	if version != FORMAT_VERSION:
		return {"ok": false, "error": "unsupported_format_version"}
	var payload: Variant = envelope.get("payload")
	if typeof(payload) != TYPE_DICTIONARY:
		return {"ok": false, "error": "invalid_payload"}
	var payload_json: String = JSON.stringify(payload)
	var expected_checksum: String = str(envelope.get("checksum", ""))
	if expected_checksum.is_empty() or _checksum(payload_json) != expected_checksum:
		return {"ok": false, "error": "checksum_mismatch"}
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
