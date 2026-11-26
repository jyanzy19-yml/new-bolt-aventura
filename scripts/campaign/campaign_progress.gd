extends Node
## Estado de campanha separado do armazenamento físico SaveSystem.
## IDs são estáveis (ex.: W1-L1 e cybercore_w1_l1_checkpoint); nenhuma referência a Node é persistida.

const CAMPAIGN_ID: String = "main"
const PROGRESS_SCHEMA_VERSION: int = 1
const PAYLOAD_KEY: String = "campaign_progress"

var last_error: String = ""


func load_state() -> Dictionary:
	last_error = ""
	var payload: Dictionary = SaveSystem.load_payload()
	if not SaveSystem.last_error.is_empty() and SaveSystem.last_error != "recovered_backup":
		last_error = SaveSystem.last_error
		return _default_state()

	var raw_state: Variant = payload.get(PAYLOAD_KEY, {})
	if typeof(raw_state) != TYPE_DICTIONARY:
		last_error = "invalid_campaign_progress"
		return _default_state()
	if raw_state.is_empty():
		return _default_state()

	if str(raw_state.get("campaign_id", "")) != CAMPAIGN_ID:
		last_error = "campaign_id_mismatch"
		return _default_state()
	if int(raw_state.get("schema_version", 0)) != PROGRESS_SCHEMA_VERSION:
		last_error = "unsupported_progress_schema"
		return _default_state()

	var current_level: Variant = raw_state.get("current_level_id", "")
	var checkpoint_id: Variant = raw_state.get("active_checkpoint_id", "")
	var completed: Variant = raw_state.get("completed_level_ids", [])
	if typeof(current_level) != TYPE_STRING or typeof(checkpoint_id) != TYPE_STRING or typeof(completed) != TYPE_ARRAY:
		last_error = "invalid_campaign_progress_fields"
		return _default_state()
	for level_id: Variant in completed:
		if typeof(level_id) != TYPE_STRING or str(level_id).is_empty():
			last_error = "invalid_completed_level_id"
			return _default_state()

	var state: Dictionary = _default_state()
	state.merge(raw_state, true)
	return state


func save_checkpoint(level_id: String, checkpoint_id: String) -> bool:
	if level_id.is_empty() or checkpoint_id.is_empty():
		last_error = "empty_level_or_checkpoint_id"
		return false
	var state: Dictionary = load_state()
	if not last_error.is_empty() and last_error != "recovered_backup":
		return false
	state["current_level_id"] = level_id
	state["active_checkpoint_id"] = checkpoint_id
	return _persist_state(state)


func mark_level_completed(level_id: String) -> bool:
	if level_id.is_empty():
		last_error = "empty_level_id"
		return false
	var state: Dictionary = load_state()
	if not last_error.is_empty() and last_error != "recovered_backup":
		return false
	var completed: Array = state.get("completed_level_ids", [])
	if not completed.has(level_id):
		completed.append(level_id)
	state["completed_level_ids"] = completed
	state["current_level_id"] = level_id
	state["active_checkpoint_id"] = ""
	return _persist_state(state)


func get_checkpoint_id(level_id: String) -> String:
	if level_id.is_empty():
		return ""
	var state: Dictionary = load_state()
	if str(state.get("current_level_id", "")) != level_id:
		return ""
	return str(state.get("active_checkpoint_id", ""))


func is_level_completed(level_id: String) -> bool:
	if level_id.is_empty():
		return false
	var state: Dictionary = load_state()
	return (state.get("completed_level_ids", []) as Array).has(level_id)


func _persist_state(state: Dictionary) -> bool:
	var payload: Dictionary = SaveSystem.load_payload()
	if not SaveSystem.last_error.is_empty() and SaveSystem.last_error != "recovered_backup":
		last_error = SaveSystem.last_error
		return false
	payload[PAYLOAD_KEY] = state
	if not SaveSystem.save_payload(payload):
		last_error = SaveSystem.last_error
		return false
	last_error = ""
	return true


func _default_state() -> Dictionary:
	return {
		"campaign_id": CAMPAIGN_ID,
		"schema_version": PROGRESS_SCHEMA_VERSION,
		"current_level_id": "",
		"active_checkpoint_id": "",
		"completed_level_ids": [],
	}
