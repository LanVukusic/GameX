@tool

extends Node2D
class_name Weapon

@export var avaliable_weapons_resouces: Array[WeaponResource]


signal shoot_active
signal shoot_release
signal reload_active
signal switch_weapon


@export var WEAPON : WeaponResource:
	set(value):
		WEAPON = value
		if Engine.is_editor_hint():
			load_weapon()

@export var current_bullet: PackedScene
@onready var sprite: Sprite2D = %WeaponSprite
@onready var raycast: RayCast2D = %BulletTransform


var ammo: int
enum weapon_state {READY, RELOADING}
var current_weapon_state: weapon_state
var reload_timer: Timer
var bpm_timer: float = 0.0
var is_firing = false
var can_shoot = true


func _ready() -> void:
	load_weapon()
	reload_active.connect(reload)
	shoot_active.connect(_shot_active)
	shoot_release.connect(_shot_released)
	

func _process(delta: float) -> void:
	 # **Increment bpm_timer every frame**
	bpm_timer += delta

	# **Automatic firing**: Fire at intervals if the button is held
	if is_firing and WEAPON.is_automatic and bpm_timer >= WEAPON.fire_rate:
		fire()
		bpm_timer = 0.0 # Reset timer for the next interval

	# **Reset can_shoot after cooldown** for both automatic and semi-automatic modes
	if bpm_timer >= WEAPON.fire_rate:
		can_shoot = true # Allow new shot when cooldown is complete
		bpm_timer = 0.0 # Reset timer


func _shot_active():
	if (!can_shoot):
		return
	is_firing = true
	fire() # Fire immediately on press for automatic weapons
	can_shoot = false # Set cooldown
	bpm_timer = 0.0 # Reset timer for consistent interval


func _shot_released():
	is_firing = false


func fire():
	if current_weapon_state == weapon_state.RELOADING:
		print("cant do dat sir you are reloading ", reload_timer.time_left)
		return
	
	if ammo <= 0:
		print("out of ammo")
		return
	
	ammo -= 1
	var b = current_bullet.instantiate() as Projectile
	b.global_position = raycast.global_position
	b.rotation = global_rotation + raycast.target_position.angle()
	get_tree().get_root().add_child(b)
	print(ammo)


func reload():
	if current_weapon_state == weapon_state.RELOADING:
		print("you are already reloading bozo")
		return
		
	current_weapon_state = weapon_state.RELOADING
	reload_timer = Timer.new()
	add_child(reload_timer)
	reload_timer.one_shot = true
	reload_timer.start(WEAPON.reload_time)
	reload_timer.timeout.connect(func():
			ammo = WEAPON.total_ammo_capacity
			current_weapon_state = weapon_state.READY
			print("delam")
			)


func load_weapon() -> void:
	sprite.texture = WEAPON.sprite_texture
	sprite.position = WEAPON.sprite_pos
	sprite.scale = WEAPON.sprite_scale
	raycast.target_position = WEAPON.raycast_target_pos
	raycast.position = WEAPON.raycast_pos


func switch_weapon_resource():
	WEAPON = avaliable_weapons_resouces
