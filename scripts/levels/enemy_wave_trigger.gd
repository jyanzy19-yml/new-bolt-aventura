class_name EnemyWaveTrigger
extends Area2D
## Dispara uma onda sequencial de inimigos já existentes. Não implementa IA nova.

signal wave_spawned(wave_id: StringName, enemy_count: int)

@export var wave_id: StringName
@export var enemy_scene: PackedScene
@export var spawn_offsets: Array[Vector2] = [Vector2(-80.0, -20.0), Vector2(80.0, -20.0)]
@export_range(0.0, 240.0, 5.0) var enemy_patrol_distance: float = 60.0
@export var one_shot: bool = true

var _triggered: bool = false
var _spawned_count: int = 0


func _ready() -> void:
	collision_layer = 0
	collision_mask = 2
	body_entered.connect(_on_body_entered)


func has_spawned() -> bool:
	return _triggered


func get_spawned_count() -> int:
	return _spawned_count


func _on_body_entered(body: Node2D) -> void:
	if not body is BoltPlayer or (one_shot and _triggered):
		return
	if enemy_scene == null:
		push_warning("EnemyWaveTrigger: enemy_scene ausente; onda ignorada.")
		return
	var spawn_parent: Node = get_parent()
	if spawn_parent == null:
		push_warning("EnemyWaveTrigger: sem parent para instanciar a onda.")
		return

	_triggered = true
	for offset in spawn_offsets:
		var enemy: Node2D = enemy_scene.instantiate() as Node2D
		if enemy == null:
			continue
		if enemy is CybercorePatrolEnemy:
			enemy.patrol_distance = enemy_patrol_distance
		spawn_parent.add_child(enemy)
		enemy.global_position = global_position + offset
		_spawned_count += 1
	wave_spawned.emit(wave_id, _spawned_count)
