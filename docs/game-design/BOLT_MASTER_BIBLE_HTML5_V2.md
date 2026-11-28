# BOLT · AVENTURA — Bíblia Mestre de Produto e Engenharia (HTML5)

**Versão:** 2.0 — consolidação normativa para a reconstrução HTML5  
**Data:** 28/11/2026  
**Projeto:** `jyanzy19-yml/new-bolt-aventura`  
**Stack:** HTML5, CSS3, JavaScript ES Modules, Canvas 2D e Vite  
**Plataforma-alvo:** Android, orientação paisagem  
**Engine de jogos:** nenhuma

> Este documento estabelece a referência de produto e engenharia para o desenvolvimento HTML5. A implementação real continua sendo determinada pelo código, testes, ADRs aceitos e evidências verificáveis. Não confundir requisitos com funcionalidades já implementadas.

## 1. Decisão tecnológica soberana

BOLT · AVENTURA será construído do zero como jogo HTML5, sem engine de jogos. A stack ativa é:

- HTML5 para o shell e estrutura da aplicação;
- CSS3 para layout, HUD DOM quando adequado, controles e áreas seguras;
- JavaScript ES Modules para lógica e composição;
- Canvas 2D para renderização principal do mundo e gameplay;
- Vite para desenvolvimento e build;
- Pointer Events para entrada e multitouch;
- Web Audio API para áudio;
- LocalStorage/IndexedDB, conforme os requisitos de integridade e volume, para persistência;
- Capacitor como candidato de empacotamento Android, sujeito a integração e validação próprias.

Godot, GDScript, Unity, Unreal e outras engines não fazem parte da implementação vigente. Referências a `project.godot`, `.tscn`, `.tres`, `.gd`, autoloads ou exportação Godot são históricas e não constituem instruções ativas. Vite e Capacitor são ferramentas/plataforma de distribuição, não engines.

A mudança tecnológica não autoriza alterar o canon, remover mecânicas aprovadas ou reduzir o escopo do produto.

## 2. Identidade do produto

Jogo original 2D de plataforma, ação e aventura, com exploração lateral, movimentação responsiva, combate legível, progressão por mundos, narrativa de ficção científica fantástica, personagens memoráveis e experiência prioritariamente mobile.

Pilares de qualidade:

1. controle responsivo e previsível;
2. legibilidade espacial e de combate;
3. exploração significativa;
4. progressão mecânica e narrativa;
5. identidade própria por mundo;
6. confiabilidade de loading e salvamento;
7. acessibilidade e UX touch;
8. desempenho mensurável em Android;
9. produção rastreável e verificável.

## 3. Canon narrativo

- **BOLT:** protagonista, pequeno robô jogável.
- **NEXO:** inteligência associada à máquina temporal e companheiro narrativo.
- **Grande Colapso:** evento central que rompeu conexões entre universos.
- **Núcleo da Eternidade:** estrutura que sustenta as conexões entre universos.
- **Sete fragmentos:** elementos ligados à estabilidade e ao equilíbrio entre realidades.
- **Arquiteto:** antagonista central, associado à intenção de impor uma realidade estável e controlada.

A narrativa deve desenvolver-se gradualmente e preservar o princípio de coexistência sem uniformização. A personalidade de BOLT deve aparecer em gestos, pausas, reações e animações. A comunicação de NEXO deve evoluir de uma postura predominantemente técnica para maior envolvimento narrativo, conforme o canon.

Não inventar nomes definitivos, motivações, revelações ou relações que a documentação aprovada não estabeleça. Marcar propostas como propostas.

## 4. Campanha e mundos

Escopo planejado: **7 mundos × 6 fases = 42 fases principais**. Cada mundo possui uma sexta fase culminante associada ao guardião e ao fragmento correspondente. O confronto com o Arquiteto encerra a campanha.

| Mundo | Princípio | Identidade |
|---|---|---|
| 1. Cybercore | Origem | tecnologia, estruturas digitais e ruínas de origem |
| 2. Egito Futurista | Memória | arquitetura egípcia, tecnologia e vestígios temporais |
| 3. Cidade dos Segredos | Verdade | cidade urbana, mistério, investigação e informação |
| 4. Dark Fantasy | Medo | fantasia sombria atmosférica, mistério e silhuetas legíveis |
| 5. Reino Medieval do Pôr do Sol | Luz | castelos, vilas, pontes e luz dourada |
| 6. Vaporwave / Las Vegas | Ilusão | neon, hologramas, cenários artificiais e percepção |
| 7. Natal / Nova York Futurista | Equilíbrio | inverno urbano, luzes festivas, comunidade e integração |

Cada mundo precisa de arquitetura ambiental, paleta, vocabulário de plataformas, hazards, inimigos, NPCs, segredos, música e efeitos próprios. Recolorir um mesmo cenário não satisfaz identidade de mundo.

### Progressão funcional por mundo

1. Introdução: apresentar ambiente e mecânica local.
2. Expansão: aplicar a mecânica em situações controladas.
3. Exploração: rotas alternativas, áreas opcionais e segredos.
4. Combinação: integrar mecânicas já aprendidas.
5. Clímax local: consolidar domínio e preparar o guardião.
6. Guardião: testar domínio, resolver o conflito local e obter o fragmento.

Cada fase precisa de ID estável, objetivo, fluxo espacial, conteúdo, hazards, inimigos, checkpoints, recompensas, segredos, condições de conclusão e critérios de QA. Não criar 42 IDs que carreguem o mesmo mapa.

## 5. Gameplay e limites de escopo

Preservar as mecânicas aprovadas, incluindo:

- movimento horizontal com aceleração e desaceleração;
- controle aéreo;
- salto;
- pulo duplo;
- coyote time;
- jump buffer;
- altura variável de salto;
- Dash;
- combate com armas;
- interação e exploração.

Arsenal inicial previsto: **Pistola, Tríplice e Laser**, cada uma com papel e comportamento distinguíveis. Não reduzir diferenças a recoloração.

O escopo documentado contempla nove aparências cosméticas: BOLT original, sete temáticas e uma secreta/legendária. Skins não alteram hitbox, física, timings ou comportamento de colisão.

Não introduzir voo, aparo/parry, wall-jump, stomp-jump ou habilidades não aprovadas. O Dash é aprovado e não pode ser removido silenciosamente.

Dificuldades previstas: História, Difícil e Super Difícil. A diferenciação deve considerar padrões, janelas de reação, recursos e checkpoints; não apenas multiplicadores de vida/dano.

## 6. Inimigos e chefes

Meta de design: pelo menos cinco arquétipos significativamente distintos por mundo. Recolorir, aumentar vida ou alterar apenas velocidade não cria novo arquétipo.

Cada inimigo deve ter função, percepção, estados, movimento, ataque, telegraph, contra-jogo, recuperação, dano e integração com o ambiente.

Cada mundo possui um guardião próprio. Chefes exigem arena, identidade, padrões legíveis, fases ou escalada, janelas de vulnerabilidade, feedback, condição de vitória, recompensa e integração narrativa. Não são inimigos comuns com HP elevado.

Combate deve ser justo: evitar ataques inevitáveis fora da tela, telegraphs ambíguos e dano sem leitura ou oportunidade de resposta.

## 7. Arquitetura de runtime

Organizar por responsabilidades coesas, com dependências direcionadas e contratos explícitos:

- bootstrap e lifecycle;
- core/clock e fixed-step loop;
- input/action buffer/touch controls;
- rendering/canvas surface/viewport/camera;
- physics/collision;
- gameplay/player/combat/enemies;
- levels/content data/worlds;
- UI/HUD/menus;
- narrative/dialogue/interactions;
- assets/loading;
- audio;
- persistence/save/progression;
- platform adapters;
- tests e tooling.

Separar simulação e renderização. A renderização não altera estado autoritativo. Usar timestep fixo ou política equivalente validada, acumulador limitado e clamp de delta após suspensão. Evitar monólitos, dependências circulares, estado global mutável e micro-modularização sem benefício.

## 8. Android e UX mobile

Android em paisagem é a plataforma-alvo. Touch e multitouch são requisitos centrais, não complementos.

- Movimento e ações devem funcionar simultaneamente por ponteiros distintos.
- Jump e Dash devem registrar ações mesmo sob pequenas quedas de FPS.
- Tratar `pointerup`, `pointercancel`, perda de foco, blur, pagehide, suspensão e retomada.
- Limpar estados de input em pause, troca de cena e lifecycle.
- Manter alvos touch confortáveis e feedback de pressionamento.
- Respeitar safe areas para controles; o mundo pode ocupar a área visual disponível.
- CSS não controla por si só as barras nativas Android. A política imersiva exige integração nativa/Capacitor e validação em aparelho.
- Não criar toggle de fullscreen nem alterar a política aprovada sem nova decisão explícita.

## 9. Loading, assets, áudio e save

Loading representa trabalho real; não usar atrasos artificiais ou percentuais inventados. Pré-carregar recursos críticos, permitir cancelamento/erro/retry e liberar recursos por mundo/fase.

Cada asset deve ter ID estável, caminho, tipo, dimensão/duração, origem, licença, estado de aprovação, dependências, política de preload e fallback. Não integrar arte final sem aprovação do asset exato quando a regra de aprovação se aplicar. Placeholder deve ser claramente identificado.

Web Audio deve contemplar unlock por gesto, buses, limites de vozes, mute, pause e lifecycle.

Persistência deve separar estado transitório, checkpoint e campanha. Usar schema versionado, validação, migração, recuperação de dados inválidos e IDs estáveis. Testar cold start, encerramento inesperado, retomada e corrupção.

## 10. Performance e validação

Hardware de referência: Android com aproximadamente 4 GB RAM e desempenho equivalente ou inferior ao MediaTek Helio G99. Meta próxima de 60 FPS quando sustentável; não prometer desempenho universal.

Medir frame time p50/p95/p99, latência de input, memória, decodificação, GC, carregamento e comportamento térmico quando as ferramentas permitirem. Registrar aparelho, Android, WebView, resolução, DPR, build e duração do teste.

Testes necessários: unitários, integração, regressão, browser, build, WebView e Android físico. Cobrir física, colisões, Dash, multitouch, pointercancel, input sob baixo FPS, lifecycle, loading, áudio, save, checkpoints, transições, softlocks e chefes.

Estados devem distinguir PLANNED, IMPLEMENTED, TESTED e VERIFIED. CI verde não prova UX touch física; APK gerado não prova instalação; execução em browser não prova compatibilidade Android.

## 11. Produção e governança

Desenvolver em 26 etapas conforme `docs/production/26_STAGE_WORKFLOW.md`. Cada tarefa deve declarar escritor primário, revisor, baseline, branch, paths permitidos/proibidos, dependências, critérios de aceite, testes e evidências.

ChatGPT e Claude Code são agentes autorizados, com um escritor por tarefa. O usuário controla a sequência e o merge. Não editar os mesmos paths simultaneamente, não fazer force-push, não integrar PR automaticamente e não alegar trabalho/testes não realizados.

A produção deve avançar por ciclos: analisar → implementar → executar → testar → corrigir → integrar → documentar → avançar. Uma vertical slice é gate de qualidade, não conclusão do jogo.

## 12. Critério de conclusão

O jogo só está concluído quando os sistemas estiverem integrados, os sete mundos e 42 fases forem conteúdo individualizado, os guardiões e confronto final funcionarem, menus e saves forem testados, controles Android forem validados, assets/áudio estiverem integrados, QA estiver documentado e o build de distribuição for reproduzível.

**Regra final:** preservar o canon, construir com intenção, validar com evidência e nunca declarar concluído o que ainda não foi produzido ou testado.
