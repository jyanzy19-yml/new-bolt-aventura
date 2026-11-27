extends BoltTest
## Testes puros do catálogo e da política sequencial aprovada.
const CATALOG = preload("res://scripts/campaign/campaign_catalog.gd")

func test_catalog_defines_seven_worlds_and_forty_two_stable_phase_ids() -> bool:
	check_eq(CATALOG.get_world_count(), 7, "sete mundos")
	check_eq(CATALOG.get_phase_count_per_world(), 6, "seis fases por mundo")
	check_eq(CATALOG.get_total_phase_count(), 42, "42 fases")
	var seen: Dictionary = {}
	for world_index in range(CATALOG.get_world_count()):
		for phase_index in range(CATALOG.get_phase_count_per_world()):
			var level_id: String = CATALOG.get_level_id(world_index, phase_index)
			check(not level_id.is_empty(), "ID válido")
			check(not seen.has(level_id), "ID único: %s" % level_id)
			seen[level_id] = true
	check_eq(seen.size(), 42, "42 IDs únicos")
	check_eq(CATALOG.get_level_id(0, 0), "W1-L1", "primeiro ID persistente")
	check_eq(CATALOG.get_level_id(6, 5), "W7-L6", "último ID persistente")
	return true

func test_world_catalog_matches_approved_world_bible_order() -> bool:
	check_eq(CATALOG.get_world_name(0), "Cybercore", "mundo 1")
	check_eq(CATALOG.get_world_name(1), "Egito Antigo Futurista", "mundo 2")
	check_eq(CATALOG.get_world_name(2), "Speakeasy Aesthetic", "mundo 3")
	check_eq(CATALOG.get_world_name(3), "Dark Fantasy", "mundo 4")
	check_eq(CATALOG.get_world_name(4), "Pôr do Sol em Cidade Medieval", "mundo 5")
	check_eq(CATALOG.get_world_name(5), "Vaporwave / Las Vegas", "mundo 6")
	check_eq(CATALOG.get_world_name(6), "Natal / Nova York Futurista", "mundo 7")
	check_eq(CATALOG.get_fragment_name(0), "Origem", "fragmento Cybercore")
	check_eq(CATALOG.get_guardian_title(6), "Guardião do Inverno", "guardião mundo 7")
	return true

func test_sequential_unlocks_start_with_only_w1_l1() -> bool:
	var completed: Array = []
	check(CATALOG.is_phase_unlocked(0, 0, completed), "W1-L1 inicia disponível")
	check(not CATALOG.is_phase_unlocked(0, 1, completed), "W1-L2 bloqueada")
	check(not CATALOG.is_world_unlocked(1, completed), "W2 bloqueado")
	return true

func test_completing_a_phase_unlocks_only_the_next_phase() -> bool:
	var completed: Array = ["W1-L1"]
	check(CATALOG.is_phase_unlocked(0, 1, completed), "W1-L1 libera W1-L2")
	check(not CATALOG.is_phase_unlocked(0, 2, completed), "W1-L3 continua bloqueada")
	check(not CATALOG.is_world_unlocked(1, completed), "W2 continua bloqueado")
	return true

func test_completing_world_sixth_phase_unlocks_next_world() -> bool:
	var completed: Array = ["W1-L6"]
	check(CATALOG.is_world_unlocked(1, completed), "W1-L6 libera W2")
	check(CATALOG.is_phase_unlocked(1, 0, completed), "W2-L1 disponível")
	check(not CATALOG.is_phase_unlocked(1, 1, completed), "W2-L2 bloqueada")
	return true

func test_completed_phases_are_replayable_and_missing_scenes_stay_unavailable() -> bool:
	var completed: Array = ["W1-L1", "W1-L2"]
	check_eq(CATALOG.get_phase_state(0, 0, completed, true), "completed", "fase concluída permanece concluída")
	check(CATALOG.is_phase_unlocked(0, 0, completed), "fase inicial pode ser rejogada")
	check_eq(CATALOG.get_phase_state(0, 2, completed, false), "coming_soon", "cena ausente fica em breve")
	check_eq(CATALOG.get_phase_state(0, 2, completed, true), "available", "fase existente e liberada disponível")
	check_eq(CATALOG.get_phase_state(0, 3, completed, true), "locked", "fase sem pré-requisito bloqueada")
	return true

func test_invalid_catalog_indices_fail_closed() -> bool:
	check_eq(CATALOG.get_level_id(-1, 0), "", "mundo negativo rejeitado")
	check_eq(CATALOG.get_level_id(7, 0), "", "mundo fora do catálogo rejeitado")
	check_eq(CATALOG.get_level_id(0, 6), "", "fase fora do mundo rejeitada")
	check(not CATALOG.is_world_unlocked(7, []), "mundo inexistente nunca desbloqueia")
	return true

func test_selection_scenes_and_main_menu_entry_are_loadable() -> bool:
	var worlds: PackedScene = load("res://scenes/ui/world_selection.tscn") as PackedScene
	var phases: PackedScene = load("res://scenes/ui/phase_selection.tscn") as PackedScene
	var menu: PackedScene = load("res://scenes/ui/main_menu.tscn") as PackedScene
	check(worlds != null, "cena de seleção de mundos carrega")
	check(phases != null, "cena de seleção de fases carrega")
	check(menu != null, "menu principal carrega com entrada de seleção")
	if menu != null:
		var instance: Node = menu.instantiate()
		check(instance.get_node_or_null("Center/Column/CampaignSelectionButton") is Button, "menu expõe botão de seleção")
		instance.free()
	return true
