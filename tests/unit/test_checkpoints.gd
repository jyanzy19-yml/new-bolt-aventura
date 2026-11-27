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


func test_checkpoint_restore_does_not_emit_activation_again() -> bool:
	var packed: PackedScene = load("res://scenes/levels/checkpoint.tscn") as PackedScene
	check(packed != null, "cena de checkpoint carrega para teste de restauração")
	if packed == null:
		return true

	var root: Node2D = Node2D.new()
	tree.root.add_child(root)
	var checkpoint: BoltCheckpoint = packed.instantiate() as BoltCheckpoint
	root.add_child(checkpoint)
	await tree.process_frame

	var activations: Array[int] = [0]
	checkpoint.activated.connect(func(_id: StringName, _position: Vector2) -> void:
		activations[0] += 1
	)

	checkpoint.restore_activation()
	check(checkpoint.is_activated(), "restauração marca checkpoint como ativo")
	var indicator: Polygon2D = checkpoint.get_node("%Indicator") as Polygon2D
	check(indicator.color.is_equal_approx(Color(0.35, 1.0, 0.68, 1.0)), "restauração atualiza indicador visual")
	check_eq(activations[0], 0, "restauração não emite novo evento de gameplay")

	checkpoint.restore_activation()
	checkpoint.activate()
	check_eq(activations[0], 0, "restauração repetida e ativação posterior não duplicam evento")

	root.queue_free()
	await tree.process_frame
	return true
