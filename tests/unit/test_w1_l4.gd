extends BoltTest
## W1-L4 Núcleo de Distribuição (BLOCKOUT PROVISÓRIO): composição, puzzle de ponta a ponta com
## projéteis reais, falha/recuperação, barreira física, checkpoints, conclusão e invariantes de
## level design (rota obrigatória alcançável sem rota secreta, sem contorno da barreira).

const LEVEL_SCENE: String = "res://scenes/campaign/cybercore_w1_l4.tscn"
const PROJECTILE_SCENE: String = "res://scenes/combat/chrono_projectile.tscn"
const TEST_SAVE_PATH: String = "user://bolt_w1_l4_test.json"
const CHECKPOINT_A: String = "cybercore_w1_l4_checkpoint_a"
const CHECKPOINT_B: String = "cybercore_w1_l4_checkpoint_b"
## Folga conservadora: salto simples (112 px) com margem; vão máximo de salto simples (~160 px) com margem.
const MAX_MANDATORY_RISE: float = 96.0
const MAX_MANDATORY_GAP: float = 140.0


func _begin() -> void:
	SaveSystem.storage_path_override = TEST_SAVE_PATH
	SaveSystem.delete_save()


func _end() -> void:
	tree.paused = false
	SaveSystem.delete_save()
	SaveSystem.storage_path_override = ""


func _spawn_level() -> Node:
	var packed: PackedScene = load(LEVEL_SCENE) as PackedScene
	check(packed != null, "cena W1-L4 carrega")
	if packed == null:
		return null
	var level: Node = packed.instantiate()
	tree.root.add_child(level)
	await tree.physics_frame
	return level


func _ticks(count: int) -> void:
	for _tick in range(count):
		await tree.physics_frame


## Dispara um projétil Crono REAL em direção ao relé, a partir da esquerda, no caminho livre.
func _shoot(level: Node, relay_name: String) -> void:
	var relay: EnergyRelay = level.get_node("%" + relay_name) as EnergyRelay
	var projectile: ChronoProjectile = (load(PROJECTILE_SCENE) as PackedScene).instantiate() as ChronoProjectile
	level.add_child(projectile)
	projectile.global_position = relay.global_position + Vector2(-90.0, -4.0)
	projectile.configure(1, 720.0, 1, 1.4)
	await _ticks(8)


func _relay(level: Node, relay_name: String) -> EnergyRelay:
	return level.get_node("%" + relay_name) as EnergyRelay


func _top(block: Node) -> float:
	return (block as Node2D).global_position.y


func _left(block: Node) -> float:
	return (block as Node2D).global_position.x


func _right(block: Node) -> float:
	return (block as Node2D).global_position.x + (block as PlatformBlock).size.x


func _gap(a: Node, b: Node) -> float:
	return maxf(0.0, maxf(_left(b) - _right(a), _left(a) - _right(b)))


func test_w1_l4_composition_and_initial_state() -> bool:
	_begin()
	var level: Node = await _spawn_level()
	if level == null:
		_end()
		return true
	var puzzle: DistributionPuzzle = level.get_node("%Puzzle") as DistributionPuzzle
	var gate: DistributionGate = level.get_node("%Gate") as DistributionGate
	check_eq(puzzle.total(), 3, "puzzle com três relés")
	check_eq(puzzle.progress(), 0, "puzzle inicia sem progresso")
	check(not puzzle.is_solved(), "puzzle inicia não resolvido")
	check(not gate.is_open(), "barreira inicia fechada")
	check(not (gate.get_node("%CollisionShape2D") as CollisionShape2D).disabled, "barreira inicia com colisão ativa")
	check_eq(puzzle.get_relay_glyphs(), [EnergyRelay.Glyph.DIAMOND, EnergyRelay.Glyph.CIRCLE, EnergyRelay.Glyph.TRIANGLE], "ordem de glifos: losango, círculo, triângulo")
	for relay_name: String in ["RelayA", "RelayB", "RelayC"]:
		var relay: EnergyRelay = _relay(level, relay_name)
		check_eq(relay.get_visual_state(), EnergyRelay.VisualState.OFF, "%s inicia apagado" % relay_name)
		check_eq(relay.collision_layer, 4, "%s usa a camada de alvo (4)" % relay_name)
		check(relay.has_method("apply_damage"), "%s segue o contrato de alvo" % relay_name)
	var conduits: Array[EnergyConduit] = []
	for conduit_name: String in ["Conduit0", "Conduit1", "Conduit2", "Conduit3"]:
		conduits.append(level.get_node("%" + conduit_name) as EnergyConduit)
	check(conduits[0].is_lit(), "conduíte fonte -> 1º relé inicia aceso (indica por onde começar)")
	check(not conduits[1].is_lit() and not conduits[2].is_lit() and not conduits[3].is_lit(), "demais conduítes iniciam apagados")
	var mural: EnergyClueMural = level.get_node("Background/ClueMural") as EnergyClueMural
	check_eq(mural.get_glyph_sequence(), puzzle.get_relay_glyphs(), "mural mostra exatamente a ordem real")
	check_eq((level.get_node("%CheckpointA") as BoltCheckpoint).checkpoint_id, &"cybercore_w1_l4_checkpoint_a", "ID do checkpoint A")
	check_eq((level.get_node("%CheckpointB") as BoltCheckpoint).checkpoint_id, &"cybercore_w1_l4_checkpoint_b", "ID do checkpoint B")
	level.free()
	_end()
	return true


func test_w1_l4_solves_end_to_end_with_real_projectiles() -> bool:
	_begin()
	var level: Node = await _spawn_level()
	if level == null:
		_end()
		return true
	var puzzle: DistributionPuzzle = level.get_node("%Puzzle") as DistributionPuzzle
	var gate: DistributionGate = level.get_node("%Gate") as DistributionGate
	await _shoot(level, "RelayA")
	check_eq(puzzle.progress(), 1, "tiro em A energiza o 1º nó")
	check_eq(_relay(level, "RelayA").get_visual_state(), EnergyRelay.VisualState.ENERGIZED, "A fica energizado")
	check((level.get_node("%Conduit1") as EnergyConduit).is_lit(), "energia avança pelo conduíte A->B")
	check(not (level.get_node("%Conduit2") as EnergyConduit).is_lit(), "conduíte B->C continua apagado")
	await _shoot(level, "RelayB")
	check_eq(puzzle.progress(), 2, "tiro em B energiza o 2º nó")
	check(not gate.is_open(), "barreira segue fechada com 2/3")
	await _shoot(level, "RelayC")
	check(puzzle.is_solved(), "tiro em C resolve")
	check(gate.is_open(), "barreira abre ao resolver")
	check((level.get_node("%Conduit3") as EnergyConduit).is_lit(), "conduíte final aceso")
	await _ticks(2)
	check((gate.get_node("%CollisionShape2D") as CollisionShape2D).disabled, "colisão da barreira desativada")
	level.free()
	_end()
	return true


func test_w1_l4_wrong_order_resets_without_damage_and_recovers() -> bool:
	_begin()
	var level: Node = await _spawn_level()
	if level == null:
		_end()
		return true
	var puzzle: DistributionPuzzle = level.get_node("%Puzzle") as DistributionPuzzle
	var player: BoltPlayer = level.get_node("%Bolt") as BoltPlayer
	var health: BoltHealth = player.get_node("%Health") as BoltHealth
	var failures: Array = []
	puzzle.sequence_failed.connect(func(relay_id: StringName) -> void: failures.append(relay_id))
	await _shoot(level, "RelayA")
	await _shoot(level, "RelayC")  # pula B: ordem incorreta
	check_eq(failures, [&"relay_c"], "ordem incorreta emite uma falha com o relé culpado")
	check_eq(puzzle.progress(), 0, "falha reinicia o progresso")
	check_eq(puzzle.failure_count(), 1, "falha contabilizada")
	check_eq(_relay(level, "RelayC").get_visual_state(), EnergyRelay.VisualState.REJECTED, "relés exibem rejeição (X)")
	check_eq(_relay(level, "RelayA").get_visual_state(), EnergyRelay.VisualState.REJECTED, "todos os relés piscam rejeição")
	check(not (level.get_node("%Conduit1") as EnergyConduit).is_lit(), "conduítes apagam após a falha")
	check_eq(health.current_health, 3, "falha do puzzle não causa dano")
	check(not (level.get_node("%Gate") as DistributionGate).is_open(), "falha não abre a barreira")
	# Após o flash o estado de repouso é OFF.
	await _ticks(int(_relay(level, "RelayA").reject_flash_duration * 60.0) + 12)
	check_eq(_relay(level, "RelayA").get_visual_state(), EnergyRelay.VisualState.OFF, "após o flash voltam a apagado")
	# Retorno após falha: a ordem correta resolve.
	await _shoot(level, "RelayA")
	await _shoot(level, "RelayB")
	await _shoot(level, "RelayC")
	check(puzzle.is_solved(), "puzzle resolve normalmente após uma falha")
	level.free()
	_end()
	return true


func test_w1_l4_duplicate_callbacks_and_post_solve_hits_are_inert() -> bool:
	_begin()
	var level: Node = await _spawn_level()
	if level == null:
		_end()
		return true
	var puzzle: DistributionPuzzle = level.get_node("%Puzzle") as DistributionPuzzle
	var relay_a: EnergyRelay = _relay(level, "RelayA")
	var progress_events: Array = []
	var solved_events: Array = []
	puzzle.progress_changed.connect(func(p: int, t: int) -> void: progress_events.append([p, t]))
	puzzle.solved.connect(func() -> void: solved_events.append(true))
	relay_a.apply_damage(1)
	relay_a.apply_damage(1)
	relay_a.apply_damage(1)
	check_eq(puzzle.progress(), 1, "três golpes simultâneos em A contam uma vez")
	check_eq(puzzle.failure_count(), 0, "duplicados não geram falha")
	check_eq(progress_events.size(), 1, "um único evento de progresso")
	_relay(level, "RelayB").apply_damage(1)
	_relay(level, "RelayC").apply_damage(1)
	relay_a.apply_damage(1)
	_relay(level, "RelayC").apply_damage(1)
	check(puzzle.is_solved(), "resolvido")
	check_eq(solved_events.size(), 1, "sinal solved emitido uma única vez")
	check_eq(puzzle.failure_count(), 0, "golpes pós-resolução não reiniciam nem falham")
	check((level.get_node("%Gate") as DistributionGate).is_open(), "barreira permanece aberta")
	level.free()
	_end()
	return true


func test_w1_l4_gate_blocks_player_until_solved_then_allows_passage() -> bool:
	_begin()
	var level: Node = await _spawn_level()
	if level == null:
		_end()
		return true
	var player: BoltPlayer = level.get_node("%Bolt") as BoltPlayer
	var gate: DistributionGate = level.get_node("%Gate") as DistributionGate
	player.global_position = Vector2(gate.global_position.x - 120.0, -24.0)
	player.velocity = Vector2.ZERO
	for _tick in range(90):
		player.velocity.x = 260.0
		await tree.physics_frame
	check(player.global_position.x < gate.global_position.x, "barreira fechada impede a passagem física")
	for relay_name: String in ["RelayA", "RelayB", "RelayC"]:
		_relay(level, relay_name).apply_damage(1)
	await _ticks(3)
	for _tick in range(90):
		player.velocity.x = 260.0
		await tree.physics_frame
	check(player.global_position.x > gate.global_position.x + 40.0, "barreira aberta permite a passagem")
	level.free()
	_end()
	return true


func test_w1_l4_goal_requires_puzzle_and_progress_is_not_duplicated() -> bool:
	_begin()
	var level: Node = await _spawn_level()
	if level == null:
		_end()
		return true
	var player: BoltPlayer = level.get_node("%Bolt") as BoltPlayer
	var hud: Hud = level.get_node("%Hud") as Hud
	var goal: Area2D = level.get_node("%Goal") as Area2D
	player.global_position = goal.global_position
	player.velocity = Vector2.ZERO
	await _ticks(4)
	check(not hud.get_node("%ResultOverlay").visible, "objetivo não conclui com o puzzle não resolvido")
	check(not CampaignProgress.is_level_completed("W1-L4"), "nada persistido como concluído sem o puzzle")
	for relay_name: String in ["RelayA", "RelayB", "RelayC"]:
		_relay(level, relay_name).apply_damage(1)
	player.global_position = goal.global_position + Vector2(0.0, 8.0)
	await _ticks(2)
	player.global_position = goal.global_position
	player.velocity = Vector2.ZERO
	await _ticks(4)
	check(hud.get_node("%ResultOverlay").visible, "objetivo conclui com o puzzle resolvido")
	check(CampaignProgress.is_level_completed("W1-L4"), "conclusão persiste")
	# Reentrada repetida no objetivo não duplica a progressão.
	player.global_position = goal.global_position + Vector2(200.0, 0.0)
	await _ticks(2)
	player.global_position = goal.global_position
	await _ticks(4)
	var completed: Array = CampaignProgress.load_state().get("completed_level_ids", [])
	check_eq(completed.count("W1-L4"), 1, "W1-L4 aparece uma única vez em completed_level_ids")
	check_eq(CampaignProgress.load_state().get("current_level_id"), "W1-L4", "sem fase seguinte implementada, retomada permanece em W1-L4")
	level.free()
	_end()
	return true


func test_w1_l4_checkpoints_persist_resume_and_keep_puzzle_on_respawn() -> bool:
	_begin()
	var level: Node = await _spawn_level()
	if level == null:
		_end()
		return true
	var player: BoltPlayer = level.get_node("%Bolt") as BoltPlayer
	var puzzle: DistributionPuzzle = level.get_node("%Puzzle") as DistributionPuzzle
	var cp_a: BoltCheckpoint = level.get_node("%CheckpointA") as BoltCheckpoint
	var cp_b: BoltCheckpoint = level.get_node("%CheckpointB") as BoltCheckpoint
	check_eq(CampaignProgress.load_state().get("current_level_id"), "W1-L4", "entrada registra W1-L4")
	check_eq(CampaignProgress.get_checkpoint_id("W1-L4"), "", "sem checkpoint inicialmente")
	player.global_position = cp_a.global_position
	player.velocity = Vector2.ZERO
	await _ticks(4)
	check_eq(CampaignProgress.get_checkpoint_id("W1-L4"), CHECKPOINT_A, "checkpoint A persiste")
	_relay(level, "RelayA").apply_damage(1)
	player.global_position = cp_b.global_position
	player.velocity = Vector2.ZERO
	await _ticks(4)
	check_eq(CampaignProgress.get_checkpoint_id("W1-L4"), CHECKPOINT_B, "checkpoint B substitui A")
	# Queda no vazio: respawn no B e o progresso do puzzle da instância é mantido.
	var kill_zone: Area2D = level.get_node("%KillZone") as Area2D
	player.global_position = Vector2(cp_b.global_position.x, kill_zone.global_position.y)
	await _ticks(6)
	check(player.global_position.distance_to(cp_b.get_respawn_position()) < 40.0, "queda reposiciona BOLT no checkpoint B")
	check_eq(puzzle.progress(), 1, "respawn por queda não reinicia o puzzle (sem retrabalho)")
	level.free()
	await tree.process_frame
	var resumed: Node = await _spawn_level()
	var resumed_player: BoltPlayer = resumed.get_node("%Bolt") as BoltPlayer
	var resumed_b: BoltCheckpoint = resumed.get_node("%CheckpointB") as BoltCheckpoint
	check(resumed_b.is_activated() and not (resumed.get_node("%CheckpointA") as BoltCheckpoint).is_activated(), "retomada restaura somente o checkpoint salvo (B)")
	check(resumed_player.global_position.distance_to(resumed_b.get_respawn_position()) < 8.0, "retomada posiciona BOLT em B")
	check_eq((resumed.get_node("%Puzzle") as DistributionPuzzle).progress(), 0, "nova instância reinicia o puzzle (estado não persistido)")
	resumed.free()
	_end()
	return true


func test_w1_l4_mandatory_routes_are_reachable_with_single_jump_metrics() -> bool:
	_begin()
	var level: Node = await _spawn_level()
	if level == null:
		_end()
		return true
	var g: Node = level.get_node("Geometry")
	var tuning: BoltTuning = BoltTuning.new()
	check(MAX_MANDATORY_RISE <= tuning.jump_height, "degrau obrigatório cabe no salto simples (%.0f <= %.0f)" % [MAX_MANDATORY_RISE, tuning.jump_height])
	# [origem, destino] percorridos na rota obrigatória (ambos os caminhos até o hub).
	var hops: Array = [
		["StartFloor", "FloorL1"], ["FloorL1", "FloorHub"],  # caminho inferior
		["StartFloor", "StepU1"], ["StepU1", "UpperFloor"], ["UpperFloor", "UpperLedge"],  # caminho superior
		["UpperLedge", "ShortcutStep"], ["ShortcutStep", "FloorHub"],  # convergência
	]
	for hop: Array in hops:
		var from_node: Node = g.get_node(hop[0])
		var to_node: Node = g.get_node(hop[1])
		var rise: float = _top(from_node) - _top(to_node)
		check(_gap(from_node, to_node) <= MAX_MANDATORY_GAP, "%s -> %s: vão %.0f <= %.0f" % [hop[0], hop[1], _gap(from_node, to_node), MAX_MANDATORY_GAP])
		check(rise <= MAX_MANDATORY_RISE, "%s -> %s: subida %.0f <= %.0f" % [hop[0], hop[1], rise, MAX_MANDATORY_RISE])
	# Rota vertical opcional: degraus entre plataformas cabem no salto simples; o último vão exige domínio de movimento.
	var chain: Array = ["FloorHub", "VerticalStep1", "VerticalStep2", "VerticalStep3", "VerticalStep4"]
	for index in range(chain.size() - 1):
		var a: Node = g.get_node(chain[index])
		var b: Node = g.get_node(chain[index + 1])
		check(_top(a) - _top(b) <= MAX_MANDATORY_RISE and _gap(a, b) <= MAX_MANDATORY_GAP, "rota vertical %s -> %s em salto simples" % [chain[index], chain[index + 1]])
	var reward_gap: float = _gap(g.get_node("VerticalStep4"), g.get_node("RewardLedge"))
	check(reward_gap > MAX_MANDATORY_GAP and reward_gap <= 300.0, "vão até a recompensa (%.0f) exige pulo duplo/dash, mas é viável" % reward_gap)
	# Relés têm piso próprio (alcançáveis) e linha de tiro horizontal livre de mundo.
	var floors: Dictionary = {"RelayA": "FloorL1", "RelayB": "UpperFloor", "RelayC": "FloorHub"}
	var space: PhysicsDirectSpaceState2D = (level as Node2D).get_world_2d().direct_space_state
	for relay_name: String in floors:
		var relay: EnergyRelay = _relay(level, relay_name)
		var base: Node = g.get_node(floors[relay_name])
		check(relay.global_position.x > _left(base) + 60.0 and relay.global_position.x < _right(base), "%s está sobre %s" % [relay_name, floors[relay_name]])
		check_near(relay.global_position.y, _top(base) - 24.0, 1.0, "%s apoiado no topo do piso" % relay_name)
		var from_point: Vector2 = relay.global_position + Vector2(-90.0, -4.0)
		var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(from_point, relay.global_position + Vector2(-22.0, -4.0), 1)
		check(space.intersect_ray(query).is_empty(), "%s: linha de tiro de 90 px livre de geometria" % relay_name)
		check(from_point.x >= _left(base) - 1.0, "%s: ponto de tiro fica sobre o mesmo piso" % relay_name)
	level.free()
	_end()
	return true


func test_w1_l4_gate_cannot_be_bypassed_by_jumping() -> bool:
	_begin()
	var level: Node = await _spawn_level()
	if level == null:
		_end()
		return true
	var tuning: BoltTuning = BoltTuning.new()
	var reach: float = tuning.jump_height * (1.0 + pow(tuning.air_jump_multiplier, 2.0) * float(tuning.air_jumps))
	var gate: DistributionGate = level.get_node("%Gate") as DistributionGate
	var gate_top: float = gate.global_position.y - gate.get_barrier_height()
	# Nenhuma plataforma a menos de 450 px da barreira permite saltar acima do topo dela.
	for node: Node in level.get_node("Geometry").get_children():
		var block: PlatformBlock = node as PlatformBlock
		if block == null or block.name == "RightWall" or block.name == "LeftWall":
			continue
		var near: bool = absf(_left(block) - gate.global_position.x) < 450.0 or absf(_right(block) - gate.global_position.x) < 450.0
		if near:
			check(_top(block) - reach > gate_top, "%s (topo %.0f, alcance %.0f) não alcança o topo da barreira (%.0f)" % [block.name, _top(block), reach, gate_top])
	# Objetivo fica do lado oposto da barreira em relação ao spawn/relés.
	check((level.get_node("%Goal") as Node2D).global_position.x > gate.global_position.x, "objetivo atrás da barreira")
	check((level.get_node("%RelayC") as Node2D).global_position.x < gate.global_position.x, "último relé antes da barreira")
	level.free()
	_end()
	return true


func test_w1_l4_beat_trigger_fires_once_and_polygons_render() -> bool:
	_begin()
	var level: Node = await _spawn_level()
	if level == null:
		_end()
		return true
	var beats: Array = []
	level.narrative_beat_requested.connect(func(beat_id: StringName) -> void: beats.append(beat_id))
	var player: BoltPlayer = level.get_node("%Bolt") as BoltPlayer
	var trigger: NarrativeBeatTrigger = level.get_node("%BeatTrigger") as NarrativeBeatTrigger
	for _pass in range(2):
		player.global_position = trigger.global_position
		player.velocity = Vector2.ZERO
		await _ticks(4)
		player.global_position = trigger.global_position + Vector2(600.0, 0.0)
		await _ticks(3)
	check_eq(beats, [&"w1_l4_nexo_ancient_signal"], "beat anunciado uma única vez, sem conteúdo narrativo")
	for node: Node in level.find_children("*", "Polygon2D", true, false):
		var polygon: Polygon2D = node as Polygon2D
		check(not Geometry2D.triangulate_polygon(polygon.polygon).is_empty(), "%s triangula (é desenhado)" % polygon.get_path())
	level.free()
	_end()
	return true


func test_w1_l4_is_resumable_from_main_menu_continue() -> bool:
	_begin()
	check(CampaignProgress.begin_level("W1-L4"), "save isolado registra W1-L4 para retomada")
	var menu_scene: PackedScene = load("res://scenes/ui/main_menu.tscn") as PackedScene
	check(menu_scene != null, "menu principal carrega para teste de retomada W1-L4")
	if menu_scene == null:
		_end()
		return true
	var menu: Node = menu_scene.instantiate()
	tree.root.add_child(menu)
	await tree.process_frame
	var continue_button: Button = menu.get_node("%ContinueButton") as Button
	check(continue_button != null and not continue_button.disabled, "Continuar habilitado quando current_level_id é W1-L4")
	check_eq(str(menu.call("_resolve_continue_path")), LEVEL_SCENE, "Continuar resolve a PackedScene W1-L4")
	menu.free()
	await tree.process_frame
	_end()
	return true


func test_w1_l4_unlocks_in_phase_selection_after_w1_l3_completion() -> bool:
	_begin()
	check(CampaignProgress.start_new_campaign(), "campanha de teste inicia")
	check(CampaignProgress.mark_level_completed("W1-L1", "W1-L2"), "conclusão W1-L1 libera W1-L2")
	check(CampaignProgress.mark_level_completed("W1-L2", "W1-L3"), "conclusão W1-L2 libera W1-L3")
	check(CampaignProgress.mark_level_completed("W1-L3"), "conclusão W1-L3 é persistida")
	tree.root.set_meta("campaign_selection_world_id", "W1")
	var phase_scene: PackedScene = load("res://scenes/ui/phase_selection.tscn") as PackedScene
	check(phase_scene != null, "seleção de fases carrega")
	if phase_scene == null:
		tree.root.remove_meta("campaign_selection_world_id")
		_end()
		return true
	var screen: Node = phase_scene.instantiate()
	tree.root.add_child(screen)
	await tree.process_frame
	var grid: GridContainer = screen.find_child("PhaseGrid", true, false) as GridContainer
	check(grid != null and grid.get_child_count() == 6, "Cybercore apresenta seis cards")
	if grid != null and grid.get_child_count() == 6:
		var w1_l4: Button = grid.get_child(3) as Button
		check(w1_l4 != null and not w1_l4.disabled, "W1-L4 fica selecionável após concluir W1-L3")
		check(w1_l4 != null and w1_l4.text.contains("DISPONÍVEL"), "W1-L4 é exibida como disponível")
	screen.free()
	await tree.process_frame
	if tree.root.has_meta("campaign_selection_world_id"):
		tree.root.remove_meta("campaign_selection_world_id")
	_end()
	return true
