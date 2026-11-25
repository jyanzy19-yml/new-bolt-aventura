class_name Actions
extends RefCounted
## Fonte única dos nomes de ações lógicas do Input Map (docs/technical/05-system-contracts.md §1).
##
## O gameplay consome ações lógicas, nunca dispositivos. Teclado é auxiliar de desenvolvimento;
## o caminho de produto é touch (ver scripts/input/touch_controls.gd).
## As ações abaixo precisam existir em project.godot; `missing()` é usado pelo boot e pelos testes.

const MOVE_LEFT: StringName = &"move_left"
const MOVE_RIGHT: StringName = &"move_right"
const JUMP: StringName = &"jump"
const DASH: StringName = &"dash"
## Reservada para o ataque básico aprovado (Pistola Crono). Ainda sem consumidor na Etapa 0.
const ATTACK: StringName = &"attack"
const INTERACT: StringName = &"interact"
const PAUSE: StringName = &"pause"

const ALL: Array[StringName] = [MOVE_LEFT, MOVE_RIGHT, JUMP, DASH, ATTACK, INTERACT, PAUSE]


## Retorna as ações obrigatórias que não existem no Input Map.
static func missing() -> Array[StringName]:
	var result: Array[StringName] = []
	for action: StringName in ALL:
		if not InputMap.has_action(action):
			result.append(action)
	return result


## Solta todas as ações de jogo (não `ui_*`). Usado em pausa, troca de cena e perda de foco
## para que nenhum comando fique preso (docs/technical/02-touch-and-display.md §2 e §5).
static func release_all_game_actions() -> void:
	for action: StringName in ALL:
		if InputMap.has_action(action) and Input.is_action_pressed(action):
			Input.action_release(action)
