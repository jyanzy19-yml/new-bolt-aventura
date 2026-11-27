class_name EnergySequence
extends RefCounted
## Lógica PURA e determinística do puzzle de distribuição de energia (sem nós, sem tempo).
## O estado é função apenas da sequência ordenada de chamadas a activate().
##
## Regras:
##  - A energia só avança para o PRÓXIMO relé da ordem exigida.
##  - Ativar um relé fora da ordem REJEITA: a sequência volta ao estado inicial (nenhum dano).
##  - Ativar um relé já energizado é um callback duplicado: ignorado, não é falha.
##  - Depois de resolvida, a sequência é terminal: novas ativações são ignoradas.
##  - IDs desconhecidos são ignorados (nunca resolvem nem reiniciam).

enum Result { ACCEPTED, IGNORED_DUPLICATE, REJECTED, IGNORED_SOLVED, UNKNOWN_RELAY }

var _order: Array[StringName] = []
var _energized: Array[StringName] = []
var _failures: int = 0


func _init(order: Array[StringName] = []) -> void:
	_order = order.duplicate()


func activate(relay_id: StringName) -> Result:
	if is_solved():
		return Result.IGNORED_SOLVED
	if not _order.has(relay_id):
		return Result.UNKNOWN_RELAY
	if _energized.has(relay_id):
		return Result.IGNORED_DUPLICATE
	if relay_id != _order[_energized.size()]:
		_energized.clear()
		_failures += 1
		return Result.REJECTED
	_energized.append(relay_id)
	return Result.ACCEPTED


func is_solved() -> bool:
	return not _order.is_empty() and _energized.size() == _order.size()


func is_energized(relay_id: StringName) -> bool:
	return _energized.has(relay_id)


func progress() -> int:
	return _energized.size()


func total() -> int:
	return _order.size()


func failure_count() -> int:
	return _failures


## Próximo relé exigido; vazio quando resolvida (ou sem ordem).
func next_expected() -> StringName:
	if is_solved() or _order.is_empty():
		return &""
	return _order[_energized.size()]
