extends SceneTree
## Runner de testes headless. Uso (a partir da raiz do projeto, após `--import`):
##   godot --headless --path . --script res://tests/test_runner.gd
## Código de saída 0 = todos passaram; 1 = houve falhas. Testes em res://tests/unit/test_*.gd.
## O código de saída reflete apenas o que este runner passa a quit(): erros de script no log
## NÃO mudam o exit code, por isso cada teste precisa terminar com `return true`.

const UNIT_DIR: String = "res://tests/unit"

var _checks: int = 0
var _failed_checks: int = 0
var _failed_tests: int = 0
var _tests: int = 0


func _initialize() -> void:
	await process_frame  # a raiz só entra na árvore no primeiro frame
	await _run_all()
	if _tests == 0:
		_failed_tests += 1
		push_error("FAIL: nenhum teste foi descoberto em %s; recusando resultado verde vazio." % UNIT_DIR)
	if _checks == 0:
		_failed_checks += 1
		push_error("FAIL: nenhum check foi executado; a suíte não validou comportamento.")
	print("RESULT: %d testes, %d verificações, %d testes com falha, %d verificações falhas"
			% [_tests, _checks, _failed_tests, _failed_checks])
	quit(1 if _failed_tests > 0 or _failed_checks > 0 else 0)


func _run_all() -> void:
	var files: Array[String] = BoltTest.list_files(UNIT_DIR, "gd")
	for path: String in files:
		if not path.get_file().begins_with("test_"):
			continue
		var script: GDScript = load(path) as GDScript
		if script == null or not script.can_instantiate():
			_tests += 1
			_failed_tests += 1
			push_error("FAIL %s: script não carrega/compila" % path)
			continue
		for method: Dictionary in script.get_script_method_list():
			var method_name: String = method["name"]
			if not method_name.begins_with("test_"):
				continue
			var test: BoltTest = script.new() as BoltTest
			test.tree = self
			_tests += 1
			var finished: Variant = await test.call(method_name)
			_cleanup_test_storage_override()
			_checks += test.checks
			_failed_checks += test.failures.size()
			if finished != true:
				_failed_tests += 1
				push_error("FAIL %s::%s não terminou (erro de runtime?)" % [path, method_name])
			for failure: String in test.failures:
				push_error("FAIL %s::%s — %s" % [path, method_name, failure])
			if finished == true and test.failures.is_empty():
				print("ok   %s::%s (%d verificações)" % [path.get_file(), method_name, test.checks])



## Each unit test runs in the same SceneTree/autoload scope. Remove only a non-empty
## test override so a failed test cannot leak a temporary path into the next test.
func _cleanup_test_storage_override() -> void:
	var save_system: Node = root.get_node_or_null("SaveSystem")
	if save_system == null:
		return
	var override_path: String = str(save_system.get("storage_path_override"))
	if override_path.is_empty():
		return
	save_system.call("delete_save")
	save_system.set("storage_path_override", "")
