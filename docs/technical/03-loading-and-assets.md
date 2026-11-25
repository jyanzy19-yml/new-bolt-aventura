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
