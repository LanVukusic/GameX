extends Node
class_name HealthComponent
 
signal sig_died
signal sig_health_changed(hp: int)

@export var max_health: int

var health: int:
		set(value):
			health = clampi(value, 0, max_health)
			sig_health_changed.emit(value)
			print(value)
			if health == 0:
				sig_died.emit()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_health(max_health)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func take_damage(attack: AttackComponent):
	health -= attack.damage
	pass

func _init_health(value: int):
	health = value

func force_signal():
	sig_health_changed.emit(health)
