# PROPOSTA — W1-L4 Núcleo de Distribuição (design de fase)

**Status: BLOCKOUT PROVISÓRIO / PROPOSTA.** Fonte de canon: `EXPANDED-42-LEVEL-CAMPAIGN-BLUEPRINT.md` (W1-L4). Tudo abaixo do que o blueprint estabelece (layout, números, glifos, textos de HUD, mural) é **proposta** pendente de playtest e aprovação visual. Sem arte final: apenas formas de blockout.

## Estabelecido pelo blueprint (preservado)
Primeira fase de combinação e orientação espacial; mapa híbrido com dois caminhos que convergem, atalhos visíveis e rota vertical opcional; direcionamento de energia por interruptores de ambiente com ordem inferível por pistas; NEXO reage a um sinal antigo mas não consegue decodificá-lo completamente; opcional de domínio de movimento com recompensa a especificar; gate: sem pixel hunting, feedback de estado, retorno seguro após falha.

## Blueprint de fase (`05-level-design-standard.md` §2)
- **ID / mundo:** W1-L4 / Cybercore.
- **Objetivo de gameplay:** deduzir a ordem de ativação de 3 relés lendo conduítes e um mural, e abrir a barreira de saída.
- **Entrada e saída:** spawn à esquerda; objetivo atrás da barreira de energia, à direita.
- **Rota principal:** (1) caminho inferior (chão, 2 vãos de 120 px) com o relé A; (2) caminho superior (degraus one-way, vãos ≤ 120 px) com o relé B; (3) convergem no hub, onde está o relé C e a barreira.
- **Rotas opcionais / atalhos:** degraus one-way visíveis ligam hub ↔ caminho superior; rota vertical de 4 plataformas one-way sobre o hub até um mirante cujo último vão (200 px) exige pulo duplo/dash.
- **Mecânica ensinada:** ler o ambiente (conduítes acesos/apagados, mural) e ativar alvos à distância com TIRO.
- **Sequência de aprendizagem:** mural visível desde o spawn → conduíte da fonte já aceso até o relé A → cada acerto acende o próximo trecho → falha reinicia sem custo.
- **Checkpoints:** A antes da bifurcação; B no hub (após a convergência).
- **Segredos/recompensas:** marcador **PLACEHOLDER** "RECOMPENSA — A ESPECIFICAR" no mirante. Sem coletável funcional (tipo de recompensa não está especificado).
- **NPCs/eventos narrativos:** gatilho `w1_l4_nexo_ancient_signal` no hub que apenas **anuncia** o beat por ID. **Nenhum diálogo, explicação ou fato sobre o sinal foi escrito.**
- **Requisitos de arte/áudio:** nenhum final; áudio ausente.

## Como a ordem é inferida (sem tentativa aleatória nem pixel hunting)
1. **Mural** perto do spawn: FONTE → ◇ → ○ → △ → BARREIRA (os glifos vêm dos próprios relés).
2. **Conduítes** ligam fisicamente fonte → A → B → C → barreira. O trecho fonte→A já inicia **aceso**; cada acerto acende o seguinte, mostrando o avanço da energia.
3. Cada relé exibe seu glifo (forma, não só cor). Estados distinguíveis por forma: apagado (cinza), energizado (halo), rejeitado (X).

Mapeamento provisório de tiro: A fica no chão da rota inferior; **B só é atingível pelo piso superior** (linha de tiro horizontal); C no hub. Isso obriga a visitar ambos os caminhos antes da convergência.

## Falha e retorno seguro
Ordem errada → sequência reinicia, todos os relés piscam X, conduítes apagam, aviso "SEQUÊNCIA INTERROMPIDA · REINICIADA". **Sem dano.** Quedas em vãos respawnam no último checkpoint e **mantêm** o progresso do puzzle da instância. Todas as áreas são percorríveis nos dois sentidos (sem soft-lock).

## Perguntas abertas (aprovação do usuário)
1. Textos de HUD ("NÓ n/3 ENERGIZADO" etc.) são propostos.
2. Forma do beat narrativo de NEXO/sinal (cutscene, fala, apenas SFX?) — a definir; o gatilho só emite o ID.
3. Qual é a recompensa opcional (cosmético/colecionável) — a especificar.
4. Persistência do estado do puzzle em checkpoint exige extensão de schema (fora de escopo; ver spec técnica).
