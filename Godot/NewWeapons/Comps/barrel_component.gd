extends Node2D
class_name BarrelComponent

var rng_gen: RandomNumberGenerator = RandomNumberGenerator.new()
@export var spread_angle: float

@export var raycasts: Array[RayCast2D]
# Called when the node enters the scene tree for the first time.
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Suggestion: Initialize the raycasts array here to ensure it's an empty array before adding children.
	raycasts = []
	for child in self.get_children():
		if child is RayCast2D:
			raycasts.append(child) # Collect all RayCast2D nodes for later use.
	
	print("BarrelComponent ready: Raycasts initialized.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _add_spread(vector: Vector2) -> Vector2:
	var rand_angle = rng_gen.randf_range(-spread_angle / 2, spread_angle / 2)
	#vector = Vector2.from_angle(rand_angle).normalized()
	return vector.rotated(rand_angle)

func spawn_bullet(projectile: PackedScene):
	if projectile == null:
		return
	else:
		for raycast in raycasts:
			var bullet = projectile.instantiate() as Projectile
			bullet.global_position = raycast.global_position
			bullet.rotation = self.global_rotation + raycast.target_position.angle()
			bullet.move_component.one_time_move_impulse(_add_spread(Vector2.from_angle(bullet.rotation)))
			get_tree().get_root().add_child(bullet)
