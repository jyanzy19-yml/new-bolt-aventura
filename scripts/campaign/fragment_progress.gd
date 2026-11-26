extends Node
## Progresso narrativo persistente dos sete fragmentos canônicos.
## Domínio separado de CampaignProgress para manter schemas independentes.

signal fragment_collected(fragment_id: String)
signal fragment_collection_failed(fragment_id: String, reason: String)

const CAMPAIGN_ID: String = "main"
const SCHEMA_VERSION: int = 1
const PAYLOAD_KEY: String = "fragment_progress"
const FRAGMENT_IDS: PackedStringArray = [
	"fragment_origin",
	"fragment_memory",
	"fragment_truth",
	"fragment_shadow",
	"fragment_light",
	"fragment_illusion",
	"fragment_equilibrium",
]
const FRAGMENT_TITLES: Dictionary = {
	"fragment_origin": "Origem",
	"fragment_memory": "Memória",
	"fragment_truth": "Verdade",
	"fragment_shadow": "Sombra",
	"fragment_light": "Luz",
	"fragment_illusion": "Ilusão",
	"fragment_equilibrium": "Equilíbrio",
}

var last_error: String = ""


func load_state() -> Dictionary:
	last_error = ""
	var payload: Dictionary = SaveSystem.load_payload()
	if not SaveSystem.last_error.is_empty() and SaveSystem.last_error != "recovered_backup":
		last_error = SaveSystem.last_error
		return _default_state()

	var raw_state: Variant = payload.get(PAYLOAD_KEY, {})
	if typeof(raw_state) != TYPE_DICTIONARY:
		last_error = "invalid_fragment_progress"
		return _default_state()
	if raw_state.is_empty():
		return _default_state()
	if str(raw_state.get("campaign_id", "")) != CAMPAIGN_ID:
		last_error = "fragment_campaign_id_mismatch"
		return _default_state()
	if int(raw_state.get("schema_version", 0)) != SCHEMA_VERSION:
		last_error = "unsupported_fragment_progress_schema"
		return _default_state()

	var collected: Variant = raw_state.get("collected_fragment_ids", [])
	if typeof(collected) != TYPE_ARRAY:
		last_error = "invalid_collected_fragment_ids"
		return _default_state()
	var seen: Dictionary = {}
	for fragment_id: Variant in collected:
		if typeof(fragment_id) != TYPE_STRING or not FRAGMENT_IDS.has(str(fragment_id)):
			last_error = "unknown_collected_fragment_id"
			return _default_state()
		if seen.has(str(fragment_id)):
			last_error = "duplicate_collected_fragment_id"
			return _default_state()
		seen[str(fragment_id)] = true

	var state: Dictionary = _default_state()
	state.merge(raw_state, true)
	return state


func collect_fragment(fragment_id: String) -> bool:
	if not FRAGMENT_IDS.has(fragment_id):
		last_error = "unknown_fragment_id"
		fragment_collection_failed.emit(fragment_id, last_error)
		return false

	var state: Dictionary = load_state()
	if not last_error.is_empty():
		fragment_collection_failed.emit(fragment_id, last_error)
		return false

	var collected: Array = state.get("collected_fragment_ids", [])
	if collected.has(fragment_id):
		return true
	collected.append(fragment_id)
	state["collected_fragment_ids"] = collected
	if not _persist_state(state):
		fragment_collection_failed.emit(fragment_id, last_error)
		return false

	last_error = ""
	fragment_collected.emit(fragment_id)
	return true


func has_fragment(fragment_id: String) -> bool:
	if not FRAGMENT_IDS.has(fragment_id):
		last_error = "unknown_fragment_id"
		return false
	var state: Dictionary = load_state()
	if not last_error.is_empty():
		return false
	return (state.get("collected_fragment_ids", []) as Array).has(fragment_id)


func get_collected_fragment_ids() -> Array[String]:
	var result: Array[String] = []
	var state: Dictionary = load_state()
	if not last_error.is_empty():
		return result
	for fragment_id: Variant in state.get("collected_fragment_ids", []):
		result.append(str(fragment_id))
	return result


func get_collected_count() -> int:
	return get_collected_fragment_ids().size()


func are_all_fragments_collected() -> bool:
	return get_collected_count() == FRAGMENT_IDS.size()


func get_fragment_title(fragment_id: String) -> String:
	return str(FRAGMENT_TITLES.get(fragment_id, ""))


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
		"schema_version": SCHEMA_VERSION,
		"collected_fragment_ids": [],
	}
