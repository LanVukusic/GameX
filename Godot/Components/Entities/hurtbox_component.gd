extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent
@export var status_effects_handler: StatusEffectHandler

# Signal the parent (Dummy/Player) when hit, passing the physics info
signal sig_hit_received(hit: HitInfo)

func _ready() -> void:
	add_to_group("Hurtbox")

# Updated to accept HitInfo instead of AttackComponent
func relay_damage(hit: HitInfo):
	
	# 1. Handle Health (Extract the number)
	if health_component:
		health_component.take_damage(hit.damage)
	else:
		print("no health component")
	
	# 2. Handle Physics/Logic (Pass the whole object up)
	sig_hit_received.emit(hit)

func relay_status_effect(status: PackedScene):
	if status_effects_handler:
		status_effects_handler.add_effect(status.instantiate())
	else:
		print("no status effect handler")
