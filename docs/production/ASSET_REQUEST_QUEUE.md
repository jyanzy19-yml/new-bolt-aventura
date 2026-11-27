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
|---|---|---|---:|---|---|
| ART-BOLT-001 | Direção visual global de BOLT · AVENTURA | Todos os mundos/sistemas | 05 | PLANNED | Definir linguagem visual antes dos concepts |
| ART-BOLT-002 | Guia técnico de sprites e assets | Pipeline Godot | 06 | SPECIFIED | Guia base criado em `SPRITE-ASSET-TECHNICAL-GUIDE.md`; parâmetros artísticos e budgets numéricos dependem da aprovação da Etapa 05 e de slice medido |
| ART-BOLT-003 | Concept do protagonista BOLT | Player | 07 | PLANNED | Requer direção visual; aguarda aprovação |
| ART-BOLT-004 | Spritesheets/animações de BOLT | Player | 08 | PLANNED | Bloqueado pelo concept aprovado e brief |
| ART-BOLT-005 | Kit visual inicial de UI/HUD | Menus/HUD | 09 | PLANNED | Requer UI/UX e aprovação |
| ART-BOLT-006 | Concepts/sprites dos inimigos | Inimigos por mundo | 16 | PLANNED | Requer arquitetura de arquétipos e direção |
| ART-BOLT-007 | Concepts/sprites dos sete chefes | Chefes/arenas | 18 | PLANNED | Requer canon e dossiers; aprovação individual |
| ART-BOLT-008 | Concepts visuais dos sete mundos | Ambientes | 21 | PLANNED | Requer bíblias de mundo e aprovação por direção |
| ART-BOLT-009 | Tilesets, fundos e kits ambientais | Fases | 22 | PLANNED | Requer concepts aprovados por mundo |
| ART-BOLT-010 | VFX, objetos e elementos ambientais | Gameplay/fases | 22–24 | PLANNED | Especificar por consumidor e legibilidade |
| ART-BOLT-011 | Polimento/variantes visuais finais | Campanha completa | 31 | PLANNED | Somente após conteúdo integrado e aprovado |

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
