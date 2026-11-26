# Regressão — coleta física do item de recuperação

**Data:** 2026-11-26  
**Branch:** `test/health-pickup-physical-contact`  
**Base:** `main` após PR #36  
**Responsável:** ChatGPT

## Diagnóstico

O teste existente de `BoltHealthPickup` invocava diretamente `_on_body_entered`. Isso verificava a lógica de cura, mas não comprovava que a configuração real de colisão e o sinal `Area2D.body_entered` acionavam a coleta durante a simulação física.

A implementação atual já usa `set_deferred("monitoring", false)` porque o Godot bloqueia a alteração síncrona de `Area2D.monitoring` durante callbacks de entrada/saída de física. O pipeline CI anteriormente detectava erros de parse e script, mas não esse erro específico de física.

## Alterações planejadas

- Acrescentar teste de integração com BOLT e o coletável instanciados e sobrepostos fisicamente.
- Verificar restauração de vida, emissão única do sinal `collected`, quantidade restaurada e consumo do coletável.
- Fazer o Godot CI falhar se o log registrar a mutação de estado de física bloqueada durante sinais `body_entered/body_exited` ou durante o flush de queries.
- Preservar a implementação de cura, valores, colisões e feedback do gameplay.

## Critérios de aceite

1. O teste aciona a coleta por sobreposição física real, sem chamar o handler privado.
2. A vida é restaurada e `collected` é emitido exatamente uma vez.
3. O coletável é consumido após a coleta.
4. O runner headless termina com sucesso e o CI não registra erro de mutação de estado físico.
5. Godot CI e Docs CI passam na PR e após o merge.

## Limites

Nenhuma execução local do Godot, editor gráfico, exportação APK, emulador ou validação em Android físico foi realizada nesta unidade. O CI headless não prova renderização, touch físico ou desempenho Android.


## Nota de auditoria pós-merge

A revisão posterior de `tests/unit/test_campaign_entry.gd` confirmou que a integração da W1-L1 já percorria a coleta por contato físico real, verificando restauração de vida, emissão do sinal, remoção do nó e feedback HUD. Portanto, a lacuna não era ausência total de cobertura física: o teste antigo em `test_enemy_combat.gd` chamava o handler diretamente. A PR #37 acrescentou uma regressão física isolada do componente e validação da emissão única/quantidade, complementando — e não inaugurando — a cobertura de integração da campanha.
