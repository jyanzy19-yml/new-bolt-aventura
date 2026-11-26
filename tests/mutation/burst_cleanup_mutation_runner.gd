extends SceneTree
## Runner isolado: usa o BoltFeedback real dentro de W1-L1 e destrói a cena
## antes do timeout do Burst, reproduzindo o ciclo de vida de transição de fase.

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

	var level: Node = packed.instantiate()
	root.add_child(level)
	await physics_frame
	var player: Node = level.get_node("Bolt")
	var feedback: Node = player.get_node("Feedback")
	var baseline: int = Burst.active_count()
	feedback.call("_on_state_changed", BoltPlayer.State.RISING)
	if Burst.active_count() != baseline + 1:
		push_error("BURST_CLEANUP_REGRESSION_FAIL: BoltFeedback não criou exatamente um Burst.")
		level.free()
		quit(3)
		return

	# Equivale à troca de cena: pai e CPUParticles2D são destruídos antes do timer.
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
