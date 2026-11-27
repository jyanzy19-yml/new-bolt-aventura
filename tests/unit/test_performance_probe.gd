extends BoltTest
## Contratos da instrumentação de performance em builds de desenvolvimento.


func _probe() -> Node:
	return tree.root.get_node_or_null("PerformanceProbe")


func test_probe_is_registered_and_debug_gated() -> bool:
	var probe: Node = _probe()
	check(probe != null, "autoload PerformanceProbe presente")
	if probe == null:
		return true
	check_eq(probe.SAMPLE_CAPACITY, 600, "janela mantém capacidade limitada de 600 amostras")
	if not OS.is_debug_build():
		check(not probe.is_enabled(), "instrumentação permanece desativada fora de build debug")
		check(not probe.set_enabled(true), "build não-debug rejeita ativação")
	else:
		check(probe.is_enabled(), "instrumentação é habilitada em build debug")
	return true


func test_probe_collects_frame_time_and_calculates_percentiles() -> bool:
	var probe: Node = _probe()
	check(probe != null, "autoload PerformanceProbe presente")
	if probe == null or not OS.is_debug_build():
		return true

	probe.reset()
	await tree.process_frame
	await tree.process_frame
	await tree.process_frame
	var snapshot: Dictionary = probe.get_snapshot()
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
	probe.reset()
	var snapshot: Dictionary = probe.get_snapshot()
	check_eq(snapshot.get("sample_count", -1), 0, "reset limpa quantidade de amostras")
	check_eq(snapshot.get("frame_time_ms_avg", -1.0), 0.0, "reset zera média")
	check_eq(snapshot.get("frame_time_ms_p95", -1.0), 0.0, "reset zera percentil")
	return true
