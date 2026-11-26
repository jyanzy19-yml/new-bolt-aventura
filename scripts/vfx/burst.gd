class_name Burst
extends RefCounted
## Explosões de partículas curtas e baratas (CPUParticles2D, compatível com GL Compatibility).
##
## Cada burst é descartável: dispara uma vez e é liberado por um timer. Há um TETO de bursts
## simultâneos para que uma sequência de eventos (vários tiros/impactos) nunca acumule nós em
## aparelhos modestos; acima do teto, o efeito é simplesmente omitido (feedback é opcional).

const MAX_ACTIVE: int = 24

static var _active: int = 0
static var _fade: Gradient


static func active_count() -> int:
	return _active


## Cria um burst em `position` (coordenadas globais) como filho de `parent`.
## `direction` aponta o centro do leque; `spread_degrees` é o ângulo total. Retorna o nó
## (ou null se omitido por teto/parâmetros inválidos).
static func spawn(parent: Node, position: Vector2, color: Color, amount: int = 8, speed: float = 120.0,
		lifetime: float = 0.35, direction: Vector2 = Vector2.UP, spread_degrees: float = 140.0,
		size: float = 3.0, gravity: float = 260.0) -> CPUParticles2D:
	if parent == null or not parent.is_inside_tree() or _active >= MAX_ACTIVE or amount <= 0:
		return null
	if _fade == null:
		_fade = Gradient.new()
		_fade.set_color(0, Color(1.0, 1.0, 1.0, 1.0))
		_fade.set_color(1, Color(1.0, 1.0, 1.0, 0.0))
	var particles: CPUParticles2D = CPUParticles2D.new()
	particles.one_shot = true
	particles.explosiveness = 1.0
	particles.amount = amount
	particles.lifetime = lifetime
	particles.direction = direction
	particles.spread = spread_degrees * 0.5
	particles.initial_velocity_min = speed * 0.5
	particles.initial_velocity_max = speed
	particles.gravity = Vector2(0.0, gravity)
	particles.scale_amount_min = size * 0.6
	particles.scale_amount_max = size
	particles.color = color
	particles.color_ramp = _fade
	particles.emitting = false
	particles.z_index = 5
	parent.add_child(particles)
	particles.global_position = position
	particles.emitting = true
	_active += 1
	parent.get_tree().create_timer(lifetime + 0.25).timeout.connect(_release.bind(particles.get_instance_id()))
	return particles


## Recebe ObjectID, não a referência do Node: o pai pode ser destruído antes do timer.
## Assim o callback continua tipável e sempre libera o contador, mesmo se a partícula já sumiu.
static func _release(particles_instance_id: int) -> void:
	_active = maxi(0, _active - 1)
	var particle_object: Object = instance_from_id(particles_instance_id)
	if particle_object is CPUParticles2D:
		(particle_object as CPUParticles2D).queue_free()
