class_name SafeAreaMargin
extends MarginContainer
## Container que afasta seu conteúdo de recortes de tela e regiões não seguras (ADR-0003,
## docs/technical/02-touch-and-display.md §3–4). Controles essenciais devem ficar dentro dele.
##
## Em desktop (desenvolvimento) as margens são zero; a conversão só é aplicada em plataforma
## móvel, onde a janela ocupa a tela inteira. NÃO validado em aparelho real.


## Converte a área segura (pixels de tela) em margens no espaço do viewport.
## Retorna Vector4(esquerda, topo, direita, base). Entradas inválidas resultam em zero.
static func compute_insets(screen_size: Vector2i, safe_rect: Rect2i, window_size: Vector2i,
		viewport_size: Vector2) -> Vector4:
	if screen_size.x <= 0 or screen_size.y <= 0 or window_size.x <= 0 or window_size.y <= 0:
		return Vector4.ZERO
	if safe_rect.size.x <= 0 or safe_rect.size.y <= 0:
		return Vector4.ZERO
	var scale_x: float = viewport_size.x / float(window_size.x)
	var scale_y: float = viewport_size.y / float(window_size.y)
	var left: float = maxf(0.0, float(safe_rect.position.x)) * scale_x
	var top: float = maxf(0.0, float(safe_rect.position.y)) * scale_y
	var right: float = maxf(0.0, float(screen_size.x - safe_rect.end.x)) * scale_x
	var bottom: float = maxf(0.0, float(screen_size.y - safe_rect.end.y)) * scale_y
	return Vector4(left, top, right, bottom)


func _ready() -> void:
	var window: Window = get_window()
	if not window.size_changed.is_connected(_apply_safe_area):
		window.size_changed.connect(_apply_safe_area)
	var viewport: Viewport = get_viewport()
	if not viewport.size_changed.is_connected(_apply_safe_area):
		viewport.size_changed.connect(_apply_safe_area)
	_apply_safe_area()


func _notification(what: int) -> void:
	# Insets podem mudar após suspensão/retomada ou mudança de orientação sem alteração
	# perceptível no tamanho lógico da janela. Recalcular ao recuperar foco evita margens antigas.
	if what == NOTIFICATION_APPLICATION_RESUMED or what == NOTIFICATION_APPLICATION_FOCUS_IN or what == NOTIFICATION_WM_WINDOW_FOCUS_IN:
		_apply_safe_area()


func _apply_safe_area() -> void:
	var insets: Vector4 = Vector4.ZERO
	if OS.has_feature("mobile"):
		insets = compute_insets(
				DisplayServer.screen_get_size(),
				DisplayServer.get_display_safe_area(),
				get_window().size,
				get_viewport().get_visible_rect().size)
	add_theme_constant_override("margin_left", roundi(insets.x))
	add_theme_constant_override("margin_top", roundi(insets.y))
	add_theme_constant_override("margin_right", roundi(insets.z))
	add_theme_constant_override("margin_bottom", roundi(insets.w))
