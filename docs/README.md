# BOLT · AVENTURA — Índice de documentação

O projeto está sendo criado do zero como jogo HTML5 para Android. Godot/GDScript e documentos técnicos exclusivos dessa engine são históricos e não constituem instruções para a nova implementação.

## Entradas obrigatórias
- [Diretiva mestre](../MASTER_DIRECTIVE.md) — missão, canon, stack, autoridade, colaboração e gates.
- [Instruções comuns dos agentes](../AGENTS.md).
- [Instruções Claude Code](../CLAUDE.md).
- [Contexto consolidado HTML5](PROJECT_CONTEXT_HTML5.md) — adaptação do dossiê mestre fornecido pelo usuário.
- [Estado de colaboração](production/COLLABORATION_STATE.md) — escritor, revisor, branch, handoff e ownership.
- [Protocolo colaborativo](production/COLLABORATIVE_DEVELOPMENT_PROTOCOL.md).
- [Continuidade](production/CONTINUITY.md).

## Skills, agentes e comandos
- `.claude/skills/router/SKILL.md` — roteador de skills.
- `.claude/skills/` — especializações de arquitetura, Canvas, gameplay/physics, input mobile, performance Android, assets/audio, QA, Capacitor, colaboração, level design, enemy/boss, save integrity, UI/accessibility e CI.
- `.claude/agents/` — revisores consultivos read-only.
- `.claude/commands/` — comandos de continuidade, handoff e revisão.

## Fontes de design
Os documentos em `game-design/` devem ser consultados para canon, personagens, mundos, campanha, gameplay e UI/UX. Antes de usar qualquer especificação técnica antiga, confirme compatibilidade com a stack HTML5 e a decisão mais recente do usuário. Não converter instruções Godot mecanicamente para JavaScript.

## Produção e QA
- `production/` — roadmap, estado, handoffs, colaboração, decisões e continuidade.
- `technical/` — consultar apenas documentos ainda compatíveis; atualizar ou substituir especificações Godot quando houver escopo e inventário confirmados.
- `qa/` — adaptar critérios de validação para browser, Canvas, WebView e Android físico.

## Regra de evidência
A documentação não comprova que uma funcionalidade existe. Diferenciar planejado, implementado, testado e validado. Não declarar limpeza do legado concluída sem inventário completo da árvore Git.
