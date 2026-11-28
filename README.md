# BOLT · AVENTURA

**Jogo 2D de plataforma, ação e aventura criado do zero em HTML5, com Android como plataforma-alvo.**

## Comece aqui
1. [MASTER_DIRECTIVE.md](MASTER_DIRECTIVE.md) — diretiva soberana, canon, tecnologia, workflow e colaboração.
2. [AGENTS.md](AGENTS.md) — contrato comum dos agentes.
3. [CLAUDE.md](CLAUDE.md) — instruções específicas para Claude Code.
4. [docs/PROJECT_CONTEXT_HTML5.md](docs/PROJECT_CONTEXT_HTML5.md) — contexto do produto sob a decisão HTML5.
5. [docs/production/](docs/production/) — planejamento, status, handoffs e evidências.

## Stack oficial
- HTML5, CSS3 e JavaScript ES Modules
- Canvas 2D
- Vite
- Web Audio API
- Pointer Events e multitouch
- Capacitor como candidato de empacotamento Android, condicionado a validação técnica

Godot/GDScript não fazem parte da implementação ativa. O jogo é uma reconstrução clean-start, não um port ou migração.

## Estado técnico
A fundação HTML5/Vite está integrada à main: shell inicial, lint, Vitest, build web, CodeQL e dependências reproduzíveis via package-lock.json e npm ci. O inventário de 28/11/2026 removeu 169 paths exclusivamente Godot da árvore ativa, preservando canon, bíblias e histórico Git. Isso ainda não representa gameplay, vertical slice, integração Capacitor, APK ou validação física Android.

## Colaboração
ChatGPT e Claude Code são agentes implementadores autorizados. Cada tarefa deve ter um escritor primário, escopo delimitado, branch isolada e revisão. Não editar os mesmos arquivos simultaneamente. Registrar resultados reais de testes e limitações.

## Skills e agentes
- Skills: .claude/skills/ — comece pelo router.
- Agentes consultivos: .claude/agents/ — revisões read-only.
- Comandos: .claude/commands/ — continuidade, handoff e revisão.

## Qualidade e evidência
Não prometer ausência absoluta de bugs. Prevenir regressões com lint, testes, build, revisão de diff e validação em browser/WebView/dispositivo conforme o nível exigido. Não confundir planejado, implementado, testado e verificado.
