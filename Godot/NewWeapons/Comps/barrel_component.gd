# BarrelComponent.gd
extends Node2D
class_name BarrelComponent

@export var muzzle: Marker2D

func spawn_bullet(weapon_stats: WeaponItem, attack_data: AttackComponent, collision_mask: int):
	if weapon_stats.projectile_scene == null:
		print("Error: No projectile scene in WeaponItem resource!")
		return

	# FIX: Use the MUZZLE'S global rotation, not the Barrel's local rotation
	var origin_rot = muzzle.global_rotation

	for i in range(weapon_stats.projectiles_per_shot):
		var bullet = weapon_stats.projectile_scene.instantiate() as RaycastProjectile
		get_tree().root.add_child(bullet)
		
		# Calculate Spread
		var spread_deg = randf_range(-weapon_stats.spread_angle / 2.0, weapon_stats.spread_angle / 2.0)
		
		# FIX: Create vector starting from the Muzzle's actual facing direction
		var final_direction = Vector2.RIGHT.rotated(origin_rot + deg_to_rad(spread_deg))
		
		bullet.setup(
			muzzle.global_position,
			final_direction,
			weapon_stats.projectile_speed, # You can move this to WeaponItem later if you want speed control
			attack_data,
			collision_mask
		)
