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
var current_weapon_state: weapon_state = weapon_state.READY
var reload_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# print(bullet_transform.position - bullet_transform.target_position)
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Shoot"):
		fire()
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
	b.position = bullet_transform.position
	# b.add_constant_central_force(to_global(bullet_transform.position - bullet_transform.target_position))
	owner.add_child(b)
	# print("fire, ", ammo)

func reload():
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
	reload()
