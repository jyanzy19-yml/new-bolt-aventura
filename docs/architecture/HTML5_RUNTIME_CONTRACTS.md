# Contratos do Runtime HTML5 — BOLT · AVENTURA

**Status:** proposta técnica inicial para revisão. Não é autorização para construir todos os módulos de uma vez.

## Princípios
- Browser APIs ficam nas bordas de plataforma; regras de domínio permanecem testáveis.
- Simulação, input, renderização, UI e persistência têm ownership explícito.
- Um único loop coordenador governa o runtime ativo.
- Nenhum módulo deve importar o bootstrap da aplicação.
- Dependências apontam para contratos estáveis; evitar ciclos.
- Estado autoritativo não deve ser alterado pelo renderer.

## Boot e lifecycle
Estados a especificar: BOOTING, LOADING, READY, RUNNING, PAUSED, SUSPENDED, TRANSITIONING, ERROR e DISPOSED. Transições explícitas, idempotência quando apropriado e testes são obrigatórios. Toda inscrição em eventos precisa de rotina de descarte. Pause/resume deve preservar input, áudio, relógio e save.

## Loop e relógio
Separar simulação e render. Avaliar timestep fixo para física, accumulator com limite de catch-up e clamp de delta após suspensão. Não simular todo o tempo perdido em background. O relógio deve ser injetável em testes. Render não aplica física.

## Input
Capturar Pointer Events na origem, preservar pointerId e distinguir press, release, cancel e perda de foco. Converter eventos em ações sem perder edges entre frames. Movimento contínuo e ações discretas têm semânticas próprias. Jump e Dash não podem depender apenas de polling no frame de render. Multitouch deve suportar movimento e ação simultâneos.

## Renderização Canvas
Renderer controla context, backing store, DPR limitado por orçamento de memória, resize e clear. Resolução CSS e interna são diferentes. Preservar proporção de gameplay e safe area. Evitar alocações em loops quentes, leituras de layout por frame, filtros caros e resize repetido.

## Assets, áudio e persistência
Assets usam IDs estáveis e manifest versionado. Loader precisa de progresso real, cancelamento/erro e liberação. Web Audio precisa de unlock por gesto, buses, limite de vozes e lifecycle. Save separa estado transitório, checkpoint e campanha; schema versionado, validação, migração e recuperação.

## Interfaces e gate
Definir interfaces pequenas para Input → Gameplay, Gameplay → Presentation, Level → Entities, Campaign → Persistence, Audio → Platform e Runtime → Lifecycle. Antes de expandir, aprovar diagrama de dependências, owners, lifecycle, input contract, timestep policy, save schema, asset manifest e testes.
