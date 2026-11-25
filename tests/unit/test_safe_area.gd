extends BoltTest
## Lógica pura de áreas seguras. Não prova comportamento real de recortes em aparelhos Android.


func test_cutout_insets_are_scaled_to_viewport() -> bool:
	# Tela 2400x1080 com recorte de 84 px à esquerda e à direita; viewport expandido 1200x540 (escala 0.5).
	var insets: Vector4 = SafeAreaMargin.compute_insets(
			Vector2i(2400, 1080), Rect2i(84, 0, 2232, 1080), Vector2i(2400, 1080), Vector2(1200, 540))
	check_near(insets.x, 42.0, 0.001, "margem esquerda")
	check_near(insets.y, 0.0, 0.001, "margem do topo")
	check_near(insets.z, 42.0, 0.001, "margem direita")
	check_near(insets.w, 0.0, 0.001, "margem da base")
	return true


func test_full_screen_safe_area_gives_zero_insets() -> bool:
	var insets: Vector4 = SafeAreaMargin.compute_insets(
			Vector2i(1920, 1080), Rect2i(0, 0, 1920, 1080), Vector2i(1920, 1080), Vector2(960, 540))
	check_eq(insets, Vector4.ZERO, "sem recorte, sem margem")
	return true


func test_invalid_inputs_are_safe() -> bool:
	check_eq(SafeAreaMargin.compute_insets(Vector2i.ZERO, Rect2i(), Vector2i.ZERO, Vector2(960, 540)),
			Vector4.ZERO, "entradas zeradas")
	check_eq(SafeAreaMargin.compute_insets(Vector2i(1920, 1080), Rect2i(), Vector2i(1920, 1080), Vector2(960, 540)),
			Vector4.ZERO, "área segura vazia")
	return true
