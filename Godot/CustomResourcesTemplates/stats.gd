extends Resource
class_name GeneralStats

signal health_changed(curr_health: int)
signal death

@export_category("Common stats")

@export var max_health: int

var health: int:
	set(value):
		health = clampi(value, 0, max_health)
		health_changed.emit(health)
		print(health)
		if health == 0:
			_on_death()
@export var move_speed: int

func take_damage(amount: int):
	health -= amount

func heal(amount: int):
	health += amount


func _on_death():
	death.emit()
	print("u ded")
