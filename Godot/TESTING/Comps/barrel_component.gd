extends Node2D
class_name BarrelComponent

@export var raycasts: Array[RayCast2D]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in self.get_children():
		if child is RayCast2D:
			raycasts.append(child)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_bullet(projectile: PackedScene):
	if projectile == null:
		return
	else:
		for raycast in raycasts:
			var bullet = projectile.instantiate() as Projectile
			bullet.global_position = raycast.global_position
			bullet.rotation = self.global_rotation + raycast.target_position.angle()
			bullet.move_component.one_time_move_impulse(Vector2.from_angle(bullet.rotation))
			get_tree().get_root().add_child(bullet)
