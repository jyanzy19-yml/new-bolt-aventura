# Pipeline de assets — BOLT · AVENTURA

**Status:** workflow formal; inventário atual não comprova assets finais integrados.  
**Autoridade:** `MASTER_DIRECTIVE.md`, `32-stage-production-plan.md` e bíblias de design.  
**Regra crítica:** ChatGPT cria os assets visuais do jogo, apresenta cada entrega ao usuário e aguarda aprovação explícita antes de integrar no repositório/Godot.

## 1. Fontes de verdade
- Direção artística: `docs/game-design/07-art-audio-direction.md`.
- Especificações: bíblias de personagens, mundos e UI/UX.
- Planejamento: `docs/production/32-stage-production-plan.md`.
- Manifesto: inventário individual de assets; este pipeline define o processo, não declara assets existentes.

O manifesto do projeto deve ficar em caminho próprio (por exemplo `assets/asset-manifest.json`) quando a estrutura de assets for criada. Manifestos de skills são templates, não inventário de assets do jogo.

## 2. Estados do ciclo de vida

| Estado | Significado | Integração permitida |
|---|---|---:|
| `PLANNED` | Necessidade identificada | Não |
| `SPECIFIED` | Brief técnico/artístico definido | Não |
| `CONCEPT_CREATED` | Concept produzido | Não |
| `AWAITING_USER_APPROVAL` | Apresentado, aguardando usuário | Não |
| `REVISION_REQUESTED` | Ajustes solicitados | Não |
| `APPROVED` | Versão/escopo aprovado explicitamente | Sim, somente a versão aprovada |
| `INTEGRATED` | Importado e referenciado no projeto | Já integrado |
| `VERIFIED` | Critérios técnicos/visuais verificados | Já integrado |
| `REJECTED` | Rejeitado; motivo preservado | Não |
| `PLACEHOLDER` | Recurso temporário não final | Apenas uso provisório identificado |

Aprovação não é integração; integração não é verificação. Arquivo presente não prova aprovação.

## 3. Responsabilidades
### ChatGPT
- Criar os assets visuais originais solicitados.
- Produzir concepts, sprites, spritesheets, ambientes, VFX, ícones e elementos visuais.
- Apresentar cada entrega com ID, versão, função e contexto.
- Registrar feedback, revisar e reapresentar.
- Não integrar, substituir ou promover assets finais sem aprovação explícita.

### Usuário
Autoridade final de aprovação/rejeição. A aprovação vale apenas para a versão, finalidade e escopo apresentados.

### Claude e outros agentes
Podem implementar consumidores, cenas, layouts e lógica quando autorizados. Não podem contornar a aprovação nem substituir assets aprovados. Se precisarem de arte, devem abrir/atualizar a solicitação na fila.

## 4. Brief técnico por asset
Registrar, conforme aplicável:
- ID estável, nome e tipo;
- mundo/fase/sistema consumidor e função;
- direção visual e referências autorizadas;
- dimensões totais e por frame, proporção e resolução-base;
- transparência/alpha e formato;
- linhas/colunas, ordem de leitura, estados, frames e FPS;
- pivô, margens, alinhamento e escala;
- paleta, contraste e legibilidade em tela pequena;
- colisões/áreas de interação quando exigidas pelo contrato;
- compressão, filtros, atlas e import settings;
- budget de memória/custo quando pertinente;
- destino no repositório;
- autoria, ferramenta, prompt/registro de criação, licença e atribuição.

Não exigir propriedades de imagem para áudio, fonte ou dados. Omitir campos não aplicáveis.

## 5. Fluxo obrigatório
1. Registrar necessidade, prioridade e consumidor na fila.
2. Especificar brief técnico/artístico e dependências.
3. Criar concept sem integrá-lo ao projeto.
4. Apresentar ao usuário com ID/versão e contexto.
5. Aguardar decisão inequívoca; silêncio não é aprovação.
6. Aplicar feedback e reapresentar, preservando versões.
7. Registrar aprovação explícita para a versão exata.
8. Integrar somente essa versão em branch/PR rastreável.
9. Verificar import, alpha, pivô, frames, escala, legibilidade e referências.
10. Testar em Android quando leitura/performance forem afetadas.
11. Atualizar manifesto, fila, tracker, proveniência e commit.

Não constituem aprovação: pedido para criar; aprovação de outro asset; avaliação positiva de versão anterior; geração sem erro; arquivo anexado ou incluído em ZIP/branch por engano.

## 6. Spritesheets e animação
Registrar tamanho total e por frame, linhas/colunas, ordem, alpha, pivô, margem, FPS, duração, estados, alinhamento, escala de importação, origem e versão aprovada. Verificar frames cortados, bordas, variação involuntária de escala, drift de pivô, halos de transparência e inconsistência de silhueta. Não inferir colisões finais pela arte.

## 7. Direitos e proveniência
Não integrar sem origem/licença identificáveis. Registrar autoria, ferramenta/URL, licença, atribuição e restrições; preservar notices. Para geração original, guardar prompt/registro e versão. Não copiar materiais protegidos sem autorização.

## 8. Critério de integração/verificação
Marcar `INTEGRATED` somente se aprovação explícita, versão correta, caminho, import settings, proveniência, referências e commit/PR estiverem registrados. Marcar `VERIFIED` após testes aplicáveis em escala nativa, Godot e, quando necessário, Android físico.

## 9. Inventário inicial
O snapshot auditado em 27/11/2026 identificou 20 arquivos de cena/recurso em `scenes/` e `resources/`, sem diretórios `assets/` ou `audio/` nem catálogo de sprites/áudio importados. W1-L1/W1-L2 continuam blockouts. Revalidar o inventário antes de afirmar o estado atual.

**Distinção obrigatória:** placeholder é temporário; concept é proposta; aprovação é decisão do usuário; integração é alteração no repositório; verificação é evidência.
