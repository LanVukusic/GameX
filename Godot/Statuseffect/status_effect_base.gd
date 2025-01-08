extends Node2D
class_name StatusEffectBase

signal sig_status_end(effect: StatusEffectBase)

var target: StatusEffectHandler
var stack_count: int = 0

#Timers private
var damage_timer: Timer
var duration_timer: Timer
var particles: GPUParticles2D

#relevant_exported_variables(could be moved in the future)
@export var type: String
@export var duration: int 
@export var max_stacks: int
@export var can_refresh: bool = true #Whether to refresh duration on stacking
@export var damage_per_second: int
@export var particle_effect: ParticleProcessMaterial

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func apply(status_effect_handler: StatusEffectHandler):
	
	if not is_instance_valid(status_effect_handler):
		print("Error: Target is no longer valid. Cannot apply status effect")
		queue_free()
		return
	add_stack()
	
	target = status_effect_handler
	
	if not particles:
		particles = GPUParticles2D.new()
		particles.amount = 1000
		particles.process_material = particle_effect
		particles.z_index = 3
		target.add_child(particles)
	
	if not damage_timer:
		damage_timer = create_timer(1, false, self._on_damage_timer_timeout)
	if not duration_timer:
		duration_timer = create_timer(duration, true, self._on_duration_timer_timeout)


func _on_damage_timer_timeout():
	if not is_instance_valid(target):
		print("Error: target has been freed")
		self.queue_free()
		return	
	
	var attack = AttackComponent.new()
	attack.damage = damage_per_second * stack_count
	target.health_component.take_damage(attack)


func _on_duration_timer_timeout():
	stack_count -= 1
	print("critical!")
	print("Removed! stack count is " + str(stack_count))
	if can_refresh:
		refresh_duration()
		print("refreshed")
	if stack_count <= 0:
		print_debug("Effect ended. Cleaing up")
		if particles:
			particles.queue_free()
		sig_status_end.emit(self)
		self.queue_free()
		stop_all_timers()


func stop_all_timers():
	for child in get_children():
		if child is Timer:
			print(child)
			child.stop()


func create_timer(wait_time: float, one_shot: bool, callback: Callable) -> Timer:
	var timer = Timer.new()
	timer.one_shot = one_shot
	timer.timeout.connect(callback)
	target.add_child(timer)
	timer.start(wait_time)
	return timer


func add_stack():
	if stack_count < max_stacks:
		stack_count += 1
		print("Stack added. Current stack count: " + str(stack_count))
		if can_refresh:
			refresh_duration()
	else:
		print("Max stacks reached. Current stack count: " + str(stack_count))


func refresh_duration():
	if duration_timer:
		duration_timer.start(duration) # Reset duration timer
