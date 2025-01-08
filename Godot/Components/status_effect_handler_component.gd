extends Node2D
class_name StatusEffectHandler

@export var health_component: HealthComponent
@export var move_component: CharacterMoveComponent

@export var active_effects: Array[StatusEffectBase]


func add_effect(effect: StatusEffectBase):
	if not is_instance_valid(effect):
		print("Error: Effect is invalid. Cannot apply.")
		return
	
	for existing_effect in active_effects:
		if is_instance_valid(existing_effect) and existing_effect.type == effect.type:
			existing_effect.apply(self)
			return
	
	active_effects.append(effect)
	effect.sig_status_end.connect(remove_effect)
	effect.apply(self)
	print(active_effects)


func remove_effect(effect_instance: StatusEffectBase):
	if not is_instance_valid(effect_instance):
		print("Warning: attempted to remove an invalid effect instance.")
		return
	
	if effect_instance.particles and is_instance_valid(effect_instance):
		effect_instance.particles.queue_free()  # Clean up particles
	
	if effect_instance in active_effects:
		active_effects.erase(effect_instance)
		print("WORKS PLZ")
	
	effect_instance.queue_free()
	print("effect removed: " + str(effect_instance))


func clear_effects():
	for effect in active_effects:
		if is_instance_valid(effect):
			effect.queue_free()
	active_effects.clear()
