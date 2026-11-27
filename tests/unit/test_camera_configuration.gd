extends BoltTest
## Contrato estrutural da Camera2D do protagonista.
## Valida configuração serializada e ownership; não substitui playtest de enquadramento.

const BOLT_SCENE: String = "res://scenes/player/bolt.tscn"

var _bolt: BoltPlayer


func _setup() -> void:
	_bolt = (load(BOLT_SCENE) as PackedScene).instantiate() as BoltPlayer
	tree.root.add_child(_bolt)
	await tree.process_frame


func _teardown() -> void:
	_bolt.queue_free()
	await tree.process_frame


func test_camera_is_owned_by_bolt_and_smoothing_is_configured() -> bool:
	await _setup()
	var camera: Camera2D = _bolt.get_camera()
	check(camera != null, "BOLT expõe sua Camera2D pelo contrato público")
	if camera == null:
		await _teardown()
		return false
	check(camera.get_parent() == _bolt, "câmera pertence ao BOLT")
	check(camera.enabled, "câmera está habilitada")
	check(camera.position_smoothing_enabled, "suavização de posição está habilitada")
	check(camera.position_smoothing_speed > 0.0, "velocidade de suavização é positiva")
	check(camera.limit_smoothed, "limites usam suavização")
	await _teardown()
	return true


func test_camera_drag_margins_are_valid_and_axes_are_enabled() -> bool:
	await _setup()
	var camera: Camera2D = _bolt.get_camera()
	check(camera.drag_horizontal_enabled, "dead zone horizontal habilitada")
	check(camera.drag_vertical_enabled, "dead zone vertical habilitada")
	check(camera.drag_left_margin >= 0.0, "margem esquerda não negativa")
	check(camera.drag_right_margin >= 0.0, "margem direita não negativa")
	check(camera.drag_top_margin >= 0.0, "margem superior não negativa")
	check(camera.drag_bottom_margin >= 0.0, "margem inferior não negativa")
	check(camera.drag_left_margin + camera.drag_right_margin < 1.0, "margens horizontais não colapsam a área útil")
	check(camera.drag_top_margin + camera.drag_bottom_margin < 1.0, "margens verticais não colapsam a área útil")
	await _teardown()
	return true


func _verify_level_camera_limits(script_path: String, expected: Rect2i) -> bool:
	var level_script: GDScript = load(script_path) as GDScript
	check(level_script != null, "script de fase carrega: %s" % script_path)
	if level_script == null:
		return false
	var level: Node2D = level_script.new() as Node2D
	var camera: Camera2D = Camera2D.new()
	level.call("configure_camera", camera)
	check_eq(camera.limit_left, expected.position.x, "limite esquerdo configurado")
	check_eq(camera.limit_top, expected.position.y, "limite superior configurado")
	check_eq(camera.limit_right, expected.end.x, "limite direito configurado")
	check_eq(camera.limit_bottom, expected.end.y, "limite inferior configurado")
	check(camera.limit_smoothed, "limites da fase usam suavização")
	camera.free()
	level.free()
	return true


func test_w1_l1_camera_limits_are_applied_by_level_contract() -> bool:
	_verify_level_camera_limits(
		"res://scripts/campaign/cybercore_w1_l1.gd",
		Rect2i(0, -360, 2200, 620)
	)
	return true


func test_w1_l2_camera_limits_are_applied_by_level_contract() -> bool:
	_verify_level_camera_limits(
		"res://scripts/campaign/cybercore_w1_l2.gd",
		Rect2i(0, -360, 1900, 620)
	)
	return true
