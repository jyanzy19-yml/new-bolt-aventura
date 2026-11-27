extends BoltTest
## Runtime smoke/regression tests for the approved campaign entry sequence.

const OPENING_PATH: String = "res://scenes/campaign/opening_cinematic.tscn"
const TUTORIAL_PATH: String = "res://scenes/tutorial/tutorial.tscn"
const CYBERCORE_W1_L1_PATH: String = "res://scenes/campaign/cybercore_w1_l1.tscn"
const CYBERCORE_W1_L2_PATH: String = "res://scenes/campaign/cybercore_w1_l2.tscn"


func _send_action(action: StringName, pressed: bool) -> void:
	var event: InputEventAction = InputEventAction.new()
	event.action = action
	event.pressed = pressed
	event.strength = 1.0 if pressed else 0.0
	Input.parse_input_event(event)


func test_campaign_entry_scenes_load_and_expose_required_nodes() -> bool:
	var opening: PackedScene = load(OPENING_PATH) as PackedScene
	var tutorial: PackedScene = load(TUTORIAL_PATH) as PackedScene
	var cybercore: PackedScene = load(CYBERCORE_W1_L1_PATH) as PackedScene
	var cybercore_l2: PackedScene = load(CYBERCORE_W1_L2_PATH) as PackedScene
	check(opening != null, "cena da abertura carrega")
	check(tutorial != null, "cena do tutorial carrega")
	check(cybercore != null, "cena W1-L1 de Cybercore carrega")
	check(cybercore_l2 != null, "cena W1-L2 Rede Interrompida carrega")
	if opening == null or tutorial == null or cybercore == null or cybercore_l2 == null:
		return true

	var opening_instance: Node = opening.instantiate()
	tree.root.add_child(opening_instance)
	await tree.process_frame
	var page_label: Label = opening_instance.get_node("Center/Panel/Column/PageLabel") as Label
	var next_button: Button = opening_instance.get_node("Center/Panel/Column/Buttons/NextButton") as Button
	check(page_label != null and page_label.text.contains("Grande Colapso"), "abertura apresenta o evento canônico")
	for _page in range(3):
		opening_instance.call("_advance")
	check(next_button.text == "IR AO TUTORIAL", "abertura conduz ao tutorial após quatro páginas")
	opening_instance.free()

	var tutorial_instance: Node = tutorial.instantiate()
	tree.root.add_child(tutorial_instance)
	await tree.process_frame
	var player: BoltPlayer = tutorial_instance.get_node("Bolt") as BoltPlayer
	var speech: Label = tutorial_instance.get_node("TutorialUI/Panel/Column/SpeechLabel") as Label
	var start_button: Button = tutorial_instance.get_node("TutorialUI/Panel/Column/StartButton") as Button
	check(player != null and not player.is_physics_processing(), "BOLT aguarda início explícito do tutorial")
	check(tutorial_instance.get_node_or_null("Messenger") is Node2D, "tutorial contém robô mensageiro provisório")
	var attack_button: TouchButton = tutorial_instance.get_node("Hud/Safe/Layout/TouchControls/Attack") as TouchButton
	check(attack_button != null and attack_button.action == Actions.ATTACK, "HUD touch expõe o botão TIRO")
	check(speech.text.contains("ROBÔ MENSAGEIRO"), "mensageiro orienta por balão de fala")
	tutorial_instance.call("_on_start_or_continue")
	check(player.is_physics_processing(), "BOLT é liberado ao iniciar o tutorial")
	player.global_position.x = 301.0
	await tree.process_frame
	check(speech.text.contains("salte"), "tutorial solicita salto após deslocamento")
	tutorial_instance.call("_on_player_state_changed", BoltPlayer.State.RISING)
	check(speech.text.contains("DASH"), "tutorial solicita Dash após salto")
	tutorial_instance.call("_on_player_state_changed", BoltPlayer.State.DASHING)
	check(speech.text.contains("TIRO"), "tutorial apresenta o ataque básico após o Dash")
	var target: BoltTrainingTarget = tutorial_instance.get_node("TrainingTarget") as BoltTrainingTarget
	_send_action(Actions.ATTACK, true)
	_send_action(Actions.ATTACK, false)
	for _tick in range(90):
		await tree.physics_frame
		if target.is_queued_for_deletion():
			break
	check(target.is_queued_for_deletion(), "ataque da Pistola Crono atinge o alvo do tutorial")
	check(start_button.visible and start_button.text == "ENTRAR EM CYBERCORE", "tutorial libera entrada em Cybercore após o ataque")
	tutorial_instance.free()

	SaveSystem.storage_path_override = "user://bolt_w1_l1_integration_test.json"
	SaveSystem.delete_save()
	var cybercore_instance: Node = cybercore.instantiate()
	tree.root.add_child(cybercore_instance)
	await tree.physics_frame
	check(cybercore_instance.get_node_or_null("Bolt") is BoltPlayer, "W1-L1 instancia BOLT")
	check(cybercore_instance.get_node_or_null("Checkpoint") is BoltCheckpoint, "W1-L1 contém checkpoint")
	check(cybercore_instance.get_node_or_null("HealthPickup") is BoltHealthPickup, "W1-L1 contém recuperação")
	check(cybercore_instance.get_node_or_null("Goal") is Area2D, "W1-L1 contém objetivo de trecho")
	check(cybercore_instance.get_node_or_null("Hud") is Hud, "W1-L1 mantém HUD e controles touch")
	check_eq(CampaignProgress.load_state().get("current_level_id"), "W1-L1", "entrada na W1-L1 registra o ponto de retomada")
	var level_player: BoltPlayer = cybercore_instance.get_node("Bolt") as BoltPlayer
	var checkpoint: BoltCheckpoint = cybercore_instance.get_node("Checkpoint") as BoltCheckpoint
	var pickup: BoltHealthPickup = cybercore_instance.get_node("HealthPickup") as BoltHealthPickup
	var enemy: CybercorePatrolEnemy = cybercore_instance.get_node("PatrolEnemy") as CybercorePatrolEnemy
	var goal: Area2D = cybercore_instance.get_node("Goal") as Area2D
	var hud: Hud = cybercore_instance.get_node("Hud") as Hud
	var health: BoltHealth = level_player.get_node("%Health") as BoltHealth
	var end_floor: PlatformBlock = cybercore_instance.get_node("Geometry/EndFloor") as PlatformBlock
	check_eq(enemy.global_position.y, -19.0, "inimigo começa apoiado no piso intermediário")
	check(enemy.global_position.x >= 800.0 and enemy.global_position.x <= 900.0, "inimigo patrulha dentro dos limites seguros do piso")
	check_eq(enemy.patrol_distance, 50.0, "patrulha fica limitada ao trecho seguro da plataforma")
	var player_shape: RectangleShape2D = (level_player.get_node("CollisionShape2D") as CollisionShape2D).shape as RectangleShape2D
	var enemy_contact_shape: RectangleShape2D = (enemy.get_node("ContactArea/CollisionShape2D") as CollisionShape2D).shape as RectangleShape2D
	var enemy_right_limit: float = enemy.global_position.x + enemy.patrol_distance
	var respawn_clearance: float = player_shape.size.x * 0.5 + enemy_contact_shape.size.x * 0.5
	check(checkpoint.global_position.x - enemy_right_limit > respawn_clearance, "respawn do checkpoint fica fora do alcance horizontal do contato inimigo")
	check(goal.global_position.x >= end_floor.global_position.x and goal.global_position.x <= end_floor.global_position.x + end_floor.size.x, "objetivo está contido no piso final")
	check(level_player.global_position.distance_to(Vector2(96.0, -24.0)) < 2.0, "BOLT inicia no ponto de entrada da fase")

	# Valida o primeiro encontro com a Pistola Crono usando o ActionBuffer e o projétil reais.
	var enemy_health: BoltHealth = enemy.get_node("%Health") as BoltHealth
	var enemy_hit: Array[bool] = [false]
	enemy.hit_received.connect(func(_remaining_health: int) -> void:
		enemy_hit[0] = true
	)
	level_player.global_position = Vector2(800.0, -24.0)
	level_player.velocity = Vector2.ZERO
	level_player.facing = 1
	_send_action(Actions.ATTACK, true)
	_send_action(Actions.ATTACK, false)
	for _tick in range(12):
		await tree.physics_frame
		if enemy_hit[0]:
			break
	check(enemy_hit[0], "Pistola Crono atinge o inimigo real da W1-L1")
	check_eq(enemy_health.current_health, 2, "projétil da campanha reduz a vida do inimigo em um ponto")

	# Percorre os gatilhos físicos reais em vez de chamar os handlers diretamente.
	var checkpoint_activated: Array[bool] = [false]
	checkpoint.activated.connect(func(_id: StringName, _position: Vector2) -> void:
		checkpoint_activated[0] = true
	)
	level_player.global_position = checkpoint.global_position
	level_player.velocity = Vector2.ZERO
	for _tick in range(3):
		await tree.physics_frame
	check(checkpoint_activated[0], "entrada física ativa o checkpoint")
	check(hud.get_node("%ProgressNotification").visible, "HUD comunica a ativação do checkpoint")
	check_eq(hud.get_node("%ProgressNotification").text, "CHECKPOINT ATIVADO", "notificação identifica o checkpoint")
	check_eq(CampaignProgress.get_checkpoint_id("W1-L1"), String(checkpoint.checkpoint_id), "checkpoint é persistido por ID estável")

	# Uma queda real na kill zone deve retornar ao ponto ativado e restaurar a vida.
	check(level_player.take_damage(1, 1.0), "BOLT recebe dano antes da queda")
	level_player.global_position = Vector2(920.0, 650.0)
	level_player.velocity = Vector2.ZERO
	for _tick in range(3):
		await tree.physics_frame
	check(level_player.global_position.distance_to(checkpoint.get_respawn_position()) < 2.0, "queda retorna ao checkpoint ativado")
	check_eq(health.current_health, health.max_health, "respawn da fase restaura a vida")

	# O coletável real deve restaurar vida e emitir feedback no HUD.
	var pickup_collected: Array[bool] = [false]
	pickup.collected.connect(func(_amount: int) -> void:
		pickup_collected[0] = true
	)
	check(level_player.take_damage(1, 1.0), "BOLT perde vida antes de recolher energia")
	level_player.global_position = pickup.global_position
	level_player.velocity = Vector2.ZERO
	for _tick in range(3):
		await tree.physics_frame
	check_eq(health.current_health, health.max_health, "coletável restaura a vida do jogador")
	check(pickup_collected[0], "coletável emite collected após cura válida")
	check(cybercore_instance.get_node_or_null("HealthPickup") == null, "coletável é removido após cura válida")
	check_eq(hud.get_node("%ProgressNotification").text, "RECUPERAÇÃO +1", "HUD comunica a recuperação")

	# A área de objetivo encerra a sequência apenas quando BOLT alcança a saída.
	level_player.global_position = goal.global_position
	level_player.velocity = Vector2.ZERO
	for _tick in range(3):
		await tree.physics_frame
		if hud.get_node("%ResultOverlay").visible:
			break
	check(hud.get_node("%ResultOverlay").visible, "alcançar fisicamente a saída conclui o trecho")
	check_eq(hud.get_node("%ResultTitle").text, "Cybercore — trecho inicial concluído", "tela de resultado identifica a conclusão")
	check(CampaignProgress.is_level_completed("W1-L1"), "conclusão da W1-L1 é persistida")
	check_eq(CampaignProgress.load_state().get("current_level_id"), "W1-L2", "conclusão da W1-L1 avança o destino de retomada para W1-L2")
	check_eq(hud.get_node("%AgainButton").text, "PRÓXIMA FASE", "resultado oferece entrada direta na próxima fase")
	check_eq(CampaignProgress.get_checkpoint_id("W1-L1"), "", "checkpoint ativo é limpo após conclusão")
	tree.paused = false
	cybercore_instance.free()
	SaveSystem.delete_save()
	SaveSystem.storage_path_override = ""
	return true


func test_w1_l1_restores_persisted_checkpoint_on_scene_reentry() -> bool:
	SaveSystem.storage_path_override = "user://bolt_w1_l1_reentry_test.json"
	SaveSystem.delete_save()
	var cybercore: PackedScene = load(CYBERCORE_W1_L1_PATH) as PackedScene
	check(cybercore != null, "W1-L1 carrega para teste de persistência do checkpoint")
	if cybercore == null:
		SaveSystem.storage_path_override = ""
		return true

	var first_level: Node = cybercore.instantiate()
	tree.root.add_child(first_level)
	await tree.physics_frame
	var first_player: BoltPlayer = first_level.get_node("Bolt") as BoltPlayer
	var first_checkpoint: BoltCheckpoint = first_level.get_node("Checkpoint") as BoltCheckpoint
	first_player.global_position = first_checkpoint.global_position
	first_player.velocity = Vector2.ZERO
	for _tick in range(3):
		await tree.physics_frame
	check(first_checkpoint.is_activated(), "entrada física ativa o checkpoint na primeira instância")
	check_eq(CampaignProgress.get_checkpoint_id("W1-L1"), String(first_checkpoint.checkpoint_id), "ID do checkpoint fica salvo")
	first_level.free()

	var second_level: Node = cybercore.instantiate()
	tree.root.add_child(second_level)
	await tree.physics_frame
	var second_player: BoltPlayer = second_level.get_node("Bolt") as BoltPlayer
	var second_checkpoint: BoltCheckpoint = second_level.get_node("Checkpoint") as BoltCheckpoint
	check(second_checkpoint.is_activated(), "checkpoint salvo restaura o indicador na reentrada")
	check(second_player.global_position.distance_to(second_checkpoint.get_respawn_position()) < 2.0, "BOLT reaparece no checkpoint persistido")
	second_level.free()
	SaveSystem.delete_save()
	SaveSystem.storage_path_override = ""
	return true


func test_campaign_defeat_exposes_retry_for_w1_l1() -> bool:
	SaveSystem.storage_path_override = "user://bolt_w1_l1_defeat_test.json"
	SaveSystem.delete_save()
	var cybercore: PackedScene = load(CYBERCORE_W1_L1_PATH) as PackedScene
	check(cybercore != null, "W1-L1 carrega para validar derrota e reinício")
	if cybercore == null:
		SaveSystem.storage_path_override = ""
		return true
	var level: Node = cybercore.instantiate()
	tree.root.add_child(level)
	await tree.physics_frame
	var player: BoltPlayer = level.get_node("Bolt") as BoltPlayer
	var hud: Hud = level.get_node("Hud") as Hud
	check(player.take_damage(3, 1.0), "dano letal encerra a vida de BOLT")
	check(hud.get_node("%ResultOverlay").visible, "derrota abre o overlay de resultado")
	check_eq(hud.get_node("%ResultTitle").text, "BOLT foi derrotado", "resultado identifica a derrota")
	var again_button: Button = hud.get_node("%AgainButton") as Button
	check(again_button.pressed.is_connected(Callable(hud, "_restart")), "JOGAR DE NOVO está conectado ao fluxo de reinício")
	check_eq(hud.get("_restart_path"), CYBERCORE_W1_L1_PATH, "reinício aponta para a W1-L1 atual")
	tree.paused = false
	level.free()
	SaveSystem.delete_save()
	SaveSystem.storage_path_override = ""
	return true


func test_main_menu_gates_continue_and_keeps_new_game_available_on_bad_save() -> bool:
	const TEST_SAVE_PATH: String = "user://bolt_main_menu_flow_test.json"
	SaveSystem.storage_path_override = TEST_SAVE_PATH
	SaveSystem.delete_save()
	var menu_scene: PackedScene = load("res://scenes/ui/main_menu.tscn") as PackedScene
	check(menu_scene != null, "menu principal carrega")
	if menu_scene == null:
		SaveSystem.storage_path_override = ""
		return true

	var menu: Node = menu_scene.instantiate()
	tree.root.add_child(menu)
	await tree.process_frame
	var new_game: Button = menu.get_node("Center/Column/PlayButton") as Button
	var continue_button: Button = menu.get_node("Center/Column/ContinueButton") as Button
	var status: Label = menu.get_node("Center/Column/ProgressStatusLabel") as Label
	check(new_game != null and not new_game.disabled, "Nova Jornada permanece disponível sem save")
	check(continue_button != null and continue_button.disabled, "Continuar fica indisponível sem progresso")
	check(continue_button.pressed.is_connected(Callable(menu, "_on_continue_pressed")), "Continuar está ligado ao callback de retomada")
	check_eq(menu.call("_resolve_continue_path"), "", "sem progresso não há destino de retomada")

	check(CampaignProgress.begin_level("W1-L1"), "fixture registra uma fase implementada")
	menu.call("_refresh_continue_state")
	check(not continue_button.disabled, "Continuar é habilitado para W1-L1 existente")
	check_eq(menu.call("_resolve_continue_path"), "res://scenes/campaign/cybercore_w1_l1.tscn", "retomada aponta diretamente para W1-L1, sem repetir abertura/tutorial")

	check(CampaignProgress.begin_level("W1-L2"), "fixture registra W1-L2 como fase atual")
	menu.call("_refresh_continue_state")
	check(not continue_button.disabled, "Continuar é habilitado para W1-L2 implementada")
	check_eq(menu.call("_resolve_continue_path"), CYBERCORE_W1_L2_PATH, "retomada aponta diretamente para W1-L2")
	check(status.text.contains("Rede Interrompida"), "menu identifica a fase atual pelo nome")

	check(CampaignProgress.begin_level("W1-L3"), "fixture registra W1-L3 como fase atual")
	menu.call("_refresh_continue_state")
	check_eq(menu.call("_resolve_continue_path"), "res://scenes/campaign/cybercore_w1_l3.tscn", "retomada aponta diretamente para W1-L3")
	check(status.text.contains("Setor de Montagem"), "menu identifica W1-L3 pelo nome")
	menu.free()

	SaveSystem.delete_save()
	var corrupt_file: FileAccess = FileAccess.open(TEST_SAVE_PATH, FileAccess.WRITE)
	check(corrupt_file != null, "cria fixture de save corrompido")
	if corrupt_file != null:
		corrupt_file.store_string("{invalid-json")
		corrupt_file.close()
	var corrupt_menu: Node = menu_scene.instantiate()
	tree.root.add_child(corrupt_menu)
	await tree.process_frame
	var corrupt_new_game: Button = corrupt_menu.get_node("Center/Column/PlayButton") as Button
	var corrupt_continue: Button = corrupt_menu.get_node("Center/Column/ContinueButton") as Button
	var corrupt_status: Label = corrupt_menu.get_node("Center/Column/ProgressStatusLabel") as Label
	check(not corrupt_new_game.disabled, "save corrompido não bloqueia Nova Jornada")
	check(corrupt_continue.disabled, "save corrompido não oferece retomada inválida")
	check(corrupt_status.text.contains("SAVE INDISPONÍVEL"), "menu informa indisponibilidade do save")
	corrupt_menu.free()
	SaveSystem.delete_save()
	SaveSystem.storage_path_override = ""
	return true
