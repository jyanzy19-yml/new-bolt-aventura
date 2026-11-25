# ADR-0002 — Godot como direção de engine

- **Status:** Aprovada como direção; versão ainda não fixada
- **Data de registro:** 2026-11-25
- **Escopo:** engine e tecnologia

## Contexto
A direção de desenvolvimento definida para o BOLT é uma reconstrução 2D em Godot Engine 4.x, usando GDScript. O repositório de skills contém exemplos voltados a versões específicas, mas ainda não comprova a versão minor/patch efetiva nem a instalação do ambiente.

## Decisão

Godot Engine 4.x + GDScript são a direção tecnológica aprovada; a versão minor/patch será registrada na fundação do projeto.
Usar Godot Engine 4.x e GDScript. Como o projeto executável ainda não existe, selecionar uma versão 4.x estável e compatível com Android, registrar a versão exata, renderer e export templates antes de implementar APIs específicas. Se já existir projeto em checkout futuro, detectar a versão real antes de qualquer migração. Não assumir versão por causa da documentação das skills.

## Consequências
- APIs, plugins e export templates precisam corresponder à versão detectada.
- Migração de versão exige análise de compatibilidade e aprovação.
- A instalação das skills não significa que o projeto Godot já esteja criado.
