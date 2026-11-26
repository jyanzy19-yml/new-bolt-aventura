# Pipeline de CI e validação — BOLT · AVENTURA

## Estado atual

- docs-validation.yml valida metadados Claude, links Markdown e controles documentais.
- godot-validation.yml prepara importação/parse headless após project.godot existir.
- Sem project.godot, o workflow Godot registra NOT APPLICABLE; isso não é teste de engine nem resultado PASS.
- A Etapa 0 deve detectar a versão estável Godot 4.x realmente usada e registrá-la em .godot-version.
- O workflow `.github/workflows/android-debug-export.yml` está sendo introduzido para exportar APK debug com templates Godot correspondentes, JDK 17 e Android SDK. A primeira execução ainda precisa confirmar o pipeline; isso não equivale a instalação ou teste físico.

## Portões

| Gate | Verificação | Evidência |
|---|---|---|
| D0 | Documentação, links e metadados | Log documental |
| G0 | Projeto e versão fixada | project.godot e .godot-version |
| G1 | Importação/parse headless | Log Godot, versão e commit |
| G2 | Testes GDScript | Runner, casos e resultados |
| G3 | Export Android debug | APK, preset, assinatura debug e proveniência SHA-256 |
| G4 | Instalação e fluxo funcional | Aparelho, build e evidências |
| G5 | Performance/sessão longa | Frame time, p95/p99, memória, duração e aparelho |

## Workflow Godot

1. Procura project.godot.
2. Se ausente, registra NOT APPLICABLE e não baixa engine.
3. Se presente, exige .godot-version no formato 4.x.y.
4. Baixa a distribuição oficial correspondente e confere a versão.
5. Executa importação headless e parse do projeto.
6. Não exporta APK, não assina, não instala e não afirma que gameplay está correto.

## Próximas ampliações

- Adotar runner GDScript somente após escolher e fixar versão/licença.
- Adicionar testes unitários, integração e validação de referências/IDs.
- Exportar Android debug quando preset, templates e SDK estiverem disponíveis.
- Manter assinatura release fora de logs e do repositório.
- Tratar teste em dispositivo físico como etapa separada.

## Integridade

Workflow verde comprova somente os passos executados. NOT APPLICABLE não significa PASSOU. Headless não prova renderização, toque, barras Android, FPS ou memória. APK exportado não significa instalado/testado. Registrar commit, versão, comando, resultado e limitações em cada handoff.


## Pipeline Android debug — em validação

- Workflow: `.github/workflows/android-debug-export.yml`.
- Executa em PRs/pushes relevantes e por `workflow_dispatch`.
- Usa `.godot-version` para baixar editor e export templates da mesma versão.
- Usa JDK 17 e Android SDK (Platform 35 / Build Tools 35.0.1, NDK e CMake fixados no workflow).
- Usa chave de debug efêmera gerada no runner e variáveis `GODOT_ANDROID_KEYSTORE_DEBUG_*`; nenhum segredo de release é criado ou armazenado.
- Executa importação e suíte headless antes do export; verifica assinatura, package ID e SHA-256.
- O artefato é somente debug/teste, com retenção temporária de 14 dias. O package ID continua `com.example.boltaventura`, placeholder não aprovado para distribuição.
- **Estado desta branch:** pipeline escrita; aguardar execução na PR. Não afirmar que APK foi gerado até existir run verde e artefato disponível.
- Mesmo com export bem-sucedido, instalação, inicialização, controles touch, safe area, lifecycle e performance continuam dependentes de teste no Android físico.
