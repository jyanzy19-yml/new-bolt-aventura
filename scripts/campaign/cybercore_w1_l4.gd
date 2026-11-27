extends Node2D
## W1-L4 — Núcleo de Distribuição. BLOCKOUT PROVISÓRIO: layout, tempos e textos são propostas.
## Dependência explícita: NÃO depende de W1-L3 (ainda não integrada). Não é referenciada pelo
## menu nem por W1-L2; a integração de progressão é uma unidade separada (ver docs).

signal narrative_beat_requested(beat_id: StringName)

const LEVEL_PATH: String = "res://scenes/campaign/cybercore_w1_l4.tscn"
const LEVEL_ID: String = "W1-L4"
const CAMERA_LIMITS: Rect2i = Rect2i(0, -560, 2540, 820)

@onready var _player: BoltPlayer = %Bolt
@onready var _spawn: Marker2D = %SpawnPoint
@onready var _kill_zone: Area2D = %KillZone
@onready var _goal: Area2D = %Goal
@onready var _hud: Hud = %Hud
@onready var _puzzle: DistributionPuzzle = %Puzzle
@onready var _beat_trigger: NarrativeBeatTrigger = %BeatTrigger
@onready var _checkpoints: Array[BoltCheckpoint] = [%CheckpointA, %CheckpointB]

var _respawn_position: Vector2 = Vector2.ZERO
var _section_finished: bool = false


func _ready() -> void:
	configure_camera(_player.get_camera())
	_hud.bind_player(_player)
	_hud.set_restart_path(LEVEL_PATH)
	_player.defeated.connect(_on_player_defeated)
	_kill_zone.body_entered.connect(_on_kill_zone_body_entered)
	_goal.body_entered.connect(_on_goal_body_entered)
	_puzzle.progress_changed.connect(_on_puzzle_progress_changed)
	_puzzle.sequence_failed.connect(_on_puzzle_failed)
	_puzzle.solved.connect(_on_puzzle_solved)
	_beat_trigger.beat_requested.connect(func(beat_id: StringName) -> void: narrative_beat_requested.emit(beat_id))
	for checkpoint: BoltCheckpoint in _checkpoints:
		checkpoint.activated.connect(_on_checkpoint_activated)
	_respawn_position = _spawn.global_position
	if not CampaignProgress.begin_level(LEVEL_ID):
		push_warning("W1-L4: não foi possível registrar a entrada na fase (%s)." % CampaignProgress.last_error)
	var saved_checkpoint_id: String = CampaignProgress.get_checkpoint_id(LEVEL_ID)
	if not CampaignProgress.last_error.is_empty():
		push_warning("W1-L4: progresso persistente indisponível (%s)." % CampaignProgress.last_error)
	for checkpoint: BoltCheckpoint in _checkpoints:
		if saved_checkpoint_id == String(checkpoint.checkpoint_id):
			checkpoint.restore_activation()
			_respawn_position = checkpoint.get_respawn_position()
	_player.respawn(_respawn_position)


func configure_camera(camera: Camera2D) -> void:
	camera.limit_left = CAMERA_LIMITS.position.x
	camera.limit_top = CAMERA_LIMITS.position.y
	camera.limit_right = CAMERA_LIMITS.end.x
	camera.limit_bottom = CAMERA_LIMITS.end.y
	camera.limit_smoothed = true


func _on_player_defeated() -> void:
	_hud.show_result("BOLT foi derrotado")


func _on_checkpoint_activated(checkpoint_id: StringName, respawn_position: Vector2) -> void:
	_respawn_position = respawn_position
	if not CampaignProgress.save_checkpoint(LEVEL_ID, String(checkpoint_id)):
		push_warning("W1-L4: não foi possível persistir checkpoint (%s)." % CampaignProgress.last_error)
	_hud.show_progress_notification("CHECKPOINT ATIVADO")


func _on_puzzle_progress_changed(progress: int, total: int) -> void:
	if progress > 0:
		_hud.show_progress_notification("NÓ %d/%d ENERGIZADO" % [progress, total])


func _on_puzzle_failed(_relay_id: StringName) -> void:
	_hud.show_progress_notification("SEQUÊNCIA INTERROMPIDA · REINICIADA")


func _on_puzzle_solved() -> void:
	_hud.show_progress_notification("DISTRIBUIÇÃO ESTABELECIDA")
	# Se BOLT já estiver dentro da área do objetivo, body_entered não dispararia de novo.
	if _goal.overlaps_body(_player):
		_try_finish()


func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body == _player:
		_player.respawn(_respawn_position)


func _on_goal_body_entered(body: Node2D) -> void:
	if body == _player:
		_try_finish()


func _try_finish() -> void:
	# Defesa em profundidade: a barreira já bloqueia fisicamente, mas a conclusão exige o puzzle.
	if _section_finished or not _puzzle.is_solved():
		return
	_section_finished = true
	# Sem fase seguinte implementada: a retomada permanece em W1-L4.
	if not CampaignProgress.mark_level_completed(LEVEL_ID):
		push_warning("W1-L4: não foi possível persistir a conclusão (%s)." % CampaignProgress.last_error)
	_hud.show_result("Cybercore — Núcleo de Distribuição concluído")
