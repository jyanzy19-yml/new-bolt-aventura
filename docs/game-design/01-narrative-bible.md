# BOLT · AVENTURA — Bíblia narrativa

## 1. Canon disponível
A história acompanha um robô que desperta em um mundo destruído. Ele encontra uma máquina temporal que se une a ele. A união permite viajar por eras e mundos. O protagonista precisa recuperar um fragmento em cada um dos sete mundos; cada fragmento é protegido por um chefe ao final do respectivo mundo. Os fragmentos estão conectados ao mistério da máquina temporal e são necessários para restaurar o equilíbrio dos universos.

Não extrapolar esta premissa para declarar quem destruiu o mundo, por que a máquina se uniu ao robô, quem criou os fragmentos ou qual é a natureza exata do antagonismo. Esses pontos precisam vir de material aprovado ou ser apresentados como propostas.

## 2. Promessa narrativa
O jogador deve sentir que acordou em um lugar que precisa compreender; que a máquina temporal é parte importante da jornada; que cada mundo revela uma parte nova do mistério; que cada fragmento representa uma conquista; que NPCs e ambientes têm histórias próprias; e que a conclusão recompensa a jornada e fecha o conflito central.

## 3. Estrutura dramática macro
| Ato | Função | Estado |
|---|---|---|
| Ato I — Despertar | Apresentar protagonista, mundo destruído e encontro com a máquina | A premissa é confirmada; cenas e diálogos a definir |
| Ato II — Travessia | Estabelecer viagem entre mundos e busca dos fragmentos | Sete mundos, fragmentos e ordem confirmados na Bíblia dos Mundos; ritmo de revelações e cenas a desenvolver |
| Ato III — Convergência | Reunir significado dos fragmentos e confrontar o conflito central | Equilíbrio dos universos é o objetivo; clímax a desenvolver sem contradizer o canon |
| Epílogo | Mostrar consequências e encerrar a jornada | Encerramento principal obrigatório; encenação e diálogos finais a desenvolver |

A sequência dos sete mundos e a ordem dos fragmentos são fixas conforme `docs/game-design/02-world-bible.md` e o prompt mestre. O que permanece a desenvolver é a distribuição das revelações, cenas, diálogos e consequências dentro dessa sequência.

## 4. Regras narrativas
1. Toda cutscene apresenta informação, emoção, decisão ou consequência nova.
2. Evitar exposição longa quando ambiente, animação ou interação comunicar melhor.
3. Manter consistência de voz, motivação e conhecimento dos personagens.
4. Não contradizer cronologia ou estado dos fragmentos.
5. A máquina temporal deve ter presença narrativa contínua; capacidades e personalidade precisam de definição aprovada.
6. O jogador entende o objetivo imediato mesmo quando o mistério maior permanece aberto.
7. Diálogos usam IDs estáveis para revisão, localização e salvamento.
8. Cenas importantes preveem pular/rever sem quebrar flags de progressão.

## 5. Ficha de cena cinematográfica
- ID e posição na sequência.
- Objetivo dramático.
- Personagens presentes e estado de conhecimento.
- Local, época e condição ambiental.
- Ação visual principal.
- Diálogo aprovado, com IDs de linha.
- Duração estimada e ritmo.
- Transição de entrada/saída.
- Controle do jogador durante a cena.
- Opção de pular e comportamento ao pular.
- Flags de história atualizadas.
- Áudio, música e legendas.
- QA: primeira exibição, replay, save/load no entorno e pulo.

## 6. Ficha de NPC
- ID/nome aprovado; papel no mundo; motivação e necessidade.
- O que sabe e não sabe; relação com BOLT e o fragmento.
- Estado inicial e mudanças após eventos.
- Linhas com IDs; função de gameplay; repetição e encerramento da conversa.

## 7. Canon narrativo consolidado

Os elementos abaixo já estão definidos no prompt mestre de design e devem ser tratados como canon de produção, não como lacunas:

- O **Grande Colapso** rompeu o **Núcleo da Eternidade** e desestabilizou a continuidade entre universos.
- **BOLT** desperta sem memória nas ruínas de **Cybercore**. Sua função original está ligada à preservação dos universos.
- A máquina temporal **NEXO** desperta e se une a BOLT, permitindo atravessar eras e mundos. NEXO está ligada ao mistério dos fragmentos.
- O antagonista central é **o Arquiteto**, que deseja impor uma única realidade e eliminar a coexistência entre universos em nome de uma ordem absoluta.
- A jornada reúne sete fragmentos, na ordem e nos mundos definidos na Bíblia dos Mundos: Origem, Memória, Verdade, Sombra, Luz, Ilusão e Equilíbrio.
- A sequência de abertura é: **cinemática de abertura → tutorial guiado por robô mensageiro com balões de fala → início da campanha em Cybercore**.
- O final deve resolver o conflito entre controle absoluto e coexistência, dar consequência à reunião dos sete fragmentos e encerrar o arco principal sem depender de uma continuação.

A causa mais profunda do Grande Colapso, a cadeia completa de eventos que levou à ruptura e a história integral do Arquiteto podem receber aprofundamento narrativo, mas qualquer detalhe novo além do que está estabelecido deve permanecer identificado como proposta até aprovação.

## 8. Questões pendentes — não preencher por suposição

- Personalidade, voz/ausência de voz, aparência final, expressões e arco emocional detalhado de BOLT.
- Forma visual, personalidade, voz, origem específica, limites e capacidades detalhadas de NEXO.
- Identidade pessoal, aparência, história completa, motivações secundárias e caracterização do Arquiteto além do objetivo central já definido.
- Origem técnica e funcionamento detalhado dos sete fragmentos; regras exatas da viagem temporal/dimensional.
- Nomes próprios, biografias e diálogos de NPCs ainda não aprovados.
- Diálogos finais, encenação exata das cutscenes, revelações intermediárias e epílogo detalhado.
- Detalhes de lore de cada mundo que não estejam definidos na Bíblia dos Mundos.

Não tratar os sete mundos, a ordem dos fragmentos, o Grande Colapso, o Núcleo da Eternidade, NEXO ou o Arquiteto como pendências gerais: esses elementos já estão definidos no prompt mestre e devem permanecer consistentes em todos os documentos.

## 9. Controle de canon
Use os rótulos **CANON APROVADO**, **PROPOSTA**, **RASCUNHO** e **DESCARTADO**. Uma proposta só vira canon após aprovação explícita. Ao alterar canon, registre a decisão em docs/decisions e atualize os documentos dependentes.
