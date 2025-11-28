extends Node2D
class_name WeaponBase

# --- Configuration ---
# CHANGE 1: No longer an @export. It starts empty until Manager injects it.
var weapon_stats: WeaponItem 

@export_flags_2d_physics var hit_mask: int = 0 

# --- Components ---
@export_group("Components")
@export var barrel: BarrelComponent
@export var magazine: MagazineComponent 
@export var fire_rate_timer: Timer

# --- State ---
var is_trigger_held: bool = false
var can_shoot: bool = true

func _ready() -> void:
	# We only do STATIC setup here (connecting signals).
	# We do NOT set values yet, because weapon_stats is null right now.
	if fire_rate_timer:
		fire_rate_timer.one_shot = true
		if not fire_rate_timer.timeout.is_connected(_on_fire_rate_timeout):
			fire_rate_timer.timeout.connect(_on_fire_rate_timeout)

# --- NEW FUNCTION: The "Injection" ---
# This is called by WeaponManager immediately after instantiating the scene.
func setup(stats: WeaponItem) -> void:
	# 1. Store the Resource
	weapon_stats = stats
	
	# 2. Apply Stats to Components
	if fire_rate_timer:
		fire_rate_timer.wait_time = weapon_stats.fire_rate
	
	if magazine:
		# If you added max_ammo to your WeaponItem resource:
		# magazine.capacity = weapon_stats.max_ammo 
		
		# Reset ammo now that we know the capacity
		magazine.call_deferred("_initialize_ammo")

# --- Input Methods ---

func start_shooting() -> void:
	is_trigger_held = true
	if can_shoot:
		_attempt_fire()

func stop_shooting() -> void:
	is_trigger_held = false

# --- Internal Logic ---

func _attempt_fire() -> void:
	# Safety Check: If setup() wasn't called, stop here.
	if not weapon_stats:
		print("Error: Attempted to fire " + name + " before setup()!")
		return

	# 1. AMMO CHECK
	if magazine and not magazine.has_ammo():
		# Optional: Auto-reload if empty
		if magazine.current_ammo == 0 and magazine.current_mags > 0:
			magazine.start_reload()
		else:
			_play_dry_fire_sound()
		return

	# 2. FIRE!
	_fire()

func _fire() -> void:
	can_shoot = false 
	
	# A. Consume Ammo
	if magazine:
		magazine.consume()
	
	# B. Spawn Bullets
	# Now using the injected weapon_stats variable
	barrel.spawn_bullet(
		weapon_stats,
		weapon_stats.attack_data,
		hit_mask
	)
	
	# C. Start Cooldown
	if fire_rate_timer:
		fire_rate_timer.start()

func _on_fire_rate_timeout() -> void:
	can_shoot = true
	if is_trigger_held:
		_attempt_fire()

func _play_dry_fire_sound():
	print("Click! (No Ammo)")

# Helper to set the team (Player vs Enemy)
func setup_team(new_hit_mask: int):
	hit_mask = new_hit_mask
