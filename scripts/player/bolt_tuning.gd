class_name BoltTuning
extends Resource
## Parâmetros de movimento de BOLT.
##
## *** TODOS OS VALORES SÃO PROVISÓRIOS ***: ponto de partida de engenharia para a sandbox de
## movimento, NÃO valores aprovados nem medidos (docs/game-design/04-gameplay-systems.md §1:
## "não inventar valores finais"). Devem ser ajustados com teste de sensação em aparelho e
## registrados com build/aparelho. Unidades: pixels do viewport base (960×540) e segundos.
##
## O conjunto de habilidades implementado cobre: pulo normal, pulo variável, pulo duplo,
## buffer de pulo, coyote time, controle aéreo e dash (All Jump, parcial). Wall slide/wall jump
## ainda NÃO estão implementados.

@export_group("Corrida")
@export var run_speed: float = 220.0
@export var ground_accel: float = 1600.0
@export var ground_decel: float = 2000.0
## Fração da aceleração de solo disponível no ar (controle aéreo).
@export_range(0.0, 1.5) var air_control: float = 0.85
@export var air_decel: float = 900.0

@export_group("Pulo")
@export var jump_height: float = 112.0
@export var jump_time_to_apex: float = 0.40
@export var fall_gravity_multiplier: float = 1.5
@export var max_fall_speed: float = 720.0
## Multiplicador da velocidade vertical ao soltar o botão durante a subida (pulo variável).
@export_range(0.0, 1.0) var jump_cut_multiplier: float = 0.45
@export_range(0, 3) var air_jumps: int = 1
## Fração da velocidade de pulo usada pelo pulo aéreo.
@export_range(0.3, 1.2) var air_jump_multiplier: float = 0.9
@export var coyote_time: float = 0.10
@export var jump_buffer: float = 0.12

@export_group("Dash")
@export var dash_speed: float = 520.0
@export var dash_duration: float = 0.16
## Tempo total entre o início de um dash e o próximo.
@export var dash_cooldown: float = 0.45
@export var dash_buffer: float = 0.12


## Gravidade (px/s²) derivada de altura e tempo até o ápice.
func gravity() -> float:
	return 2.0 * jump_height / (jump_time_to_apex * jump_time_to_apex)


## Velocidade inicial de pulo (px/s, positiva) derivada de altura e tempo até o ápice.
func jump_velocity() -> float:
	return 2.0 * jump_height / jump_time_to_apex
