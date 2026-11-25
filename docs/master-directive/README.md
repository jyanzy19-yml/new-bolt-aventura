# BOLT · AVENTURA — Master Game Development Directive

**Versão:** 1.0 — diretiva fornecida pelo usuário em 2026-11-25  
**Projeto:** `new-bolt-aventura`  
**Engine:** Godot 4.x (versão exata a detectar)  
**Linguagem:** GDScript  
**Plataforma-alvo:** aplicativo Android, orientação paisagem  
**Status:** diretiva de produto e execução incorporada ao repositório; implementação do jogo ainda precisa ser realizada e validada.

## Como utilizar

Esta diretiva foi dividida em partes para facilitar consulta, carregamento seletivo por agentes e atualização controlada. Leia primeiro este índice e depois as partes relevantes. Para iniciar ou retomar uma sessão de desenvolvimento, leia também `docs/production/PROJECT_STATUS.md`, `CURRENT_TASK.md`, `NEXT_ACTIONS.md` e o último checkpoint validado, quando esses arquivos existirem.

## Partes

| Arquivo | Conteúdo |
|---|---|
| [00 — Mandato, autonomia e identidade](00-mandato-identidade.md) | Objetivo, autonomia, fluxo de trabalho, identidade e história |
| [01 — Campanha e sete universos](01-campanha-e-universos.md) | 42 fases, estrutura de fases, escala, cenários, ecossistemas e sete mundos |
| [02 — Antagonista e design de inimigos](02-antagonista-e-inimigos.md) | Arquiteto, confronto final, IA, leitura de ataques e encontros |
| [03 — Bolt, movimentação e combate](03-bolt-movimentacao-combate.md) | All Jump, animações, colisões, armas, skins e NPCs |
| [04 — Fluxo de jogo, menus e experiência](04-fluxo-menus-e-cinematicas.md) | Inicialização, menus, progressão entre telas, cinemáticas e tutorial |
| [05 — HUD, controles e configurações](05-hud-controles-configuracoes.md) | HUD, pausa, touchscreen, multitouch, opções e acessibilidade |
| [06 — Progressão e salvamento](06-progressao-e-salvamento.md) | Fragmentos, segredos, recompensas, checkpoints e integridade dos saves |
| [07 — Arquitetura Godot e assets](07-arquitetura-e-assets.md) | Organização técnica, cenas, recursos, direção de arte e pipeline |
| [08 — Android e desempenho](08-android-performance.md) | Perfil de hardware, métricas, renderização, loading e comportamento Android |
| [09 — GitHub, CI e qualidade](09-github-ci-e-qa.md) | Branches, Actions, builds, testes e evidências |
| [10 — Documentação e skills](10-documentacao-e-skills.md) | Registros de produção, continuidade e uso de skills |
| [11 — Etapas e critérios de conclusão](11-etapas-e-conclusao.md) | Etapas 0–15, vertical slice, princípios e primeira execução |

## Precedência e resolução de conflitos

1. Esta diretiva registra a instrução mais recente do usuário para o escopo do jogo. Quando uma regra explícita daqui conflitar com uma orientação anterior, aplique esta diretiva ao trabalho futuro e registre a reconciliação nos documentos afetados.
2. Preservar arquivos, histórico, decisões e conteúdo existente que não conflitem com esta diretiva. Não apagar nem reescrever histórico para esconder decisões anteriores.
3. A diretiva exige **não implementar voo, parry/aparar ou Dash**. Isso substitui qualquer referência anterior a essas habilidades como requisito de implementação. O conjunto de movimentos aprovado nesta diretiva é o All Jump descrito na Parte 03.
4. Os sete universos, 42 fases, sete guardiões, confronto final, nove aparências e três armas são o escopo-alvo definido nesta diretiva. Nomes, assets, conteúdo e sistemas ainda não implementados não podem ser descritos como existentes.
5. Godot 4.x é a direção técnica. Detectar a versão realmente instalada/configurada antes de escolher APIs, plugins ou export templates; não presumir uma versão menor específica.
6. Autonomia significa avançar nas tarefas reversíveis e seguras sem pedir aprovação intermediária. Não autoriza apagar dados, expor segredos, alterar permissões, publicar releases oficiais, assinar com credenciais não fornecidas ou executar ações irreversíveis sem autorização.
7. Quando uma especificação for tecnicamente inviável ou contraditória, documentar o conflito, escolher uma alternativa reversível que preserve a intenção e continuar o restante. Interromper somente a parte realmente bloqueada.
8. Diferenciar sempre **IMPLEMENTED**, **TESTED**, **VERIFIED** e **APPROVED**. A diretiva não constitui evidência de implementação ou teste.

## Estado real conhecido na incorporação

Na inspeção desta atualização, o repositório contém documentação, skills, agentes e fluxos de trabalho. Não foi identificado um projeto Godot executável na raiz. Portanto, a primeira execução técnica deverá começar por auditoria do conteúdo real e, se confirmado que o projeto está ausente, inicialização do projeto Godot sem misturar ou apagar os materiais de documentação existentes.
