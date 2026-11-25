# BOLT · AVENTURA — MASTER DIRECTIVE
## Diretriz central de criação, produção e validação

**Função deste arquivo:** ponto de entrada obrigatório para Claude Code e qualquer agente que trabalhe no projeto. Ele conecta a visão do produto às bíblias de design, especificações técnicas, roadmap e QA. Não substitui os documentos especializados: determina como encontrá-los, interpretá-los, resolver conflitos e transformar requisitos em entregas verificáveis.

**Projeto:** BOLT · AVENTURA  
**Repositório:** `jyanzy19-yml/new-bolt-aventura`  
**Engine de direção:** Godot 4.x com GDScript — confirmar a versão real antes de usar APIs.  
**Produto-alvo:** aplicativo Android empacotado, em orientação paisagem.  
**Estado do projeto:** consultar sempre `docs/production/stage-status.md`; nunca presumir que documentação equivale a jogo implementado.

---

## 1. Missão

Desenvolver BOLT · AVENTURA como um jogo 2D de plataforma, ação e aventura com identidade própria, narrativa com começo, desenvolvimento, clímax e conclusão, gameplay responsivo, mundos distintos, fases bem construídas, personagens memoráveis, chefes justos, menus profissionais e desempenho adequado ao Android.

O objetivo não é apenas produzir documentos ou protótipos isolados. O objetivo final é um produto Android completo, integrado, jogável, testado e sustentável. Toda decisão de design deve poder ser traduzida em conteúdo implementável; toda implementação deve ter critérios de aceite; toda alegação de qualidade deve ter evidência.

### Resultados esperados
- Uma experiência narrativa coerente, com cenas, diálogos, NPCs e consequências.
- Sete mundos distintos, com progressão e identidade próprias.
- Campanha planejada de 42 fases: seis por mundo, conforme a diretiva de design; validar a matriz detalhada antes de produzir conteúdo em escala.
- Chefes associados aos mundos e aos fragmentos da campanha.
- Plataforma precisa, combate legível, controles touch confiáveis e curva de aprendizagem justa.
- Menus, HUD, configurações, salvamento e progressão integrados.
- Aplicativo Android instalável, com testes reais e riscos documentados.

---

## 2. Hierarquia de autoridade e resolução de conflitos

Antes de criar ou alterar conteúdo, classifique cada informação:

- **CANON APROVADO:** confirmado explicitamente pelo usuário ou por decisão registrada.
- **REQUISITO:** condição obrigatória de produto, técnica ou qualidade.
- **PROPOSTA:** recomendação criativa/técnica ainda não aprovada.
- **A DEFINIR:** lacuna que não pode ser preenchida por suposição.
- **IMPLEMENTADO:** presente no projeto executável, inspecionado no código/cenas.
- **VALIDADO:** aprovado por teste reproduzível, com build, ambiente e evidência registrados.
- **DESCARTADO:** ideia rejeitada; não reintroduzir sem autorização.

### Ordem de precedência
1. Instrução explícita mais recente do usuário para a tarefa atual.
2. Decisão aprovada e registrada em `docs/decisions/`.
3. Canon confirmado nas bíblias de `docs/game-design/`.
4. Requisitos e especificações técnicas aprovados.
5. Este arquivo e os prompts mestres.
6. Propostas, rascunhos, exemplos e sugestões de agentes.

Se dois documentos de nível semelhante discordarem, **não escolha silenciosamente**. Registre o conflito, identifique os arquivos e trechos envolvidos, indique impacto e apresente uma recomendação. Peça decisão quando a escolha alterar canon, escopo, experiência ou arquitetura.

### Reconciliação documental concluída
A divergência entre o prompt mestre e as Bíblias narrativa, de mundos e personagens foi corrigida nesta revisão. O Grande Colapso, Núcleo da Eternidade, BOLT, NEXO, o Arquiteto, a sequência dos sete mundos, os sete fragmentos e os títulos descritivos dos guardiões estão consolidados nas bíblias correspondentes. Detalhes de caracterização, lore secundária, paletas, NPCs e mecânicas específicas que ainda não foram definidos permanecem propostas/pendências; não os transformar em canon sem aprovação.

Nunca transforme uma sugestão de Claude, agente, skill, ferramenta ou documento não aprovado em decisão do usuário.

---

## 3. Documentos de fonte de verdade

Leia `docs/README.md` para o índice completo. Para cada tarefa, consulte os documentos diretamente relacionados. A organização lógica é:

| Área mestra | Fonte principal no repositório | Responsabilidade |
|---|---|---|
| MASTER_DIRECTIVE | `/MASTER_DIRECTIVE.md` | Missão, precedência, fluxo de trabalho e gates |
| GAME_BIBLE | `docs/game-design/01-narrative-bible.md` | Premissa, arcos, canon, cenas, NPCs e questões narrativas |
| WORLD_AND_LEVEL_DESIGN | `docs/game-design/02-world-bible.md`, `05-level-design-standard.md` e prompt mestre | Mundos, fases, ritmo, desafios, chefes e critérios de fase |
| GAMEPLAY_SPECIFICATION | `docs/game-design/04-gameplay-systems.md` e `03-character-bible.md` | Movimento, combate, inimigos, chefes, habilidades e progressão |
| UI_UX_SPECIFICATION | `docs/game-design/06-ui-ux.md` | Menus, HUD, navegação, touch e acessibilidade |
| TECHNICAL_SPECIFICATION | `docs/technical/` | Godot, arquitetura, Android, input, loading, recursos e contratos |
| PRODUCTION_ROADMAP | `docs/production/roadmap.md`, `stage-status.md` e `change-management.md` | Gates, sequência, estado e controle de mudanças |
| QA_AND_ACCEPTANCE | `docs/qa/test-matrix.md`, `docs/production/definition-of-done.md` | Testes, evidências, severidade e critérios de conclusão |

Documentos especializados existentes devem ser reutilizados e aprimorados; não criar cópias concorrentes com o mesmo conteúdo. Se um novo documento for realmente necessário, atualize o índice e declare sua relação com a fonte existente.

### Leitura mínima por tipo de tarefa
- História/cutscene/diálogo: narrativa, personagens, mundo e decisões.
- Mundo/fase/chefe/inimigo: mundo, personagens, padrão de level design, gameplay e QA.
- Movimento/combate/controles: gameplay, contratos técnicos, touch/display, performance e QA.
- Menu/HUD: UI/UX, touch/display, arquitetura e QA.
- Android/loading/performance: todos os documentos técnicos pertinentes, roadmap e matriz de testes.
- Release: checklist Android, Definition of Done, QA, status e validação.

---

## 4. Identidade do produto e plataforma

- Nome: **BOLT · AVENTURA**.
- Gênero: plataforma, ação e aventura 2D.
- Engine: Godot 4.x; a versão efetiva é a detectada no projeto.
- Linguagem: GDScript.
- Destino: aplicativo Android empacotado. Não redirecionar o escopo para navegador ou jogo web.
- Orientação: paisagem.
- Hardware de referência: aparelhos Android com cerca de 4 GB de RAM e MediaTek Helio G99 ou inferior.
- Meta de performance: 60 FPS quando o aparelho puder sustentar; não prometer resultado universal.
- Input: touch é caminho principal e precisa ser validado em aparelho real.
- Tela/barras Android: respeitar a decisão registrada em `docs/decisions/` e as limitações reais do Android. Não alterar modo imersivo, barras ou opção de tela cheia sem aprovação.

Preservar comportamento, física, controles, arte, áudio, conteúdo e salvamento já aprovados. Otimização não autoriza simplificar o jogo ou mudar sua sensação.

---

## 5. Narrativa e direção criativa

A experiência precisa contar uma história completa. Cada mundo deve acrescentar algo ao arco maior, apresentar identidade própria e produzir uma mudança perceptível na jornada. NPCs não devem existir apenas como decoração; cutscenes não devem interromper o jogo sem função; diálogos devem revelar personalidade, contexto, conflito ou consequência.

Regras:
1. Manter continuidade temporal, espacial e emocional.
2. Diferenciar o que o jogador sabe, o que cada personagem sabe e o que permanece misterioso.
3. Usar IDs estáveis para cenas, diálogos, personagens, eventos e flags.
4. Toda cutscene deve ter objetivo dramático, encenação, duração, transições, legendas, opção de pular e comportamento determinístico das flags.
5. Toda conversa deve ter função narrativa ou de gameplay.
6. Não preencher lacunas do canon com invenções apresentadas como fatos.
7. Planejar começo, desenvolvimento, clímax, resolução e epílogo.
8. A história deve ser compreensível mesmo quando o jogador pula cenas opcionais; detalhes extras podem enriquecer a exploração.

A bíblia narrativa e o registro de decisões são as fontes para nomes, motivações, revelações e final.

---

## 6. Mundos, fases e level design

A campanha tem sete mundos e uma meta de 42 fases, seis por mundo. A sexta fase de cada mundo é planejada como conclusão de arco com confronto de guardião/chefe e progressão do fragmento, respeitando o canon aprovado e a matriz definitiva.

Cada mundo precisa de:
- Fantasia central, tema e emoção dominante.
- Linguagem visual e sonora reconhecível.
- Mecânica ou vocabulário de gameplay próprio.
- NPCs com propósito e função.
- Meta mínima de cinco arquétipos de inimigos realmente distintos, não apenas recolorações.
- Obstáculos, perigos, plataformas, encontros e segredos.
- Curva ensinar → praticar → combinar → dominar.
- Checkpoints e rota principal sem softlock.
- Chefe com telegraphs legíveis, padrões justos e contra-jogo compreensível.
- Fragmento/recompensa com significado e consequência.
- Transição coerente para o próximo arco.

### Padrão para cada fase
Antes de construir uma fase, documentar:
- ID estável, mundo, posição na campanha e status.
- Objetivo principal e objetivos opcionais.
- Resumo narrativo e evento de entrada/saída.
- Layout e fluxo de navegação.
- Mecânica ensinada, praticada ou testada.
- Inimigos, perigos, plataformas e encontros.
- Checkpoint, segredo, colecionáveis e recompensas.
- Curva de dificuldade e acessibilidade.
- Dependências de habilidades/itens.
- Critérios de conclusão e QA.
- Orçamento de recursos e riscos de performance.

Não produzir 42 fases genéricas. Cada fase deve ter propósito, ritmo, variação e uma razão clara para existir.

---

## 7. Gameplay, combate e progressão

O gameplay deve ser responsivo, previsível, legível e satisfatório em touch. Consultar `docs/game-design/04-gameplay-systems.md` antes de alterar qualquer regra.

### Movimento
Especificar e testar aceleração, desaceleração, velocidade, controle aéreo, salto, altura variável quando aprovada, pulo duplo se aprovado, buffer, coyote time, dash, wall slide/jump quando aprovados, colisões, aterrissagem, knockback, invulnerabilidade e transições de estado.

Cada habilidade precisa de regras explícitas de início, duração, interrupção, cancelamento, recarga, prioridade e término. Não mudar valores ou física por intuição: medir e registrar.

### Combate
Armas, habilidades e inimigos devem ter propósito distinto. Cada ação de combate precisa de feedback audiovisual, limites claros, alcance, recarga/custo, compatibilidade touch e papel de balanceamento. Inimigos precisam de silhueta, comportamento, telegraph, contra-jogo e variações funcionais.

### Tutorial
Ensinar uma ideia principal por vez: demonstrar, permitir prática segura, confirmar domínio e depois combinar com habilidades anteriores. Não ensinar apenas por texto uma ação que depende de timing ou coordenação. Deve ser possível repetir instruções sem bloquear a campanha.

### Progressão
Definir desbloqueios, moedas, itens, melhorias, skins, conquistas, segredos, inventário e dificuldades apenas conforme canon/requisitos aprovados. Persistência, custo, impacto no balanceamento e comunicação ao jogador devem ser especificados. Nenhum item opcional pode causar softlock.

---

## 8. Menus, HUD e UX

O produto deve ter fluxos consistentes e completos:
- Inicialização/carregamento.
- Menu principal.
- Novo jogo/continuar.
- Seleção de mundo/fase quando aprovada.
- HUD.
- Pausa e retomada.
- Configurações.
- Inventário/arsenal/habilidades quando aplicáveis.
- Diálogos/interações.
- Resultados, vitória/derrota e créditos.
- Salvamento e recuperação.

Para cada tela, documentar propósito, hierarquia visual, foco inicial, ação principal, ações secundárias, navegação, retorno/cancelamento, estados vazios/erro, feedback, persistência e comportamento em diferentes proporções.

Regras de interface:
- Priorizar legibilidade e alvos touch confortáveis.
- Não encobrir perigos ou informação essencial.
- Testar multitouch e estados normal/pressionado/desabilitado.
- Respeitar safe areas, recortes, barras e gestos Android.
- Suportar legendas e opções de áudio; considerar redução de flashes/tremor e contraste.
- Não usar somente cor para comunicar estado.
- Manter o HUD limpo e contextual.

---

## 9. Arquitetura e engenharia Godot

Antes de implementar, verificar se o repositório contém o projeto executável:
1. Localizar `project.godot`.
2. Detectar versão, renderer, resolução, orientação, configurações de input e exportação Android.
3. Inventariar cenas, scripts, recursos, plugins, addons e presets.
4. Identificar o que está implementado, incompleto, ausente ou quebrado.
5. Ler as skills técnicas mínimas relevantes e conferir compatibilidade com a versão real.

Princípios:
- Separar responsabilidades de input, movimento, combate, IA, UI, narrativa, progressão, save, áudio e fluxo de cenas.
- Preferir composição, cenas coesas, recursos de dados reutilizáveis e contratos explícitos.
- Evitar monólitos e também fragmentação excessiva.
- Evitar dependências circulares e autoloads sem responsabilidade clara.
- Usar IDs estáveis e fonte única de verdade para estados persistentes.
- Não adicionar dependências sem justificativa, compatibilidade e avaliação de licença.
- Não substituir arquitetura ou engine sem aprovação.

---

## 10. Android, input e performance

Prioridades técnicas:
1. Salto, dash e ações essenciais devem responder consistentemente.
2. Multitouch deve suportar combinações simultâneas válidas.
3. Eventos de toque devem ser limpos em pausa, troca de cena, perda de foco e retomada.
4. Física não deve depender indevidamente da taxa de renderização.
5. Quedas de FPS não devem produzir aceleração/câmera lenta descontrolada.
6. Pré-carregar recursos e fazer loading entre fases quando isso reduzir stutter real.
7. Evitar alocações excessivas, picos de GC, overdraw, partículas desnecessárias e vazamentos.
8. Gerenciar memória de texturas, áudio, cenas e recursos.
9. Testar sessão prolongada e aquecimento.
10. Medir antes/depois em aparelhos identificados.

Não inserir espera artificial para fazer uma tela de loading durar mais. A tela deve refletir trabalho real, ter estados de progresso/erro e impedir interação prematura.

Registrar frame time médio, p95/p99, picos, memória inicial/final/pico, build, commit, aparelho, versão Android, resolução, duração e condições térmicas. Headless/editor não substitui teste visual e touch no dispositivo.

---

## 11. Save, checkpoints e integridade

Separar estado transitório de estado persistente. Documentar o que é salvo em checkpoint e campanha, incluindo progresso, fragmentos, desbloqueios, itens, moedas, configurações e posição de retomada conforme escopo aprovado.

Exigir:
- Versão do formato de save.
- Validação de dados e tratamento de corrupção.
- Escrita segura para evitar sobrescrever save válido com dados parciais.
- Estratégia de migração entre versões.
- Testes de interrupção, fechamento forçado, retomada e atualização.
- Consistência entre flags narrativas, mundo/fase e inventário.

---

## 12. Roadmap e gates de produção

Seguir `docs/production/roadmap.md`; a ordem pode ser ajustada com justificativa, mas não se pula gate bloqueado.

- **Gate 0 — Auditoria:** inventário, engine/versão, canon, arquitetura, riscos e lacunas.
- **Gate 1 — Vertical slice:** provar o ciclo jogável em Android com movimento, touch, câmera, colisões, HUD, transição e medição.
- **Gate 2 — Sistemas centrais:** consolidar input, player, inimigos, combate, save, UI, áudio e fluxo de cenas.
- **Gate 3 — Mundos:** produzir e validar cada mundo individualmente.
- **Gate 4 — Integração e polimento:** fechar narrativa, cutscenes, diálogos, áudio, feedback, progressão e acessibilidade.
- **Gate 5 — QA e release candidate:** regressão, aparelhos, sessão prolongada, exportação e riscos residuais.

Cada gate deve conter escopo, entregáveis, evidências, problemas, riscos, decisão e responsável. Não declarar etapa concluída sem critérios de aceite.

---

## 13. QA e Definition of Done

Usar a matriz de `docs/qa/test-matrix.md` e `docs/production/definition-of-done.md`. Testar, conforme a alteração:
- Movimento, colisões, pulo, dash e transições.
- Multitouch e input sob stutter, pausa e perda de foco.
- Inimigos, chefes, telegraphs, arenas e estados.
- Rotas, checkpoints, segredos, fragmentos e softlocks.
- Menus, HUD, navegação, safe areas e proporções.
- Cutscenes, diálogos, flags e replay/pulo.
- Save/load, corrupção e migração.
- Loading, memória, performance e sessão prolongada.
- Instalação, suspensão/retomada e exportação Android.

Todo relatório deve identificar build/commit, ambiente, passos, resultado esperado/obtido, evidência e limitações. Classificar bugs por severidade. Não marcar teste não executado como aprovado.

---

## 14. Fluxo obrigatório de trabalho para Claude

Para cada solicitação:
1. **Entender:** resumir o objetivo e limites da tarefa.
2. **Inspecionar:** ler arquivos relevantes e verificar estado real do projeto.
3. **Classificar:** separar canon, requisitos, propostas, pendências, implementado e validado.
4. **Planejar:** listar escopo, dependências, arquivos, riscos e critérios de aceite.
5. **Aprovar:** solicitar autorização antes de mudanças materiais de canon, escopo, arquitetura, plataforma, controles ou experiência.
6. **Executar:** fazer mudanças pequenas, coesas e rastreáveis.
7. **Testar:** executar verificações proporcionais e registrar resultados reais.
8. **Revisar:** procurar regressões e contradições nos documentos relacionados.
9. **Documentar:** atualizar índice, decisões, status e evidências.
10. **Reportar:** informar o que mudou, o que não mudou, testes, limitações, riscos e próximos passos.

Não modificar arquivos fora do escopo sem explicar e justificar. Não publicar releases, alterar visibilidade, acessar segredos ou executar ações destrutivas sem solicitação explícita.

---

## 15. Critério de conclusão do produto

BOLT · AVENTURA só pode ser declarado completo quando:
- O início, desenvolvimento, clímax e final estiverem integrados e coerentes.
- Os sete mundos e as 42 fases planejadas estiverem implementados, conectados e concluíveis.
- Os inimigos e chefes cumprirem os requisitos de variedade e qualidade de cada mundo.
- Tutorial, cutscenes, NPCs, diálogos e fragmentos funcionarem.
- Movimento, combate, habilidades e controles touch estiverem responsivos e balanceados.
- Menus, HUD, configurações, progressão e salvamento estiverem completos.
- O aplicativo Android estiver exportado e instalável.
- QA funcional, regressão, save e Android estiver documentado.
- Performance e limitações estiverem medidas em aparelhos identificados.
- Não houver bugs blocker/critical conhecidos sem decisão explícita de release.
- O estado final estiver registrado com evidências e aprovação exigida.

**Regra final:** criar um jogo memorável, não apenas um conjunto de funcionalidades. Cada mundo deve ter personalidade; cada fase, propósito; cada habilidade, utilidade; cada chefe, leitura justa; cada menu, função clara; e cada revelação, consequência. Preservar o canon, respeitar decisões, medir o que for técnico e nunca confundir plano, código e validação.

## 16. Mandato explícito: criar o jogo do zero

A missão de produção é **criar BOLT · AVENTURA integralmente do zero como jogo Godot 4.x funcional e exportável para Android**. O repositório é atualmente um ecossistema documental; não presumir que exista `project.godot`, cenas ou gameplay implementados. A documentação especifica o produto; somente arquivos Godot executáveis constituem implementação.

A diretiva operacional obrigatória está em [docs/production/from-zero-implementation-directive.md](docs/production/from-zero-implementation-directive.md). Claude deve lê-la integralmente e executá-la. Criar projeto, cenas, scripts, Resources, dados, assets licenciados, UI, sistemas, testes e configuração Android. Não parar após auditoria, planejamento, arquitetura ou vertical slice: esses são gates internos e o trabalho deve prosseguir até a campanha completa, respeitando bloqueios materiais e aprovações de canon.

A autorização cobre a implementação do escopo já documentado, não autoriza alterar canon, engine, plataforma, controles ou decisões aprovadas. Lacunas devem ser isoladas como propostas provisórias e não podem bloquear trabalho independente. A execução deve distinguir claramente implementado, testado e validado em dispositivo real. Nunca declarar APK, FPS ou compatibilidade sem evidência.

### 16.1 Sequência mínima de produção
1. Descobrir estado real e fixar versão Godot 4.x compatível.
2. Criar projeto executável e fundação Android.
3. Implementar vertical slice representativa e validá-la.
4. Consolidar sistemas reutilizáveis e contratos.
5. Produzir os sete mundos e 42 fases com conteúdo distinto.
6. Integrar narrativa, arte, áudio, menus, saves e progressão.
7. Executar QA, otimização, exportação e checklist Android.

### 16.2 Regra de continuidade
Não solicitar autorização para tarefas normais dentro do escopo. Solicitar decisão somente quando houver mudança material não coberta por canon/ADR, credencial/assinatura exclusiva do usuário, risco destrutivo ou bloqueio externo real. Continuar trabalho independente durante bloqueios. Ao encerrar uma sessão, registrar arquivos alterados, testes, estado real e próximo passo executável.


---

## 17. Protocolo de qualidade, rastreamento e continuidade

Aplicar obrigatoriamente `docs/production/quality-control-protocol.md` em toda mudança substancial. O protocolo define inspeção prévia, implementação incremental, revisão de diff, regressão, severidade e níveis de validação L0–L5. Não confundir inspeção documental, análise estática, teste Godot/headless, observação em emulador e validação em aparelho Android físico.

Manter `docs/production/implementation-tracker.md` atualizado com evidência do branch atual. O tracker contém 24 sistemas globais e IDs para as 42 fases planejadas; nenhuma fase pode ser declarada implementada apenas pela existência de uma cena vazia. O status deve ser Não iniciado, Em andamento, Implementado, Validado, Bloqueado ou Não aplicável, conforme critérios do documento.

Antes de encerrar cada sessão substancial, atualizar `docs/production/CONTINUITY.md` com commit, arquivos alterados, testes realmente executados, nível de validação, bugs abertos, bloqueios e próxima ação exata. Ao retomar, inspecionar Git e arquivos reais primeiro; o estado do repositório prevalece sobre qualquer handoff antigo.

Comandos auxiliares: `/bolt-continue` retoma o trabalho sem depender da memória do chat; `/bolt-release-check` verifica prontidão sem publicar, assinar ou liberar builds. São prompts de fluxo, não evidência de que verificações foram executadas.

**Regra de qualidade:** nunca esconder falhas, inventar resultados, marcar teste não executado como aprovado, sacrificar controles touch ou alterar canon/ADRs para acelerar. Corrigir S0/S1 antes de aprovar o gate afetado; registrar riscos residuais de S2 antes de qualquer release.
