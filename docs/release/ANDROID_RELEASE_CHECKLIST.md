# Checklist de release Android

**Status:** checklist futuro; nenhum APK/AAB ou release é declarado por este documento.

## Identidade
- [ ] Application ID definitivo aprovado (não usar placeholder).
- [ ] Nome, ícone, versão e versionCode/versionName.
- [ ] Orientação landscape e política de status/navigation bars.
- [ ] Safe areas e recortes verificados.

## Web runtime
- [ ] Build web reproduzível.
- [ ] Assets locais/offline e caminhos relativos verificados.
- [ ] Sem erros fatais de console.
- [ ] Loading, save, áudio e lifecycle verificados.
- [ ] WebView mínima suportada documentada.

## Android shell
- [ ] Necessidade do Capacitor justificada.
- [ ] Permissões mínimas.
- [ ] Back button e lifecycle.
- [ ] Status/navigation bars e modo imersivo.
- [ ] Tela cheia consistente.
- [ ] Orientação e safe areas em aparelhos variados.

## Segurança e assinatura
- [ ] Signing config fora do Git.
- [ ] Secrets armazenados como GitHub Actions secrets.
- [ ] Artefato assinado e verificado.
- [ ] SHA-256 registrado.
- [ ] SBOM/dependency review quando aplicável.
- [ ] Nenhum dado de debug sensível.

## QA físico
- [ ] Instalação limpa.
- [ ] Atualização sobre versão anterior.
- [ ] Cold start e retomada.
- [ ] Multitouch, jump e Dash sob carga.
- [ ] Sessão prolongada e thermal behavior.
- [ ] Save/load e recuperação.
- [ ] Teste em pelo menos um aparelho da classe-alvo e um aparelho de referência adicional.

## Publicação
- [ ] Aprovação explícita do usuário.
- [ ] Release notes.
- [ ] Artefatos e checksums arquivados.
- [ ] Plano de rollback.
