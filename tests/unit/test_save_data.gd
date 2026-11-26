extends BoltTest
## SaveData: validação de IDs, sanitização de entrada do disco e tratamento de versão.


func _parse(raw: Variant) -> Array:
	var out: Array = []
	var status: SaveData.ParseStatus = SaveData.parse(raw, out)
	return [status, out]


func test_level_id_validation() -> bool:
	for good: String in ["W1-L1", "W7-L6", "W3-L4", "dev.movement_sandbox", "dev.a"]:
		check(SaveData.is_valid_level_id(good), "ID de fase válido: %s" % good)
	for bad: String in ["", "W0-L1", "W8-L1", "W1-L7", "w1-l1", "W1-L1 ", "dev.", "dev.UPPER", "../x", "W1-L1\nW1-L2"]:
		check(not SaveData.is_valid_level_id(bad), "ID de fase inválido: '%s'" % bad.replace("\n", "\\n"))
	return true


func test_generic_id_validation() -> bool:
	for good: String in ["cp_a", "fragment.w1-l1.a", "a", "0abc"]:
		check(SaveData.is_valid_id(good), "ID válido: %s" % good)
	for bad: String in ["", "_x", "Has Space", "UP", "a/b", "x".repeat(65)]:
		check(not SaveData.is_valid_id(bad), "ID inválido: %s" % bad.left(20))
	return true


func test_roundtrip_preserves_data() -> bool:
	var data: SaveData = SaveData.new()
	data.completed_levels = ["W1-L2", "W1-L1"]
	data.checkpoints = {"W1-L3": "cp_b"}
	data.collected = ["gem_2", "gem_1"]
	data.flags = ["met_npc"]
	var result: Array = _parse(JSON.parse_string(JSON.stringify(data.to_dict())))  # passa por JSON (ints viram float)
	check_eq(result[0], SaveData.ParseStatus.OK, "formato aceito após ida e volta por JSON")
	var loaded: SaveData = result[1][0]
	check_eq(loaded.completed_levels.size(), 2, "fases concluídas preservadas")
	check(loaded.completed_levels.has("W1-L1") and loaded.completed_levels.has("W1-L2"), "IDs de fase iguais")
	check_eq(loaded.checkpoints.get("W1-L3"), "cp_b", "checkpoint preservado")
	check_eq(loaded.collected.size(), 2, "colecionáveis preservados")
	check_eq(loaded.flags.size(), 1, "flags preservadas")
	check_eq(loaded.discarded_entries, 0, "nada descartado em dado válido")
	return true


func test_to_dict_is_deterministic_and_sorted() -> bool:
	var a: SaveData = SaveData.new()
	a.completed_levels = ["W1-L2", "W1-L1"]
	var b: SaveData = SaveData.new()
	b.completed_levels = ["W1-L1", "W1-L2"]
	check_eq(JSON.stringify(a.to_dict(), "", true), JSON.stringify(b.to_dict(), "", true), "mesma saída independente da ordem de inserção")
	return true


func test_invalid_and_duplicate_entries_are_discarded() -> bool:
	var raw: Dictionary = {
		"version": 1,
		"completed_levels": ["W1-L1", "W1-L1", "nope", 5, "W9-L1"],
		"checkpoints": {"W1-L2": "cp_a", "bad": "cp_a", "W1-L3": 7, "W1-L4": "BAD ID"},
		"collected": ["a", "a", "B B"],
		"flags": "não é lista",
	}
	var result: Array = _parse(raw)
	check_eq(result[0], SaveData.ParseStatus.OK, "aceita o que é aproveitável")
	var loaded: SaveData = result[1][0]
	check_eq(loaded.completed_levels, ["W1-L1"] as Array[String], "apenas fase válida e única")
	check_eq(loaded.checkpoints.size(), 1, "apenas o checkpoint válido")
	check_eq(loaded.collected, ["a"] as Array[String], "colecionável único e válido")
	check_eq(loaded.flags.size(), 0, "campo de tipo errado vira vazio")
	check(loaded.discarded_entries >= 9, "descartes contabilizados (%d)" % loaded.discarded_entries)
	return true


func test_missing_fields_use_defaults() -> bool:
	var result: Array = _parse({"version": 1})
	check_eq(result[0], SaveData.ParseStatus.OK, "só a versão basta")
	var loaded: SaveData = result[1][0]
	check_eq(loaded.completed_levels.size() + loaded.checkpoints.size() + loaded.collected.size() + loaded.flags.size(), 0, "tudo vazio")
	check_eq(loaded.discarded_entries, 0, "campos ausentes não contam como lixo")
	return true


func test_version_handling() -> bool:
	check_eq(_parse({"version": 1.0})[0], SaveData.ParseStatus.OK, "versão 1.0 (float do JSON) aceita")
	check_eq(_parse({"version": 2})[0], SaveData.ParseStatus.UNSUPPORTED_VERSION, "versão futura recusada")
	check_eq(_parse({"version": 99.0})[0], SaveData.ParseStatus.UNSUPPORTED_VERSION, "versão futura (float) recusada")
	for bad: Variant in [null, 0, -1, 1.5, "1", true, [1]]:
		check_eq(_parse({"version": bad})[0], SaveData.ParseStatus.MALFORMED, "versão inválida: %s" % str(bad))
	check_eq(_parse({})[0], SaveData.ParseStatus.MALFORMED, "sem versão")
	for bad_root: Variant in [null, 5, "x", [1, 2]]:
		check_eq(_parse(bad_root)[0], SaveData.ParseStatus.MALFORMED, "raiz não é objeto: %s" % str(bad_root))
	return true
