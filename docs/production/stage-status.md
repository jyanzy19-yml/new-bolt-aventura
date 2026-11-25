# Estado de produção — baseline verificado do BOLT · AVENTURA

**Data:** 2026-11-25  
**Branch:** main  
**HEAD auditado:** d8d1a5b8801f0096ba372bf686c459fdba385931

## Inventário

| Item | Estado |
|---|---:|
| Entradas na árvore Git | 228 |
| Markdown no repositório | 129 |
| Markdown em docs/ | 41 |
| Skills | 36 |
| Agentes | 8 |
| Comandos | 6 |
| Workflows no HEAD auditado | 1 |
| project.godot | Ausente |
| Cenas .tscn | 0 |
| Scripts .gd | 4, todos exemplos/testes de skills |
| Assets de jogo (imagem/áudio/fonte) | 0 identificados |

O repositório é um ecossistema documental e de ferramentas; ainda não é um jogo Godot executável.

## Implementação real

- Projeto Godot e configuração Android: não implementados.
- Cenas, scripts e recursos de gameplay BOLT: não implementados.
- Pipeline de assets: padrão documental; sem assets finais integrados.
- Testes GDScript/gameplay: não executados, projeto ausente.
- APK, instalação, emulador e dispositivo físico: não comprovados.
- FPS, frame time, memória e estabilidade Android: não medidos.

## CI

- docs-validation.yml valida metadados, links e controles.
- godot-validation.yml foi adicionado nesta atualização; executará import/parse headless somente após project.godot e .godot-version existirem.
- Sem projeto, o workflow Godot informa NOT APPLICABLE; isso não é PASS de engine.
- Run documental #90: SUCCESS no HEAD auditado. Não valida gameplay, export Android ou aparelho.

## Colaboração

Fonte canônica: [COLLABORATION_STATE.md](COLLABORATION_STATE.md).

- Estado PENDING; nenhum escritor ativo.
- Etapa 0: Claude Code — fundação executável Godot.
- Etapa 1: ChatGPT — auditar Etapa 0 e implementar próxima unidade do roadmap.
- Um escritor por vez; usuário aciona manualmente o próximo agente.
- Não iniciar Etapa 1 antes de inspecionar commit e handoff reais da Etapa 0.

## PR #1

A [PR #1](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/1) continua aberta e divergente. Comparação consultada: 17 commits exclusivos na PR e 88 exclusivos em main; GitHub informou não mergeável no momento. Não mesclar, fechar ou reaproveitar automaticamente; reconciliar especificações primeiro.

## Próxima ação

Claude Code executa Etapa 0: reconfirmar repositório; ler diretrizes; detectar versão Godot 4.x e renderer; criar project.godot, estrutura mínima, configuração Android/paisagem, input map e cena inicial; executar import/parse quando possível; atualizar tracker, continuidade, estado e handoff.

Não antecipar gameplay das etapas posteriores. Não inventar versão, build, teste ou métrica.

## Referências

- [Pipeline CI](CI_AND_VALIDATION_PIPELINE.md)
- [Pipeline de assets](ASSET_PIPELINE.md)
- [Matriz QA](../qa/test-matrix.md)
- [Template de teste Android](../qa/ANDROID_DEVICE_TEST_TEMPLATE.md)
- [Contratos entre sistemas](../technical/05-system-contracts.md)
- [Roadmap](roadmap.md)
- [Tracker de 24 sistemas e 42 fases](implementation-tracker.md)
