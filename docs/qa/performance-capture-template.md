# Captura de performance — BOLT

**Protocolo:** [Profiling Android — Etapa 29](android-performance-profiling-protocol.md)

> Preencher uma cópia por cenário e repetição. Não estimar valores ausentes: usar **NÃO MEDIDO**. Preservar os relatórios individuais; não substituir dados brutos por médias agregadas.

## Identificação
- Commit:
- APK / SHA-256:
- Build (debug/release):
- Versão Godot:
- Renderer:
- Cenário (P0–P5 ou justificativa):
- Cena e sequência reproduzível:
- Duração efetiva:
- Repetição (ex.: 1/3):
- Aparelho/modelo:
- SoC / GPU / RAM:
- Android / nível de API:
- Resolução / taxa de atualização / orientação:
- Condição térmica inicial/final:
- Energia (carregando ou bateria):
- Ferramenta externa e configuração:

## PerformanceProbe
- Número de amostras:
- Frame time médio:
- p95:
- p99:
- Máximo:
- FPS derivado da média (não usar isoladamente):
- Tempo de processamento:
- Tempo de física:
- Memória estática Godot:
- Objetos / nós:
- Draw calls / render objects:

## Métricas externas Android
- CPU:
- GPU frame time:
- RSS/PSS:
- Heap:
- Memória gráfica:
- Pico de memória:
- Temperatura:
- Throttling:
- Energia:
- Latência de toque (método, taxa e incerteza):

## Método
- Estado inicial do processo:
- VSync / frame cap:
- Passos exatos:
- Duração por trecho:
- Número de repetições:
- Condições controladas:
- Eventos/interrupções:

## Resultado
- Gargalo demonstrado:
- Evidência que sustenta o diagnóstico:
- Hipótese causal:
- Alteração aplicada (ou nenhuma):
- Comparação antes/depois:
- Efeitos colaterais:
- Regressões funcionais:
- Limitações / campos NÃO MEDIDOS:
- Próxima medição:

## Integridade
- [ ] Mesmo aparelho/configuração do baseline comparado
- [ ] Mesmo cenário, sequência e duração
- [ ] Condição térmica registrada
- [ ] Valores brutos preservados
- [ ] Métricas com definições distintas não foram misturadas
- [ ] Testes funcionais de input executados separadamente
- [ ] Nenhum resultado foi inferido a partir de APK/CI/headless
