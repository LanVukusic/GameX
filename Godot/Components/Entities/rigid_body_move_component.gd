extends Node
class_name RigidBodyMoveComponent

@export var actor: RigidBody2D
@export var force: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func one_time_move_impulse(vector: Vector2):
	actor.apply_central_impulse(vector * force)
