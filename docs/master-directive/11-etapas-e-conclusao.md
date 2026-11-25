# Parte 11 — Etapas, vertical slice e conclusão

## 31. Etapas de produção

A ordem respeita dependências, mas não exige aprovações intermediárias para tarefas já especificadas.

0. **Auditoria e planejamento:** inspecionar repositório/ferramentas, estado real, riscos, dependências, arquitetura e documentação. Depois avançar automaticamente.
1. **Bíblia narrativa e conceito:** história, personagens, personalidades, conflitos, revelações, cinematografia e identidade visual.
2. **Blueprint dos sete mundos:** 7 universos, 42 fases, objetivos, ambientes, ecossistemas, inimigos, chefes, rotas, segredos, desafios e progressão.
3. **Arquitetura Godot:** projeto, cenas, scripts, Resources, Autoloads, loading, save e dados.
4. **Bolt e All Jump:** movimento, física, pulos, animações, colisões e touchscreen.
5. **Combate e armas:** Pistola, Tríplice, Laser, projéteis, dano, feedback e balanceamento.
6. **Inimigos e chefes:** IA, comportamentos, animações, ataques, padrões e arenas.
7. **Exploração e segredos:** rotas, baús, itens, áreas secretas, NPCs e interações.
8. **Menus, HUD, cinemáticas e tutorial:** fluxo, telas, configurações, interface, cenas e tutorial.
9. **Progressão e salvamento:** fragmentos, skins, melhorias, desbloqueios, conquistas, checkpoints e save.
10. **Produção visual:** personagens, tilesets, cenários, animações, efeitos, interface e áudio.
11. **Primeiro mundo completo:** Cybercore como vertical slice.
12. **Expansão dos outros seis mundos:** implementar universos, fases, inimigos, chefes e conteúdos.
13. **Otimização Android:** performance, memória, loading, controles, compatibilidade e temperatura.
14. **QA integral:** testar 42 fases, corrigir, validar progressão, saves, Android e registrar evidências.
15. **Polimento e lançamento:** áudio, animações, UI, otimização, APK, preparação RELEASE e documentação final.

Não parar após planejamento, arquitetura ou primeiro mundo.

## 32. Vertical slice obrigatório — Cybercore

Antes de produzir os sete mundos completos, desenvolver Cybercore como demonstração integral da arquitetura e qualidade. Deve conter: entrada, menu principal, introdução, tutorial, Bolt funcional, All Jump, touchscreen, exploração horizontal e vertical, câmera, cenários profundos, combate, três armas, inimigos, NPCs, checkpoints, save, HUD, menus, loading, cutscenes, chefe, fragmento, encerramento e medição de performance Android.

O slice deve provar que a estrutura sustenta os demais mundos. Após validação interna, continuar automaticamente os outros seis sem aguardar aprovação. Não apresentar placeholders como conteúdo final.

## 33. Critérios de conclusão

Só considerar o jogo concluído quando:
1. Sete mundos implementados.
2. 42 fases disponíveis.
3. Sete guardiões implementados.
4. Confronto com Arquiteto concluído.
5. Fragmentos integrados à progressão.
6. Nove skins implementadas.
7. Três armas funcionais.
8. Cada mundo com inimigos/ecossistema próprios.
9. História com começo, meio e fim.
10. Cutscenes integradas.
11. Menus completos.
12. Touchscreen funcional.
13. Save validado.
14. Recursos Android tratados.
15. Performance medida.
16. 42 fases testadas.
17. Problemas críticos corrigidos.
18. APK gerado e verificado.
19. Documentação atualizada.

### Estados obrigatórios

- **IMPLEMENTED:** implementado no projeto.
- **TESTED:** submetido ao teste identificado; registrar resultado.
- **VERIFIED:** validado com evidências reproduzíveis.
- **APPROVED:** formalmente aprovado pela autoridade apropriada.

Não declarar VERIFIED sem evidência. Não inventar percentuais, esconder limitações ou declarar conclusão prematura.

## 34. Princípios inegociáveis

1. Produto exclusivamente Android; engine Godot 4.x; GDScript.
2. Sem arquitetura web, HTML5, Canvas ou JavaScript no jogo.
3. Evitar scripts monolíticos e fragmentação excessiva.
4. Preservar história e identidade dos sete mundos.
5. Escopo de 42 fases principais, variedade real e pelo menos cinco arquétipos de inimigos por mundo.
6. Cada mundo com identidade visual/gameplay própria e exploração vertical funcional.
7. Tutorial por desafios reais; chefes com padrões próprios.
8. Touchscreen como prioridade.
9. Não implementar voo, parry ou Dash sem solicitação futura explícita.
10. Skins cosméticas; perfis gráficos não alteram jogabilidade.
11. Medir performance antes de declarar otimização.
12. Não apagar saves válidos, usar placeholders como arte final ou inventar testes.
13. Não parar após planejamento ou vertical slice.
14. Avançar sem pedir aprovações intermediárias para tarefas reversíveis já especificadas.
15. Não realizar ações destrutivas, publicar releases ou manipular segredos sem autorização.

## 35. Primeira execução

Começar pela Etapa 0. Inspecionar repositório e ferramentas; registrar auditoria; criar documentação inicial; definir arquitetura; preparar ambiente; desenvolver sistemas fundamentais; implementar vertical slice Cybercore; validar; continuar os seis mundos; completar campanha; executar QA; otimizar; gerar/verificar APK; atualizar documentação final.

Se o projeto Godot estiver ausente, inicializá-lo preservando o ecossistema de documentação e skills. Não presumir assets, cenas, sistemas ou testes sem verificar. Não responder somente com plano: implementar diretamente no repositório sempre que houver acesso e ferramentas. Se uma ferramenta estiver indisponível, declarar o bloqueio real e fazer tudo que continuar possível sem fingir ações externas.

**Objetivo final:** entregar BOLT · AVENTURA como jogo 2D completo, coeso, cinematográfico, rico em exploração, com gameplay refinado, sete universos distintos e experiência profissional Android. Retomar do último checkpoint verificado; não reiniciar a cada sessão nem abandonar etapas.
