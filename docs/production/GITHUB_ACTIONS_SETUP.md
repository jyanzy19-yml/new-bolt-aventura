# Configuração do GitHub para produção

Os arquivos de workflow e automação já estão no repositório desta branch. Algumas proteções exigem configuração pelo proprietário na interface do GitHub e não são ativadas apenas por commitar YAML.

## 1. Actions
- Abra **Settings → Actions → General**.
- Confirme que GitHub Actions está permitido para o repositório.
- Mantenha permissões de workflow em leitura por padrão.
- Não habilite permissões de escrita globais sem necessidade.
- Verifique se workflows de PRs de forks seguem política segura.

## 2. Branch protection para main
Depois que os workflows executarem pelo menos uma vez:
- Abra **Settings → Branches** e adicione uma ruleset para `main`.
- Exija Pull Request antes de integrar.
- Exija pelo menos uma aprovação humana quando apropriado.
- Exija resolução de conversas.
- Exija checks CI/CodeQL que realmente existam no repositório.
- Bloqueie force-push e exclusão da branch.
- Não marque nomes de checks como obrigatórios antes de eles aparecerem no GitHub.

## 3. CodeQL
O workflow `.github/workflows/codeql.yml` executa análise de JavaScript/TypeScript em push, PR e agenda semanal. Confirme em **Security → Code scanning** se os resultados aparecem. A disponibilidade pode depender das configurações/plano do GitHub.

## 4. Dependabot
O arquivo `.github/dependabot.yml` verifica semanalmente dependências npm e GitHub Actions. Revise PRs de atualização; não faça merge automático sem CI e análise de changelog.

## 5. Secrets e Android
Nenhum secret é necessário para CI web. Quando assinatura Android for adicionada, use **Settings → Secrets and variables → Actions**. Nunca grave keystore, senha ou chave no Git. Não exponha secrets a workflows que executam código não confiável de PR.

## 6. Limitação atual
O lockfile npm ainda precisa ser gerado e commitado. O CI usa `npm install` provisoriamente. Após adicionar `package-lock.json`, mudar para `npm ci` e habilitar cache npm.
