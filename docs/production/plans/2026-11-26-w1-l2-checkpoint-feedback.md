# Correção — feedback de checkpoint em W1-L2

**Data:** 2026-11-26  
**Branch:** `fix/w1-l2-checkpoint-feedback`  
**Base:** `main` após a integração da PR #35  
**Responsável:** ChatGPT

## Diagnóstico

A rotina `_on_checkpoint_activated` de W1-L2 exibia a notificação `CHECKPOINT ATIVADO` somente dentro do ramo de falha de `CampaignProgress.save_checkpoint`. No caminho normal de persistência bem-sucedida, o checkpoint era ativado e salvo, mas o jogador não recebia feedback visual. W1-L1 já apresenta a notificação independentemente do resultado do salvamento.

## Alteração

- Manter o aviso de erro quando a persistência falhar.
- Exibir `CHECKPOINT ATIVADO` após qualquer ativação física do checkpoint, como feedback da ação de gameplay.
- Acrescentar regressão em `test_w1_l2_progression.gd` verificando visibilidade e texto da notificação.

## Fora de escopo

- Não altera schema, gravação, IDs, posição de respawn, física, Dash, combate ou temporização do campo.
- Não declara persistência em Android físico validada.
- Não transforma W1-L2 de blockout em fase final.

## Critérios de aceite

1. A ativação do checkpoint mantém o ID persistente esperado.
2. O HUD exibe a notificação após a ativação.
3. A notificação possui o texto esperado.
4. Testes Godot 4.7.2 e Docs CI passam.
5. O diff permanece limitado à correção e à rastreabilidade.

## Validação

**Pendente:** GitHub Actions nesta branch/PR. Nenhuma execução local do Godot, exportação APK ou validação Android físico foi realizada nesta unidade.
