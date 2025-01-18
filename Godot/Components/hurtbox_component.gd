extends Area2D
class_name HurtboxComponent

@export var health_component:HealthComponent
@export var status_effects_handler: StatusEffectHandler

func _ready() -> void:
	add_to_group("Hurtbox")

func relay_damage(attack: AttackComponent):
	if HealthComponent:
		health_component.take_damage(attack)
	else :
		("no health component")

func relay_status_effect(status: PackedScene):
	if status_effects_handler:
		status_effects_handler.add_effect(status.instantiate())
	else:
		print("no status effect handler")
