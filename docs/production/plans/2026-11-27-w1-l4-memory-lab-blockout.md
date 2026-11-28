# W1-L4 — Laboratório de Memórias: blockout vertical

**Data:** 27/11/2026  
**Branch:** `feat/cybercore-w1-l4-memory-lab-2026-11-27`  
**Base:** main após correção canônica de W1-L3  
**Estado:** EM VALIDAÇÃO

## Objetivo

Implementar a primeira versão executável da fase vertical W1-L4 conforme o Atlas Mestre, sem introduzir canon, inimigos ou armas que ainda não existem no projeto.

## Escopo

- Três elevadores móveis e rota vertical base → arquivo → câmaras → observatório.
- Componente `AlternatingPlatform` com aviso de saída/retorno e colisão determinística em fixed-step.
- Dois lasers ambientais usando `TimedEnergyGate` com janela segura inicial longa.
- `NarrativeBeatTrigger` por ID, sem diálogo e sem alteração do save.
- Registro de preservação obrigatório para conclusão.
- Rota secreta lateral com silhueta placeholder e beat one-shot.
- Dois checkpoints persistentes usando CampaignProgress schema v1.
- MainMenu Continue e seleção de fase W1-L4.
- Atualização do título do guardião de Cybercore para Sentinela do Fragmento conforme Atlas.

## Dependências e lacunas

- Projeção Defensiva e Drone Vigia ainda não existem como arquétipos; usar somente inimigo genérico provisório e documentar.
- Tríplice/Laser ainda não estão completos; nenhum puzzle pode exigir essas armas.
- Sistema narrativo global, item de lore persistente, arte final e interação de diálogo permanecem fora desta unidade.
- W1-L5 será Torre do Núcleo, não Perímetro do Guardião.

## Aceite

1. Godot Validation e Documentation Validation passam.
2. Android Debug Export passa com a suíte headless.
3. AlternatingPlatform comprova estados e avisos antes de mudar colisão.
4. Lasers começam inativos e mantêm ciclos configurados.
5. Registro central bloqueia a saída até ser recuperado.
6. Memória secreta emite beat ID uma única vez.
7. Checkpoints, seleção e Continue funcionam sem alterar save schema.
8. Sem afirmação de validação física Android.
