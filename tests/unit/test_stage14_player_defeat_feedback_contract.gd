extends BoltTest
## Integra o esgotamento da vida de BOLT ao feedback terminal da fase real W1-L1.

const LEVEL_SCENE: String = "res://scenes/campaign/cybercore_w1_l1.tscn"
const TEST_SAVE_PATH: String = "user://bolt_stage14_player_defeat_test.json"


func _tap_buffered(action: StringName) -> void:
	var down: InputEventAction = InputEventAction.new()
	down.action = action
	down.pressed = true
	down.strength = 1.0
	tree.root.push_input(down, false)
	var up: InputEventAction = InputEventAction.new()
	up.action = action
	up.pressed = false
	up.strength = 0.0
	tree.root.push_input(up, false)


func test_w1_l1_player_depletion_enters_single_terminal_feedback_state() -> bool:
	Actions.release_all_game_actions()
	SaveSystem.storage_path_override = TEST_SAVE_PATH
	SaveSystem.delete_save()

	var packed: PackedScene = load(LEVEL_SCENE) as PackedScene
	check(packed != null, "cena real W1-L1 carrega para o contrato de derrota")
	if packed == null:
		SaveSystem.storage_path_override = ""
		return true

	var level: Node = packed.instantiate()
	tree.root.add_child(level)
	await tree.process_frame

	var player: BoltPlayer = level.get_node("Bolt") as BoltPlayer
	var hud: Hud = level.get_node("Hud") as Hud
	var health: BoltHealth = player.get_node("%Health") as BoltHealth
	var buffer: ActionBuffer = player.get_node("%ActionBuffer") as ActionBuffer
	var result_overlay: Control = hud.get_node("%ResultOverlay") as Control
	var result_title: Label = hud.get_node("%ResultTitle") as Label
	var health_label: Label = hud.get_node("%HealthLabel") as Label
	var touch_controls: Control = hud.get_node("%TouchControls") as Control
	var defeat_events: Array[int] = [0]
	player.defeated.connect(func() -> void: defeat_events[0] += 1)

	check_eq(health.current_health, 3, "BOLT inicia com vida íntegra na fase")
	check(not result_overlay.visible, "overlay terminal inicia oculto")
	_tap_buffered(Actions.ATTACK)
	check(buffer.has_pending(Actions.ATTACK), "toque curto de ataque está pendente antes da derrota")

	check(player.take_damage(health.max_health, 1.0), "dano letal válido é aceito pelo jogador")
	check_eq(health.current_health, 0, "vida do jogador chega a zero")
	check_eq(defeat_events[0], 1, "transição terminal emite defeated exatamente uma vez")
	check(not player.is_physics_processing(), "jogador derrotado interrompe processamento físico")
	check(not buffer.has_pending(Actions.ATTACK), "derrota limpa ação de ataque pendente")
	check(result_overlay.visible, "W1-L1 apresenta overlay terminal após defeated")
	check_eq(result_title.text, "BOLT foi derrotado", "overlay comunica corretamente a derrota")
	check_eq(health_label.text, "VIDA  0 / 3", "HUD reflete a vida esgotada")
	check(not touch_controls.visible, "controles touchscreen são ocultados no estado terminal")
	check(tree.paused, "fase é pausada enquanto o resultado terminal está visível")
	check_eq(hud.get_node("%AgainButton").text, "JOGAR DE NOVO", "derrota oferece reinício da fase atual")

	check(not player.take_damage(1, 1.0), "dano posterior ao esgotamento é rejeitado")
	check_eq(defeat_events[0], 1, "dano posterior não duplica o evento defeated")
	check_eq(result_title.text, "BOLT foi derrotado", "feedback terminal permanece estável")

	# O runner compartilha SceneTree/autoloads entre testes; desfazer a pausa e o save isolado.
	tree.paused = false
	Actions.release_all_game_actions()
	level.free()
	SaveSystem.delete_save()
	SaveSystem.storage_path_override = ""
	await tree.process_frame
	return true
