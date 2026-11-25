# Definition of Done — BOLT · AVENTURA

Uma tarefa só está concluída quando todos os critérios aplicáveis forem atendidos.

## Escopo e documentação
- O pedido e os limites foram compreendidos.
- Documentos aprovados foram consultados.
- Mudanças de escopo/canon/arquitetura foram submetidas à aprovação necessária.
- Arquivos alterados e decisões estão identificados.

## Implementação
- A solução atende ao comportamento solicitado.
- Não introduz dependências desnecessárias ou duplicação.
- Estados de erro, cancelamento e interrupção foram considerados.
- Compatibilidade com a versão real do Godot foi verificada.

## Testes
- Testes automatizados relevantes foram executados e resultado registrado.
- Testes manuais relevantes foram descritos separadamente.
- Nenhum teste é declarado como executado sem evidência.
- Casos de regressão foram considerados.

## Android
Quando aplicável:
- Build/export é compatível com versão e templates identificados.
- Input touch e multitouch foram testados.
- Safe areas, barras do sistema e recortes foram verificados.
- Retomada, pausa e interrupção foram testadas.
- Teste em dispositivo real é identificado por modelo/versão e não generalizado.

## Performance
Quando aplicável:
- Cena e sequência de reprodução são identificáveis.
- Build, aparelho e condições são registrados.
- Frame time/memória foram medidos antes/depois quando a tarefa é de otimização.
- Melhorias não foram presumidas a partir de FPS isolado.
- Mudanças visuais ou físicas são explicitadas.

## Comunicação
- Resumo objetivo do que mudou.
- Lista de arquivos.
- Testes executados e resultados.
- Limitações, riscos e validações pendentes.
- Próximo bloqueio, se houver.
