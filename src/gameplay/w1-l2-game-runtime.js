import { COMBAT_ACTIONS } from './combat-system.js';

const EMPTY_INPUT = Object.freeze({ pressed: [], released: [], held: [] });

function near(player, target, padding = 58) {
  return player.x <= target.x + target.width + padding &&
    player.x + player.width >= target.x - padding &&
    player.y <= target.y + target.height + padding &&
    player.y + player.height >= target.y - padding;
}

function cloneEnemy(enemy) {
  return {
    ...enemy,
    direction: 1,
    health: enemy.health,
    maxHealth: enemy.health,
    alive: true,
    fireRemaining: enemy.fireInterval > 0 ? enemy.fireInterval * 0.65 : 0,
    windupRemaining: 0,
    attackDirection: 1,
    contactCooldown: 0,
  };
}

/**
 * W1-L2 encounter/progression orchestration.
 * CombatSystem owns projectiles, weapon cooldowns and player health; this
 * runtime owns enemy health, AI schedules, objective state and interactions.
 */
export class W1L2GameRuntime {
  #level;
  #combat;
  #enemies;
  #objectiveIndex = 0;
  #secretFound = false;
  #repeaterActive = false;
  #completed = false;
  #message = 'NEXO // MAPA PARCIAL RECUPERADO. PROCURE O REPETIDOR.';
  #messageRemaining = 5;
  #prompt = '';
  #time = 0;
  #contactCooldown = 0;
  #checkpointIndex = -1;
  #respawnPosition;

  constructor({ level, combatSystem }) {
    if (level?.id !== 'w1-l2' || !Array.isArray(level.enemies)) {
      throw new TypeError('W1L2GameRuntime exige o pacote de dados W1-L2.');
    }
    if (!combatSystem || typeof combatSystem.update !== 'function' ||
        typeof combatSystem.spawnEnemyProjectile !== 'function' ||
        typeof combatSystem.damagePlayer !== 'function') {
      throw new TypeError('combatSystem não implementa o contrato esperado.');
    }
    this.#level = level;
    this.#combat = combatSystem;
    this.#enemies = level.enemies.map(cloneEnemy);
    this.#respawnPosition = { ...level.spawn };
  }

  get snapshot() {
    return {
      objective: this.#level.objectives[this.#objectiveIndex]?.label ?? 'Repetidor religado',
      objectiveIndex: this.#objectiveIndex,
      objectiveCount: this.#level.objectives.length,
      secretFound: this.#secretFound,
      repeaterActive: this.#repeaterActive,
      completed: this.#completed,
      checkpointId: this.#checkpointIndex >= 0 ? this.#level.checkpoints[this.#checkpointIndex].id : null,
      respawnPosition: { ...this.#respawnPosition },
      enemies: this.#enemies.map((enemy) => ({ ...enemy })),
      combat: this.#combat.snapshot,
      message: this.#messageRemaining > 0 ? this.#message : '',
      interactPrompt: this.#prompt,
      time: this.#time,
    };
  }

  update(deltaSeconds, playerSnapshot, inputFrame = EMPTY_INPUT) {
    if (!Number.isFinite(deltaSeconds) || deltaSeconds <= 0) {
      throw new RangeError('deltaSeconds deve ser finito e maior que zero.');
    }
    if (!playerSnapshot?.body) throw new TypeError('playerSnapshot.body é obrigatório.');
    const player = playerSnapshot.body;
    this.#time += deltaSeconds;
    this.#messageRemaining = Math.max(0, this.#messageRemaining - deltaSeconds);
    this.#contactCooldown = Math.max(0, this.#contactCooldown - deltaSeconds);

    for (let index = this.#checkpointIndex + 1; index < this.#level.checkpoints.length; index += 1) {
      const checkpoint = this.#level.checkpoints[index];
      if (player.x + player.width / 2 < checkpoint.x) break;
      this.#checkpointIndex = index;
      this.#respawnPosition = { x: checkpoint.x, y: checkpoint.y - player.height };
      this.#setMessage('PONTO DE SINCRONIZAÇÃO // CHECKPOINT ATIVADO.', 3);
    }

    for (const enemy of this.#enemies) {
      if (!enemy.alive) continue;
      enemy.x += enemy.direction * enemy.speed * deltaSeconds;
      if (enemy.x <= enemy.patrolMin) {
        enemy.x = enemy.patrolMin;
        enemy.direction = 1;
      } else if (enemy.x + enemy.width >= enemy.patrolMax) {
        enemy.x = enemy.patrolMax - enemy.width;
        enemy.direction = -1;
      }
      if (enemy.fireInterval > 0) {
        enemy.fireRemaining = Math.max(0, enemy.fireRemaining - deltaSeconds);
        const playerCenter = player.x + player.width / 2;
        const enemyCenter = enemy.x + enemy.width / 2;
        const sameLane = Math.abs((player.y + player.height * 0.45) -
          (enemy.y + enemy.height * 0.5)) < 170;
        const inRange = Math.abs(playerCenter - enemyCenter) < 520;

        if (!sameLane || !inRange) {
          enemy.windupRemaining = 0;
        } else if (enemy.fireRemaining === 0 && enemy.windupRemaining === 0) {
          enemy.attackDirection = playerCenter < enemyCenter ? -1 : 1;
          enemy.windupRemaining = 0.38;
        } else if (enemy.windupRemaining > 0) {
          enemy.windupRemaining = Math.max(0, enemy.windupRemaining - deltaSeconds);
          if (enemy.windupRemaining === 0) {
            const originX = enemy.attackDirection > 0 ? enemy.x + enemy.width : enemy.x - 8;
            this.#combat.spawnEnemyProjectile({
              x: originX,
              y: enemy.y + enemy.height * 0.45,
              vx: enemy.attackDirection * enemy.projectileSpeed,
              vy: Math.sign((player.y + player.height * 0.45) -
                (enemy.y + enemy.height * 0.45)) * 24,
              width: 9,
              height: 9,
              damage: 1,
              lifetimeSeconds: 3,
              sourceId: enemy.id,
            });
            enemy.fireRemaining = enemy.fireInterval;
          }
        }
      }
      if (near(player, enemy, 0) && this.#contactCooldown <= 0) {
        const hit = this.#combat.damagePlayer(1);
        if (hit.applied) {
          this.#contactCooldown = 0.65;
          this.#setMessage('BOLT // IMPACTO DETECTADO. PROCURE A COBERTURA.', 2.5);
        }
      }
    }

    const input = {
      ...inputFrame,
      pressed: [...(inputFrame.pressed ?? [])],
      released: [...(inputFrame.released ?? [])],
      held: [...(inputFrame.held ?? [])],
    };
    if (input.pressed.includes('weapon-1')) input.pressed.push(COMBAT_ACTIONS.WEAPON_1);
    if (input.pressed.includes('weapon-2')) input.pressed.push(COMBAT_ACTIONS.WEAPON_2);
    if (input.pressed.includes('weapon-3')) input.pressed.push(COMBAT_ACTIONS.WEAPON_3);
    if (input.pressed.includes('weapon-next')) input.pressed.push(COMBAT_ACTIONS.WEAPON_NEXT);
    if (input.held.includes('fire')) input.held.push(COMBAT_ACTIONS.FIRE);
    if (input.pressed.includes('fire')) input.pressed.push(COMBAT_ACTIONS.FIRE);

    const combatResult = this.#combat.update(deltaSeconds, playerSnapshot, 
      this.#enemies.filter((enemy) => enemy.alive), input);
    for (const hit of combatResult.enemyHits) {
      const target = this.#enemies.find((enemy) => enemy.id === hit.enemyId);
      if (!target || !target.alive) continue;
      target.health = Math.max(0, target.health - hit.damage);
      if (target.health === 0) {
        target.alive = false;
        this.#setMessage('NEXO // AMEAÇA NEUTRALIZADA. ROTA MAIS SEGURA.', 2.2);
      }
    }

    const cache = this.#level.interactables.find((item) => item.kind === 'secret');
    const repeater = this.#level.interactables.find((item) => item.kind === 'objective');
    this.#prompt = '';
    if (!this.#completed) {
      if (cache && !this.#secretFound && near(player, cache)) this.#prompt = cache.prompt;
      else if (repeater && near(player, repeater)) this.#prompt = repeater.prompt;
    }
    if (input.pressed.includes('interact') && !this.#completed) {
      if (cache && !this.#secretFound && near(player, cache)) {
        this.#secretFound = true;
        this.#setMessage('REGISTRO DE EVACUAÇÃO // CYBERCORE RECEBEU UM AVISO ANTES DO COLAPSO.', 5);
      } else if (repeater && near(player, repeater)) {
        this.#repeaterActive = true;
        this.#completed = true;
        this.#objectiveIndex = this.#level.objectives.length - 1;
        this.#setMessage('NEXO // REPETIDOR RESTAURADO. A FÁBRICA DE ECOS FOI LOCALIZADA.', 6);
      }
    }
    while (this.#objectiveIndex < this.#level.objectives.length - 1 &&
      player.x >= this.#level.objectives[this.#objectiveIndex].thresholdX) {
      this.#objectiveIndex += 1;
    }
    return this.snapshot;
  }

  respawn() {
    this.#combat.respawnPlayer();
    this.#enemies = this.#level.enemies.map(cloneEnemy);
    this.#contactCooldown = 0;
    this.#setMessage('NEXO // SINCRONIZAÇÃO RESTAURADA. CONTINUE.', 3.5);
    return { ...this.#respawnPosition };
  }

  reset() {
    this.#combat.reset();
    this.#enemies = this.#level.enemies.map(cloneEnemy);
    this.#objectiveIndex = 0;
    this.#secretFound = false;
    this.#repeaterActive = false;
    this.#completed = false;
    this.#time = 0;
    this.#checkpointIndex = -1;
    this.#respawnPosition = { ...this.#level.spawn };
    this.#contactCooldown = 0;
    this.#setMessage('NEXO // MAPA PARCIAL RECUPERADO. PROCURE O REPETIDOR.', 5);
    return this.snapshot;
  }

  #setMessage(message, duration) {
    this.#message = message;
    this.#messageRemaining = duration;
  }
}
