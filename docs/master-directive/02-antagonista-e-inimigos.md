# Parte 02 — Antagonista, IA e encontros

## 9. Confronto final — O Arquiteto

Depois dos sete fragmentos, enfrentar o Arquiteto. Não é apenas outro chefe com mais vida; representa o conflito central da história.

Etapas:
1. **O Criador:** apresenta seu plano e domínio das linhas temporais.
2. **O Controle:** a arena muda; ataques representam a tentativa de unificar os universos.
3. **A Verdade:** Bolt descobre a conexão definitiva entre sua origem, NEXO e o Núcleo.
4. **A Ruptura:** confronto final, com os sete fragmentos reagindo.
5. **A Escolha:** encerramento narrativo e reconstrução do equilíbrio.

A luta deve ser desafiadora, legível e cinematográfica. Concluir com animações, música, enquadramento, pausas dramáticas e expressões — não depender só de diálogos.

## 10. Comportamento e design dos inimigos

Quantidade não substitui variedade funcional. Cada tipo precisa de identidade visual, silhueta, animações, estados de comportamento, patrulha, detecção, distância de reação, ataques, intervalos, recuperação, recebimento de dano, reação ao impacto, derrota, colisões, sons, efeitos e parâmetros de dificuldade.

### 10.1. IA

Usar máquina de estados ou arquitetura equivalente. Estados possíveis: IDLE, PATROL, ALERT, CHASE, ATTACK, RECOVERY, HURT, STUNNED quando fizer sentido e DEAD. Não implementar todos os estados em todos os inimigos por obrigação; cada inimigo recebe somente os estados que justificam seu comportamento.

### 10.2. Leitura e justiça dos ataques

Ataques perigosos devem apresentar sinais visuais ou sonoros antes de atingir Bolt. O jogador deve compreender quando o inimigo ataca, qual área será atingida, quando se mover e quando o inimigo está vulnerável. Não usar ataques impossíveis de prever.

### 10.3. Encontros combinados

Planejar combinações com papéis complementares: inimigo terrestre enquanto drone controla área superior; torre limita travessia enquanto patrulheiro pressiona plataforma; inimigo blindado exige posicionamento enquanto outro limita espaço; inimigo aéreo durante seção vertical.

A dificuldade deve vir da combinação de comportamentos e do level design, não de inflar artificialmente a vida dos inimigos. Cada encontro deve ser legível, testável e ajustável.
