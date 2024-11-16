extends BaseProjectile
class_name BasicBulletProjectile

func projectile_spawned():
	pass

func on_hit(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int):
	queue_free()
	pass