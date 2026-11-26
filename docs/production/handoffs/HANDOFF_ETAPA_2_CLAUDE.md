# Handoff de preparação — Etapa 2 (ChatGPT → Claude Code)

**Data:** 2026-11-26  
**Responsável pelo próximo turno:** Claude Code  
**Etapa:** 2 — continuação do Gate 1 / vertical slice  
**Repositório:** `jyanzy19-yml/new-bolt-aventura`  
**Branch de integração:** `main`  
**Commit-base confirmado:** `9d5381047817ac9fc949583f6645d24eadd88e8c` (HEAD da main após PR #4).  
**Estado:** handoff integrado na PR #4; Claude pode iniciar após o usuário ativar a sessão e confirmar o HEAD atual.

## 1. O que já está integrado

- Etapa 0 — ACCEPTED: fundação Godot 4.7.2 e protótipo técnico provisório.
- Etapa 1 — HANDOFF_READY: correção de reatribuição de ponteiro em `TouchControls`, regressão e execução da suíte no CI. Entrega original `f3ab682`.
- PR #2 — MERGED: expansão das skills, agentes consultivos e validações de qualidade. Merge `6f8bae62018fc2c7efce8fa454c16681599dcbe6`.
- PR #3 — MERGED: hardening da fundação e correção dos registros de aceite. Merge `4ecaff1d67049155d95bcbb5fc9d1c98187d3767`.
- PR #4 — MERGED: handoff Etapa 2 e sincronização documental. Merge `9d5381047817ac9fc949583f6645d24eadd88e8c`.
- Auditoria de polimento: consulte [repository-polish-audit-2026-11-26.md](../repository-polish-audit-2026-11-26.md); entregue pela PR #5.

## 2. Hardening recente da Etapa 0

- `tests/test_runner.gd` falha se não descobrir testes ou não executar verificações.
- `SafeAreaMargin` recalcula insets após resize, mudança de viewport, retomada e eventos de foco.
- Comentário de `SceneFlow` não confunde teste headless com latência real de input.
- Handoff/checklist da Etapa 0 registram a exceção de escopo como aceita, sem canonizar tuning ou sandbox.
- Auditoria detalhada: [stage-0-hardening-audit.md](../stage-0-hardening-audit.md).

## 3. Evidência de CI

No commit da PR #3 (`373d5170362ded16d7054aeacf3daeb6b649d751`):
- Godot CI Run #45: SUCCESS; importação condicional e análise de scripts concluídas.
- Docs CI Run #133: SUCCESS.
- A suíte anterior no Godot CI #36 executou 42 testes / 171 verificações / 0 falhas. Não atribuir esses números à Run #45 sem confirmar que o runner foi executado nela.

Validação máxima comprovada: L2 (Godot headless/CI). Não há APK exportado, instalação, editor gráfico, emulador, toque físico, safe area em aparelho, FPS ou memória medidos.

## 4. Ponto exato para Claude começar

1. Confirmar que está em `main` no commit-base acima (ou em descendente dele), sem alterações locais não registradas; verificar PRs e branch atual.
2. Ler `MASTER_DIRECTIVE.md`, `CLAUDE.md`, `AGENTS.md`, `docs/production/COLLABORATION_STATE.md`, `docs/production/COLLABORATIVE_DEVELOPMENT_PROTOCOL.md` e `docs/production/CONTINUITY.md`.
3. Ler `docs/production/handoffs/HANDOFF_ETAPA_1.md`, este handoff, `docs/production/stage-status.md`, `implementation-tracker.md`, `roadmap.md`, `quality-control-protocol.md` e `definition-of-done.md`.
4. Ler a diretiva from-zero e as especificações/ADRs relevantes para a primeira unidade do Gate 1. Carregar `.claude/skills/router/SKILL.md` e somente as skills necessárias.
5. Auditar o projeto real e as alterações das Etapas 0/1/PR #2/PR #3/PR #4. Ler também a auditoria de polimento e reconciliar os conflitos de documentação identificados. Não reimplementar o que já existe.
6. Escolher a próxima unidade funcional mínima que aproxime a vertical slice Android dos critérios do Gate 1; registrar escopo e critérios verificáveis antes de ampliar o trabalho.
7. Corrigir somente defeitos confirmados que afetem a unidade. Preservar contratos, canon e valores provisórios; não reescrever sistemas funcionais por preferência.
8. Implementar em branch própria, executar testes adequados, revisar diff e abrir PR. Atualizar tracker, stage status, continuidade, estado colaborativo e handoff com commit real.

## 5. Restrições e decisões ainda abertas

- Android empacotado é o único alvo; orientação paisagem.
- Priorizar controles touch, incluindo salto/dash e multitouch, para aparelhos de aproximadamente 4 GB RAM e Helio G99 ou inferiores.
- Sandbox é ambiente de desenvolvimento, não fase da campanha.
- Tuning de movimento, layout touch, viewport 960×540 e renderer GL Compatibility continuam provisórios.
- Package ID `com.example.boltaventura` é placeholder; não inventar identificador definitivo.
- Não declarar exportação, instalação ou validação Android sem evidência.
- PR #1 permanece aberta, baseada em commit anterior e reportada como não mergeável pelo GitHub. Não mesclar automaticamente; revisar/rebasear e reconciliar seus documentos raiz antes.
- Existe conflito documental sobre a mecânica Dash: código/tracker atuais a incluem, enquanto a diretiva proposta na PR #1 a exclui. Não remover nem ampliar a mecânica sem resolver a fonte canônica.
- Um único escritor ativo. O usuário inicia Claude manualmente; não há transferência automática de sessão.

## 6. Próximo responsável e critério de transferência

Claude Code é o próximo escritor, Etapa 2. ChatGPT não deve iniciar implementação concorrente. Após a entrega de Claude, ChatGPT auditará o commit/PR, verificará os testes e só então aceitará ou devolverá correções antes de assumir a Etapa 3.

**Este handoff prepara o início da Etapa 2; não declara a vertical slice concluída nem autoriza pular gates de qualidade.**
