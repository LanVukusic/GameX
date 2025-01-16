extends StatusEffectBase
class_name FireStatus

@export var damage_per_tick: int

func _ready() -> void:
	pass

func validate_target() -> bool:
	if target and target.health_component:
		return true
	return false

func process_effect():
	print("dmg")
	var attack = AttackComponent.new()
	attack.damage = damage_per_tick * stack_count
	target.health_component.take_damage(attack)
