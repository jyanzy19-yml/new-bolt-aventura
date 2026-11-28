# LevelRuntime — lifecycle de conteúdo

**Status:** implementação de ciclo de vida em memória para definições declarativas.  
**Dependência:** schema versionado `LEVEL_SCHEMA_VERSION = 1`.  
**Não é:** carregador de arquivos, decodificador de imagens/áudio, gerenciador de bundles ou instanciação de atores.

## Garantias

1. A definição é validada pelo schema antes de ser aceita.
2. O conteúdo é clonado para uma árvore de dados JSON compatível.
3. Objetos e arrays da árvore ativa são congelados recursivamente.
4. O runtime não compartilha referências mutáveis com o objeto de origem.
5. Uma nova fase só substitui a fase ativa depois que validação e clonagem terminam com sucesso.
6. Falhas não destroem a fase que já está carregada.
7. `unload()` é idempotente e remove a referência ativa.

## Formato de dados

Metadados desconhecidos são preservados pelo schema, mas o LevelRuntime exige que toda a árvore seja composta por null, strings, booleanos, números finitos, arrays e objetos simples. Funções, símbolos, BigInt, valores não finitos, classes, accessors e referências circulares são rejeitados. Isso mantém os dados de fase serializáveis e previsíveis.

## Fronteiras futuras

O próximo adaptador deve converter `geometry.solids` e `geometry.oneWayPlatforms` em `CollisionWorld`, sem armazenar instâncias de gameplay dentro do documento de conteúdo. Carregamento assíncrono de assets, cancelamento, progress reporting e descarregamento seletivo pertencem ao gerenciador de assets, não a esta classe.
