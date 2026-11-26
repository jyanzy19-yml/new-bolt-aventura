# Fundação do projeto Godot — estado real (Etapa 0)

**Escopo:** descreve o projeto Godot que **existe** no repositório. Complementa os princípios de [00-architecture-principles.md](00-architecture-principles.md) e os contratos de [05-system-contracts.md](05-system-contracts.md). Tudo marcado como **provisório** é decisão técnica reversível, não canon, e precisa de medição em aparelho Android antes de ser congelada.

## 1. Versão, renderer e ambiente

| Item | Valor | Evidência / status |
|---|---|---|
| Godot | **4.7.2 estável** (`4.7.2.stable.official.ed1daf0bf`) | `.godot-version`; `--headless --version` executado no ambiente de desenvolvimento |
| Renderer | **GL Compatibility** (desktop e mobile) | Decisão técnica provisória. Justificativa: jogo 2D, menor sobrecarga e maior compatibilidade em GPUs Android modestas (Mali-G57 do Helio G99). **Não medido em aparelho.** Reavaliar Mobile/Vulkan só com medição (ADR futura) |
| Linguagem | GDScript tipado | ADR-0002 |
| Export templates | **Não instalados** no ambiente de desenvolvimento | Exportação Android **não executada** (ver §7) |

O CI (`.github/workflows/godot-validation.yml`) baixa exatamente a versão de `.godot-version`. Atualizar a versão exige alterar esse arquivo, rodar os testes e registrar a mudança.

## 2. Exibição e orientação (ADR-0003)

- **Orientação:** `display/window/handheld/orientation=4` (*Sensor Landscape*: paisagem nas duas direções; retrato nunca é oferecido).
- **Viewport base:** 960×540, `stretch/mode=canvas_items`, `stretch/aspect=expand`. **Provisório.** A resolução-base de pixel art ainda não foi aprovada ([07-art-audio-direction.md](../game-design/07-art-audio-direction.md)); 960×540 é um valor de trabalho. Com `expand`, telas mais largas que 16:9 mostram mais mundo horizontalmente em vez de barras pretas: a câmera e os limites de fase precisam tratar isso (SYS-007).
- **Filtro de textura padrão:** *nearest* (provisório, pressupõe pixel art).
- **Barras do sistema:** política imersiva aplicada pelo preset de export (`screen/immersive_mode=true`). **Não existe opção/toggle de Tela cheia no jogo** e ela permanece desligada. O comportamento real (gestos que revelam barras temporariamente, recortes, retomada) **não foi validado em aparelho**.
- **Áreas seguras:** `scripts/ui/safe_area_margin.gd` converte `DisplayServer.get_display_safe_area()` para o espaço do viewport; controles essenciais devem ficar dentro dele.

## 3. Android (preset de export)

`export_presets.cfg` contém um preset **Android (debug/teste)**: APK, `arm64-v8a` apenas (provisório; alvo de referência é arm64), sem Gradle custom build, imersivo ligado, **sem keystore, senhas ou caminho de export** (a assinatura de debug vem das Editor Settings de cada máquina; a de release é do usuário). `package/unique_name` é o placeholder **`com.example.boltaventura`** — o package ID definitivo é decisão do usuário e precisa ser fixado antes de qualquer distribuição. `exclude_filter` mantém `tests/`, `docs/`, `.claude/` e `.github/` fora do pacote.

## 4. Física e camadas

- 60 ticks de física por segundo, `max_physics_steps_per_frame=8` (padrão do Godot, declarado em teste). Movimento e salto devem rodar em `_physics_process`; nada de gameplay depende da taxa de render.
- Camadas 2D: 1 `world`, 2 `player`, 3 `enemy`, 4 `hazard`, 5 `pickup`, 6 `interactable`. São contrato: não renumerar sem migrar as cenas.

## 5. Input Map

Fonte única dos nomes: `scripts/input/actions.gd` (`class_name Actions`). Teclado é auxiliar de desenvolvimento; touch é o caminho de produto.

| Ação | Teclado (dev) | Observação |
|---|---|---|
| `move_left` / `move_right` | A/← · D/→ | |
| `jump` | Espaço · W · ↑ | |
| `dash` | Shift · K | Dash é habilidade obrigatória aprovada |
| `attack` | J | Reservada (ataque básico aprovado); sem consumidor ainda |
| `interact` | E | Reservada |
| `pause` | Esc · P | |

Não há bindings de gamepad (não aprovados). `Actions.release_all_game_actions()` solta todas as ações e é chamado em troca de cena e perda de foco.

## 6. Estrutura e autoloads

```
project.godot  .godot-version  export_presets.cfg  icon.svg (placeholder)
scenes/boot/        cena de entrada (valida o contrato de input e abre o menu)
scenes/ui/          menus e HUD
scripts/core/       fluxo da aplicação (boot, SceneFlow)
scripts/input/      contrato de ações do Input Map
scripts/ui/         scripts de interface (menu, SafeAreaMargin)
tests/              runner headless + testes unitários (tests/unit/test_*.gd)
```

Diretórios para player, inimigos, mundos etc. serão criados **quando houver conteúdo real**, não antes. Nenhuma das 42 fases existe como cena.

**Autoload único:** `SceneFlow` (contrato Scene Flow → Loading): carregamento real em thread (`ResourceLoader.load_threaded_*`), sinais `transition_started/finished/failed`, bloqueio de transições simultâneas, soltura de ações ao trocar de cena. Sem espera artificial.

## 7. Verificação executada e limites

Comandos (a partir da raiz, Godot 4.7.2 headless, Linux x86_64):

```
godot --headless --path . --import
godot --headless --path . --script res://tests/test_runner.gd     # exit 0 = passou
godot --headless --path . --fixed-fps 60 --quit-after 300         # smoke da cena principal; conferir o log
```

O runner foi validado com falha proposital (exit code 1) antes de ser considerado confiável. Também falha se não descobrir testes ou não executar verificações, evitando CI verde com suíte vazia. **O que isto prova:** o projeto importa, os scripts compilam, as cenas instanciam, o Input Map e as configurações declaradas coincidem com a decisão, e o `SceneFlow` troca de cena. **O que isto não prova:** renderização, toque real, multitouch, barras do sistema, desempenho, memória, exportação ou instalação no Android.

Exportação Android: tentativa de `--export-debug` falha neste ambiente por ausência de Android SDK (`build-tools`/`apksigner`) e de export templates. Estado: **NÃO EXECUTADO/BLOQUEADO pelo ambiente**; nenhum APK existe.

## 8. Decisões pendentes do usuário

1. Package ID definitivo (hoje `com.example.boltaventura`).
2. Resolução-base e escala de pixel art (hoje 960×540, provisória).
3. Renderer final após medição em aparelho (hoje GL Compatibility, provisório).
4. Arquiteturas ABI além de `arm64-v8a`, se houver aparelhos 32-bit na meta.

## 9. Base de gameplay da Etapa 0 (adição a pedido do usuário — PROVISÓRIO)

A ordem de execução do usuário pediu, além da fundação, movimento, câmera, controles touch, HUD e um primeiro nível funcional. Isto **excede** o §5 do `ETAPA_0_CLAUDE_CHECKLIST.md` (que proíbe antecipar gameplay); o conflito é registrado no handoff. Seguiu-se a ordem do usuário; os itens abaixo estão como "Em andamento", não "Implementado".

| Peça | Arquivos | Notas |
|---|---|---|
| Buffer de ações | `scripts/input/action_buffer.gd` | Idade medida em **ticks de física** (tempo de jogo), não em relógio: um pico de quadros não expira um toque válido. Janela 0,12 s (provisória) |
| Touch | `scripts/input/touch_controls.gd`, `touch_button.gd` | Rastreio por dedo; ação solta só quando nenhum dedo a segura; deslize entre ←/→; soltura em pausa, perda de foco, ocultação, cancelamento |
| Entrada imediata | `scripts/core/scene_flow.gd` | `Input.use_accumulated_input = false`: com acúmulo, `Input.parse_input_event` só valia 1 quadro depois (latência extra no toque). Há teste de regressão |
| Jogador | `scripts/player/bolt_player.gd`, `bolt_tuning.gd`, `resources/player/bolt_tuning_provisional.tres`, `scenes/player/bolt.tscn` | Todos os números de `BoltTuning` são **provisórios**; visual = polígonos placeholder |
| Sandbox | `scenes/levels/sandbox/movement_sandbox.tscn`, `scripts/levels/movement_sandbox.gd`, `scenes/world/platform_block.tscn` | **Cenário de desenvolvimento, NÃO é fase da campanha** (sem ID W#-L#); serve para exercitar o movimento |
| HUD | `scripts/ui/hud.gd`, `scenes/ui/hud.tscn` | Botões touch, pausa, resultado, safe area. Layout provisório |

Armadilha encontrada: identificador de autoload usado diretamente em script compilado durante `load_threaded` causou erro de parse intermitente; scripts de UI resolvem `/root/SceneFlow` em tempo de execução (0/40 falhas de boot após a correção).

Evidência (Godot 4.7.2 headless, Linux): suíte `tests/test_runner.gd` = 41 testes, 167 verificações, 0 falhas; 5 mutações deliberadas foram detectadas pelos testes; laço de boot 20× sem erros; um bot com entrada sintética completa a sandbox sem quedas. **Não prova** sensação de controle, renderização, toque físico, barras do Android, FPS, memória ou exportação.
