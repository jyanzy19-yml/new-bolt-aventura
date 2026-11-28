# BOLT · AVENTURA

**Jogo 2D de plataforma, ação e aventura criado do zero em HTML5, com Android como plataforma-alvo.**

## Comece aqui
1. [MASTER_DIRECTIVE.md](MASTER_DIRECTIVE.md) — diretiva soberana, canon, tecnologia, workflow e colaboração ChatGPT/Claude.
2. [AGENTS.md](AGENTS.md) — regras comuns a qualquer agente.
3. [CLAUDE.md](CLAUDE.md) — instruções específicas para Claude Code.
4. [docs/PROJECT_CONTEXT_HTML5.md](docs/PROJECT_CONTEXT_HTML5.md) — contexto consolidado do produto adaptado à decisão HTML5.
5. [docs/production/](docs/production/) — planejamento, status, handoffs e evidências, quando disponíveis.

## Stack oficial
- HTML5, CSS3 e JavaScript ES Modules
- Canvas 2D
- Vite
- Web Audio API
- Pointer Events e multitouch
- Capacitor como candidato de empacotamento Android, condicionado a validação técnica

Godot/GDScript não fazem parte da nova implementação. O jogo está sendo criado do zero; não é port nem migração.

## Colaboração
ChatGPT e Claude Code estão autorizados a desenvolver. Cada tarefa deve ter um escritor primário, escopo e arquivos delimitados, branch isolada e revisão antes da integração. É proibido editar simultaneamente os mesmos arquivos. O usuário controla a sequência e o merge.

## Skills e agentes
- Skills: `.claude/skills/` — comece pelo `router` e carregue apenas as especializações pertinentes.
- Agentes consultivos: `.claude/agents/` — revisões focadas e read-only.
- Comandos: `.claude/commands/` — continuidade, handoff e revisão.

## Estado e evidência
A redefinição para HTML5 e a base de skills foram registradas. A limpeza dos arquivos antigos ainda exige inventário verificável da árvore completa. Não assumir que código, assets ou documentação Godot já foram removidos. Não confundir planejado, implementado, testado e validado em Android físico.
