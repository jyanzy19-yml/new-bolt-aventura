extends BoltTest
## Lógica pura do puzzle de distribuição: ordem, falha, duplicados, terminalidade, determinismo.

const A: StringName = &"a"
const B: StringName = &"b"
const C: StringName = &"c"


func _seq() -> EnergySequence:
	var order: Array[StringName] = [A, B, C]
	return EnergySequence.new(order)


func test_correct_order_solves_and_reports_progress() -> bool:
	var s: EnergySequence = _seq()
	check_eq(s.progress(), 0, "inicia sem relés energizados")
	check(not s.is_solved(), "inicia não resolvida")
	check_eq(s.next_expected(), A, "primeiro relé esperado é A")
	check_eq(s.activate(A), EnergySequence.Result.ACCEPTED, "A aceito")
	check_eq(s.next_expected(), B, "depois de A espera-se B")
	check_eq(s.activate(B), EnergySequence.Result.ACCEPTED, "B aceito")
	check(not s.is_solved(), "2/3 não resolve")
	check_eq(s.activate(C), EnergySequence.Result.ACCEPTED, "C aceito")
	check(s.is_solved(), "ordem completa resolve")
	check_eq(s.progress(), 3, "progresso 3/3")
	check_eq(s.next_expected(), &"", "resolvida não espera mais nada")
	return true


func test_wrong_order_rejects_and_resets_from_any_position() -> bool:
	for wrong_first: StringName in [B, C]:
		var s: EnergySequence = _seq()
		check_eq(s.activate(wrong_first), EnergySequence.Result.REJECTED, "%s primeiro é rejeitado" % wrong_first)
		check_eq(s.progress(), 0, "rejeição mantém estado inicial")
		check_eq(s.failure_count(), 1, "falha contabilizada")
	var mid: EnergySequence = _seq()
	mid.activate(A)
	check_eq(mid.activate(C), EnergySequence.Result.REJECTED, "pular B rejeita")
	check_eq(mid.progress(), 0, "falha no meio reinicia tudo")
	check(not mid.is_energized(A), "A deixa de estar energizado após falha")
	# Recuperação: a ordem certa ainda resolve depois da falha.
	mid.activate(A)
	mid.activate(B)
	mid.activate(C)
	check(mid.is_solved(), "ordem correta resolve após falha (sem softlock)")
	check_eq(mid.failure_count(), 1, "contador de falhas preservado")
	return true


func test_duplicate_activation_is_ignored_not_a_failure() -> bool:
	var s: EnergySequence = _seq()
	s.activate(A)
	check_eq(s.activate(A), EnergySequence.Result.IGNORED_DUPLICATE, "A repetido é ignorado")
	check_eq(s.activate(A), EnergySequence.Result.IGNORED_DUPLICATE, "A repetido de novo é ignorado")
	check_eq(s.progress(), 1, "duplicados não avançam")
	check_eq(s.failure_count(), 0, "duplicados não são falha")
	s.activate(B)
	check_eq(s.activate(A), EnergySequence.Result.IGNORED_DUPLICATE, "relé anterior já energizado é duplicado, não falha")
	check_eq(s.progress(), 2, "progresso intacto")
	return true


func test_solved_is_terminal_and_unknown_ids_are_inert() -> bool:
	var s: EnergySequence = _seq()
	check_eq(s.activate(&"ghost"), EnergySequence.Result.UNKNOWN_RELAY, "ID desconhecido ignorado")
	check_eq(s.progress(), 0, "desconhecido não avança")
	check_eq(s.failure_count(), 0, "desconhecido não conta como falha")
	s.activate(A)
	s.activate(B)
	s.activate(C)
	for relay_id: StringName in [A, B, C, &"ghost"]:
		var result: EnergySequence.Result = s.activate(relay_id)
		check(result == EnergySequence.Result.IGNORED_SOLVED, "pós-resolução %s é ignorado" % relay_id)
	check(s.is_solved() and s.progress() == 3 and s.failure_count() == 0, "resolvida permanece intacta")
	return true


func test_empty_order_is_never_solved_and_run_is_deterministic() -> bool:
	var empty: EnergySequence = EnergySequence.new()
	check(not empty.is_solved(), "ordem vazia nunca resolve")
	check_eq(empty.activate(A), EnergySequence.Result.UNKNOWN_RELAY, "ordem vazia ignora tudo")
	var script: Array[StringName] = [B, A, A, C, A, B, B, C, &"x", A]
	var first: Array = []
	var second: Array = []
	var s1: EnergySequence = _seq()
	var s2: EnergySequence = _seq()
	for relay_id: StringName in script:
		first.append([s1.activate(relay_id), s1.progress()])
		second.append([s2.activate(relay_id), s2.progress()])
	check_eq(first, second, "mesma entrada produz mesma saída (determinismo)")
	return true
