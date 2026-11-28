# WeaponController — contrato de disparo configurável

**Status:** controlador genérico de disparo; não aprova nem define o catálogo final de armas.  
**Dependências:** `ProjectileSystem` e frames de input normalizados.

## Responsabilidades

- Selecionar uma arma entre definições injetadas com IDs estáveis.
- Aplicar semântica de gatilho `automatic` (ação held) ou `semi-automatic` (borda pressed).
- Aplicar cooldown determinístico por tempo de simulação.
- Resolver direção de mira e normalizá-la.
- Calcular muzzle origin relativo ao centro do corpo e à orientação do jogador.
- Criar um projétil no ProjectileSystem e aplicar cooldown somente quando o spawn é aceito.
- Não consumir sequência/cooldown quando o limite de projéteis impede o spawn.

## Definição de arma

Cada entrada declara ID, fireMode, cooldown, offsets de muzzle e um perfil de projétil (dimensões, velocidade, dano e lifetime). Todos os parâmetros são obrigatórios e validados. Nenhum perfil de teste deste módulo é um valor de balanceamento aprovado.

## Política de troca

A troca para um ID desconhecido retorna false. Trocar para uma arma válida não zera o cooldown global já em andamento; isso evita contornar a cadência apenas alternando seleção. Um futuro inventário poderá impor regras adicionais.

## Limites

O controlador atual cria um projétil por disparo. Padrões de rajada/espalhamento, feixes contínuos, munição, recarga, upgrades, animações, feedback audiovisual e catálogo canônico permanecem fora do escopo até que suas definições sejam aprovadas e testadas.
