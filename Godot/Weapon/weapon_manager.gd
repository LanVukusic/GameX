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
enum weapon_state{READY, RELOADING}
var current_weapon_state: weapon_state = weapon_state.READY
var reload_timer: Timer
var bpm_timer: Timer
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_weapon()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Shoot"):
		if current_weapon.is_automatic == true:
			bpm_timer.start()
		else:
			fire()
	if event.is_action_released("Shoot"):
		bpm_timer.stop()

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
	var b = current_bullet.instantiate()
	b.global_position = bullet_transform.global_position
	owner.add_child(b)
	print("fire, ",ammo )

func reload():
	if current_weapon_state == weapon_state.RELOADING:
		print("you are already reloading dipshit")
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
	print("delam2")

func bpm_time(value):
	bpm_timer = Timer.new()
	add_child(bpm_timer)
	bpm_timer.one_shot = false
	bpm_timer.paused = false
	bpm_timer.wait_time = value
	bpm_timer.timeout.connect(fire)

func _init_weapon():
	bpm_time(current_weapon.fire_rate)
	$Sprite2D.texture = current_weapon.texture
	reload()
	
