# ADR-0001 — Android como plataforma-alvo

- **Status:** Aprovada como direção de produto
- **Data de registro:** 2026-11-25
- **Escopo:** plataforma de entrega

## Contexto
O produto foi definido para ser desenvolvido e executado como aplicativo Android empacotado. Navegador e navegador móvel não são plataformas-alvo.

## Decisão
Priorizar Android em arquitetura, input, interface, desempenho, exportação, QA e release. Ferramentas desktop podem ser usadas para desenvolvimento e validação, mas não alteram a plataforma final.

## Consequências
- Testes touch e em dispositivos Android são essenciais.
- Safe areas, barras do sistema, recortes e interrupções Android precisam ser validados.
- Desempenho deve ser medido em hardware real de referência.
- Não criar requisitos de compatibilidade web sem solicitação explícita.
