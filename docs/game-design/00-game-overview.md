# BOLT · AVENTURA — Visão geral e pilares de design

## 1. Identidade do produto
- Nome: BOLT · AVENTURA.
- Gênero: aventura e plataforma 2D.
- Engine pretendida: Godot 2D; a versão exata deve ser detectada no projeto real.
- Plataforma-alvo: aplicativo Android empacotado.
- Hardware-alvo: aparelhos Android com aproximadamente 4 GB de RAM e MediaTek Helio G99 ou inferior.
- Estado deste repositório: framework de documentação e skills; não presumir que o projeto executável Godot já esteja presente.

## 2. Premissa central confirmada
Um robô desperta em um mundo destruído e encontra uma máquina temporal que se une a ele. Essa união permite viajar entre eras e mundos. A missão principal é recuperar um fragmento em cada um dos sete mundos. Os fragmentos são protegidos pelos chefes no final de cada mundo e estão ligados ao mistério da máquina temporal; juntos, são necessários para restaurar o equilíbrio dos universos.

O nome da máquina temporal é **NEXO** e o antagonista central é **o Arquiteto**, conforme o prompt mestre. A forma, personalidade, origem detalhada, cronologia completa, causa mais profunda do Colapso e encenação do desfecho devem seguir as Bíblias narrativa/personagens; detalhes adicionais permanecem propostas até aprovação. Não extrapolar a premissa como se detalhes novos fossem canon.

## 3. Pilares de experiência
1. **Aventura com progressão clara:** cada mundo acrescenta compreensão, desafio e domínio.
2. **Movimento expressivo:** habilidades compreensíveis, responsivas e combináveis.
3. **Mundos memoráveis:** identidade visual, sonora, mecânica e narrativa próprias.
4. **Narrativa integrada:** cenas, NPCs, ambientes e chefes avançam a história.
5. **Desafio justo:** perigos legíveis, telegraphs claros, checkpoints e curva de aprendizagem.
6. **Personalidade:** BOLT é reconhecível por comportamento, animação e reações.
7. **Qualidade mobile:** controles touch confiáveis, leitura em telas pequenas e desempenho adequado.

## 4. Escopo de conteúdo desejado
- História com começo, desenvolvimento, clímax e conclusão.
- Sete mundos, cada um com fragmento e chefe guardião.
- Pelo menos cinco arquétipos de inimigos realmente distintos por mundo como meta mínima; recolorações não contam como arquétipos.
- NPCs com função narrativa ou de gameplay.
- Tutorial integrado em desafios reais e graduais.
- Menus profissionais: título, pausa, configurações, seleção/progresso e resultados, conforme fluxo aprovado.
- Checkpoints, segredos, recompensas opcionais e salvamento confiável.
- Cutscenes com função narrativa, opção de pular e replay quando apropriado.
- Acessibilidade básica: áudio, legibilidade, remapeamento quando suportado e redução de efeitos intensos.

## 5. Limites
- Não criar versão de navegador como alvo do produto.
- Não migrar de engine sem aprovação explícita.
- Não inventar nomes, diálogos, personagens, mundos ou reviravoltas como canon.
- Não otimizar por intuição sem perfil, medição ou reprodução.
- Não sacrificar responsividade touch ou legibilidade por efeitos visuais.
- Não adicionar sistemas complexos sem justificativa de experiência e manutenção.

## 6. Métricas de qualidade
| Área | Evidência esperada |
|---|---|
| Controle | Ações essenciais registradas, inclusive em multitouch |
| Movimento | Física previsível, estados sem travamento |
| Leitura | Ameaças, plataformas, pickups e objetivos distinguíveis |
| Progressão | Mecânicas ensinadas antes de combinações avançadas |
| Narrativa | Cenas e diálogos coerentes com canon aprovado |
| Android | Testes reais ou limitações explicitamente registradas |
| Performance | Frame time, p95/p99, memória e aquecimento medidos |
| Robustez | Salvamento, retomada, pausa, perda de foco e transições |

## 7. Status
- Premissa robô + máquina temporal + sete fragmentos: **confirmado**.
- Android empacotado: **confirmado**.
- Godot: **direção confirmada**, versão exata **a detectar**.
- Meta de cinco inimigos distintos por mundo: **requisito de design**.
- Nomes e detalhes dos sete mundos: **a definir/recuperar da Bíblia aprovada**.
- Mecânicas finais, números de balanceamento e duração: **a definir**.
