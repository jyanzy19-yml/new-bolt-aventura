# Checklist de release Android

## Projeto e versão
- [ ] Versão do Godot confirmada.
- [ ] Export templates correspondem exatamente à versão.
- [ ] Renderer e configurações de projeto documentados.
- [ ] Identificador de pacote e versão do app aprovados.
- [ ] Orientação e política de barras do sistema aprovadas.

## Build e segurança
- [ ] Export preset Android revisado.
- [ ] SDK/JDK configurados conforme a versão Godot.
- [ ] Assinatura de release configurada fora do repositório.
- [ ] Nenhuma senha, keystore ou segredo commitado.
- [ ] Permissões Android mínimas e justificadas.
- [ ] APK/AAB gerado e artefato identificado por hash/commit.

## Funcionalidade
- [ ] Instalação limpa.
- [ ] Inicialização e retorno ao menu.
- [ ] Controles touch e multitouch.
- [ ] Pause/resume e interrupções.
- [ ] Save/load e migração.
- [ ] Campanha e progressão concluíveis.
- [ ] Cutscenes, diálogos e áudio.
- [ ] Safe areas, barras e recortes.

## Performance e estabilidade
- [ ] Frame time em cena leve e pesada.
- [ ] p95/p99 e picos registrados.
- [ ] Memória inicial, final e pico registrados.
- [ ] Sessão prolongada e aquecimento.
- [ ] Carregamento e primeiro uso de efeitos.
- [ ] Sem crash/blocker conhecido.

## Release decision
- [ ] Matriz de QA atualizada.
- [ ] Bugs blocker/critical resolvidos ou decisão formal registrada.
- [ ] Limitações conhecidas comunicadas.
- [ ] Aprovação explícita do release candidate.
