class_name SaveData
extends RefCounted
## Estado PERSISTENTE de progresso (docs/technical/05-system-contracts.md §8): somente dados
## serializáveis, versionados e identificados por IDs estáveis — nunca Nodes nem caminhos de cena.
##
## Esta classe é a única fonte de verdade do formato. Toda entrada vinda do disco passa por
## `from_dict`, que valida e sanitiza (descarta o inválido, remove duplicatas) em vez de confiar.
## O conteúdo narrativo/de campanha NÃO é definido aqui: são só contêineres de IDs.
##
## Esquema v1 (PROPOSTA técnica — ADR-0004, aguardando aprovação):
##   version            int
##   completed_levels   [level_id]            ex.: "W1-L1" (IDs do tracker) ou "dev.<nome>"
##   checkpoints        {level_id: checkpoint_id}  último checkpoint de cada fase em andamento
##   collected          [id]                  itens/recompensas únicos já obtidos (anti-duplicação)
##   flags              [id]                  flags de progresso/narrativa por ID estável

const SCHEMA_VERSION: int = 1

## IDs de fase: "W1-L1" a "W7-L6" (tracker) ou "dev.<nome>" para cenários de desenvolvimento.
const LEVEL_ID_PATTERN: String = "^(W[1-7]-L[1-6]|dev\\.[a-z0-9_]{1,40})$"
## Demais IDs estáveis (checkpoint, colecionável, flag).
const GENERIC_ID_PATTERN: String = "^[a-z0-9][a-z0-9_.\\-]{0,63}$"

enum ParseStatus { OK, MALFORMED, UNSUPPORTED_VERSION }

var completed_levels: Array[String] = []
var checkpoints: Dictionary = {}
var collected: Array[String] = []
var flags: Array[String] = []
## Quantos itens inválidos foram descartados ao carregar (diagnóstico; não é persistido).
var discarded_entries: int = 0

static var _level_regex: RegEx
static var _generic_regex: RegEx


static func is_valid_level_id(id: String) -> bool:
	if _level_regex == null:
		_level_regex = RegEx.create_from_string(LEVEL_ID_PATTERN)
	return _level_regex.search(id) != null


static func is_valid_id(id: String) -> bool:
	if _generic_regex == null:
		_generic_regex = RegEx.create_from_string(GENERIC_ID_PATTERN)
	return _generic_regex.search(id) != null


func to_dict() -> Dictionary:
	var sorted_levels: Array[String] = completed_levels.duplicate()
	sorted_levels.sort()
	var sorted_collected: Array[String] = collected.duplicate()
	sorted_collected.sort()
	var sorted_flags: Array[String] = flags.duplicate()
	sorted_flags.sort()
	return {
		"version": SCHEMA_VERSION,
		"completed_levels": sorted_levels,
		"checkpoints": checkpoints.duplicate(),
		"collected": sorted_collected,
		"flags": sorted_flags,
	}


## Converte um Dictionary lido do disco em SaveData. `out` recebe o resultado e o retorno diz se
## o formato foi aceito. Versão futura (> SCHEMA_VERSION) é recusada SEM tentar interpretar, para
## que o chamador nunca sobrescreva um save de uma versão mais nova do jogo.
static func parse(raw: Variant, out: Array) -> ParseStatus:
	if not (raw is Dictionary):
		return ParseStatus.MALFORMED
	var dict: Dictionary = raw
	var version: int = _read_version(dict.get("version"))
	if version < 1:
		return ParseStatus.MALFORMED
	if version > SCHEMA_VERSION:
		return ParseStatus.UNSUPPORTED_VERSION
	dict = migrate(dict, version)
	var data: SaveData = SaveData.new()
	data._load_levels(dict.get("completed_levels"))
	data._load_checkpoints(dict.get("checkpoints"))
	data.collected = data._load_ids(dict.get("collected"))
	data.flags = data._load_ids(dict.get("flags"))
	out.clear()
	out.append(data)
	return ParseStatus.OK


## Migração explícita, passo a passo (v1 → v2 → …). Hoje existe só a v1, então não há passos;
## ao subir SCHEMA_VERSION, adicionar o passo correspondente aqui e um teste com um save antigo.
static func migrate(dict: Dictionary, from_version: int) -> Dictionary:
	if from_version < SCHEMA_VERSION:
		push_error("SaveData: sem migração de v%d para v%d." % [from_version, SCHEMA_VERSION])
	return dict


## JSON devolve números como float; aceita 1 e 1.0, recusa o resto.
static func _read_version(value: Variant) -> int:
	if value is int:
		return value
	if value is float and is_equal_approx(value, floorf(value)):
		return int(value)
	return 0


func _load_levels(value: Variant) -> void:
	for id: String in _load_ids(value, true):
		completed_levels.append(id)


func _load_checkpoints(value: Variant) -> void:
	if not (value is Dictionary):
		if value != null:
			discarded_entries += 1
		return
	var source: Dictionary = value
	for key: Variant in source:
		var level_id: String = str(key)
		var checkpoint_id: Variant = source[key]
		if key is String and checkpoint_id is String and is_valid_level_id(level_id) and is_valid_id(checkpoint_id):
			checkpoints[level_id] = checkpoint_id
		else:
			discarded_entries += 1


## Lista de IDs válidos e únicos; entradas inválidas/duplicadas são contadas e descartadas.
func _load_ids(value: Variant, levels: bool = false) -> Array[String]:
	var result: Array[String] = []
	if not (value is Array):
		if value != null:
			discarded_entries += 1
		return result
	var seen: Dictionary = {}
	for item: Variant in value:
		var valid: bool = item is String and (is_valid_level_id(item) if levels else is_valid_id(item))
		if valid and not seen.has(item):
			seen[item] = true
			result.append(item)
		else:
			discarded_entries += 1
	return result
