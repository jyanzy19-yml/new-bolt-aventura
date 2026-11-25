# Pipeline de assets — BOLT · AVENTURA

**Status:** padrão preparado; nenhum asset final do jogo foi confirmado.

## Fonte de verdade

O manifesto do projeto deve ficar em caminho próprio do jogo, por exemplo assets/asset-manifest.json, depois da criação do projeto Godot. O manifesto em .claude/skills/create-game-assets/assets/asset-manifest.json é referência/template da skill; não é inventário de assets já integrados.

## Campos mínimos

- id: identificador estável e único.
- role: função no jogo.
- path: caminho relativo no projeto.
- status: planned, placeholder, review, approved, integrated ou rejected.
- technical: dimensões, transparência, pivô, frames, escala e filtragem quando aplicável.
- source: origem, ferramenta/URL, criador, data, licença, atribuição e registro de prompt/fonte.
- verification: revisão em escala nativa, revisão no Godot, verificações técnicas e responsável.

Adaptar campos para áudio, fontes, tilesets, animações e shaders; não exigir propriedades de imagem para recursos que não as possuem.

## Estados

| Estado | Significado |
|---|---|
| planned | Necessidade identificada; arquivo não existe |
| placeholder | Recurso temporário identificado |
| review | Arquivo recebido e aguardando avaliação |
| approved | Conteúdo aprovado, ainda não necessariamente integrado |
| integrated | Importado/usado no projeto e validado |
| rejected | Não usar; motivo registrado |

Arquivo presente não significa aprovado ou integrado. Placeholder nunca é arte final.

## Fluxo

1. Criar necessidade rastreável por mundo, fase ou sistema.
2. Especificar função, dimensões, pivô, frames, paleta, estilo e destino.
3. Confirmar origem legítima e licença antes de integrar.
4. Revisar consistência visual em escala nativa.
5. Importar no Godot com settings da versão real.
6. Verificar transparência, pivôs, margens, atlas, compressão, filtros, áudio e dependências.
7. Inspecionar em cena e em aparelho quando aplicável.
8. Atualizar manifesto, tracker, handoff e evidências.

## Direitos e proveniência

Não integrar assets sem origem/licença identificável. Registrar autoria, URL/ferramenta, licença, atribuição e restrições. Preservar notices de terceiros. Para geração original, preservar prompt/registro de criação. Não guardar segredos ou dados pessoais no manifesto.

## Critério de integração

Marcar integrated somente quando caminho existe, origem/licença estão preenchidas, import settings foram revisados, recurso foi aberto no Godot, uso em cena foi inspecionado e responsável/commit estão registrados.

A auditoria atual encontrou zero imagens, áudio ou fontes de jogo; não há assets finais integrados a declarar.
