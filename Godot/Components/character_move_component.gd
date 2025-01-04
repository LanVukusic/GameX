extends Node
class_name CharacterMoveComponent

@export var speed: int
@export var actor: Node2D
var move_vector: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	actor.velocity = move_vector
	actor.move_and_slide()
	pass
