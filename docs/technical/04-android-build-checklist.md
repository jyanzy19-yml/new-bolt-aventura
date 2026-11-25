# Android build — checklist técnico

Este documento é um roteiro de verificação, não uma receita fixa de comandos. Os caminhos e opções variam com a versão real do Godot e do Android SDK.

1. Identificar a versão do Godot no projeto.
2. Instalar export templates da mesma versão.
3. Confirmar versão e caminhos do Android SDK, build-tools e JDK suportados por essa versão.
4. Revisar o preset Android no editor e exportar primeiro um build de teste.
5. Confirmar package ID, version code/name, orientação, ícone e permissões.
6. Verificar assinatura de release e manter keystore/segredos fora do Git.
7. Instalar o artefato em dispositivo real e testar cold start, pausa, retomada, input e save/load.
8. Registrar logs e hash do artefato.
9. Fazer export release somente após QA e aprovação.

Nunca assumir que instruções de exportação de uma skill para outra versão do Godot são compatíveis.
