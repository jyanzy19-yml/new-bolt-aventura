# Estado de produção — BOLT · AVENTURA

**Auditoria de pré-produção:** 2026-11-25  
**Branch:** main  
**HEAD de referência do inventário:** 3963e8efe189150ca4384bc028f62394c8d759e6

## Inventário atual após os documentos de pré-produção

| Item | Quantidade/estado |
|---|---:|
| Entradas na árvore Git | 234 |
| Markdown no repositório | 134 |
| Markdown em docs/ | 46 |
| Skills Claude Code | 36 |
| Agentes consultivos | 8 |
| Comandos Claude Code | 6 |
| Workflows GitHub Actions | 2 |
| project.godot | Ausente |
| Cenas .tscn | 0 |
| Scripts .gd | 4, todos exemplos/testes de skills |
| Assets de jogo (imagem/áudio/fonte) | 0 identificados |

O repositório continua sendo um ecossistema de documentação e ferramentas. O jogo executável ainda não foi iniciado. Os dois novos documentos desta preparação são a auditoria de pré-produção e o checklist de aceite da Etapa 0.

## Implementação e validação

- Projeto Godot e configuração Android: não implementados.
- Cenas/scripts de gameplay BOLT: não implementados.
- Assets finais: nenhum identificado ou integrado.
- Testes de gameplay: não executados.
- APK, instalação, emulador e aparelho físico: não comprovados.
- FPS, frame time, memória e estabilidade Android: não medidos.

## CI observado na base auditada

- [Run documental #96](https://github.com/jyanzy19-yml/new-bolt-aventura/actions/runs/45700675751): SUCCESS; validação documental e links/metadados concluídos.
- [Run Godot #6](https://github.com/jyanzy19-yml/new-bolt-aventura/actions/runs/45700675747): workflow SUCCESS, mas o log registra NOT APPLICABLE porque project.godot estava ausente. Nenhum teste de engine foi realizado.
- Esses runs pertencem à base auditada antes dos documentos de pré-produção desta rodada. As novas alterações documentais disparam nova validação; consultar Actions para o resultado do HEAD mais recente.
- Nenhum workflow atual exporta APK ou certifica gameplay/performance Android.

## Colaboração

Fonte canônica: [COLLABORATION_STATE.md](COLLABORATION_STATE.md).

- Estado PENDING; nenhum escritor ativo.
- Etapa 0: Claude Code — fundação executável Godot.
- Etapa 1: ChatGPT — revisar a Etapa 0 e implementar a próxima unidade do roadmap.
- Um escritor por vez; o usuário aciona manualmente o próximo agente.
- Consulte [checklist de execução e aceite da Etapa 0](ETAPA_0_CLAUDE_CHECKLIST.md) antes de iniciar.
- A Etapa 1 não começa antes da inspeção do commit e do handoff reais da Etapa 0.

## PR #1

A [PR #1](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/1) continua aberta e divergente. A comparação da base auditada de main com docs/master-directive-bolt indicou 17 commits exclusivos na PR e 94 exclusivos em main; estado diverged. A PR contém 17 arquivos, incluindo uma diretiva em 12 partes que se sobrepõe a documentos já existentes. Não mesclar, fechar ou reaproveitar automaticamente.

## Próxima ação

Claude Code executa a Etapa 0 conforme [checklist dedicado](ETAPA_0_CLAUDE_CHECKLIST.md): reconfirmar repositório/branch/PRs; ler diretrizes e skills pertinentes; detectar versão Godot 4.x e renderer; criar project.godot, estrutura mínima, configuração Android/paisagem, Input Map e cena inicial; executar import/parse se possível; atualizar tracker, continuidade, estado e handoff.

Não antecipar gameplay de etapas posteriores. Não inventar versão, build, teste ou métrica.

## Referências

- [Pipeline de CI](CI_AND_VALIDATION_PIPELINE.md)
- [Pipeline de assets](ASSET_PIPELINE.md)
- [Matriz QA](../qa/test-matrix.md)
- [Template de teste Android](../qa/ANDROID_DEVICE_TEST_TEMPLATE.md)
- [Contratos entre sistemas](../technical/05-system-contracts.md)
- [Roadmap](roadmap.md)
- [Tracker de 24 sistemas e 42 fases](implementation-tracker.md)
- [Auditoria de pré-produção](PREPRODUCTION_AUDIT.md)


## Atualização — Etapa 0 entregue (2026-11-26)

Etapa 0: HANDOFF_READY. Existe projeto Godot 4.7.2 executável com base de movimento/touch/HUD e sandbox de desenvolvimento (não é fase da campanha). Validação: L2 headless. Sem APK, sem validação em aparelho, sem fases W#-L#. Ver [handoff](handoffs/HANDOFF_ETAPA_0.md) e [tracker](implementation-tracker.md).
