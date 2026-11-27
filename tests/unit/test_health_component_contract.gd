extends BoltTest
## Contratos de eventos e transições do componente de vida.

func test_health_damage_emits_one_change_and_one_depletion_per_lifecycle() -> bool:
	var health: BoltHealth = BoltHealth.new()
	health.max_health = 2
	tree.root.add_child(health)
	await tree.process_frame

	var changes: Array[Vector2i] = []
	var depletion_count: Array[int] = [0]
	health.health_changed.connect(func(current: int, maximum: int) -> void:
		changes.append(Vector2i(current, maximum))
	)
	health.depleted.connect(func() -> void:
		depletion_count[0] += 1
	)

	check(not health.apply_damage(0), "dano zero é rejeitado")
	check(not health.apply_damage(-1), "dano negativo é rejeitado")
	check_eq(health.current_health, 2, "dano inválido não altera a vida")
	check(changes.is_empty(), "dano inválido não emite health_changed")

	check(health.apply_damage(1), "primeiro dano válido é aceito")
	check(health.apply_damage(1), "dano que esgota a vida é aceito")
	check(not health.apply_damage(1), "dano após esgotamento é rejeitado")
	check(not health.restore(1), "restore comum não revive vida esgotada")
	check_eq(health.current_health, 0, "vida permanece esgotada")
	check_eq(changes.size(), 2, "cada redução válida emite uma atualização")
	check_eq(changes[0], Vector2i(1, 2), "primeira atualização informa vida atual e máxima")
	check_eq(changes[1], Vector2i(0, 2), "atualização terminal informa vida zero e máxima")
	check_eq(depletion_count[0], 1, "depleted é emitido uma vez na transição para zero")

	health.restore_full()
	check_eq(health.current_health, 2, "restore_full inicia novo ciclo de vida")
	check_eq(changes.size(), 3, "restore_full emite atualização de vida")
	check_eq(changes[2], Vector2i(2, 2), "restauração completa informa vida máxima")
	check_eq(depletion_count[0], 1, "restauração não reemite depleted")

	check(health.apply_damage(2), "novo ciclo aceita dano após restore_full")
	check_eq(depletion_count[0], 2, "novo esgotamento emite um novo evento terminal")
	health.queue_free()
	await tree.process_frame
	return true
