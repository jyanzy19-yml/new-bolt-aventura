# Parte 08 — Android, performance e carregamento

## 25. Performance Android

Alvo: Android com aproximadamente 4 GB RAM e MediaTek Helio G99 ou inferior, incluindo intermediários e superiores. Meta de 60 FPS quando sustentável pelo aparelho, sem prometer desempenho universal.

### 25.1. Métricas

Registrar FPS médio, P50/P95/P99, frame time, picos de processamento, memória, tempo de carregamento e comportamento térmico quando disponível. Referências: 60 FPS = 16,67 ms/frame; 30 FPS = 33,33 ms/frame.

### 25.2. Otimização

Medir CPU, GPU, RAM, texturas, animações, partículas, física, IA, loading, frame pacing, bateria e temperatura. Avaliar object pooling, atlas, visibility culling, limites de partículas, liberação de recursos, carregamento assíncrono e redução de processamento desnecessário.

Não otimizar por intuição. Medir antes/depois, registrar cenário, aparelho, build, duração, configurações e metodologia. Otimização não pode alterar física, hitboxes, resposta de input ou identidade visual aprovada sem decisão explícita.

### 25.3. Renderização

Avaliar Mobile e Compatibility conforme compatibilidade Android, estabilidade, performance e recursos gráficos realmente usados. Escolher com evidência, não por parecer mais avançado.

### 25.4. Loading

Criar loading profissional com identidade visual, progresso quando possível, preparação dos recursos, liberação de recursos antigos e carregamento controlado. Evitar travamentos durante gameplay. Não adicionar espera artificial: o objetivo é deslocar trabalho pesado para transições e evitar hitching em execução.

## 26. Android e comportamento do aplicativo

Tratar orientação paisagem, proporções, recortes, safe areas, edge-to-edge, barras de status/navegação, multitouch, ciclo de vida, pausa/retomada, interrupções, perda de foco e áudio em segundo plano.

A interface deve funcionar em diferentes telas. Usar área disponível inclusive próxima às barras do sistema quando permitido; não depender apenas do fullscreen para tratar barras. Não ocultar indevidamente elementos Android e não deixar barras/recortes cobrirem botões essenciais. Testar em dispositivos reais quando possível e registrar limitações quando não for.
