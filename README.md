# BOLT · AVENTURA

<p align="center">
  <strong>Uma aventura 2D de plataforma, ação e ficção científica.</strong><br/>
  Desenvolvimento clean-start em HTML5, com Android como plataforma-alvo.
</p>

<p align="center">
  <img alt="Status: em desenvolvimento" src="https://img.shields.io/badge/status-em%20desenvolvimento-orange"/>
  <img alt="Stack: HTML5 Canvas" src="https://img.shields.io/badge/stack-HTML5%20%7C%20Canvas%202D-blue"/>
  <img alt="Agentes: ChatGPT + Claude" src="https://img.shields.io/badge/agents-ChatGPT%20%2B%20Claude-purple"/>
  <img alt="Plataforma: Android" src="https://img.shields.io/badge/platform-Android-green"/>
</p>

> **Importante:** o jogo está sendo criado do zero em HTML5. Não é port nem migração da implementação histórica Godot/GDScript. Stack vigente: HTML5, CSS3, JavaScript ES Modules, Canvas 2D e Vite.

## Comece por aqui
1. [MASTER_DIRECTIVE.md](MASTER_DIRECTIVE.md) — autoridade principal, canon, requisitos e regras de execução.
2. [AGENTS.md](AGENTS.md) — contrato comum dos agentes.
3. [CLAUDE.md](CLAUDE.md) — instruções do Claude Code.
4. [Contexto HTML5](docs/PROJECT_CONTEXT_HTML5.md).
5. [Estado de colaboração](docs/production/COLLABORATION_STATE.md).
6. [Índice de documentação](docs/README.md).

## Stack e ferramentas
| Camada | Tecnologia |
|---|---|
| Estrutura | HTML5 + CSS3 |
| Linguagem | JavaScript ES Modules |
| Renderização 2D | Canvas 2D |
| Dev server/build | Vite |
| Áudio | Web Audio API |
| Entrada | Pointer Events / multitouch |
| Android | Capacitor em avaliação, não declarado como concluído |
| Testes | Vitest |
| Qualidade | ESLint + Prettier |
| CI | GitHub Actions |

## Desenvolvimento local
Requisitos: Node.js 22 LTS (ou versão compatível em `.nvmrc`) e npm.

```bash
npm install
npm run dev
```

Validação:
```bash
npm run lint
npm test
npm run build
npm run preview
```

A primeira instalação deve gerar `package-lock.json`; mantenha-o versionado para builds reproduzíveis. Até isso ocorrer, o CI usa `npm install` como etapa transitória.

## Estrutura-alvo
```text
src/
  app/          # bootstrap e composição
  core/         # relógio, eventos, matemática e contratos
  runtime/      # loop, lifecycle e estados
  gameplay/     # regras e sistemas de jogo
  entities/     # player, inimigos, NPCs e bosses
  physics/      # movimento e colisões
  input/        # teclado, ponteiro e multitouch
  rendering/    # Canvas, câmera e renderização
  levels/       # carregamento e dados de fases
  ui/           # menus, HUD e overlays
  audio/        # Web Audio e buses
  persistence/ # save, checkpoints e migrações
  platform/     # adapters browser/Android
  assets/       # manifests e carregadores
tests/
docs/
.github/
.claude/
```

A estrutura é uma arquitetura-alvo; módulos só devem ser criados quando houver responsabilidade e consumidor reais. O scaffold inicial não é uma implementação de gameplay.

## Colaboração ChatGPT + Claude Code
Os dois agentes estão autorizados a implementar. Cada tarefa substancial tem um escritor primário, revisor, branch isolada, escopo/paths definidos e critérios de aceite. Não editar simultaneamente os mesmos arquivos. O usuário controla a integração.

- Skills: [`.claude/skills/`](.claude/skills/README.md)
- Agentes revisores: [`.claude/agents/`](.claude/agents/README.md)
- Comandos: [`.claude/commands/`](.claude/commands/README.md)
- Protocolo: [docs/production/COLLABORATIVE_DEVELOPMENT_PROTOCOL.md](docs/production/COLLABORATIVE_DEVELOPMENT_PROTOCOL.md)

## GitHub
- [Issues](../../issues) — bugs, tarefas e propostas.
- [Pull requests](../../pulls) — revisão e integração.
- [Actions](../../actions) — CI.
- [Security](../../security) — alertas e políticas, quando habilitados.

Consulte [CONTRIBUTING.md](CONTRIBUTING.md) antes de contribuir.

## Estado honesto
Esta fundação adiciona tooling e governança, não a campanha jogável. Não declara performance em Android, APK gerado ou validação física. A limpeza do legado ainda depende de inventário completo da árvore Git. Diferenciar sempre planejado, implementado, testado e verificado.
