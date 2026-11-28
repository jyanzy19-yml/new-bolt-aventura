# CombatRuntime — composição do loop de combate

**Status:** integração determinística de WeaponController, ProjectileSystem e HealthComponent.  
**Dependências:** CollisionWorld e frames de input normalizados.

## Responsabilidade

- Possuir um ProjectileSystem e um WeaponController ligados à mesma instância.
- Receber o delta fixo e avançar o cooldown de arma e lifetime/movimento de projéteis no mesmo passo.
- Criar disparos antes de atualizar projéteis, fazendo o projétil recém-criado avançar no próprio passo.
- Resolver impactos no mundo e hits em alvos que exponham `health.applyDamage()`.
- Retornar resultados de disparo e eventos de projétil sem acoplar apresentação.

## Ordem do passo

1. WeaponController consome o frame de input e tenta criar o projétil.
2. ProjectileSystem atualiza lifetime e movimento dos projéteis ativos.
3. ProjectileSystem resolve primeiro hit válido ou impacto no mundo.
4. CombatRuntime retorna os eventos e contagem ativa.

## Limites

Não implementa catálogo canônico, padrões múltiplos, ammo/reload, knockback, invulnerabilidade, hitstop, animação, áudio, HUD ou feedback final. Os testes validam integração lógica, não balanceamento, browser, WebView ou dispositivo Android.
