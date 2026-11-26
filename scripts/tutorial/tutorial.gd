extends Node2D
## Tutorial inicial guiado pelo robô mensageiro. Textos são instruções funcionais provisórias;
## não definem personalidade ou biografia do personagem.

const CAMPAIGN_LEVEL_PATH: String = "res://scenes/campaign/cybercore_w1_l1.tscn"
const CAMERA_LIMITS: Rect2i = Rect2i(0, -320, 1400, 560)
const MOVE_TARGET_X: float = 300.0

enum Step { INTRO, MOVE, JUMP, DASH, ATTACK, COMPLETE }

@onready var _player: BoltPlayer = %Bolt
@onready var _spawn: Marker2D = $SpawnPoint
@onready var _hud: Hud = %Hud
@onready var _speech: Label = %SpeechLabel
@onready var _start_button: Button = %StartButton
@onready var _target: BoltTrainingTarget = %TrainingTarget
@onready var _combat: BoltCombat = %Bolt/Combat

var _step: Step = Step.INTRO
var _spawn_position: Vector2 = Vector2.ZERO


func _ready() -> void:
	var camera: Camera2D = _player.get_camera()
	camera.limit_left = CAMERA_LIMITS.position.x
	camera.limit_top = CAMERA_LIMITS.position.y
	camera.limit_right = CAMERA_LIMITS.end.x
	camera.limit_bottom = CAMERA_LIMITS.end.y
	_hud.bind_player(_player)
	_spawn_position = _spawn.global_position
	_player.set_physics_process(false)
	%KillZone.body_entered.connect(_on_kill_zone_body_entered)
	_hud.set_restart_path("res://scenes/tutorial/tutorial.tscn")
	_player.state_changed.connect(_on_player_state_changed)
	_target.defeated.connect(_on_target_defeated)
	_combat.set_enabled(false)
	_start_button.pressed.connect(_on_start_or_continue)
	_render_step()


func _process(_delta: float) -> void:
	if _step == Step.MOVE and _player.global_position.x >= MOVE_TARGET_X:
		_set_step(Step.JUMP)


func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body == _player:
		_player.respawn(_spawn_position)


func _on_player_state_changed(new_state: int) -> void:
	if _step == Step.JUMP and new_state == BoltPlayer.State.RISING:
		_set_step(Step.DASH)
	elif _step == Step.DASH and new_state == BoltPlayer.State.DASHING:
		_set_step(Step.ATTACK)


func _on_target_defeated() -> void:
	if _step == Step.ATTACK:
		_set_step(Step.COMPLETE)


func _on_start_or_continue() -> void:
	if _step == Step.INTRO:
		_start_button.visible = false
		_player.set_physics_process(true)
		_set_step(Step.MOVE)
	elif _step == Step.COMPLETE:
		_start_button.disabled = true
		var flow: Node = get_node_or_null("/root/SceneFlow")
		if flow == null:
			push_error("Tutorial: autoload SceneFlow ausente.")
			_start_button.disabled = false
			return
		if not flow.change_scene(CAMPAIGN_LEVEL_PATH):
			_start_button.disabled = false


func _set_step(next_step: Step) -> void:
	_step = next_step
	_render_step()


func _render_step() -> void:
	match _step:
		Step.INTRO:
			_speech.text = "ROBÔ MENSAGEIRO\nVamos preparar seus controles. Siga as instruções."
			_start_button.text = "COMEÇAR"
			_start_button.visible = true
		Step.MOVE:
			_speech.text = "ROBÔ MENSAGEIRO\nMova BOLT para a direita."
			_start_button.visible = false
		Step.JUMP:
			_speech.text = "ROBÔ MENSAGEIRO\nAgora salte. Use o botão PULO."
			_start_button.visible = false
		Step.DASH:
			_speech.text = "ROBÔ MENSAGEIRO\nExperimente o DASH para avançar rapidamente."
			_start_button.visible = false
		Step.ATTACK:
			_combat.set_enabled(true)
			_speech.text = "ROBÔ MENSAGEIRO\\nAponte para o alvo e use TIRO."
			_start_button.visible = false
		Step.COMPLETE:
			_speech.text = "ROBÔ MENSAGEIRO\nControles básicos verificados. Cybercore aguarda."
			_start_button.text = "ENTRAR EM CYBERCORE"
			_start_button.visible = true
