# BOLT · AVENTURA — Continuity Log

## Snapshot — 2026-11-28

- Stack soberana: HTML5, CSS3, JavaScript ES Modules, Canvas 2D, Vite, Web Audio API e Pointer Events.
- Produto criado do zero; não é port nem migração Godot.
- PR #120 integrada à main: metadados das Skills/catálogos corrigidos; documentação validada com sucesso.
- PR #117 (fundação Vite/ES Modules) foi marcada ready, mas precisa de reconciliação com a main após a integração da PR #120.
- Branch ativa de consolidação/limpeza: `chore/html5-runtime-cleanup`.
- Inventário recursivo do baseline: 417 arquivos versionados; 169 paths classificados como remoção por serem artefatos exclusivos da antiga implementação Godot. O histórico Git permanece preservado.
- Canon, bíblias de design, conteúdo narrativo, planos e handoffs históricos foram mantidos.
- `scripts/validate_project_docs.py` permanece porque valida documentação; testes JavaScript do scaffold permanecem. Testes GDScript foram removidos da árvore ativa.
- Nenhum gameplay HTML5, vertical slice, APK Capacitor ou teste em Android físico é declarado concluído.

## Próximas ações verificáveis

1. Concluir PR de consolidação e limpeza após CI integral.
2. Gerar e commitar `package-lock.json` em ambiente com acesso ao registry; migrar CI para `npm ci`.
3. Executar lint, Vitest, build Vite, validador documental e CodeQL no commit integrado.
4. Implementar a primeira vertical slice com contratos e testes.
5. Validar browser, Android WebView e dispositivo físico separadamente.

## Entrega em desenvolvimento — BOLT-001 W1-L1 (2026-11-28)

- **Primary writer:** ChatGPT. **Branch:** agent/chatgpt/w1-l1-production-playable.
- **Base:** PR #161, commit 3ef82158aa45c21af51e2eea793b0ebbdfc44570. A PR #161 é uma integração agregada ainda aberta; contém o runtime HTML5, input multitouch, física, câmera e uma fixture de debug.
- Implementação criada nesta branch: dados reais de conteúdo W1-L1 em src/levels/w1-l1.js; runtime de objetivos/segredo/patrulha/sincronização; renderer vetorial de blockout; boot/menu de início, pause/resume e controles touch de movimento, salto, Dash e interação; testes específicos de dados e runtime.
- O conteúdo respeita o percurso da fonte de campanha: câmara de despertar → corredor desmoronado → pátio aberto → abrigo de manutenção. A ativação do primeiro ponto de sincronização conclui W1-L1.
- **Status:** implementação submetida à validação CI; blockout jogável pretendido, não arte final. Sem áudio final, save persistente, W1-L2, combate ou validação Android física nesta unidade.
- **Não confundir:** PR #161 continua sendo dependência técnica da branch e a main não recebeu estes arquivos. A nova PR deve deixar clara a estratégia de integração para evitar mesclar componentes #145–#158 em duplicidade.
- Próxima ação: executar lint, Vitest, Vite build e revisão de diff após abrir PR; corrigir falhas observadas. Depois, avançar para integração de combate/feedback e W1-L2, sem declarar campanha completa.
