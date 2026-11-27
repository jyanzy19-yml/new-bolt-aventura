extends BoltTest
## Boot must fail closed when the required Input Map contract is incomplete.

const BOOT_SCENE: String = "res://scenes/boot/boot.tscn"


func test_boot_reports_missing_required_action_without_starting_transition() -> bool:
	var action: StringName = Actions.JUMP
	check(InputMap.has_action(action), "fixture starts with required Jump action")
	if not InputMap.has_action(action):
		return true
	check(not SceneFlow.is_transitioning(), "SceneFlow is idle before isolated Boot test")
	if SceneFlow.is_transitioning():
		return true

	var original_events: Array[InputEvent] = InputMap.action_get_events(action)
	var original_deadzone: float = InputMap.action_get_deadzone(action)
	InputMap.erase_action(action)

	var packed: PackedScene = load(BOOT_SCENE) as PackedScene
	check(packed != null, "Boot scene can be loaded")
	if packed == null:
		InputMap.add_action(action, original_deadzone)
		for event: InputEvent in original_events:
			InputMap.action_add_event(action, event)
		return true

	var boot: Node = packed.instantiate()
	check(boot != null, "Boot scene can be instantiated")
	if boot == null:
		InputMap.add_action(action, original_deadzone)
		for event: InputEvent in original_events:
			InputMap.action_add_event(action, event)
		return true

	tree.root.add_child(boot)
	await tree.process_frame
	var status: Label = boot.get_node_or_null("Center/Column/StatusLabel") as Label
	check(status != null, "Boot exposes its startup status label")
	if status != null:
		check(status.text.contains("Input Map incompleto"), "Boot explains the missing Input Map contract")
	check(not SceneFlow.is_transitioning(), "Boot does not request the main menu with an invalid Input Map")

	boot.free()
	InputMap.add_action(action, original_deadzone)
	for event: InputEvent in original_events:
		InputMap.action_add_event(action, event)
	check(InputMap.has_action(action), "original Jump action is restored after the test")
	return true
