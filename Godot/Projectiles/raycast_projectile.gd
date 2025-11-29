extends Node2D
class_name RaycastProjectile

# --- Variables ---
var velocity: Vector2 = Vector2.ZERO
var hit_mask: int = 3
var max_lifetime: float = 3.0 
var attack_data: AttackComponent 

# --- DEBUG TOGGLE ---
@export var debug_draw: bool = true

# --- Visual Nodes ---
@onready var sprite = $Sprite2D
@onready var particles = $GPUParticles2D 

func setup(pos: Vector2, dir: Vector2, speed: float, _data: AttackComponent, _mask: int):
	if _data == null:
		attack_data = AttackComponent.new()
		attack_data.damage = 0
	else:
		attack_data = _data

	global_position = pos
	velocity = dir * speed
	hit_mask = _mask
	# Rotate the node to face direction of travel
	rotation = dir.angle()
	
	get_tree().create_timer(max_lifetime).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	# 1. DEBUG VISUALIZATION
	if debug_draw:
		queue_redraw()

	# 2. MOVEMENT LOGIC
	var current_pos = global_position
	var next_pos = current_pos + (velocity * delta)
	
	var hit_result = _perform_raycast(current_pos, next_pos)
	
	if hit_result:
		global_position = hit_result.position
		_handle_impact(hit_result)
		set_physics_process(false)
		_destroy_bullet()
	else:
		global_position = next_pos

# --- THE DRAWING FUNCTION (FIXED) ---
func _draw() -> void:
	if debug_draw:
		# FIX: We draw in LOCAL space. 
		# Since the node is already rotated to face the direction of travel, 
		# "Forward" is always just Vector2.RIGHT relative to the sprite.
		
		# 1. Calculate scalar distance traveled this frame (Speed * Delta)
		var distance_this_frame = velocity.length() * get_physics_process_delta_time()
		
		# 2. Draw a line straight forward along the local X axis
		var step_vector = Vector2.RIGHT * distance_this_frame
		
		# Draw a thick Red Line
		draw_line(Vector2.ZERO, step_vector, Color.RED, 5.0)

func _perform_raycast(start: Vector2, end: Vector2) -> Dictionary:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(start, end)
	
	query.collision_mask = hit_mask 
	query.collide_with_areas = true 
	query.collide_with_bodies = true
	
	if owner: 
		query.exclude = [self, owner] 
		
	return space_state.intersect_ray(query)

func _handle_impact(result: Dictionary):
	var collider = result.collider
	if collider is HurtboxComponent:
		print("SUCCESS:Delivered payload to", collider.owner.name)
		# --- NEW TYPE-SAFE WAY ---
		# Look how clean this is! 
		# You pass the arguments in the order defined in HitInfo._init
		var hit = HitInfo.new(
			attack_data.damage,
			attack_data.knockback_force,
			velocity.normalized(),      # The dynamic direction
			attack_data.stun_time,
			owner                       # The source player
		)
		
		collider.relay_damage(hit)
		

func _destroy_bullet():
	if particles:
		particles.emitting = false
		sprite.visible = false
		await get_tree().create_timer(1.0).timeout 
	
	queue_free()
