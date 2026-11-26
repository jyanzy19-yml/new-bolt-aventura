# Direção de arte e áudio — BOLT · AVENTURA

## 1. Objetivo
Construir uma identidade audiovisual consistente para protagonista, máquina temporal, sete mundos, inimigos, chefes, interface e cutscenes. Esta bíblia define critérios de produção; não substitui referências visuais aprovadas.

## 2. Estado do estilo
A direção final de pixel art, resolução-base, escala de sprites, paletas, proporções, densidade de detalhe, iluminação e animação precisa ser confirmada a partir dos materiais aprovados. Não inventar esses parâmetros como decisões fechadas.

## 3. Personagem e silhueta
- BOLT deve ser reconhecível em tamanho reduzido.
- Silhueta e pose devem comunicar estado de movimento, dano, interação e habilidade.
- Animações essenciais têm prioridade sobre microdetalhes.
- Pivôs, origem, hitbox e sprite precisam permanecer coerentes.
- Variações cosméticas não devem confundir leitura de gameplay.

## 4. Identidade dos mundos
Cada mundo deve ter guia próprio de paleta, materiais, arquitetura, formas dominantes, fundo, primeiro plano, iluminação, partículas e assinatura sonora. As identidades centrais dos sete mundos e a ordem dos fragmentos estão definidas em `02-world-bible.md`; paletas finais, materiais, arquitetura detalhada, referências visuais e assinaturas musicais específicas ainda precisam de desenvolvimento e aprovação.

## 5. Animação
Manter uma lista de estados e transições: idle, locomotion, start/stop, jump, fall, land, dash, hit, interact, victory/defeat e estados específicos aprovados. Definir duração, loop, cancelamento, prioridade e sincronização com gameplay.

## 6. VFX
Efeitos precisam comunicar causa, direção, duração, área e resultado. Evitar partículas e flashes que escondam perigos, hitboxes, personagem ou UI. Prever opção de reduzir efeitos intensos quando viável.

## 7. Áudio
Definir identidade de música, ambiência, UI, movimento, interação, inimigos, chefes, fragmentos e transições. Usar buses/controles de volume coerentes; evitar saturação e competição entre eventos. Música adaptativa só deve ser adicionada quando a experiência justificar a complexidade.

## 8. Produção e proveniência
Todo asset deve ter origem, licença, autor/fonte, status e configuração de importação registrados. Não usar material sem licença clara. Distinguir placeholder de arte final em commits e documentação.

## 9. Orçamento mobile
Medir dimensões e memória de texturas, formatos de áudio, quantidade de partículas, overdraw, animações simultâneas e custo de primeiro carregamento. Otimizar com base em perfil e preservar legibilidade.

## 10. Gate de aprovação
A direção visual e sonora deve ser aprovada em contexto de gameplay real, em tela Android, com UI e efeitos ativos. Uma imagem isolada não comprova legibilidade ou desempenho.
