# Parte 03 — Bolt, movimentação, armas e personagens

## 11. Personagem principal — Bolt

Bolt é o centro da experiência. Movimentação precisa, agradável e consistente. Usar **CharacterBody2D** para a implementação principal.

### 11.1. All Jump

Implementar:
- Pulo responsivo e altura variável.
- Pulo duplo.
- Jump Buffer e Coyote Time.
- Controle aéreo.
- Aceleração e desaceleração.
- Gravidade e detecção de chão.
- Colisões consistentes.
- Plataformas móveis.
- Sincronização das animações.
- Resposta touchscreen.

O pulo deve responder imediatamente; comandos próximos à borda temporal não podem ser perdidos; pulo duplo previsível; altura relacionada ao tempo de pressionamento dentro de limites; sem atravessar plataformas; correção aérea disponível; física independente da qualidade gráfica.

**Limites explícitos:** não implementar voo; não implementar parry/aparar; não implementar Dash sem solicitação futura explícita. Não adicionar wall jump, stomp jump ou habilidades especiais não especificadas. Essas exclusões prevalecem sobre referências anteriores a Dash em documentos antigos.

### 11.2. Animações

Prever Idle, Run, Jump, Fall, Double Jump, Land, Shoot, Hurt, Death, Interact e Victory. As animações refletem o estado real e não bloqueiam comandos importantes.

### 11.3. Colisões

Separar hitbox/hurtbox da aparência visual. Verificar paredes, plataformas, cantos, quedas, plataformas móveis, inimigos, projéteis, limites, áreas de dano e consistência em todas as nove skins.

## 12. Armas e combate

As três armas principais ficam disponíveis desde o início e devem ser equilibradas para que nenhuma torne as outras inúteis.

- **Pistola:** disparo simples, trajetória previsível, uso geral, cadência equilibrada e baixa complexidade.
- **Tríplice:** múltiplas direções/trajectórias, maior cobertura e utilidade contra grupos.
- **Laser:** disparo concentrado, identidade visual e sonora própria, adequado a alvos alinhados.

Melhorias podem alterar alcance, cadência, eficiência, comportamento de projéteis, cobertura, efeitos visuais ou consumo de recursos se houver sistema que o justifique. Não aumentar somente dano.

Combate: disparo responsivo, direcionamento, colisão de projéteis, dano, invulnerabilidade temporária após impacto quando apropriado, feedback visual/sonoro, reação inimiga, indicadores de vida, vida de Bolt e balanceamento. O combate deve funcionar bem em touchscreen sem exigir precisão excessiva.

## 13. Personagens e skins

Nove aparências cosméticas:
1. Bolt original.
2. Inspirada em Cybercore.
3. Inspirada no Egito futurista.
4. Inspirada na cidade dos segredos.
5. Inspirada em Dark Fantasy.
6. Inspirada no reino medieval.
7. Inspirada em Vaporwave.
8. Inspirada no mundo natalino futurista.
9. Secreta/lendária.

Todas compartilham a mesma física, hitbox, capacidades, velocidade, comportamento e controles. A skin secreta deve vir de conquista ou descoberta significativa.

## 14. NPCs e vida dos universos

NPCs transmitem civilização e não são apenas objetos parados. Implementar, quando apropriado, conversas, animações, rotinas pequenas, reações a Bolt, informações, missões curtas, recompensas, histórias pessoais e comentários sobre eventos. Alguns podem reaparecer em fases posteriores.

Robôs mensageiros pequenos conectam os universos e dão personalidade ao mundo. NEXO comenta descobertas e acontecimentos sem repetição. Preferir diálogos curtos e expressivos, não textos longos por padrão.
