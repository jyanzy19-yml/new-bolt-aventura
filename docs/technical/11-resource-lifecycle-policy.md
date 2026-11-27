# Política de ciclo de vida de recursos — Etapa 05

**Baseline auditada:** main após PR #69 e PR #70, commit `5e55fa1693d8ecf6d8a1d79bfffa1999824ad1ea`.  
**Engine:** Godot 4.7.2.  
**Escopo:** recursos de cenas, dependências, preload, cache e liberação de referências.  
**Natureza:** decisão técnica baseada no inventário atual; não constitui prova de desempenho em Android físico.

## 1. Inventário observado

A inspeção recursiva do repositório identificou 20 arquivos de cena/recurso sob `scenes/` e `resources/`, todos pequenos arquivos de texto Godot. Não há diretórios `assets/` ou `audio/` nem catálogo de texturas, spritesheets, fontes importadas ou streams de áudio no baseline auditado. A identidade visual corrente é majoritariamente construída com nós geométricos, cores e controles; isso é consistente com o estado de blockout registrado para W1-L1 e W1-L2.

As cenas de campanha declaram dependências diretas por `ext_resource`:
- W1-L1: script da fase, PlatformBlock, player, HUD, checkpoint, inimigo de patrulha e pickup.
- W1-L2: script da fase, PlatformBlock, player, HUD, checkpoint e TimedEnergyGate.
- Tutorial: script, PlatformBlock, player, HUD e TrainingTarget.
- HUD e LoadingOverlay são recursos de cena usados por composição/autoload.

O Boot carrega o script leve de MainMenu na thread principal antes de solicitar a cena do menu por SceneFlow. SceneFlow usa `ResourceLoader.load_threaded_request()` com o cache mode padrão (`CACHE_MODE_REUSE`) e impede solicitações de transição concorrentes.

## 2. Decisão de preload

**Não introduzir preload global de fases nem um gerenciador genérico de preload neste estágio.**

Justificativa:
1. O inventário atual não contém bibliotecas pesadas de arte/áudio que justifiquem retenção antecipada.
2. As dependências estruturais de cada fase já estão declaradas na própria PackedScene e são resolvidas pelo carregamento da cena.
3. SceneFlow já carrega a PackedScene de destino em thread durante uma transição, com progresso real quando disponível.
4. O único prewarm explícito mantido é o script leve de MainMenu no Boot, cuja finalidade é evitar disputa de compilação/carregamento do script durante a transição threaded de cold start.
5. Sem captura de primeiro uso, tempo de transição e memória, preload adicional aumentaria o conjunto residente sem benefício demonstrado.

### Regras

- Usar `preload()` apenas para dependências pequenas, estáticas e indispensáveis à execução do script, quando a semântica de carregamento antecipado for intencional.
- Não adicionar PackedScenes de fases, catálogos inteiros ou assets opcionais a autoloads por conveniência.
- Para navegação entre cenas, manter SceneFlow como proprietário da transição e o carregamento threaded existente.
- Usar o cache padrão de reutilização salvo necessidade específica documentada e medida.
- Qualquer futura política de preload deve declarar o conjunto exato de recursos, momento de aquisição, owner, memória incremental, benefício de latência e condição de liberação.

## 3. Política de liberação e cache

Godot mantém recursos carregados em cache por caminho. Recursos derivam de RefCounted e são liberados quando deixam de possuir referências; a entrada correspondente pode sair do cache quando todas as referências forem liberadas.

Consequentemente, a política atual é **liberação por ownership e ciclo de vida**, não limpeza global forçada:

1. Ao sair de uma fase, permitir que SceneTree remova a cena anterior e seus Nodes.
2. Não manter referências fortes a PackedScenes, Resources ou Nodes de fases concluídas em autoloads sem requisito explícito.
3. Não copiar recursos de fase para singletons globais.
4. Quando uma referência temporária deixar de ser necessária, limpá-la no owner que a adquiriu.
5. Verificar `ResourceLoader.has_cached(path)` e `get_cached_ref(path)` somente como observabilidade do cache, não como prova isolada de vazamento.
6. Não tratar `CACHE_MODE_IGNORE` como mecanismo de unload: esse modo altera a política de consulta/armazenamento do carregamento e pode produzir instâncias distintas; não remove referências existentes nem descarrega um recurso já retido.
7. Não implementar rotina de purge ou unload genérico sem identificar ownership, dependências compartilhadas e evidência de retenção indevida.

A API pública ResourceLoader documenta carregamento, estado de cache e modos de cache, mas não oferece método genérico `unload(path)`. A liberação depende de encerrar referências reais. Não declarar memória recuperada sem medir o processo.

## 4. Relação com cancelamento de transição

A PR #69 implementa cancelamento lógico da troca, não interrupção do I/O threaded. Ao terminar a operação, SceneFlow drena a solicitação com `load_threaded_get()` e não instala a cena de destino. O cancelamento não garante, por si só, que todos os recursos dependentes deixem o cache; isso depende de referências remanescentes e do ciclo de vida do Resource.

## 5. Protocolo de medição

A PR #70 adiciona `PerformanceProbe`, ativo somente em builds debug, com janela de 600 amostras de frame time e monitores de runtime. O probe não mede RSS total Android, GPU frame time, temperatura, throttling ou consumo energético.

Para cada futura decisão de preload/unload:

1. Registrar commit, aparelho/SoC/RAM, versão Android, renderer, resolução e build.
2. Definir uma sequência fixa: cold boot → menu → fase → retorno ao menu → reentrada na fase.
3. Capturar frame time e monitores de memória antes/depois de cada transição.
4. Repetir ao menos três ciclos comparáveis, incluindo cold start e reentrada com cache aquecido.
5. Comparar tempo de transição, p95/p99, máximo e memória; separar memória do engine de RSS do processo quando a ferramenta do dispositivo permitir.
6. Registrar se a mudança reduziu pico/retensão sem elevar stutter, tempo de carregamento ou custo de CPU.
7. Não converter uma leitura isolada do cache ou de MEMORY_STATIC em conclusão de unload.

Template: `docs/qa/performance-capture-template.md`.

## 6. Gatilhos para revisar a política

Reavaliar preload/unload quando pelo menos uma destas condições existir:
- spritesheets, áudio, fontes, partículas ou ambientes de tamanho relevante forem adicionados;
- o grafo de dependências de uma fase crescer significativamente;
- capturas físicas demonstrarem stutter recorrente na primeira exibição de um recurso;
- a memória permanecer elevada após ciclos de saída/entrada, com referências identificadas;
- o projeto introduzir hubs, mundos persistentes ou streaming de segmentos.

A revisão deve ser acompanhada por inventário atualizado, hipótese mensurável, owner explícito e testes de regressão.

## 7. Fontes técnicas

- [Godot 4.7 — ResourceLoader](https://docs.godotengine.org/en/4.7/classes/class_resourceloader.html): modos CACHE_MODE_REUSE/IGNORE, consultas de cache e API de carregamento threaded.
- [Godot — Resource](https://docs.godotengine.org/en/stable/classes/class_resource.html): referência contada e remoção do cache quando todas as referências são liberadas.

**Conclusão:** no baseline atual, a opção de menor risco é manter carregamento threaded por cena, prewarm pontual do script de menu e liberação natural por referência. Não há evidência que justifique preload global, cache manager ou unload forçado.


## 8. Telemetria de transições em builds debug — Etapa 29

A implementação complementar da Etapa 29 amplia o `PerformanceProbe` sem alterar o proprietário do carregamento:

- O probe observa os sinais existentes de `SceneFlow`: início, conclusão, falha e cancelamento.
- Cada transição concluída registra caminho, resultado, duração monotônica em milissegundos e `Performance.MEMORY_STATIC` antes/depois.
- O histórico mantém no máximo 32 registros; os mais antigos são descartados.
- O snapshot calcula p95 de duração sob demanda. Nenhuma ordenação ou alocação do histórico ocorre no loop de frame.
- A telemetria é debug-only e não altera destino, pausa, cancelamento, troca de cena, cache, ownership ou referências de recursos.
- `MEMORY_STATIC` é um monitor do engine, não RSS do processo Android. A diferença antes/depois não comprova unload nem ausência de vazamento.
- O teste automatizado injeta os quatro resultados possíveis pelo contrato de sinais e verifica o limite de retenção. A captura física continua necessária para RSS, GPU, temperatura e frame pacing.

A instrumentação fornece evidência comparável de duração de transições no runtime debug e prepara a sequência de medição descrita na seção 5. Ela não autoriza preload global, cache manager ou purge de recursos.
