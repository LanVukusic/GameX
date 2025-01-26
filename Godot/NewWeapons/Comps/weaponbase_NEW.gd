extends Node2D
class_name WeaponBase

# Exported variables for the weapon's components
@export var barrel:BarrelComponent
@export var magazine: MagazineComponent

# Boolean variables for input handling and firing cooldown
var is_shoot_pressed: bool = false # Tracks whether the shoot button is being pressed
var can_shoot: bool = true # Tracks whether the weapon can fire

# Weapon configuration variables
@export var fire_rate: float # Time (in seconds) between shots
@export var fire_cooldown: Timer # Timer node to manage fire rate cooldown

func _ready() -> void:
	fire_cooldown.timeout.connect(_on_fire_timer_timeout)

# Main game loop for physics calculations
func _physics_process(_delta: float) -> void:
	# Check if the shoot button is pressed and attempt to fire
	if is_shoot_pressed:
		fire()

# Callback triggered when the fire cooldown timer ends
func _on_fire_timer_timeout():
	can_shoot = true

# Called when the shoot button is pressed
func on_shoot_active() -> void:
	is_shoot_pressed = true

# Called when the shoot button is released
func on_shoot_release() -> void:
	is_shoot_pressed = false

# Handles firing logic
func fire() -> void:
	if can_shoot:
		# Spawn a bullet from the barrel and update cooldown state
		barrel.spawn_bullet(magazine.get_projectile())
		can_shoot = false
		fire_cooldown.start(fire_rate)
