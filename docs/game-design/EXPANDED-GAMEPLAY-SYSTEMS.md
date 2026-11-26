# BOLT · AVENTURA — BÍBLIA EXPANDIDA DE SISTEMAS E GAMEPLAY
**Status:** especificação de design; parâmetros finais dependem de protótipo e medição.  
**Alvo:** Godot 4.7.2, GDScript, Android empacotado em paisagem.

## 1. Contrato de gameplay

O núcleo é plataforma de precisão acessível por touch, exploração de espaços 2D, combate legível e progressão narrativa. Cada sistema deve ser avaliado pelo que acrescenta à decisão do jogador e pelo custo de implementação, QA, performance e manutenção.

## 2. Player controller — estados e transições

Definir máquina de estados explícita. Estados mínimos a considerar: IDLE, RUN, RISING, FALLING, LANDING, DASHING, ATTACKING (se bloquear movimento), DAMAGED, KNOCKBACK, DEAD, RESPAWNING, INTERACTING e CUTSCENE. Não criar estado se uma flag local for suficiente; não acumular flags contraditórias.

Para cada transição documentar:
- evento de entrada;
- pré-condições;
- prioridade;
- ações de início;
- atualização;
- condição de saída;
- limpeza de input;
- efeitos colaterais;
- eventos/sinais;
- invariantes.

Invariantes: não ficar simultaneamente derrotado e controlável; não manter Dash após pause se a regra não permitir; não aceitar input residual após trocar de cena; não permitir movimento físico durante cutscene bloqueada.

## 3. Movimento horizontal

Separar velocidade-alvo, aceleração, desaceleração, controle aéreo e atrito. A sensação deve ser responsiva, sem deriva inesperada. A física final precisa ser medida em aparelho real e comparada em diferentes taxas de frame. Evitar que movimento dependa de FPS renderizado.

## 4. Salto

Documentar altura, impulso, gravidade ascendente/descendente, altura variável (se existente), buffer e coyote time. O jogador deve entender quando o salto foi aceito. Testar:
- pressionar antes de tocar o chão;
- pressionar exatamente no pouso;
- soltar cedo;
- manter pressionado;
- saltar após dano;
- salto em plataforma móvel;
- mudança de cena durante input;
- multitouch com direção e ataque.

## 5. Dash

Dash é requisito preservado por ADR-001-DASH. Não remover, substituir ou ajustar parâmetros incidentalmente. Antes de qualquer modificação, consultar ADR, script, input map, touch control e testes. Dash deve possuir estados de início/execução/fim, regras de colisão, invulnerabilidade se aprovada, cooldown e cancelamento claramente documentados. O teste deve cobrir touch, teclado de desenvolvimento e transições.

## 6. Input e ActionBuffer

A camada lógica deve abstrair o dispositivo. O input touch não deve chamar diretamente a lógica de gameplay; deve alimentar ações semânticas. O buffer deve:
- guardar evento com timestamp/tick ou janela limitada;
- consumir no máximo conforme contrato;
- expirar sem gerar ação tardia;
- limpar em pause, focus loss e troca de cena;
- tratar pressionar/soltar e ponteiro cancelado;
- suportar ações simultâneas.

Definir prioridade de ações simultâneas com base em estado e contexto, não por ordem acidental dos callbacks.

## 7. Touch UI

Botões essenciais devem ter hitbox confortável, feedback de pressionado e estado indisponível. O joystick deve tolerar pequenas imprecisões. Testar dedos diferentes em botões distintos, arrastar para fora, soltar fora, cancelamento pelo sistema, rotação, safe area e frame drops. Nenhum botão essencial pode depender de um único frame de polling.

## 8. Combate e armas

### Pistola Crono
Arma inicial de referência já conectada ao fluxo básico. Valores de cooldown/dano/velocidade/lifetime existentes são provisórios e não devem ser canonizados sem playtest.

### Tríplice Prisma
Proposta de arma com função de cobertura angular/controle de espaço. A implementação deve evitar multiplicar projéteis excessivamente e manter leitura em telas pequenas. Não implementar antes de existir justificativa de progressão e contrato de balanceamento.

### Laser Nexo
Proposta de arma de precisão/linha de energia, com telegraph claro, duração e custo definidos por teste. Evitar atravessar toda a fase sem contrajogo.

Para qualquer arma: limitar projéteis ativos, validar colisão, tempo de vida, saída de cena, dano, feedback, pausa e limpeza.

## 9. Saúde e dano

Vida deve ser domínio independente do visual. Validar amount, máximo, mínimo, dano repetido, invulnerabilidade, cura, derrota e restauração. Cura não deve reviver jogador derrotado, não deve ultrapassar máximo e não deve consumir pickup quando não houver cura efetiva. Dano não deve ser aplicado durante estados invulneráveis, salvo regra explícita.

## 10. Inimigos — gramática de IA

Arquétipos devem diferir por padrão de decisão:
- patrulheiro: controla território;
- sentinela: reage à aproximação;
- perseguidor: pressiona movimento;
- controlador de espaço: cria zonas temporárias;
- defensor: exige janela ou posicionamento;
- variante aérea: testa leitura vertical;
- suporte: altera comportamento de outros inimigos.

Esta lista é vocabulário de design, não compromisso de implementar todos em cada mundo. Cada mundo seleciona pelo menos cinco arquétipos distintos na meta de conteúdo, evitando recolor.

## 11. Chefes — estrutura de combate

Cada chefe possui fases com transições previsíveis, telegraphs e janelas de punição. O chefe pode alterar arena, ritmo e padrões, mas não pode ocultar o estado vulnerável. Dano do chefe deve ser previsível e testável. Garantir que a câmera não esconda ataques e que botões touch permaneçam acessíveis.

## 12. Câmera

Documentar dead zone, look-ahead, smoothing, limites, zonas verticais, arenas, cutscenes e transição. A câmera nunca deve revelar armadilha antes de forma injusta nem esconder plataforma obrigatória. Testar aspect ratios Android e safe areas.

## 13. HUD e feedback

HUD deve priorizar vida, estado de arma, ações relevantes e objetivo atual. Não exibir números sem utilidade. Notificações de checkpoint, cura, fragmento e objetivo devem ser curtas, não bloquear controles e respeitar duração. Resultado deve permitir retry/continuar conforme fluxo real.

## 14. Progressão

Separar campanha, fase, habilidade, inventário, colecionáveis e configurações em domínios de save independentes. Cada domínio precisa de schema versionado. O reset de Nova Jornada deve preservar configurações e apagar apenas o progresso de campanha, conforme contrato existente.

## 15. Checkpoint e respawn

Especificar posição, vida, estado de mundo, inimigos, pickups e portas. Checkpoint ativado deve ter feedback e persistência. Respawn deve limpar velocidade, efeitos, inputs, projéteis hostis e timers inválidos. Testar reentrada de cena e processo reiniciado.

## 16. SceneFlow

Transições concorrentes devem ser bloqueadas. O loading deve mostrar progresso/estado real quando possível, não inventar percentuais. A cena anterior deve ser liberada no momento correto. Falha de carregamento precisa de fallback e log. Input residual não pode atravessar a transição.

## 17. SaveSystem

Manter envelope versionado, checksum, escrita atômica, backup e validação JSON-safe. Migrações precisam ser puras e testadas. Testar corrupção parcial, backup inválido, versão futura, campos desconhecidos, tipos errados, ausência de arquivo e gravação interrompida. Não apagar arquivo corrompido sem decisão explícita.

## 18. Áudio e feedback

Separar música, efeitos, UI e ambiente. Sons de ameaça devem ser distinguíveis da música. Não sobrepor sons críticos. A mixagem deve funcionar em alto-falante de celular. Permitir silenciar e ajustar níveis.

## 19. Performance

Estabelecer orçamento por cena: inimigos ativos, projéteis, partículas, luzes, nós processando, texturas e áudio simultâneo. Medir antes de otimizar. Usar pooling somente se churn de alocação for gargalo comprovado. Evitar carregar grandes quantidades de recursos durante gameplay; usar preloading/loading entre fases.

## 20. Testes obrigatórios por sistema

- Player: estado, colisão, física e transições.
- Input: multitouch, buffer, cancelamento e limpeza.
- Arma: cooldown, spawn, colisão, dano e cleanup.
- Inimigo: patrulha, percepção, dano, derrota e reset.
- Saúde: cura, dano, invulnerabilidade e morte.
- Pickup: cura válida, vida cheia, jogador derrotado e remoção.
- Checkpoint: ativação, persistência e respawn.
- Save: corrupção, migração e reset.
- HUD: estado e feedback.
- SceneFlow: concorrência, loading e falha.

## 21. Princípio de integração

Não implementar todos os sistemas em paralelo. Construir uma vertical slice representativa, validar sensação, arquitetura e custo, então generalizar. W1-L1 é a base atual de campanha; sua qualidade deve subir antes de multiplicar fases.
