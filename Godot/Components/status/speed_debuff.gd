extends StatusEffectBase
class_name SpeedDebuff

@export var speed_reduction_ratio: float

func _ready() -> void:
	super._ready()
	pass


# Validates whether the target has a move component.
func validate_target() -> bool:
	if target and target.move_component:
		return true
	return false

func process_effect():
	print("i am speed")
	if target and target.move_component:
		target.move_component.change_speed(speed_reduction_ratio)
		print("current speed" + str(target.move_component.speed))

func on_tick_timer_timeout():
	process_effect()
	tick_count += 1
	print("Removed a tick! Tick count is " + str(tick_count))
	
	if tick_count >= max_ticks:
		target.move_component.reset_speed()
		print_debug("Effect ended. Cleaing up")
		_remove_status()
