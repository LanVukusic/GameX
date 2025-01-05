extends Area2D
class_name HurtboxComponent

@export var health_component:HealthComponent
@export var status_effects_handler: StatusEffectHandler

func _ready() -> void:
	add_to_group("Hurtbox")

func relay_damage(attack: AttackComponent):
	if HealthComponent:
		health_component.take_damage(attack)

func relay_status_effect(status: StatusEffectBase):
	if StatusEffectHandler:
		status_effects_handler.apply_effect(status)
