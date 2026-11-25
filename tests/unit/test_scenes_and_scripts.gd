extends BoltTest
## Smoke estático/de carga: todo script compila e toda cena carrega e instancia.
## Não substitui teste visual, de toque ou de desempenho.


func test_all_scripts_compile() -> bool:
	var paths: Array[String] = []
	paths.append_array(list_files("res://scripts", "gd"))
	paths.append_array(list_files("res://tests", "gd"))
	check(paths.size() > 0, "há scripts para verificar")
	for path: String in paths:
		var script: GDScript = load(path) as GDScript
		check(script != null and script.can_instantiate(), "compila: %s" % path)
	return true


func test_all_scenes_load_and_instantiate() -> bool:
	var paths: Array[String] = list_files("res://scenes", "tscn")
	check(paths.size() > 0, "há cenas para verificar")
	for path: String in paths:
		var packed: PackedScene = load(path) as PackedScene
		check(packed != null, "carrega: %s" % path)
		if packed == null:
			continue
		var instance: Node = packed.instantiate()
		check(instance != null, "instancia: %s" % path)
		if instance != null:
			instance.free()
	return true
