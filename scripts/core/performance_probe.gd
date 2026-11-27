extends Node
## Instrumentação leve de frame time e monitores de runtime para builds de desenvolvimento.
## Não é um profiler de GPU nem substitui medições em aparelho Android físico.

const SAMPLE_CAPACITY: int = 600
const RESOURCE_SAMPLE_INTERVAL: int = 30

var _enabled: bool = false
var _frame_times_ms: PackedFloat32Array = PackedFloat32Array()
var _write_index: int = 0
var _sample_count: int = 0
var _frames_since_resource_sample: int = 0

var _memory_static_bytes: int = 0
var _object_count: int = 0
var _node_count: int = 0
var _draw_calls: int = 0
var _render_objects: int = 0
var _process_time_ms: float = 0.0
var _physics_process_time_ms: float = 0.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_enabled(OS.is_debug_build())


## Ativa a coleta somente em builds de desenvolvimento/debug.
## Retorna false quando a build não permite instrumentação.
func set_enabled(value: bool) -> bool:
	if value and not OS.is_debug_build():
		return false
	_enabled = value
	if _enabled and _frame_times_ms.is_empty():
		_frame_times_ms.resize(SAMPLE_CAPACITY)
		_sample_resource_monitors()
	set_process(_enabled)
	return true


func is_enabled() -> bool:
	return _enabled


func _process(delta: float) -> void:
	if not _enabled or delta <= 0.0:
		return

	_frame_times_ms[_write_index] = delta * 1000.0
	_write_index = (_write_index + 1) % SAMPLE_CAPACITY
	_sample_count = mini(_sample_count + 1, SAMPLE_CAPACITY)

	_frames_since_resource_sample += 1
	if _frames_since_resource_sample >= RESOURCE_SAMPLE_INTERVAL:
		_frames_since_resource_sample = 0
		_sample_resource_monitors()


func _sample_resource_monitors() -> void:
	_memory_static_bytes = int(Performance.get_monitor(Performance.MEMORY_STATIC))
	_object_count = int(Performance.get_monitor(Performance.OBJECT_COUNT))
	_node_count = int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT))
	_draw_calls = int(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME))
	_render_objects = int(Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME))
	_process_time_ms = Performance.get_monitor(Performance.TIME_PROCESS) * 1000.0
	_physics_process_time_ms = Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS) * 1000.0


## Retorna uma fotografia calculada sob demanda; a ordenação nunca ocorre no loop de frame.
func get_snapshot() -> Dictionary:
	var samples: Array[float] = []
	for index: int in range(_sample_count):
		samples.append(_frame_times_ms[index])
	samples.sort()

	var total_ms: float = 0.0
	var max_ms: float = 0.0
	for sample_ms: float in samples:
		total_ms += sample_ms
		max_ms = maxf(max_ms, sample_ms)

	var average_ms: float = total_ms / float(_sample_count) if _sample_count > 0 else 0.0
	return {
		"enabled": _enabled,
		"sample_count": _sample_count,
		"sample_capacity": SAMPLE_CAPACITY,
		"frame_time_ms_avg": average_ms,
		"frame_time_ms_p95": _percentile(samples, 0.95),
		"frame_time_ms_p99": _percentile(samples, 0.99),
		"frame_time_ms_max": max_ms,
		"fps_from_average": 1000.0 / average_ms if average_ms > 0.0 else 0.0,
		"process_time_ms_last_sample": _process_time_ms,
		"physics_process_time_ms_last_sample": _physics_process_time_ms,
		"memory_static_bytes": _memory_static_bytes,
		"object_count": _object_count,
		"node_count": _node_count,
		"draw_calls_last_sample": _draw_calls,
		"render_objects_last_sample": _render_objects,
	}


func _percentile(sorted_samples: Array[float], percentile: float) -> float:
	if sorted_samples.is_empty():
		return 0.0
	var index: int = clampi(int(ceil(float(sorted_samples.size()) * percentile)) - 1, 0, sorted_samples.size() - 1)
	return sorted_samples[index]


## Limpa a janela de frame time sem alterar o estado de execução do jogo.
func reset() -> void:
	_write_index = 0
	_sample_count = 0
	_frames_since_resource_sample = 0
	if not _frame_times_ms.is_empty():
		_frame_times_ms.fill(0.0)
	if _enabled:
		_sample_resource_monitors()
