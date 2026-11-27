extends BoltTest
## Contratos de consumo único e expiração do projétil da Pistola Crono.

const ENEMY_SCENE: String = "res://scenes/enemies/cybercore_patrol_enemy.tscn"


func test_projectile_applies_damage_only_once_before_deferred_deletion() -> bool:
	var enemy_scene: PackedScene = load(ENEMY_SCENE) as PackedScene
	var projectile_scene: PackedScene = load("res://scenes/combat/chrono_projectile.tscn") as PackedScene
	check(enemy_scene != null and projectile_scene != null, "cenas de inimigo e projétil carregam")
	if enemy_scene == null or projectile_scene == null:
		return true
	var root: Node2D = Node2D.new()
	tree.root.add_child(root)
	var enemy: CybercorePatrolEnemy = enemy_scene.instantiate() as CybercorePatrolEnemy
	var projectile: ChronoProjectile = projectile_scene.instantiate() as ChronoProjectile
	root.add_child(enemy)
	root.add_child(projectile)
	await tree.process_frame
	var health: BoltHealth = enemy.get_node("%Health") as BoltHealth
	projectile.configure(1, 720.0, 1, 1.0)
	projectile.call("_on_body_entered", enemy)
	check_eq(health.current_health, 2, "primeiro impacto aplica um ponto de dano")
	check(projectile.is_queued_for_deletion(), "projétil agenda remoção após o impacto")
	projectile.call("_on_body_entered", enemy)
	check_eq(health.current_health, 2, "callback repetido antes da remoção não aplica dano adicional")
	root.queue_free()
	await tree.process_frame
	return true


func test_expired_projectile_ignores_late_collision_callback() -> bool:
	var enemy_scene: PackedScene = load(ENEMY_SCENE) as PackedScene
	var projectile_scene: PackedScene = load("res://scenes/combat/chrono_projectile.tscn") as PackedScene
	check(enemy_scene != null and projectile_scene != null, "cenas de inimigo e projétil carregam")
	if enemy_scene == null or projectile_scene == null:
		return true
	var root: Node2D = Node2D.new()
	tree.root.add_child(root)
	var enemy: CybercorePatrolEnemy = enemy_scene.instantiate() as CybercorePatrolEnemy
	var projectile: ChronoProjectile = projectile_scene.instantiate() as ChronoProjectile
	root.add_child(enemy)
	root.add_child(projectile)
	await tree.process_frame
	var health: BoltHealth = enemy.get_node("%Health") as BoltHealth
	projectile.configure(1, 720.0, 1, 0.05)
	projectile.call("_physics_process", 0.1)
	check(projectile.is_queued_for_deletion(), "projétil expirado agenda remoção")
	projectile.call("_on_body_entered", enemy)
	check_eq(health.current_health, 3, "callback tardio após expiração não causa dano")
	root.queue_free()
	await tree.process_frame
	return true
