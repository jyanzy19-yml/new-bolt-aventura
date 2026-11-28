# Perfil de performance Android — BOLT · AVENTURA

## Hardware-alvo
Referência: Android com aproximadamente 4 GB de RAM e MediaTek Helio G99 ou inferior. Meta próxima de 60 FPS quando aparelho e carga sustentarem; não é garantia universal.

## Métricas
Registrar aparelho, SoC, RAM, Android, WebView/Chrome, resolução, DPR, build/commit, temperatura inicial, duração e cenário. Medir:
- frame time p50/p95/p99 e spikes;
- input-to-action latency;
- memória JS e pressão de memória quando observável;
- tempo de boot/loading;
- decode de imagem/áudio;
- tamanho do bundle e assets;
- comportamento após 10–20 minutos;
- throttling térmico e retomada após background.

## Orçamento inicial
Os números concretos serão definidos após o primeiro vertical slice e perfil de aparelhos. Não inventar limites absolutos de memória ou draw calls. Registrar baseline antes de otimizar.

## Áreas de custo
Backing store/DPR, overdraw, transparências, filtros, partículas, projéteis, alocações em hot paths, parsing/decodificação durante gameplay, colisões, buscas de entidades, áudio simultâneo e lifecycle.

## Protocolo antes/depois
1. Fixar build e cenário reprodutível.
2. Aquecer o runtime de forma documentada.
3. Capturar baseline.
4. Alterar uma variável por vez.
5. Repetir cenário e duração.
6. Comparar p50/p95/p99, spikes, memória e input latency.
7. Rejeitar otimização que degrade física, controle, legibilidade ou conteúdo sem aprovação.

FPS instantâneo isolado não comprova estabilidade.
