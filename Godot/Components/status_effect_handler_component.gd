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
			print("already applied")
			if existing_effect.can_refresh:
					existing_effect.refresh_duration()
			return
	
	if not effect.sig_status_end.is_connected(remove_effect):
		effect.sig_status_end.connect(remove_effect)

	
	active_effects.append(effect)
	effect.apply(self)
	print(active_effects)


func remove_effect(effect_instance: StatusEffectBase):
	if not is_instance_valid(effect_instance):
		print("Warning: attempted to remove an invalid effect instance.")
		return
	
	if effect_instance in active_effects:
		active_effects.erase(effect_instance)
		print("WORKS PLZ")
	
