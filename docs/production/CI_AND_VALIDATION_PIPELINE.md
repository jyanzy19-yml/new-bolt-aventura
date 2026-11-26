# Pipeline de CI e validação — BOLT · AVENTURA

## Estado atual

- `docs-validation.yml` valida metadados, links Markdown e controles documentais.
- `godot-validation.yml` baixa a versão fixada, importa o projeto e executa `tests/test_runner.gd`; erros de parse/runtime relevantes também são verificados nos logs.
- `android-debug-export.yml` exporta APK debug usando Godot e templates pareados, JDK 17 e Android SDK com componentes fixados.
- A pipeline Android foi integrada pela PR #38 em `d08a2b203e525ccc98a4a0e45d1532b41e674fc5`.
- Execução comprovada: Android Debug Export `45879045098` SUCCESS; Godot Validation `45879045282` SUCCESS; Docs Validation `45879045081` SUCCESS.
- Artifact `bolt-aventura-android-debug-5be706c042fceaa66dadf2509ffafd0833ad3617`, 28.194.385 bytes. Godot 4.7.2; assinatura APK v2/v3 verificada; package ID `com.example.boltaventura` (placeholder); SHA-256 `acbacb86afeb767e293ba357d6749db4bdde55c2d78c05f90779dafc5f438fab`.
- O artifact é debug/teste, retenção temporária de 14 dias. Não é release nem distribuição. Nenhuma credencial de release foi criada.
- Segunda execução confirmada na PR #39: Android Debug Export `45881252046` SUCCESS; Godot Validation `45881320136` SUCCESS (72 testes/451 verificações/0 falhas); Docs Validation `45881320133` SUCCESS. Artifact `bolt-aventura-android-debug-7415dfb988faf2dd63f9ff289106e7f7205dcdd1`, 28.194.534 bytes; assinatura v2/v3 válida; package ID `com.example.boltaventura`; SHA-256 `db03a42b909781a1f5e7c94d025615e1aa5f397c8ebd306ba30cddf84eca14b0`.
- **Pós-merge PR #39 na main:** Godot Validation `45881703643` SUCCESS — 72 testes/451 verificações/0 falhas; Docs Validation `45881703650` SUCCESS; Android Debug Export `45881703604` SUCCESS. Artifact `bolt-aventura-android-debug-50c9bfdd997edf0cb5cb7cfb22d246bd4d0beca2`, 28.194.560 bytes; APK 28.447.553 bytes; assinatura v2/v3 válida; package ID `com.example.boltaventura`; SHA-256 `edb88f43f407241e5716d6b7d327272c22e40f1025a00637d7393573e320c6d7`.
- **Pós-merge PR #41 na main:** Godot Validation `45883137849` SUCCESS — 75 testes/470 verificações/0 falhas; Docs Validation `45883137856` SUCCESS; Android Debug Export `45883137961` SUCCESS. Artifact `bolt-aventura-android-debug-66b3c0e060762ebe1f3c4b6af84c84a79f0cd781`, 28.197.105 bytes; APK 28.456.143 bytes; assinatura v2/v3 válida; package ID `com.example.boltaventura`; SHA-256 `5c630ba464bdd34617aface29e86da721eb1b9578f5f82d717b15b619941f213`.
- **PR #42:** Godot Validation `45883759266` SUCCESS — 77 testes/479 verificações/0 falhas; Docs `45883759252` SUCCESS; Android Debug Export `45883759260` SUCCESS. Artifact `bolt-aventura-android-debug-b5f277107f2c590ef5401cd24c0d15e7f0a6468b`, 28.197.547 bytes; APK 28.456.143 bytes; assinatura v2/v3 válida; package ID `com.example.boltaventura`; SHA-256 `976b83d44abb50a7c545e8943b3f5b89ebfbb98ef364eb3a3da9224f0fb79f2c`.
- **PR #43:** Godot Validation `45884348999` SUCCESS — 78 testes/484 verificações/0 falhas; Docs `45884348954` SUCCESS; Android Debug Export `45884348969` SUCCESS. Artifact `bolt-aventura-android-debug-b6bf765bccdb80c2de0512655208060ab2fc1480`, 28.197.557 bytes; APK 28.456.143 bytes; assinatura v2/v3 válida; package ID `com.example.boltaventura`; SHA-256 `3dc8eba90dc3f914b1db725f50fbdc38bee9a16dee2c38d95b05f476a41cb212`.

## Portões

| Gate | Verificação | Evidência |
|---|---|---|
| D0 | Documentação, links e metadados | Log documental |
| G0 | Projeto e versão fixada | `project.godot` e `.godot-version` |
| G1 | Importação/parse headless | Log Godot, versão e commit |
| G2 | Testes GDScript | Runner, casos e resultados |
| G3 | Export Android debug | APK, preset, assinatura debug, package ID e SHA-256 |
| G4 | Instalação e fluxo funcional | Aparelho, build e evidências |
| G5 | Performance/sessão longa | Frame time, p95/p99, memória, duração e aparelho |

## Workflow Godot

1. Confirma `project.godot` e `.godot-version`.
2. Baixa a distribuição oficial correspondente.
3. Executa importação headless e `tests/test_runner.gd`.
4. Falha em parse/runtime errors monitorados e testes com exit code não zero.
5. Não exporta APK, não instala e não prova renderização, toque físico ou performance.

## Workflow Android debug

1. Instala JDK 17 e Android SDK com Platform 35, Build Tools 35.0.1, NDK r28b e CMake fixados.
2. Baixa Godot e templates da versão exata de `.godot-version`.
3. Executa importação e suíte headless antes de exportar.
4. Gera keystore de debug efêmera no runner.
5. Exporta pelo preset `Android (debug/teste)`.
6. Verifica assinatura, extrai package ID, calcula SHA-256 e publica artifact temporário.

## Limites de validação

- CI verde comprova somente as etapas executadas.
- APK exportado e assinado não significa instalado ou inicializado.
- Ainda não foram comprovados em aparelho: cold start, controles touch/multitouch, safe area, barras Android, suspensão/retomada, estabilidade prolongada, FPS, CPU/GPU ou memória.
- Package ID `com.example.boltaventura` permanece placeholder; não usar para distribuição final.
- A chave de debug é efêmera e não deve ser reutilizada como credencial de release.

## Integridade

Registrar commit, versão, workflow, run, artifact, assinatura, package ID, hash e limitações. Não generalizar resultados de um aparelho para outros. Separar L2 headless, G3 export, G4 dispositivo e G5 sessão prolongada.
