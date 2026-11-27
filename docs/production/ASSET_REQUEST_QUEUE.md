# Fila de solicitações de assets — BOLT · AVENTURA

**Autoridade:** `32-stage-production-plan.md` e `ASSET_PIPELINE.md`.  
**Regra:** nenhum asset visual final é integrado antes da aprovação explícita do usuário sobre a versão exata apresentada por ChatGPT.

## Como operar

- Uma linha por asset ou conjunto visual com escopo homogêneo.
- Criar brief completo antes de gerar concept.
- Atualizar status sem apagar histórico.
- Aprovação deve identificar asset ID, versão, finalidade e data/contexto da decisão.
- Assets rejeitados permanecem registrados com motivo; não reutilizar silenciosamente.
- Não preencher dimensões, frames, pivôs ou paletas por suposição antes das etapas de direção de arte e especificação técnica.

## Estados permitidos

`PLANNED`, `SPECIFIED`, `CONCEPT_CREATED`, `AWAITING_USER_APPROVAL`, `REVISION_REQUESTED`, `APPROVED`, `INTEGRATED`, `VERIFIED`, `REJECTED`, `PLACEHOLDER`.

## Backlog inicial

Os itens abaixo são necessidades planejadas, não briefs aprovados, conceitos gerados ou assets existentes.

| ID | Entrega | Consumidor | Etapa de referência | Estado | Bloqueio/observação |
| ART-BOLT-001 | Requisitos visuais globais (documentação, sem arte final) | Todos os mundos/sistemas | 05 | PLANNED | Definir requisitos de leitura e consistência; não gerar concepts |
| ART-BOLT-002 | Guia técnico/pipeline de sprites e assets | Pipeline Godot | 06 | PLANNED | Definir contratos e processo; não gerar spritesheets |
| ART-BOLT-003 | Especificação funcional visual do protagonista BOLT | Player | 07 (requisitos); 31 (concept/arte final) | PLANNED | Não criar concept agora; manter descrição funcional e requisitos |
| ART-BOLT-004 | Spritesheets/animações finais de BOLT | Player | 31 | PLANNED | Bloqueado até estabilização do gameplay e aprovação do concept |
| ART-BOLT-005 | UI/HUD gráfica definitiva | Menus/HUD | 31 | PLANNED | Implementar fluxos com wireframes/placeholders antes |
| ART-BOLT-006 | Concepts/sprites finais dos inimigos | Inimigos por mundo | 31 | PLANNED | Depende de arquétipos funcionais estabilizados |
| ART-BOLT-007 | Concepts/sprites finais dos sete guardiões | Chefes/arenas | 31 | PLANNED | Depende dos dossiers e encontros funcionais; aprovação individual |
| ART-BOLT-008 | Concepts visuais finais dos sete mundos | Ambientes | 31 | PLANNED | Direção final após blockouts e composição funcional |
| ART-BOLT-009 | Tilesets, fundos e kits ambientais finais | Fases | 31 | PLANNED | Produzir após geometrias/colisões e layouts estabilizados |
| ART-BOLT-010 | VFX, objetos e elementos ambientais finais | Gameplay/fases | 31 | PLANNED | Especificar necessidades antes; produzir assets finais no fim |
| ART-BOLT-011 | Polimento/variantes visuais finais | Campanha completa | 31–32 | PLANNED | Somente após integração dos conjuntos finais |
|---|---|---|---:|---|---|

## Política de produção tardia — 27/11/2026

A fila permanece ativa para planejamento, dependências e rastreabilidade, mas não autoriza gerar arte imediatamente. A produção visual definitiva está programada para Etapa 31. Antes dela, só briefs, especificações, wireframes e placeholders técnicos identificados. Etapa 32 fecha integração, verificação e auditoria de cobertura. Nenhum asset final entra no jogo sem aprovação explícita da versão exata pelo usuário.

## Registro de aprovações

| Asset ID | Versão apresentada | Decisão do usuário | Data | Observações |
|---|---|---|---|---|
| — | — | Nenhuma aprovação registrada nesta fila inicial | — | Não presumir aprovação |

## Template de brief

```yaml
asset_id: ART-BOLT-XXX
name: "Nome descritivo"
type: character | npc | enemy | boss | tileset | background | prop | vfx | ui | icon | audio | font
consumer: "Cena, fase, sistema ou mundo"
purpose: "Função de gameplay/narrativa/interface"
status: PLANNED
visual_direction: "Referência à bíblia/decisão aprovada"
dimensions: "A definir após especificação"
frame_size: "A definir ou N/A"
frames: "A definir ou N/A"
fps: "A definir ou N/A"
transparency: "A definir ou N/A"
pivot: "A definir ou N/A"
safe_margins: "A definir ou N/A"
palette: "A definir após direção de arte"
format: "A definir após pipeline técnico"
target_path: "Proposto, ainda não criado"
provenance: "Registrar autoria/ferramenta/licença"
presented_version: null
user_approval: null
integration_commit: null
verification: null
```

O template é um esquema de planejamento, não autorização para preencher lacunas por palpite. Para assets de áudio/fontes, adaptar os campos técnicos.
