# BOLT · AVENTURA — Seleção de mundos/fases e progressão sequencial

**Data:** 27/11/2026  
**Estado:** implementação em branch isolada; aguarda CI e revisão  
**Decisão de progressão:** aprovada explicitamente pelo usuário em 27/11/2026.

## Política aprovada

1. W1-L1 inicia disponível.
2. Concluir a fase N libera a fase N+1 no mesmo mundo.
3. Concluir Wn-L6 libera W(n+1)-L1.
4. A regra se repete até W7-L6.
5. Fases concluídas permanecem rejogáveis.
6. Fases sem PackedScene implementada permanecem indisponíveis e exibidas como EM BREVE; nunca solicitar carregamento de cena ausente.
7. Preservar CampaignProgress schema v1, current_level_id, completed_level_ids, IDs persistentes e SaveSystem.

## Fontes de autoridade

- docs/game-design/02-world-bible.md: ordem e nomes dos sete mundos, fragmentos e títulos descritivos dos guardiões.
- docs/game-design/EXPANDED-42-LEVEL-CAMPAIGN-BLUEPRINT.md: estrutura 7 × 6 e títulos de produção; o próprio blueprint classifica as fichas como propostas, não como cenas implementadas nem títulos finais aprovados.
- docs/game-design/06-ui-ux.md: touch-first, safe areas, fluxos de menu, foco, cancelamento e acessibilidade.
- docs/technical/05-system-contracts.md: SceneFlow/Loading threaded.
- docs/decisions/ADR-0003-android-system-bars.md: política imersiva consistente em todas as telas.
- scripts/campaign/campaign_progress.gd: schema v1 e domínio persistente atual.

## Modelo de implementação

- CampaignCatalog é catálogo imutável de IDs/metadados e regras derivadas; não grava save.
- CampaignProgress continua sendo a única autoridade do estado persistente.
- O estado da UI é calculado a partir de IDs concluídos, mundo/fase e existência real da PackedScene.
- A entrada na seleção não altera o save.
- O contexto temporário do mundo selecionado é transportado apenas durante a navegação entre as duas telas, sem persistência.
- Todas as transições de tela/fase usam SceneFlow.change_scene().
- A disponibilidade de cenas é verificada novamente no momento do clique.
- Nenhuma cena ausente é carregada por fallback ou caminho presumido.

## Status dos títulos

Os nomes dos sete mundos, fragmentos e títulos descritivos dos guardiões vêm da Bíblia oficial. Os títulos de fases presentes no blueprint expandido são propostas de produção; a UI os usa como rótulos de trabalho, sem promovê-los a canon narrativo. Fases sem título de produção definido são exibidas como “Fase N”.

## Limites e integração

A PR #105 altera scripts/ui/main_menu.gd; por isso esta unidade não modifica esse script. A entrada de seleção é adicionada como nó independente a scenes/ui/main_menu.tscn, evitando colisão com a alteração de retomada da PR #105. Arquivos de rastreabilidade compartilhados por PRs abertas também não são alterados nesta branch. A integração final deve reconciliar trackers/continuidade após a resolução das PRs concorrentes.

## Não incluído

- Arte final, spritesheets, fundos, ícones ou efeitos não aprovados.
- Alterações ao schema de save, CampaignProgress, física, Dash, InputMap ou cenas de fase.
- Criação das 42 fases; as ausentes continuam Em breve.
- Alteração da opção de tela cheia ou da política Android system bars.
- Validação física Android.

## Critérios de aceite

- Catálogo contém exatamente 7 mundos, 6 fases por mundo e 42 IDs únicos.
- Regra sequencial cobre início, progressão intramundo, transição entre mundos e replay.
- Cena ausente permanece indisponível e não é carregada.
- Telas são navegáveis por touch e respeitam safe area.
- Entrada e retorno usam SceneFlow threaded.
- Schema v1 e IDs persistentes não mudam.
- Testes automatizados e validação Godot/Docs/Android CI devem ser registrados com resultados reais.
