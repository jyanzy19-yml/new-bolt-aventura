# Handoff — inimigo-base e dano ao jogador

**Data:** 2026-11-26  
**PR:** [#19 — enemy base and player damage loop](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/19)  
**Branch:** `feat/cybercore-enemy-player-damage`  
**Base:** `e588c2f6a45cda0ec71b14dad815f2359569e3bf`

## Entrega desta unidade

- Criada a cena/script `CybercorePatrolEnemy`: patrulha horizontal limitada, vida via `BoltHealth`, dano de contato e remoção ao ser derrotado.
- BOLT agora possui três pontos de vida provisórios, recebe dano e knockback, ganha janela temporária de invulnerabilidade e emite sinal de derrota.
- Respawn restaura vida e limpa invulnerabilidade/estado de derrota.
- HUD mostra a vida atual e W1-L1 exibe resultado quando BOLT é derrotado.
- Um inimigo foi inserido no blockout W1-L1 para validar o loop em contexto de campanha.
- Testes adicionados para vida, invulnerabilidade, respawn, patrulha, contato e dano por projétil.

## Limites e decisões preservadas

- O inimigo é um protótipo funcional, não um arquétipo canônico nem um design final.
- Valores atuais (3 HP, 1 dano, velocidade 70 px/s, patrulha 120 px, invulnerabilidade 0,9 s e knockback 300 px/s) são provisórios e exigem playtesting.
- Dash, ActionBuffer, controles touch e Pistola Crono foram preservados.
- A morte mostra o overlay de resultado; reinício recarrega a fase. Respawn por checkpoint após derrota final ainda não foi projetado como loop de vidas.

## Validação

- PR #19 dispara Godot Validation em Godot 4.7.2 e validação documental.
- Registrar os resultados reais dos workflows antes de integrar.
- Não houve exportação APK, instalação, emulador ou teste em aparelho Android nesta unidade.

## Próxima ação

Após os checks, revisar os logs, corrigir falhas e integrar somente com os workflows obrigatórios verdes. Depois, evoluir o inimigo para uma primeira interação de combate melhor apresentada e continuar o desenho do ciclo de dano/recuperação sem canonizar parâmetros não aprovados.
