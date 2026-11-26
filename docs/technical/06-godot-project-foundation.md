# Fundação do projeto Godot — estado real (Etapa 0)

**Escopo:** descreve o projeto Godot que **existe** no repositório. Complementa os princípios de [00-architecture-principles.md](00-architecture-principles.md) e os contratos de [05-system-contracts.md](05-system-contracts.md). Tudo marcado como **provisório** é decisão técnica reversível, não canon, e precisa de medição em aparelho Android antes de ser congelada.

## 1. Versão, renderer e ambiente

| Item | Valor | Evidência / status |
|---|---|---|
| Godot | **4.7.2 estável** (`4.7.2.stable.official.ed1daf0bf`) | `.godot-version`; `--headless --version` executado no ambiente de desenvolvimento |
| Renderer | **GL Compatibility** (desktop e mobile) | Decisão técnica provisória. Justificativa: jogo 2D, menor sobrecarga e maior compatibilidade em GPUs Android modestas (Mali-G57 do Helio G99). **Não medido em aparelho.** Reavaliar Mobile/Vulkan só com medição (ADR futura) |
| Linguagem | GDScript tipado | ADR-0002 |
| Export templates | O ambiente local de desenvolvimento pode não ter templates instalados; o workflow Android CI baixa os templates compatíveis com Godot 4.7.2 | Exportação Android debug **executada em CI** (ver §7); exportação local/editor gráfico não comprovada |

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
| `attack` | J | Consumida pelo `BoltCombat` para Pistola Crono básica; valores provisórios |
| `interact` | E | Reservada |
| `pause` | Esc · P | |

Não há bindings de gamepad (não aprovados). `Actions.release_all_game_actions()` solta todas as ações e é chamado em troca de cena e perda de foco.

## 6. Estrutura e autoloads

```
project.godot / .godot-version / export_presets.cfg / icon.svg (placeholder)
scenes/
  boot/       entrada do app
  ui/         menu, HUD e loading overlay
  campaign/   W1-L1 e W1-L2 (blockouts)
  tutorial/   tutorial guiado
  player/     BOLT
  combat/     projétil, pickup e alvo de treino
  enemies/    inimigo-base Cybercore
  levels/     sandbox, checkpoint e campo energético
  world/      plataforma sólida, móvel e unidirecional
scripts/
  core/ campaign/ combat/ enemies/ input/ levels/ player/ tutorial/ ui/ world/
resources/player/  BoltTuning provisório
tests/              runner headless + testes unitários
docs/               design, technical, production, QA e ADRs
```

A árvore atual contém 19 cenas e 30 scripts de runtime. W1-L1 e W1-L2 existem em blockout/protótipo; as outras 40 fases planejadas ainda não existem como cenas. A sandbox continua fora da campanha.

**Autoloads atuais:** `SceneFlow`, `SaveSystem`, `CampaignProgress` e `LoadingOverlay` (cena CanvasLayer). `SceneFlow` faz carregamento threaded (`ResourceLoader.load_threaded_*`), emite `transition_started/finished/failed`, bloqueia transições concorrentes e limpa ações; `LoadingOverlay` apresenta estado/progresso real; `SaveSystem` e `CampaignProgress` mantêm persistência e progressão separadas.

## 7. Verificação executada e limites

Comandos (a partir da raiz, Godot 4.7.2 headless, Linux x86_64):

```
godot --headless --path . --import
godot --headless --path . --script res://tests/test_runner.gd     # exit 0 = passou
godot --headless --path . --fixed-fps 60 --quit-after 300         # smoke da cena principal; conferir o log
```

O runner foi validado com falha proposital (exit code 1) e falha se não descobrir testes ou não executar verificações. **Evidência atual pós-merge PR #47:** Godot 4.7.2; 88 testes/553 verificações/0 falhas; teste de compilação de scripts (53 verificações) e carregamento/instanciação de cenas (39 verificações). Android Debug Export CI SUCCESS; APK 28.461.057 bytes, assinatura v2/v3 válida, SHA-256 `c3ca03958eecf120f1a9f5f1e4fae3851fb7560bca303c8eb5a930f987b58123`; artifact `bolt-aventura-android-debug-2636226c4027625649e66c51ff64d7e2e56168a6`. **O que isto prova:** import/parse headless, testes, carregamento/instanciação de cenas e exportação debug no runner CI. **O que isto não prova:** renderização visual em aparelho, toque físico, barras/safe area, desempenho, memória, lifecycle Android ou instalação/uso no dispositivo.

## 8. Decisões pendentes do usuário

1. Package ID definitivo (hoje `com.example.boltaventura`).
2. Resolução-base e escala de pixel art (hoje 960×540, provisória).
3. Renderer final após medição em aparelho (hoje GL Compatibility, provisório).
4. Arquiteturas ABI além de `arm64-v8a`, se houver aparelhos 32-bit na meta.

## 9. Base de gameplay atual — evolução desde a Etapa 0

A tabela descreve componentes existentes, não a conclusão da vertical slice. Os parâmetros de movimento/combate permanecem provisórios; W1-L1/W1-L2 continuam blockouts e a sandbox não é fase de campanha.

| Sistema | Arquivos / cenas | Estado real |
|---|---|---|
| Input / buffer | Actions, ActionBuffer, TouchControls, TouchButton | Ações lógicas, multitouch, cancelamento, limpeza em pause/foco/transição; toque físico ainda não validado |
| Player / movimento | BoltPlayer, BoltTuning, bolt.tscn | Corrida, salto, pulo duplo provisório, coyote, buffer e Dash; valores provisórios, visual placeholder |
| Combate | BoltHealth, BoltCombat, ChronoProjectile, BoltTrainingTarget | Pistola Crono básica, vida/dano, alvo de treino; arsenal e balanceamento incompletos |
| Campanha | cybercore_w1_l1.tscn, cybercore_w1_l2.tscn, CampaignProgress | W1-L1/W1-L2 em blockout; checkpoints e progressão persistente; não são fases finais |
| Obstáculos | PlatformBlock, MovingPlatform, OneWayPlatform, TimedEnergyGate, BoltCheckpoint, pickups | Componentes reutilizáveis e testes; integração/posicionamento segue design da fase |
| Persistência | SaveSystem, CampaignProgress | JSON versionado v1, backup/recuperação e progressão; QA Android lifecycle pendente |
| UI / loading | Menu, HUD, LoadingOverlay, SafeAreaMargin | Nova Jornada/Continuar, pausa, resultado, loading e safe area; UX final e teste em aparelho pendentes |
| Sandbox | movement_sandbox.tscn | Ambiente de desenvolvimento, fora da campanha |

O projeto tem quatro autoloads: SceneFlow, SaveSystem, CampaignProgress e LoadingOverlay. O Input Map attack é consumido por BoltCombat; interact permanece reservado. Não há bindings de gamepad aprovados. O inventário de comandos do protótipo HTML legado (Blast, Voar e seleção de armas) está em reconciliação no GAP-021 e não deve ser presumido como removido ou reintroduzido.

Evidência atual: PR #47 pós-merge, Godot 4.7.2, 88 testes/553 verificações/0 falhas; Android debug export CI SUCCESS. Isso não prova sensação de controle, renderização, toque físico, barras do Android, FPS, memória, instalação ou lifecycle em aparelho.
