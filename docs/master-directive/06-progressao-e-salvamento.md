# Parte 06 — Progressão, segredos e salvamento

## 21. Progressão e recompensas

Desbloqueios: mundos, fases, fragmentos, skins, itens lendários, melhorias, segredos e conquistas. Recompensas devem incentivar exploração sem exigir repetição excessiva.

### 21.1. Segredos

Distribuir salas escondidas, passagens alternativas, baús, itens especiais, registros históricos, pequenos encontros, áreas opcionais e colecionáveis narrativos. Descoberta por observação, exploração e domínio de mecânicas. Não esconder recompensas atrás de caminhos impossíveis de identificar.

## 22. Checkpoints e salvamento

Sistema robusto, versionado e validável. Persistir:
- Mundo/fase atual e checkpoint.
- Vida/estado apropriado.
- Fragmentos.
- Skins desbloqueadas.
- Armas e melhorias.
- Itens e conquistas.
- Configurações.
- Progresso narrativo relevante.

Requisitos: validar dados; versionar schema; permitir migração; recuperar-se de dados inválidos; preservar saves válidos; evitar corrupção; tratar interrupções e encerramento do Android; evitar perda de progresso.

Não apagar saves reais durante testes. Testes de save devem usar fixtures, perfis isolados ou cópias controladas. Toda migração deve ter caminho de recuperação e validação.
