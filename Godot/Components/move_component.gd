extends Node
class_name MoveComponent

@export var speed: int
@export var actor: Node2D
var move_vector: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if actor is CharacterBody2D:
		actor.velocity = move_vector
		actor.move_and_slide()
	if actor is RigidBody2D:
		actor.apply_impulse()
	pass
