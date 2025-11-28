extends Node2D
class_name PlayerDevNode

var player: Player

@export_category("THIS IS AN OVERRIDE FOR NETWORKED CONTROLLS")
@export var disable_controlls: bool = false

@export var player_name: String
@export var color: Color
@export var uIManager: UIManager
@export var peerId:int

func _ready() -> void:
	player = get_parent()
	uIManager.init_UIPlayerNode(player, peerId)
	player.joined.emit(color, player_name)
	print(player.name)
	print(color, player_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if disable_controlls:
		return
	# looking
	var look_dir = get_global_mouse_position() - global_position
	
	if player.look_input_component == null:
		print("look_input_component is null!")
	else:
		player.look_input_component.handle_look_direction(look_dir)


	# movement
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	player.move_input_component.handle_input(input_dir)

# button events
# button events
func _input(event: InputEvent) -> void:
	if disable_controlls:
		return
		
	# 1. SHOOTING (Updated names)
	# Changed 'on_shoot_active' -> 'start_shooting'
	if event.is_action_pressed("Shoot") and player.weapon_manager.current_weapon:
		player.weapon_manager.current_weapon.start_shooting()

	# Changed 'on_shoot_release' -> 'stop_shooting'
	if event.is_action_released("Shoot") and player.weapon_manager.current_weapon:
		player.weapon_manager.current_weapon.stop_shooting()
	
	# 2. RELOADING (Added Safety Check)
	if event.is_action_pressed("Reload") and player.weapon_manager.current_weapon:
		# CRASH FIX: We must check if the weapon actually HAS a magazine before reloading!
		var weapon = player.weapon_manager.current_weapon
		if weapon.magazine != null:
			weapon.magazine.reload()
		else:
			print("This weapon cannot be reloaded.")

	# 3. UTILITY
	if event.is_action_pressed("Lamp"):
		player.toggle_lamp()
	
	if event.is_action_pressed("WeaponSwitch"):
		# This is fine, provided your WeaponManager signal is connected.
		player.weapon_manager.switch_weapons_pressed.emit()
	

# only allow to be a parent of th player
func _get_configuration_warnings() -> PackedStringArray:
	var handler = get_parent()
	if !handler is Player:
		return ["Need to be attached to a player"]
	
	return []
