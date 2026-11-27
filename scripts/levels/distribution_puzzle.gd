class_name DistributionPuzzle
extends Node
## Controlador local do puzzle de distribuição: liga relés -> EnergySequence -> conduítes/barreira.
## A ordem exigida é a ordem de `relay_paths`. O estado vive na instância da fase (não é persistido:
## o schema de save v1 não muda). Falha = sequência reiniciada, sem dano; resolvido é terminal.

signal progress_changed(progress: int, total: int)
signal sequence_failed(relay_id: StringName)
signal solved

@export var relay_paths: Array[NodePath] = []
## relays + 1 conduítes: conduits[k] acende quando progress >= k (conduits[0] = fonte -> 1º relé).
@export var conduit_paths: Array[NodePath] = []
@export var gate_path: NodePath

var _relays: Array[EnergyRelay] = []
var _conduits: Array[EnergyConduit] = []
var _gate: DistributionGate
var _sequence: EnergySequence


func _ready() -> void:
	var ids: Array[StringName] = []
	for path: NodePath in relay_paths:
		var relay: EnergyRelay = get_node_or_null(path) as EnergyRelay
		if relay == null:
			push_error("DistributionPuzzle: relé inválido em %s." % path)
			continue
		if ids.has(relay.relay_id):
			push_error("DistributionPuzzle: relay_id duplicado %s." % relay.relay_id)
			continue
		ids.append(relay.relay_id)
		_relays.append(relay)
		relay.struck.connect(_on_relay_struck)
	for path: NodePath in conduit_paths:
		var conduit: EnergyConduit = get_node_or_null(path) as EnergyConduit
		if conduit != null:
			_conduits.append(conduit)
	_gate = get_node_or_null(gate_path) as DistributionGate
	_sequence = EnergySequence.new(ids)
	_refresh()


func is_solved() -> bool:
	return _sequence.is_solved()


func progress() -> int:
	return _sequence.progress()


func total() -> int:
	return _sequence.total()


func failure_count() -> int:
	return _sequence.failure_count()


func get_relay_glyphs() -> Array[int]:
	var glyphs: Array[int] = []
	for relay: EnergyRelay in _relays:
		glyphs.append(relay.glyph)
	return glyphs


func _on_relay_struck(relay_id: StringName) -> void:
	match _sequence.activate(relay_id):
		EnergySequence.Result.ACCEPTED:
			_refresh()
			progress_changed.emit(_sequence.progress(), _sequence.total())
			if _sequence.is_solved():
				if _gate != null:
					_gate.open()
				solved.emit()
		EnergySequence.Result.REJECTED:
			_refresh()
			for relay: EnergyRelay in _relays:
				relay.flash_rejected()
			progress_changed.emit(0, _sequence.total())
			sequence_failed.emit(relay_id)
		_:
			pass  # duplicado, já resolvido ou desconhecido: sem efeito


func _refresh() -> void:
	for relay: EnergyRelay in _relays:
		relay.set_state(
			EnergyRelay.VisualState.ENERGIZED if _sequence.is_energized(relay.relay_id) else EnergyRelay.VisualState.OFF
		)
	for index in range(_conduits.size()):
		_conduits[index].set_lit(_sequence.progress() >= index)
