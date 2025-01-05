extends Node
class_name CharacterMoveComponent

@export var speed: int
@export var actor: CharacterBody2D
var move_vector: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if actor:
		actor.velocity = move_vector * speed
		actor.move_and_slide()
		pass
