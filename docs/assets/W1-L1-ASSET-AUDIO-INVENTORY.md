# W1-L1 — Inventário de assets e áudio

**Task:** BOLT-001 · Fonte: `content/levels/w1-l1.content.json` (`assets[]`).
**Estado geral:** os 34 itens estão `SPECIFIED` com aprovação `NONE`. **Nenhum arquivo de asset foi criado, importado ou aprovado nesta task.** Os IDs são estáveis para referência futura pelo manifesto de assets (PR #160); o formato de manifesto do runtime ainda não os consome.

Classificação:
- **FINAL**: nenhum.
- **PLACEHOLDER (existente)**: retângulos de debug desenhados pelo runtime; não são assets.
- **NECESSÁRIO**: todos os itens abaixo.

Regras para produção (do repositório): origem e licença registradas (`asset-provenance-qa`), sem música protegida, sem síntese provisória como trilha final, transparência real, escala coerente com o corpo 30×46 px, pedidos via `docs/production/ASSET_REQUEST_QUEUE.md`.

| ID | Tipo | Descrição | Usado por | Estado | Aprovação |
|---|---|---|---|---|---|
| `tile-w1-floor-metal` | imagem | Piso metálico de infraestrutura (topo com realce de borda). | solids | SPECIFIED | NONE |
| `tile-w1-wall-ruin` | imagem | Parede e massa de teto em ruína tecnológica. | solids | SPECIFIED | NONE |
| `tile-w1-rubble` | imagem | Entulho e blocos caídos (obstáculos e leitos de vala). | solids | SPECIFIED | NONE |
| `tile-w1-ledge-debris` | imagem | Cornijas e restos estruturais usados como plataformas unidirecionais. | one-way | SPECIFIED | NONE |
| `tile-w1-catwalk-metal` | imagem | Passarelas metálicas e almofadas de pouso. | one-way | SPECIFIED | NONE |
| `tile-w1-pool-bed` | imagem | Leito do fosso de energia residual. | solids | SPECIFIED | NONE |
| `bg-w1l1-far-skyline` | imagem | Camada distante: horizonte tecnológico fragmentado e farol do abrigo. | level | SPECIFIED | NONE |
| `bg-w1l1-mid-ruins` | imagem | Camada intermediária: estruturas em ruína. | level | SPECIFIED | NONE |
| `bg-w1l1-near-structures` | imagem | Camada próxima: vigas e dutos fora do plano jogável. | level | SPECIFIED | NONE |
| `bg-w1l1-chamber-interior` | imagem | Interior da câmara de despertar. | sec-01-chamber | SPECIFIED | NONE |
| `bg-w1l1-shelter-interior` | imagem | Interior do abrigo de manutenção. | sec-06-shelter | SPECIFIED | NONE |
| `prop-w1l1-awakening-cradle` | imagem | Berço de despertar de BOLT. | props | SPECIFIED | NONE |
| `prop-w1l1-awakening-console` | imagem | Console de despertar (inativo, pulsando, usado). | interactables | SPECIFIED | NONE |
| `prop-w1l1-chamber-door` | imagem | Porta da câmara (fechada, abrindo, aberta). | gates | SPECIFIED | NONE |
| `prop-w1l1-exit-door` | imagem | Porta de saída do abrigo (fechada, abrindo, aberta). | gates | SPECIFIED | NONE |
| `prop-w1l1-floor-light-strip` | imagem | Faixa luminosa de piso. | props | SPECIFIED | NONE |
| `prop-w1l1-checkpoint-beacon` | imagem | Baliza de checkpoint (inativa, ativando, ativa). | checkpoints | SPECIFIED | NONE |
| `prop-w1l1-repair-kit` | imagem | Kit de reparo (coletável de cura). | pickups | SPECIFIED | NONE |
| `prop-w1l1-diagnostic-compartment` | imagem | Painel rachado com luz vazando; abre ao interagir. | interactables | SPECIFIED | NONE |
| `prop-w1l1-landing-light` | imagem | Luz de pouso das almofadas da sequência de saltos. | props | SPECIFIED | NONE |
| `prop-w1l1-sync-terminal` | imagem | Terminal do primeiro ponto de sincronização. | interactables | SPECIFIED | NONE |
| `prop-w1l1-shelter-lamps` | imagem | Iluminação do abrigo. | props | SPECIFIED | NONE |
| `sprite-w1-maint-unit-defective` | imagem | Unidade de manutenção defeituosa: dormente, reinício, patrulha, giro, pane, dano, derrota. | enemies | SPECIFIED | NONE |
| `sprite-w1-maint-unit-inert` | imagem | Unidade de manutenção inerte (cenário). | props | SPECIFIED | NONE |
| `vfx-w1-pit-edge-light` | imagem | Luz de borda de vala (redundância não cromática do perigo). | hazards | SPECIFIED | NONE |
| `vfx-w1-residue-pool` | imagem | Energia residual do fosso (pulso, brilho, partículas limitadas). | hazards | SPECIFIED | NONE |
| `audio-mus-w1l1-awakening` | áudio | Música: isolamento e despertar (esparsa). | events | SPECIFIED | NONE |
| `audio-mus-w1l1-exploration` | áudio | Música: exploração (movimento gradual). | events | SPECIFIED | NONE |
| `audio-mus-w1l1-shelter` | áudio | Música: resolução no abrigo. | events | SPECIFIED | NONE |
| `audio-amb-w1l1-corridor` | áudio | Ambiência do corredor (zumbido elétrico, estrutura, vento distante). | events | SPECIFIED | NONE |
| `audio-sfx-door-open` | áudio | Efeito: abertura de porta. | events | SPECIFIED | NONE |
| `audio-sfx-signal-flicker` | áudio | Efeito: oscilação do sinal. | events | SPECIFIED | NONE |
| `audio-stg-secret-found` | áudio | Stinger: segredo encontrado. | events | SPECIFIED | NONE |
| `audio-stg-sync-established` | áudio | Stinger: sincronização estabelecida. | events | SPECIFIED | NONE |

## Notas de produção
- **Resolução de arte:** a unidade de mundo é o px lógico de 800×450; dimensões finais de sprite/tile dependem de decisão de escala (pendente, D-13).
- **Perigo sem cor:** `vfx-w1-pit-edge-light` e a luz de pouso garantem leitura sem depender só de cor.
- **Orçamento:** nenhum orçamento de memória/atlas foi definido; medir em dispositivo antes de fixar.
- **Áudio:** `audio-mus-w1l1-*` (3), `audio-amb-w1l1-corridor`, `audio-sfx-*` (2) e `audio-stg-*` (2); mixagem e loops a validar com Web Audio no WebView.
- **Referência histórica (não usar como fonte):** o ZIP V5.2 anexado pelo usuário contém `assets/` de um código-base anterior (por exemplo `bg_w1.png`, `music_w1.wav`). Não foi importado: proveniência e licença não verificadas, e o pacote não pertence à base limpa do repositório.
