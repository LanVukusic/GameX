extends Node2D
class_name StatusEffectBase

signal status_end

var target: StatusEffectHandler

@export var duration: int
@export var damage_per_second: int
@export var particle_effect: ParticleProcessMaterial
var particles: GPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func apply(thing_to_apply: StatusEffectHandler):
	target = thing_to_apply
	particles = GPUParticles2D.new()
	particles.amount = 1000
	particles.process_material = particle_effect
	particles.z_index = 3
	target.add_child(particles)
	
	
	var damage_timer = Timer.new()
	damage_timer.name = "DamageTimer"
	damage_timer.one_shot = false
	damage_timer.timeout.connect(_on_damage_timer_timeout)
	add_child(damage_timer)
	damage_timer.start(1)

	var duration_timer = Timer.new()
	duration_timer.name = "DurationTimer"
	duration_timer.one_shot = true
	duration_timer.timeout.connect(_on_duration_timer_timeout)
	add_child(duration_timer)
	duration_timer.start(duration)

func _on_damage_timer_timeout():
	var attack = AttackComponent.new()
	attack.damage = damage_per_second
	target.health_component.take_damage(attack)
	pass

func _on_duration_timer_timeout():
	if particles:
		particles.emitting = false
		particles.queue_free()
	status_end.emit()
	queue_free()
