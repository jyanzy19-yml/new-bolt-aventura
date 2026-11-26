# Cybercore W1-L1 / W1-L2 — polimento visual, de feedback e de legibilidade

**Branch:** `feat/cybercore-w1-blockout` · **Base:** `main` @ `fc4839e` · **Status:** implementado e testado em headless; renderização conferida por captura em software GL; **nada validado em aparelho Android**.

Escopo: somente apresentação e feedback. Mecânicas, tuning, Dash, controles touch, save, boot e progressão **não foram alterados**. Toda a direção de arte abaixo é **PROPOSTA PROVISÓRIA** (não canon); os documentos aprovados só definem Cybercore como "ruínas tecnológicas e mundo destruído".

## O que mudou

| Área | Mudança | Arquivos |
|---|---|---|
| Visual / profundidade | Cenário de 3 camadas com parallax (céu fixo, horizonte distante, ruínas próximas com antenas de alerta), geradas por código, determinísticas | `scripts/world/cybercore_backdrop*.gd`, `scenes/world/cybercore_backdrop.tscn`, as duas cenas de fase |
| Visual / composição | Blocos com painéis, brilho sob a borda e base escurecida (mesma API) | `scripts/world/platform_block.gd` |
| Game feel | Poeira de pouso (proporcional à velocidade de queda), impulso de pulo, rastro de dash, antecipação (look-ahead) horizontal da câmera, tremor curto ao sofrer dano. Desligável via `camera_effects_enabled` | `scripts/player/bolt_feedback.gd`, `scenes/player/bolt.tscn` |
| Combate / VFX | Clarão de disparo, impacto do projétil, faíscas ao acertar e explosão ao derrotar o inimigo; brilho no projétil | `scripts/vfx/burst.gd`, `bolt_combat.gd`, `chrono_projectile.gd/.tscn`, `cybercore_patrol_enemy.gd` |
| UX / perigo | Campo energético ativo passa a vermelho-alaranjado (mesma leitura do inimigo; ciano = seguro) e **pisca em alerta 0,45 s antes de ativar**. Tempos, `monitoring` e dano inalterados | `scripts/levels/timed_energy_gate.gd` |
| Performance | Teto de 24 bursts simultâneos; cada camada do fundo é UMA malha (1 draw call) | `burst.gd`, `cybercore_backdrop_layer.gd` |

`BoltFeedback` só observa sinais/estado do jogador: remover o nó deixa a jogabilidade idêntica.

## Evidências

- **Suíte headless (Godot 4.7.2):** `main` = 92 testes / 584 verificações; esta branch = **102 / 644, 0 falhas**. Novos: `tests/unit/test_cybercore_polish.gd` (10 testes).
- **Mutação:** 5 alterações deliberadas no código (teto de bursts, limiar de poeira, telégrafo, explosão do inimigo, bug de câmera) — **todas detectadas**. Dois testes eram fracos na primeira versão (sobreviveram ao mutante) e foram reforçados.
- **Bug real achado pelos testes:** `BoltFeedback` buscava a câmera no `_ready` (filhos ficam prontos antes do pai) → look-ahead/tremor nunca funcionariam. Corrigido.
- **Renderização real** (Xvfb + Mesa/llvmpipe, GL Compatibility): capturas em `evidence/cybercore-w1-polish/` (antes/depois da W1-L1, W1-L2, explosão).
- **Draw calls por quadro** (monitor do renderizador, W1-L1 / W1-L2): `main` 21 / 19 → versão ingênua do fundo 167 / 166 (**regressão 8×, descartada**) → versão final com malha única **25 / 23**. Memória estática ~35,4 MB (≈ +0,2 MB).

## Limitações e o que NÃO foi feito

- **Android físico, FPS, memória e térmica: NÃO medidos.** As contagens acima vêm de software GL num PC; não representam a Helio G99.
- **Áudio: não implementado.** Não há nenhum asset/bus de áudio no projeto; sincronizar SFX exige assets e decisão de direção sonora.
- **Inimigos novos/arquétipos, animações finais de BOLT e arte final: fora de escopo** (não especificados; nada foi inventado). BOLT segue com polígonos placeholder, por isso não há squash & stretch (o visual usa `scale.x` para virar o personagem).
- **Level design (layout, ritmo, posicionamento de inimigos): NÃO alterado**; seria mudar fase aprovada sem especificação.
- Tuning dos efeitos (tamanhos, tempos, look-ahead 56 px, tremor 6 px) é provisório e **não foi avaliado por uma pessoa em aparelho**.

## Defeito pré-existente encontrado (NÃO corrigido aqui — fora do escopo permitido)

`main` (sem esta PR) falha **5/5** no smoke de boot (`--fixed-fps 60 --quit-after 300`) com `Parse Error: res://scenes/ui/main_menu.tscn:12`. Causa provável (mesmo mecanismo já diagnosticado na Etapa 0): `scripts/ui/main_menu.gd` usa os autoloads `CampaignProgress`/`SaveSystem` por identificador direto num script compilado durante o carregamento em thread. Correção sugerida, em PR própria: resolver via `get_node_or_null("/root/CampaignProgress")` em tempo de execução (e testar o boot em laço). Toca inicialização/progressão, que a missão proibia alterar.


## Revisão independente e correção S2 — 2026-11-26

- **Evidência:** Godot Validation run `45904728896` (head original `d51bcb4`) terminou SUCCESS e registrou `102 testes / 644 verificações / 0 falhas`, mas o log também contém múltiplos `ERROR: Error calling from signal 'timeout' to callable: 'GDScript::_release': Cannot convert argument 1 from Object to Object.` Portanto, o resultado verde anterior não significava ausência de erro de runtime.
- **Causa técnica:** `Burst.spawn()` vinculava uma referência `CPUParticles2D` tipada ao callback de `SceneTreeTimer`. Quando a cena/pai era destruído antes do timeout, o objeto podia já estar inválido quando o timer tentava invocar o método; a conversão do argumento falhava e `_active` não era decrementado.
- **Correção na branch da PR:** o callback agora recebe o `instance_id` (int), decrementa o contador independentemente da vida do Node e só chama `queue_free()` se `instance_from_id()` ainda resolver uma `CPUParticles2D` válida.
- **Regressão adicionada:** `test_burst_releases_counter_when_parent_is_freed_before_timeout` destrói o pai antes do timeout e exige que o contador retorne ao baseline. O teste drena efeitos anteriores para evitar dependência de ordem.
- **Mutação:** workflow independente `.github/workflows/burst-cleanup-mutation.yml` restaura temporariamente o callback antigo, exige que a asserção específica falhe e depois restaura o código corrigido e roda novamente a suíte.
- **Estado desta correção:** commits separados na branch `feat/cybercore-w1-blockout`: correção `dba47d9`, regressão/isolation `e50230b` e `7e41df9`, workflow de mutação `436927d`. A validação destes commits ainda depende dos novos checks; não declarar o S2 fechado antes dos logs.
- **Impacto de escopo:** apenas ciclo de vida do VFX Burst e cobertura de teste; nenhuma mudança de gameplay, dano, Dash, input, save ou progressão.
