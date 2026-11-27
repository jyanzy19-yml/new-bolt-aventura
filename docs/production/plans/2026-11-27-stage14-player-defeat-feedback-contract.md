# Etapa 14 — integração de derrota do jogador e feedback terminal

**Data:** 27/11/2026  
**Etapa:** 14 — Interações, sobrevivência, checkpoints e recuperação  
**Branch:** `test/stage14-player-defeat-feedback-contract-2026-11-27`  
**Base:** `main` no início desta unidade  
**Tipo:** regressão automatizada de integração; sem alteração de runtime

## Motivação

Os contratos já existentes cobrem separadamente a transição do componente `BoltHealth` para vida esgotada (PR #82), a recuperação de estados transitórios no respawn (PR #93), e a apresentação de resultados na HUD. Esta unidade fecha uma lacuna de integração: demonstrar que o esgotamento real da vida do protagonista propaga-se uma única vez pelo sinal público `BoltPlayer.defeated`, alcança o controlador da fase W1-L1 e deixa HUD, controles touchscreen e SceneTree em um estado terminal coerente.

A regressão utiliza a cena real de campanha W1-L1 e a API pública `BoltPlayer.take_damage()`. Não invoca diretamente o handler privado da fase nem o método `Hud.show_result()`.

## Escopo fechado

Arquivo novo: `tests/unit/test_stage14_player_defeat_feedback_contract.gd`.

Cenário coberto:

1. Instanciar W1-L1 com armazenamento isolado e confirmar vida íntegra/overlay oculto.
2. Inserir um toque curto de ataque no `ActionBuffer` para observar a limpeza no ciclo terminal.
3. Aplicar dano letal pela API pública do jogador.
4. Verificar vida zero, emissão única de `defeated`, interrupção do processamento físico e limpeza do comando pendente.
5. Verificar integração real com HUD: texto de derrota, vida `0 / 3`, controles touch ocultos, SceneTree pausada e ação de reinício da fase.
6. Rejeitar dano adicional e confirmar que não há duplicação de evento nem mutação do feedback terminal.

## Preservação

- Um arquivo de teste é adicionado; o workflow Android também remove a reinstalação redundante de `cmdline-tools;latest`, já disponibilizado pelo passo `setup-android`.
- Nenhum script de runtime, cena, valor de vida/dano, física, invulnerabilidade, Dash, InputMap, ActionBuffer, save schema, ID persistente, progressão, canon, arte ou asset é modificado.
- A mudança no workflow é operacional e idêntica à correção aplicada na PR #93, necessária enquanto essa correção ainda não estiver integrada em `main`.
- Não altera a política de recuperação/respawn da PR #93.
- Não duplica o contrato unitário de sinais de `BoltHealth` da PR #82; cobre a integração `BoltHealth → BoltPlayer → controlador W1-L1 → Hud`.
- O save de teste usa caminho isolado e é removido ao final.
- Não declara a Etapa 14 concluída.

## Critérios de aceite

- O teste é descoberto automaticamente pelo runner `tests/test_runner.gd`.
- O fluxo é exercitado por cena de campanha e API pública; handlers privados de fase/UI não são chamados pelo teste.
- Godot Validation, Documentation Validation e Android Debug Export passam no HEAD final.
- A PR permanece aberta para revisão; não integrar sem autorização explícita.
- Exportação Android em CI é evidência de compatibilidade de empacotamento, não validação física.

## Limitações

O teste headless não comprova renderização visual em aparelho, latência de touchscreen, acessibilidade do botão de reinício em hardware, frame pacing, FPS, memória ou estabilidade térmica Android.


## Evidência CI — HEAD de implementação

- HEAD de implementação validado: `d666d52f5f19bc62672eddbf7dd41592142b3ad4`.
- Godot Validation run `46042358492`: SUCCESS — **109 testes / 1.959 verificações / 0 falhas**, 20/20 cold boots; mutation check do prewarm aprovado.
- Documentation Validation run `46042358553`: SUCCESS.
- Android Debug Export run `46042358532`: SUCCESS — suíte headless **109 testes / 1.959 verificações / 0 falhas**.
- APK debug: 28.469.428 bytes; package ID placeholder `com.example.boltaventura`; SHA-256 `c54c573be6b5c4029c22a7476f8756b4ddf52428b91242a9cee93bea7f69e276`; assinatura v2/v3 verificada; artifact ID `15220227823`; digest ZIP SHA-256 `a1029d859cd2e8c30161ba6e007899b3f866f2d5f3f74ef8b5c187b353ca1fe7`.
- A remoção da instalação redundante de `cmdline-tools;latest` corrigiu o pré-requisito de exportação Android enquanto a correção correspondente da PR #93 ainda não está em `main`.
- Esta evidência pertence ao HEAD de implementação acima. Os commits posteriores nesta branch são apenas atualização de documentação; a validação documental do HEAD mais recente deve ser confirmada separadamente.
