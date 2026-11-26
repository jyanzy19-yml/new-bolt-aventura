extends BoltTest
## Runtime smoke/regression tests for the approved campaign entry sequence.

const OPENING_PATH: String = "res://scenes/campaign/opening_cinematic.tscn"
const TUTORIAL_PATH: String = "res://scenes/tutorial/tutorial.tscn"
const CYBERCORE_W1_L1_PATH: String = "res://scenes/campaign/cybercore_w1_l1.tscn"


func test_campaign_entry_scenes_load_and_expose_required_nodes() -> bool:
	var opening: PackedScene = load(OPENING_PATH) as PackedScene
	var tutorial: PackedScene = load(TUTORIAL_PATH) as PackedScene
	var cybercore: PackedScene = load(CYBERCORE_W1_L1_PATH) as PackedScene
	check(opening != null, "cena da abertura carrega")
	check(tutorial != null, "cena do tutorial carrega")
	check(cybercore != null, "cena W1-L1 de Cybercore carrega")
	if opening == null or tutorial == null or cybercore == null:
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
	check(speech.text.contains("ROBÔ MENSAGEIRO"), "mensageiro orienta por balão de fala")
	tutorial_instance.call("_on_start_or_continue")
	check(player.is_physics_processing(), "BOLT é liberado ao iniciar o tutorial")
	player.global_position.x = 301.0
	await tree.process_frame
	check(speech.text.contains("salte"), "tutorial solicita salto após deslocamento")
	tutorial_instance.call("_on_player_state_changed", BoltPlayer.State.RISING)
	check(speech.text.contains("DASH"), "tutorial solicita Dash após salto")
	tutorial_instance.call("_on_player_state_changed", BoltPlayer.State.DASHING)
	check(start_button.visible and start_button.text == "ENTRAR EM CYBERCORE", "tutorial libera entrada em Cybercore após os comandos")
	tutorial_instance.free()

	var cybercore_instance: Node = cybercore.instantiate()
	tree.root.add_child(cybercore_instance)
	await tree.physics_frame
	check(cybercore_instance.get_node_or_null("Bolt") is BoltPlayer, "W1-L1 instancia BOLT")
	check(cybercore_instance.get_node_or_null("Checkpoint") is BoltCheckpoint, "W1-L1 contém checkpoint")
	check(cybercore_instance.get_node_or_null("Goal") is Area2D, "W1-L1 contém objetivo de trecho")
	check(cybercore_instance.get_node_or_null("Hud") is Hud, "W1-L1 mantém HUD e controles touch")
	cybercore_instance.free()
	return true
