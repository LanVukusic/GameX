extends StatusEffectBase
class_name SpeedDebuff

@export var speed_reduction_ratio: float


func process_effect():
	target.move_component.change_speed(speed_reduction_ratio)
	print("current speed" + str(target.move_component.speed))
