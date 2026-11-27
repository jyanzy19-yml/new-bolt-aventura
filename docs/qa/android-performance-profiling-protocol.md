# Protocolo de profiling Android — Etapa 29

**Projeto:** BOLT · AVENTURA  
**Engine:** Godot 4.7.2  
**Plataforma-alvo:** aplicativo Android nativo, orientação paisagem  
**Escopo:** estabelecer uma captura reproduzível de CPU, frame pacing, memória e estabilidade em aparelho físico antes de qualquer otimização baseada em hipótese.  
**Estado:** protocolo documental; nenhuma medição física é declarada por este documento.

## 1. Objetivo e princípio de validade

Este protocolo transforma a instrumentação existente em evidência comparável entre builds. O objetivo não é produzir um número isolado de FPS, mas identificar em quais cenas, transições e condições o custo cresce, separar gargalos de CPU/GPU/memória e verificar se uma alteração melhora o resultado sem degradar controles, física, carregamento ou estabilidade.

A meta de 60 FPS é um alvo, não uma propriedade presumida. A referência temporal correspondente é 16,67 ms por frame. Um aparelho só pode ser declarado capaz de sustentar 60 FPS quando a cena, a duração, a versão do aparelho, as condições térmicas e os resultados de frame time estiverem registrados. APK exportado por CI, execução headless e métricas do editor não substituem esta captura.

## 2. Instrumentação disponível e limites

O autoload `PerformanceProbe` existente:

- só coleta quando `OS.is_debug_build()` permite;
- mantém uma janela circular de 600 amostras de frame time;
- calcula média, p95, p99, máximo e FPS derivado da média sob demanda;
- amostra monitores de memória estática, objetos, nós, draw calls, render objects e tempos de processamento a cada 30 frames;
- não ordena a janela durante o loop de frame; a ordenação ocorre ao solicitar o snapshot.

**Não interpretar os seguintes campos como métricas que não são:** `memory_static_bytes` não é RSS total do processo Android nem memória GPU; draw calls não equivalem a GPU frame time; `fps_from_average` não descreve estabilidade de frame pacing; amostras do probe não isolam por si só CPU, GPU, compositor ou espera de VSync. O probe não mede temperatura, throttling, energia, latência física de toque nem consumo total de memória do dispositivo.

Para completar a observação, registrar métricas externas do Android quando disponíveis, identificando a ferramenta e sua configuração. Não misturar medições de ferramentas diferentes sem registrar essa diferença.

## 3. Identificação obrigatória da captura

Cada execução deve registrar:

| Campo | Valor obrigatório |
|---|---|
| Commit | SHA completo da build testada |
| Artefato | Nome do APK e SHA-256 |
| Tipo de build | Debug ou release; não comparar tipos diferentes como se fossem equivalentes |
| Godot | Versão exata (baseline 4.7.2) |
| Renderer | Renderer efetivo no aparelho |
| Dispositivo | Fabricante, modelo e codinome, se disponível |
| SoC/GPU | Modelo exato |
| RAM | Capacidade física reportada |
| Android | Versão e nível de API |
| Display | Resolução, taxa de atualização e orientação |
| Estado térmico | Frio/estabilizado/aquecido, com observação |
| Energia | Bateria, carregamento conectado ou desconectado |
| Configuração | VSync/frame cap e opções relevantes |
| Cena | ID/nome e sequência executada |
| Duração | Tempo por cenário e duração total |
| Repetição | Índice da repetição e quantidade total |

Não publicar identificadores pessoais do aparelho. Identifique-o pelo modelo e configuração técnica.

## 4. Preparação controlada

1. Escolher um aparelho representativo do limite inferior da matriz-alvo e registrar seu SoC/RAM reais. Não usar estimativa de localização ou nome comercial como substituto do modelo exato.
2. Instalar um APK identificado por commit e hash. Confirmar que a instalação terminou e que o app abre; registrar falhas em vez de descartá-las.
3. Manter a mesma resolução, orientação, renderer, taxa de atualização e configuração de energia durante a série comparável.
4. Registrar se o aparelho está conectado ao carregador. Não alternar essa condição entre baseline e comparação.
5. Permitir que a temperatura se estabilize antes da primeira série. Registrar aquecimento durante as repetições; não comparar uma execução fria com outra sob throttling sem marcar a diferença.
6. Fechar ou registrar aplicativos de fundo relevantes. Não executar atualizações, downloads ou gravações paralelas durante a captura.
7. Não limpar dados do aplicativo para simular cold start. Force-stop/reabertura testa processo frio preservando a distinção entre cold process e reset de save. Testes de save/reset devem ser separados.
8. Confirmar que o probe está habilitado na build de desenvolvimento e que a solicitação de snapshot não está sendo executada continuamente durante a medição.

## 5. Cenários mínimos

Executar cada cenário separadamente e registrar início/fim. Não fundir resultados de cenas distintas em uma única média.

### P0 — Inicialização fria do processo

- Force-stop do aplicativo.
- Iniciar pelo launcher.
- Registrar tempo entre acionamento e primeiro frame utilizável do menu.
- Registrar travamentos, tela vazia, overlay e erros.
- Repetir sem limpar dados ou saves.

### P1 — Menu em repouso

- Permanecer no menu sem interação por 60 segundos.
- Capturar frame time, memória e estabilidade.
- Observar crescimento contínuo de objetos/nós ou memória sem atividade que o justifique.

### P2 — Entrada e permanência em fase

- Iniciar a fase de campanha disponível.
- Registrar tempo de transição e primeiro frame jogável.
- Permanecer 120 segundos em uma sequência repetível.
- Repetir a mesma rota e ações de input em cada execução.

### P3 — Cena com maior densidade disponível

- Selecionar, entre as cenas implementadas, a que tiver maior densidade observável de nós, colisões, elementos ativos ou draw calls.
- Registrar o critério que justificou a seleção.
- Não criar conteúdo novo nem chamar sandbox de fase de campanha.
- Se não houver cena suficientemente representativa, registrar a lacuna.

### P4 — Saída e reentrada

- Sair da fase pelo fluxo normal.
- Retornar ao menu e entrar novamente na mesma fase.
- Capturar memória e frame time após cada transição.
- Comparar primeira entrada com reentrada aquecida; não assumir que cache aquecido é vazamento ou melhoria sem observar o ciclo completo.

### P5 — Sessão contínua

- Executar 10 minutos de uso contínuo em rota repetível.
- Registrar frame time em intervalos fixos e comportamento térmico.
- Observar degradação progressiva, pausas, travamentos, perda de input e erros.
- Se a sessão for interrompida, registrar a causa e a duração efetivamente concluída.

## 6. Repetibilidade e coleta

- Executar no mínimo três repetições comparáveis por cenário.
- Fazer reset da janela do `PerformanceProbe` imediatamente antes de cada trecho medido.
- Coletar um snapshot ao final de cada trecho; preservar também os valores por repetição, sem substituir todos por uma média agregada.
- Como a janela contém 600 frames, registrar o número real de amostras. A 60 FPS, 600 amostras representam aproximadamente 10 segundos, mas a duração real varia com o frame rate.
- Para cenários longos, coletar snapshots em intervalos previamente definidos e iguais entre repetições.
- Registrar média, p95, p99 e máximo de frame time. Priorizar distribuição e picos, não apenas FPS médio.
- Registrar memória inicial, final e pico usando a mesma ferramenta externa e a mesma definição de métrica em todas as comparações.
- Se um dado não estiver disponível, marcar **NÃO MEDIDO**; não estimar nem preencher com zero.

## 7. Testes de responsividade e integridade

Durante uma execução separada da captura de performance, verificar:

- movimento contínuo enquanto salto é acionado;
- salto e Dash em sequência e durante movimento;
- entradas simultâneas em multitouch;
- resposta após pequenas quedas de frame rate;
- ausência de input preso após abrir/fechar pausa;
- retorno correto após alternar foco, bloquear/desbloquear tela e retomar o aplicativo.

Registrar o intervalo entre evento de toque e feedback observável somente quando houver método de medição identificado. Vídeo externo em alta taxa de quadros ou instrumentação temporal específica pode ser usado, mas o método, a taxa real e a incerteza precisam constar no relatório. Sem medição, classificar apenas como teste funcional qualitativo; não declarar latência em milissegundos.

A captura não autoriza modificar física, Dash, InputMap, IDs persistentes, save schema, safe areas ou política das barras do sistema. Regressões funcionais invalidam a otimização mesmo que o frame time melhore.

## 8. Interpretação e critérios de decisão

- **Frame time:** 16,67 ms é o orçamento nominal de 60 FPS. p95/p99 acima desse valor indicam que uma parcela relevante dos frames excede o orçamento; o máximo identifica picos, mas deve ser interpretado com o contexto da captura.
- **CPU:** comparar tempo de processamento do engine com frame time e evidência externa. Não atribuir automaticamente toda diferença à GPU.
- **GPU:** exigir ferramenta que reporte GPU frame time ou evidência equivalente. Draw calls isoladas não provam gargalo de GPU.
- **Memória:** distinguir memória estática do Godot, heap, RSS/PSS do processo e memória gráfica. Não somar métricas com definições sobrepostas.
- **Crescimento:** comparar menu → fase → menu → reentrada e sessões repetidas. Investigar ownership/referências antes de propor unload ou purge.
- **Temperatura:** associar queda sustentada de desempenho à evolução térmica e ao estado de throttling reportado; sem telemetria, registrar apenas observação e incerteza.
- **Comparação antes/depois:** usar mesmo aparelho, build type, renderer, resolução, cenário, sequência, duração, condição térmica e ferramenta. Alterar uma variável por vez sempre que possível.
- **Aprovação:** otimização só é candidata a aceite quando melhora uma métrica-alvo de forma repetível, não introduz regressão funcional e não piora materialmente outras métricas ou transições.

Não estabelecer um limite absoluto de RSS, GPU ou temperatura sem baseline medido e especificação do aparelho. Não declarar “60 FPS estáveis” com base apenas na média.

## 9. Formato do relatório por execução

Usar `docs/qa/performance-capture-template.md` e anexar:

1. identificação completa e hash do APK;
2. cenário e passos exatos;
3. três repetições com amostras individuais;
4. snapshots do PerformanceProbe;
5. medições externas e nome/configuração da ferramenta;
6. frame time médio, p95, p99 e máximo;
7. memória por métrica claramente identificada;
8. condição térmica antes/depois;
9. falhas, stutters, interrupções e observações de input;
10. limitações e dados não medidos.

Manter relatórios brutos por execução. Qualquer resumo agregado deve apontar para as capturas de origem.

## 10. Gate de otimização

Antes de alterar runtime:

- [ ] baseline reproduzível registrada;
- [ ] gargalo demonstrado por pelo menos uma métrica pertinente;
- [ ] hipótese causal escrita;
- [ ] variável a alterar isolada;
- [ ] risco para física, controles, carregamento e memória avaliado.

Depois de alterar runtime:

- [ ] mesmos cenários repetidos no mesmo aparelho;
- [ ] comparação antes/depois anexada;
- [ ] regressão Godot/headless aprovada;
- [ ] export Android validado em CI;
- [ ] regressões funcionais verificadas;
- [ ] documentação, tracker e continuidade atualizados.

Sem aparelho físico ou evidência equivalente, o trabalho permitido limita-se a preparar instrumentação, corrigir defeitos demonstrados por testes e formular hipóteses. Não executar tuning especulativo nem marcar profiling Android como concluído.

## 11. Estado inicial conhecido

No baseline documental disponível:

- Godot 4.7.2 e renderer GL Compatibility estão configurados.
- `PerformanceProbe` está registrado como autoload e é debug-only.
- O probe cobre frame time e monitores internos, mas não RSS total Android, GPU frame time, temperatura, throttling, energia ou latência de toque.
- A política de recursos recomenda carregamento threaded por cena e liberação por ownership/referências; não há evidência que justifique preload global ou unload forçado.
- Não existe, neste checkpoint, relatório de profiling físico validado para o aparelho-alvo.

**Conclusão:** este protocolo prepara uma medição controlada e auditável. Não representa resultado de benchmark, aprovação de Gate 1, conclusão da Etapa 29 ou prova de desempenho em qualquer aparelho.
