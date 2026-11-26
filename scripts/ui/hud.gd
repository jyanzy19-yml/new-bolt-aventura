class_name Hud
extends CanvasLayer
## HUD de gameplay: vida, controles touch, pausa e tela de resultado.

const MAIN_MENU_PATH: String = "res://scenes/ui/main_menu.tscn"

@onready var _touch: TouchControls = %TouchControls
@onready var _pause_overlay: Control = %PauseOverlay
@onready var _result_overlay: Control = %ResultOverlay
@onready var _resume_button: Button = %ResumeButton
@onready var _result_title: Label = %ResultTitle
@onready var _again_button: Button = %AgainButton
@onready var _health_label: Label = %HealthLabel
@onready var _progress_notification: Label = %ProgressNotification
@onready var _progress_notification_timer: Timer = %ProgressNotificationTimer

var _restart_path: String = ""
var _result_next_path: String = ""


func _scene_flow() -> Node:
	return get_node_or_null("/root/SceneFlow")


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_pause_overlay.visible = false
	_result_overlay.visible = false
	%ResumeButton.pressed.connect(func() -> void: set_paused(false))
	%PauseMenuButton.pressed.connect(_go_to_menu)
	%ResultMenuButton.pressed.connect(_go_to_menu)
	_again_button.pressed.connect(_restart)
	_progress_notification_timer.timeout.connect(_on_progress_notification_timeout)
	var flow: Node = _scene_flow()
	if flow != null:
		flow.connect("transition_started", Callable(self, "_on_scene_transition_started"))
		flow.connect("transition_failed", Callable(self, "_on_scene_transition_failed"))
	else:
		push_warning("Hud: autoload SceneFlow ausente; transições não serão observadas.")


func _exit_tree() -> void:
	# SceneFlow owns pause restoration while a transition is active.
	var flow: Node = _scene_flow()
	if flow != null and not bool(flow.call("is_transitioning")):
		get_tree().paused = false


func bind_player(player: BoltPlayer) -> void:
	player.dash_cooldown_changed.connect(_on_dash_cooldown_changed)
	player.health_changed.connect(_on_player_health_changed)
	var health: BoltHealth = player.get_node("%Health") as BoltHealth
	_on_dash_cooldown_changed(1.0)
	_on_player_health_changed(health.current_health, health.max_health)


func set_restart_path(path: String) -> void:
	_restart_path = path


func _input(event: InputEvent) -> void:
	var flow: Node = _scene_flow()
	if flow != null and bool(flow.call("is_transitioning")):
		return
	if event.is_action_pressed(Actions.PAUSE, false) and not _result_overlay.visible:
		set_paused(not get_tree().paused)
		get_viewport().set_input_as_handled()


func set_paused(paused: bool) -> void:
	get_tree().paused = paused
	_pause_overlay.visible = paused
	_touch.release_all()
	_touch.visible = not paused
	Actions.release_all_game_actions()
	if paused:
		_resume_button.grab_focus()


func show_progress_notification(message: String) -> void:
	if message.is_empty() or _result_overlay.visible:
		return
	_progress_notification.text = message
	_progress_notification.visible = true
	_progress_notification_timer.start()


func _on_progress_notification_timeout() -> void:
	_progress_notification.visible = false


func show_result(title: String, next_path: String = "") -> void:
	_result_title.text = title
	_result_next_path = next_path
	_again_button.text = "PRÓXIMA FASE" if not _result_next_path.is_empty() else "JOGAR DE NOVO"
	_result_overlay.visible = true
	_pause_overlay.visible = false
	_touch.release_all()
	_touch.visible = false
	Actions.release_all_game_actions()
	get_tree().paused = true
	_again_button.grab_focus()


func _on_scene_transition_started(_path: String) -> void:
	_touch.release_all()
	_touch.visible = false
	Actions.release_all_game_actions()


func _on_scene_transition_failed(_path: String, _reason: String) -> void:
	_touch.visible = not get_tree().paused and not _result_overlay.visible


func _on_dash_cooldown_changed(ratio: float) -> void:
	var dash_button: TouchButton = _touch.get_button(Actions.DASH)
	if dash_button != null:
		dash_button.availability = ratio


func _on_player_health_changed(current: int, maximum: int) -> void:
	_health_label.text = "VIDA  %d / %d" % [current, maximum]


func _go_to_menu() -> void:
	_leave_to(MAIN_MENU_PATH)


func _restart() -> void:
	var destination: String = _result_next_path if not _result_next_path.is_empty() else _restart_path
	if destination != "":
		_leave_to(destination)


func _leave_to(path: String) -> void:
	get_tree().paused = false
	Actions.release_all_game_actions()
	var flow: Node = get_node_or_null("/root/SceneFlow")
	if flow == null:
		push_error("Hud: autoload SceneFlow ausente.")
		return
	flow.call("change_scene", path)
