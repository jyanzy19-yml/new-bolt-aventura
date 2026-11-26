extends BoltTest
## Regressões do ciclo de vida/dano do jogador e inimigo-base de Cybercore.

const PLAYER_SCENE: String = "res://scenes/player/bolt.tscn"
const ENEMY_SCENE: String = "res://scenes/enemies/cybercore_patrol_enemy.tscn"


func test_player_damage_invulnerability_and_respawn_restore_health() -> bool:
	var packed: PackedScene = load(PLAYER_SCENE) as PackedScene
	check(packed != null, "cena de BOLT carrega com componente de vida")
	if packed == null:
		return true
	var root: Node2D = Node2D.new()
	tree.root.add_child(root)
	var player: BoltPlayer = packed.instantiate() as BoltPlayer
	player.damage_invulnerability = 0.1
	root.add_child(player)
	await tree.process_frame
	var health: BoltHealth = player.get_node("%Health") as BoltHealth
	check_eq(health.current_health, 3, "BOLT inicia com três pontos de vida")
	check(player.take_damage(1, 1.0), "primeiro dano é aplicado")
	check_eq(health.current_health, 2, "vida diminui após dano")
	check(not player.take_damage(1, -1.0), "dano repetido durante invulnerabilidade é ignorado")
	check_eq(health.current_health, 2, "invulnerabilidade impede perda adicional de vida")
	player.respawn(Vector2(120.0, -20.0))
	check_eq(health.current_health, 3, "respawn restaura a vida completa")
	check_eq(player.global_position, Vector2(120.0, -20.0), "respawn reposiciona BOLT")
	check(player.take_damage(1, -1.0), "invulnerabilidade é limpa no respawn")
	check_eq(health.current_health, 2, "novo dano pode ser recebido após respawn")
	root.queue_free()
	await tree.process_frame
	return true


func test_patrol_enemy_moves_and_contact_damages_player_once_during_invulnerability() -> bool:
	var player_scene: PackedScene = load(PLAYER_SCENE) as PackedScene
	var enemy_scene: PackedScene = load(ENEMY_SCENE) as PackedScene
	check(player_scene != null and enemy_scene != null, "cenas de jogador e inimigo carregam")
	if player_scene == null or enemy_scene == null:
		return true
	var root: Node2D = Node2D.new()
	tree.root.add_child(root)
	var player: BoltPlayer = player_scene.instantiate() as BoltPlayer
	var enemy: CybercorePatrolEnemy = enemy_scene.instantiate() as CybercorePatrolEnemy
	player.damage_invulnerability = 0.2
	root.add_child(player)
	root.add_child(enemy)
	player.global_position = Vector2.ZERO
	enemy.global_position = Vector2.ZERO
	var start_x: float = enemy.global_position.x
	for _tick in 8:
		await tree.physics_frame
	var health: BoltHealth = player.get_node("%Health") as BoltHealth
	check(enemy.global_position.x > start_x, "inimigo patrulha horizontalmente")
	check_eq(health.current_health, 2, "contato causa dano ao jogador")
	for _tick in 8:
		await tree.physics_frame
	check_eq(health.current_health, 2, "invulnerabilidade evita dano contínuo por contato")
	root.queue_free()
	await tree.process_frame
	return true


func test_chrono_projectile_can_defeat_patrol_enemy() -> bool:
	var enemy_scene: PackedScene = load(ENEMY_SCENE) as PackedScene
	var projectile_scene: PackedScene = load("res://scenes/combat/chrono_projectile.tscn") as PackedScene
	check(enemy_scene != null and projectile_scene != null, "cena do inimigo e projétil carregam")
	if enemy_scene == null or projectile_scene == null:
		return true
	var root: Node2D = Node2D.new()
	tree.root.add_child(root)
	var enemy: CybercorePatrolEnemy = enemy_scene.instantiate() as CybercorePatrolEnemy
	root.add_child(enemy)
	enemy.global_position = Vector2(100.0, 0.0)
	var health: BoltHealth = enemy.get_node("%Health") as BoltHealth
	for _shot in 3:
		var projectile: ChronoProjectile = projectile_scene.instantiate() as ChronoProjectile
		root.add_child(projectile)
		projectile.global_position = Vector2(0.0, 0.0)
		projectile.configure(1, 720.0, 1, 1.0)
		for _tick in 20:
			await tree.physics_frame
			if projectile.is_queued_for_deletion():
				break
	check_eq(health.current_health, 0, "três disparos derrotam o inimigo com três pontos de vida")
	check(enemy.is_queued_for_deletion(), "inimigo derrotado é removido")
	root.queue_free()
	await tree.process_frame
	return true
