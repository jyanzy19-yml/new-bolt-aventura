# Etapa 29 — telemetria de duração das transições de cena

**Data:** 27/11/2026  
**Branch:** `perf/stage29-transition-telemetry-2026-11-27`  
**Base:** main após merge da PR #110  
**Tipo:** instrumentação debug-only e regressões; sem alteração de gameplay.

## 1. Objetivo

Tornar observável a duração real das transições já coordenadas por `SceneFlow`, complementando o `PerformanceProbe` para que futuras decisões de preload, cache ou liberação possam partir de medições e não de suposições.

## 2. Alterações

- `PerformanceProbe` observa os sinais existentes de início, conclusão, falha e cancelamento de `SceneFlow`.
- Registra caminho da cena, resultado, duração baseada em relógio monotônico e `MEMORY_STATIC` antes/depois.
- Mantém janela limitada de 32 transições.
- Calcula p95 da duração somente quando `get_snapshot()` é solicitado.
- Mantém a instrumentação restrita a builds debug.

## 3. Limites e preservação

- Não altera o fluxo de carregamento, cancelamento, pausa, concorrência, cache ou troca de cenas.
- Não mantém referências a `PackedScene`, `Resource` ou `Node`.
- Não adiciona preload, unload, purge, pooling ou cache manager.
- Não executa ordenação nem alocação do histórico no loop de frame.
- `MEMORY_STATIC` não representa RSS do processo e não prova recuperação de memória.
- Nenhuma mudança em física, Dash, InputMap, save schema, IDs, progressão, canon, assets ou cenas de gameplay.

## 4. Regressões

1. Resultado de transição concluída registrado como `success`.
2. Cancelamento lógico registrado como `cancelled`.
3. Falha registrada como `failed`.
4. Duração não negativa e caminho preservado.
5. Monitores de memória antes/depois presentes.
6. p95 calculado sob demanda.
7. `reset()` limpa histórico e janela ativa.
8. Histórico retém no máximo 32 entradas e descarta as mais antigas.

## 5. Critérios de aceite

- Godot 4.7.2 Validation: SUCCESS.
- Documentation Validation: SUCCESS.
- Android Debug Export: SUCCESS.
- Diff restrito a instrumentação, testes e documentação.
- Nenhuma alegação de medição física ou ganho de performance sem captura em dispositivo identificado.

## 6. Pendências fora desta unidade

A Etapa 29 permanece EM ANDAMENTO até capturas comparáveis em Android físico, incluindo cold boot, entrada/saída/reentrada de fase, frame time p95/p99, RSS do processo, GPU quando disponível e condição térmica. O baseline auditado não justifica preload global nem unload forçado.
