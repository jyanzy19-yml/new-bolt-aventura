# Catálogo de skills — BOLT · AVENTURA

## Política de seleção

A implementação ativa é clean-start HTML5: HTML5, CSS3, JavaScript ES Modules, Canvas 2D, Vite, Web Audio API e Pointer Events. Capacitor permanece candidato de empacotamento Android sujeito à validação. Este catálogo não é um espelho completo de coleções externas.

## Engenharia HTML5 e plataforma

| Skill | Uso |
|---|---|
| `router` | Seleciona o menor conjunto de skills pertinente à tarefa |
| `html5-game-architecture` | Arquitetura, módulos, dependências e lifecycle |
| `canvas2d-runtime` | Canvas 2D, câmera, frame loop e viewport |
| `canvas-rendering-performance` | Profiling de renderização, backing store e frame pacing |
| `web-tooling-ci` | Vite, dependências, CI e higiene do repositório |
| `browser-webview-compatibility` | APIs de browser, WebView e system UI |
| `android-web-performance` | Memória, performance e térmica em Android |
| `android-capacitor-packaging` | Avaliação e empacotamento nativo via Capacitor |

## Gameplay, conteúdo e UX

| Skill | Uso |
|---|---|
| `gameplay-physics-loop` | Simulação, movimento, colisão, combate e Dash |
| `deterministic-gameplay-testing` | Testes determinísticos e regressões |
| `mobile-input-ux` | Touch, multitouch, Pointer Events e safe areas |
| `enemy-boss-design` | Arquétipos de inimigos, chefes e telegraphs |
| `level-design-content` | Campanha, mundos, fases e checkpoints |
| `persistence-save-integrity` | Schema versionado, saves e recuperação |
| `assets-loading-audio` | Manifestos, loading, decode e áudio |
| `asset-provenance-qa` | Licenciamento, origem e aprovação de assets |
| `web-game-qa` | Estratégia de testes e critérios de release |
| `ui-ux-accessibility` | Interface, acessibilidade e ergonomia |
| `collaborative-development` | Trabalho coordenado entre ChatGPT e Claude Code |

## Disciplinas complementares

As skills engine-neutral de áudio, câmera, diálogo, game AI, game feel, UI, input, level design, otimização, física, platformer, saves e criação de assets continuam utilizáveis quando suas recomendações forem compatíveis com Canvas 2D e browser APIs.

## Skills legadas

Skills exclusivamente Godot/GDScript não fazem parte da seleção ativa e foram removidas do diretório operacional. O histórico Git preserva os arquivos anteriores para consulta histórica. Não reinstalar essas skills como instruções de implementação sem decisão explícita do usuário.

## Regras de uso

1. Ler `MASTER_DIRECTIVE.md`, `AGENTS.md` e o handoff ativo.
2. Identificar o subsistema e carregar somente skills pertinentes.
3. Tratar exemplos externos como referências, não como autoridade.
4. Separar PLANNED, IMPLEMENTED, TESTED e VERIFIED.
5. Não declarar compatibilidade Android física com base apenas em testes desktop.
