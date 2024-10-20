@tool
extends Node
class_name Damagable

@export_category("Configurable")
@export var maxHealth: float

@export_category("Read-only debug readout")
@export var health: float

signal damageTaken(damage: float)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func dealDamage(damage: float):
	health -= damage
	damageTaken.emit(damage)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	push_error()
	pass

# func _get_configuration_warnings() -> PackedStringArray:
# 	return ["penis"]