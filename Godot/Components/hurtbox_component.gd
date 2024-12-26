extends Area2D
class_name HurtboxComponent

@export var health_component:HealthComponent

func _ready() -> void:
	add_to_group("Hurtbox")

func relay_damage(attack: AttackComponent):
	health_component.take_damage(attack)
