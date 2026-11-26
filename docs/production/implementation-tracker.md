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

Este parágrafo registra somente o baseline histórico de pré-produção de 2026-11-25. Ele não descreve o estado atual: a fundação Godot e parte dos sistemas SYS-001 a SYS-007 e SYS-017/SYS-020/SYS-022 foram implementados parcialmente e estão descritos nas linhas atuais da tabela. A coluna Status deve sempre refletir evidência do branch atual, nunca o baseline histórico.

## 3. Sistemas globais

| ID | Sistema / entrega | Status | Evidência / observação |
|---|---|---|---|
| SYS-001 | Projeto Godot e versão fixada | Implementado | `project.godot`, `.godot-version` = 4.7.2. Evidência L2: `--headless --import` sem erros; `tests/test_runner.gd` 0 falhas (Godot 4.7.2 headless, Linux). Não validado em editor gráfico nem Android. Ver [06-godot-project-foundation.md](../technical/06-godot-project-foundation.md) |
| SYS-002 | Configuração Android, paisagem e renderer | Implementado | Orientação 4 (sensor landscape), viewport 960×540 (provisório), GL Compatibility (provisório), preset Android com `screen/immersive_mode=true` (ADR-0003); PR #38 integrou export Android debug em CI. PR #39 repetiu export no commit `0e94f7e4` (run `45881252046`); package ID placeholder, instalação e validação física pendentes |
| SYS-003 | Arquitetura, cenas e recursos compartilhados | Em andamento | Boot, menu, `SceneFlow`, `SaveSystem`, `CampaignProgress`, `Actions`, `SafeAreaMargin`, `BoltTuning`, `PlatformBlock` e HUD. Menu/retomada reconhece W1-L1 e W1-L2 na main após PR #34; demais contratos pendentes |
| SYS-004 | Input abstrato e multitouch | Em andamento | `TouchControls`/`TouchButton` rastreiam ponteiros independentes; `ActionBuffer` limpa edges em pausa/suspensão/perda de foco. PR #39 e PR #42 integradas; branch `test/scene-flow-failure-pause-restoration` acrescenta regressão de restauração de pause state após falha. Teste físico pendente |
| SYS-005 | BOLT: controller, estados e animação | Em andamento | `BoltPlayer` (GROUNDED/RISING/FALLING/DASHING), vida/dano, knockback, invulnerabilidade e API de cura. Dash preservado. Placeholders e valores provisórios; sem validação física Android |
| SYS-006 | Movimento, salto, All Jump e dash | Em andamento | Corrida, pulo variável, pulo duplo, coyote, buffer, dash aéreo único (`BoltTuning` provisório). Bot headless completa a sandbox. **Feel não avaliado por humano**; semântica de "All Jump" não confirmada em fonte aprovada — não canonizada |
| SYS-007 | Câmera e limites de fase | Em andamento | `Camera2D` nativa com suavização, drag margins, callback físico e limites definidos em W1-L1/W1-L2. Branch `test/camera-contracts` extrai `configure_camera()` e adiciona regressões de rig/limites; CI pendente. Enquadramento, bordas e feel não avaliados visualmente/em aparelho |
| SYS-008 | Combate, dano e armas | Em andamento | `BoltHealth`, `BoltCombat`, `ChronoProjectile`, `BoltHealthPickup` e `CybercorePatrolEnemy`: Pistola Crono, dano/vida do jogador, invulnerabilidade, knockback, cura limitada, coletável de recuperação e flash de impacto. Tríplice Prisma, Laser Nexo, chefes e balanceamento final pendentes. PR #21: 53 testes, 276 verificações, 0 falhas em Godot 4.7.2 |
| SYS-009 | Habilidades e cooldowns | Não iniciado | Sem implementação do jogo |
| SYS-010 | IA e arquétipos de inimigos | Em andamento | `CybercorePatrolEnemy` é um inimigo-base provisório de patrulha e contato em W1-L1. Ainda não é arquétipo canônico; IA avançada, variedade e tuning final pendentes |
| SYS-011 | Chefes e arenas | Não iniciado | Sem implementação do jogo |
| SYS-012 | NPCs, interação, diálogo e flags | Não iniciado | Sem implementação do jogo |
| SYS-013 | Objetivos, colecionáveis e fragmentos | Não iniciado | Sem implementação do jogo |
| SYS-014 | Checkpoints, respawn e progressão | Em andamento | `CampaignProgress` persiste entrada/checkpoint/conclusão; W1-L1 avança o destino salvo para W1-L2; W1-L2 possui checkpoint próprio e blockout integrado pela PR #34; Godot CI pré/pós-merge passou; sandbox permanece ambiente de desenvolvimento |
| SYS-015 | Save/load, versão e recuperação | Em andamento | `SaveSystem` JSON v1 + `CampaignProgress` v1; reset seletivo, retomada W1-L1/W1-L2, backup/corrupção/schema cobertos. PR #31 CI pós-merge: 66 testes/404 verificações. Encerramento forçado e QA Android pendentes |
| SYS-016 | Inventário, moedas, melhorias e skins | Não iniciado | Sem implementação do jogo |
| SYS-017 | Menus, HUD, pausa e configurações | Em andamento | Nova Jornada/Continuar; retomada mapeia W1-L1 e W1-L2; HUD de resultado oferece PRÓXIMA FASE; overlay de carregamento persistente básico adicionado em branch. Configurações completas e validação visual/Android ausentes |
| SYS-018 | Cutscenes, legendas e replay/pulo | Em andamento | Nova Jornada segue abertura/tutorial; Continuar retoma W1-L1 ou W1-L2 conforme o progresso persistido. PR #34 integrada; storyboard/tutorial provisórios, animação final, áudio e replay persistente pendentes |
| SYS-019 | Áudio, música, buses e opções | Não iniciado | Sem implementação do jogo |
| SYS-020 | Loading, transições e gestão de memória | Em andamento | PR #41 integrou `LoadingOverlay` com progresso real, sucesso/falha; 75 testes/470 verificações/0 falhas e export Android SUCCESS. Branch `fix/scene-flow-input-lock` adiciona pausa real da SceneTree, ocultação touch e restauração em falha; CI pendente. Cancelamento, preload e gestão de memória pendentes |
| SYS-021 | Pipeline de assets e proveniência | Não iniciado | Pipeline do jogo a estabelecer |
| SYS-022 | Testes automatizados e regressão | Em andamento | Workflow Godot 4.7.2 executa import + `tests/test_runner.gd`; PRs #34/#35: 69 testes, 439 verificações, 0 falhas em Godot CI pré/pós-merge; PR #35 valida contato físico real da `Area2D`; Docs CI SUCCESS. Headless não equivale a QA visual ou Android físico |
| SYS-023 | Exportação, instalação e QA Android | Em andamento | PR #38 integrou pipeline Godot 4.7.2. PR #39 repetiu export com artifact `bolt-aventura-android-debug-7415dfb988faf2dd63f9ff289106e7f7205dcdd1`, assinatura v2/v3 e SHA-256 `db03a42b909781a1f5e7c94d025615e1aa5f397c8ebd306ba30cddf84eca14b0`. Package ID provisório; instalação, inicialização, touch, safe area e QA físico ainda não executados |
| SYS-024 | Créditos, encerramento e release candidate | Não iniciado | Sem campanha implementada |

## 4. Rastreador das 42 fases

A matriz define a estrutura planejada: seis fases por mundo; fases 1–5 de progressão/exploração e fase 6 como conclusão local com guardião/fragmento. Os nomes de fases são IDs provisórios, não títulos narrativos finais.

| ID | Mundo | Função planejada | Status inicial | Evidência |
|---|---|---|---|---|
| W1-L1 | Cybercore | Entrada e exploração | Em andamento | Blockout com BOLT, HUD/touch, combate, coletável, checkpoint persistente e objetivo; conclusão direciona W1-L2 após integração da PR #34. Placeholders, arte/áudio finais, playtest humano e QA Android pendentes |
| W1-L2 | Cybercore | Progressão | Em andamento | Blockout integrado pela PR #34 em `cybercore_w1_l2.tscn`, com campo energético cíclico, plataformas, checkpoint e objetivo; CI pré-merge passou, playtest humano/Android pendentes |
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


## 5. Nota de reconciliação de escopo — auditoria 2026-11-26

A auditoria estática da main confirmou que o código atual e os registros SYS-005/SYS-006 incluem Dash. A PR #1, ainda aberta e não integrada, contém uma diretiva que exclui Dash; o `MASTER_DIRECTIVE.md` da main ainda usa linguagem condicional sobre dash. Até a revisão/reconciliação da PR #1 e confirmação da fonte canônica, não ampliar nem remover essa mecânica silenciosamente. Estado e evidências completas: [auditoria de polimento](repository-polish-audit-2026-11-26.md).


## Entrada da campanha — branch `feat/campaign-opening-tutorial`

- Menu principal → storyboard funcional de abertura → tutorial guiado por robô mensageiro provisório → blockout W1-L1 Cybercore.
- A abertura usa fatos do canon aprovado, mas ainda não é cinemática final animada.
- Tutorial introduz movimento, salto e Dash com o player/HUD/touch existentes. Textos instrucionais são provisórios e não definem a personalidade do mensageiro.
- W1-L1 permanece Em andamento; inimigos, combate, assets/áudio finais, save/load e QA Android continuam pendentes.
- Teste de runtime novo: `tests/unit/test_campaign_entry.gd`; verifica storyboard, progressão de etapas do tutorial e contratos de W1-L1; PR #15 integrada em `783c1d2`; Godot CI #56 e Docs CI #175 SUCCESS (44 testes, 205 verificações, 0 falhas). CI pós-merge #57/#176 em execução.


## Combate básico — branch `feat/chrono-pistol-combat-core`

- `BoltHealth`: vida reutilizável com redução limitada a zero e sinal de esgotamento.
- `BoltCombat`: consome ATTACK pelo `ActionBuffer` e instancia `ChronoProjectile` da Pistola Crono.
- Botão touch TIRO adicionado ao HUD; ação ATTACK passa a ser bufferizada como salto/dash.
- `BoltTrainingTarget` é alvo estático de treino, não um arquétipo de inimigo da campanha.
- Tutorial agora ensina mover → saltar → Dash → acertar o alvo com TIRO antes de liberar Cybercore.
- Cadência, velocidade, dano e alcance são parâmetros de protótipo; não representam balanceamento aprovado. Tríplice Prisma, Laser Nexo, seleção de armas, IA inimiga e dano/vida de BOLT permanecem pendentes.
- Testes novos: `test_combat_core.gd`, regressão de buffer ATTACK e extensão de `test_campaign_entry.gd`; PR #17 integrada em `33fe452`; Godot CI #61 e Docs CI #182 SUCCESS (47 testes, 231 verificações, 0 falhas). CI pós-merge #62/#183 em execução.


## Pós-merge PR #21 — recuperação e feedback (2026-11-26)

- Main HEAD: `b2e66d9638d367cce29b266d75f230cb16ed1763`.
- `BoltHealth.restore(amount)` limita a cura à vida máxima e não restaura uma vida já esgotada.
- `BoltPlayer.heal(amount)` bloqueia cura para jogador derrotado ou sem necessidade de cura.
- `BoltHealthPickup` é consumido apenas após recuperação válida; colocado em W1-L1 como protótipo de gameplay.
- `CybercorePatrolEnemy` emite feedback visual temporário ao receber dano e restaura a cor-base no tick fixo.
- Godot CI run `45849915250` SUCCESS: Godot 4.7.2, 53 testes, 276 verificações, 0 falhas. Uma execução anterior falhou e foi corrigida antes do merge.
- Sem exportação APK, instalação, emulador, aparelho físico ou medições de desempenho.


## Correção de integração W1-L1 — branch `fix/w1-l1-layout-checkpoint-integration`

- Inimigo-base em `scenes/campaign/cybercore_w1_l1.tscn`: posição alinhada ao piso intermediário e patrulha limitada à plataforma.
- Área `Goal`: altura corrigida para cruzar a área de colisão do jogador sobre o piso final.
- `tests/unit/test_campaign_entry.gd`: cobertura de posição do inimigo/objetivo e fluxo checkpoint → dano → queda/respawn.
- A primeira execução Godot CI (`45851338093`) encontrou uma asserção excessivamente rígida: o inimigo já havia avançado no primeiro tick. Corrigida para verificar o intervalo de patrulha; nova CI pendente.
- Status W1-L1 permanece **Em andamento**. Não houve playtest humano nem validação Android.


## W1-L1 — feedback de progressão e gatilhos de integração (branch `feat/w1-l1-progression-feedback`)

- `Hud.show_progress_notification(message)`: feedback temporizado via Timer one-shot; não adiciona processamento por frame.
- `CybercoreW1L1`: conecta `BoltHealthPickup.collected` e apresenta mensagens de checkpoint/recuperação.
- `tests/unit/test_campaign_entry.gd`: exercita os eventos por sobreposição física real para checkpoint, kill zone, pickup e Goal; verifica vida restaurada e overlay de conclusão.
- A geometria não foi alterada: revisão confirmou que `PlatformBlock` interpreta `position` como canto superior esquerdo e o Goal está dentro do EndFloor. O teste protege essa relação.
- Status W1-L1 continua **Em andamento**; ainda faltam playtest humano, arte/áudio finais, save/load de campanha e QA Android.

- Checkpoint da W1-L1 agora em x=980; teste verifica folga entre o ponto de respawn e a área de contato do inimigo usando dimensões das CollisionShape2D.


## W1-L1 — integração do primeiro disparo no encontro real (branch `test/w1-l1-live-combat-encounter`)

- Novo teste em `tests/unit/test_campaign_entry.gd`: posiciona BOLT no piso do encontro, envia o evento lógico ATTACK pelo `Input.parse_input_event`, deixa o `ActionBuffer` e `BoltCombat` processarem o disparo e aguarda o sinal `CybercorePatrolEnemy.hit_received`.
- Verifica que o projétil real da Pistola Crono reduz a vida do inimigo real instanciado em W1-L1.
- Não altera dano, cadência, velocidade, tuning, IA ou comportamento de combate; apenas eleva a cobertura de integração do contrato já implementado.
- CI desta branch pendente. W1-L1 permanece **Em andamento** até critérios de fase, playtest e QA Android serem atendidos.


## W1-L1 — derrota e retry (branch `test/w1-l1-defeat-retry-flow`)

- Novo teste `test_campaign_defeat_exposes_retry_for_w1_l1`: aplica dano letal ao player real da cena, verifica overlay/título de derrota, conexão do botão `JOGAR DE NOVO` e destino de reinício para a própria W1-L1.
- Não altera política de vidas, checkpoint, respawn, dano, invulnerabilidade ou fluxo de cena; valida o contrato já implementado.
- CI Godot 4.7.2 e Docs desta branch pendentes.


## Pós-merge PR #26 — derrota e retry W1-L1

- Main HEAD: `3428851c774f989d3522da1ed0430e9d39f7a680`.
- `test_campaign_defeat_exposes_retry_for_w1_l1`: dano letal no player da cena, overlay/título de derrota, conexão do botão `JOGAR DE NOVO` e destino de reinício W1-L1.
- Godot CI pré-merge `45855625278` SUCCESS: 54 testes, 304 verificações, 0 falhas. Docs CI pré-merge `45855625442` SUCCESS.
- CI pós-merge main Godot `45855795164` SUCCESS: 54 testes, 304 verificações, 0 falhas; Docs `45855795173` SUCCESS.
- W1-L1 segue **Em andamento**; critérios pendentes incluem persistência de campanha/save-load, conteúdo final, playtest e QA Android.


## SYS-015 — armazenamento versionado (branch `feat/versioned-save-storage-foundation`)

- `scripts/core/save_system.gd`, autoload `SaveSystem`; arquivo principal `user://bolt_save.json`, temporário e backup.
- Envelope `format_version=1`, `payload` Dictionary JSON-safe e checksum SHA-256. Tipos runtime (Node/Resource) e chaves que não sejam String são rejeitados.
- Escrita com temporário e backup; leitura tenta backup após principal ausente/inválido. Versão desconhecida falha fechada. API síncrona deve ser chamada em marcos discretos, nunca por frame.
- `tests/unit/test_save_system.gd`: round-trip/sobrescrita/delete, backup recovery, versão futura e payload não serializável; CI pendente.
- Não há modelo de dados de campanha, migração de versão, autosave ou integração com `BoltCheckpoint`. `SYS-014` e W1-L1 permanecem Em andamento.


## Integração CampaignProgress — branch `feat/w1-l1-persistent-checkpoint-progress`

- Autoload `CampaignProgress` separado do `SaveSystem`; schema de domínio v1 dentro da chave `campaign_progress` do payload raiz.
- Persiste `campaign_id=main`, `current_level_id`, `active_checkpoint_id` e `completed_level_ids` com IDs estáveis.
- W1-L1 grava no evento de checkpoint, restaura indicador/respawn na reentrada e marca conclusão ao alcançar o objetivo; conclusão limpa o checkpoint ativo e não inventa transição para W1-L2.
- ADR-0004 e docs técnicos `08-campaign-progress.md` formalizam o contrato. Testes de serviço e integração adicionados; CI pendente.
- SYS-014/SYS-015 continuam **Em andamento** até validação Android, migrações e integração das demais fases.


## Pós-merge PR #29 — CampaignProgress em W1-L1

- Main HEAD: `44d9e0fcda68200579506b909c8920d4692cdc84`.
- Godot CI pré-merge `45859492456` SUCCESS: 62 testes, 369 verificações, 0 falhas; Docs CI `45859492355` SUCCESS.
- `SYS-014`: checkpoint de W1-L1 agora persiste e restaura em reentrada; demais níveis e sandbox continuam sem integração.
- `SYS-015`: SaveSystem v1 + CampaignProgress v1 implementados parcialmente; migrações futuras e outros domínios pendentes.
- W1-L1 segue **Em andamento**: falta conteúdo final, transição real para W1-L2, playtest humano e QA Android.


## Correção transversal de feedback — W1-L2 checkpoint (2026-11-26)

- `SYS-014` / W1-L2: corrigido na branch `fix/w1-l2-checkpoint-feedback` o caminho em que a notificação visual só aparecia quando o salvamento falhava.
- O caminho normal agora também deve informar `CHECKPOINT ATIVADO`; regressão verifica visibilidade e texto no HUD.
- **Estado:** implementado na branch, aguardando Godot CI e Docs CI. Não classificar como validado nem integrado até os checks e o merge serem confirmados.
- A correção não altera a persistência nem o comportamento do checkpoint.


## SYS-022 — regressão de contato físico do coletável (2026-11-26)

- Base: main após PR #36, commit `afea046b6a481d48299641c9d8e529f6288d5256`.
- Achado: o teste anterior de `BoltHealthPickup` invocava `_on_body_entered` diretamente; não exercitava a colisão real entre o player e a `Area2D`.
- Branch `test/health-pickup-physical-contact`: acrescentado teste de sobreposição física, cura, emissão única de `collected` e consumo do coletável.
- O workflow Godot passa a procurar também o erro de mutação de estado físico bloqueada durante sinais/flush de queries.
- **Estado:** PR #37 integrada em `39b6db8298542c5057c06f509b20d250a888e289`; Godot e Docs CI pré/pós-merge SUCCESS. A cobertura física isolada complementa o teste de integração já existente em `test_campaign_entry.gd`.
- Não altera cura, valores de gameplay, colisões, persistência ou canon.


## SYS-024 — pipeline de exportação Android debug (2026-11-26)

- Base: main após PR #37, commit `39b6db8298542c5057c06f509b20d250a888e289`.
- Preset existente: `Android (debug/teste)`, arm64-v8a, landscape e modo imersivo; package ID `com.example.boltaventura` permanece placeholder.
- Branch `ci/android-debug-export`: workflow baixa Godot e templates pareados, instala JDK 17/Android SDK, gera chave de debug efêmera, roda importação/testes, exporta APK, verifica assinatura/package ID/hash e publica artifact temporário.
- Nenhuma chave de release, segredo, package ID definitivo ou permissão nova foi introduzida.
- **Estado:** PR #38 integrada em `d08a2b203e525ccc98a4a0e45d1532b41e674fc5`; export Android debug SUCCESS no run `45879045098`, assinatura v2/v3 verificada e artifact publicado. Instalação e validação Android física pendentes.
- Mesmo após export, instalação, cold start, touch, safe area, lifecycle e performance Android físico permanecem pendentes.


## SYS-004 — limpeza do ActionBuffer no ciclo de vida Android (2026-11-26)

- Base: main após PR #38, commit `d08a2b203e525ccc98a4a0e45d1532b41e674fc5`.
- Achado: a liberação de ações físicas em perda de foco não garantia, por si só, a remoção dos edges ainda armazenados no `ActionBuffer`.
- PR #39 integrada por squash em `50c9bfdd997edf0cb5cb7cfb22d246bd4d0beca2`: limpeza em notificações de pausa, suspensão e perda de foco; regressões de JUMP e DASH passaram.
- A janela de buffer, a física, os valores de movimento e o Dash não foram alterados.
- Plano: `docs/production/plans/2026-11-26-action-buffer-lifecycle-clear.md`.
- **Estado:** integrada e validada em CI headless — 72 testes/451 verificações/0 falhas. Notificações simuladas em headless não substituem teste de background/foreground em Android físico.


## Pós-merge PR #39 — ActionBuffer lifecycle

- Main merge: `50c9bfdd997edf0cb5cb7cfb22d246bd4d0beca2`.
- `ActionBuffer` limpa edges pendentes em pausa, suspensão e perda de foco.
- Godot CI `45881320136`: 72 testes / 451 verificações / 0 falhas.
- Docs CI `45881320133`: SUCCESS.
- Android Debug Export `45881252046`: SUCCESS; artifact, assinatura, package ID e SHA-256 documentados em `CI_AND_VALIDATION_PIPELINE.md`.
- A lógica foi testada por notificações simuladas/headless; teste real de background/foreground e multitouch continua pendente em Android físico.


## SYS-020 — overlay persistente de carregamento (2026-11-26)

- Base: main após PR #40, commit `85412c3bdd5c6eefd27f25bf2a56af4b38fcdfed`.
- `SceneFlow` já fazia carregamento threaded; não existia UI persistente conectada aos sinais de transição.
- Branch `feat/scene-loading-overlay`: autoload `LoadingOverlay` e cena `scenes/ui/loading_overlay.tscn`; mostra texto sem porcentagem quando o engine não reporta progresso e barra somente quando há valor real.
- O overlay é ocultado em sucesso e falha. `SceneFlow` usa `PROCESS_MODE_ALWAYS` para concluir transições mesmo com a árvore pausada.
- Testes adicionados: autoload no project config, estado inicial, progresso real, conclusão, falha e processamento durante pausa.
- Plano: `docs/production/plans/2026-11-26-scene-loading-overlay.md`.
- **Estado:** aguardando CI; não há validação visual ou Android físico.


## SYS-020 — bloqueio integral de input durante carregamento (2026-11-26)

- Base: main após PR #41, commit `66b3c0e060762ebe1f3c4b6af84c84a79f0cd781`.
- Revisão da PR #41 identificou que `Control.MOUSE_FILTER_STOP` captura input GUI/touch, mas não bloqueia ações de teclado no InputMap.
- Branch `fix/scene-flow-input-lock`: SceneFlow pausa a SceneTree ao aceitar a transição, continua processando em `PROCESS_MODE_ALWAYS`, retoma após `scene_changed` e restaura a pausa anterior em falha; HUD oculta/libera TouchControls e ignora pause durante transição.
- Regressões: pausa/retomada da SceneTree na troca real; touch liberado/oculto e restaurado quando a transição falha.
- Plano: `docs/production/plans/2026-11-26-scene-flow-input-lock.md`.
- **Estado:** aguardando CI; teste Android físico pendente.


## SYS-007 — contratos da câmera 2D (2026-11-26)

- Base: main após PR #43, commit `22923228d2a58c0ee6d75b581d5a16aa70e1a7ef`.
- Implementação existente: Camera2D nativa, smoothing speed 10, drag margins horizontal/vertical, `limit_smoothed` e callback físico; W1-L1 bounds `(0,-360)-(2200,260)`, W1-L2 `(0,-360)-(1900,260)`.
- Branch `test/camera-contracts`: extração da aplicação de limites para `configure_camera()` e testes de propriedades do rig e limites por fase.
- Plano: `docs/production/plans/2026-11-26-camera-contracts.md`.
- **Estado:** aguardando CI. Headless valida propriedades, não o enquadramento visual ou o comportamento em hardware.
