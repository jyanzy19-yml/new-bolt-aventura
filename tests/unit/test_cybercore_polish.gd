extends BoltTest
## Polimento visual/feedback de Cybercore: backdrop, partículas, feedback do jogador, telégrafo.
## Verifica ESTRUTURA e COMPORTAMENTO observável em headless; não julga estética (isso foi feito
## por captura de tela renderizada, fora desta suíte) nem desempenho em aparelho.

const BACKDROP: String = "res://scenes/world/cybercore_backdrop.tscn"
const BOLT: String = "res://scenes/player/bolt.tscn"
const BLOCK: String = "res://scenes/world/platform_block.tscn"
const GATE: String = "res://scenes/levels/timed_energy_gate.tscn"
const ENEMY: String = "res://scenes/enemies/cybercore_patrol_enemy.tscn"
const LEVELS: Array[String] = ["res://scenes/campaign/cybercore_w1_l1.tscn", "res://scenes/campaign/cybercore_w1_l2.tscn"]


func _action(action: StringName, pressed: bool) -> void:
	var event: InputEventAction = InputEventAction.new()
	event.action = action
	event.pressed = pressed
	event.strength = 1.0 if pressed else 0.0
	Input.parse_input_event(event)


func _frames(count: int) -> void:
	for i in range(count):
		await tree.physics_frame


## Cena mínima: piso em y=0 e BOLT 'height' px acima dele.
func _world(height: float) -> Array:
	Actions.release_all_game_actions()
	var root: Node2D = Node2D.new()
	var floor_block: PlatformBlock = (load(BLOCK) as PackedScene).instantiate() as PlatformBlock
	floor_block.position = Vector2(-2000.0, 0.0)
	floor_block.size = Vector2(4000.0, 64.0)
	root.add_child(floor_block)
	var player: BoltPlayer = (load(BOLT) as PackedScene).instantiate() as BoltPlayer
	player.position = Vector2(0.0, -20.0 - height)
	root.add_child(player)
	tree.root.add_child(root)
	return [root, player, player.get_node("Feedback") as BoltFeedback]


func _free(root: Node) -> void:
	Actions.release_all_game_actions()
	root.queue_free()
	await tree.process_frame


func test_backdrop_has_three_ordered_parallax_layers() -> bool:
	var backdrop: ParallaxBackground = (load(BACKDROP) as PackedScene).instantiate() as ParallaxBackground
	tree.root.add_child(backdrop)
	check_eq(backdrop.layer, -100, "atrás de tudo")
	var layers: Array[ParallaxLayer] = []
	for child: Node in backdrop.get_children():
		if child is ParallaxLayer:
			layers.append(child)
	check_eq(layers.size(), 3, "três camadas")
	if layers.size() == 3:
		check_eq(layers[0].motion_scale, Vector2.ZERO, "céu fixo na tela")
		check(layers[1].motion_scale.x > 0.0 and layers[1].motion_scale.x < layers[2].motion_scale.x, "mais longe = move menos")
		check(layers[2].motion_scale.x < 1.0, "fundo nunca acompanha o primeiro plano")
		for layer: ParallaxLayer in layers:
			var art: CybercoreBackdropLayer = layer.get_child(0) as CybercoreBackdropLayer
			check(art != null, "camada com arte: %s" % layer.name)
			if art != null:
				# Geometria existe e vem de UMA malha (1 draw call por camada, medido em render real).
				check(art.triangle_count() >= 6, "camada %s gera geometria (%d triângulos)" % [layer.name, art.triangle_count()])
				check(art.triangle_count() < 20000, "camada %s dentro do orçamento de vértices" % layer.name)
	backdrop.queue_free()
	await tree.process_frame
	return true


func test_both_w1_levels_use_the_backdrop() -> bool:
	for path: String in LEVELS:
		var level: Node = (load(path) as PackedScene).instantiate()
		var found: bool = false
		for child: Node in level.get_children():
			if child is CybercoreBackdrop:
				found = true
		check(found, "backdrop presente em %s" % path.get_file())
		level.free()
	return true


func test_burst_spawns_one_shot_particles_and_releases_them() -> bool:
	# Efeitos de testes anteriores podem expirar durante a espera deste teste.
	await tree.create_timer(1.0).timeout
	var host: Node2D = Node2D.new()
	tree.root.add_child(host)
	var before: int = Burst.active_count()
	var particles: CPUParticles2D = Burst.spawn(host, Vector2(10.0, 20.0), Color.WHITE, 6, 100.0, 0.1)
	check(particles != null, "criado")
	if particles != null:
		check(particles.one_shot and particles.emitting, "dispara uma vez")
		check_eq(particles.global_position, Vector2(10.0, 20.0), "na posição pedida")
		check_eq(Burst.active_count(), before + 1, "contabilizado")
	await tree.create_timer(0.6).timeout
	check_eq(Burst.active_count(), before, "liberado após o tempo de vida")
	check(particles == null or not is_instance_valid(particles), "nó removido da árvore")
	check_eq(Burst.spawn(null, Vector2.ZERO, Color.WHITE), null, "sem pai: omitido sem erro")
	check_eq(Burst.spawn(host, Vector2.ZERO, Color.WHITE, 0), null, "quantidade inválida: omitido")
	host.queue_free()
	await tree.process_frame
	return true


func test_burst_releases_counter_when_parent_is_freed_before_timeout() -> bool:
	# Drena bursts dos testes anteriores para isolar o delta deste caso.
	await tree.create_timer(1.0).timeout
	var host: Node2D = Node2D.new()
	tree.root.add_child(host)
	var baseline: int = Burst.active_count()
	var particles: CPUParticles2D = Burst.spawn(host, Vector2.ZERO, Color.WHITE, 4, 50.0, 0.1)
	check(particles != null, "burst criado antes de destruir o pai")
	check_eq(Burst.active_count(), baseline + 1, "contador incrementado")
	host.queue_free()
	await tree.process_frame
	check(not is_instance_valid(particles), "partícula removida junto com o pai")
	await tree.create_timer(0.6).timeout
	check_eq(Burst.active_count(), baseline, "callback do timer libera contador mesmo após destruição do pai")
	return true


func test_burst_count_is_capped() -> bool:
	var host: Node2D = Node2D.new()
	tree.root.add_child(host)
	var baseline: int = Burst.active_count()  # podem restar bursts de testes anteriores
	var created: int = 0
	for i in range(72):
		if Burst.spawn(host, Vector2.ZERO, Color.WHITE, 2, 50.0, 0.05) != null:
			created += 1
	# Teto em valor LITERAL: se alguém afrouxar a constante, este teste precisa falhar.
	check(Burst.active_count() <= 24, "nunca acima do teto de 24 (%d)" % Burst.active_count())
	check(created < 72, "excedentes omitidos (%d de 72 criados)" % created)
	await tree.create_timer(0.8).timeout
	check(Burst.active_count() <= baseline, "os criados aqui foram liberados")
	host.queue_free()
	await tree.process_frame
	return true


func test_hard_landing_makes_dust_but_a_tiny_drop_does_not() -> bool:
	var world: Array = _world(300.0)
	var player: BoltPlayer = world[1]
	var feedback: BoltFeedback = world[2]
	for i in range(200):
		await tree.physics_frame
		if player.is_on_floor():
			break
	check(player.is_on_floor(), "pré-condição: pousou")
	check_eq(feedback.landing_bursts, 1, "queda grande gera poeira de pouso")
	await _free(world[0])
	var small: Array = _world(4.0)
	var small_player: BoltPlayer = small[1]
	for i in range(60):
		await tree.physics_frame
	check(small_player.is_on_floor(), "pré-condição: pousou (queda pequena)")
	check_eq((small[2] as BoltFeedback).landing_bursts, 0, "queda mínima não gera poeira")
	await _free(small[0])
	return true


func test_jump_and_dash_feedback_trigger_without_changing_movement() -> bool:
	var world: Array = _world(0.0)
	var player: BoltPlayer = world[1]
	var feedback: BoltFeedback = world[2]
	await _frames(20)  # assenta no chão
	check(player.is_on_floor(), "pré-condição: no chão")
	_action(Actions.JUMP, true)
	await _frames(3)
	_action(Actions.JUMP, false)
	check(feedback.jump_bursts >= 1, "pulo gera impulso")
	check(player.velocity.y < 0.0 or player.state != BoltPlayer.State.GROUNDED, "o pulo continua funcionando")
	await _frames(70)
	_action(Actions.MOVE_RIGHT, true)
	_action(Actions.DASH, true)
	await _frames(4)
	_action(Actions.DASH, false)
	_action(Actions.MOVE_RIGHT, false)
	check(feedback.dash_trail_bursts >= 1, "dash deixa rastro")
	await _free(world[0])
	return true


func test_camera_look_ahead_follows_facing_and_can_be_disabled() -> bool:
	var world: Array = _world(0.0)
	var player: BoltPlayer = world[1]
	var feedback: BoltFeedback = world[2]
	var camera: Camera2D = player.get_camera()
	player.facing = 1
	for i in range(90):
		await tree.process_frame
	check(camera.offset.x > feedback.look_ahead * 0.6, "antecipa à direita (%.1f)" % camera.offset.x)
	check(camera.offset.x <= feedback.look_ahead + 0.01, "nunca excede o limite")
	player.facing = -1
	for i in range(90):
		await tree.process_frame
	check(camera.offset.x < -feedback.look_ahead * 0.6, "inverte para a esquerda (%.1f)" % camera.offset.x)
	feedback.camera_effects_enabled = false
	camera.offset = Vector2.ZERO
	for i in range(10):
		await tree.process_frame
	check_eq(camera.offset, Vector2.ZERO, "desligável: câmera intacta")
	await _free(world[0])
	return true


func test_damage_shakes_camera_and_bursts_without_changing_damage_rules() -> bool:
	var world: Array = _world(0.0)
	var player: BoltPlayer = world[1]
	var feedback: BoltFeedback = world[2]
	feedback.look_ahead = 0.0
	await _frames(10)
	check_eq(player.take_damage(1), true, "dano aplicado como antes")
	check_eq(feedback.damage_bursts, 1, "efeito de dano")
	await tree.process_frame
	await tree.process_frame  # process_frame é emitido antes do _process dos nós
	check(player.get_camera().offset.length() > 0.0, "câmera treme")
	check_eq(player.take_damage(1), false, "invulnerabilidade preservada (sem 2º efeito)")
	check_eq(feedback.damage_bursts, 1, "sem efeito duplicado")
	await tree.create_timer(2.5).timeout  # tempo real: o tremor deve se esgotar sozinho
	await tree.process_frame
	await tree.process_frame
	check_near(player.get_camera().offset.length(), 0.0, 0.25, "tremor termina (resíduo imperceptível do suavizador)")
	await _free(world[0])
	return true


func test_energy_gate_telegraphs_before_activating() -> bool:
	var gate: TimedEnergyGate = (load(GATE) as PackedScene).instantiate() as TimedEnergyGate
	gate.initial_active = false
	gate.inactive_duration = 0.3  # menor que a janela de telégrafo
	gate.active_duration = 2.0
	tree.root.add_child(gate)
	await tree.process_frame
	await tree.process_frame
	var visual: Polygon2D = gate.get_node("%Visual") as Polygon2D
	check(not gate.is_active(), "ainda inativo")
	check(visual.color.r > 0.9 and visual.color.g > 0.4, "pisca em alerta laranja antes de ativar")
	check_eq(gate.monitoring, false, "o aviso não ativa o dano")
	await tree.create_timer(0.45).timeout
	check(gate.is_active(), "ativa no tempo normal")
	check(visual.color.r > 0.9 and visual.color.b < 0.4, "ativo = vermelho-alaranjado (perigo)")
	gate.queue_free()
	await tree.process_frame
	return true


func test_enemy_defeat_makes_an_explosion_and_still_reports_defeat() -> bool:
	var host: Node2D = Node2D.new()
	tree.root.add_child(host)
	var enemy: CybercorePatrolEnemy = (load(ENEMY) as PackedScene).instantiate() as CybercorePatrolEnemy
	host.add_child(enemy)
	var defeated: Array[bool] = [false]
	enemy.defeated.connect(func() -> void: defeated[0] = true)
	await tree.process_frame
	enemy.apply_damage(1)
	var hit_particles: int = 0
	for child: Node in host.get_children():
		if child is CPUParticles2D:
			hit_particles += 1
	check(hit_particles >= 1, "acerto sem derrota gera faíscas")
	enemy.apply_damage(5)
	var biggest: int = 0
	for child: Node in host.get_children():
		if child is CPUParticles2D:
			biggest = maxi(biggest, (child as CPUParticles2D).amount)
	check(biggest >= 15, "derrota gera explosão grande (maior burst: %d partículas)" % biggest)
	check(defeated[0], "sinal de derrota preservado")
	await tree.create_timer(0.9).timeout
	host.queue_free()
	await tree.process_frame
	return true
