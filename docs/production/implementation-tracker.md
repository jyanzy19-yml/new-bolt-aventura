# BOLT · AVENTURA — Rastreador de implementação

**Objetivo:** impedir que sistemas ou fases sejam declarados concluídos apenas por terem arquivos ou cenas criados.  
**Atualização:** em toda entrega substancial e mudança de gate.  
**Regra:** estado precisa refletir evidência no branch atual.

## 1. Vocabulário de status

| Status | Significado |
|---|---|
| Não iniciado | Nenhuma implementação executável identificada |
| Em andamento | Implementação parcial; critérios ainda não atendidos |
| Implementado | Funcionalidade existe no projeto, mas validação não está completa |
| Validado | Critérios aplicáveis passaram e evidências estão registradas |
| Bloqueado | Dependência real impede avanço; bloqueio e responsável registrados |
| Não aplicável | Justificativa documentada e aprovada |

Não usar percentuais subjetivos. Não inferir "validado" a partir de arquivos existentes ou de uma revisão documental.

## 2. Baseline inicial

Na inspeção documental de 2026-11-25, não havia project.godot, cenas .tscn ou código de gameplay BOLT. Portanto, os sistemas abaixo começam como **Não iniciado** até nova inspeção confirmar uma alteração. O baseline inicial era "Não iniciado" para todos os sistemas; a coluna Status é atualizada a partir de evidência (Etapa 0 em andamento, ver COLLABORATION_STATE.md).

## 3. Sistemas globais

| ID | Sistema / entrega | Status | Evidência / observação |
|---|---|---|---|
| SYS-001 | Projeto Godot e versão fixada | Implementado | `project.godot`, `.godot-version` = 4.7.2. Evidência L2: `--headless --import` sem erros; `tests/test_runner.gd` 0 falhas (Godot 4.7.2 headless, Linux). Não validado em editor gráfico nem Android. Ver [06-godot-project-foundation.md](../technical/06-godot-project-foundation.md) |
| SYS-002 | Configuração Android, paisagem e renderer | Implementado | Orientação 4 (sensor landscape), viewport 960×540 (provisório), GL Compatibility (provisório), preset Android com `screen/immersive_mode=true` (ADR-0003), sem segredos; verificado por `tests/unit/test_project_config.gd`. **Export Android NÃO executado** (sem SDK/templates); nenhum APK; nada validado em aparelho |
| SYS-003 | Arquitetura, cenas e recursos compartilhados | Em andamento | Existem: boot, menu, autoload `SceneFlow` (thread, `use_accumulated_input=false`), `Actions`, `SafeAreaMargin`, `BoltTuning` (Resource), `PlatformBlock`, HUD. Testado só em headless. Faltam inimigos, mundos, save, áudio e demais contratos |
| SYS-004 | Input abstrato e multitouch | Em andamento | `TouchControls`/`TouchButton` (por dedo, soltura só sem dedos, deslize entre direções, soltura em pausa/foco), `ActionBuffer` em ticks de física. 10+4 testes headless com eventos sintéticos. **Layout e tamanhos provisórios; NÃO testado em toque real/aparelho** |
| SYS-005 | BOLT: controller, estados e animação | Em andamento | `BoltPlayer` (GROUNDED/RISING/FALLING/DASHING) + placeholders. ~11 testes headless. Sem animação final, dano, wall slide/jump. Valores provisórios; não validado em aparelho |
| SYS-006 | Movimento, salto, All Jump e dash | Em andamento | Corrida, pulo variável, pulo duplo, coyote, buffer, dash aéreo único (`BoltTuning` provisório). Bot headless completa a sandbox. **Feel não avaliado por humano**; semântica de "All Jump" não confirmada em fonte aprovada — não canonizada |
| SYS-007 | Câmera e limites de fase | Em andamento | `Camera2D` com suavização, drag margins e limites definidos pela sandbox. Não avaliado visualmente/em aparelho |
| SYS-008 | Combate, dano e armas | Não iniciado | Sem implementação do jogo |
| SYS-009 | Habilidades e cooldowns | Não iniciado | Sem implementação do jogo |
| SYS-010 | IA e arquétipos de inimigos | Não iniciado | Sem implementação do jogo |
| SYS-011 | Chefes e arenas | Não iniciado | Sem implementação do jogo |
| SYS-012 | NPCs, interação, diálogo e flags | Não iniciado | Sem implementação do jogo |
| SYS-013 | Objetivos, colecionáveis e fragmentos | Não iniciado | Sem implementação do jogo |
| SYS-014 | Checkpoints, respawn e progressão | Não iniciado | Sem implementação do jogo |
| SYS-015 | Save/load, versão e recuperação | Não iniciado | Sem implementação do jogo |
| SYS-016 | Inventário, moedas, melhorias e skins | Não iniciado | Sem implementação do jogo |
| SYS-017 | Menus, HUD, pausa e configurações | Não iniciado | Sem implementação do jogo |
| SYS-018 | Cutscenes, legendas e replay/pulo | Não iniciado | Sem implementação do jogo |
| SYS-019 | Áudio, música, buses e opções | Não iniciado | Sem implementação do jogo |
| SYS-020 | Loading, transições e gestão de memória | Não iniciado | Sem implementação do jogo |
| SYS-021 | Pipeline de assets e proveniência | Não iniciado | Pipeline do jogo a estabelecer |
| SYS-022 | Testes automatizados e regressão | Não iniciado | Sem projeto executável |
| SYS-023 | Exportação, instalação e QA Android | Não iniciado | Sem APK/build verificada |
| SYS-024 | Créditos, encerramento e release candidate | Não iniciado | Sem campanha implementada |

## 4. Rastreador das 42 fases

A matriz define a estrutura planejada: seis fases por mundo; fases 1–5 de progressão/exploração e fase 6 como conclusão local com guardião/fragmento. Os nomes de fases são IDs provisórios, não títulos narrativos finais.

| ID | Mundo | Função planejada | Status inicial | Evidência |
|---|---|---|---|---|
| W1-L1 | Cybercore | Entrada e exploração | Não iniciado | Sem cena |
| W1-L2 | Cybercore | Progressão | Não iniciado | Sem cena |
| W1-L3 | Cybercore | Progressão | Não iniciado | Sem cena |
| W1-L4 | Cybercore | Combinação de mecânicas | Não iniciado | Sem cena |
| W1-L5 | Cybercore | Domínio e preparação | Não iniciado | Sem cena |
| W1-L6 | Cybercore | Guardião Tecnológico / Origem | Não iniciado | Sem cena |
| W2-L1 | Egito Antigo Futurista | Entrada e exploração | Não iniciado | Sem cena |
| W2-L2 | Egito Antigo Futurista | Progressão | Não iniciado | Sem cena |
| W2-L3 | Egito Antigo Futurista | Progressão | Não iniciado | Sem cena |
| W2-L4 | Egito Antigo Futurista | Combinação de mecânicas | Não iniciado | Sem cena |
| W2-L5 | Egito Antigo Futurista | Domínio e preparação | Não iniciado | Sem cena |
| W2-L6 | Egito Antigo Futurista | Guardião Ancestral das Pirâmides / Memória | Não iniciado | Sem cena |
| W3-L1 | Speakeasy Aesthetic | Entrada e exploração | Não iniciado | Sem cena |
| W3-L2 | Speakeasy Aesthetic | Progressão | Não iniciado | Sem cena |
| W3-L3 | Speakeasy Aesthetic | Progressão | Não iniciado | Sem cena |
| W3-L4 | Speakeasy Aesthetic | Combinação de mecânicas | Não iniciado | Sem cena |
| W3-L5 | Speakeasy Aesthetic | Domínio e preparação | Não iniciado | Sem cena |
| W3-L6 | Speakeasy Aesthetic | Mestre das Sombras / Verdade | Não iniciado | Sem cena |
| W4-L1 | Dark Fantasy | Entrada e exploração | Não iniciado | Sem cena |
| W4-L2 | Dark Fantasy | Progressão | Não iniciado | Sem cena |
| W4-L3 | Dark Fantasy | Progressão | Não iniciado | Sem cena |
| W4-L4 | Dark Fantasy | Combinação de mecânicas | Não iniciado | Sem cena |
| W4-L5 | Dark Fantasy | Domínio e preparação | Não iniciado | Sem cena |
| W4-L6 | Dark Fantasy | Rei Esquecido / Sombra | Não iniciado | Sem cena |
| W5-L1 | Pôr do Sol em Cidade Medieval | Entrada e exploração | Não iniciado | Sem cena |
| W5-L2 | Pôr do Sol em Cidade Medieval | Progressão | Não iniciado | Sem cena |
| W5-L3 | Pôr do Sol em Cidade Medieval | Progressão | Não iniciado | Sem cena |
| W5-L4 | Pôr do Sol em Cidade Medieval | Combinação de mecânicas | Não iniciado | Sem cena |
| W5-L5 | Pôr do Sol em Cidade Medieval | Domínio e preparação | Não iniciado | Sem cena |
| W5-L6 | Pôr do Sol em Cidade Medieval | Guardião da Coroa / Luz | Não iniciado | Sem cena |
| W6-L1 | Vaporwave / Las Vegas | Entrada e exploração | Não iniciado | Sem cena |
| W6-L2 | Vaporwave / Las Vegas | Progressão | Não iniciado | Sem cena |
| W6-L3 | Vaporwave / Las Vegas | Progressão | Não iniciado | Sem cena |
| W6-L4 | Vaporwave / Las Vegas | Combinação de mecânicas | Não iniciado | Sem cena |
| W6-L5 | Vaporwave / Las Vegas | Domínio e preparação | Não iniciado | Sem cena |
| W6-L6 | Vaporwave / Las Vegas | Ilusionista Supremo / Ilusão | Não iniciado | Sem cena |
| W7-L1 | Natal / Nova York Futurista | Entrada e exploração | Não iniciado | Sem cena |
| W7-L2 | Natal / Nova York Futurista | Progressão | Não iniciado | Sem cena |
| W7-L3 | Natal / Nova York Futurista | Progressão | Não iniciado | Sem cena |
| W7-L4 | Natal / Nova York Futurista | Combinação de mecânicas | Não iniciado | Sem cena |
| W7-L5 | Natal / Nova York Futurista | Domínio e preparação | Não iniciado | Sem cena |
| W7-L6 | Natal / Nova York Futurista | Guardião do Inverno / Equilíbrio | Não iniciado | Sem cena |

## 5. Definition of Done por fase

Uma fase só muda para **Implementado** quando cena, layout jogável, objetivo, rota principal, inimigos/perigos, checkpoints/recompensas previstos, transições e integração de progressão existirem.

Só muda para **Validado** quando inicia e termina corretamente; não possui softlock na rota principal; checkpoint/respawn e save/load preservam estado; encontros e chefe (quando aplicável) são vencíveis e legíveis; controles touch funcionam; performance foi medida conforme o gate e o aparelho disponível; testes e bugs restantes estão registrados.

## 6. Como atualizar

- Alterar status somente com evidência do branch/commit atual.
- Em "Evidência", incluir caminho de cena/script/dados, teste e commit ou referência do relatório.
- Não marcar fase como implementada apenas porque existe uma cena vazia.
- Não usar "80%" ou "quase pronta"; registrar critérios que faltam.
- Se um mundo ou sistema for dividido em subtarefas, criar IDs filhos sem apagar o ID pai.
- Sincronizar este arquivo com stage-status.md, CONTINUITY.md e QA.
