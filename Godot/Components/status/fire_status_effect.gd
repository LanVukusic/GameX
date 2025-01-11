extends StatusEffectBase
class_name FireStatusEffect

func _ready() -> void:
	tick_timer.timeout.connect(_on_tick_timer_timeout)
