class_name TouchControls
extends Control
## Controles touch com multitouch real (docs/technical/02-touch-and-display.md §2).
##
## - Cada dedo (índice de ponteiro) é rastreado de forma independente: soltar um dedo nunca
##   cancela a ação de outro dedo.
## - Uma ação só é solta quando NENHUM dedo a segura.
## - Pressionar/soltar viram eventos `InputEventAction` (via Input.parse_input_event), de modo
##   que o gameplay consome ações lógicas e o ActionBuffer enxerga as bordas de pressionar.
## - Dedo que sai do botão solta a ação; botões `slide_enter` permitem trocar de direção
##   arrastando de um para o outro.
## - Tudo é solto em perda de foco, saída da árvore, ocultação, pausa (via `release_all`) e
##   cancelamento de toque.
##
## Estado: implementado e testado em headless com eventos sintéticos. NÃO validado em aparelho.

## Folga (unidades do viewport) para tolerar toques que caem logo fora do botão.
@export var hit_slop: float = 14.0

var _buttons: Array[TouchButton] = []
## índice do dedo -> botão atualmente seguro por esse dedo
var _pointer_button: Dictionary = {}
## ação -> Array[int] de índices de dedos que a seguram
var _action_pointers: Dictionary = {}


func _ready() -> void:
	# Precisa continuar recebendo "soltar" mesmo com o jogo pausado.
	process_mode = Node.PROCESS_MODE_ALWAYS
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_collect_buttons(self)
	visibility_changed.connect(_on_visibility_changed)


func _exit_tree() -> void:
	release_all()


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT or what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		release_all()


## Botão registrado para `action`, ou null.
func get_button(action: StringName) -> TouchButton:
	for button: TouchButton in _buttons:
		if button.action == action:
			return button
	return null


## Solta todas as ações seguras por toques. Chamar ao pausar e ao trocar de cena.
func release_all() -> void:
	var held: Array = _action_pointers.keys()
	_pointer_button.clear()
	_action_pointers.clear()
	for action: StringName in held:
		_send_action(action, false)
	for button: TouchButton in _buttons:
		button.visual_pressed = false


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch: InputEventScreenTouch = event
		if touch.pressed and not touch.canceled:
			_on_pointer_down(touch.index, touch.position)
		else:
			_on_pointer_up(touch.index)
	elif event is InputEventScreenDrag:
		var drag: InputEventScreenDrag = event
		_on_pointer_drag(drag.index, drag.position)


func _on_pointer_down(index: int, position: Vector2) -> void:
	if get_tree().paused or not is_visible_in_tree():
		return
	var button: TouchButton = _button_at(position, true)
	if button != null:
		_bind(index, button)


func _on_pointer_up(index: int) -> void:
	_unbind(index)


func _on_pointer_drag(index: int, position: Vector2) -> void:
	if get_tree().paused or not is_visible_in_tree():
		return
	var current: TouchButton = _pointer_button.get(index) as TouchButton
	if current != null:
		if current.contains_point(position, hit_slop):
			return  # ainda dentro (com histerese): nada muda
		_unbind(index)
		var entered: TouchButton = _button_at(position, false)
		if entered != null and entered.slide_enter and current.slide_enter:
			_bind(index, entered)
	else:
		# Dedo que começou fora de qualquer botão e desliza para um botão de direção.
		var entered_free: TouchButton = _button_at(position, false)
		if entered_free != null and entered_free.slide_enter:
			_bind(index, entered_free)


## Botão sob `point`. Com `use_slop`, aceita toques próximos e escolhe o centro mais perto.
func _button_at(point: Vector2, use_slop: bool) -> TouchButton:
	for button: TouchButton in _buttons:
		if button.is_visible_in_tree() and button.contains_point(point, 0.0):
			return button
	if not use_slop:
		return null
	var best: TouchButton = null
	var best_distance: float = INF
	for button: TouchButton in _buttons:
		if button.is_visible_in_tree() and button.contains_point(point, hit_slop):
			var distance: float = button.center_distance(point)
			if distance < best_distance:
				best_distance = distance
				best = button
	return best


func _bind(index: int, button: TouchButton) -> void:
	# Um mesmo ponteiro não pode permanecer associado a dois botões. Embora o Android
	# normalmente envie UP antes de reutilizar um índice, eventos duplicados/reordenados
	# não podem deixar a ação anterior presa.
	var previous: TouchButton = _pointer_button.get(index) as TouchButton
	if previous == button:
		return
	if previous != null:
		_unbind(index)
	_pointer_button[index] = button
	var holders: Array = _action_pointers.get(button.action, [])
	var first_holder: bool = holders.is_empty()
	if not holders.has(index):
		holders.append(index)
	_action_pointers[button.action] = holders
	button.visual_pressed = true
	if first_holder:
		_send_action(button.action, true)


func _unbind(index: int) -> void:
	var button: TouchButton = _pointer_button.get(index) as TouchButton
	if button == null:
		return
	_pointer_button.erase(index)
	var holders: Array = _action_pointers.get(button.action, [])
	holders.erase(index)
	if holders.is_empty():
		_action_pointers.erase(button.action)
		_send_action(button.action, false)
	else:
		_action_pointers[button.action] = holders
	button.visual_pressed = _is_button_held(button)


func _is_button_held(button: TouchButton) -> bool:
	for held_button: Variant in _pointer_button.values():
		if held_button == button:
			return true
	return false


func _send_action(action: StringName, pressed: bool) -> void:
	var event: InputEventAction = InputEventAction.new()
	event.action = action
	event.pressed = pressed
	event.strength = 1.0 if pressed else 0.0
	Input.parse_input_event(event)


func _on_visibility_changed() -> void:
	if not is_visible_in_tree():
		release_all()


func _collect_buttons(node: Node) -> void:
	for child: Node in node.get_children():
		if child is TouchButton:
			_buttons.append(child)
		_collect_buttons(child)
