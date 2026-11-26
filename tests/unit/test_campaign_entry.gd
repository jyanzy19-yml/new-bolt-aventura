extends BoltTest
## Smoke/regression tests for the approved campaign entry sequence.

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
	check(opening_instance.get_node_or_null("Center/Panel/Column/PageLabel") is Label, "abertura possui painel narrativo")
	check(opening_instance.get_node_or_null("Center/Panel/Column/Buttons/NextButton") is Button, "abertura possui avanço")
	opening_instance.free()

	var tutorial_instance: Node = tutorial.instantiate()
	check(tutorial_instance.get_node_or_null("Bolt") is BoltPlayer, "tutorial instancia BOLT")
	check(tutorial_instance.get_node_or_null("Hud") is Hud, "tutorial instancia HUD e controles touch")
	check(tutorial_instance.get_node_or_null("Messenger") is Node2D, "tutorial contém robô mensageiro provisório")
	check(tutorial_instance.get_node_or_null("TutorialUI/Panel/Column/SpeechLabel") is Label, "tutorial possui balão de orientação")
	check(tutorial_instance.get_node_or_null("TutorialUI/Panel/Column/StartButton") is Button, "tutorial possui início explícito")
	tutorial_instance.free()

	var cybercore_instance: Node = cybercore.instantiate()
	check(cybercore_instance.get_node_or_null("Bolt") is BoltPlayer, "W1-L1 instancia BOLT")
	check(cybercore_instance.get_node_or_null("Checkpoint") is BoltCheckpoint, "W1-L1 contém checkpoint")
	check(cybercore_instance.get_node_or_null("Goal") is Area2D, "W1-L1 contém objetivo de trecho")
	check(cybercore_instance.get_node_or_null("Hud") is Hud, "W1-L1 mantém HUD e controles touch")
	cybercore_instance.free()
	return true
