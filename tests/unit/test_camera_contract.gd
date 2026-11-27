extends BoltTest
## Contrato headless da Camera2D: rig built-in e limites aplicados por fase.


const PLAYER_SCENE: String = "res://scenes/player/bolt.tscn"
const W1_L1_SCRIPT: String = "res://scripts/campaign/cybercore_w1_l1.gd"
const W1_L2_SCRIPT: String = "res://scripts/campaign/cybercore_w1_l2.gd"
const W1_L3_SCRIPT: String = "res://scripts/campaign/cybercore_w1_l3.gd"


func test_player_camera_uses_builtin_smoothing_and_drag_margins() -> bool:
	var packed: PackedScene = load(PLAYER_SCENE) as PackedScene
	check(packed != null, "cena de BOLT carrega")
	if packed == null:
		return true
	var player: Node = packed.instantiate()
	var camera: Camera2D = player.get_node("Camera") as Camera2D
	check(camera != null, "Camera2D presente no player")
	if camera != null:
		check(camera.position_smoothing_enabled, "suavização de posição habilitada")
		check_near(camera.position_smoothing_speed, 10.0, 0.01, "velocidade de suavização configurada")
		check(camera.drag_horizontal_enabled and camera.drag_vertical_enabled, "deadzone horizontal e vertical habilitadas")
		check_near(camera.drag_left_margin, 0.12, 0.001, "margem esquerda")
		check_near(camera.drag_right_margin, 0.12, 0.001, "margem direita")
		check_near(camera.drag_top_margin, 0.2, 0.001, "margem superior")
		check_near(camera.drag_bottom_margin, 0.25, 0.001, "margem inferior")
		check(camera.limit_smoothed, "limites suavizados")
		check_eq(camera.process_callback, Camera2D.CAMERA2D_PROCESS_PHYSICS, "camera atualiza após o movimento de física")
	player.free()
	return true


func _check_level_limits(script_path: String, expected_right: int, level_name: String) -> bool:
	var level_script: GDScript = load(script_path) as GDScript
	check(level_script != null, "%s script carrega" % level_name)
	if level_script == null:
		return true
	var level = level_script.new()
	var camera: Camera2D = Camera2D.new()
	level.configure_camera(camera)
	check_eq(camera.limit_left, 0, "%s limite esquerdo" % level_name)
	check_eq(camera.limit_top, -360, "%s limite superior" % level_name)
	check_eq(camera.limit_right, expected_right, "%s limite direito" % level_name)
	check_eq(camera.limit_bottom, 260, "%s limite inferior" % level_name)
	check(camera.limit_smoothed, "%s suaviza limites" % level_name)
	level.free()
	camera.free()
	return true


func test_w1_l1_camera_limits_match_level_bounds() -> bool:
	return _check_level_limits(W1_L1_SCRIPT, 2200, "W1-L1")


func test_w1_l2_camera_limits_match_level_bounds() -> bool:
	return _check_level_limits(W1_L2_SCRIPT, 1900, "W1-L2")


func test_w1_l3_camera_limits_match_level_bounds() -> bool:
	return _check_level_limits(W1_L3_SCRIPT, 2600, "W1-L3")
