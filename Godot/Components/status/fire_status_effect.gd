extends StatusEffectBase
class_name FireStatusEffect

@export var damage_per_tick: int

func _ready() -> void:
	tick_timer.timeout.connect(_on_tick_timer_timeout)

func process_effect():
	print("dmg")
	var attack = AttackComponent.new()
	attack.damage = damage_per_tick * stack_count
	target.health_component.take_damage(attack)
