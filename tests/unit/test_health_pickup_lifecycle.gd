extends BoltTest
## Regressões de lifecycle do coletável de recuperação.

const PLAYER_SCENE: String = "res://scenes/player/bolt.tscn"
const PICKUP_SCENE: String = "res://scenes/combat/bolt_health_pickup.tscn"


func test_pickup_ignores_duplicate_contact_after_successful_collection() -> bool:
	var player_packed: PackedScene = load(PLAYER_SCENE) as PackedScene
	var pickup_packed: PackedScene = load(PICKUP_SCENE) as PackedScene
	check(player_packed != null and pickup_packed != null, "cenas de BOLT e coletável carregam")
	if player_packed == null or pickup_packed == null:
		return true

	var root: Node2D = Node2D.new()
	tree.root.add_child(root)
	var player: BoltPlayer = player_packed.instantiate() as BoltPlayer
	var pickup: BoltHealthPickup = pickup_packed.instantiate() as BoltHealthPickup
	root.add_child(player)
	root.add_child(pickup)
	await tree.process_frame

	var health: BoltHealth = player.get_node("%Health") as BoltHealth
	check(player.take_damage(1, 0.0), "BOLT perde vida antes de coletar")
	check_eq(health.current_health, health.max_health - 1, "vida reduzida cria condição válida de coleta")

	var collected_count: Array[int] = [0]
	pickup.collected.connect(func(_amount: int) -> void:
		collected_count[0] += 1
	)

	pickup.call("_on_body_entered", player)
	check_eq(health.current_health, health.max_health, "primeiro contato restaura vida")
	check(pickup.is_queued_for_deletion(), "coletável entra no fluxo de remoção")
	check(not pickup.visible, "coletável fica invisível imediatamente")
	check_eq(collected_count[0], 1, "coleta válida emite collected uma vez")

	# queue_free() só remove o nó ao fim do frame. Uma notificação de contato
	# repetida nesta janela não pode curar nem emitir novamente.
	pickup.call("_on_body_entered", player)
	check_eq(health.current_health, health.max_health, "callback tardio não aplica cura duplicada")
	check_eq(collected_count[0], 1, "callback tardio não duplica o evento collected")

	root.queue_free()
	await tree.process_frame
	return true
