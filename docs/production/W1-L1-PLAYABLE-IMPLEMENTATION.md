# W1-L1 — Despertar entre Ruínas
## Implementação jogável inicial / pacote de produção

**Task:** BOLT-001  
**Writer:** ChatGPT  
**Base:** PR #161, commit 3ef82158aa45c21af51e2eea793b0ebbdfc44570  
**Branch:** agent/chatgpt/w1-l1-production-playable  
**Status do conteúdo:** IMPLEMENTADO como blockout jogável; não aprovado como arte final.  
**Validação:** testes automatizados adicionados; execução CI/browser/dispositivo ainda pendente no momento deste registro.

## 1. Autoridade de design

A fase implementa os beats do blueprint oficial docs/game-design/EXPANDED-42-LEVEL-CAMPAIGN-BLUEPRINT.md:

- Função: tutorial orgânico e apresentação de BOLT.
- Percurso: câmara de despertar → corredor desmoronado → pátio aberto → abrigo de manutenção.
- Progressão: movimento/aceleração, salto, altura variável, pulo duplo e interação em espaços legíveis.
- Encontro: unidade de manutenção defeituosa isolada, opcional/leve.
- Narrativa: BOLT desperta sem memória; NEXO emite sinal fragmentado e orienta a saída.
- Segredo: compartimento de diagnóstico opcional.
- Conclusão: ativar o primeiro ponto de sincronização no abrigo.

O conteúdo não declara novos nomes, revelações ou personagens como canon. Textos curtos de interface são implementação provisória de beats já aprovados.

## 2. Mapa espacial implementado

Coordenadas em espaço de mundo, Canvas lógico 800×450. Limites da fase: 3600×700. Spawn: (72, 504). Piso principal: y=550.

| Segmento | Intervalo X | Função | Elementos |
|---|---:|---|---|
| Câmara de despertar | 0–720 | Apresentar personagem e leitura de movimento | Cápsula de despertar, pilar, plataformas largas |
| Corredor desmoronado | 720–1500 | Praticar deslocamento e salto em terreno irregular | Viga caída, entulho, plataforma elevada e sinal quebrado |
| Pátio aberto | 1500–2700 | Combinar salto, pulo duplo, Dash e exploração vertical curta | Arco em ruínas, plataformas escalonadas, unidade de manutenção, compartimento secreto |
| Abrigo de manutenção | 2700–3600 | Reduzir ritmo, apresentar objetivo de interação e concluir | Abrigo, ponto de sincronização e saída para W1-L2 |

A rota principal permanece horizontal e concluível. A seção vertical no pátio é curta e oferece acesso ao compartimento de diagnóstico; o segredo não é pré-requisito para terminar a fase.

## 3. Objetivos e progressão

1. Sair da câmara de despertar (progressão espacial em X ≥ 720).
2. Atravessar o corredor desmoronado (X ≥ 1500).
3. Alcançar o abrigo de manutenção (X ≥ 2700).
4. Ativar o primeiro ponto de sincronização (interação próxima ao terminal em X≈3220).

O compartimento de diagnóstico (X≈2200, Y≈222) é opcional. Sua ativação registra a descoberta apenas na sessão; persistência de campanha/save será integrada em uma etapa posterior.

## 4. Mecânicas e input

- Movimento horizontal e aceleração: setas ou A/D; botões touch independentes esquerda/direita.
- Salto variável e pulo duplo: Espaço/W/Z; botão touch PULAR.
- Dash: Shift/C; botão touch DASH. O contrato e os parâmetros existentes do PlayerMotor foram preservados, sem retuning nesta entrega.
- Interação: E/Enter; botão touch AÇÃO.
- Pausa: P/Escape ou botão PAUSAR.
- O input continua desacoplado da taxa de renderização por ActionBuffer e simulação em passo fixo de 60 Hz.

Os parâmetros do PlayerMotor reutilizam os valores da fixture de runtime que já existia; permanecem provisórios e não são declarados balanceamento final.

## 5. Unidade de manutenção

A unidade patrulha um trecho isolado do pátio, entre os limites declarados nos dados da fase. Sua função nesta primeira fase é introduzir leitura de movimento e evasão sem antecipar a lição de arsenal prevista para W1-L2. O contato é sinalizado visualmente; dano, combate e balanceamento de inimigos ainda não estão implementados nesta slice.

## 6. Direção visual e áudio

A renderer apresenta cenário vetorial original: ruínas tecnológicas, cápsula, mastros de sinal, arco, terminal, abrigo, beacon, plataformas metálicas e personagem robótico legível. É um placeholder de produção para validar composição, contraste, percurso e feedback.

- Arte final: PENDENTE de direção visual consolidada e aprovação do asset exato.
- Animações finais/spritesheets: PENDENTES.
- Música e SFX: PENDENTES; não há áudio final integrado nesta entrega.
- Paleta e materiais usados pelo renderer são proposta de blockout, não decisão final de arte.

## 7. QA automatizado adicionado

| ID | Caso | Resultado esperado | Severidade |
|---|---|---|---|
| W1L1-DATA-001 | Validar W1_L1 com schema compartilhado | Dados aceitos, IDs estáveis e geometria dentro dos limites | Crítica |
| W1L1-FLOW-001 | Cruzar limites dos quatro segmentos | Objetivo principal avança em ordem | Alta |
| W1L1-SECRET-001 | Interagir com compartimento | Segredo registrado sem concluir fase | Média |
| W1L1-END-001 | Interagir com ponto de sincronização | Checkpoint/sincronização e conclusão ativados | Crítica |
| W1L1-ENEMY-001 | Simular patrulha prolongada | Unidade permanece dentro dos limites de patrulha | Alta |
| W1L1-INPUT-001 | Teclado e multitouch | Ações chegam por ActionBuffer; testar manualmente simultaneidade real | Alta |
| W1L1-VIEW-001 | Aspect ratios e safe areas | Canvas mantém proporção e controles continuam acessíveis | Alta |
| W1L1-LIFECYCLE-001 | Blur/visibility/pause/resume | Nenhuma ação fica presa; requer browser/device QA | Alta |
| W1L1-PLAY-001 | Jogar do início ao fim em browser | Rota principal concluível, sem softlock | Crítica |
| W1L1-ANDROID-001 | Android WebView em aparelho físico | Touch, barras, lifecycle e performance verificados | Crítica |

Os últimos cinco casos exigem validação manual/ambiente apropriado e não são declarados aprovados por este documento.

## 8. Dependências e limitações

- A W1-L1 usa o runtime Canvas/physics/input da PR #161; esta PR deve ser integrada antes ou junto com o pacote que a consome.
- O ponto de saída referencia W1-L2, mas W1-L2 não está implementada nesta slice.
- Save persistente, checkpoint após cold start, áudio, armas, combate, dano, menu de opções, inventário e campanha completa permanecem pendentes.
- A política de immersive system bars depende de shell Android nativo; não é implementada por CSS/Canvas.
- Não foi feita validação manual no browser ou Android físico neste registro.
- A fase é jogável em blockout vetorial, mas não é candidata a release nem conteúdo visual final.

## 9. Critério de aceite desta unidade

A unidade será considerada integrada quando CI confirmar lint, testes e build; revisão do diff não apontar regressões; a rota principal puder ser concluída em browser; e as limitações de Android/arte/áudio permanecerem explicitamente rastreadas. A aprovação de integração não equivale à aprovação de arte final ou validação Android física.


## Estado de CI

Os resultados oficiais de lint, testes, build e análise estática são os checks associados ao HEAD atual da Pull Request. Este documento não substitui essas evidências e deve ser atualizado após cada execução relevante.
