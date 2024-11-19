@tool
extends Node2D
class_name Weapon

signal shoot
signal reload_active
signal current_ammo
signal mags_left


@export var WEAPON: WeaponResource:
	set(value):
		WEAPON = value
		load_weapon()

@export var current_bullet: PackedScene
var sprite: Sprite2D
var raycast: RayCast2D

enum weapon_state { READY, RELOADING }
var current_weapon_state: weapon_state = weapon_state.READY

var can_shoot: bool = true
var reload_timer: Timer
var fire_timer: Timer

func _init() -> void:
	# Initialize sprite and raycast nodes
	sprite = Sprite2D.new()
	self.add_child(sprite)
	raycast = RayCast2D.new()
	self.add_child(raycast)


func _ready() -> void:
	load_weapon()
	# Connect signals
	reload_active.connect(reload)
	#shoot_active.connect(_shot_active)
	#shoot_release.connect(_shot_released)
	
	#intialise fire_timer
	fire_timer = Timer.new()
	fire_timer.one_shot = true
	fire_timer.timeout.connect(_on_fire_timer_timeout)
	add_child(fire_timer)
	
	#initialise reload_timer
	reload_timer = Timer.new()
	reload_timer.one_shot = true
	add_child(reload_timer)

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Shoot") and WEAPON.is_automatic == false:
		fire()
		can_shoot = false

	if  Input.is_action_pressed("Shoot") and WEAPON.is_automatic:
		fire()


func _on_fire_timer_timeout():
	can_shoot = true


func fire():
	if can_shoot:
		# Decrement ammo and instantiate the bullet
		if WEAPON.current_mag_ammo <= 0:
			print("Out of ammo.")
			return

		var bullet = current_bullet.instantiate() as Projectile
		bullet.global_position = raycast.global_position
		bullet.rotation = global_rotation + raycast.target_position.angle()
		get_tree().get_root().add_child(bullet)
		
		can_shoot = false
		fire_timer.start(WEAPON.fire_rate)
		WEAPON.current_mag_ammo -= 1
		print("Ammo left:", WEAPON.current_mag_ammo)
		emit_signal("current_ammo")

func reload():
	if current_weapon_state == weapon_state.RELOADING:
		print("Already reloading.")
		return

	if WEAPON.current_mags == 0:
		print("No more magazines.")
		return

	current_weapon_state = weapon_state.RELOADING
	reload_timer.start(WEAPON.reload_time)
	reload_timer.timeout.connect(_on_reload_timeout)
	print("Reloading...")

func _on_reload_timeout():
	WEAPON.current_mags -= 1
	WEAPON.current_mag_ammo = WEAPON.magazine_capacity
	current_weapon_state = weapon_state.READY
	print("Reload complete. Magazines left:", WEAPON.current_mags)

func load_weapon() -> void:
# Configure the sprite and raycast based on the weapon resource
	sprite.texture = WEAPON.sprite_texture
	sprite.position = WEAPON.sprite_pos
	sprite.scale = WEAPON.sprite_scale
	sprite.rotation = WEAPON.sprite_rotation
	raycast.position = WEAPON.raycast_pos
	raycast.target_position = WEAPON.raycast_target_pos
