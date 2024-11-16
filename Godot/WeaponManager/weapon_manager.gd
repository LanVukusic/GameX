extends Node2D
class_name WeaponManager

@export var current_bullet: PackedScene
@export var available_weapon_resources: Array[WeaponResource]  # Use consistent naming
var weapon_stack: Array[Weapon] = []  # To hold instantiated Weapon nodes
@export var current_weapon: Weapon = null

func _ready() -> void:
	# Initialize weapons from available resources
	for resource in available_weapon_resources:
		add_weapon(resource)
	switch_weapon()


func add_weapon(weapon_resource: WeaponResource):
	# Create a new Weapon instance and initialize it with the provided resource
	var weapon = Weapon.new()
	weapon.WEAPON = weapon_resource  # Setter for the WeaponResource
	weapon.current_bullet = current_bullet
	weapon.name = weapon.WEAPON.name
	# Add the weapon as a child and to the weapon stack
	weapon_stack.append(weapon)

func switch_weapon():
	if weapon_stack.size() == 0:
		print("No weapons available to switch.")
		return


	# Find the next weapon index in a circular fashion
	var current_index = weapon_stack.find(current_weapon)
	var next_index = (current_index + 1) % weapon_stack.size()

	# Only keep the current weapon visible
	for gun in weapon_stack:
		print("brisem ", gun,gun.get_parent())
		if(gun.get_parent() != null):
			remove_child(gun)

	# Switch visibility and set the new weapon
	current_weapon = weapon_stack[next_index]
	add_child(current_weapon)

#	print("Switched to weapon:", current_weapon.name)

func _input(event: InputEvent) -> void:
	# Listen for input to switch weapons
	if event.is_action_pressed("WeaponSwitch"):
		switch_weapon()
	if event.is_action_pressed("CheckTree"):
		print_tree()
