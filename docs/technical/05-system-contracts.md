# Contratos entre sistemas — BOLT · AVENTURA

Este documento registra contratos conceituais. Os nomes finais de classes, sinais e Resources devem seguir o projeto Godot real depois da auditoria.

## 1. Input → Player Controller
Input publica ações lógicas e estados/edges de pressionar e soltar. O controller decide o que é permitido no estado atual. UI não deve alterar velocidade ou física diretamente.

## 2. Player/Enemy → Health e dano
Se o jogo usar um sistema comum de vida/dano, definir tipos de evento, origem, alvo, invulnerabilidade, feedback e regras de duplicidade. Não criar uma abstração genérica se houver apenas um consumidor simples.

## 3. Gameplay → HUD
HUD observa estado apresentado por contrato explícito. Não deve ser fonte de verdade de vida, fragmentos, cooldowns ou progresso. Atualizações não devem exigir polling caro sem necessidade.

## 4. Level → Checkpoint/Progress
Level informa eventos de progresso por IDs estáveis. Checkpoint e progress system definem o que persiste e como restaurar. Evitar dependência circular entre cena e save.

## 5. Dialogue/Events → Narrative Flags
Diálogos e cutscenes atualizam flags por IDs definidos e validados. Pular uma cena deve aplicar os mesmos efeitos persistentes obrigatórios de assisti-la.

## 6. Scene Flow → Loading
Um coordenador de transição controla destino, carregamento, cancelamento, erro, bloqueio de input e liberação de recursos. Impedir duas transições incompatíveis simultâneas.

**Implementação atual:** `SceneFlow` controla carregamento threaded, falha e concorrência; `LoadingOverlay` apresenta o estado/progresso real e bloqueia interação durante a transição. Cancelamento e política abrangente de liberação de recursos permanecem pendentes e não devem ser declarados concluídos.

## 7. Audio Events → Audio Buses
Gameplay emite eventos sem conhecer detalhes de mixagem. Buses controlam categorias e configurações de usuário. Interrupção/resume deve preservar estado coerente.

## 8. Save System → Persistent State
Persistir somente dados serializáveis e versionados. Não persistir referências diretas a Nodes, objetos temporários ou caminhos frágeis de cena.

## 9. Critérios de revisão
Para cada contrato, documentar produtor, consumidor, payload, frequência, ciclo de vida, tratamento de erro, ownership e testes. Revisar dependências circulares, estado duplicado e chamadas síncronas no caminho crítico.
