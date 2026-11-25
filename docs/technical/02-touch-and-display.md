# Especificação Android — input touch, tela e áreas seguras

## 1. Input abstrato
O gameplay deve consumir ações lógicas, não depender diretamente de um único tipo de dispositivo. A versão Android usa touch como entrada prioritária. Teclado/gamepad podem servir como dispositivos auxiliares de desenvolvimento e acessibilidade quando aprovados.

## 2. Requisitos de controles
- Movimento, salto, dash e demais ações essenciais têm bindings claros.
- Multitouch simultâneo deve ser testado: movimento + salto + dash, incluindo pressionar e soltar em ordens diferentes.
- Não perder eventos por quedas momentâneas de FPS: avaliar input buffering e consumo no tick de física.
- Evitar que um toque de UI fique preso após pausa, troca de cena, interrupção do app ou saída do dedo da área do botão.
- Definir prioridade para ações simultâneas e feedback de estado.
- Separar estado visual do botão do estado lógico da ação.
- Testar toque rápido, prolongado, repetido e arrasto.
- Garantir que pausa/configurações não deixem comandos de gameplay ativos por trás.

## 3. Orientação e proporção
A orientação oficial do produto é **paisagem**. Configurar o projeto Android para essa orientação e testar proporções comuns e telas alongadas; não distorcer o mundo para preencher espaço. Definir política de letterbox, câmera, UI e áreas extras sem alterar a orientação do dispositivo.

## Decisão de exibição aprovada

Consultar também `docs/decisions/ADR-0003-android-system-bars.md`. A política de produto aprovada é manter as barras de status e navegação do Android ocultas de forma imersiva durante a experiência do jogo, inclusive fora de uma opção de tela cheia; a opção/configuração de Tela cheia permanece DESLIGADA. Não adicionar um toggle que reative ou altere essa decisão sem aprovação. A implementação deve usar as APIs Android/Godot compatíveis com a versão escolhida e reconhecer que o sistema operacional pode revelar barras temporariamente por gestos ou políticas próprias. Nunca posicionar controles essenciais em áreas reservadas a gestos do sistema.

## 4. Barras do sistema e recortes
O requisito do projeto é tratar barra de status, barra de navegação e recortes de tela de forma intencional, inclusive quando a experiência for imersiva. O comportamento exato depende da versão Android, API, configuração do app e dispositivo.

- Separar conteúdo visual que pode se estender da área segura onde botões precisam ser tocáveis.
- Não colocar ações essenciais sob barras, recortes ou regiões de gestos do sistema.
- Não afirmar que o app cobre barras em todos os aparelhos sem validar.
- Testar modo imersivo, barras visíveis e retorno de foco conforme decisão aprovada.
- Verificar mudanças de comportamento entre versões Android e fabricantes.

## 5. Testes de interrupção
Testar chamada/notificação, troca de app, bloqueio/desbloqueio, pausa, retomada, rotação se suportada, perda de foco e retorno. Nenhum estado de input deve ficar preso.

## 6. Critério de aprovação
Controles essenciais funcionam consistentemente em multitouch; layout respeita safe areas; barras e recortes são tratados conforme decisão aprovada; interrupções não causam input fantasma, softlock ou perda de progresso.
