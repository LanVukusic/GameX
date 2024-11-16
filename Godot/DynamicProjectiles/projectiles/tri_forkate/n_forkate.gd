extends BaseProjectile
class_name NForkateBullet


@export var shot_dirs: Array[RayCast2D]

var shot_projectiles: Array[BaseProjectile]


func bullet_setup():
	for shot_i in len(shot_dirs):
		var trig_scn = self.active_stack.pop_front()
		if (trig_scn != null):
			shot_projectiles.push_front(trig_scn.instantiate().with_data(active_stack))


func spawn_trigger(body: Node):
	if (len(shot_projectiles) == 0):
		self.queue_free()
		return

	for shot_i in len(shot_projectiles):
		shot_projectiles[shot_i].position = self.position

		var magnitude = self.linear_velocity.length()
		var shot_angle = (shot_dirs[shot_i].target_position - shot_dirs[shot_i].position).angle() + self.linear_velocity.angle()
		var shot_vector = Vector2.from_angle(shot_angle).normalized()
		
		shot_projectiles[shot_i].linear_velocity = shot_vector * magnitude
		shot_projectiles[shot_i].add_collision_exception_with(body) # the new bullet should not collide with the same wall as parent
		get_tree().root.add_child(shot_projectiles[shot_i])
		self.queue_free()
		# return shot_projectiles[shot_i]

func on_hit(_body_rid: RID, _body: Node, _body_shape_index: int, _local_shape_index: int):
	call_deferred("spawn_trigger", _body)
