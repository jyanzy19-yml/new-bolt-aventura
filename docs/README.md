# BOLT · AVENTURA — Índice de documentação

O jogo está sendo reconstruído do zero como produto HTML5, com Android como plataforma-alvo. A stack ativa é HTML5, CSS3, JavaScript ES Modules, Canvas 2D e Vite; Web Audio API e Pointer Events suportam áudio e input. Capacitor é candidato de empacotamento, ainda sujeito a validação.

## Entradas obrigatórias
- [Diretiva mestre](../MASTER_DIRECTIVE.md) — missão, canon, stack, autoridade, colaboração e gates.
- [Contrato comum dos agentes](../AGENTS.md).
- [Instruções Claude Code](../CLAUDE.md).
- [Dossiê histórico](../BOLT_MASTER_CONTEXT.md) — fonte original de contexto, com instruções Godot explicitamente superadas pelo addendum HTML5.
- [Dossiê mestre compartilhado](../BOLT_SHARED_MASTER_CONTEXT.md) — contexto atualizado para ChatGPT e Claude Code: canon, stack HTML5, estado verificável, governança e próximos trabalhos.
- [Contexto consolidado HTML5](PROJECT_CONTEXT_HTML5.md) — requisitos de produto adaptados à decisão atual.
- [Estado de colaboração](production/COLLABORATION_STATE.md).
- [Continuidade](production/CONTINUITY.md).
- [Inventário e limpeza do legado](production/REPOSITORY_CLEANUP_2026-11-28.md).

## Skills, agentes e comandos
- `.claude/skills/router/SKILL.md` — roteador principal.
- `.claude/skills/` — skills ativas de arquitetura, Canvas, gameplay, mobile, Android, assets, QA e CI.
- `.claude/agents/` — revisores consultivos read-only.
- `.claude/commands/` — comandos de continuidade, handoff e revisão.

## Fontes de design
Os documentos em `game-design/` são a referência para canon, personagens, mundos, campanha, gameplay, arte, áudio e UX. Não inventar nomes, sequência ou revelações que não estejam aprovados.

## Produção e QA
- `production/` — roadmap, ownership, handoffs, decisões, continuidade, rastreabilidade e gates.
- `qa/` — matriz de testes, templates e evidências.
- `architecture/`, `assets/`, `performance/`, `release/` — contratos técnicos HTML5 e planejamento de plataforma.
- `technical/` — material técnico histórico; cada documento precisa ser conferido contra a stack HTML5 antes de reutilização. `06-godot-project-foundation.md` é apenas registro histórico, não instrução ativa.

## Regra de evidência
A documentação não comprova que uma funcionalidade existe. Diferenciar planejado, implementado, testado e validado. APK exportado não equivale a instalação nem a teste em aparelho físico.
