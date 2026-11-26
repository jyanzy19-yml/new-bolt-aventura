class_name Hud
extends CanvasLayer
## HUD de gameplay: controles touch, pausa e tela de resultado.
##
## O HUD OBSERVA o estado do jogador por sinais (docs/technical/05-system-contracts.md §3); não
## é fonte de verdade de nada. Continua processando durante a pausa (PROCESS_MODE_ALWAYS) para
## que os botões de pausa/resultado funcionem.

const MAIN_MENU_PATH: String = "res://scenes/ui/main_menu.tscn"

@onready var _touch: TouchControls = %TouchControls
@onready var _pause_overlay: Control = %PauseOverlay
@onready var _result_overlay: Control = %ResultOverlay
@onready var _resume_button: Button = %ResumeButton
@onready var _result_title: Label = %ResultTitle
@onready var _again_button: Button = %AgainButton

var _restart_path: String = ""


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_pause_overlay.visible = false
	_result_overlay.visible = false
	%ResumeButton.pressed.connect(func() -> void: set_paused(false))
	%PauseMenuButton.pressed.connect(_go_to_menu)
	%ResultMenuButton.pressed.connect(_go_to_menu)
	_again_button.pressed.connect(_restart)


func _exit_tree() -> void:
	# Sair da cena nunca pode deixar o jogo pausado nem comandos pressionados.
	get_tree().paused = false


func bind_player(player: BoltPlayer) -> void:
	player.dash_cooldown_changed.connect(_on_dash_cooldown_changed)
	_on_dash_cooldown_changed(1.0)


func set_restart_path(path: String) -> void:
	_restart_path = path


func _input(event: InputEvent) -> void:
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


func show_result(title: String) -> void:
	_result_title.text = title
	_result_overlay.visible = true
	_pause_overlay.visible = false
	_touch.release_all()
	_touch.visible = false
	Actions.release_all_game_actions()
	get_tree().paused = true
	_again_button.grab_focus()


func _on_dash_cooldown_changed(ratio: float) -> void:
	var dash_button: TouchButton = _touch.get_button(Actions.DASH)
	if dash_button != null:
		dash_button.availability = ratio


func _go_to_menu() -> void:
	_leave_to(MAIN_MENU_PATH)


func _restart() -> void:
	if _restart_path != "":
		_leave_to(_restart_path)


func _leave_to(path: String) -> void:
	get_tree().paused = false
	Actions.release_all_game_actions()
	# Resolvido em runtime (mesmo motivo de MainMenu: compilação em thread de carregamento).
	var flow: Node = get_node_or_null("/root/SceneFlow")
	if flow == null:
		push_error("Hud: autoload SceneFlow ausente.")
		return
	flow.change_scene(path)
