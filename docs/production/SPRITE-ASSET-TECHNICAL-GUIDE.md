# Guia técnico de produção de sprites e assets — BOLT · AVENTURA

**ID:** ART-BOLT-002  
**Etapa:** 06 — Guia técnico de produção de sprites e assets  
**Versão:** 1.0  
**Estado:** ESPECIFICAÇÃO TÉCNICA BASE; parâmetros artísticos dependentes da aprovação da Etapa 05  
**Engine:** Godot 4.7.2 / GDScript  
**Plataforma-alvo:** Android empacotado, orientação paisagem  
**Base de trabalho:** `71463b5a1f27d7499943858ac86392a3933c58f2`  
**Regra de autoridade:** este guia complementa, não substitui, `MASTER_DIRECTIVE.md`, o plano de 32 etapas, as bíblias, ADRs e o pipeline de assets.

> Este guia estabelece contratos de produção, metadados, nomenclatura, validação e importação. Ele não escolhe estilo visual, resolução lógica, dimensões de sprite, paletas, proporções, FPS artístico ou budgets numéricos ainda não aprovados. Valores dependentes da direção visual permanecem explicitamente TBD.

---

## 1. Objetivo e escopo

Tornar a produção de assets reproduzível, auditável e tecnicamente importável no Godot, evitando decisões improvisadas por asset ou por agente.

O guia cobre:
- sprites estáticos e animados;
- spritesheets e sequências de frames;
- personagens, inimigos, chefes e NPCs;
- tilesets, fundos, parallax e elementos ambientais;
- props, pickups e objetos interativos;
- VFX e elementos gráficos de feedback;
- UI, HUD, ícones e painéis;
- fontes e recursos tipográficos;
- áudio e música, apenas no que diz respeito a metadados, proveniência e integração no pipeline.

Fora do escopo desta etapa:
- criação de arte final;
- escolha definitiva do estilo visual;
- concept final de BOLT/NEXO;
- produção de spritesheets finais;
- definição de paletas finais por mundo;
- alteração de cenas/scripts de runtime;
- integração de assets ainda não aprovados.

## 2. Estado das dependências

### 2.1 Direção visual

A Etapa 05 possui uma proposta documental em revisão, mas não há aprovação registrada para estilo, resolução-base, escala, proporções, paletas ou tratamento final. A proposta não é fonte de parâmetros fechados.

Portanto:
- o pipeline pode ser especificado agora;
- os campos técnicos podem ser definidos por categoria e função;
- dimensões, frame size, escala de apresentação, paleta e densidade visual ficam como TBD;
- budgets iniciais só podem ser registrados como hipóteses após a escolha do estilo e do slice de referência;
- nenhuma arte criada sob parâmetros hipotéticos pode ser promovida automaticamente a asset oficial.

### 2.2 Inventário

O snapshot documental anterior registrou cenas e recursos de texto Godot, sem catálogo comprovado de sprites finais. Esse snapshot deve ser revalidado antes de qualquer importação. Não assumir que a ausência histórica de uma pasta prova a ausência atual de assets.

### 2.3 Princípio de independência

Uma especificação pode definir o que precisa ser medido, validado ou registrado sem inventar o valor que será medido. Este princípio rege todos os campos TBD deste documento.

## 3. Estados obrigatórios do ciclo de vida

Usar os estados do pipeline existente, sem criar sinônimos:

| Estado | Critério de entrada | Critério de saída |
|---|---|---|
| `PLANNED` | Necessidade identificada e consumidor conhecido | Brief técnico iniciado |
| `SPECIFIED` | Brief e parâmetros aplicáveis documentados | Concept/asset produzido |
| `CONCEPT_CREATED` | Versão conceitual identificada | Apresentação ao usuário |
| `AWAITING_USER_APPROVAL` | Versão exata apresentada | Decisão explícita |
| `REVISION_REQUESTED` | Feedback vinculado à versão | Nova versão apresentada |
| `APPROVED` | Usuário aprova versão, escopo e finalidade | Integração autorizada |
| `INTEGRATED` | Arquivo aprovado importado e referenciado | Verificação concluída |
| `VERIFIED` | Checklist técnico/visual aplicável aprovado | Manutenção/versionamento |
| `REJECTED` | Rejeição explícita registrada | Arquivamento ou novo brief |
| `PLACEHOLDER` | Recurso provisório claramente identificado | Substituição controlada |

Aprovação é vinculada à versão, não apenas ao nome do asset. Alteração material de conteúdo, enquadramento, proporção, paleta, frames ou função cria nova versão e exige nova avaliação.

## 4. Identificação, nomes e estrutura de arquivos

### 4.1 IDs

Usar IDs estáveis e independentes do nome de arquivo:
- `CHR-BOLT-001`: protagonista;
- `CHR-NEXO-001`: máquina temporal/personagem, conforme a bíblia;
- `ENY-W01-001`: inimigo do mundo 1;
- `BOS-W01-001`: guardião/chefe do mundo 1;
- `ENV-W01-001`: elemento ambiental do mundo 1;
- `TIL-W01-001`: conjunto de tiles;
- `VFX-COM-001`: efeito reutilizável;
- `UI-HUD-001`: elemento de HUD;
- `ICO-COM-001`: ícone comum;
- `AUD-W01-001`: recurso de áudio do mundo 1.

Os exemplos ilustram sintaxe e não reservam IDs reais nem criam personagens, entidades ou assets canônicos. Antes de atribuir um ID, verificar unicidade no manifesto.

### 4.2 Nomes de arquivo

Convenção proposta:
`<asset_id>_<subject>_<state-or-variant>_v<major>.<ext>`

Regras:
- minúsculas ASCII e snake_case;
- sem espaços, acentos ou caracteres ambíguos;
- estado/variante explícito quando necessário;
- versão no registro de produção; não criar cópias concorrentes com nomes vagos como `final2`, `final_final` ou `new`;
- arquivos-fonte e exports devem ser distinguíveis;
- manter nomes estáveis após integração; renomear exige atualizar referências e manifesto.

Exemplo puramente esquemático: `chr_bolt_001_idle_v001.png`.

### 4.3 Organização proposta

A estrutura definitiva deve ser compatível com o projeto real e aprovada antes de movimentar arquivos existentes. A seguinte árvore é uma proposta para novos assets, não uma instrução para reorganizar recursos atuais:

```text
assets/
  manifest/
    asset-manifest.json
  source/
    characters/
    enemies/
    bosses/
    worlds/
    ui/
    vfx/
    audio/
  exports/
    characters/
    enemies/
    bosses/
    worlds/
    ui/
    vfx/
    audio/
  references/
    approved/
    rejected/
```

Separar fonte editável, export de runtime e referências. Não incluir arquivos-fonte pesados no pacote Android se não forem necessários ao runtime. Não duplicar assets por cena sem necessidade comprovada.

## 5. Especificação de imagem e spritesheet

### 5.1 Campos obrigatórios

Para cada imagem, registrar:
- largura e altura total em pixels;
- largura e altura de cada frame, quando animado;
- número de linhas e colunas;
- ordem de leitura dos frames;
- quantidade de frames úteis;
- alpha/transparência;
- espaço de margem e extrusão, se houver;
- pivô/origem por asset ou por frame;
- escala de apresentação prevista;
- filtro/import mode;
- formato-fonte e formato de runtime;
- compressão e motivo da escolha;
- proveniência, autoria e versão.

Não preencher dimensões nem FPS com números arbitrários. A direção de arte e o primeiro slice aprovado determinarão os valores globais e as exceções justificadas.

### 5.2 Grid e alinhamento

- Frames devem compartilhar uma grade consistente quando a animação exigir.
- Nenhum frame pode ser cortado por limites de célula.
- Margens devem impedir bleeding entre frames no modo de import escolhido.
- Pivôs precisam ser consistentes entre estados, salvo deslocamento intencional documentado.
- A posição dos pés/contato com o chão deve ser verificada em animações de locomoção, salto e aterrissagem.
- Drift de pivô, mudança involuntária de escala e halos de alpha são defeitos de export.
- O pivô visual não define a hitbox de gameplay.
- Colisões devem continuar configuradas em nós/recursos de física próprios, nunca inferidas automaticamente da silhueta artística sem decisão explícita.

### 5.3 Animação

Registrar por animação:
- ID e nome do estado;
- frames e ordem;
- FPS/duração;
- loop ou one-shot;
- frame/evento de início e término;
- pivô e alinhamento;
- condições de interrupção;
- prioridade em relação a outras animações;
- evento de gameplay sincronizado, se existir;
- versão aprovada.

O mapeamento de estado para animação pertence à especificação de gameplay/animação e não deve ser codificado como lógica de física dentro do arquivo de arte. A animação não pode alterar física, hitbox ou input essencial.

## 6. Tilesets, cenários e parallax

Para cada tileset ou kit ambiental:
- tamanho de célula e dimensões do atlas;
- margem/separação entre células;
- regra de autotile/terrain, se usada;
- variantes de borda, canto, topo e lateral;
- origem/pivô de props;
- camadas e ordem de desenho;
- colisões separadas da arte;
- tiles decorativos sem colisão identificados;
- regras de repetição e continuidade;
- escala e filtragem;
- licença/proveniência.

Para parallax:
- camada, ordem e fator de movimento;
- comportamento em limites de fase;
- regra de repetição;
- custo de transparência/overdraw a medir;
- proibição de simular plataformas, projéteis ou perigos no fundo.

Nenhuma dimensão de tile é fixada nesta versão; depende da resolução-base e do estilo aprovados.

## 7. UI, HUD, ícones e fontes

Registrar:
- função e contexto de uso;
- tamanho lógico e tamanho mínimo legível;
- estados (normal, pressionado, desabilitado, selecionado, foco, erro, sucesso);
- margens internas e área interativa;
- contraste em fundos claros/escuros;
- variações de idioma/texto;
- escala para Android paisagem;
- safe areas e regiões de gesto;
- comportamento em proporções de tela suportadas;
- licença da fonte e fallback.

Para botões touch, separar dimensão visual da área de toque e validar ambas. Não posicionar controles essenciais em áreas reservadas pelo sistema Android. Não depender apenas de cor para estado. O estilo visual final do HUD permanece sujeito à aprovação da Etapa 09.

## 8. VFX e feedback

Cada VFX deve declarar:
- evento que o dispara;
- função de feedback;
- posição/origem e orientação;
- duração e curva temporal;
- área ocupada;
- prioridade visual;
- limite simultâneo;
- possibilidade de interrupção;
- comportamento em pause/scene change;
- fallback ou redução de intensidade, quando aplicável;
- custo estimado e método de validação.

Efeitos de gameplay têm prioridade sobre atmosfera. VFX não pode ocultar BOLT, perigos, telegraphs, pickups, interativos ou informação essencial da HUD. Valores numéricos de partículas, duração e transparência dependem de medição e aprovação visual; não são definidos por palpite.

## 9. Áudio e fontes — metadados específicos

Áudio deve registrar:
- asset ID, função, mundo/sistema consumidor;
- formato-fonte e export;
- duração, sample rate, canais e tamanho;
- loop, ponto de loop e transições;
- loudness/nível relativo e prioridade;
- bus de destino;
- comportamento em pause, mute e mudança de cena;
- licença, autoria e proveniência.

Fontes devem registrar família, peso, licença, idiomas/glyph coverage, fallback, uso e tamanho de export. Não embutir famílias sem licença compatível.

## 10. Importação no Godot 4.7.2

### 10.1 Regras gerais

- O projeto Godot e suas configurações atuais são a autoridade para importação.
- Não alterar project settings globais para acomodar um único asset sem justificar impacto em todos os consumidores.
- Configurações específicas devem ser documentadas por categoria e validadas em build Android.
- Preservar fonte original e proveniência fora do caminho de runtime, quando possível.
- Verificar o resultado importado no editor e no build empacotado.
- Não editar manualmente arquivos gerados em `.godot/imported/`; são artefatos derivados.
- Não assumir que o preview do editor representa memória, qualidade ou custo no dispositivo.

### 10.2 Checklist de importação de textura

- [ ] Formato e alpha corretos.
- [ ] Sem halo, matte ou borda indesejada.
- [ ] Dimensões e frame grid conferidos.
- [ ] Filtro compatível com estilo aprovado.
- [ ] Mipmaps habilitados/desabilitados conforme uso e teste, não por padrão cego.
- [ ] Compressão escolhida considerando qualidade e plataforma Android.
- [ ] Atlas/region configurado sem bleeding.
- [ ] Pivô e escala conferidos em cena real.
- [ ] Referências e UID/import remap preservados pelo fluxo do Godot.
- [ ] Build Android abre e apresenta o recurso corretamente.

### 10.3 Política de compressão

Não existe um único formato ideal para todos os recursos. A escolha deve considerar transparência, arte pixelada ou contínua, artefatos visíveis, tamanho em memória, tamanho de pacote, suporte no renderer e custo de descompressão. Registrar a justificativa por classe de asset e validar em Android. Não declarar uma compressão vencedora sem comparação representativa.

### 10.4 Atlas e carregamento

- Agrupar por afinidade real de uso e ciclo de vida, não apenas por conveniência editorial.
- Evitar atlas monolítico que force carregamento de recursos não relacionados.
- Evitar fragmentação excessiva que multiplique overhead e draw state.
- Não criar preload global como consequência automática do pipeline.
- Respeitar SceneFlow e política de lifecycle existentes.
- Medir tempo de carregamento e custo de textura quando o asset/slice estiver disponível.

## 11. Budgets e método de estabelecimento

Budgets numéricos permanecem **TBD** até que estilo, resolução-base e slice representativo sejam aprovados.

Cada budget deverá conter:
- categoria e unidade;
- valor-alvo e limite máximo;
- escopo (por asset, personagem, fase ou build);
- dispositivo/ambiente de referência;
- método e ferramenta de medição;
- margem de segurança;
- qualidade visual mínima;
- data e versão do baseline;
- responsável pela aprovação.

Categorias a orçar:
- dimensões e memória de textura;
- tamanho de atlas e número de páginas;
- quantidade de frames e animações simultâneas;
- partículas e transparências;
- overdraw e draw calls;
- tamanho de áudio e memória de reprodução;
- tamanho total do pacote;
- tempo de import, carregamento inicial e troca de fase.

A primeira estimativa será uma hipótese documentada, nunca um resultado medido. O target Android inclui aparelhos de entrada; export CI não comprova desempenho físico.

## 12. Manifesto de assets

O manifesto é a fonte de rastreabilidade por asset. A fila de solicitações continua sendo o backlog; o manifesto acompanha cada recurso desde o brief até verificação.

### 12.1 Esquema mínimo

```json
{
  "schema_version": 1,
  "project": "BOLT · AVENTURA",
  "engine": "Godot 4.7.2",
  "assets": [
    {
      "asset_id": "CHR-BOLT-001",
      "name": "bolt",
      "category": "character",
      "consumer": "player",
      "status": "PLANNED",
      "version": null,
      "source_path": null,
      "runtime_path": null,
      "dimensions_px": null,
      "frame_size_px": null,
      "frames": null,
      "fps": null,
      "pivot": null,
      "alpha": null,
      "import_profile": null,
      "provenance": {
        "creator": null,
        "tool": null,
        "source_or_prompt_record": null,
        "license": null,
        "attribution": null
      },
      "approval": {
        "user": null,
        "version": null,
        "date": null,
        "scope": null
      },
      "integration": {
        "commit": null,
        "scene_references": [],
        "verification": null
      }
    }
  ]
}
```

O registro acima é um exemplo de estrutura e não declara que o asset exista, que esteja aprovado ou que o caminho esteja criado. Campos nulos permanecem nulos até haver evidência.

### 12.2 Regras de integridade

- `asset_id` único.
- `status` pertence à enumeração do pipeline.
- `APPROVED` exige versão, decisão e escopo.
- `INTEGRATED` exige aprovação, commit, caminho runtime e referência real.
- `VERIFIED` exige evidência e checklist.
- `REJECTED` preserva motivo e versão.
- Referências de cena devem apontar para arquivos existentes.
- Não sobrescrever histórico de versão aprovada.

## 13. Proveniência, direitos e segurança

Para cada asset, guardar autoria, ferramenta, origem, prompt/registro de criação, licença, atribuição e restrições. Não integrar recursos de origem desconhecida, assets copiados de jogos comerciais, fontes sem licença ou materiais cuja permissão de uso não esteja clara. Manter arquivos de licença/notices aplicáveis.

## 14. Templates operacionais

### 14.1 Brief de sprite/personagem

```yaml
asset_id: CHR-XXX-001
name: ""
category: character
consumer: ""
purpose: ""
status: SPECIFIED
visual_direction_reference: ""
approval_dependency: "Etapa 05 / decisão visual aplicável"
canvas_px: TBD
frame_px: TBD
rows: TBD
columns: TBD
frame_order: TBD
frame_count: TBD
fps: TBD
loop: TBD
alpha: TBD
pivot: TBD
safe_margin_px: TBD
presentation_scale: TBD
filter: TBD
compression: TBD
runtime_path: TBD
source_path: TBD
provenance:
  creator: ""
  tool: ""
  prompt_or_source_record: ""
  license: ""
  attribution: ""
approval:
  version: null
  decision: null
  date: null
```

### 14.2 Brief de tileset

```yaml
asset_id: TIL-WXX-001
name: ""
world_id: ""
consumer: ""
status: SPECIFIED
visual_direction_reference: ""
tile_size_px: TBD
atlas_size_px: TBD
margin_px: TBD
separation_px: TBD
terrain_or_autotile: TBD
collision_policy: "Separada da arte; referenciar contrato de gameplay"
layers: TBD
repeat_rules: TBD
filter: TBD
compression: TBD
runtime_path: TBD
provenance: {}
approval: null
```

### 14.3 Brief de VFX

```yaml
asset_id: VFX-XXX-001
name: ""
trigger_event: ""
gameplay_purpose: ""
status: SPECIFIED
duration_ms: TBD
world_space_size: TBD
orientation: TBD
priority: TBD
max_concurrent_instances: TBD
interrupt_policy: TBD
pause_policy: TBD
reduced_effect_fallback: TBD
runtime_path: TBD
provenance: {}
approval: null
```

## 15. Checklists de revisão

### 15.1 Revisão pré-concept

- [ ] Consumidor e finalidade identificados.
- [ ] Fonte canônica e dependências registradas.
- [ ] Decisões visuais aprovadas identificadas.
- [ ] Lacunas separadas de fatos.
- [ ] ID reservado após verificação de unicidade.
- [ ] Brief adequado à categoria.
- [ ] Direitos e referências autorizados.

### 15.2 Revisão do arquivo exportado

- [ ] Versão e nome corretos.
- [ ] Dimensões, alpha, margens e frames conferidos.
- [ ] Sem cortes, bleeding, halo ou artefatos.
- [ ] Pivôs e alinhamento coerentes.
- [ ] Proveniência completa.
- [ ] Compatível com o import profile documentado.
- [ ] Apresentado ao usuário se for concept/arte final.

### 15.3 Revisão pós-import

- [ ] Import concluído sem erro.
- [ ] Recurso referenciado corretamente.
- [ ] Escala, pivô e timing conferidos em contexto.
- [ ] Colisão continua independente da arte.
- [ ] Sem regressão de UI, input, safe area ou gameplay.
- [ ] Build Android validado quando aplicável.
- [ ] Manifesto, fila e PR atualizados.
- [ ] Evidência anexada ao registro.

## 16. Critérios de aceite da Etapa 06

A etapa pode ser considerada **IMPLEMENTADA** quando:
1. este guia cobre as categorias de assets do projeto;
2. nomenclatura, IDs, estrutura e ciclo de vida estão definidos;
3. os campos técnicos e templates permitem briefs sem adivinhação;
4. regras de import Godot, atlas, compressão, pivôs, alpha e animação estão documentadas;
5. manifesto e checklists estão definidos;
6. dependências da Etapa 05 e todos os TBD estão explícitos;
7. índice, fila e status de produção estão atualizados.

A etapa só pode ser considerada **VALIDADA** após revisão documental, consistência dos templates, verificação dos links/referências e CI documental aprovada. Não exige export Android, pois não altera runtime. A aprovação da Etapa 05 continua necessária antes de preencher parâmetros artísticos e iniciar produção final.

## 17. Pendências para fechar os parâmetros numéricos

- [ ] Aprovação da direção visual global da Etapa 05.
- [ ] Escolha da resolução lógica e escala de apresentação.
- [ ] Definição de dimensão-base de personagem e tile.
- [ ] Definição de FPS por classe de animação.
- [ ] Escolha de filtros e compressão por classe de asset.
- [ ] Produção e aprovação de um slice visual representativo.
- [ ] Medição de memória, tamanho, import e carregamento.
- [ ] Aprovação dos budgets iniciais.

## 18. Estado desta entrega

**Entregue:** guia técnico base, convenções, ciclo de vida, templates, manifesto, importação Godot, política de atlas/compressão, critérios de proveniência, checklists e critérios de aceite.

**Não entregue:** parâmetros numéricos finais, manifesto de assets reais, sprites, concepts, arte final, importação de recursos, budgets medidos ou aprovação artística.

**Próxima ação:** validar a documentação da Etapa 06; depois, com a Etapa 05 aprovada, consolidar os parâmetros dependentes e preparar o brief técnico do concept de BOLT (Etapa 07).
