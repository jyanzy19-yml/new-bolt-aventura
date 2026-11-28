# Política de segurança

Não reporte vulnerabilidades em issues públicas. Use **Private vulnerability reporting** do GitHub Security, se habilitado; caso contrário, contate o proprietário por canal privado já conhecido.

Inclua componente/versão, impacto, passos mínimos e mitigação. Remova tokens, dados pessoais, saves reais e credenciais de anexos.

Práticas obrigatórias:
- Nunca commitar tokens, keystores, certificados privados ou arquivos de assinatura.
- Validar e limitar dados importados, saves, manifests e mensagens externas.
- Fixar dependências via lockfile assim que gerado e revisar advisories.
- Conceder permissões mínimas aos GitHub Actions.
- Não executar código de PR não confiável com secrets privilegiados.
- Tratar assets e arquivos do usuário como entrada não confiável.
