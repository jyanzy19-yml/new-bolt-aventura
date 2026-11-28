# Perfil de performance Android — BOLT · AVENTURA

## Hardware-alvo
Referência de produto: Android com aproximadamente 4 GB de RAM e MediaTek Helio G99 ou inferior. A meta é aproximar 60 FPS quando o aparelho e a carga sustentarem; não é garantia universal.

## Métricas obrigatórias
Registrar aparelho, SoC, RAM, Android, WebView/Chrome, resolução, DPR, build/commit, temperatura inicial, duração e cenário. Medir:
- frame time p50/p95/p99 e spikes;
- input-to-action latency;
- memória JS e pressão de memória quando observável;
- tempo de boot e loading;
- decode de imagem/áudio;
- tamanho do bundle e assets;
- comportamento após 10–20 minutos de sessão;
- throttling térmico e retomada após background.

## Orçamento inicial — metas de engenharia, não medições
Os números concretos devem ser propostos após o primeiro vertical slice e perfil de aparelhos. Até lá, não inventar limites absolutos de memória ou draw calls. Registrar baseline antes de otimizar.

## Áreas de custo
- backing store do Canvas e DPR;
- resolução interna versus CSS;
- overdraw e transparências;
- filtros, sombras e gradientes;
- partículas e projéteis;
- alocações temporárias em hot paths;
- parsing e decodificação durante gameplay;
- consultas de colisão e buscas de entidades;
- áudio simultâneo;
- lifecycle e retomada.

## Protocolo antes/depois
1. Fixar build e cenário reprodutível.
2. Aquecer o runtime de forma documentada.
3. Capturar baseline.
4. Alterar uma variável por vez.
5. Repetir cenário e duração.
6. Comparar p50/p95/p99, spikes, memória e input latency.
7. Rejeitar otimização que degrada física, controle, legibilidade ou conteúdo sem aprovação.

Não usar FPS instantâneo isolado como prova de estabilidade.
