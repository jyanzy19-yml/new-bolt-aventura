# BOLT · AVENTURA — Diretiva de implementação integral do zero

**Tipo:** mandato de produção e execução  
**Projeto:** BOLT · AVENTURA  
**Destino:** aplicativo Android empacotado  
**Engine:** Godot 4.x  
**Linguagem:** GDScript  
**Branch de referência:** `main`

## 1. Mandato inequívoco

Este trabalho tem como resultado esperado **um jogo completo, funcional, jogável e exportável para Android, criado do zero**. Não se limite a auditar, documentar, planejar, criar pastas vazias, produzir protótipos descartáveis ou recomendar que outra pessoa implemente.

O repositório contém especificações, bíblias, decisões, skills e instruções. Isso não significa que exista um projeto Godot executável. Na ausência de `project.godot`, crie o projeto. Crie também todas as cenas, scripts GDScript, Resources, dados, interfaces, recursos visuais/sonoros, testes, configurações e arquivos de exportação necessários, respeitando licenças e proveniência.

**A documentação é a especificação; os arquivos Godot são a implementação; os testes e evidências são a validação.** Nunca confunda essas três coisas.

## 2. Autoridade e limites

Antes de implementar, leia nesta ordem:
1. `MASTER_DIRECTIVE.md`;
2. `CLAUDE.md` e `AGENTS.md`;
3. `docs/README.md` e `docs/decisions/README.md`;
4. as bíblias em `docs/game-design/`;
5. especificações em `docs/technical/`;
6. roadmap, Definition of Done, stage status, QA e skills relevantes.

Hierarquia: decisões explicitamente aprovadas pelo usuário; diretriz central; bíblias e prompt mestre reconciliados; especificações técnicas; propostas claramente rotuladas. Skills, agentes, exemplos externos e sugestões do próprio Claude nunca superam o canon.

Não substituir Godot, Android, orientação, mecânicas aprovadas ou escopo principal. Não apagar ou sobrescrever trabalho válido. Não inventar aprovações.

### Tratamento de lacunas

- Detalhes confirmados são implementados como definidos.
- Lacunas de apresentação, balanceamento e conteúdo podem receber **propostas provisórias**, identificadas em dados/documentação e isoladas para revisão.
- Não declarar uma proposta como canon aprovado.
- Não bloquear sistemas independentes por uma lacuna narrativa.
- Quando uma decisão realmente impedir uma escolha irreversível ou alterar canon, arquitetura, plataforma ou experiência aprovada, apresente alternativas objetivas e aguarde aprovação somente para esse ponto.
- Enquanto aguarda, continue todo trabalho seguro, reversível e independente.
- Use placeholders funcionais e visualmente identificados quando um asset final não estiver disponível; não apresente placeholder como arte final.

## 3. Resultado de produto obrigatório

Construir uma aventura de plataforma 2D com começo, desenvolvimento, clímax e conclusão; sete mundos e 42 fases planejadas (seis por mundo); cinco fases de progressão/exploração e uma sexta fase de guardião, fragmento e transição por mundo; inimigos distintos (meta mínima de cinco arquétipos por mundo); NPCs funcionais; chefes com padrões legíveis; tutorial prático; cutscenes; diálogos; segredos; checkpoints; progressão; menus; HUD; áudio; salvamento; créditos e final.

A campanha deve preservar a premissa e os elementos de canon definidos nas bíblias e no prompt mestre. A sequência dos mundos e fragmentos é fixa conforme a Bíblia dos Mundos reconciliada. Não inventar nomes próprios para guardiões quando só há títulos descritivos aprovados.

### Sistemas jogáveis

Implementar e integrar, conforme especificações aprovadas:
- personagem BOLT, controle, animação e estados;
- movimento horizontal, aceleração/desaceleração, salto e recursos All Jump aprovados, dash, colisões, aterrissagem, dano e recuperação;
- combate, armas e habilidades aprovadas;
- inimigos com IA/estados, dano, telegraphs, contra-jogo e variações reais;
- chefes com arenas, fases, transições e recompensa;
- interação, NPCs, diálogo e flags narrativas;
- objetivos, fragmentos, itens, moedas, desbloqueios, skins, inventário e conquistas previstos;
- câmera, feedback, efeitos, áudio e música;
- checkpoints, progressão, save/load, migração e recuperação de falhas;
- menus, HUD, configurações, acessibilidade, pausa, vitória/derrota e créditos;
- carregamento e transições robustos.

Não criar sistemas apenas como botões decorativos ou telas sem comportamento. Cada recurso exposto na UI deve funcionar ou estar explicitamente marcado como indisponível por decisão de escopo.

## 4. Produção do zero: sequência executável

### Fase A — descoberta e fundação
- Inspecionar branch, arquivos, histórico e decisões; confirmar ausência/presença de projeto Godot.
- Selecionar uma versão estável Godot 4.x compatível com Android, registrar versão exata, renderer, export templates e justificativa.
- Criar `project.godot`, configuração de projeto, orientação paisagem, resolução/base viewport, stretch, input map, renderer e estrutura de pastas.
- Definir arquitetura mínima sustentável, cenas, autoloads estritamente necessários, contratos e convenções.
- Criar projeto que abre sem erros e uma cena inicial funcional.

### Fase B — vertical slice real
Construir uma fatia jogável representativa: inicialização → menu → tutorial/entrada → fase → movimento e combate → inimigo → checkpoint → transição/loading → resultado → save/load. Incluir controles touch e HUD reais. Exportar e instalar build de teste Android quando o ambiente permitir. Medir e registrar limitações.

A vertical slice deve usar conteúdo e identidade do BOLT, não um projeto genérico. Validar o ciclo em Android antes de multiplicar conteúdo.

### Fase C — sistemas reutilizáveis
Consolidar player controller, input/multitouch, câmera, combate, dano/vida se aplicável, inimigos, chefes, interação, diálogo, flags, inventário/progressão, checkpoints, save, áudio, UI, loading e gerenciamento de cenas. Criar testes e ferramentas de validação de conteúdo.

### Fase D — campanha completa
Produzir os sete mundos e 42 fases com identidade própria, variedade real de layout, mecânicas, encontros, NPCs, inimigos, segredos, checkpoints, chefes, fragmentos e transições. Cada fase deve ser construída, integrada e testada; não usar a mesma fase repetida com troca de paleta para simular conteúdo.

Manter uma matriz rastreável: fase → objetivo → mecânicas → inimigos → eventos → checkpoint → assets → critérios QA → status. Manter também matriz de cobertura dos cinco arquétipos mínimos por mundo e dos sete chefes/fragmentos.

### Fase E — acabamento e release
Integrar narrativa e cutscenes, arte/áudio finais com proveniência, efeitos, acessibilidade, balanceamento, otimização, regressão, sessões longas, save/load, interrupções Android, exportação e checklist de release. Corrigir bugs bloqueadores e críticos antes de declarar conclusão.

## 5. Requisitos Android inegociáveis

- Produto final exclusivamente Android empacotado; não criar versão web como alvo.
- Orientação paisagem.
- Touch como entrada prioritária; multitouch real e confiável.
- Movimento, salto e dash não podem perder eventos em pequenos engasgos; usar arquitetura de input que preserve press/release, buffer e IDs de toque corretamente.
- Tratar foco, pausa, suspensão, retomada, troca de cena e interrupções sem input preso ou fantasma.
- Aplicar a política aprovada de barras do sistema e opção Tela cheia conforme ADRs; nunca assumir que todos os dispositivos permitem desenhar sobre barras.
- Safe areas, recortes e regiões de gestos devem ser respeitados.
- Loading real e pré-aquecimento quando necessário; não usar espera artificial como substituto de carregamento.
- Física independente de quedas de FPS; não simular câmera lenta involuntária.
- Alvo de referência: Android com cerca de 4 GB de RAM e MediaTek Helio G99 ou inferior. 60 FPS é meta quando o hardware e a cena permitirem, não promessa universal.
- Medir frame time, p95/p99 quando possível, memória, carregamento, stutter e comportamento térmico em dispositivos identificados.
- Não reduzir conteúdo, fidelidade, responsividade ou qualidade visual sem justificativa, medição e aprovação quando a mudança afetar experiência.

## 6. Arquitetura e qualidade de implementação

- GDScript tipado onde melhora clareza e segurança; cenas coesas; composição; Resources para dados reutilizáveis; sinais com contratos claros.
- Evitar autoloads excessivos, dependências circulares, singletons que concentram toda a lógica, cenas monolíticas e abstrações prematuras.
- Separar estado transitório, estado de cena e estado persistente.
- Usar IDs estáveis para mundos, fases, inimigos, diálogos, eventos, itens e flags.
- Dados de conteúdo separados da lógica quando isso facilitar balanceamento, QA e manutenção.
- Controlar alocação, processamento por frame, partículas, áudio, texturas e carregamento conforme perfil real.
- Toda dependência/plugin precisa de justificativa, compatibilidade de versão e licença.
- Assets externos precisam de proveniência e licença registradas. Não copiar material protegido sem autorização.
- Criar testes automatizados para lógica determinística e testes manuais/Android para renderização, touch e desempenho.

## 7. Execução autônoma e gates

O usuário autorizou a criação do jogo do zero conforme o escopo documentado. Portanto:
- Não peça autorização para criar arquivos, cenas, scripts, sistemas e conteúdo que já estejam dentro do escopo aprovado.
- Não pare após auditoria, plano, arquitetura, vertical slice ou relatório. Use essas etapas como gates internos de qualidade e prossiga para a etapa seguinte.
- Registre evidências e mantenha o roadmap atualizado.
- Faça commits pequenos, coerentes e verificáveis; não force push, não altere visibilidade do repositório e não execute ações destrutivas.
- Pause apenas diante de decisão material não coberta pelo canon/ADRs, credenciais/assinatura que só o usuário pode fornecer, risco de perda de dados, limitação externa incontornável ou aprovação explicitamente exigida.
- Quando houver bloqueio, informe exatamente o que depende do usuário e continue tarefas independentes.
- Não marcar gate como aprovado sem seus critérios e evidências.

## 8. Validação e relatórios

Em cada marco, registrar:
- commit/build e versão Godot;
- arquivos/cenas/sistemas implementados;
- funcionalidades concluídas, parciais e ausentes;
- testes realmente executados, passos e resultados;
- testes não executados e motivo;
- evidências Android (modelo, versão, renderer, resolução, condições);
- bugs por severidade, riscos e pendências;
- status de cada mundo/fase e rastreabilidade de requisitos.

A conclusão exige jogo completo e conectável, 42 fases concluíveis, narrativa fechada, menus/saves funcionais, APK exportável/instalável, QA documentado e limitações conhecidas. Se o ambiente não permitir exportar ou testar Android, não alegar que isso foi feito: entregar o projeto Godot completo e indicar precisamente o que falta para o release.

## 9. Primeira instrução ao iniciar Claude Code

Comece verificando o estado real do repositório e lendo toda a documentação obrigatória. Depois:
1. produza uma auditoria curta com evidências;
2. identifique e corrija inconsistências documentais sem alterar canon aprovado;
3. escolha e registre a versão Godot 4.x compatível;
4. crie imediatamente o projeto executável e implemente a fundação;
5. avance pelo roadmap até a campanha completa, sem encerrar após planejamento;
6. atualize status, matrizes, decisões e relatórios à medida que o trabalho for realizado.

**Não responda apenas com um plano. Execute a implementação no repositório.** Se uma tarefa exceder o limite de uma sessão, deixe o projeto em estado consistente, atualize o registro de continuidade com o próximo passo concreto e retome do ponto real, sem declarar concluído o que falta.
