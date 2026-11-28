function overlapsExpanded(body, target, padding = 58) {
  return (
    body.x <= target.x + target.width + padding &&
    body.x + body.width >= target.x - padding &&
    body.y <= target.y + target.height + padding &&
    body.y + body.height >= target.y - padding
  );
}

function emptyFrame() {
  return { pressed: [], released: [], held: [] };
}

/**
 * W1-L1 objective, optional secret, patrol and synchronization state.
 * It is intentionally independent from DOM, rendering and player physics.
 */
export class W1L1GameRuntime {
  #level;
  #objectiveIndex = 0;
  #secretFound = false;
  #checkpointActive = false;
  #completed = false;
  #enemy;
  #message = 'NEXO // SINAL FRAGMENTADO DETECTADO';
  #messageRemaining = 5;
  #messageFlags = new Set(['awakening']);
  #interactPrompt = '';
  #time = 0;
  #enemyContact = false;
  #contactCooldown = 0;
  #contactResolution = null;

  constructor(level) {
    if (!level || level.id !== 'w1-l1' || !Array.isArray(level.objectives)) {
      throw new TypeError('W1L1GameRuntime exige os dados de produção W1-L1.');
    }
    this.#level = level;
    this.#enemy = { ...level.enemy, direction: 1 };
  }

  get snapshot() {
    return {
      objectiveIndex: this.#objectiveIndex,
      objective: this.#level.objectives[this.#objectiveIndex]?.label ?? 'Fase concluída',
      objectiveCount: this.#level.objectives.length,
      secretFound: this.#secretFound,
      checkpointActive: this.#checkpointActive,
      completed: this.#completed,
      enemy: { ...this.#enemy },
      enemyContact: this.#enemyContact,
      contactResolution: this.#contactResolution ? { ...this.#contactResolution } : null,
      interactPrompt: this.#interactPrompt,
      message: this.#messageRemaining > 0 ? this.#message : '',
      time: this.#time,
    };
  }

  update(deltaSeconds, playerSnapshot, inputFrame = emptyFrame()) {
    if (!Number.isFinite(deltaSeconds) || deltaSeconds <= 0) {
      throw new RangeError('deltaSeconds deve ser finito e maior que zero.');
    }
    if (!playerSnapshot?.body) {
      throw new TypeError('playerSnapshot.body é obrigatório.');
    }
    if (!Array.isArray(inputFrame.pressed)) {
      throw new TypeError('inputFrame.pressed deve ser um array.');
    }

    this.#time += deltaSeconds;
    this.#messageRemaining = Math.max(0, this.#messageRemaining - deltaSeconds);
    this.#contactCooldown = Math.max(0, this.#contactCooldown - deltaSeconds);
    this.#enemyContact = false;
    this.#contactResolution = null;

    const player = playerSnapshot.body;
    if (!this.#completed) {
      if (!this.#messageFlags.has('movement') && player.x >= 150) {
        this.#messageFlags.add('movement');
        this.#setMessage('MOVIMENTO // USE OS CONTROLES LATERAIS PARA AVANÇAR.', 3.5);
      }
      if (inputFrame.pressed.includes('jump') && playerSnapshot.jumpsRemaining === 1 &&
          !this.#messageFlags.has('variable-jump')) {
        this.#messageFlags.add('variable-jump');
        this.#setMessage('SALTO // SEGURE PULAR PARA GANHAR ALTURA; SOLTE PARA ENCURTAR.', 4.5);
      }
      if (inputFrame.pressed.includes('jump') && playerSnapshot.jumpsRemaining === 0 &&
          !this.#messageFlags.has('double-jump')) {
        this.#messageFlags.add('double-jump');
        this.#setMessage('PULO DUPLO // PRESSIONE PULAR NOVAMENTE ENQUANTO ESTIVER NO AR.', 4.5);
      }
      while (
        this.#objectiveIndex < this.#level.objectives.length - 1 &&
        player.x >= this.#level.objectives[this.#objectiveIndex].thresholdX
      ) {
        this.#objectiveIndex += 1;
      }
    }

    this.#enemy.x += this.#enemy.direction * this.#enemy.speed * deltaSeconds;
    if (this.#enemy.x <= this.#enemy.patrolMin) {
      this.#enemy.x = this.#enemy.patrolMin;
      this.#enemy.direction = 1;
    } else if (this.#enemy.x + this.#enemy.width >= this.#enemy.patrolMax) {
      this.#enemy.x = this.#enemy.patrolMax - this.#enemy.width;
      this.#enemy.direction = -1;
    }

    if (overlapsExpanded(player, this.#enemy, 0)) {
      this.#enemyContact = true;
      const standingAbove = player.y + player.height <= this.#enemy.y + 10;
      if (!standingAbove && this.#contactCooldown === 0) {
        const playerCenter = player.x + player.width / 2;
        const enemyCenter = this.#enemy.x + this.#enemy.width / 2;
        const hitFromLeft = playerCenter < enemyCenter;
        this.#contactResolution = {
          x: hitFromLeft ? this.#enemy.x - player.width - 2 : this.#enemy.x + this.#enemy.width + 2,
          y: player.y,
          facing: hitFromLeft ? 1 : -1,
        };
        this.#contactCooldown = 0.45;
        this.#setMessage('UNIDADE DE MANUTENÇÃO // MOVIMENTO ERRÁTICO. DESVIE.', 2.5);
      }
    }

    const diagnostic = this.#level.interactables.find((item) => item.kind === 'secret');
    const synchronization = this.#level.interactables.find((item) => item.kind === 'completion');
    this.#interactPrompt = '';
    if (!this.#completed) {
      if (diagnostic && !this.#secretFound && overlapsExpanded(player, diagnostic)) {
        this.#interactPrompt = diagnostic.prompt;
      } else if (synchronization && overlapsExpanded(player, synchronization)) {
        this.#interactPrompt = synchronization.prompt;
      }
    }

    if (inputFrame.pressed.includes('interact') && !this.#completed) {
      if (diagnostic && !this.#secretFound && overlapsExpanded(player, diagnostic)) {
        this.#secretFound = true;
        this.#setMessage('REGISTRO // IDENTIDADE DE BOLT INCOMPLETA. DADOS CORROMPIDOS.', 6);
      } else if (synchronization && overlapsExpanded(player, synchronization)) {
        this.#checkpointActive = true;
        this.#completed = true;
        this.#objectiveIndex = this.#level.objectives.length - 1;
        this.#setMessage('NEXO // PONTO DE SINCRONIZAÇÃO ATIVADO.', 8);
      }
    }

    if (!this.#messageFlags.has('corridor') && player.x >= 760) {
      this.#messageFlags.add('corridor');
      this.#setMessage('NEXO // SINAL FRAGMENTADO. SIGA A RESSONÂNCIA.', 4.5);
    }
    if (!this.#messageFlags.has('courtyard') && player.x >= 1540) {
      this.#messageFlags.add('courtyard');
      this.#setMessage('NEXO // UMA FONTE DE SINCRONIZAÇÃO ESTÁ ADIANTE.', 4.5);
    }

    if (!this.#completed && player.x >= 1500 && inputFrame.pressed.includes('dash') &&
        !this.#messageFlags.has('dash')) {
      this.#messageFlags.add('dash');
      this.#setMessage('DASH // USE A HABILIDADE PARA ATRAVESSAR O PÁTIO COM AGILIDADE.', 4);
    }

    return this.snapshot;
  }

  #setMessage(message, duration) {
    this.#message = message;
    this.#messageRemaining = duration;
  }
}
