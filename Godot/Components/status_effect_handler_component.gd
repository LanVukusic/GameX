extends Node2D
class_name StatusEffectHandler

@export var health_component: HealthComponent
@export var move_component: CharacterMoveComponent

@export var active_effects: Array[StatusEffectBase]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func apply_effect(effect: StatusEffectBase):
	active_effects.append(effect)
	effect.apply(self)
	pass


func remove_effect(effect_instance: StatusEffectBase):
	if effect_instance.particles:
		effect_instance.particles.queue_free()  # Clean up particles
		active_effects.erase(effect_instance)
	effect_instance.queue_free()
