extends Node
class_name CircularMovementComponent

@export var movement_component: MoveComponent

# Parameters for circular mot(ion
var center: Vector2
var radius: float = 100                  # Radius of the circle
var angular_speed: float = 1.0           # Speed of the rotation (radians per second)
var angle: float = 0.0                   # Current angle in radians

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if movement_component:
	   # Update the angle for circular motion
		angle += angular_speed * delta
		
		# Calculate the velocity vector for circular motion
		var tangential_velocity = Vector2(
			-sin(angle),  # X-component of tangential velocity
			cos(angle)    # Y-component of tangential velocity
			) * angular_speed * radius
		# Update the velocity of the movement component
		movement_component.velocity = tangential_velocity

func get_center() -> void:
	center = movement_component.actor.global_position
