# ADR-0003 — Política imersiva das barras do sistema Android

- **Status:** Aprovada
- **Data de registro:** 2026-11-11
- **Escopo:** apresentação Android, barras do sistema e configuração de tela

## Contexto

O jogo é destinado a Android em orientação paisagem. A experiência deve ocupar a tela do aparelho sem deixar permanentemente visíveis a barra de status e a barra de navegação. O requisito não se limita a um modo de tela cheia opcional.

## Decisão

- Manter a barra de status e a barra de navegação do Android ocultas por política imersiva durante a experiência do jogo, inclusive quando a opção de Tela cheia da interface do jogo estiver desligada.
- A opção/configuração de Tela cheia permanece **DESLIGADA**; não criar alternância que modifique essa decisão sem aprovação explícita.
- Tratar a política como comportamento de apresentação do aplicativo, não como alteração de gameplay, física, movimento, controles touch, sprites, fases, áudio ou salvamento.
- Usar as APIs e configurações compatíveis com a versão Android/Godot escolhida. O sistema operacional pode revelar temporariamente barras por gestos, políticas de segurança ou comportamento específico do dispositivo; não prometer ocultação absoluta em todas as circunstâncias.
- Manter controles essenciais fora das regiões de gestos do sistema e respeitar recortes e áreas seguras.
- Validar entrada/saída de imersão, foco, pausa, retomada e diferentes proporções em aparelhos reais.

## Consequências

- A implementação deve ser consistente entre as telas do jogo, não apenas durante uma cena marcada como fullscreen.
- A UI deve considerar insets e regiões de gestos mesmo com as barras ocultas.
- A opção Tela cheia deve permanecer desligada e não deve ser ativada automaticamente.
- Qualquer mudança futura exige novo ADR e aprovação explícita.
