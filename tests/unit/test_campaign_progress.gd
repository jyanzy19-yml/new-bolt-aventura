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
	var state: Dictionary = progress.call("load_state")
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
	state = progress.call("load_state")
	var completed: Array = state.get("completed_level_ids", [])
	check_eq(completed.size(), 1, "completed level ID is stored only once")
	check_eq(completed[0], "W1-L1", "completed level list contains stable ID")
	_cleanup()
	return true



func test_level_completion_advances_resume_target_when_next_level_is_supplied() -> bool:
	var progress: Node = _prepare()
	check(progress.call("begin_level", "W1-L1"), "inicia W1-L1")
	check(progress.call("save_checkpoint", "W1-L1", "cybercore_w1_l1_checkpoint"), "salva checkpoint antes da conclusão")
	check(progress.call("mark_level_completed", "W1-L1", "W1-L2"), "conclui W1-L1 e define W1-L2 como próximo destino")
	var state: Dictionary = progress.call("load_state")
	check_eq(state.get("completed_level_ids"), ["W1-L1"], "W1-L1 permanece registrada como concluída")
	check_eq(state.get("current_level_id"), "W1-L2", "destino de retomada avança para a próxima fase")
	check_eq(state.get("active_checkpoint_id"), "", "checkpoint anterior é limpo ao avançar")
	check_eq(progress.call("get_checkpoint_id", "W1-L1"), "", "checkpoint não vaza para a fase concluída")
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
	var state: Dictionary = progress.call("load_state")
	check_eq(state.get("current_level_id"), "", "unknown schema is not interpreted as current state")
	check_eq(progress.get("last_error"), "unsupported_progress_schema", "reports incompatible progress schema")
	check(not progress.call("save_checkpoint", "W1-L1", "cp_2"), "does not overwrite an unsupported schema silently")
	check(progress.call("start_new_campaign"), "explicit Nova Jornada replaces an incompatible campaign schema")
	state = progress.call("load_state")
	check_eq(state.get("current_level_id"), "", "incompatible campaign progress is reset to a clean state")
	check_eq(progress.get("last_error"), "", "new campaign can continue after explicit reset")
	_cleanup()
	return true


func test_new_campaign_resets_campaign_only_and_preserves_other_domains() -> bool:
	var progress: Node = _prepare()
	check(SaveSystem.save_payload({
		"settings": {"music": 0.25, "sfx": 0.5},
		"campaign_progress": {
			"campaign_id": "main",
			"schema_version": 1,
			"current_level_id": "W1-L1",
			"active_checkpoint_id": "cybercore_w1_l1_checkpoint",
			"completed_level_ids": ["W1-L1"],
		},
	}), "semeia save com progresso e configurações")
	check(progress.call("start_new_campaign"), "Nova Jornada redefine o domínio da campanha")
	var state: Dictionary = progress.call("load_state")
	check_eq(state.get("current_level_id"), "", "nova campanha começa sem fase atual")
	check_eq(state.get("active_checkpoint_id"), "", "nova campanha começa sem checkpoint")
	check_eq(state.get("completed_level_ids"), [], "nova campanha limpa fases concluídas")
	var payload: Dictionary = SaveSystem.load_payload()
	check_eq(payload.get("settings"), {"music": 0.25, "sfx": 0.5}, "configurações de outros domínios são preservadas")
	_cleanup()
	return true


func test_begin_level_records_resume_point_and_preserves_same_level_checkpoint() -> bool:
	var progress: Node = _prepare()
	check(progress.call("begin_level", "W1-L1"), "entrada na fase registra o ponto de retomada")
	var state: Dictionary = progress.call("load_state")
	check_eq(state.get("current_level_id"), "W1-L1", "fase atual fica persistida desde a entrada")
	check_eq(state.get("active_checkpoint_id"), "", "entrada inicial não inventa checkpoint")
	check(progress.call("save_checkpoint", "W1-L1", "cybercore_w1_l1_checkpoint"), "checkpoint existente pode ser gravado")
	check(progress.call("begin_level", "W1-L1"), "reentrada na mesma fase é idempotente")
	check_eq(progress.call("get_checkpoint_id", "W1-L1"), "cybercore_w1_l1_checkpoint", "reentrada não apaga checkpoint ativo")
	_cleanup()
	return true


func test_new_campaign_does_not_overwrite_unreadable_save() -> bool:
	var progress: Node = _prepare()
	var corrupt_file: FileAccess = FileAccess.open(TEST_SAVE_PATH, FileAccess.WRITE)
	check(corrupt_file != null, "abre arquivo temporário para fixture corrompida")
	if corrupt_file != null:
		corrupt_file.store_string("{invalid-json")
		corrupt_file.close()
	check(not progress.call("start_new_campaign"), "não sobrescreve envelope ilegível sem recuperação")
	check_eq(progress.get("last_error"), "invalid_json", "expõe a causa da falha de persistência")
	check(FileAccess.file_exists(TEST_SAVE_PATH), "arquivo corrompido é preservado para diagnóstico/recuperação")
	_cleanup()
	return true


func test_progress_schema_rejects_fractional_and_textual_values() -> bool:
	var progress: Node = _prepare()
	var raw_state: Dictionary = {
		"campaign_id": "main",
		"schema_version": 1.5,
		"current_level_id": "W1-L1",
		"active_checkpoint_id": "",
		"completed_level_ids": [],
	}
	check(SaveSystem.save_payload({"campaign_progress": raw_state}), "grava fixture com schema fracionário")
	var state: Dictionary = progress.call("load_state")
	check_eq(state.get("current_level_id"), "", "schema fracionário não é interpretado como v1")
	check_eq(progress.get("last_error"), "unsupported_progress_schema", "schema fracionário informa incompatibilidade")

	raw_state["schema_version"] = "1"
	check(SaveSystem.save_payload({"campaign_progress": raw_state}), "grava fixture com schema textual")
	state = progress.call("load_state")
	check_eq(state.get("current_level_id"), "", "schema textual não é convertido para inteiro")
	check_eq(progress.get("last_error"), "unsupported_progress_schema", "schema textual informa incompatibilidade")

	raw_state["schema_version"] = 1.0
	check(SaveSystem.save_payload({"campaign_progress": raw_state}), "grava fixture com schema numericamente integral")
	state = progress.call("load_state")
	check_eq(state.get("current_level_id"), "W1-L1", "aceita número float exatamente integral")
	check_eq(progress.get("last_error"), "", "representação numérica integral não gera erro")
	_cleanup()
	return true
