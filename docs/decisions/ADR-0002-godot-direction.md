# ADR-0002 — Godot como direção de engine

- **Status:** Aprovada como direção; versão ainda não fixada
- **Data de registro:** 2026-11-25
- **Escopo:** engine e tecnologia

## Contexto
A direção de desenvolvimento definida para o BOLT é uma reconstrução 2D em Godot. O repositório de skills contém exemplos voltados a versões específicas, mas ainda não comprova a versão efetiva do projeto.

## Decisão
Usar Godot como direção de engine. Antes de implementar, inspecionar o projeto real e identificar a versão em project.godot, configuração de build ou instrução explícita. Não assumir versão por causa da documentação das skills.

## Consequências
- APIs, plugins e export templates precisam corresponder à versão detectada.
- Migração de versão exige análise de compatibilidade e aprovação.
- A instalação das skills não significa que o projeto Godot já esteja criado.
