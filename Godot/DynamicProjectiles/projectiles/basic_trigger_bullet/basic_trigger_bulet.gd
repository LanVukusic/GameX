extends BaseProjectile
class_name BasicTriggerBulletProjectile

# @export var trigger_projectile: PackedScene
@export var spread_angle: float
var rng = RandomNumberGenerator.new()
var trig: BaseProjectile = null

func bullet_setup():
	var trig_scn = self.active_stack.pop_front()
	if (trig_scn != null):
		trig = trig_scn.instantiate().with_data(active_stack)
	else:
		# print("no active stack found")
		pass

func projectile_spawned():
	pass

func spawn_trigger(body: Node):
	if (trig == null):
		self.queue_free()
		return
	trig.position = self.position

	var magnitude = self.linear_velocity.length()
	var rand_angle = rng.randf_range(-spread_angle / 2, spread_angle / 2) + self.linear_velocity.angle()
	var rand_vec = Vector2.from_angle(rand_angle).normalized()

	
	trig.linear_velocity = rand_vec * magnitude
	trig.add_collision_exception_with(body)
	get_tree().root.add_child(trig)
	self.queue_free()
	return trig

func on_hit(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int):
	call_deferred("spawn_trigger", body)
