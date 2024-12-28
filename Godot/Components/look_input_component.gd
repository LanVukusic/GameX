extends Node
class_name LookInputComponent

@export var look_component: LookComponent
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func handle_look_direction(direction: Vector2):
	var target = direction.angle() + PI / 2
	var look_speed = 0.1
	look_component.actor.rotation = lerp_angle(look_component.actor.rotation, target, look_speed)
