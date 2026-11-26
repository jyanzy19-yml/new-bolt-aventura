extends BoltTest
## Verifica ativação única do checkpoint e sua integração com o respawn da sandbox.
## Não valida persistência entre sessões: isso pertence ao futuro SaveSystem.

const SANDBOX: String = "res://scenes/levels/sandbox/movement_sandbox.tscn"


func test_checkpoint_updates_respawn_target_once() -> bool:
	Actions.release_all_game_actions()
	var packed: PackedScene = load(SANDBOX) as PackedScene
	check(packed != null, "sandbox carrega para teste de checkpoint")
	if packed == null:
		return true

	var level: Node = packed.instantiate()
	tree.root.add_child(level)
	await tree.physics_frame

	var player: BoltPlayer = level.get_node("%Bolt") as BoltPlayer
	var checkpoint: BoltCheckpoint = level.get_node("%Checkpoint") as BoltCheckpoint
	var activations: Array[int] = [0]
	checkpoint.activated.connect(func(_id: StringName, _position: Vector2) -> void:
		activations[0] += 1
	)
	var expected_position: Vector2 = checkpoint.get_respawn_position()

	checkpoint.activate()
	checkpoint.activate()
	check_eq(activations[0], 1, "checkpoint emite ativação somente uma vez")

	level.call("_on_kill_zone_body_entered", player)
	check_near(player.global_position.x, expected_position.x, 0.01, "respawn usa coordenada X do checkpoint")
	check_near(player.global_position.y, expected_position.y, 0.01, "respawn usa coordenada Y do checkpoint")

	Actions.release_all_game_actions()
	level.queue_free()
	await tree.process_frame
	return true
