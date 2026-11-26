# Plano — overlay de carregamento persistente para transições de cena

**Data:** 2026-11-26  
**Branch:** `feat/scene-loading-overlay`  
**Base:** main após PR #40, `85412c3bdd5c6eefd27f25bf2a56af4b38fcdfed`

## Diagnóstico

`SceneFlow` já faz `ResourceLoader.load_threaded_request()`, acompanha progresso, bloqueia transições concorrentes e emite sinais de início/conclusão/falha. Entretanto, não existia uma interface persistente conectada a esses sinais. A cena Boot tinha apenas um rótulo local; depois da troca de cena, não havia overlay comum para exibir o estado de carregamento das próximas fases.

## Implementação proposta

- Criar `LoadingOverlay` como autoload CanvasLayer, acima do HUD e persistente entre cenas.
- Exibir overlay apenas após `SceneFlow.transition_started`.
- Mostrar porcentagem somente quando `SceneFlow.progress` receber progresso real de `ResourceLoader`; se não houver dado, mostrar texto sem porcentagem.
- Ocultar overlay em `transition_finished` e `transition_failed`.
- Bloquear interação durante a transição sem introduzir espera artificial.
- Manter `SceneFlow` em `PROCESS_MODE_ALWAYS` para concluir transições mesmo se a árvore anterior estiver pausada.
- Adicionar regressões para estado inicial, progresso real, conclusão e falha.

## Critérios de aceite

1. O autoload é registrado e a cena pode ser carregada/instanciada.
2. O overlay aparece apenas após início bem-sucedido de carregamento.
3. Nenhuma porcentagem é exibida enquanto o engine não fornece progresso.
4. A porcentagem acompanha o valor real informado.
5. Overlay some em sucesso e falha.
6. Transições continuam processando com a árvore pausada.
7. Godot CI e Docs CI passam.

## Limites

- Não adiciona espera mínima artificial de 4 segundos; o tempo de carregamento continua determinado pelo trabalho real do engine.
- Não implementa cancelamento de transição nem descarregamento/preload avançado; esses itens continuam pendentes no contrato técnico.
- Testes headless não comprovam legibilidade, animação, frame time ou safe area em aparelho Android. A validação visual/física permanece pendente.


## Resultado da integração — PR #41

- PR #41 integrada por squash em `66b3c0e060762ebe1f3c4b6af84c84a79f0cd781`.
- Godot CI: 75 testes/470 verificações/0 falhas; Docs CI SUCCESS; Android Debug Export SUCCESS.
- O overlay e a apresentação de progresso real estão integrados.
- Revisão pós-merge identificou que GUI capture não bloqueia ações de teclado; o bloqueio integral foi separado no plano `2026-11-26-scene-flow-input-lock.md`.
