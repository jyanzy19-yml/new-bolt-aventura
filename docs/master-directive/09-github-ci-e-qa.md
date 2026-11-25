# Parte 09 — GitHub, CI, builds e qualidade

## 27. GitHub e automação

Repositório oficial: `new-bolt-aventura`. Antes de modificar: inspecionar conteúdo, branches, histórico, arquivos, permissões e estado atual. Se o repositório estiver vazio de jogo, inicializar o projeto Godot preservando documentação, skills e agentes existentes. Criar branch de desenvolvimento. Não misturar arquivos antigos HTML/JavaScript/Canvas com a arquitetura Godot e não criar uma versão paralela do jogo.

### 27.1. GitHub Actions

Criar `.github/workflows/build-android.yml` para checkout, ambiente, Godot, Android SDK/dependências, validação do projeto, análise GDScript, testes automatizados, export Android e upload de artefato. Fixar versões de ferramentas e documentar requisitos. Usar secrets com segurança; nunca imprimir keystore, senhas ou tokens nos logs.

### 27.2. Builds

Preparar APK DEBUG instalável, APK RELEASE e preparação AAB/Google Play. Não expor keystore/senhas/secrets. Não publicar versão oficial sem autorização explícita. Só declarar APK disponível quando efetivamente gerado e verificado.

Diferenciar testes automatizados, editor, simulação, emulador e dispositivo físico. Não afirmar teste físico sem tê-lo realizado.

## 28. Testes e controle de qualidade

Testar inicialização, loading, menus, input, física, pulos, colisões, combate, armas, inimigos, chefes, fases, segredos, progressão, checkpoints, saves, cutscenes, áudio, Android e performance.

### 28.1. Validação das 42 fases

Cada fase deve ser percorrida do início ao fim. Verificar saltos impossíveis, rotas bloqueadas, softlocks, checkpoints incorretos, objetivos impossíveis, chefes invencíveis por bug, progressão inconsistente, saves corrompidos, menus sem saída, input sem resposta, colisões, segredos inacessíveis, quedas sem recuperação, inimigos fora do cenário e loading incorreto.

### 28.2. Classes de dispositivos

- **Classe A:** 4 GB RAM, Helio G99 ou inferior.
- **Classe B:** Android intermediário.
- **Classe C:** Android superior.

Registrar modelo, Android, versão do jogo, perfil gráfico, cena, duração, FPS/frame time, memória, temperatura quando disponível, problemas e resultado.

Não inventar resultados. Não marcar VERIFIED sem evidências correspondentes.
