# Contratos do Runtime HTML5 — BOLT · AVENTURA

**Status:** proposta técnica inicial para revisão. Não é autorização para construir todos os módulos de uma vez.

## 1. Princípios
- Browser APIs ficam nas bordas de plataforma; regras de domínio permanecem testáveis.
- Simulação, input, renderização, UI e persistência têm ownership explícito.
- Um único loop coordenador governa o runtime ativo.
- Nenhum módulo deve importar o bootstrap de aplicação.
- Dependências apontam para contratos estáveis; evitar ciclos.
- Estado autoritativo não deve ser alterado pelo renderer.

## 2. Boot e lifecycle
Estados mínimos a especificar: BOOTING, LOADING, READY, RUNNING, PAUSED, SUSPENDED, TRANSITIONING, ERROR e DISPOSED. As transições devem ser explícitas, idempotentes quando apropriado e cobertas por testes.

O boot deve validar recursos críticos, registrar listeners e expor falhas compreensíveis. Toda inscrição em eventos precisa de rotina de descarte. Pause/resume deve preservar consistência de input, áudio, relógio e save.

## 3. Loop e relógio
Separar passo de simulação e render. Avaliar timestep fixo para física, accumulator com limite de catch-up e clamp de delta após suspensão. Não tentar simular todo o tempo perdido em background. O relógio deve ser injetável em testes.

O render não pode aplicar física. A política de pausa, slow device, aba oculta, throttling e retomada precisa ser documentada.

## 4. Input
Capturar eventos de Pointer Events na origem, preservar pointerId e distinguir press, release, cancel e perda de foco. Converter eventos em ações sem perder edges entre frames. Movimento contínuo e ações discretas devem ter semântica própria.

Jump e Dash não podem depender apenas de polling no frame de render. Definir buffers, prioridades, consumo único, cancelamento e reset de estado. Multitouch deve suportar movimento e ação simultâneos.

## 5. Renderização Canvas
O renderer controla context, backing store, DPR limitado por orçamento de memória, resize e clear. Resolução CSS e resolução interna não são equivalentes. O cálculo de escala precisa preservar proporção de gameplay e safe area.

Evitar alocações por objeto em loops quentes, leituras de layout por frame, sombras/filtros caros e redimensionamento repetido do canvas. Usar profiling antes de otimizar.

## 6. Assets e áudio
Assets usam IDs estáveis e manifest versionado. Loader precisa de progresso real, cancelamento/erro e liberação de recursos. Web Audio precisa de unlock por gesto, buses, limites de vozes e lifecycle.

## 7. Persistência
Separar save técnico, domínio de campanha, checkpoint e estado transitório. Schema versionado, validação de payload, migração e recuperação devem ser testados. Storage não é confiável nem garantido.

## 8. Interfaces entre sistemas
Definir interfaces pequenas para Input → Gameplay, Gameplay → Events/Presentation, Level → Entities, Campaign → Persistence, Audio → Platform e Runtime → Lifecycle. Não compartilhar referências internas de entidades entre sistemas sem contrato.

## 9. Critérios de aprovação
Antes de expandir o runtime, aprovar diagrama de dependências, owners, lifecycle, input contract, timestep policy, save schema, asset manifest e estratégia de testes. Qualquer decisão que altere canon ou feel precisa de aprovação do usuário.
