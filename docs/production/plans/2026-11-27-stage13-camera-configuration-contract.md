# Etapa 13 — contrato estrutural da câmera do protagonista

**Data:** 2026-11-27  
**Escopo:** regressões automatizadas da configuração da Camera2D presente na cena de BOLT.  
**Classificação:** teste headless L2.

## Objetivo

Fixar invariantes estruturais já presentes na cena do jogador, sem retunar parâmetros ou presumir aprovação de enquadramento final.

## Cobertura

- A câmera é acessível pelo método público `BoltPlayer.get_camera()` e pertence ao nó do protagonista.
- A câmera está habilitada e utiliza suavização de posição e de limites.
- A suavização possui velocidade positiva.
- As zonas mortas horizontal e vertical estão habilitadas.
- As margens são não negativas e não colapsam a área útil de enquadramento.

## Fora de escopo

- Não altera `bolt.tscn`, limites de fases, smoothing speed, margins ou comportamento de runtime.
- Não prova enquadramento visual, ausência de clipping, legibilidade em diferentes proporções, seguimento durante gameplay ou performance.
- Não substitui revisão em Android físico; a validação visual depende de fase/layout e resolução real.
- Não converte valores atuais em decisões artísticas definitivas.

## Aceite desta unidade

- Os testes passam na suíte Godot 4.7.2.
- Docs validation e Android Debug Export passam.
- O diff permanece restrito ao novo teste e documentação.
- Etapa 13 permanece EM ANDAMENTO até cobertura dos demais contratos espaciais e validação visual/hardware aplicável.
