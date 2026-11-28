# Pipeline de assets e proveniência

## Princípios
Todo asset final precisa de origem conhecida, licença compatível, aprovação da versão exata e referência estável. Placeholder deve ser marcado como placeholder. Não copiar assets de jogos comerciais ou fontes sem permissão.

## Manifesto recomendado
Cada registro deve conter:
- `id` estável;
- caminho relativo;
- tipo e formato;
- dimensões/duração;
- tamanho em bytes;
- mundo/fase de uso;
- origem/autoria;
- licença/termos;
- estado: PLACEHOLDER, PROPOSED, APPROVED, INTEGRATED, VERIFIED;
- política: eager, preload por fase, lazy ou streaming;
- dependências e fallback.

## Imagem
Avaliar resolução, compressão, transparência, atlas, decode, memória e custo de upload para Canvas. Evitar imagens gigantes quando a área visível não justifica. Não redimensionar assets em hot path.

## Áudio
Registrar sample rate, canais, duração, codec, loop points, loudness alvo e política de decode. Planejar buses de música, SFX e UI, limite de vozes e lifecycle do AudioContext.

## Loading
Progresso só deve ser exibido quando mensurável. Tratar falha, retry, cancelamento e liberação. Não usar atraso artificial para simular carregamento.

## Aprovação
Nenhum asset final entra no build sem aprovação explícita do usuário da versão exata, conforme protocolo de produção.
