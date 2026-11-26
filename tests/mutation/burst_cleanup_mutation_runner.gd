extends SceneTree
## Runner isolado para mutation testing do ciclo de vida do Burst.
## Carrega Burst uma única vez; evita reimportar class_name no mesmo processo.

func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var host: Node2D = Node2D.new()
	root.add_child(host)
	var baseline: int = Burst.active_count()
	var particles: CPUParticles2D = Burst.spawn(host, Vector2.ZERO, Color.WHITE, 4, 50.0, 0.1)
	if particles == null:
		push_error("BURST_CLEANUP_REGRESSION_FAIL: spawn retornou null.")
		quit(2)
		return

	host.queue_free()
	await process_frame
	await create_timer(0.6).timeout
	var after: int = Burst.active_count()
	if after != baseline:
		push_error("BURST_CLEANUP_REGRESSION_FAIL: expected %d active, got %d." % [baseline, after])
		quit(1)
		return
	print("BURST_CLEANUP_REGRESSION_PASS")
	quit(0)
