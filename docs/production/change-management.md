# Gestão de mudanças — BOLT · AVENTURA

## 1. Classificação
- **Correção:** restaura comportamento aprovado.
- **Melhoria interna:** altera implementação sem mudar comportamento visível.
- **Melhoria de produto:** altera UX, balanceamento ou conteúdo.
- **Mudança de canon:** altera história, personagens, mundos ou eventos.
- **Mudança arquitetural:** altera engine, módulos, contratos ou dependências.
- **Mudança de plataforma/release:** altera alvo, assinatura, publicação ou configuração Android.

## 2. Aprovação
Correções dentro do escopo podem seguir o pedido explícito. Mudanças de produto, canon, arquitetura, engine, plataforma e release precisam de aprovação quando não estiverem claramente autorizadas pelo pedido.

## 3. Plano incremental
Antes de tarefa multi-arquivo, registrar objetivo, estado atual, arquivos previstos, dependências, riscos, etapas, testes e critérios de aceite. Dividir em commits coerentes sempre que possível.

## 4. Preservação
- Inspecionar arquivos existentes antes de substituir.
- Nunca sobrescrever documentos canônicos sem comparar o conteúdo.
- Não remover arquivos apenas por parecerem obsoletos.
- Preservar licenças, NOTICE e atribuições de terceiros.
- Evitar misturar mudanças de design, refatoração e correções independentes no mesmo commit.

## 5. Revisão e rastreabilidade
Cada mudança relevante deve apontar para requisito, documento, issue ou decisão. Atualizar catálogo, índice e stage status quando a estrutura mudar. Não registrar como concluído aquilo que não foi validado.

## 6. Rollback
Para mudanças arriscadas, identificar como reverter e quais dados podem ser afetados. Migrações de save devem prever compatibilidade ou recuperação antes de alterar formato persistente.
