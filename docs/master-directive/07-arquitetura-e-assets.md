# Parte 07 — Arquitetura Godot e pipeline de assets

## 23. Arquitetura Godot

Usar Godot Engine 4.x estável e GDScript. Detectar versão real antes de selecionar APIs. Arquitetura modular, reutilizável e sustentável, sem scripts monolíticos e sem fragmentação excessiva.

Utilizar conforme necessidade: Scene/Node/Resource Systems, Signals, CharacterBody2D, Area2D, PhysicsBody2D, AnimationPlayer, AnimatedSprite2D, AnimationTree, TileMapLayer, Camera2D, ResourceLoader, AudioStreamPlayer, Autoloads e Resources personalizados.

Cada sistema tem responsabilidade clara; separar estado, UI, input, apresentação e persistência quando fizer sentido.

### 23.1. Estrutura sugerida

```text
new-bolt-aventura/
├── project.godot
├── README.md
├── CHANGELOG.md
├── export_presets.cfg
├── scenes/
│   ├── boot/ menus/ gameplay/ player/ enemies/ bosses/ npc/ weapons/ objects/
│   ├── worlds/
│   │   ├── cybercore/ egypt/ speakeasy/ dark_fantasy/
│   │   ├── medieval/ vaporwave/ winter_city/
│   ├── cinematics/ ui/
├── scripts/
│   ├── core/ player/ enemies/ bosses/ combat/ world/ progression/
│   ├── save/ audio/ ui/ android/
├── resources/
│   ├── characters/ enemies/ weapons/ items/ levels/ configuration/
├── assets/
│   ├── characters/ enemies/ bosses/ environments/ backgrounds/ tilesets/
│   ├── ui/ effects/ audio/ fonts/
├── docs/
│   ├── design/ narrative/ worlds/ levels/ technical/ qa/ android/ art/
├── tests/
├── android/
└── .github/workflows/build-android.yml
```

A estrutura é proposta, não obrigação. Ajustar quando houver solução tecnicamente melhor; preservar separação por responsabilidade e descoberta fácil dos recursos.

## 24. Assets e direção de arte

Criar `docs/art/MASTER_ASSET_LIST.md` com Bolt, NEXO, robôs mensageiros, nove aparências, inimigos, chefes, NPCs, tilesets, cenários, plataformas, armadilhas, baús, fragmentos, itens lendários, UI, efeitos, animações e elementos ambientais.

Para cada asset registrar: nome, função, dimensões, resolução, frames, layout, transparência, pivô, escala, formato, nomenclatura, animações necessárias e mundo correspondente.

### 24.1. Integração de artes

Artes finais serão produzidas com auxílio do ChatGPT Image Generation. Responsabilidades do pipeline: identificar necessidades; criar especificações e prompts precisos; definir proporções/dimensões; manter consistência; organizar arquivos recebidos; validar qualidade; integrar no Godot; ajustar pivôs, colisões e animações.

Nunca fingir que assets foram recebidos. Placeholders técnicos podem ser usados temporariamente, identificados como PLACEHOLDER e rastreados na fila de assets; nunca tratá-los como arte final. Se um asset depender do usuário, registrar a dependência e continuar as tarefas não bloqueadas.
