class_name ActionBuffer
extends Node
## Buffer de pressionamentos de ações (docs/technical/02-touch-and-display.md §2).
##
## Registra QUANDO uma ação foi pressionada, a partir dos EVENTOS (`_input`), e a consome no tick
## de física. Assim um toque curto que começa e termina entre dois ticks (por exemplo durante
## uma queda momentânea de FPS) não é perdido: `Input.is_action_just_pressed` devolveria false
## nesse caso, mas o buffer ainda guarda o pressionamento.
##
## A idade é medida em TICKS DE FÍSICA (tempo de jogo), não em relógio de parede. Motivo: num
## pico de quadros o relógio avança muito enquanto a simulação dá só um tick; medir em relógio
## faria um toque válido expirar antes de ser processado. Em tempo de jogo a janela se mantém
## coerente com o que o jogador vê acontecer. Também torna os testes determinísticos.
##
## O estado "mantido" NÃO é duplicado aqui: use `Input.is_action_pressed`, que continua correto
## quando as ações são soltas à força (pausa, troca de cena, perda de foco).

## Janela padrão (s de tempo de jogo). PROVISÓRIO — valor de trabalho, a ser medido em aparelho.
const DEFAULT_WINDOW: float = 0.12

@export var tracked_actions: Array[StringName] = [Actions.JUMP, Actions.DASH]

## ação -> índice do tick de física em que foi pressionada
var _pressed_at_tick: Dictionary = {}


func _input(event: InputEvent) -> void:
	for action: StringName in tracked_actions:
		if event.is_action_pressed(action, false):
			_pressed_at_tick[action] = Engine.get_physics_frames()


## Há um pressionamento recente (dentro da janela, em segundos de tempo de jogo) ainda não consumido?
func has_pending(action: StringName, window: float = DEFAULT_WINDOW) -> bool:
	if not _pressed_at_tick.has(action):
		return false
	var age_ticks: int = Engine.get_physics_frames() - int(_pressed_at_tick[action])
	var age: float = float(age_ticks) / float(Engine.physics_ticks_per_second)
	# Tolerância de meio tick: 0,12 s = 7,2 ticks; sem isso o limite oscilaria por arredondamento.
	return age <= window + 0.5 / float(Engine.physics_ticks_per_second)


## Consome o pressionamento pendente. Retorna true no máximo uma vez por pressionamento.
func consume(action: StringName, window: float = DEFAULT_WINDOW) -> bool:
	var pending: bool = has_pending(action, window)
	_pressed_at_tick.erase(action)
	return pending


## Descarta pressionamentos pendentes (pausa, respawn, troca de cena).
func clear() -> void:
	_pressed_at_tick.clear()
