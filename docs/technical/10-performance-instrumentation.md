# Instrumentação de performance — builds de desenvolvimento

## Objetivo

Disponibilizar uma captura local e reproduzível de frame time e monitores de runtime durante a Etapa 05, sem introduzir HUD de diagnóstico, dependência de gameplay ou coleta contínua em builds release.

## Implementação

`PerformanceProbe` é um autoload técnico independente, implementado em `scripts/core/performance_probe.gd`.

- Ativa-se somente quando `OS.is_debug_build()` retorna `true`; builds não-debug rejeitam ativação explícita.
- Mantém uma janela circular limitada a 600 amostras de `delta`, expressas em milissegundos.
- Calcula média, p95, p99, máximo e FPS derivado da média somente quando `get_snapshot()` é solicitado; não ordena amostras no loop de frame.
- A cada 30 frames, captura monitores de memória estática, contagem de objetos/nós, draw calls, objetos renderizados e tempos de processamento/physics reportados pelo Godot.
- `reset()` limpa a janela sem modificar estado de gameplay.
- `set_enabled(false)` interrompe a coleta; `set_enabled(true)` só é aceito em build debug.

## API

```gdscript
var metrics: Dictionary = PerformanceProbe.get_snapshot()
print(metrics["frame_time_ms_p95"])
print(metrics["memory_static_bytes"])
PerformanceProbe.reset()
```

Campos principais: `sample_count`, `frame_time_ms_avg`, `frame_time_ms_p95`, `frame_time_ms_p99`, `frame_time_ms_max`, `fps_from_average`, `process_time_ms_last_sample`, `physics_process_time_ms_last_sample`, `memory_static_bytes`, `object_count`, `node_count`, `draw_calls_last_sample` e `render_objects_last_sample`.

## Interpretação e limites

- `delta` mede o intervalo observado entre frames; não deve ser interpretado como tempo puro de CPU ou GPU.
- `TIME_PROCESS` e `TIME_PHYSICS_PROCESS` são monitores do engine e não fornecem profiling detalhado por função.
- `MEMORY_STATIC` não equivale à memória RSS total do processo Android nem mede VRAM/GPU de forma completa.
- Draw calls e objetos renderizados são amostras pontuais a cada 30 frames.
- O probe não mede temperatura, throttling, consumo energético, latência touch, picos de alocação por função ou GPU frame time.
- Headless CI valida o contrato e a execução do código, não a performance de um dispositivo físico.

## Procedimento de captura

1. Executar uma build debug no aparelho Android identificado.
2. Reproduzir a mesma cena e sequência durante a janela de captura.
3. Consultar `PerformanceProbe.get_snapshot()` por um harness/script de diagnóstico temporário; a implementação não adiciona interface de profiling ao produto.
4. Registrar commit, build, aparelho/SoC/RAM, Android, renderer, resolução, duração e condição térmica no template `docs/qa/performance-capture-template.md`.
5. Repetir a sequência antes/depois de qualquer otimização. Não alterar parâmetros de gameplay com base apenas em uma captura isolada.

A existência do probe não declara que o jogo já foi perfilado nem que a meta de 60 FPS foi atingida.
