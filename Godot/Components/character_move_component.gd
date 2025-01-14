extends Node
class_name CharacterMoveComponent

@export var default_speed: float
@export var speed: float
@export var actor: CharacterBody2D
var move_vector: Vector2 = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if actor:
		actor.velocity = move_vector * speed
		actor.move_and_slide()
		pass

func change_speed(ratio: float) -> void:
	speed *= ratio

func reset_speed():
	speed = default_speed
