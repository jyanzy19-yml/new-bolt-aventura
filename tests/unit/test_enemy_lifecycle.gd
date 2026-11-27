extends BoltTest
## Regressões do encerramento do ciclo de vida do inimigo-base.

const PLAYER_SCENE: String = "res://scenes/player/bolt.tscn"
const ENEMY_SCENE: String = "res://scenes/enemies/cybercore_patrol_enemy.tscn"


func test_defeated_enemy_ignores_late_contact_callback() -> bool:
	var player_scene: PackedScene = load(PLAYER_SCENE) as PackedScene
	var enemy_scene: PackedScene = load(ENEMY_SCENE) as PackedScene
	check(player_scene != null and enemy_scene != null, "cenas de BOLT e inimigo carregam para teste de lifecycle")
	if player_scene == null or enemy_scene == null:
		return true

	var root: Node2D = Node2D.new()
	tree.root.add_child(root)
	var player: BoltPlayer = player_scene.instantiate() as BoltPlayer
	var enemy: CybercorePatrolEnemy = enemy_scene.instantiate() as CybercorePatrolEnemy
	root.add_child(player)
	root.add_child(enemy)
	await tree.process_frame

	var health: BoltHealth = player.get_node("%Health") as BoltHealth
	var defeated_count: Array[int] = [0]
	enemy.defeated.connect(func() -> void:
		defeated_count[0] += 1
	)

	enemy.apply_damage(3)
	check(enemy.is_queued_for_deletion(), "inimigo derrotado entra no fluxo de remoção")
	check_eq(defeated_count[0], 1, "derrota emite o evento uma única vez")

	# Simula um body_entered atrasado na mesma janela em que queue_free ainda
	# não removeu fisicamente o nó da SceneTree.
	enemy.call("_on_contact_body_entered", player)
	enemy.apply_damage(1)
	check_eq(health.current_health, health.max_health, "callback tardio após derrota não causa dano em BOLT")
	check_eq(defeated_count[0], 1, "dano posterior não repete o evento de derrota")

	root.queue_free()
	await tree.process_frame
	return true
