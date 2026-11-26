extends BoltTest
## Tests for the campaign-domain payload layered over SaveSystem.

const TEST_SAVE_PATH: String = "user://bolt_campaign_progress_unit_test.json"


func _prepare() -> Node:
	SaveSystem.storage_path_override = TEST_SAVE_PATH
	SaveSystem.delete_save()
	return CampaignProgress


func _cleanup() -> void:
	SaveSystem.delete_save()
	SaveSystem.storage_path_override = ""


func test_checkpoint_and_completion_preserve_unrelated_payload() -> bool:
	var progress: Node = _prepare()
	check(SaveSystem.save_payload({"settings": {"music": 0.25}}), "seed unrelated settings payload")
	check(progress.call("save_checkpoint", "W1-L1", "cybercore_w1_l1_checkpoint"), "saves stable level/checkpoint IDs")
	var state: Dictionary = progress.call("load_state", )
	check_eq(state.get("campaign_id"), "main", "campaign ID is explicit")
	check_eq(int(state.get("schema_version", 0)), 1, "progress schema is versioned")
	check_eq(state.get("current_level_id"), "W1-L1", "current level ID is persisted")
	check_eq(state.get("active_checkpoint_id"), "cybercore_w1_l1_checkpoint", "active checkpoint ID is persisted")
	check_eq(progress.call("get_checkpoint_id", "W1-L1"), "cybercore_w1_l1_checkpoint", "checkpoint lookup is scoped to its level")
	check_eq(progress.call("get_checkpoint_id", "W1-L2"), "", "checkpoint does not leak to another level")
	var whole_payload: Dictionary = SaveSystem.load_payload()
	check_eq(whole_payload.get("settings"), {"music": 0.25}, "campaign update preserves unrelated save payload")

	check(progress.call("mark_level_completed", "W1-L1"), "marks the level complete")
	check(progress.call("is_level_completed", "W1-L1"), "completed level is queryable")
	check_eq(progress.call("get_checkpoint_id", "W1-L1"), "", "completion clears the active checkpoint")
	check(progress.call("mark_level_completed", "W1-L1"), "completion is idempotent")
	state = progress.call("load_state", )
	var completed: Array = state.get("completed_level_ids", [])
	check_eq(completed.size(), 1, "completed level ID is stored only once")
	check_eq(completed[0], "W1-L1", "completed level list contains stable ID")
	_cleanup()
	return true


func test_empty_ids_are_rejected_without_writing_progress() -> bool:
	var progress: Node = _prepare()
	check(not progress.call("save_checkpoint", "", "checkpoint"), "empty level ID is rejected")
	check(not progress.call("save_checkpoint", "W1-L1", ""), "empty checkpoint ID is rejected")
	check(not progress.call("mark_level_completed", ""), "empty completion ID is rejected")
	check_eq(SaveSystem.load_payload(), {}, "invalid IDs do not write a save")
	_cleanup()
	return true


func test_unknown_progress_schema_fails_closed() -> bool:
	var progress: Node = _prepare()
	check(SaveSystem.save_payload({
		"campaign_progress": {
			"campaign_id": "main",
			"schema_version": 999,
			"current_level_id": "W1-L1",
			"active_checkpoint_id": "cp_1",
			"completed_level_ids": [],
		},
	}), "writes an unknown progress schema fixture")
	var state: Dictionary = progress.call("load_state", )
	check_eq(state.get("current_level_id"), "", "unknown schema is not interpreted as current state")
	check_eq(progress.get("last_error"), "unsupported_progress_schema", "reports incompatible progress schema")
	check(not progress.call("save_checkpoint", "W1-L1", "cp_2"), "does not overwrite an unsupported schema silently")
	_cleanup()
	return true
