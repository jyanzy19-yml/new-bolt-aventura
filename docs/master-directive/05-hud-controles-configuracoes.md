# Parte 05 — HUD, touchscreen e configurações

## 18. HUD e interface no gameplay

HUD claro, elegante e legível, com vida, arma selecionada, munição/recurso somente se aplicável, progresso relevante, pausa e elementos contextuais. Evitar excesso de informação. Respeitar proporção da tela e áreas seguras Android.

### 18.1. Pausa

Pausar deve interromper corretamente gameplay, inimigos e física. Opções: continuar, reiniciar fase com tratamento seguro, retornar ao menu e configurações disponíveis. Não deixar mundo ativo atrás do menu.

## 19. Controles touchscreen — prioridade máxima

Controles: analógico virtual, pulo, disparo, troca de arma, interação e pausa. Suportar multitouch para mover+pular, mover+disparar, pular+disparar e corrigir movimento no ar.

Requisitos: resposta imediata; áreas de toque adequadas; feedback visual e som opcional; sem conflitos; detecção confiável; múltiplas proporções de tela; personalização de posição, escala e transparência.

Os comandos devem continuar confiáveis durante pequenas oscilações de desempenho. Leitura de input não pode depender de animações ou processamento visual pesado. O pulo tem prioridade de resposta. Overlays não podem capturar toques destinados aos controles. Não adicionar botões de voo, parry ou Dash.

## 20. Menus e configurações

Interface completa com:

**Vídeo:** ECO, NORMAL, ALTO e ULTRA. Perfis devem afetar somente qualidade gráfica e custo de renderização, nunca física, hitboxes, precisão, velocidade ou progressão.

**Áudio:** volume geral, música e efeitos sonoros.

**Controles:** posição dos botões, tamanho, transparência e sensibilidade do analógico.

**Geral:** idioma (inicialmente português brasileiro), pausa automática e acessibilidade; incluir redução de efeitos visuais quando necessário.

Salvar as configurações. Garantir que alterações não invalidem gameplay nem causem perda de estado.
