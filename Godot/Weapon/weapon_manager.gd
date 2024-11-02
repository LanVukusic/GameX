@tool
extends Node2D

#signal Weapon_Changed
#signal Weapon_stack
#signal Update_weapon_stack

@export var current_bullet: PackedScene
@export var current_weapon: WeaponResource
@export var bullet_transform: RayCast2D

#var weapon_stack = []
#var weapon_indicator = 0
var ammo: int
enum weapon_state {READY, RELOADING}
var current_weapon_state: weapon_state
var reload_timer: Timer
var bpm_timer: float = 0.0
var is_firing = false
var can_shoot = true



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
 # **Increment bpm_timer every frame**
	bpm_timer += delta

	# **Automatic firing**: Fire at intervals if the button is held
	if is_firing and current_weapon.is_automatic and bpm_timer >= current_weapon.fire_rate:
		fire()
		bpm_timer = 0.0  # Reset timer for the next interval

	# **Reset can_shoot after cooldown** for both automatic and semi-automatic modes
	if bpm_timer >= current_weapon.fire_rate:
		can_shoot = true  # Allow new shot when cooldown is complete
		bpm_timer = 0.0  # Reset timer
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Shoot") and can_shoot:
		is_firing = true
		fire()  # Fire immediately on press for automatic weapons
		can_shoot = false  # Set cooldown
		bpm_timer = 0.0  # Reset timer for consistent interval

	if event.is_action_released("Shoot"):
		is_firing = false

	if event.is_action_pressed("Reload"):
		reload()



func fire():
	if current_weapon_state == weapon_state.RELOADING:
		print("cant do dat sir you are reloading ", reload_timer.time_left)
		return
	
	if ammo <= 0:
		print("out of ammo")
		return
	
	ammo -= 1
	var b = current_bullet.instantiate() as Projectile
	b.global_position = bullet_transform.global_position
	b.rotation = global_rotation + bullet_transform.target_position.angle()
	get_tree().get_root().add_child(b)

func reload():
	if current_weapon_state == weapon_state.RELOADING:
		print("you are already reloading bozo")
		return
		
	current_weapon_state = weapon_state.RELOADING
	reload_timer = Timer.new()
	add_child(reload_timer)
	reload_timer.one_shot = true
	reload_timer.start(current_weapon.reload_time)
	reload_timer.timeout.connect(func():
			ammo = current_weapon.total_ammo_capacity
			current_weapon_state = weapon_state.READY
			print("delam")
			)
	print("hihi")


func _init_weapon():
	$Sprite2D.texture = current_weapon.texture
	current_weapon_state = weapon_state.READY
	reload()
