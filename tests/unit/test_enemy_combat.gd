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


func test_health_restore_is_capped_and_cannot_revive_depleted_health() -> bool:
	var health: BoltHealth = BoltHealth.new()
	health.max_health = 3
	tree.root.add_child(health)
	await tree.process_frame
	check_eq(health.current_health, 3, "componente inicia com vida máxima")
	check(health.apply_damage(2), "componente aceita dano")
	check(health.restore(1), "componente restaura vida")
	check_eq(health.current_health, 2, "restauração soma a quantidade solicitada")
	check(health.restore(10), "restauração excedente é aceita")
	check_eq(health.current_health, 3, "restauração não ultrapassa vida máxima")
	check(not health.restore(1), "restaurar vida cheia não altera o estado")
	check(health.apply_damage(3), "dano pode esgotar a vida")
	check_eq(health.current_health, 0, "vida chega a zero")
	check(not health.restore(2), "cura não revive componente esgotado")
	health.queue_free()
	await tree.process_frame
	return true


func test_health_pickup_only_collects_when_player_needs_health() -> bool:
	var player_scene: PackedScene = load(PLAYER_SCENE) as PackedScene
	var pickup_scene: PackedScene = load("res://scenes/combat/bolt_health_pickup.tscn") as PackedScene
	check(player_scene != null and pickup_scene != null, "cenas de BOLT e coletável de vida carregam")
	if player_scene == null or pickup_scene == null:
		return true
	var root: Node2D = Node2D.new()
	tree.root.add_child(root)
	var player: BoltPlayer = player_scene.instantiate() as BoltPlayer
	var pickup: BoltHealthPickup = pickup_scene.instantiate() as BoltHealthPickup
	root.add_child(player)
	root.add_child(pickup)
	await tree.process_frame
	var health: BoltHealth = player.get_node("%Health") as BoltHealth
	check(not player.heal(1), "BOLT não aceita cura quando está com vida cheia")
	check(not pickup.is_queued_for_deletion(), "coletável permanece disponível com vida cheia")
	check(player.take_damage(1, 0.0), "BOLT recebe dano antes da coleta")
	check_eq(health.current_health, 2, "dano reduz vida para permitir recuperação")
	pickup.call("_on_body_entered", player)
	check_eq(health.current_health, 3, "coletável restaura um ponto de vida")
	check(pickup.is_queued_for_deletion(), "coletável é consumido após cura válida")
	root.queue_free()
	await tree.process_frame
	return true


func test_enemy_hit_feedback_flashes_and_returns_to_base_color() -> bool:
	var enemy_scene: PackedScene = load(ENEMY_SCENE) as PackedScene
	check(enemy_scene != null, "cena do inimigo carrega para teste de feedback")
	if enemy_scene == null:
		return true
	var root: Node2D = Node2D.new()
	tree.root.add_child(root)
	var enemy: CybercorePatrolEnemy = enemy_scene.instantiate() as CybercorePatrolEnemy
	root.add_child(enemy)
	await tree.process_frame
	var visual: Polygon2D = enemy.get_node("%Visual") as Polygon2D
	var original_color: Color = visual.color
	enemy.apply_damage(1)
	check(visual.color != original_color, "inimigo muda de cor ao receber dano")
	check_eq((enemy.get_node("%Health") as BoltHealth).current_health, 2, "feedback acompanha redução real de vida")
	for _tick in 12:
		await tree.physics_frame
	check_eq(visual.color, original_color, "cor original retorna após o flash")
	root.queue_free()
	await tree.process_frame
	return true



func test_health_pickup_collects_through_physical_area_contact() -> bool:
	var player_scene: PackedScene = load(PLAYER_SCENE) as PackedScene
	var pickup_scene: PackedScene = load("res://scenes/combat/bolt_health_pickup.tscn") as PackedScene
	check(player_scene != null and pickup_scene != null, "cenas de BOLT e coletável carregam para contato físico")
	if player_scene == null or pickup_scene == null:
		return true
	var root: Node2D = Node2D.new()
	tree.root.add_child(root)
	var player: BoltPlayer = player_scene.instantiate() as BoltPlayer
	var pickup: BoltHealthPickup = pickup_scene.instantiate() as BoltHealthPickup
	player.damage_invulnerability = 0.0
	var collected_amounts: Array[int] = []
	pickup.collected.connect(func(amount: int) -> void:
		collected_amounts.append(amount)
	)
	root.add_child(player)
	root.add_child(pickup)
	await tree.process_frame
	var health: BoltHealth = player.get_node("%Health") as BoltHealth
	check(player.take_damage(1, 0.0), "BOLT recebe dano antes do contato físico")
	player.velocity = Vector2.ZERO
	pickup.global_position = player.global_position
	for _tick in 5:
		await tree.physics_frame
		if not collected_amounts.is_empty():
			break
	if not collected_amounts.is_empty():
		for _settle_tick in 3:
			await tree.physics_frame
	check_eq(health.current_health, 3, "contato físico real restaura a vida de BOLT")
	check_eq(collected_amounts.size(), 1, "contato físico emite collected exatamente uma vez")
	if not collected_amounts.is_empty():
		check_eq(collected_amounts[0], 1, "sinal de coleta informa a quantidade restaurada")
	check(not is_instance_valid(pickup) or pickup.is_queued_for_deletion(), "coletável é consumido após a coleta física")
	root.queue_free()
	await tree.process_frame
	return true


func _send_action(action: StringName, pressed: bool) -> void:
	var event: InputEventAction = InputEventAction.new()
	event.action = action
	event.pressed = pressed
	event.strength = 1.0 if pressed else 0.0
	Input.parse_input_event(event)


func _count_projectiles(root: Node) -> int:
	var count: int = 0
	for child: Node in root.get_children():
		if child is ChronoProjectile and not child.is_queued_for_deletion():
			count += 1
	return count


func test_respawn_resets_attack_cooldown_and_reenables_combat() -> bool:
	var packed: PackedScene = load(PLAYER_SCENE) as PackedScene
	check(packed != null, "cena de BOLT carrega para regressão de respawn/combate")
	if packed == null:
		return true

	var root: Node2D = Node2D.new()
	tree.root.add_child(root)
	var player: BoltPlayer = packed.instantiate() as BoltPlayer
	root.add_child(player)
	await tree.process_frame

	_send_action(Actions.ATTACK, true)
	_send_action(Actions.ATTACK, false)
	for _tick in 2:
		await tree.physics_frame
	check_eq(_count_projectiles(root), 1, "primeiro ataque cria um projétil")

	check(player.take_damage(3, 1.0), "derrota desativa o combate após esgotar a vida")
	check(not player.is_physics_processing(), "jogador derrotado interrompe a física")
	player.respawn(Vector2(80.0, -20.0))
	check(player.is_physics_processing(), "respawn reativa a física do jogador")

	_send_action(Actions.ATTACK, true)
	_send_action(Actions.ATTACK, false)
	for _tick in 2:
		await tree.physics_frame
	check_eq(_count_projectiles(root), 2, "primeiro ataque após respawn não herda o cooldown anterior")

	Actions.release_all_game_actions()
	root.queue_free()
	await tree.process_frame
	return true


func test_respawn_discards_unconsumed_action_buffer_press() -> bool:
	var packed: PackedScene = load(PLAYER_SCENE) as PackedScene
	check(packed != null, "cena de BOLT carrega para regressão do ActionBuffer no respawn")
	if packed == null:
		return true

	var root: Node2D = Node2D.new()
	tree.root.add_child(root)
	var player: BoltPlayer = packed.instantiate() as BoltPlayer
	root.add_child(player)
	await tree.process_frame
	var buffer: ActionBuffer = player.get_node("%ActionBuffer") as ActionBuffer
	player.set_physics_process(false)

	_send_action(Actions.ATTACK, true)
	_send_action(Actions.ATTACK, false)
	check(buffer.has_pending(Actions.ATTACK), "toque curto fica pendente antes do respawn")

	player.respawn(Vector2(64.0, -24.0))
	check(not buffer.has_pending(Actions.ATTACK), "respawn descarta o comando antigo não consumido")
	check(player.is_physics_processing(), "respawn reativa o processamento do jogador")

	Actions.release_all_game_actions()
	root.queue_free()
	await tree.process_frame
	return true


func test_enemy_terminal_lifecycle_is_idempotent_and_ignores_late_contact() -> bool:
	var player_scene: PackedScene = load(PLAYER_SCENE) as PackedScene
	var enemy_scene: PackedScene = load(ENEMY_SCENE) as PackedScene
	check(player_scene != null and enemy_scene != null, "cenas de BOLT e inimigo carregam para o contrato terminal")
	if player_scene == null or enemy_scene == null:
		return true

	var root: Node2D = Node2D.new()
	tree.root.add_child(root)
	var player: BoltPlayer = player_scene.instantiate() as BoltPlayer
	var enemy: CybercorePatrolEnemy = enemy_scene.instantiate() as CybercorePatrolEnemy
	player.global_position = Vector2(1000.0, 0.0)
	enemy.global_position = Vector2.ZERO
	root.add_child(player)
	root.add_child(enemy)
	await tree.process_frame

	var player_health: BoltHealth = player.get_node("%Health") as BoltHealth
	var enemy_health: BoltHealth = enemy.get_node("%Health") as BoltHealth
	var defeated_events: Array[int] = [0]
	var hit_events: Array[int] = [0]
	enemy.defeated.connect(func() -> void: defeated_events[0] += 1)
	enemy.hit_received.connect(func(_remaining: int) -> void: hit_events[0] += 1)

	enemy.apply_damage(0)
	check_eq(enemy_health.current_health, 3, "dano inválido não altera a vida do inimigo")
	check_eq(hit_events[0], 0, "dano inválido não emite hit_received")

	enemy.apply_damage(3)
	check_eq(enemy_health.current_health, 0, "dano letal esgota a vida do inimigo")
	check_eq(hit_events[0], 1, "dano letal aceito emite um único hit_received")
	check_eq(defeated_events[0], 1, "transição terminal emite defeated uma única vez")
	check(enemy.is_queued_for_deletion(), "inimigo derrotado agenda remoção")

	# queue_free() é diferido; callbacks ainda podem chegar antes do flush da SceneTree.
	enemy.apply_damage(1)
	enemy.call("_on_contact_body_entered", player)
	check_eq(enemy_health.current_health, 0, "dano tardio não reabre o ciclo terminal")
	check_eq(hit_events[0], 1, "dano tardio não duplica hit_received")
	check_eq(defeated_events[0], 1, "callbacks tardios não duplicam defeated")
	check_eq(player_health.current_health, player_health.max_health,
		"contato tardio após derrota não causa dano em BOLT")

	root.queue_free()
	await tree.process_frame
	return true
