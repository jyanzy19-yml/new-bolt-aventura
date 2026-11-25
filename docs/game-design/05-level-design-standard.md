# BOLT · AVENTURA — Padrão de level design

## 1. Objetivo
Cada fase deve ensinar, testar ou combinar habilidades e comunicar visualmente o caminho, os riscos, as recompensas e a intenção narrativa.

## 2. Blueprint de fase
- ID, mundo e versão:
- Objetivo narrativo:
- Objetivo de gameplay:
- Entrada e saída:
- Duração-alvo (a definir por playtest):
- Rota principal:
- Rotas opcionais:
- Mecânica ensinada:
- Sequência de aprendizagem:
- Tipos de encontro:
- Checkpoints:
- Segredos e recompensas:
- NPCs e diálogos:
- Eventos e cutscenes:
- Requisitos de arte/áudio:
- Orçamento de performance:
- Critérios de conclusão e QA:

## 3. Ritmo de uma fase
Alternar exploração, desafio de movimento, encontro, descanso narrativo e recompensa. Evitar longos trechos homogêneos. Usar variação de ritmo sem retirar controle do jogador desnecessariamente.

## 4. Legibilidade
- Distinguir primeiro plano, plano jogável e fundo.
- Contraste suficiente para personagem, plataformas, perigos e itens.
- Não comunicar perigo apenas por cor.
- Indicar superfícies interativas de forma consistente.
- Evitar partículas, iluminação e efeitos que ocultem hitboxes.
- Garantir que o jogador consiga antecipar saltos e aterrissagens.
- Considerar proporções de tela e safe areas Android.

## 5. Desafio justo
- Ensinar antes de exigir.
- Telegraphs devem ter tempo e contraste suficientes.
- Evitar ameaças fora da tela sem indicação.
- Dar espaço para corrigir erros quando a habilidade esperada permitir.
- Checkpoints devem respeitar o custo de repetição.
- Não exigir precisão incompatível com touch sem opção alternativa.

## 6. Critérios de QA por fase
Concluir rota principal; validar rotas opcionais; testar colisões e limites; testar checkpoint e respawn; verificar NPCs e flags; confirmar que não há softlocks; verificar chefe e fragmento; medir frame time na seção mais carregada; testar proporções de tela relevantes.
