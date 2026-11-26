# Handoff — recuperação de vida e feedback de combate

**Data:** 2026-11-26  
**PR:** [#21 — health pickups and enemy hit feedback](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/21)  
**Branch:** `feat/health-pickup-hit-feedback`  
**Merge:** `b2e66d9638d367cce29b266d75f230cb16ed1763`

## Entrega

- `BoltHealth.restore(amount)`: restauração positiva, limitada a `max_health`; retorna false se a vida está cheia, o valor é inválido ou a vida está esgotada.
- `BoltPlayer.heal(amount)`: interface de cura do player, bloqueada após derrota.
- `BoltHealthPickup`: Area2D reutilizável que cura BOLT e só desaparece após uma cura válida.
- Inimigo-base: flash de cor ao receber dano, sinal `hit_received` e restauração da cor original via tick fixo.
- Um coletável provisório foi posicionado em Cybercore W1-L1.

## Testes e validação

- Godot 4.7.2 headless: import/parse aprovado.
- Run `45849915250`: SUCCESS, 53 testes, 276 verificações, 0 falhas.
- A primeira execução `45849739361` falhou por `%Visual` não estar marcado como único e testes de contato afetados pela falha de inicialização. A cena foi corrigida e a segunda execução passou.

## Limites

- Coletável, quantidade de cura e feedback visual são placeholders de gameplay; não são design final, inventário, economia ou recompensa canônica.
- Não foi executada exportação APK, instalação, emulador, aparelho Android, FPS ou memória.
- Dash, ActionBuffer, controles touch, Pistola Crono e fluxo de derrota foram preservados.

## Próxima unidade sugerida

Evoluir W1-L1 como encontro de combate curto e legível: garantir espaçamento/posicionamento, comunicar dano e recuperação ao jogador e cobrir o fluxo de derrota/reinício/retorno ao checkpoint com testes. Em seguida, fechar a experiência de campanha inicial antes de iniciar novos arquétipos ou armas.
