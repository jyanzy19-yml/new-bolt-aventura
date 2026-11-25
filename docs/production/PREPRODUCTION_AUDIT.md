# Auditoria de pré-produção — BOLT · AVENTURA

**Data:** 2026-11-25  
**Branch:** `main`  
**HEAD auditado:** `bc5799c651ccd5ffbcdfadf36f669435df63501b`  
**Escopo:** documentação, governança de agentes, CI, QA, especificações de produto e preparação da Etapa 0.  
**Limite:** esta auditoria não cria nem valida o jogo executável.

## 1. Estado real confirmado

| Item | Estado no HEAD auditado |
|---|---:|
| Entradas na árvore Git | 232 |
| Markdown no repositório | 132 |
| Markdown em `docs/` | 44 |
| Skills Claude Code | 36 |
| Agentes consultivos | 8 |
| Comandos Claude Code | 6 |
| Workflows GitHub Actions | 2 |
| `project.godot` | Ausente |
| Cenas `.tscn` | 0 |
| Scripts `.gd` | 4, exemplos/testes de skills |
| Assets de jogo (imagem/áudio/fonte) | 0 identificados |
| Gameplay BOLT | Não implementado |

O repositório é um framework documental e de ferramentas. Não há projeto Godot executável, cenas de jogo, assets finais, APK ou evidência de gameplay.

## 2. CI observado

- [Validação documental — Run #96](https://github.com/jyanzy19-yml/new-bolt-aventura/actions/runs/45700675751): **SUCCESS**. O job de validação documental e a etapa de links/metadados terminaram com sucesso.
- [Validação Godot — Run #6](https://github.com/jyanzy19-yml/new-bolt-aventura/actions/runs/45700675747): workflow **SUCCESS**, mas o log registra **NOT APPLICABLE** porque `project.godot` não existe. Nenhum engine, script, gameplay ou Android foi testado.
- O workflow Godot exige `.godot-version` exata no formato 4.x.y quando o projeto existir e executará import/parse headless. Não exporta APK.
- Não há pipeline confirmado para testes GDScript, exportação Android, instalação, testes touch ou performance.

## 3. Colaboração e PR

- Atribuição canônica permanece: **Etapa 0 — Claude Code — PENDING**; nenhum escritor ativo; **Etapa 1 — ChatGPT** após inspeção e aceite do handoff.
- A alternância é sequencial: um escritor ativo por vez; o usuário inicia manualmente o agente seguinte.
- [PR #1](https://github.com/jyanzy19-yml/new-bolt-aventura/pull/1) permanece aberta. A comparação atual de `main` com `docs/master-directive-bolt` informa 17 commits exclusivos na PR e 94 exclusivos em `main`, estado divergente. A PR contém 17 arquivos, incluindo uma diretiva dividida em 12 partes que se sobrepõe às fontes já existentes. Não mesclar, fechar ou reaproveitar automaticamente.
- A regra de escritor único está documentada, mas não é imposta tecnicamente por proteção de branch. Nenhuma configuração de proteção, secret ou permissão foi alterada nesta auditoria.

## 4. Achados documentais

| ID | Achado | Ação |
|---|---|---|
| AUD-01 | Snapshots em status/continuidade/colaboração/reportes apontavam para commits anteriores ao HEAD atual | Atualizar o status e registrar o snapshot atual nos documentos de continuidade e colaboração |
| AUD-02 | UI/UX §5 tratava a política das barras Android como decisão ainda aberta, em conflito com ADR-0003 aprovada | Corrigir a especificação para obedecer à ADR |
| AUD-03 | A especificação de tela tratava orientação como algo ainda a confirmar, embora a direção do produto seja paisagem | Fixar a redação em paisagem, mantendo validação de proporções e safe areas |
| AUD-04 | A tabela narrativa dizia que a ordem dos mundos estava a definir, embora a ordem seja fixa na Bíblia dos Mundos e no prompt mestre | Distinguir ordem fixa de ritmo/revelações narrativas ainda a desenvolver |
| AUD-05 | Não havia checklist compacto de aceite específico da Etapa 0 | Criar checklist ligado ao estado colaborativo e ao índice |
| AUD-06 | O relatório de validação estrutural continha inventários históricos que poderiam ser confundidos com o estado atual | Acrescentar referência explícita ao snapshot atual e aos limites do CI |

## 5. Integridade do design e dos contratos

- As fontes principais confirmam sete mundos, 42 fases, seis fases por mundo, cinco fases de progressão/exploração e uma sexta fase de guardião/fragmento/transição.
- A ordem e os fragmentos estão definidos na Bíblia dos Mundos e no prompt mestre; detalhes de layouts, NPCs, diálogos e revelações continuam em desenvolvimento ou proposta.
- All Jump e dash pertencem ao conjunto-base descrito no prompt mestre. Voo e parry não são habilidades obrigatórias do conjunto-base. Não importar especificações divergentes da PR #1 sem revisão.
- ADR-0003 define política imersiva: barras de status e navegação ocultas durante a experiência, inclusive fora de uma opção de tela cheia; a opção/configuração de Tela cheia permanece desligada. O Android pode revelar temporariamente as barras por gestos ou políticas do sistema.
- Os contratos entre sistemas são conceituais. Nomes finais de classes, sinais e Resources devem ser definidos após a criação do projeto real.

## 6. Preparação concluída para a Etapa 0

O checklist `ETAPA_0_CLAUDE_CHECKLIST.md` estabelece pré-leitura, inspeção, versão Godot, fundação mínima, configuração Android/paisagem, cena inicial, testes possíveis, atualização do tracker e handoff. Ele não amplia a Etapa 0 para implementar sistemas completos ou conteúdo da campanha.

## 7. Limitações desta auditoria

- A inspeção de código foi limitada porque o repositório não possui projeto Godot e a pesquisa de código do GitHub não retornou resultados indexados nesta sessão.
- Os números do inventário foram confirmados no snapshot anterior e os commits posteriores auditados alteraram documentos/workflow sem adicionar ou remover entradas da árvore.
- A validação documental CI não verifica coerência semântica, decisões de design, execução do Godot, gameplay, Android ou performance.
- Nenhum APK, emulador ou aparelho físico foi utilizado.
- Não foi executado Claude Code.

## 8. Próxima ação

Claude Code inicia a Etapa 0 somente quando o usuário o acionar. Deve confirmar o HEAD mais recente, seguir `COLLABORATION_STATE.md`, `COLLABORATIVE_DEVELOPMENT_PROTOCOL.md` e o checklist da Etapa 0, criar a fundação Godot real e entregar commit e handoff verificáveis. ChatGPT assume a Etapa 1 apenas depois de inspecionar a entrega integrada.


## 9. Alterações documentais aplicadas após a base auditada

Após o inventário no commit-base `bc5799c651ccd5ffbcdfadf36f669435df63501b`, esta rodada adicionou dois documentos e atualizou as especificações de UI/UX, narrativa, orientação/touch, QA Android, status, continuidade, colaboração e índice de documentação. O inventário resultante passa a 234 entradas, 134 arquivos Markdown no repositório e 46 em `docs/`; as contagens de skills/agentes/comandos/workflows permanecem 36/8/6/2. Essas alterações não criam projeto Godot, gameplay, cenas ou assets.

A validação documental correspondente deve ser consultada no GitHub Actions após a conclusão dos commits. O workflow Godot continuará registrando NOT APPLICABLE enquanto `project.godot` estiver ausente.
