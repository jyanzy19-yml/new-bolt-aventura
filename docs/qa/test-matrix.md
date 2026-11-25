# Matriz de QA — BOLT · AVENTURA

## 1. Regras
Registrar versão do jogo, commit, versão Godot, build, aparelho, versão Android, resolução/orientação e sequência de reprodução. Separar testes automatizados, editor, emulador e dispositivo físico.

## 2. Matriz funcional
| Área | Cenários essenciais | Resultado |
|---|---|---|
| Inicialização | cold start, retorno ao menu, erro de recurso | A executar |
| Movimento | andar, salto, dash, aterrissagem, bordas, colisões | A executar |
| Multitouch | movimento + salto + dash; soltar em ordens diferentes | A executar |
| Input | toque rápido/longo, pausa, troca de cena, perda de foco | A executar |
| Câmera | limites, transições, cutscenes, telas diferentes | A executar |
| Inimigos | percepção, estados, colisões, saída da arena, derrota | A executar |
| Chefes | fases, telegraphs, transições, vitória, reinício | A executar |
| Progressão | checkpoint, fragmento, desbloqueios, segredos | A executar |
| Save/load | salvar, fechar, retomar, dados inválidos e migração | A executar |
| UI | menu, pausa, configurações, HUD, diálogos | A executar |
| Áudio | buses, volume, mute, interrupção e retomada | A executar |
| Loading | progresso, falha, cancelamento, pico de memória | A executar |
| Android | instalação, barras, safe areas, interrupções | A executar |
| Performance | cena leve, cena pesada, sessão prolongada | A executar |

## 3. Matriz de dispositivos
Preencher com dispositivos disponíveis; não inventar resultados.

| Aparelho | SoC/GPU | RAM | Android | Resolução | Build | Status |
|---|---|---:|---|---|---|---|
| Dispositivo de referência A | A registrar | A registrar | A registrar | A registrar | A registrar | Pendente |
| Dispositivo de referência B | A registrar | A registrar | A registrar | A registrar | A registrar | Pendente |

## 4. Performance
Para cada captura: duração, cena, build, VSync/frame cap, temperatura/condição, média, p95, p99, máximo, CPU/GPU quando disponível, memória inicial/final/pico e observações.

## 5. Severidade
- **Blocker:** impede iniciar, jogar, salvar ou concluir campanha.
- **Critical:** perda de progresso, softlock, crash recorrente ou input essencial inutilizável.
- **Major:** falha importante com workaround limitado.
- **Minor:** problema localizado sem bloquear fluxo principal.
- **Cosmetic:** apresentação sem impacto funcional relevante.

## 6. Saída de QA
Aprovado, reprovado ou bloqueado; lista de bugs; evidências; cenários não executados; riscos residuais; build testada.
