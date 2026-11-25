# BOLT · AVENTURA — UI/UX, menus e acessibilidade

## 1. Princípios
A interface deve ser legível em tela de celular, consistente entre menus e gameplay, navegável por touch e não encobrir informação crítica. A estética deve apoiar a identidade do jogo sem reduzir clareza.

## 2. Fluxos previstos
- Inicialização e carregamento.
- Menu principal.
- Novo jogo / continuar.
- Seleção de mundo/fase, se aprovada.
- HUD de gameplay.
- Pausa e retomada.
- Configurações.
- Diálogo/interação.
- Tela de conclusão e resultados.
- Salvamento, falha e retorno ao menu.

Cada fluxo deve definir entrada, saída, foco inicial, ação principal, ações secundárias, cancelamento e comportamento de save/load.

## 3. HUD
Exibir somente informações necessárias ao estado atual. Definir prioridade, persistência, animação, feedback de dano/recarga e comportamento em cutscenes. Evitar excesso de texto e ícones sem rótulo compreensível.

## 4. Controles touch
- Botões essenciais com área de toque confortável.
- Estados visuais: normal, pressionado, desabilitado e indisponível.
- Multitouch testado, especialmente movimento + salto + dash.
- Layout configurável quando viável.
- Não depender exclusivamente de gestos pouco descobertos.
- Evitar que botões fiquem sob recortes, barras do sistema ou gestos do Android.
- Garantir que eventos de toque terminem corretamente em pausa, troca de cena ou perda de foco.

## 5. Tela e áreas seguras
Separar área de jogo, área de interface e área de sistema. Decidir explicitamente se a experiência usa modo imersivo, barras visíveis ou política híbrida. A escolha deve ser validada no Android real; não assumir que o app pode desenhar sobre barras em todos os aparelhos/versões.

## 6. Acessibilidade
Considerar tamanho de texto, contraste, legendas, controles alternativos, remapeamento quando suportado, volume independente, redução de screen shake/flashes e opções de dificuldade quando aprovadas. Não usar somente cor para comunicar estado.

## 7. QA de interface
Testar telas estreitas e largas, proporções extremas, orientação definida para o jogo, safe areas, recortes, toque rápido e prolongado, multitouch, navegação de menu, foco, pausa, mudança de app e retomada.
