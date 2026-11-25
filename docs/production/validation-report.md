# Relatório de validação — ecossistema BOLT

**Data:** 2026-11-25  
**Branch:** main  
**Escopo:** documentação, skills, agentes, comandos Claude Code e automação de validação.

## Resultado da validação estrutural

| Grupo | Quantidade | Verificação |
|---|---:|---|
| Skills Claude | 35 | 26 skills comunitárias previamente verificadas + 9 skills BOLT novas; as 9 novas foram recuperadas do GitHub e validadas quanto à presença, frontmatter, nome do diretório e descrição |
| Agentes especializados | 8 | Arquivos existentes; configuração read-only documentada |
| Comandos Claude Code | 4 | Arquivos recuperados e frontmatter/descrição verificados |
| Documentos em docs/ | 34 | Conteúdo não vazio; os 25 destinos Markdown do índice docs/README.md foram recuperados com sucesso |
| Arquivos de orientação raiz | 4 | README, CLAUDE, AGENTS e catálogo recuperados após atualização |
| Arquivos auxiliares das skills upstream | 39 | Validação estrutural registrada na auditoria anterior |
| Atribuição | 2 | LICENSE e NOTICE preservados |
| Automação e contribuição | 5 | Script Python, workflow GitHub Actions, dois issue forms e template de pull request criados e recuperados |

## Trabalho concluído nesta etapa
- Adicionadas nove skills originais específicas do BOLT para Android touch, performance, chefes, cutscenes, continuidade dos mundos, saves, UI mobile, pipeline de assets e gates de produção.
- Criados quatro comandos Claude Code: /bolt-audit, /bolt-plan, /bolt-qa e /bolt-android-review.
- Adicionadas bíblias e especificações complementares de arte/áudio, contratos entre sistemas e gestão de mudanças.
- Atualizados README, CLAUDE.md, AGENTS.md, catálogo de skills e índice de documentação.
- Criado script de validação estrutural e workflow GitHub Actions para validar metadados Claude e links Markdown locais.
- Criados formulários de issue para bugs e propostas, além de template de pull request.

## Atualização documental — mandato de criação do zero

Nesta revisão foram adicionados o mandato operacional de implementação integral do zero e sua referência obrigatória em `MASTER_DIRECTIVE.md`, `CLAUDE.md`, `AGENTS.md`, READMEs, prompt mestre e roadmap; foram reconciliadas as Bíblias de visão geral, narrativa, mundos e personagens com o prompt mestre; e foi registrada a ADR-0003 para a política de barras do sistema Android. Os arquivos atualizados foram recuperados novamente do GitHub após os commits e inspecionados quanto à presença e ao conteúdo esperado. Foram verificados 7 links locais no README raiz e 43 no índice docs/README.md, sem destinos ausentes. A árvore da branch main contém 133 arquivos; não contém project.godot nem cenas .tscn, e os quatro scripts .gd existentes são exemplos/testes das skills, não código do jogo.

Esta revisão não implementou código Godot, cenas, assets do jogo, build ou APK. A verificação desta etapa é documental e não substitui execução do CI, testes Godot ou validação Android.

## Método e limites
A validação realizada nesta conversa foi por leitura dos arquivos recuperados do GitHub, inspeção de conteúdo/frontmatter e verificação de existência dos destinos listados no índice principal de documentação. Não foi executado o script Python em checkout local nem foi observado um resultado de execução do GitHub Actions; portanto, o CI recém-criado aguarda sua primeira execução confirmada.

Não foi executado Claude Code neste ambiente. Não foram executados testes GDScript, build/export, instalação APK, testes em dispositivos Android, medições de FPS/memória ou validação visual do jogo.

## Conclusão
**Ecossistema documental, skills e fluxos: arquivos criados e verificados estruturalmente por recuperação do GitHub.**  
**CI: configurado; execução ainda não confirmada.**  
**Jogo Godot e APK: não avaliados nesta etapa.**

Próximo gate: auditar o projeto executável, identificar versão Godot/renderer e submeter o primeiro vertical slice para aprovação.
