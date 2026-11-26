# Handoff — Etapa 0 (Claude Code → ChatGPT)

## Identificação

- **Etapa concluída:** 0 — fundação Godot + base de movimento/touch/HUD/sandbox (ver "Conflito de escopo").
- **Responsável:** Claude Code. **Próxima etapa / responsável:** 1 — ChatGPT.
- **Repositório / branch:** jyanzy19-yml/new-bolt-aventura, `main`.
- **Commit-base:** `16d42de2f2b5b3a52411f7d13db6d37b3a38b9d3`.
- **Commits de entrega:** `7057532` (fundação) + `c32a99d` (gameplay-base, testes e documentação).
- **PR #1:** não tocada, não mesclada (divergente).
- **Estado:** HANDOFF_READY (não significa slice, APK ou campanha prontos).

## Conflito de escopo (decisão a confirmar)

`ETAPA_0_CLAUDE_CHECKLIST.md` §5 proíbe antecipar gameplay; a ordem de execução do usuário pediu explicitamente personagem, movimento, câmera, touch, HUD e primeiro nível funcional. Segui a ordem do usuário e rebaixei o status: SYS-004/005/006/007 = **Em andamento (provisório)**. A sandbox é cenário de desenvolvimento, **não** fase da campanha. ChatGPT: aceite ou reverta explicitamente.

## Implementado (headless apenas)

Projeto Godot 4.7.2 (`.godot-version`), `project.godot` (paisagem, 960×540 provisório, GL Compatibility provisório, física 60 Hz, camadas, Input Map), `export_presets.cfg` (imersivo conforme ADR-0003, sem segredos, package ID placeholder), boot + menu + `SceneFlow` (threaded), `SafeAreaMargin`, `TouchControls`/`TouchButton` (multitouch por dedo), `ActionBuffer` (ticks de física), `BoltPlayer` + `BoltTuning` (corrida, pulo variável, pulo duplo, coyote, buffer, dash), câmera, `PlatformBlock`, sandbox de movimento, HUD (touch, pausa, resultado), suíte de testes headless.

## Não implementado

Animação final, assets, áudio, combate/dano/inimigos, wall slide/jump, save, qualquer fase W#-L#, export Android/APK, CI Godot validado no GitHub (apenas local).

## Propostas provisórias (não canonizadas)

Todos os valores de `BoltTuning`; janelas de buffer/coyote; layout dos botões touch; geometria da sandbox; regra "pulo ignorado durante o dash"; "All Jump" interpretado como pulo duplo (**sem fonte aprovada confirmada**).

## Validação

| Verificação | Comando | Ambiente | Resultado |
|---|---|---|---|
| Import | `godot --headless --path . --import` | Godot 4.7.2 Linux | sem erros |
| Testes | `godot --headless --path . --script res://tests/test_runner.gd` | idem | 41 testes, 167 verificações, 0 falhas (exit 0) |
| Mutação | 5 alterações deliberadas no código | idem | todas detectadas; arquivos restaurados |
| Boot | `--fixed-fps 60 --quit-after 300` ×20 | idem | 0/20 com erro |
| Playthrough | bot com entrada sintética | idem | completa a sandbox, 0 quedas |
| Editor gráfico / renderização | — | — | **NÃO EXECUTADO** |
| Toque físico / Android / barras | — | — | **NÃO EXECUTADO** (sem aparelho) |
| Export APK | `--export-debug` | — | **BLOQUEADO** (sem SDK/templates) |
| FPS / memória | — | — | **NÃO EXECUTADO** |

**Nível máximo: L2 (headless).**

## Bugs/riscos

- Sensação de controle nunca avaliada por humano; tuning pode estar ruim.
- Toque real, multitouch físico e imersivo do Android não verificados.
- O erro intermitente de parse de autoload em carga em thread foi mitigado (resolução por `/root/SceneFlow`); evitar referenciar autoloads por identificador em scripts de cena carregados em thread.
- Bot só prova transponibilidade, não qualidade do percurso.

## Decisões pendentes do usuário

Package ID; resolução-base; renderer final; ABIs; semântica canônica de "All Jump"; se a antecipação de gameplay da Etapa 0 é aceita.

## Próxima ação concreta (Etapa 1, ChatGPT)

1. Inspecionar o HEAD e rodar import + suíte (critério: exit 0, 41 testes).
2. Auditar este handoff e o conflito de escopo.
3. Escolher a próxima unidade do roadmap (ex.: validação em aparelho do toque/imersivo se o usuário tiver aparelho; ou primeiro inimigo/combate conforme docs aprovados). Não canonizar os valores provisórios.

## Declaração

- [x] Nenhum teste declarado sem execução real.
- [x] Commit `c32a99d` enviado a `origin/main` (push confirmado).
