extends Node
class_name HealthComponent

signal sig_died
signal sig_health_changed(hp: int)

@export var max_health: int = 100  # Default maximum health

var _health: int = 0  # Backing variable for health


var health: int:
	get:
		return _health
	set(value):
		# Clamp value and update health
		value = clamp(value, 0, max_health)
		if _health != value:  # Only emit signals if the value changes
			_health = value
			sig_health_changed.emit(_health)  # Emit health changed signal
			print("Health changed to:", _health)
			# Emit death signal if health is zero
			if _health == 0:
				sig_died.emit()  # Emit died signal

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	_init_health(max_health)
	call_deferred("_emit_initial_health")

# Method to handle taking damage
func take_damage(attack: AttackComponent):
	health -= attack.damage

# Method to initialize health
func _init_health(value: int):
	health = value



func _emit_initial_health() -> void:
	sig_health_changed.emit(_health)  # Emit the initial health signal after everything is ready
