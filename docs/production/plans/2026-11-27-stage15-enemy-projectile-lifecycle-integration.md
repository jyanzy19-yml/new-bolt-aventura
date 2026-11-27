# Etapa 15 — lifecycle de inimigos e projéteis de impacto único

**Data:** 27/11/2026  
**Branch:** `integration/stage15-enemy-projectile-lifecycle-2026-11-27`  
**Base:** `main` após as integrações Stage 14  
**Tipo:** correções de lifecycle/locomoção do inimigo provisório e consumo terminal do projétil; sem novos arquétipos ou balanceamento.

## 1. Objetivo

Consolidar as correções de integridade do inimigo-base provisório e do projétil Crono. Fechar janelas de callback tardio causadas por remoção deferred e assegurar que o movimento de patrulha respeite os limites espaciais declarados.

## 2. Contratos cobertos

1. **Enemy lifecycle:** callback de contato recebido depois da derrota é ignorado enquanto `queue_free()` ainda não removeu o nó; evento `defeated` continua único.
2. **Patrol bounds:** o último passo de física é limitado à distância restante até o endpoint; a direção inverte no tick seguinte, sem overshoot por discretização.
3. **Projectile terminal state:** cada projétil produz no máximo um impacto ou expiração; callbacks repetidos antes da remoção deferred são ignorados.
4. **Expired projectile:** callback de colisão tardio após expiração não aplica dano.

## 3. Implementação

- `CybercorePatrolEnemy` guarda callback de contato com `_active` e limita o último passo da patrulha.
- `ChronoProjectile` introduz estado terminal `_spent`, marcado antes de chamar o alvo e também na expiração.
- `tests/unit/test_enemy_lifecycle.gd` cobre contato tardio após derrota e os dois endpoints com velocidade alta.
- `tests/unit/test_chrono_projectile.gd` cobre impacto repetido e colisão tardia após expiração.
- `docs/technical/05-system-contracts.md` documenta lifecycle, separação lifecycle/behavior, percepção, locomoção, telegraphs, dados, harnesses e limites do inimigo provisório.

## 4. Limites e preservação

- Não cria arquétipo canônico, IA de percepção, perseguição, navegação por plataformas, telegraphs, pooling ou hierarquia genérica prematura.
- Mantém valores exportados de velocidade, distância, dano, cooldown e duração; somente o último passo é limitado para respeitar o endpoint.
- Não altera Player, Dash, InputMap, save schema, IDs persistentes, fases, campanha, canon, arte ou assets.
- O inimigo-base permanece provisório e não participa de persistência.

## 5. Critérios de aceite

- Godot 4.7.2 Validation: todos os testes passam.
- Documentation Validation: SUCCESS.
- Android Debug Export: SUCCESS, com assinatura v2/v3 e artifact rastreável.
- Os testes exercitam os estados terminais antes da remoção física deferred.

## 6. Limitações

CI/headless não substitui playtest visual nem validação em Android físico. Não mede percepção, navegação por plataformas, balanceamento, FPS, frame pacing, memória ou termal. Etapa 15 permanece EM ANDAMENTO.
