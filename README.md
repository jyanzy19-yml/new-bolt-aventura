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
A PR de integração [#161](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/161) compõe uma primeira fatia jogável de depuração: movimento, salto, pulo duplo, Dash, colisão estática, câmera, Canvas 2D e controles touch. O conteúdo W1-L1 é uma fixture marcada como não aprovada para produção. A integração ainda não está na `main` e não representa a fase final, APK Android ou validação física.

## Executar o protótipo de depuração
Requisitos: Node.js 22+ e npm 10+.

```bash
npm ci
npm run dev
```

Abra o endereço local exibido pelo Vite. Para validar o projeto:

```bash
npm run lint
npm test
npm run build
```

Controles temporários do protótipo:
- **A / ←**: mover para a esquerda
- **D / →**: mover para a direita
- **Espaço / W / Z**: pular e executar pulo duplo
- **Shift**: Dash
- Em telas touch: botões de movimento, PULAR e DASH

A geometria, as teclas e os valores de movimento dessa fixture são parâmetros de depuração. Não representam o layout definitivo nem balanceamento aprovado de W1-L1.

## Colaboração
ChatGPT e Claude Code são agentes implementadores autorizados. Cada tarefa deve ter um escritor primário, escopo delimitado, branch isolada e revisão. Não editar os mesmos arquivos simultaneamente. Registrar resultados reais de testes e limitações.

## Skills e agentes
- Skills: `.claude/skills/` — comece pelo `router`.
- Agentes consultivos: `.claude/agents/` — revisões read-only.
- Comandos: `.claude/commands/` — continuidade, handoff e revisão.

## Qualidade e evidência
Não prometer ausência absoluta de bugs. Prevenir regressões com lint, testes, build, revisão de diff e validação em browser/WebView/dispositivo conforme o nível exigido. Não confundir planejado, implementado, testado e verificado.
