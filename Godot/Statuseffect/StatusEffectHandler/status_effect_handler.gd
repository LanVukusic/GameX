extends Node2D
class_name StatusEffectHandler

#keep track of effects

@export var effect_stack: Array[StatusEffectBase]
@export var player: Player = self.get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
