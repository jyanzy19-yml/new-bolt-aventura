# Curated skills catalog — BOLT · AVENTURA

**Source collection:** [gamedev-skills/awesome-gamedev-agent-skills](https://github.com/gamedev-skills/awesome-gamedev-agent-skills)  
**Integration format:** Claude Code project skills, one `SKILL.md` per skill under `.claude/skills/<name>/`.  
**Selection policy:** focused set for a Godot 2D Android platform-adventure; this is not a full mirror of the upstream multi-engine collection.

## Router and Godot implementation
| Skill | Use |
|---|---|
| `router` | Classifies the game-development task and selects the smallest relevant skill set. |
| `godot-gdscript` | GDScript language patterns and engine-specific scripting. |
| `godot-nodes-scenes` | Scene tree, nodes, reusable scenes and scene composition. |
| `godot-signals-groups` | Signal wiring and node groups. |
| `godot-resources` | Reusable data/resources and resource loading. |
| `godot-2d-movement` | CharacterBody2D platform movement. |
| `godot-physics` | Collision bodies, areas, layers/masks and physics queries. |
| `godot-tilemap` | TileMapLayer/TileSet level construction and collision. |
| `godot-animation` | AnimatedSprite2D, AnimationPlayer/Tree and transitions. |
| `godot-ui-control` | Control nodes, anchors, containers, themes and focus. |
| `godot-audio` | Godot audio players and buses. |
| `godot-export` | Export configuration and platform packaging, including Android workflow checks. |
| `godot-gdscript-headless-testing` | Automated headless validation and test reporting. |

## Game design and disciplines
| Skill | Use |
|---|---|
| `platformer` | Platformer genre structure and common gameplay systems. |
| `input-systems` | Input abstraction, remapping and device/touch considerations. |
| `physics-tuning` | Frame-independent physics tuning and motion quality. |
| `game-feel` | Feedback, timing, animation response and readable impacts. |
| `camera-systems` | Camera follow, look-ahead, dead zones and bounds. |
| `level-design` | Pacing, traversal, challenge progression and level readability. |
| `game-ai` | Enemy behavior architecture and state-driven decision making. |
| `create-game-assets` | Art direction, asset pipelines, sprites and asset QA. |
| `dialogue-systems` | NPC dialogue and branching narrative structure. |
| `save-systems` | Save data, versioning, migration and recovery. |
| `performance-optimization` | Profiling-led performance and memory optimization. |
| `game-ui-ux` | HUD, menus, interaction flow, readability and accessibility. |
| `audio-design` | Music, sound effects, adaptive audio and mix design. |

## Skill adicional adaptada para BOLT

| Skill | Origem de referência | Uso e adaptação |
|---|---|---|
| `godot-project-structure` | Abordagem Function First descrita em [grndctrl/godot-skills](https://github.com/grndctrl/godot-skills) | Skill original reescrita para BOLT: organização por responsabilidade, dependências, posicionamento de arquivos e migrações seguras. Não copia scripts nem o texto da skill upstream; não impõe estrutura antes de existir um projeto Godot real. |

## How Claude should load skills
1. At the beginning of a new game-development task, read `router/SKILL.md`.
2. Identify the project's actual engine/version from its files. If there is no Godot project yet, report that and treat engine API details as provisional.
3. Read only the selected skill files needed for the current task. For example:
   - Player movement: `godot-2d-movement` + `input-systems` + `game-feel`.
   - Level production: `godot-tilemap` + `level-design` + `camera-systems`.
   - Enemy behavior: `game-ai` + `godot-physics` + `game-feel`.
   - Menus/HUD: `godot-ui-control` + `game-ui-ux` + `input-systems`.
   - Narrative/NPCs: `dialogue-systems` + `godot-signals-groups`.
   - Saves: `save-systems` + `godot-resources` + `godot-gdscript-headless-testing`.
   - Android build: `godot-export` + `performance-optimization`.
4. Check the APIs and commands in each skill against the actual Godot version and installed export templates. Upstream skills may target a newer release.
5. Do not load all skills for every task; avoid unnecessary context consumption.

## Compatibility and provenance
The upstream repository describes its skills as authored from primary documentation and is distributed under Apache License 2.0. The original `LICENSE` and `NOTICE` are preserved in `THIRD_PARTY_NOTICES/awesome-gamedev-agent-skills/`. Each skill file is copied from the source collection without claiming it was authored by this project.

The upstream collection changes over time. Check the upstream repository before future updates; do not automatically overwrite local customizations. The presence of a skill does not guarantee compatibility with every Godot release or Android device.


## Pacote instalado e arquivos auxiliares

A seleção contém **26 skills**. Os arquivos de referência e exemplos de código citados pelas skills foram copiados para as pastas locais correspondentes, preservando seus caminhos relativos. O helper de relatório de assets também está disponível em create-game-assets/scripts.

O exemplo binário player-idle.png citado pela skill de arte não estava disponível na origem consultada e, portanto, não foi fabricado nem incluído. A própria skill recebeu uma nota explicando que esse caminho é ilustrativo e deve ser substituído por um asset real do projeto.

## Agentes consultivos do projeto

Em .claude/agents/ existem oito revisores especializados, todos configurados como read-only:
- game-architect
- gameplay-engineer
- narrative-designer
- level-designer
- android-performance-engineer
- qa-engineer
- ui-ux-designer
- art-audio-director

Eles apoiam auditorias e recomendações; não substituem aprovação do usuário nem executam mudanças por conta própria.

## Documentação de produto e engenharia

O índice em docs/README.md conecta as bíblias de design, especificações Android/Godot, roadmap, critérios de conclusão, matriz de QA, templates e registros de decisão. Este catálogo não fixa a versão exata do Godot; ela será registrada após detecção no projeto real. Os nomes e a sequência dos sete mundos são canon definidos na Bíblia dos Mundos e no prompt mestre.


## Skills originais específicas do BOLT (9)
| Skill | Uso |
|---|---|
| `bolt-android-touch` | Multitouch, buffer de input, salto/dash, interrupções e safe areas Android. |
| `bolt-performance-validation` | Baselines, frame time, CPU/GPU, memória, loading e validação térmica. |
| `bolt-boss-encounters` | Fases, telegraphs, arenas, fragmentos e justiça dos chefes. |
| `bolt-cinematic-sequences` | Cutscenes, câmera, diálogo, skip/replay e flags narrativas. |
| `bolt-world-continuity` | Continuidade dos sete mundos, fragmentos, NPCs e progressão. |
| `bolt-save-integrity` | Save versionado, checkpoints, migração, recuperação e integridade. |
| `bolt-mobile-ui` | HUD, menus, ergonomia touch, safe areas e acessibilidade. |
| `bolt-content-pipeline` | Proveniência, licenças, importação, sprites, áudio e orçamento de memória. |
| `bolt-production-gates` | Planejamento incremental, aprovações, evidências e critérios de conclusão. |

Total atual: **36 skills** (26 skills selecionadas da coleção Apache-2.0 + 1 skill de estrutura original adaptada com referência comunitária + 9 originais BOLT). Total de comandos Claude Code: **6**.

## Comandos de projeto
- `/bolt-audit` — auditoria read-only do estado real do repositório/projeto.
- `/bolt-plan` — plano de implementação com limites e aprovações.
- `/bolt-qa` — matriz focada de testes e regressão.
- `/bolt-android-review` — revisão de input, display, export e desempenho Android.
- `/bolt-continue` — retomada de produção a partir do estado verificado e do handoff.
- `/bolt-release-check` — auditoria read-only de prontidão para release Android.

Os comandos estão em `.claude/commands/` e são instruções de fluxo para Claude Code; não são agentes autônomos nem executam automaticamente testes.
