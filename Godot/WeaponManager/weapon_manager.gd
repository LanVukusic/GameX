extends Node2D
class_name weapon_manager

signal weapon_changed

var weapon_scenes: Array[PackedScene] = []   # Empty array, to be filled with weapon scenes at runtime
var current_weapon_index: int = 0            # Tracks the current weapon index
var current_weapon: Weapon = null            # Reference to the current weapon instance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Check if weapons are initialized and initialize the first weapon
	if weapon_scenes.size() > 0:
		switch_weapon(0)

# Method to dynamically add a weapon scene to the manager
func add_weapon_scene(weapon_scene: PackedScene) -> void:
	weapon_scenes.append(weapon_scene)
	if weapon_scenes.size() == 1:
		switch_weapon(0)  # Automatically initialize the first weapon if this is the first entry

# Method to switch to the next weapon in the list
func switch_weapon(next_index: int = -1):
	# Ensure we have weapons to switch between
	if weapon_scenes.size() == 0:
		print("No weapons available to switch.")
		return

	# Calculate the next weapon index in a circular fashion if no specific index is provided
	if next_index == -1:
		current_weapon_index = (current_weapon_index + 1) % weapon_scenes.size()
	else:
		current_weapon_index = next_index % weapon_scenes.size()

	# Remove the current weapon if it exists
	if current_weapon:
		remove_child(current_weapon)
		current_weapon.queue_free()  # Free the weapon instance

	# Instantiate the new weapon and add it to the WeaponManager node
	var new_weapon_scene = weapon_scenes[current_weapon_index]
	current_weapon = new_weapon_scene.instantiate() as Weapon
	add_child(current_weapon)
	

func _on_wepon_switch_pressed():

# Optional: Switch weapon on a key press (or call this function from other code to switch)
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("WeaponSwitch"):
		pass  # Custom input action, e.g., "switch_weapon"
