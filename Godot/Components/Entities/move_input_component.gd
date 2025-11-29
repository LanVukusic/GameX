extends Node
class_name MoveInputComponent

@export var move_component: CharacterMoveComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass

func handle_input(direction: Vector2):
	move_component.move_vector = direction
