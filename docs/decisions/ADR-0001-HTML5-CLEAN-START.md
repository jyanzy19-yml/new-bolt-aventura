# ADR-0001 — Reconstrução clean-start em HTML5

- **Status:** ACCEPTED (decisão do usuário)
- **Data:** 2026-11-27
- **Responsável pela decisão:** usuário / product owner

## Contexto
O projeto possui documentação e histórico técnico anteriores em Godot/GDScript. O usuário decidiu que a nova implementação será desenvolvida do zero como jogo HTML5, organizado em módulos e pastas.

## Decisão
A stack vigente é HTML5, CSS3, JavaScript ES Modules, Canvas 2D e Vite. Web Audio API e Pointer Events são as APIs-alvo para áudio e entrada. Capacitor pode ser avaliado para empacotamento Android após validação dos requisitos nativos.

A iniciativa não é port nem migração da implementação Godot. Cenas, scripts, addons, autoloads e workflows exclusivos da engine antiga não devem ser convertidos mecanicamente.

## Invariantes de produto
Preservar o canon aprovado, BOLT/NEXO, Grande Colapso, Núcleo da Eternidade, Arquiteto, sete mundos, sete fragmentos, campanha planejada de 42 fases, mecânicas aprovadas incluindo Dash, identidade audiovisual e requisitos Android/mobile.

## Consequências
- Criar uma nova base de runtime e tooling web.
- Reavaliar contratos técnicos sob APIs de browser/WebView.
- Adaptar documentação engine-neutral; marcar instruções Godot como históricas.
- Não apagar materiais antigos antes de inventário recursivo e classificação de paths.
- Validar compatibilidade e comportamento Android em aparelhos reais.

## Revisão
Reabrir somente mediante nova decisão explícita do usuário ou evidência técnica que exija reconsideração.
