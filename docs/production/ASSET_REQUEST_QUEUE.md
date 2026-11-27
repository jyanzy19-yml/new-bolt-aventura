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
