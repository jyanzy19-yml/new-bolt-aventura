# Pipeline de exportação Android debug

**Data:** 2026-11-26  
**Branch:** `ci/android-debug-export`  
**Base:** `main` após PR #37  
**Responsável:** ChatGPT

## Diagnóstico

O projeto já possui um preset Godot Android de debug/teste, orientação paisagem, arquitetura arm64 e modo imersivo. Porém, a pipeline atual só executa importação e testes headless; não exporta APK. O package ID `com.example.boltaventura` permanece placeholder e não deve ser tratado como identidade de distribuição.

## Objetivo

Criar uma pipeline reproduzível que gere e verifique um APK Android de debug, usando a versão Godot e templates exatamente fixados pelo repositório. O artefato servirá para instalação e testes manuais posteriores, não como release.

## Decisões de implementação

- Usar OpenJDK 17 e Android SDK com Platform 35 / Build Tools 35.0.1 e pacotes exigidos pela exportação Godot 4.7.2.
- Baixar o editor Godot e export templates correspondentes a `.godot-version`.
- Configurar SDK/JDK via `ANDROID_HOME` e `JAVA_HOME`, lidos pelo editor Godot.
- Gerar uma chave de debug efêmera somente no runner; não criar keystore de release nem guardar credenciais.
- Executar importação e suíte headless antes da exportação.
- Exportar com o preset existente `Android (debug/teste)`, sem modificar package ID, permissões, orientação, renderer ou identidade.
- Verificar assinatura APK, package ID, tamanho e SHA-256; publicar o APK como artifact temporário do GitHub Actions.

## Fora de escopo

- Não criar APK/AAB de release.
- Não definir package ID definitivo.
- Não criar/usar keystore de distribuição.
- Não adicionar permissões ou plugins.
- Não declarar instalação, inicialização, touch físico, safe area, performance ou compatibilidade Android sem teste em dispositivo.

## Critérios de aceite

1. Godot e export templates correspondem exatamente à versão registrada em `.godot-version`.
2. Importação e testes headless passam antes da exportação.
3. Exportação gera APK não vazio usando o preset existente.
4. Assinatura de debug é verificada e package ID é extraído do APK.
5. Artefato e metadados de proveniência são publicados no Actions.
6. Docs CI passa e a documentação distingue exportação de instalação/teste físico.

## Validação pendente

A pipeline ainda precisa executar na PR. Nenhuma exportação local, instalação, emulador ou teste Android físico foi realizado nesta unidade.
