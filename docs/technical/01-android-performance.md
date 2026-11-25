# Especificação técnica — Android e desempenho

## 1. Plataforma
Produto destinado a aplicativo Android empacotado. Não tratar navegador móvel como alvo. A integração final depende da arquitetura real do projeto e do fluxo de exportação Godot aprovado.

## 2. Hardware-alvo
- Referência: cerca de 4 GB de RAM.
- Referência de SoC: MediaTek Helio G99 ou inferior.
- Considerar variação de GPU, resolução, armazenamento, versão Android, temperatura e throttling.
- Não declarar compatibilidade universal com base em um único aparelho.

## 3. Meta de frame time
- Meta preferencial: 60 FPS quando o aparelho conseguir sustentar.
- Orçamento matemático de 60 FPS: aproximadamente 16,67 ms por frame.
- Medir CPU e GPU separadamente quando possível.
- A estabilidade sustentada e a responsividade são mais importantes que um pico breve de FPS.
- Definir fallback de qualidade/frame cap apenas após testes e aprovação; não reduzir automaticamente qualidade sem critério.

## 4. Método obrigatório de otimização
1. Reproduzir a cena/problema com build e sequência conhecidos.
2. Registrar aparelho, versão, renderer, resolução, duração e condições térmicas.
3. Capturar frame time e separar CPU/GPU.
4. Registrar média e percentis (p95/p99), além de picos.
5. Medir memória e evolução ao longo de sessão.
6. Corrigir o maior gargalo identificado.
7. Repetir a mesma medição e comparar.
8. Reverter mudanças que piorem resultado ou alterem gameplay sem aprovação.

Não declarar que um aparelho sustenta 60 FPS sem teste prolongado nele.

## 5. Áreas prioritárias
- Alocação de objetos em loops quentes e criação/destruição frequente.
- Quantidade de nós ativos e atualizações por frame.
- Partículas, transparências, overdraw e resolução de render.
- Texturas, atlas, import settings e memória de áudio.
- Carregamento de cenas, shaders e recursos em primeiro uso.
- Física e colisões desnecessárias.
- IA e sensores atualizados com frequência maior que a necessária.
- Sinais/conexões duplicadas e referências não liberadas.
- Persistência e serialização fora do caminho crítico de frame.

## 6. Orçamento de memória
Não inventar um limite universal de RAM. Medir memória do processo e recursos em dispositivos de referência; manter margem para Android, serviços de fundo e variações de aparelho. Registrar tamanho de texturas, áudio, cenas e picos de carregamento.

## 7. Sessão longa e térmica
Executar sessões prolongadas em Android real. Comparar frame time e memória no início e após aquecimento. Verificar se há queda gradual, stutter recorrente, crescimento de memória ou perda de responsividade.

## 8. Relatório obrigatório
Aparelho/SoC/RAM; versão Android; versão Godot; renderer; build; cena; duração; método; média/p95/p99/max; CPU/GPU; memória inicial/final/pico; temperatura/condições se disponível; alteração aplicada; comparação; limitações.
