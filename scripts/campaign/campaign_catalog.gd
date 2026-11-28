class_name CampaignCatalog
extends RefCounted
## Catálogo imutável. Não persiste estado e não substitui CampaignProgress.

const WORLD_IDS: Array[String] = ["W1", "W2", "W3", "W4", "W5", "W6", "W7"]
const WORLD_NAMES: Array[String] = [
	"Cybercore", "Egito Antigo Futurista", "Speakeasy Aesthetic", "Dark Fantasy",
	"Pôr do Sol em Cidade Medieval", "Vaporwave / Las Vegas", "Natal / Nova York Futurista",
]
const FRAGMENT_NAMES: Array[String] = ["Origem", "Memória", "Verdade", "Sombra", "Luz", "Ilusão", "Equilíbrio"]
const GUARDIAN_TITLES: Array[String] = [
	"Sentinela do Fragmento", "Guardião Ancestral das Pirâmides", "Mestre das Sombras",
	"Rei Esquecido", "Guardião da Coroa", "Ilusionista Supremo", "Guardião do Inverno",
]
const PHASE_TITLES: Dictionary = {
	"W1-L1": "Despertar entre Ruínas",
	"W1-L2": "Ruas sem Sinal",
	"W1-L3": "Fábrica de Ecos",
	"W1-L4": "Laboratório de Memórias",
}
const SCENE_PATHS: Dictionary = {
	"W1-L1": "res://scenes/campaign/cybercore_w1_l1.tscn",
	"W1-L2": "res://scenes/campaign/cybercore_w1_l2.tscn",
	"W1-L3": "res://scenes/campaign/cybercore_w1_l3.tscn",
	"W1-L4": "res://scenes/campaign/cybercore_w1_l4.tscn",
}

static func get_world_count() -> int:
	return WORLD_IDS.size()

static func get_phase_count_per_world() -> int:
	return 6

static func get_total_phase_count() -> int:
	return get_world_count() * get_phase_count_per_world()

static func get_level_id(world_index: int, phase_index: int) -> String:
	if world_index < 0 or world_index >= get_world_count():
		return ""
	if phase_index < 0 or phase_index >= get_phase_count_per_world():
		return ""
	return "%s-L%d" % [WORLD_IDS[world_index], phase_index + 1]

static func get_world_index(world_id: String) -> int:
	return WORLD_IDS.find(world_id)

static func get_world_name(world_index: int) -> String:
	if world_index < 0 or world_index >= WORLD_NAMES.size():
		return ""
	return WORLD_NAMES[world_index]

static func get_fragment_name(world_index: int) -> String:
	if world_index < 0 or world_index >= FRAGMENT_NAMES.size():
		return ""
	return FRAGMENT_NAMES[world_index]

static func get_guardian_title(world_index: int) -> String:
	if world_index < 0 or world_index >= GUARDIAN_TITLES.size():
		return ""
	return GUARDIAN_TITLES[world_index]

static func get_phase_title(level_id: String, phase_index: int) -> String:
	if PHASE_TITLES.has(level_id):
		return str(PHASE_TITLES[level_id])
	return "Fase %d" % (phase_index + 1)

static func get_scene_path(level_id: String) -> String:
	return str(SCENE_PATHS.get(level_id, ""))

static func is_scene_available(level_id: String) -> bool:
	var path: String = get_scene_path(level_id)
	return not path.is_empty() and ResourceLoader.exists(path, "PackedScene")

static func is_phase_unlocked(world_index: int, phase_index: int, completed_level_ids: Array) -> bool:
	if world_index < 0 or world_index >= get_world_count():
		return false
	if phase_index < 0 or phase_index >= get_phase_count_per_world():
		return false
	if world_index == 0 and phase_index == 0:
		return true
	if phase_index > 0:
		return completed_level_ids.has(get_level_id(world_index, phase_index - 1))
	return completed_level_ids.has(get_level_id(world_index - 1, get_phase_count_per_world() - 1))

static func is_world_unlocked(world_index: int, completed_level_ids: Array) -> bool:
	if world_index < 0 or world_index >= get_world_count():
		return false
	if world_index == 0:
		return true
	return completed_level_ids.has(get_level_id(world_index - 1, get_phase_count_per_world() - 1))

static func get_phase_state(world_index: int, phase_index: int, completed_level_ids: Array, scene_exists: bool) -> String:
	if not scene_exists:
		return "coming_soon"
	var level_id: String = get_level_id(world_index, phase_index)
	if level_id.is_empty():
		return "locked"
	if completed_level_ids.has(level_id):
		return "completed"
	if is_phase_unlocked(world_index, phase_index, completed_level_ids):
		return "available"
	return "locked"

static func get_world_completed_count(world_index: int, completed_level_ids: Array) -> int:
	var count: int = 0
	for phase_index in range(get_phase_count_per_world()):
		if completed_level_ids.has(get_level_id(world_index, phase_index)):
			count += 1
	return count

static func get_world_state(world_index: int, completed_level_ids: Array, first_phase_scene_exists: bool) -> String:
	if world_index < 0 or world_index >= get_world_count():
		return "locked"
	if get_world_completed_count(world_index, completed_level_ids) == get_phase_count_per_world():
		return "completed"
	if not is_world_unlocked(world_index, completed_level_ids):
		return "locked"
	if not first_phase_scene_exists:
		return "coming_soon"
	return "available"

static func get_total_completed_count(completed_level_ids: Array) -> int:
	var count: int = 0
	for world_index in range(get_world_count()):
		count += get_world_completed_count(world_index, completed_level_ids)
	return count
