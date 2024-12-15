extends Node2D
class_name PlayerDevNode

var player: Player

@export_category("THIS IS AN OVERRIDE FOR NETWORKED CONTROLLS")
@export var player_name: String
@export var color: Color
@export var uIManager: UIManager

func _ready() -> void:
	player = get_parent()
	uIManager.init_UIPlayerNode(player, 0)
	player.joined.emit(color, player_name)
	player.weapon_manager.update_ui()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	# looking
	var look_dir = get_global_mouse_position() - global_position
	player.lookVec.emit(look_dir)

	# movement
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	player.moveVec.emit(input_dir)

# button events
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Shoot"):
		player.weapon_manager.current_weapon.shoot_pressed.emit()

	if event.is_action_released("Shoot"):
		player.weapon_manager.current_weapon.shoot_released.emit()
	

	if event.is_action_pressed("Reload"):
		player.weapon_manager.current_weapon.reload_active.emit()

	if event.is_action_pressed("Lamp"):
		player.lamp.emit()
	
	if event.is_action_pressed("WeaponSwitch"):
		player.weapon_manager.switch_weapons_pressed.emit()
	

# only allow to be a parent of th player
func _get_configuration_warnings() -> PackedStringArray:
	var handler = get_parent()
	if handler.name != "Player":
		return ["Need to be attached to a player"]
	
	return []
