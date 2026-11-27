# Especificação técnica — carregamento, recursos e transições

## 1. Objetivo
Evitar travamentos perceptíveis durante gameplay transferindo trabalho pesado para transições controladas, sem criar espera artificial ou telas de carregamento sem progresso real.

## 2. Política de carregamento
- Identificar recursos necessários para a próxima cena/fase.
- Pré-carregar recursos previsíveis quando houver benefício mensurável.
- Carregar de forma assíncrona quando a API da versão do Godot permitir e a complexidade justificar.
- Mostrar progresso real quando disponível; caso contrário, usar estado de carregamento honesto sem porcentagem falsa.
- Manter input de gameplay bloqueado apenas durante a transição necessária.
- Tratar cancelamento, falha, falta de memória e retorno ao menu.
- Liberar recursos que não precisam permanecer em memória.

## 3. Shader e primeiro uso
Identificar stutter causado por compilação/importação/primeiro uso. Aquecer apenas os recursos relevantes e com medição. Não instanciar escondido um conjunto enorme de objetos apenas para mascarar compilação.

## 4. Transições
Definir estado visual, áudio, foco, bloqueio de input, fade, progresso, cancelamento e destino de cada transição. Garantir que múltiplos pedidos não iniciem carregamentos concorrentes incompatíveis.

## 5. Catálogo de assets
Cada asset deve ter ID, caminho, tipo, mundo/sistema, licença/proveniência, resolução/formato, import settings, tamanho, dependências e estado (placeholder, revisão, aprovado, integrado). Não usar assets de origem desconhecida ou licença incompatível.

## 6. Critérios de validação
Medir tempo de entrada, pico de memória, frame time após transição e primeira exibição de efeitos. Repetir em build Android e aparelho-alvo. Confirmar que o gameplay permanece responsivo após carregamento.


## 7. Implementação atual — Godot 4.7.2

- `SceneFlow` faz `ResourceLoader.load_threaded_request()`, publica progresso disponível e impede transições concorrentes.
- O autoload `LoadingOverlay` acompanha `transition_started`, `transition_finished` e `transition_failed`; permanece acima das cenas, captura input GUI/touch e apresenta estado/progresso real.
- A PR #42 integrou o input lock: pausa a SceneTree e oculta os controles touch durante a transição, para impedir ações de gameplay via teclado/touch; a retomada ocorre após `scene_changed`, e falha restaura o estado de pausa anterior.
- A porcentagem só aparece quando o `ResourceLoader` fornece progresso real. Sem esse dado, a interface mostra apenas estado de carregamento, sem estimativa inventada.
- O overlay não força duração mínima. Se o recurso carregar rápido, a transição termina rápido; se houver trabalho real, a interface permanece visível até sucesso/falha.
- A API `SceneFlow.change_scene(path, allow_cancel=true)` permite cancelar a troca de cena via `cancel_transition()`. O cancelamento é lógico: a API pública `ResourceLoader` não expõe cancelamento da thread; a transição permanece ocupada e o overlay mostra “Cancelando carregamento…” até a solicitação terminar. Quando carregada, a cena é recuperada e descartada sem ser instalada; o estado de pausa anterior é restaurado. Se a carga falhar, o fluxo termina pelo caminho de falha.
- O cancelamento não é uma política de descarregamento seletivo: recursos dependentes/cache podem continuar residentes segundo o cache do ResourceLoader. Não declarar redução de memória sem medição.
- **Pendências:** baseline de performance e memória em Android físico; avaliar preload/unload somente se medições demonstrarem necessidade. O cancelamento lógico da troca está implementado como opt-in, mas não interrompe o I/O threaded e ainda não possui controle visual de cancelamento definido.


## 8. Política de ciclo de vida — Etapa 05

A política vigente de preload, cache e liberação de referências está especificada em [11-resource-lifecycle-policy.md](11-resource-lifecycle-policy.md). O inventário atual não justifica preload global nem um gerenciador genérico de recursos. Manter SceneFlow threaded por cena, prewarm pontual do script do menu e liberação natural por ownership/refcount. Qualquer mudança deve ser motivada por captura comparável em Android físico; não usar CACHE_MODE_IGNORE como mecanismo de unload.
