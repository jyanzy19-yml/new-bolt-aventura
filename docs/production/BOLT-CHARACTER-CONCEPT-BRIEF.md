# Brief de concept art — protagonista BOLT

**ID:** ART-BOLT-003  
**Etapa:** 07 — Concept art do protagonista BOLT e aprovação visual  
**Versão:** 0.1 — brief técnico preparatório  
**Estado:** SPECIFIED / aguardando decisões visuais da Etapa 05  
**Engine:** Godot 4.7.2 / GDScript  
**Produto:** Android empacotado, orientação paisagem  
**Fonte narrativa:** `docs/game-design/03-character-bible.md`  
**Pipeline técnico:** PR #88 — `docs/production/SPRITE-ASSET-TECHNICAL-GUIDE.md` (ainda não integrada à main)

---

## 1. Objetivo

Preparar a especificação de produção para o concept visual do protagonista, de modo que a primeira apresentação seja avaliável, rastreável e compatível com a futura implementação no Godot. Este documento não define a aparência de BOLT e não substitui a bíblia de personagens nem a direção visual global.

O resultado desta etapa deverá ser um conjunto de propostas visuais identificadas por versão, acompanhado de uma folha de personagem e de uma apresentação em escala de gameplay. A integração como arte oficial depende da aprovação explícita do usuário sobre a versão exata.

## 2. Autoridade narrativa e fatos confirmados

Os seguintes pontos são requisitos de consistência, não sugestões:
- BOLT é o protagonista.
- BOLT é um robô.
- BOLT desperta em um mundo destruído.
- BOLT encontra NEXO, uma máquina temporal, e une-se a ela.
- NEXO permite a travessia entre eras e mundos e está ligada ao mistério dos fragmentos.
- A função original de BOLT ligada à preservação dos universos é canon.
- O conflito central opõe a preservação/coexistência dos universos à imposição de uma única realidade pelo Arquiteto.

Não estão definidos e não podem ser inventados como canon neste brief:
- origem técnica específica e circunstâncias de criação;
- personalidade, voz, vocabulário e biografia detalhada;
- idade aparente, espécie/modelo ou classificação industrial;
- aparência final, proporções, materiais, paleta e detalhes ornamentais;
- origem e forma visual do vínculo físico/visual com NEXO;
- expressões, gestos, relações e arco emocional detalhado.

Qualquer solução visual para esses campos deve ser rotulada como proposta de concept e submetida a decisão.

## 3. Dependências e bloqueios

### 3.1 Etapa 05 — direção visual global

A proposta de direção visual global está registrada na PR #87 e ainda aguarda avaliação/aprovação explícita. Portanto, este brief pode avançar em requisitos, critérios e estrutura de apresentação, mas não pode congelar:
- estilo artístico;
- resolução lógica e escala de apresentação;
- proporções finais;
- paleta global ou paleta de BOLT;
- linguagem de linha, textura, iluminação e materialidade;
- densidade de detalhe;
- dimensões finais de sprite ou frame.

### 3.2 Etapa 06 — pipeline técnico

O guia ART-BOLT-002 foi criado na PR #88. A PR permanece aberta e sua validação documental automatizada foi concluída com sucesso (Docs Validation run `46016532136`). O guia está validado no escopo documental, embora ainda não integrado à `main`. Os valores técnicos dependentes da direção visual continuam TBD até a aprovação da Etapa 05.

### 3.3 Regra de não bloqueio

É permitido preparar requisitos, perguntas de design, vistas necessárias e critérios de avaliação. É vedado produzir/registrar um concept final como aprovado, criar spritesheet de produção ou integrar arte final enquanto as dependências não forem resolvidas.

## 4. Requisitos de leitura em gameplay

A proposta de BOLT deverá ser avaliada no contexto real de jogo, não apenas como ilustração isolada.

- Silhueta reconhecível em escala reduzida.
- Centro de massa e orientação corporal legíveis durante corrida, salto, queda e aterrissagem.
- Cabeça/face e direção de olhar legíveis sem depender de microdetalhes.
- Membros e articulações visualmente separáveis nas poses de ação.
- Contraste suficiente em cenários claros, escuros e com efeitos.
- Contorno e detalhes não devem se confundir com perigos, pickups, inimigos ou foreground.
- Elementos luminosos, se propostos, devem reforçar hierarquia e não mascarar telegraphs ou HUD.
- A leitura deve sobreviver à proporção paisagem Android e à variação de telas prevista.
- A forma visual não determina hitbox, collider, alcance ou física.

Nenhum requisito acima prescreve uma solução estética específica.

## 5. Folha de personagem — conteúdo exigido

A folha de BOLT deverá conter, no mínimo, os seguintes painéis:

1. **Vista principal:** pose neutra em ângulo aprovado pela direção de arte.
2. **Vistas ortográficas:** frente, perfil e costas, com consistência geométrica.
3. **Silhueta:** preenchimento sólido sem detalhes internos, para teste de reconhecimento.
4. **Escala de gameplay:** BOLT sobre fundo representativo e em tamanho de apresentação previsto.
5. **Expressões/estado facial:** somente se compatível com o concept escolhido; não presumir boca, olhos ou voz.
6. **Materiais e construção:** indicação de materiais, juntas, superfícies e peças móveis, sem afirmar origem técnica canônica.
7. **Detalhes distintivos:** cada detalhe precisa de justificativa de leitura, função narrativa ou função de gameplay.
8. **Paleta proposta:** apresentada como alternativa visual, não como canon, até aprovação.
9. **Notas de consistência:** elementos que não podem mudar entre vistas e futuras animações.

## 6. Matriz de poses para avaliação

A primeira apresentação deve incluir poses estáticas de leitura, não spritesheet:
- repouso/idle neutro;
- locomoção/corrida;
- início de salto;
- ápice do salto;
- queda;
- aterrissagem;
- dano/reação;
- interação/atenção;
- pose de apresentação do protagonista.

As poses são requisitos de cobertura para avaliação. Não definem timing, frame count, animação final ou implementação de gameplay. Estados exatos devem ser reconciliados com a especificação de gameplay vigente antes da produção de sprites.

## 7. Critérios de avaliação e revisão

Cada alternativa será avaliada sem pontuação artificial ou decisão automática:

| Critério | Pergunta de avaliação |
|---|---|
| Identidade | BOLT parece um protagonista reconhecível e próprio? |
| Silhueta | É identificável em tamanho pequeno e sem detalhes internos? |
| Coerência | A construção comunica um robô sem contradizer o canon? |
| Expressividade | As poses comunicam intenção e estado sem lore inventada? |
| Gameplay | Membros, orientação e contato com o chão são legíveis? |
| Mobile | A leitura sobrevive à escala e à tela paisagem? |
| Produção | A forma pode ser reproduzida em vistas e animações consistentes? |
| Integração | Há separação entre arte, pivôs, colisões e lógica de runtime? |
| Direção global | A proposta respeita as decisões aprovadas da Etapa 05? |

O usuário poderá aprovar uma alternativa, rejeitar, pedir revisão ou aprovar apenas partes específicas. A aprovação deve identificar a versão e o escopo.

## 8. Contrato de aprovação

Cada apresentação terá:
- ID do asset: ART-BOLT-003;
- versão imutável da proposta;
- imagens/folha de personagem correspondentes;
- descrição das decisões ainda abertas;
- referência à direção visual global;
- finalidade da aprovação;
- registro da decisão do usuário.

Estados:
- `SPECIFIED`: brief pronto;
- `CONCEPT_CREATED`: proposta visual gerada;
- `AWAITING_USER_APPROVAL`: versão exata apresentada;
- `REVISION_REQUESTED`: revisão solicitada;
- `APPROVED`: aprovação explícita;
- `REJECTED`: rejeição explícita.

Nenhuma mensagem genérica de continuidade ou pedido para avançar equivale à aprovação de uma aparência específica. Concept aprovado não autoriza automaticamente spritesheet, animação, alteração de hitbox ou integração em cenas; cada escopo tem seu próprio aceite.

## 9. Restrições de integração

- Não alterar o nó/estrutura do Player apenas para acomodar um concept.
- Não inferir hitboxes a partir da silhueta.
- Não modificar física, aceleração, salto, Dash, InputMap, multitouch, save schema, IDs persistentes ou progressão.
- Não introduzir dependência runtime de ferramentas de arte.
- Não substituir placeholders atuais antes de aprovação e plano de integração.
- Manter origem e arquivos-fonte, exports, licenças e proveniência rastreáveis.
- Confirmar pivôs e alinhamento em cenas de teste sem mudar gameplay.
- Arte gerada para avaliação é concept, não asset integrado.

## 10. Critérios de aceite da Etapa 07

A etapa será concluída quando:
1. dependências visuais e técnicas forem resolvidas ou suas exceções explicitamente aprovadas;
2. concept de BOLT for apresentado em versão identificada;
3. folha de personagem contiver vistas e poses exigidas;
4. legibilidade for demonstrada em escala de gameplay e fundos representativos;
5. alternativas e decisões pendentes estiverem explícitas;
6. o usuário aprovar explicitamente uma versão/escopo ou rejeitar e solicitar revisão;
7. decisão, versão e proveniência forem registradas no manifesto e na fila;
8. nenhum asset não aprovado for integrado.

Enquanto a Etapa 05 não estiver aprovada, o trabalho desta etapa permanece preparatório e não pode declarar aceite visual final.

## 11. Estado desta entrega

**Entregue nesta unidade:** brief técnico ART-BOLT-003, matriz de fatos e lacunas, requisitos de leitura, folha de personagem, matriz de poses, critérios de avaliação, contrato de aprovação e limites de integração.

**Ainda não entregue:** concept visual, vistas desenhadas, poses ilustradas, paleta, proporções, arte final, spritesheet ou integração no jogo.

**Próxima ação:** resolver aprovação da direção visual global (Etapa 05) e validação do pipeline (Etapa 06); em seguida, produzir a primeira folha de concept de BOLT para avaliação explícita.
