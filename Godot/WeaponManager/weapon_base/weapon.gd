extends Node2D
class_name Weapon

signal shoot_pressed
signal shoot_released
signal reload_active


@export var WEAPON: WeaponResource

@export var current_bullet: PackedScene
var sprite: Sprite2D
@onready var raycast:RayCast2D = $RayCast2D

enum weapon_state { READY, RELOADING }
var current_weapon_state: weapon_state = weapon_state.READY

var is_shoot_pressed: bool = false
var can_shoot: bool = true
var reload_timer: Timer
var fire_timer: Timer

func _ready() -> void:
	# Connect signals
	reload_active.connect(reload)
	shoot_pressed.connect(on_shoot_active)
	shoot_released.connect(on_shoot_relase)
	
	#intialise fire_timer
	fire_timer = Timer.new()
	fire_timer.name = "FireTimer"
	fire_timer.one_shot = true
	fire_timer.timeout.connect(_on_fire_timer_timeout)
	add_child(fire_timer)
	
	#initialise reload_timer
	reload_timer = Timer.new()
	reload_timer.name = "ReloadTimer"
	reload_timer.one_shot = true
	reload_timer.timeout.connect(_on_reload_timeout)
	add_child(reload_timer)
	
	WEAPON.init_weapon_values()
	
func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	if  is_shoot_pressed and WEAPON.is_automatic:
		fire()


func _on_fire_timer_timeout():
	can_shoot = true


#inputs
func on_shoot_active() -> void:
	fire()
	is_shoot_pressed = true

func on_shoot_relase() -> void:
	is_shoot_pressed = false

func fire():
	if can_shoot and current_weapon_state == weapon_state.READY:
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

func reload():
	if current_weapon_state == weapon_state.RELOADING:
		print("Already reloading.")
		return

	if WEAPON.current_mags == 0:
		print("No more magazines.")
		return

	current_weapon_state = weapon_state.RELOADING
	reload_timer.start(WEAPON.reload_time)
	print("Reloading...")

func _on_reload_timeout():
	WEAPON.current_mags -= 1
	WEAPON.current_mag_ammo = WEAPON.magazine_capacity
	current_weapon_state = weapon_state.READY
	print("Reload complete. Magazines left:", WEAPON.current_mags)
