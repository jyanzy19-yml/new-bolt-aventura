# BOLT · AVENTURA

**Jogo 2D de plataforma, ação e aventura criado do zero em HTML5, com Android como plataforma-alvo.**

## Comece aqui
1. [MASTER_DIRECTIVE.md](MASTER_DIRECTIVE.md) — diretiva soberana, canon, tecnologia, workflow e colaboração.
2. [AGENTS.md](AGENTS.md) — contrato comum dos agentes.
3. [CLAUDE.md](CLAUDE.md) — instruções específicas para Claude Code.
4. [docs/PROJECT_CONTEXT_HTML5.md](docs/PROJECT_CONTEXT_HTML5.md) — contexto do produto sob a decisão HTML5.
5. [docs/production/](docs/production/) — planejamento, status, handoffs e evidências.
6. [W1-L1 — implementação jogável](docs/production/W1-L1-PLAYABLE-IMPLEMENTATION.md) — conteúdo, mapa, objetivos, QA e limitações da primeira fase.

## Stack oficial
- HTML5, CSS3 e JavaScript ES Modules
- Canvas 2D
- Vite
- Web Audio API (integração de áudio ainda pendente)
- Pointer Events e multitouch
- Capacitor como candidato de empacotamento Android, condicionado a validação técnica

Godot/GDScript não fazem parte da implementação ativa. O jogo é uma reconstrução clean-start, não um port ou migração.

## Estado técnico
A PR [#162](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/162) agrega o runtime HTML5 da PR #161 e implementa W1-L1 como primeiro blockout jogável: câmara de despertar, corredor desmoronado, pátio aberto e abrigo de manutenção; personagem, câmera, colisões, salto, pulo duplo, Dash, interação, unidade de manutenção, compartimento opcional, objetivos e sincronização final.

O conteúdo usa arte vetorial placeholder, sem aprovação de arte final. Áudio, save persistente, combate armado, W1-L2, Capacitor e validação em Android físico continuam pendentes. A PR ainda não foi integrada à main.

## Executar W1-L1
Requisitos: Node.js 22+ e npm 10+.

\`\`\`bash
npm ci
npm run dev
\`\`\`

Abra o endereço local exibido pelo Vite e pressione **INICIAR FASE**.

### Controles
- **A / ←**: mover para a esquerda
- **D / →**: mover para a direita
- **Espaço / W / Z**: salto e pulo duplo
- **Shift / C**: Dash
- **E / Enter**: interagir com o compartimento ou ponto de sincronização
- **P / Esc**: pausar
- **Touch**: movimento, PULAR, DASH e AÇÃO

### Verificações
\`\`\`bash
npm run lint
npm test
npm run build
\`\`\`

Os valores de movimento reutilizam a configuração da fixture de runtime anterior e permanecem provisórios; não são balanceamento final aprovado. O blockout serve para validar fluxo, legibilidade e integração antes da produção de arte e áudio finais.

## Colaboração
ChatGPT e Claude Code são agentes implementadores autorizados. Cada tarefa deve ter um escritor primário, escopo delimitado, branch isolada e revisão. Não editar os mesmos arquivos simultaneamente. Registrar resultados reais de testes e limitações.

## Skills e agentes
- Skills: \`.claude/skills/\` — comece pelo \`router\`.
- Agentes consultivos: \`.claude/agents/\` — revisões read-only.
- Comandos: \`.claude/commands/\` — continuidade, handoff e revisão.

## Qualidade e evidência
Não prometer ausência absoluta de bugs. Prevenir regressões com lint, testes, build, revisão de diff e validação em browser/WebView/dispositivo conforme o nível exigido. Não confundir planejado, implementado, testado e verificado.
