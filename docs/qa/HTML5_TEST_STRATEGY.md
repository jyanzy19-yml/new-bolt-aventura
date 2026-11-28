# Estratégia de testes — HTML5 / Canvas / Android

## Camadas de evidência
1. **Unitário:** matemática, relógio, buffers, serialização e regras isoladas.
2. **Integração:** contratos entre input, gameplay, colisão, progressão, save e áudio.
3. **Browser automation:** boot, navegação, canvas, loading, pause/resume e erros.
4. **Build/CI:** lint, testes e build de produção.
5. **Manual browser:** leitura visual, game feel, touch e transições.
6. **Android físico:** WebView, orientação, safe area, barras do sistema, lifecycle, multitouch, áudio e performance sustentada.

Nenhuma camada substitui a seguinte.

## Matriz mínima
| Área | Cenários |
|---|---|
| Runtime | boot, erro, pause, resume, dispose, repeated start/stop |
| Clock | delta alto, aba oculta, catch-up limit, clock injected |
| Input | press/release/cancel, pointerId, multitouch, lost focus |
| Gameplay | jump buffer, coyote, Dash, colisão, dano, morte, respawn |
| Physics | cantos, one-way, moving platforms, tunneling |
| Camera | limites, transição, resize, aspect ratios |
| Loading | sucesso, falha, retry, cancelamento, concorrência |
| Assets | missing, corrupt, decode fail, oversized, duplicate IDs |
| Audio | unlock, mute, pause/resume, voice limit, interrupted context |
| Save | round-trip, corrupt, future schema, migration, duplicate rewards |
| UI | navigation, focus, touch targets, safe area, back/cancel |
| Android | background/foreground, rotation policy, bars, WebView |

## Regras
- Determinismo sempre que possível; injetar clock e random.
- Evitar sleeps arbitrários; sincronizar por estado/condição.
- Cada bug corrigido recebe teste de regressão.
- Testes não compartilham saves persistentes sem isolamento.
- Reportar comando, ambiente, duração e resultado.
- CI verde não prova game feel nem comportamento em aparelho físico.
