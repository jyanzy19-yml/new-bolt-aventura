# BOLT · AVENTURA — Índice de documentação

O projeto está sendo criado do zero como jogo HTML5 para Android. Godot/GDScript e documentos técnicos exclusivos dessa engine são históricos e não constituem instruções para a nova implementação.

## Entradas obrigatórias
- [Diretiva mestre](../MASTER_DIRECTIVE.md) — missão, canon, stack, autoridade, colaboração e gates.
- [Instruções comuns dos agentes](../AGENTS.md).
- [Instruções Claude Code](../CLAUDE.md).
- [Contexto consolidado HTML5](PROJECT_CONTEXT_HTML5.md).
- [Estado de colaboração](production/COLLABORATION_STATE.md).
- [Protocolo colaborativo](production/COLLABORATIVE_DEVELOPMENT_PROTOCOL.md).
- [Plano de reconstrução](production/HTML5_REBUILD_PLAN.md).
- [Continuidade](production/CONTINUITY.md).

## Engenharia HTML5
- [Contratos do runtime](architecture/HTML5_RUNTIME_CONTRACTS.md).
- [ADR-0001 — clean-start HTML5](decisions/ADR-0001-HTML5-CLEAN-START.md).
- [Template ADR](decisions/ADR-TEMPLATE.md).
- [Pipeline de assets](assets/ASSET_PIPELINE.md).
- [Perfil de performance Android](performance/ANDROID_PERFORMANCE_PROFILE.md).
- [Estratégia de testes](qa/HTML5_TEST_STRATEGY.md).

## Produção e colaboração
- [Workflow de 26 etapas](production/26_STAGE_WORKFLOW.md) — organização do trabalho; o prompt mestre continua soberano.
- [Template de fase](production/LEVEL_SPEC_TEMPLATE.md).
- [Template de tarefa multiagente](production/AGENT_TASK_TEMPLATE.md).
- [Definition of Done](production/DEFINITION_OF_DONE.md).
- [Governança do repositório](production/REPOSITORY_GOVERNANCE.md).
- [Configuração do GitHub Actions](production/GITHUB_ACTIONS_SETUP.md).
- [Lockfile e dependências](production/LOCKFILE_AND_DEPENDENCIES.md).
- [Checklist de release Android](release/ANDROID_RELEASE_CHECKLIST.md).

## Skills, agentes e comandos
- `.claude/skills/router/SKILL.md` — roteador.
- `.claude/skills/` — especializações HTML5, gameplay, mobile, performance, assets, QA e colaboração.
- `.claude/agents/` — revisores consultivos read-only.
- `.claude/commands/` — continuidade, handoff e revisão.

## Fontes de design
Os documentos em `game-design/` devem ser consultados para canon, personagens, mundos, campanha, gameplay e UI/UX. Antes de usar especificações técnicas antigas, confirmar compatibilidade com HTML5 e a decisão mais recente do usuário. Não converter instruções Godot mecanicamente para JavaScript.

## Regra de evidência
Documentação não comprova funcionalidade. Diferenciar PLANNED, IMPLEMENTED, TESTED e VERIFIED. Não declarar limpeza do legado sem inventário completo da árvore Git.
