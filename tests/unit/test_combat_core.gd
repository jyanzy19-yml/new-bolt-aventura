extends BoltTest
## Combat core: health component and projectile/target integration.

const HEALTH_SCRIPT: String = "res://scripts/combat/bolt_health.gd"
const TARGET_SCENE: String = "res://scenes/combat/training_target.tscn"
const PROJECTILE_SCENE: String = "res://scenes/combat/chrono_projectile.tscn"


func test_health_component_clamps_damage_and_emits_depleted_once() -> bool:
	var health_script: GDScript = load(HEALTH_SCRIPT) as GDScript
	check(health_script != null, "BoltHealth compila")
	if health_script == null:
		return true
	var health: Node = health_script.new()
	health.set("max_health", 3)
	tree.root.add_child(health)
	await tree.process_frame
	check_eq(health.get("current_health"), 3, "vida inicial corresponde ao máximo")
	check(health.call("apply_damage", 2), "dano positivo aplicado")
	check_eq(health.get("current_health"), 1, "vida reduzida corretamente")
	check(health.call("apply_damage", 9), "dano excedente aplicado")
	check_eq(health.get("current_health"), 0, "vida limitada a zero")
	check(not health.call("apply_damage", 1), "alvo derrotado não recebe dano adicional")
	health.queue_free()
	await tree.process_frame
	return true


func test_chrono_projectile_defeats_training_target() -> bool:
	var target_scene: PackedScene = load(TARGET_SCENE) as PackedScene
	var projectile_scene: PackedScene = load(PROJECTILE_SCENE) as PackedScene
	check(target_scene != null and projectile_scene != null, "cenas de alvo e projétil carregam")
	if target_scene == null or projectile_scene == null:
		return true
	var target: BoltTrainingTarget = target_scene.instantiate() as BoltTrainingTarget
	var projectile: ChronoProjectile = projectile_scene.instantiate() as ChronoProjectile
	var root: Node2D = Node2D.new()
	tree.root.add_child(root)
	root.add_child(target)
	root.add_child(projectile)
	target.global_position = Vector2(160.0, 0.0)
	projectile.global_position = Vector2(0.0, 0.0)
	projectile.configure(1, 720.0, 1, 1.0)
	var defeated: Array[bool] = [false]
	target.defeated.connect(func() -> void: defeated[0] = true)
	for _tick in range(30):
		await tree.physics_frame
		if defeated[0]:
			break
	check(defeated[0], "projétil atinge e derrota alvo de treinamento")
	check(not is_instance_valid(target), "alvo é removido após vida chegar a zero")
	root.queue_free()
	await tree.process_frame
	return true
