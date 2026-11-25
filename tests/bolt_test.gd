class_name BoltTest
extends RefCounted
## Base dos testes headless. Cada método `test_*` deve terminar com `return true`:
## um erro de runtime no meio devolve `null` ao runner, que conta o teste como falho.

## Definido pelo runner antes de executar o teste.
var tree: SceneTree

var checks: int = 0
var failures: Array[String] = []


func check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures.append(label)


func check_eq(actual: Variant, expected: Variant, label: String) -> void:
	checks += 1
	if not is_same(actual, expected) and actual != expected:
		failures.append("%s (esperado %s, obtido %s)" % [label, expected, actual])


func check_near(actual: float, expected: float, tolerance: float, label: String) -> void:
	checks += 1
	if absf(actual - expected) > tolerance:
		failures.append("%s (esperado %s ±%s, obtido %s)" % [label, expected, tolerance, actual])


## Lista caminhos de arquivos com a extensão dada, recursivamente, sob `dir_path`.
static func list_files(dir_path: String, extension: String) -> Array[String]:
	var result: Array[String] = []
	var dir: DirAccess = DirAccess.open(dir_path)
	if dir == null:
		return result
	dir.list_dir_begin()
	var name: String = dir.get_next()
	while name != "":
		var full: String = dir_path.path_join(name)
		if dir.current_is_dir():
			if not name.begins_with("."):
				result.append_array(list_files(full, extension))
		elif name.get_extension() == extension:
			result.append(full)
		name = dir.get_next()
	dir.list_dir_end()
	result.sort()
	return result
