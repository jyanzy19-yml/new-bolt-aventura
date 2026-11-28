# Definition of Done — BOLT · AVENTURA

Uma tarefa só pode ser declarada concluída quando todos os itens aplicáveis estiverem satisfeitos:

## Produto
- [ ] Critérios de aceite foram atendidos.
- [ ] Canon, mecânicas aprovadas e UX mobile foram preservados.
- [ ] Estados de erro, cancelamento, pause/resume e lifecycle foram considerados.
- [ ] Nenhum placeholder foi apresentado como conteúdo final.

## Engenharia
- [ ] Ownership e dependências estão explícitos.
- [ ] Não há dependência circular ou estado global desnecessário.
- [ ] Recursos/listeners têm descarte apropriado.
- [ ] Dados externos são validados.
- [ ] Dependências e licenças foram revisadas.
- [ ] Secrets não foram adicionados.

## Qualidade
- [ ] Lint executado.
- [ ] Testes relevantes executados.
- [ ] Build de produção executado.
- [ ] Teste de regressão adicionado para bug corrigido.
- [ ] Revisão independente concluída.
- [ ] Riscos e testes não executados foram documentados.

## Integração e continuidade
- [ ] PR/diff revisado.
- [ ] Documentação e tracker atualizados.
- [ ] Handoff inclui commit, paths e evidências.
- [ ] Próximo responsável está claro.

## Nível de evidência
- **IMPLEMENTED:** código integrado/inspecionado.
- **TESTED:** comandos e testes executados com resultado registrado.
- **VERIFIED:** comportamento comprovado no ambiente-alvo, com dispositivo/build/cenário.
- Não elevar automaticamente um nível ao outro.
