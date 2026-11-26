# Arquitetura técnica — princípios para Godot

## 1. Estado e descoberta
**Estado atual confirmado:** o repositório contém projeto Godot executável, project.godot, .godot-version = 4.7.2, cenas, scripts, Resources, testes e pipeline de exportação Android debug via CI. Antes de cada implementação, reconfirmar o HEAD e inspecionar os arquivos/consumidores reais, porque este estado evolui por PR. Ver technical/06-godot-project-foundation.md e production/stage-status.md.

A sequência de auditoria continua obrigatória para qualquer mudança: verificar renderer, resolução, orientação, Input Map, versão do editor/runtime/templates, autoloads, estrutura e documentos aprovados; separar fatos, hipóteses e decisões provisórias. Não criar estrutura definitiva ou migrar módulos por preferência.

## 2. Princípios de arquitetura
- Separar regras de gameplay, apresentação, input, UI e persistência.
- Preferir cenas coesas e composição a hierarquias profundas.
- Usar Resources para dados reutilizáveis quando isso simplificar autoria e validação.
- Usar sinais para comunicação desacoplada; evitar dependências globais desnecessárias.
- Manter autoloads poucos, explícitos e com responsabilidade clara.
- Tipar GDScript quando melhorar segurança e manutenção.
- Evitar abstrações prematuras e microarquiteturas difíceis de depurar.
- Manter IDs estáveis para conteúdo, diálogos, missões e eventos persistidos.
- Não misturar dados de save com referências temporárias a nós da cena.
- Documentar decisões que alterem contratos entre sistemas.

## 3. Estrutura de referência — proposta, não imposição
Uma estrutura possível, a adaptar ao tamanho real do jogo:
- project.godot
- scenes/ (menus, player, enemies, worlds, bosses, shared)
- scripts/ (core, gameplay, UI, systems)
- resources/ (configurações e dados de jogo)
- assets/ (art, audio, fonts, VFX)
- data/ (diálogos e conteúdo serializado)
- tests/ (testes automatizados e fixtures)
- docs/ (documentação do projeto)

Não mover arquivos ou dividir módulos sem mapear dependências e obter autorização quando isso mudar a arquitetura aprovada.

## 4. Contratos entre sistemas
Definir interfaces explícitas para:
- Input → Player Controller.
- Player/Enemy → Health/Damage, se existir.
- Gameplay → HUD por sinais ou estado observável.
- Level → Checkpoint/Progress.
- Game State → Save System.
- Dialogue/Events → Narrative Flags.
- Scene Flow → Loading/Transition.
- Audio Events → Audio Buses.

Evitar referências circulares. Um sistema não deve alterar diretamente nós internos de outro sem contrato documentado.

## 5. Estado de jogo
Separar estado transitório (animação, velocidade, alvo atual) de estado persistente (fragmentos, checkpoints, desbloqueios, configurações). Definir fonte de verdade para cada dado e regra de atualização atômica.

## 6. Testabilidade
Sistemas com lógica determinística devem permitir teste sem depender de arte final. Isolar tempo, aleatoriedade e I/O quando necessário. Testes headless validam lógica, não renderização, toque real ou desempenho GPU.

## 7. Critério de arquitetura aprovada
A arquitetura só é aprovada após inspeção do projeto real, diagrama de dependências, justificativa de módulos, estratégia de testes, plano de migração (se houver) e revisão do impacto Android.
