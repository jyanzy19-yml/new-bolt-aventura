# Política de segurança

## Escopo
Esta política cobre o código, tooling, workflows e dependências deste repositório. Não envie relatórios de vulnerabilidade em issues públicas.

## Como reportar
Use o recurso **Private vulnerability reporting** do GitHub Security, se estiver habilitado para o repositório. Se não estiver disponível, contate o proprietário do repositório por um canal privado já conhecido. Não publique detalhes exploráveis antes de uma correção coordenada.

## Informações úteis
Inclua componente/versão afetada, impacto, passos mínimos de reprodução e mitigação conhecida. Remova tokens, dados pessoais, saves reais e credenciais de qualquer anexo.

## Práticas obrigatórias
- Nunca commitar tokens, keystores, certificados privados ou arquivos de assinatura.
- Validar e limitar dados importados, saves, manifests e mensagens externas.
- Fixar dependências via lockfile assim que gerado e revisar alertas de supply chain.
- Conceder permissões mínimas aos GitHub Actions.
- Não executar código de PR não confiável com secrets privilegiados.
- Tratar assets e arquivos do usuário como entrada não confiável.
