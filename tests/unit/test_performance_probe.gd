extends BoltTest
## Contratos da instrumentação de performance em builds de desenvolvimento.


func _probe() -> Node:
	return tree.root.get_node_or_null("PerformanceProbe")


func test_probe_is_registered_and_debug_gated() -> bool:
	var probe: Node = _probe()
	check(probe != null, "autoload PerformanceProbe presente")
	if probe == null:
		return true
	if not OS.is_debug_build():
		check(not bool(probe.call("is_enabled")), "instrumentação permanece desativada fora de build debug")
		check(not bool(probe.call("set_enabled", true)), "build não-debug rejeita ativação")
	else:
		check(bool(probe.call("is_enabled")), "instrumentação é habilitada em build debug")
	return true


func test_probe_collects_frame_time_and_calculates_percentiles() -> bool:
	var probe: Node = _probe()
	check(probe != null, "autoload PerformanceProbe presente")
	if probe == null or not OS.is_debug_build():
		return true

	probe.call("reset")
	await tree.process_frame
	await tree.process_frame
	await tree.process_frame
	var snapshot: Dictionary = probe.call("get_snapshot")
	check_eq(snapshot.get("sample_capacity", 0), 600, "janela mantém capacidade limitada de 600 amostras")
	check(int(snapshot.get("sample_count", 0)) >= 1, "frames são armazenados na janela")
	check(float(snapshot.get("frame_time_ms_avg", 0.0)) > 0.0, "média de frame time é positiva")
	check(float(snapshot.get("frame_time_ms_p95", 0.0)) > 0.0, "p95 é calculado")
	check(float(snapshot.get("frame_time_ms_p99", 0.0)) > 0.0, "p99 é calculado")
	check(float(snapshot.get("frame_time_ms_max", 0.0)) >= float(snapshot.get("frame_time_ms_avg", 0.0)), "máximo não é inferior à média")
	check(snapshot.has("memory_static_bytes"), "snapshot expõe memória estática")
	check(snapshot.has("process_time_ms_last_sample"), "snapshot expõe tempo de processamento")
	check(snapshot.has("draw_calls_last_sample"), "snapshot expõe draw calls")
	return true


func test_probe_reset_clears_the_frame_window() -> bool:
	var probe: Node = _probe()
	check(probe != null, "autoload PerformanceProbe presente")
	if probe == null or not OS.is_debug_build():
		return true
	probe.call("reset")
	var snapshot: Dictionary = probe.call("get_snapshot")
	check_eq(snapshot.get("sample_count", -1), 0, "reset limpa quantidade de amostras")
	check_eq(snapshot.get("frame_time_ms_avg", -1.0), 0.0, "reset zera média")
	check_eq(snapshot.get("frame_time_ms_p95", -1.0), 0.0, "reset zera percentil")
	return true



func test_probe_ring_buffer_retains_latest_600_samples() -> bool:
	var probe: Node = _probe()
	check(probe != null, "autoload PerformanceProbe presente")
	if probe == null or not OS.is_debug_build():
		return true

	probe.call("reset")
	# Injeção determinística de 605 deltas: a janela deve reter somente os valores 6..605 ms.
	for frame_index: int in range(1, 606):
		probe.call("_process", float(frame_index) / 1000.0)

	var snapshot: Dictionary = probe.call("get_snapshot")
	check_eq(snapshot.get("sample_count", 0), 600, "buffer permanece limitado após overflow")
	check_eq(snapshot.get("sample_capacity", 0), 600, "capacidade declarada permanece constante")
	check(is_equal_approx(float(snapshot.get("frame_time_ms_avg", 0.0)), 305.5), "média considera somente os últimos 600 valores")
	check(is_equal_approx(float(snapshot.get("frame_time_ms_p95", 0.0)), 575.0), "p95 usa nearest-rank sobre a janela ordenada")
	check(is_equal_approx(float(snapshot.get("frame_time_ms_p99", 0.0)), 599.0), "p99 usa nearest-rank sobre a janela ordenada")
	check(is_equal_approx(float(snapshot.get("frame_time_ms_max", 0.0)), 605.0), "máximo exclui a amostra descartada")
	return true


func test_probe_records_scene_flow_transition_outcomes_and_bounded_history() -> bool:
	var probe: Node = _probe()
	var flow: Node = tree.root.get_node_or_null("SceneFlow")
	check(probe != null and flow != null, "PerformanceProbe e SceneFlow estão registrados")
	if probe == null or flow == null or not OS.is_debug_build():
		return true

	probe.call("reset")
	var success_path: String = "res://telemetry_success.tscn"
	var cancelled_path: String = "res://telemetry_cancelled.tscn"
	var failed_path: String = "res://telemetry_failed.tscn"

	flow.emit_signal("transition_started", success_path)
	flow.emit_signal("transition_finished", success_path)
	flow.emit_signal("transition_started", cancelled_path)
	flow.emit_signal("transition_cancelled", cancelled_path)
	flow.emit_signal("transition_started", failed_path)
	flow.emit_signal("transition_failed", failed_path, "test_failure")

	var snapshot: Dictionary = probe.call("get_snapshot")
	var history: Array = snapshot.get("transition_history", [])
	check_eq(snapshot.get("transition_sample_count", 0), 3, "telemetria registra sucesso, cancelamento e falha")
	check_eq(history.size(), 3, "histórico mantém os três eventos concluídos")
	if history.size() == 3:
		check_eq(history[0].get("outcome", ""), "success", "resultado de transição concluída é identificado")
		check_eq(history[1].get("outcome", ""), "cancelled", "resultado de transição cancelada é identificado")
		check_eq(history[2].get("outcome", ""), "failed", "resultado de transição com falha é identificado")
		check_eq(history[2].get("path", ""), failed_path, "registro preserva o caminho da cena")
		check(float(history[2].get("duration_ms", -1.0)) >= 0.0, "duração de transição nunca é negativa")
		check(history[2].has("memory_static_before_bytes"), "registro captura memória estática antes da transição")
		check(history[2].has("memory_static_after_bytes"), "registro captura memória estática depois da transição")
	check_eq(snapshot.get("transition_last_outcome", ""), "failed", "snapshot destaca o resultado mais recente")
	check_eq(snapshot.get("transition_last_path", ""), failed_path, "snapshot destaca o destino mais recente")
	check(float(snapshot.get("transition_duration_ms_p95", -1.0)) >= 0.0, "p95 de transições é calculado sob demanda")

	probe.call("reset")
	snapshot = probe.call("get_snapshot")
	check_eq(snapshot.get("transition_sample_count", -1), 0, "reset limpa o histórico de transições")
	check((snapshot.get("transition_history", []) as Array).is_empty(), "reset não mantém registros antigos")
	return true


func test_probe_transition_history_is_bounded_to_32_records() -> bool:
	var probe: Node = _probe()
	var flow: Node = tree.root.get_node_or_null("SceneFlow")
	check(probe != null and flow != null, "PerformanceProbe e SceneFlow estão disponíveis para limite do histórico")
	if probe == null or flow == null or not OS.is_debug_build():
		return true

	probe.call("reset")
	for index: int in range(40):
		var path: String = "res://telemetry_%02d.tscn" % index
		flow.emit_signal("transition_started", path)
		flow.emit_signal("transition_finished", path)
	var snapshot: Dictionary = probe.call("get_snapshot")
	var history: Array = snapshot.get("transition_history", [])
	check_eq(snapshot.get("transition_sample_count", 0), 32, "histórico limita retenção às 32 transições mais recentes")
	check_eq(history.size(), 32, "snapshot não expõe mais de 32 registros")
	if history.size() == 32:
		check_eq(history[0].get("path", ""), "res://telemetry_08.tscn", "overflow descarta somente os registros mais antigos")
		check_eq(history[31].get("path", ""), "res://telemetry_39.tscn", "último registro preservado é o mais recente")
	probe.call("reset")
	return true
