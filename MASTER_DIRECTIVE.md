# BOLT · AVENTURA — MASTER DEVELOPMENT PROMPT
## Diretriz soberana de criação integral do jogo em HTML5

**Projeto:** BOLT · AVENTURA  
**Repositório:** `jyanzy19-yml/new-bolt-aventura`  
**Estado:** REINÍCIO TOTAL DA IMPLEMENTAÇÃO — jogo criado do zero.  
**Stack:** HTML5, CSS3, JavaScript ES Modules, Canvas 2D, Web Audio API e Vite.  
**Destino principal:** Android, com empacotamento Capacitor após validação.  
**Orientação:** paisagem. **Idioma:** pt-BR.

## 1. MISSÃO

Criar BOLT · AVENTURA do zero como jogo 2D completo, modular, profissional e otimizado para Android. Isto NÃO é migração de Godot. Não portar GDScript, cenas, autoloads, plugins, testes ou arquitetura da engine. O runtime anterior é descartado como base de implementação. A nova implementação começa limpa.

Preservar integralmente o prompt, o canon, a identidade e a experiência pretendida. A mudança autorizada é tecnológica: Godot/GDScript deixam de fazer parte do projeto e são substituídos por HTML5 modular. Não reduzir o jogo a uma demo ou protótipo.

## 2. PRESERVAÇÃO DE CONTEÚDO

Preservar história, cronologia, arcos, diálogos e cutscenes aprovados; BOLT, NEXO, o Arquiteto, Grande Colapso e Núcleo da Eternidade; sete mundos, sete fragmentos, guardiões e campanha planejada de 42 fases; personagens, NPCs, inimigos, chefes, itens, habilidades, armas e progressão aprovados; identidade visual, arte, áudio, atmosfera, HUD, menus, UX, acessibilidade, salvamento, checkpoints, mecânicas aprovadas (incluindo Dash), metas Android e requisitos de qualidade.

Não inventar lacunas como canon. Classificar conteúdo como CANON, REQUIREMENT, PROPOSAL, TBD, IMPLEMENTED, TESTED ou VERIFIED. Descrição não é evidência de implementação.

## 3. STACK E ARQUITETURA

- HTML semântico para shell e superfícies DOM; CSS moderno para layout, responsividade e safe areas.
- JavaScript moderno com ES Modules; evitar framework de UI sem necessidade demonstrada.
- Canvas 2D para renderização principal; Vite para desenvolvimento e build.
- Web Audio API para áudio; Pointer Events para input unificado e multitouch.
- Persistência versionada com IndexedDB/localStorage conforme necessidade.
- Capacitor para APK/AAB após avaliação; PWA é complementar, não substitui automaticamente o aplicativo Android.

Arquitetura de referência: `index.html`, `package.json`, `vite.config.js`, `src/core`, `src/runtime`, `src/gameplay`, `src/entities`, `src/physics`, `src/input`, `src/rendering`, `src/camera`, `src/levels`, `src/ui`, `src/audio`, `src/persistence`, `src/platform`, `assets`, `data`, `tests`, `scripts`, `docs`. Ajustar com justificativa técnica. Separar responsabilidades sem microfragmentação, dependências circulares ou estado global implícito. Definir contratos e ciclo de vida explícitos.

## 4. RUNTIME E GAMEPLAY

Implementar loop com timestep fixo para simulação, renderização desacoplada, delta limitado, relógio monotônico e tratamento de suspensão/retomada. Física não depende do FPS.

Especificar e testar máquina de estados do jogador, movimento, aceleração/desaceleração, controle aéreo, salto, buffer, coyote time, pulo adicional conforme canon, Dash, colisões, plataformas, knockback, invulnerabilidade, combate, projéteis, armas, inimigos, chefes, telegraphs, câmera, checkpoints, morte/respawn, itens, fragmentos, progressão, diálogos, cutscenes, menus e HUD. Preservar a intenção e sensação das mecânicas aprovadas. Medir parâmetros não definidos; não apresentá-los como decisões aprovadas.

## 5. ANDROID E MOBILE

Android é prioritário. Considerar aparelhos com cerca de 4 GB RAM e MediaTek Helio G99 ou inferiores. Landscape, viewport adaptável, safe areas, recortes e barras do sistema devem ser tratados conscientemente. Dimensionar Canvas por resolução lógica e DPR limitado por orçamento.

Input touch é requisito crítico: Pointer Events, pointerId, pointer capture, multitouch simultâneo, latência baixa e limpeza em pointercancel, blur, visibilitychange, pause, troca de tela e rotação. Salto e Dash devem responder mesmo sob stutter. Não depender do próximo frame para registrar toque. Validar em dispositivos reais.

Meta de 60 FPS quando o hardware sustentar, sem prometer universalidade. Medir frame time, p95/p99, memória, long tasks, GC, latência e aquecimento. Reduzir alocações no hot path, overdraw, filtros caros, superfícies excessivas e trabalho por frame. Pooling apenas quando medição justificar.

## 6. ASSETS, LOADING, ÁUDIO E SAVE

Manter manifesto de assets, IDs estáveis, validação de referências, orçamento de memória, preload seletivo e liberação de recursos. Loading reflete trabalho real, mostra progresso/erro e bloqueia gameplay até prontidão; nunca inserir espera artificial.

Áudio deve respeitar gesto do usuário, ciclo suspend/resume do AudioContext, buses de volume, limites de vozes e cleanup. Save deve ter schema versionado, validação, migração, recuperação de corrupção e escrita resistente a interrupções. Separar preferências, progresso e estado transitório.

## 7. QUALIDADE

Configurar testes unitários, integração, contratos, regressão e browser tests adequados ao stack web. Cobrir loop, física, colisões, Dash, multitouch, pointercancel, UI, loading, assets, áudio, save/load, campanha, checkpoints, softlocks e build. Diferenciar IMPLEMENTED, TESTED e VERIFIED. Registrar commit, comandos, ambiente, aparelho, WebView/navegador, métricas e limitações. Nunca alegar testes não executados.

## 8. SKILLS

Skills em `.claude/skills/<nome>/SKILL.md`. Ler o router no início e carregar apenas as skills pertinentes:
- `html5-game-architecture`
- `canvas2d-runtime`
- `gameplay-physics-loop`
- `mobile-input-ux`
- `android-web-performance`
- `assets-loading-audio`
- `web-game-qa`
- `android-capacitor-packaging`

Skills são guias subordinados a este prompt; não substituem canon nem autoridade do usuário. Não usar skills de Godot como instruções válidas.

## 9. FLUXO DE PRODUÇÃO

1. Preservar este prompt como fonte soberana.
2. Limpar a implementação antiga: não manter runtime, cenas, scripts, testes ou documentação técnica exclusiva de Godot.
3. Criar estrutura HTML5 limpa e reprodutível.
4. Configurar tooling, lint, testes e build.
5. Definir contratos/ADRs essenciais.
6. Construir vertical slice para validar arquitetura.
7. Expandir sistemas centrais e produzir os sete mundos/42 fases.
8. Integrar narrativa, arte, áudio, UI, progressão e polimento.
9. Validar Android, desempenho, acessibilidade e regressões.
10. Entregar produto completo, não encerrar após planejamento ou protótipo.

## 10. POLÍTICA DO REPOSITÓRIO

No branch ativo, preservar este prompt e manter somente os arquivos mínimos para orientar agentes e as novas skills HTML5, além de configurações necessárias quando a implementação começar. Remover implementação Godot, skills Godot, agentes/comandos/workflows exclusivos de Godot, assets e documentos técnicos obsoletos/duplicados. Preservar o histórico Git. Antes de exclusões em massa, inventariar a árvore completa e garantir que `MASTER_DIRECTIVE.md` é o prompt a preservar. Nunca afirmar limpeza completa sem verificar todos os caminhos.

## 11. ENTREGA

Relatar escopo, arquivos criados/alterados/removidos, decisões, estado real, testes executados, testes não executados, riscos e próximo passo executável.

**Diretriz final:** construir BOLT · AVENTURA do zero em HTML5, preservando integralmente canon e experiência pretendida. Godot e GDScript não fazem mais parte do projeto.
