# Roadmap de produção — BOLT · AVENTURA

Este roadmap define gates de qualidade, não datas. A ordem pode ser ajustada após auditoria do projeto real, mas nenhuma etapa deve ser declarada concluída sem evidência e aprovação exigida.

## Gate 0 — Auditoria e alinhamento
**Objetivo:** compreender o estado real do repositório e congelar o escopo inicial aprovado.

Entregáveis: inventário do repositório; engine/versão confirmadas; documentos canônicos identificados; riscos; arquitetura existente; lacunas de design; plano de validação.

Saída: auditoria, versão/renderer definidos ou decisão registrada, inconsistências documentais corrigidas e plano executável. **A implementação da fundação começa imediatamente após a auditoria; não aguardar uma nova autorização para tarefas já cobertas pelo escopo aprovado.**

## Gate 1 — Fundação técnica e vertical slice
**Objetivo:** provar o ciclo central em uma pequena fatia representativa.

Entregáveis: inicialização Android; cena jogável; personagem; movimento principal; controles touch; câmera; colisões; HUD mínimo; transição e carregamento; build instalável de teste.

Saída: vertical slice reproduzível, jogável e medido em pelo menos um dispositivo Android de referência quando disponível. Não extrapolar resultado para todos os aparelhos. Após validar, continuar automaticamente para os sistemas centrais; a vertical slice não é o produto final.

## Gate 2 — Sistemas centrais
**Objetivo:** consolidar sistemas reutilizáveis antes de multiplicar conteúdo.

Entregáveis: input; player controller; inimigos base; dano/vida se aprovados; interação; checkpoints; save/load; diálogo; áudio; UI; fluxo de cenas; testes.

Saída: contratos entre sistemas documentados e regressões essenciais automatizadas.

## Gate 3 — Produção dos sete mundos
**Objetivo:** produzir conteúdo com padrão consistente.

Cada mundo passa por conceito, blockout, validação de gameplay, arte/áudio, NPCs, pelo menos cinco arquétipos de inimigo distintos, chefe, fragmento, narrativa, QA e otimização. Usar canon já documentado; propostas provisórias podem avançar isoladas sem serem declaradas canon. Produzir seis fases por mundo e rastrear todas as 42.

Saída: cada mundo revisado individualmente; nenhum conteúdo placeholder apresentado como final.

## Gate 4 — Integração narrativa e polimento
**Objetivo:** fechar começo, meio e fim.

Entregáveis: cutscenes, diálogos finais, transições, feedback, animações, música, efeitos, opções de acessibilidade e correção de inconsistências.

Saída: campanha completa e revisada, com progressão e conclusão coerentes.

## Gate 5 — QA Android e release candidate
**Objetivo:** validar o produto em condições próximas às reais.

Entregáveis: matriz de aparelhos; sessões longas; regressão; save/load; interrupções; controles; barras do sistema; performance; memória; exportação; assinatura e checklist de release.

Saída: release candidate com riscos conhecidos, resultados anexados e aprovação explícita.

## Regra de avanço
Cada gate registra escopo, entregáveis, evidências, problemas conhecidos, riscos e decisão. Gates são controles internos de qualidade, não pontos de parada automática. Prosseguir para o próximo gate quando os critérios forem atendidos. Parar somente para bloqueio crítico, decisão material não coberta por canon/ADR, credencial/assinatura exclusiva do usuário ou risco destrutivo. Continuar tarefas independentes enquanto houver bloqueio.
