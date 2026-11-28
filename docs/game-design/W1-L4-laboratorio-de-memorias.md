# W1-L4 — Laboratório de Memórias

**ID persistente:** `W1-L4`  
**Mundo:** W1 — Cybercore  
**Estado:** BLOCKOUT PROVISÓRIO · IMPLEMENTAÇÃO INICIAL  
**Etapa:** 23 — Construção das fases e integração dos ambientes

## 1. Fonte canônica

A fase segue a entrada W1-L4 do Atlas Mestre de 42 fases:

- **Função:** aprofundar mistério e precisão.
- **Estrutura:** vertical, com elevadores, câmaras e plataformas em níveis.
- **Percurso:** recepção lacrada → arquivo holográfico → câmaras de teste → observatório.
- **Ensina:** leitura de plataformas, saltos encadeados e uso deliberado de cada arma.
- **Desafios:** plataformas que alternam estado com aviso visual; lasers ambientais lentos e previsíveis.
- **Inimigos:** Projeção Defensiva, Drone Vigia e Sentinela.
- **Narrativa:** primeira evidência de que Bolt esteve ligado a um projeto de preservação.
- **Segredo:** memória corrompida com silhueta de uma figura associada ao Arquiteto.
- **Conclusão:** recuperar o registro central e localizar a torre de energia.

W1-L4 é **Laboratório de Memórias**. Não é “Núcleo de Distribuição”; as PRs que propunham esse nome foram encerradas sem merge por divergirem do Atlas.

## 2. Composição implementada

- Rota vertical com três elevadores móveis.
- Plataformas de laboratório com ciclo `ACTIVE → WARNING_OFF → INACTIVE → WARNING_ON`.
- A colisão permanece durante `WARNING_OFF`, é removida em `INACTIVE` e só retorna depois de `WARNING_ON`.
- Dois lasers ambientais `TimedEnergyGate` com janelas inativas longas e previsíveis.
- Arquivo holográfico com trigger de registro de preservação.
- Rota lateral provisória por dutos de manutenção.
- Silhueta visual provisória e beat ID de memória corrompida associada ao Arquiteto.
- Dois checkpoints verticais.
- Observatório/saída bloqueado até a recuperação do registro central.

## 3. Contratos dos novos componentes

### AlternatingPlatform

- Deriva de `PlatformBlock`; mantém o contrato de colisão do mundo.
- Usa delta físico fixo, respeita pausa da SceneTree e não depende de Timer ocioso.
- Expõe estado e sinal `state_changed`.
- Avisa antes de remover colisão e antes de restaurá-la.
- O estado visual é distinto em ativo, aviso de saída, inativo e aviso de retorno.

### NarrativeBeatTrigger

- Emite somente um `StringName` de beat, sem texto de diálogo embutido.
- Aceita BOLT como corpo ativador e pode ser one-shot.
- Não altera CampaignProgress nem o save schema.
- O controlador da fase traduz os IDs em notificações temporárias de UI; a integração com o sistema narrativo global permanece pendente.

## 4. Progressão e persistência

- ID persistente: `W1-L4`.
- Checkpoints:
  - `cybercore_w1_l4_archive_checkpoint`
  - `cybercore_w1_l4_chambers_checkpoint`
- Entrada e conclusão usam `CampaignProgress` schema v1.
- O registro central é requisito de conclusão; o segredo é um evento local à instância e não é persistido.
- O menu Continuar resolve W1-L4.
- O catálogo libera W1-L4 após W1-L3, desde que a PackedScene exista.
- W1-L5 permanece indisponível até a fase canônica Torre do Núcleo ser implementada.

## 5. Lacunas conhecidas

- Projeção Defensiva e Drone Vigia ainda não existem como arquétipos próprios. O blockout usa `CybercorePatrolEnemy` genérico apenas como placeholder; não o renomear como se fosse um deles.
- As armas Tríplice e Laser e o contrato de uso deliberado de cada arma ainda não estão completos; não criar gates que dependam delas antes de integrar os sistemas.
- A recepção lacrada é representada por composição de blockout, sem puzzle de acesso adicional.
- O beat ID é local; ainda não há diálogo, dublagem ou persistência narrativa global.
- O segredo tem rota e silhueta provisórias, mas não concede item de lore persistente.
- Arte, animação final, áudio, balanceamento e telemetria Android física permanecem pendentes.

## 6. Critérios de regressão

- Godot 4.7.2 importa e instancia a cena.
- Plataformas alternantes sinalizam antes de mudar colisão.
- A pausa congela o ciclo.
- Lasers iniciam em janela segura e mantêm seus ciclos previsíveis.
- O registro central é necessário para concluir.
- O beat secreto é one-shot e não altera save.
- Checkpoint restaura a posição vertical após reentrada.
- W1-L4 fica selecionável após W1-L3 e pode ser retomada pelo menu.
- Nenhum teste declara arquétipos, armas ou narrativa global como concluídos.

## 7. Limites de validação

CI/headless comprova parsing, contratos e regressões. Não comprova legibilidade touch, conforto de saltos encadeados, janela real de lasers, performance térmica, FPS, memória ou equilíbrio em Android físico. A fase permanece BLOCKOUT PROVISÓRIO.
