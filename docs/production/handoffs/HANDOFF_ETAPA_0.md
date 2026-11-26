# Handoff — Etapa 0 (Claude Code → ChatGPT)

## Identificação e estado final

- **Responsável:** Claude Code.
- **Etapa:** 0 — fundação Godot e protótipo técnico inicial.
- **Repositório/branch de integração:** `jyanzy19-yml/new-bolt-aventura`, `main`.
- **Commit-base registrado:** `16d42de2f2b5b3a52411f7d13db6d37b3a38b9d3`.
- **Commits principais de entrega:** `7057532` (fundação), `c32a99d` (base provisória de gameplay/testes/docs), `ab72c58` (ajustes posteriores).
- **Estado:** **ACCEPTED** pelo responsável da Etapa 1. O aceite não significa vertical slice, APK, campanha ou validação física concluídos.

## Exceção de escopo — resolvida

O §5 do checklist original restringia a Etapa 0 à fundação e proibia antecipar gameplay. Durante a execução, o usuário solicitou explicitamente uma base com personagem, movimento, câmera, touch, HUD e um primeiro cenário funcional. Claude implementou parte desse escopo adicional como protótipo provisório.

**Decisão de aceite:** a Etapa 1 inspecionou a entrega e aceitou a ampliação como exceção específica solicitada pelo usuário. Portanto, a antiga pendência “ChatGPT: aceite ou reverta explicitamente” está resolvida. Isso não altera a regra de que a sandbox é cenário de desenvolvimento, não fase da campanha, e não canoniza parâmetros, layout touch ou interpretação de “All Jump”.

## Implementado na Etapa 0

- Projeto Godot 4.7.2, GDScript, configuração Android/paisagem e renderer GL Compatibility provisório.
- `project.godot`, Input Map, boot, menu e autoload `SceneFlow`.
- `SafeAreaMargin`, `TouchControls`, `TouchButton`, `ActionBuffer`.
- `BoltPlayer`, `BoltTuning` provisório, câmera e geometria de plataforma.
- Sandbox de movimento e HUD de desenvolvimento.
- Testes headless iniciais.

## Não implementado na Etapa 0

Campanha/fases W#-L#, combate, armas funcionais, inimigos, chefes, NPCs, checkpoints persistentes, save/load, áudio final, animação final, assets finais, APK exportado/instalado e QA físico Android.

## Valores e decisões que continuam provisórios

- Todos os valores de `BoltTuning`, janelas de buffer/coyote e layout/tamanho dos botões touch.
- Geometria e percurso da sandbox.
- Regra de pulo durante dash.
- Interpretação de “All Jump” como pulo duplo, sem confirmação de fonte canônica.
- Viewport 960×540, renderer final e ABI além de arm64-v8a.
- Package ID atual é placeholder `com.example.boltaventura`; precisa ser definido antes de distribuição.

## Validação original da Etapa 0

| Verificação | Resultado declarado no handoff original | Limite |
|---|---|---|
| Import/headless | Godot 4.7.2, sem erros | Não comprova renderização |
| Runner inicial | 41 testes, 167 verificações, 0 falhas | Estado do runner naquele commit |
| Testes de mutação | 5 alterações deliberadas detectadas | Evidência do ambiente de desenvolvimento |
| Boot repetido | 20 execuções, 0 erros observados | Não comprova Android |
| Sandbox com bot | Percurso sintético concluído | Não comprova sensação de controle |
| Editor gráfico/renderização | NÃO EXECUTADO | — |
| Toque físico, barras, FPS e memória | NÃO EXECUTADO | — |
| Exportação APK | BLOQUEADA por SDK/templates ausentes no ambiente | Nenhum APK foi produzido |

**Nível máximo original: L2 (headless).**

## Validação posterior pela Etapa 1

A Etapa 1 corrigiu um defeito de reatribuição do mesmo índice de ponteiro em `TouchControls`, adicionou teste de regressão e atualizou o CI para executar a suíte. No Godot CI Run #36, commit `624edce`, a importação e a suíte passaram: **42 testes, 171 verificações, 0 falhas**. Docs CI Run #124 também passou. Essa validação posterior não deve ser atribuída retroativamente à execução original da Etapa 0.

## Achados e riscos conhecidos

- Defeito S3 de reatribuição de índice de ponteiro foi corrigido na Etapa 1 e coberto por regressão.
- Coordenadas touch, safe areas, orientação/reversão, barras Android, retomada após interrupções e desempenho ainda exigem dispositivo real.
- O ajuste `Input.use_accumulated_input = false` não possui medição de latência/custo em aparelho.
- Tuning e layout continuam provisórios; sensação de controle não foi avaliada por teste humano documentado.
- O bot da sandbox prova apenas que o percurso sintético é transponível.

## Decisões pendentes do produto

1. Package ID definitivo.
2. Resolução-base/escala final de pixel art.
3. Renderer final após medição em hardware.
4. ABI(s) necessárias além de arm64-v8a.
5. Semântica canônica de “All Jump” conforme as fontes aprovadas.

A decisão sobre aceitar a ampliação de escopo da Etapa 0 **não está mais pendente**.

## Próximo turno

A Etapa 1 foi entregue. O próximo responsável é Claude Code — Etapa 2. Deve auditar o HEAD atual e o handoff da Etapa 1, preservar correções existentes e continuar o Gate 1/vertical slice conforme o roadmap. Não declarar Android validado até haver evidência física.
