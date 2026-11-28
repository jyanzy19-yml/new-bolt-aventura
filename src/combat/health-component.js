function assertPositiveFinite(value, name) {
  if (!Number.isFinite(value) || value <= 0) {
    throw new RangeError(`${name} deve ser finito e maior que zero.`);
  }
}

/**
 * Health is a gameplay-domain component; it has no rendering or scene ownership.
 * Invulnerability, knockback and healing-item policy are intentionally external.
 */
export class HealthComponent {
  #maxHealth;
  #currentHealth;

  constructor({ maxHealth, currentHealth = maxHealth }) {
    assertPositiveFinite(maxHealth, 'maxHealth');
    if (!Number.isFinite(currentHealth) || currentHealth < 0 || currentHealth > maxHealth) {
      throw new RangeError('currentHealth deve estar entre zero e maxHealth.');
    }

    this.#maxHealth = maxHealth;
    this.#currentHealth = currentHealth;
  }

  get maxHealth() {
    return this.#maxHealth;
  }

  get currentHealth() {
    return this.#currentHealth;
  }

  get defeated() {
    return this.#currentHealth <= 0;
  }

  applyDamage(amount) {
    assertPositiveFinite(amount, 'amount');
    const applied = Math.min(amount, this.#currentHealth);
    this.#currentHealth -= applied;

    return {
      applied,
      currentHealth: this.#currentHealth,
      defeated: this.defeated,
    };
  }

  heal(amount) {
    assertPositiveFinite(amount, 'amount');
    const healed = Math.min(amount, this.#maxHealth - this.#currentHealth);
    this.#currentHealth += healed;

    return {
      healed,
      currentHealth: this.#currentHealth,
      defeated: this.defeated,
    };
  }

  reset(currentHealth = this.#maxHealth) {
    if (!Number.isFinite(currentHealth) || currentHealth < 0 || currentHealth > this.#maxHealth) {
      throw new RangeError('currentHealth deve estar entre zero e maxHealth.');
    }
    this.#currentHealth = currentHealth;
    return this.currentHealth;
  }
}
