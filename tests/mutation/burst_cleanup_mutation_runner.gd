extends SceneTree
## Runner isolado para mutation testing: gera uma rajada cheia de CPUParticles2D
## dentro de W1-L1, destrói o nível antes dos timeouts e observa todos os callbacks.

func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	await create_timer(1.0).timeout
	var save_system: Node = root.get_node_or_null("SaveSystem")
	if save_system != null:
		save_system.set("storage_path_override", "user://burst_cleanup_mutation.json")
		save_system.call("delete_save")

	var packed: PackedScene = load("res://scenes/campaign/cybercore_w1_l1.tscn") as PackedScene
	if packed == null:
		push_error("BURST_CLEANUP_REGRESSION_FAIL: W1-L1 não carregou.")
		quit(2)
		return

	var level: Node2D = packed.instantiate() as Node2D
	root.add_child(level)
	await physics_frame
	var baseline: int = Burst.active_count()
	for index in range(24):
		var particles: CPUParticles2D = Burst.spawn(
			level, Vector2(float(index) * 8.0, 0.0), Color.WHITE, 4, 50.0, 0.1
		)
		if particles == null:
			push_error("BURST_CLEANUP_REGRESSION_FAIL: limite de 24 efeitos não foi atingido.")
			level.free()
			quit(3)
			return
	if Burst.active_count() != baseline + 24:
		push_error("BURST_CLEANUP_REGRESSION_FAIL: contador não atingiu baseline + 24.")
		level.free()
		quit(4)
		return

	# Simula teardown de fase com muitos efeitos ainda aguardando timeout.
	level.free()
	await create_timer(0.8).timeout
	var after: int = Burst.active_count()
	if after != baseline:
		push_error("BURST_CLEANUP_REGRESSION_FAIL: expected %d active, got %d." % [baseline, after])
		quit(1)
		return
	print("BURST_CLEANUP_REGRESSION_PASS")
	if save_system != null:
		save_system.call("delete_save")
		save_system.set("storage_path_override", "")
	quit(0)
