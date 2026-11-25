# Protocolo de qualidade e prevenção de regressões — BOLT · AVENTURA

**Status:** obrigatório para implementação e revisão.  
**Escopo:** documentação, código, cenas, dados, assets, builds e release.  
**Autoridade:** subordinado à hierarquia de decisões de MASTER_DIRECTIVE.md.

## 1. Objetivo

Transformar requisitos em entregas verificáveis e reduzir retrabalho, regressões, falsa conclusão e perda de contexto. Este protocolo não promete ausência de erros; exige detecção precoce, correção rastreável e comunicação honesta.

## 2. Regras inegociáveis

1. **Inspecionar antes de editar.** Verificar branch, arquivos, histórico recente e dependências afetadas.
2. **Preservar o que funciona.** Não substituir implementação funcional por placeholder, stub, mock ou versão simplificada para aparentar progresso.
3. **Uma fonte de verdade.** Não duplicar regras de gameplay, estado persistente, canon ou configuração em múltiplos lugares sem contrato explícito.
4. **Mudanças pequenas e rastreáveis.** Separar refatoração, conteúdo e correção quando forem independentes.
5. **Provar antes de declarar.** Toda afirmação de conclusão aponta para arquivo, teste, build ou evidência observável.
6. **Não esconder falhas.** Registrar testes falhos, ignorados, bloqueados e não executados.
7. **Não inventar aprovação.** Propostas criativas continuam propostas até aprovação explícita.
8. **Não otimizar por palpite.** Medir antes/depois e preservar sensação, física, controles, arte e áudio aprovados.
9. **Não expandir escopo silenciosamente.** Tarefas normais já autorizadas avançam sem pedir confirmação; decisões materiais fora do canon/ADRs, credenciais exclusivas, ações destrutivas ou bloqueios reais exigem consulta.
10. **Continuar com segurança.** Um bloqueio localizado não deve paralisar tarefas independentes e reversíveis.

## 3. Ciclo obrigatório de cada mudança

### Antes
- Identificar requisito e fonte documental.
- Ler código, cenas, dados relacionados e consumidores.
- Registrar objetivo, escopo, dependências, risco e critério de aceite.
- Identificar dados persistentes, sinais, autoloads, recursos compartilhados e fluxos de cena afetados.
- Definir teste de regressão mínimo.

### Durante
- Implementar a menor mudança coerente.
- Manter nomes, IDs e contratos estáveis quando possível.
- Evitar caminhos frágeis, referências mágicas, estado duplicado e dependências circulares.
- Tratar falhas de carregamento, ausência de recursos, interrupção, cancelamento e estados inválidos.
- Não adicionar dependências externas sem necessidade, licença e impacto avaliados.

### Depois
- Revisar diff completo e arquivos não intencionais.
- Executar verificações estáticas, importação/headless, testes unitários/integrados e testes manuais aplicáveis.
- Verificar links, referências de recursos, IDs, sinais e transições afetadas.
- Executar regressões direcionadas.
- Atualizar tracker, continuidade e decisões quando aplicável.
- Registrar commit, evidências, limitações e próximo passo.

## 4. Níveis de validação — não confundir

| Nível | O que comprova | O que não comprova |
|---|---|---|
| L0 — inspeção | Arquivos e estrutura presentes | Que o projeto abre |
| L1 — estático | Formato, referências e regras verificáveis | Comportamento em runtime |
| L2 — Godot/headless | Importação, parse e testes executados no engine | Renderização, toque físico ou performance real |
| L3 — editor/emulador | Fluxos observados no ambiente testado | Compatibilidade universal |
| L4 — Android físico | Comportamento no aparelho identificado | Desempenho em todos os aparelhos |
| L5 — sessão prolongada | Estabilidade durante duração/condições registradas | Ausência absoluta de falhas futuras |

Sempre informar o nível alcançado. Um teste headless não pode ser descrito como teste Android físico.

## 5. Critérios por domínio

### Projeto e arquitetura
- Projeto abre na versão Godot registrada.
- Nenhuma referência quebrada, dependência circular ou erro de parse conhecido.
- Ownership e ciclo de vida de Nodes/Resources claros.
- Autoloads limitados a serviços realmente globais.
- Sinais desconectados e recursos liberados quando apropriado.
- Dados de conteúdo separados de lógica quando isso reduzir acoplamento.

### Movimento e input
- Movimento, salto, dash, colisões, aterrissagem, estados e câmera testados.
- Multitouch movimento + salto + dash funciona em ordens variadas.
- Pressionar/soltar rapidamente, arrastar para fora do botão, pausar, trocar cena e retomar não deixam input preso.
- Buffering e consumo no tick de física são testados sob frame-time elevado.
- UI não altera física diretamente.

### Combate, inimigos e chefes
- Hitboxes/hurtboxes, invulnerabilidade, dano, knockback, cooldowns e feedback consistentes.
- Telegráficos legíveis em tela pequena.
- Inimigos têm comportamento e contra-jogo distintos, não apenas atributos alterados.
- Chefes podem ser vencidos, reiniciados e concluídos sem softlock.
- Limites de entidades/efeitos e desempenho são medidos em encontros densos.

### Fases e progressão
- Rota principal concluível; sem softlock.
- Checkpoints, respawn, fragmentos, objetivos, desbloqueios e transições preservam estado correto.
- Segredos e conteúdo opcional não bloqueiam a campanha.
- Save/load, encerramento inesperado e migração são testados.
- Cada fase tem identidade, objetivo, curva de dificuldade, conteúdo e critério de conclusão próprios.

### UI, narrativa e áudio
- Toda ação visível funciona ou está claramente indisponível por decisão registrada.
- Foco, navegação, toque, safe areas, escalas e estados de erro testados.
- Pular cutscene aplica os mesmos efeitos persistentes obrigatórios que assisti-la.
- IDs de diálogos/eventos/flags são estáveis.
- Mixagem, mute, interrupção e retomada mantêm estado coerente.

### Android e performance
- Registrar modelo, SoC/GPU, RAM, Android, resolução, versão Godot, renderer e build.
- Medir frame time, p95/p99, picos, memória inicial/final/pico e duração.
- Comparar a mesma cena, sequência e condições antes/depois.
- Testar sessão aquecida, troca de app, suspensão/retomada e interrupções.
- Não declarar 60 FPS sustentados sem evidência prolongada no aparelho citado.
- Não alterar política de barras, orientação ou controles sem autorização.

## 6. Severidade e política de bloqueio

- **S0 — Blocker:** não inicia, perda irrecuperável de progresso, campanha impossível de concluir.
- **S1 — Critical:** crash recorrente, softlock, save corrompido, input essencial inutilizável.
- **S2 — Major:** sistema importante falha com workaround limitado.
- **S3 — Minor:** falha localizada sem bloquear fluxo principal.
- **S4 — Cosmetic:** apresentação sem impacto funcional.

S0/S1 impedem declarar o gate correspondente aprovado. S2 exige plano e decisão explícita sobre risco residual antes de release. S3/S4 podem ser priorizados sem interromper trabalho independente.

## 7. Política de conclusão

- **Não iniciada:** nenhuma implementação executável identificada.
- **Em andamento:** implementação parcial.
- **Implementada:** funcionalidade existe no projeto, mas a validação aplicável não foi concluída.
- **Validada:** critérios aplicáveis passaram e evidências estão registradas.
- **Bloqueada:** dependência real impede avanço; bloqueio e responsável registrados.
- **Não aplicável:** justificativa documentada e aprovada.

"Arquivo criado", "código escrito", "cena abre" e "feature validada" são estados diferentes.

## 8. Evidências mínimas de entrega

Toda entrega substancial registra commit/branch, requisito e arquivos afetados, comportamento esperado, testes realmente executados, resultado e nível L0–L5, ambiente/aparelho quando aplicável, evidências reproduzíveis, testes não executados e motivo, bugs conhecidos/severidade, riscos residuais e próximo gate.

## 9. Regra final

Não sacrificar qualidade essencial para cumprir prazo artificial. Otimizar o processo eliminando retrabalho, duplicação e espera desnecessária — nunca omitindo testes ou declarando progresso que não existe.
