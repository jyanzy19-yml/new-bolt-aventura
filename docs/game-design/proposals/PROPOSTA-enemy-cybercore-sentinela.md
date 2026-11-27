# PROPOSTA — Arquétipo de inimigo Cybercore: Sentinela

**Status:** PROPOSTA (não canônica). Aguarda aprovação do usuário conforme GAP-010 (`docs/production/requirements-gap-register.md`).
**Nome, silhueta, números e comportamento são provisórios.** Nada aqui altera canon, ADRs, schema de save ou física/controles de BOLT.
**Implementação existente:** `scripts/enemies/cybercore_sentry.gd`, `scripts/enemies/sentry_bolt.gd`, `scenes/enemies/cybercore_sentry.tscn`, `scenes/enemies/sentry_bolt.tscn`. Testes: `tests/unit/test_cybercore_sentry.gd`.

## Por que este arquétipo

O único inimigo existente em Cybercore é o patrulheiro provisório (`CybercorePatrolEnemy`): move-se e causa dano por contato. A meta do projeto é ≥ 5 arquétipos **distintos por decisões exigidas do jogador**, não por cor ou vida (`03-character-bible.md` §5). A Sentinela exige uma decisão diferente da patrulha: **ler uma linha de tiro e reagir a um aviso**, em vez de evitar contato.

## Ficha de inimigo (template de `03-character-bible.md` §5)

- **ID / mundo / papel de encontro:** `cybercore_sentry` (ID provisório) / Cybercore (W1) / atirador estacionário de zona: controla uma linha horizontal e cria pontos de risco/abrigo.
- **Silhueta e leitura à distância:** corpo azul-acinzentado claro com um cano lateral apontando para o alvo e um núcleo central que muda de cor por estado. Corpo claro o bastante para ler contra o fundo escuro (ajustado após captura renderizada). Arte final pendente.
- **Locomoção e espaço ocupado:** estacionária; caixa de 30×40 px; sem contato perigoso.
- **Estado inicial e máquina de estados:** `IDLE → TELEGRAPH → COOLDOWN → IDLE`; dano durante `TELEGRAPH` → `STAGGER → IDLE` (disparo cancelado). Orientação inicial configurável (`initial_facing`).
- **Padrão de percepção:** BOLT dentro de `detection_range` (380 px), alinhada verticalmente (`vertical_tolerance` 56 px) e **com linha de visão livre** (raycast contra a camada de mundo). Abrigos do mundo bloqueiam a percepção.
- **Ação/ataque e telegraph:** projétil horizontal lento (170 px/s, 1 de dano). Telegraph de 0,8 s: linha de mira visível e núcleo que pisca cada vez mais rápido. A **direção é travada no início do aviso**. Sem áudio ainda (pendente).
- **Janela de resposta e contra-jogo:** (1) sair da linha durante o aviso; (2) pular/dashar o projétil lento; (3) usar abrigo; (4) interromper acertando a Sentinela durante o telegraph (stagger de 0,6 s). O aviso de 0,8 s e a velocidade baixa buscam não exigir reflexo impossível em touch. **Valores não validados com jogadores nem em aparelho.**
- **Interação com terreno:** o mundo bloqueia percepção e projétil; o projétil some ao tocar o mundo.
- **Reação a dano/derrota:** contrato de inimigo existente (`apply_damage`, `hit_received`, `defeated`); 2 de vida; flash de impacto; `queue_free` ao ser derrotada.
- **Variações e escalonamento (ideias, não implementadas):** telegraph mais curto, rajada dupla, orientação oscilante, versão em teto/parede. Nada disso foi implementado.
- **Limites de quantidade simultânea:** no máximo **1 projétil por Sentinela** em voo; recomendação de projeto: ≤ 2 Sentinelas ativas na mesma tela.
- **Requisitos de performance:** sem alocação por frame além do projétil instanciado por disparo (cena leve: 1 Area2D + 2 polígonos); 1 raycast por tick apenas em `IDLE` com alvo no sensor; sem `Timer`/tween por instância. **Custo real não medido em Helio G99.**
- **Casos de QA (cobertos por testes automatizados, ver relatório):** telegraph antes do disparo; fora de alcance/desalinhada é ignorada; abrigo bloqueia visão; dano no telegraph cancela o disparo; direção travada; limite de um projétil; dano único e despawn do projétil; sem dano de contato; derrota.

## Questões abertas para aprovação

1. Aprovar (ou renomear/redesenhar) a Sentinela como arquétipo de Cybercore.
2. Aprovar a janela de 0,8 s e velocidade 170 px/s como ponto de partida ou substituir após playtest em aparelho.
3. Definir feedback sonoro do telegraph e do disparo (nenhum áudio implementado).
