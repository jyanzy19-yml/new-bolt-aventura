# BOLT · AVENTURA — Bíblia de gameplay

## 1. Princípios
Gameplay deve ser responsivo, legível, consistente e adequado a touch. Valores numéricos finais não devem ser inventados a partir de exemplos de skills. Primeiro identificar a versão do projeto e medir o comportamento atual.

## 2. Movimento do jogador
Documentar e testar:
- movimento horizontal, aceleração, desaceleração e controle aéreo;
- salto, altura variável se aprovada, buffer e coyote time se aprovados;
- dash e suas condições, duração, recarga e cancelamentos;
- colisões, bordas, plataformas móveis e plataformas unidirecionais;
- knockback, invulnerabilidade e recuperação, quando aplicáveis;
- estados de animação e transições;
- comportamento em pausas, câmera lenta, hitstop e perda/retorno de foco.

Toda habilidade deve ter regras claras de início, atualização, interrupção, término e prioridade. Não manter input preso ao trocar de cena ou pausar.

## 3. Combate e habilidades
O jogo pode conter combate fictício de plataforma. Cada habilidade deve declarar propósito, custo/recarga, alcance, telegraph, feedback, limites, compatibilidade com touch e papel no balanceamento. Evitar adicionar habilidades redundantes.

## 4. Tutorial integrado
O tutorial deve:
1. Apresentar uma única ideia principal.
2. Demonstrar por ambiente, animação ou instrução curta.
3. Permitir prática segura.
4. Confirmar domínio com desafio real e justo.
5. Reutilizar a habilidade em combinação posterior.
6. Oferecer repetição ou ajuda sem bloquear jogadores.

Não ensinar uma ação somente com texto se ela depende de timing ou coordenação. O tutorial precisa funcionar com controles touch.

## 5. Checkpoints e progressão
Definir claramente:
- o que é salvo em checkpoint;
- posição e estado do jogador;
- inimigos, portas, itens e fragmentos;
- reinício após falha;
- persistência de segredos e recompensas;
- comportamento ao sair/retomar o aplicativo;
- migração de saves entre versões.

Nenhum checkpoint deve gerar ciclo de morte, softlock ou perda inesperada de progresso.

## 6. Câmera e feedback
A câmera deve preservar legibilidade e não esconder perigos. Documentar dead zones, look-ahead, limites, transições e comportamento em cutscenes. Screen shake, flashes e hitstop devem ser configuráveis ou reduzíveis quando possível.

## 7. Requisitos de input
Separar ações lógicas do dispositivo físico. A mesma ação do jogo deve poder receber teclado/gamepad em testes de desenvolvimento e touch na versão Android, sem tornar navegador um alvo de produto.

Requisitos:
- multitouch real;
- pressionar e soltar corretamente;
- buffer de ações para reduzir perda por frame;
- prioridade definida para ações simultâneas;
- tratamento de foco, pausa e mudança de cena;
- alvos touch dimensionados para uso confortável;
- feedback de pressionado/indisponível;
- não depender de arrastar um joystick virtual com precisão extrema.

## 8. Balanceamento
Registrar valores, justificativa, fonte de teste, build, aparelho e versão. Alterar uma variável relevante por vez quando possível. Avaliar acessibilidade, dificuldade e performance em conjunto.
