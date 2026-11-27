# W1-L4 Núcleo de Distribuição — especificação técnica, integração e relatório de PR

**Classificação:** BLOCKOUT PROVISÓRIO. Branch `feat/w1-l4-distribution-core` (base `main` `ceb6091`). **Não integrada; sem merge.**
Design/proposta: `docs/game-design/proposals/PROPOSTA-W1-L4-nucleo-de-distribuicao.md`.

## 1. Arquitetura (ownership)
| Responsabilidade | Arquivo | Natureza |
|---|---|---|
| Regras do puzzle (pura, sem nós/tempo) | `scripts/levels/energy_sequence.gd` (`EnergySequence`, RefCounted) | determinístico, testável isoladamente |
| Interruptor reutilizável | `scripts/levels/energy_relay.gd` + `scenes/levels/energy_relay.tscn` | StaticBody2D camada 4 com contrato de alvo `apply_damage` |
| Conduíte | `scripts/levels/energy_conduit.gd` | Line2D, apagado/aceso (forma + cor) |
| Barreira de saída | `scripts/levels/distribution_gate.gd` + `scenes/levels/distribution_gate.tscn` | StaticBody2D camada 1; abre uma vez (terminal) |
| Controlador do puzzle | `scripts/levels/distribution_puzzle.gd` (`DistributionPuzzle`) | liga relés → sequência → conduítes/barreira; sinais `progress_changed`, `sequence_failed`, `solved` |
| Mural de pistas | `scripts/levels/energy_clue_mural.gd` | desenha a ordem a partir dos glifos reais dos relés |
| Gatilho de beat narrativo | `scripts/levels/narrative_beat_trigger.gd` | one-shot; só emite o ID |
| Controlador de fase | `scripts/campaign/cybercore_w1_l4.gd` | camera, HUD, checkpoints, kill zone, objetivo, persistência (contratos existentes) |
| Cena | `scenes/campaign/cybercore_w1_l4.tscn` | blockout com `PlatformBlock`/`OneWayPlatform` existentes |

Dependência de direção: fase → puzzle → (relé, conduíte, barreira) → `EnergySequence`. A lógica pura não conhece nós. Nenhum sistema central foi modificado.

## 2. Especificação formal do puzzle
**Ordem exigida:** `relay_a (◇) → relay_b (○) → relay_c (△)` = ordem de `relay_paths` do `DistributionPuzzle`.

**Estados do puzzle:** `EM ANDAMENTO` (progress 0..2) e `RESOLVIDO` (3/3, terminal). Falha não é um estado: é uma transição para progress 0.
**Estados do relé (visual):** `OFF` · `ENERGIZED` (halo) · `REJECTED` (X, transitório 0,6 s e volta ao estado de repouso). O estado lógico é derivado de `EnergySequence`.
**Ativação:** um golpe de TIRO (`apply_damage`) no relé emite `struck(relay_id)`. Andar/encostar **não** ativa.

| Evento (relé tocado) | Condição | Resultado |
|---|---|---|
| Próximo esperado | `id == ordem[progress]` | `ACCEPTED`: energiza, acende o próximo conduíte, `progress_changed`; no 3/3: abre a barreira + `solved` |
| Fora de ordem | `id != ordem[progress]`, ainda não energizado | `REJECTED`: progress=0, relés piscam X, `sequence_failed` (**sem dano**) |
| Já energizado | `id` em energizados | `IGNORED_DUPLICATE`: nada (callback duplicado não é falha) |
| Após resolvido | qualquer | `IGNORED_SOLVED`: nada (terminal) |
| ID desconhecido | fora da ordem | `UNKNOWN_RELAY`: nada |

**Sucesso:** 3/3 na ordem → barreira abre (colisão desativada de forma deferida) → objetivo conclui a fase.
**Falha:** ordem errada (recuperável indefinidamente). **Reinicialização:** falha reinicia a sequência; recarregar a fase (derrota/restart) reinicia tudo.
**Persistência:** o estado do puzzle **não é persistido** (schema v1 intacto). Respawn por queda mantém o progresso (mesma instância); retomar de checkpoint em nova instância reinicia o puzzle.
**Conclusão:** `mark_level_completed("W1-L4")` sem destino seguinte; exige `puzzle.is_solved()` (defesa em profundidade além da barreira física); se BOLT já estiver na área quando resolver, a conclusão é reavaliada.
**Anti-bypass:** barreira de 560 px; teste de invariante garante que nenhuma plataforma próxima permita alcançar o topo (salto + pulo aéreo de `BoltTuning`).

## 3. Contratos preservados
Dash, física, InputMap, multitouch, schema de save v1, IDs existentes, `main_menu.gd`, `CampaignProgress`/`SaveSystem`, W1-L1/L2/L3: **não alterados** (diff limitado a arquivos novos + docs). IDs novos: nível `W1-L4`; checkpoints `cybercore_w1_l4_checkpoint_a/b`; beat `w1_l4_nexo_ancient_signal`; relés `relay_a/b/c`.

## 4. Dependências e integração (unidade SEPARADA, não feita aqui)
- **W1-L3 (PR #84) não está na `main`;** W1-L4 não depende dela e não a referencia.
- Para integrar após L3: (a) `cybercore_w1_l3.gd` passar `"W1-L4"`/caminho em `mark_level_completed`/`show_result`; (b) `main_menu.gd` mapear `W1-L4` em `LEVEL_PATHS`/`LEVEL_LABELS`; (c) ajustar testes de entrada/threaded loading/câmera. Esses arquivos pertencem a outros workstreams e foram deixados intactos.
- **Aviso de desenvolvimento:** abrir W1-L4 diretamente grava `current_level_id="W1-L4"`; até o menu mapear esse ID, "Continuar" ficará indisponível para esse save (comportamento existente para IDs desconhecidos). A fase não é alcançável a partir do menu/campanha nesta PR.
- O gatilho de beat narrativo não tem consumidor ainda (sem sistema de cutscene/diálogo).

## 5. Validação executada (Godot 4.7.2, headless)
- Suíte completa: **141 testes / 2.283 verificações / 0 falhas** (exit 0), com 15 testes novos (`test_energy_sequence.gd` ×5, `test_w1_l4.gd` ×10).
- Cobertura: carregamento e composição; estados iniciais; ordem certa (com **projéteis Crono reais**); ordem errada, sem dano, recuperação; duplicados e pós-resolução; barreira bloqueia/permite fisicamente; objetivo exige puzzle e não duplica progressão; checkpoints/retomada/respawn; alcançabilidade da rota obrigatória (vãos ≤ 140, degraus ≤ 96 px) e viabilidade da rota opcional; linha de tiro livre; anti-bypass; beat one-shot; triangulação de todos os `Polygon2D`.
- **Mutation testing:** 8/8 mutantes eliminados (sem reinício na falha; barreira nunca abre; objetivo ignora puzzle; duplicado vira falha; resolvido não terminal; barreira curta; piso superior inalcançável; sem feedback de rejeição).
- **Evidência visual** (Xvfb + Mesa llvmpipe, GL Compatibility; só composição): `docs/production/evidence/cybercore-w1-l4/` (5 capturas).

## 6. Não executado / limitações
- **Nada validado em aparelho Android** (touch real, FPS, memória, safe areas, latência de TIRO): não executado, sem dispositivo.
- Sem medição de desempenho; renderização em GL por software não representa Helio G99.
- Sem playtest humano: dificuldade, distâncias e legibilidade das pistas não avaliadas. Tempos/valores são provisórios.
- Relé B/C podem ficar sob os botões touch dependendo da câmera (captura 01); a posição de HUD não foi alterada.
- Sem áudio; sem arte final (aprovação visual pendente — `ASSET_PIPELINE.md`).
- **CI remoto (workflows) não executado por mim nesta sessão;** registrar resultado quando a PR rodar.
- Persistência do estado do puzzle requer ADR e extensão de schema — fora de escopo.

## 7. Critérios de aceite
- [x] Cena executável (`cybercore_w1_l4.tscn`) carrega e roda em teste headless.
- [x] Puzzle de ponta a ponta com projéteis reais; solução dedutível por conduítes + mural.
- [x] Falha recuperável, sem dano; duplicados inertes; sem bypass conhecido.
- [x] Testes relevantes passam; mutantes eliminados.
- [x] Diff limitado a arquivos novos e docs; sem tocar L3/menu/save/Dash/física.
- [ ] Revisão humana, CI remoto, playtest e validação Android (pendentes).


## Addendum de integração na main — 27/11/2026

Esta branch reaplica a implementação W1-L4 sobre o HEAD atual após as integrações #107 (seleção de campanha) e #105 (W1-L3). A PR #106 original ficou divergente por alterações concorrentes no tracker/continuidade; seu conteúdo funcional e testes foram reaplicados sem copiar os snapshots antigos desses documentos.

- W1-L3 está integrada em `main` como BLOCKOUT PROVISÓRIO (PR #105).
- `CampaignCatalog` e as telas de seleção de mundo/fase estão integradas (PR #107); o catálogo já contém o caminho W1-L4, mas a disponibilidade depende da PackedScene real.
- W1-L4 é adicionada como BLOCKOUT PROVISÓRIO; não é fase final, não introduz canon novo e não contém encontro de guardião.
- `scripts/ui/main_menu.gd` agora resolve W1-L4 em `LEVEL_PATHS` e `LEVEL_LABELS`, evitando que o botão Continuar fique indisponível após salvar dentro da fase.
- `test_w1_l4.gd` inclui regressão de retomada pelo menu.
- As cinco capturas Xvfb de composição foram preservadas em `docs/production/evidence/cybercore-w1-l4/`; são evidência de composição, não de gameplay Android.
- CI da branch atual aguarda Godot Validation, Documentation Validation e Android Debug Export. Os resultados de CI do head antigo da PR #106 não são transferidos automaticamente para esta branch.
- Nenhum playtest humano ou teste em Android físico foi realizado. Posição dos relés em relação aos controles touch, legibilidade, dificuldade e performance permanecem pendentes.
